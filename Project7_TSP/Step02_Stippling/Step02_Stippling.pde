/* ===========================================================
   STEP 2 — STIPPLING
   ===========================================================

   Stippling is drawing a picture with lots of dots: dots
   packed close together look dark, and dots spread far apart
   look light. This sketch stipples a picture using weighted
   Voronoi stippling, a method published by Adrian Secord in
   2002. Craig Kaplan and Robert Bosch used it in 2005 to
   place the cities for TSP art, because it spaces the dots
   out evenly while still matching the picture's darks and
   lights.

   It starts by scattering dots at random, more of them where
   the picture is dark. Then, round after round:

     1. Each dot claims the part of the picture that is closer
        to it than to any other dot. These parts are called
        Voronoi regions, after Georgy Voronoi, 1908.

     2. Each dot moves to the center of mass of its region,
        where dark spots weigh more than light ones. So dots
        get pulled toward the darks, and pushed apart by their
        neighbors.

   Moving dots to the center of their regions over and over
   is called Lloyd's algorithm, after Stuart Lloyd, 1957.
   After a few dozen rounds, the dots settle into an even,
   natural-looking pattern.

   The picture is smiley.png, in this sketch's data folder.
   The folder also has epitrochoid.png, a looping curve
   like the ones from Project 2, drawn with a thick line, and
   wave.png, The Great Wave off Kanagawa, a woodblock print
   by Katsushika Hokusai from about 1831.
   To use your own, put a picture in the data folder and
   change pictureFile. Pictures with strong darks and lights
   work best.

   The picture is made as big as fits inside the margins.

   Press PLAY and watch the dots settle. The round number is
   shown at the bottom. When the last round is done, the
   picture is saved as picture.pdf.

   THE VALUES YOU CAN CHANGE

     pictureFile       the picture to stipple
     numberOfDots      how many dots. More shows more detail
                       but each round takes longer
     contrast          how much more the dark parts count
                       than the light parts. 1 is the picture
                       as it is. Bigger empties out the light
                       parts
     lightestGray      grays lighter than this, from 0 to
                       255, count as white and get no dots.
                       Kaplan and Bosch suggest this, since
                       even a faint gray pulls in a few dots
     numberOfRounds    how many times the dots move
     sampleStep        how many pixels apart the picture is
                       checked. 1 is the most exact but the
                       slowest
     paperColor        the color of the paper
     pointColor        the color of the dots
     dotSize           how big each dot is
     textColor         the color of the round number

   THE EQUATIONS

   How dark a spot of the picture is, from its red, green and
   blue, each from 0 to 255. Green looks brightest to our
   eyes and blue the darkest, so they count different
   amounts:

       gray = 0.299 * red + 0.587 * green + 0.114 * blue

   If gray is more than lightestGray, it becomes 255, which
   is white. Then:

       darkness = (1 - gray / 255) ^ contrast

   ^ means "to the power of". darkness goes from 0 (white)
   to 1 (black), and contrast pushes the in-between grays
   toward 0.

   The distance between a spot at x1, y1 and a dot at x2, y2:

       distance = sqrt((x2 - x1)^2 + (y2 - y1)^2)

   The center of mass of a dot's region, adding up over every
   spot x, y in the region:

       dotX = (sum of darkness * x) / (sum of darkness)
       dotY = (sum of darkness * y) / (sum of darkness)

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE DOTS ------------------------------------
String pictureFile = "smiley.png";
int numberOfDots = 4000;
float contrast = 2;
float lightestGray = 240;
int numberOfRounds = 50;
int sampleStep = 1;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color pointColor = color( 35,  35,  35);   // charcoal
float dotSize = 3;
color textColor = color(0, 0, 0);

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
PImage picture;

float[] dotX = new float[numberOfDots];
float[] dotY = new float[numberOfDots];

// the spots of the picture that are checked, where they are
// on the page, and how dark they are. White spots are left
// out, since they weigh nothing
float[] spotX;
float[] spotY;
float[] spotDarkness;
int numberOfSpots;

// To find the closest dot to a spot quickly, the page is cut
// into square cells, and each cell keeps a list of the dots
// in it. Then only the cells near the spot need checking
float cellSize;
int gridColumns;
int gridRows;
int[] cellStart;   // where each cell's list starts in cellDots
int[] cellDots;    // every cell's list of dot numbers, one
                   // after another

int roundsDone = 0;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
  smooth(8);
}

void setup() {
  picture = loadImage(pictureFile);

  // as big as fits inside the margins, without stretching,
  // leaving room for the dots at the edges
  float zoom = min((pageWidth - 2 * pageMargin - dotSize) / picture.width,
                   (pageHeight - 2 * pageMargin - dotSize) / picture.height);
  float pictureLeft = centerX - zoom * picture.width / 2;
  float pictureTop = centerY - zoom * picture.height / 2;

  // find how dark each spot is, keeping the ones that aren't
  // white
  picture.loadPixels();
  int spotsAcross = picture.width / sampleStep;
  int spotsDown = picture.height / sampleStep;
  spotX = new float[spotsAcross * spotsDown];
  spotY = new float[spotsAcross * spotsDown];
  spotDarkness = new float[spotsAcross * spotsDown];
  numberOfSpots = 0;
  for (int pixelY = 0; pixelY < spotsDown * sampleStep; pixelY += sampleStep) {
    for (int pixelX = 0; pixelX < spotsAcross * sampleStep; pixelX += sampleStep) {
      color spotColor = picture.pixels[pixelY * picture.width + pixelX];
      float red = red(spotColor);
      float green = green(spotColor);
      float blue = blue(spotColor);
      float gray = 0.299 * red + 0.587 * green + 0.114 * blue;
      if (gray > lightestGray) {
        gray = 255;
      }
      float darkness = pow(1 - gray / 255, contrast);
      if (darkness > 0) {
        spotX[numberOfSpots] = pictureLeft + zoom * (pixelX + 0.5);
        spotY[numberOfSpots] = pictureTop + zoom * (pixelY + 0.5);
        spotDarkness[numberOfSpots] = darkness;
        numberOfSpots++;
      }
    }
  }

  // scatter the dots: pick random spots, and keep each one
  // depending on how dark it is. Stop trying after a while,
  // in case the picture is all white
  int dotsPlaced = 0;
  for (int tryNumber = 0; tryNumber < 1000 * numberOfDots && dotsPlaced < numberOfDots; tryNumber++) {
    int spotNumber = int(random(numberOfSpots));
    if (random(1) < spotDarkness[spotNumber]) {
      dotX[dotsPlaced] = spotX[spotNumber];
      dotY[dotsPlaced] = spotY[spotNumber];
      dotsPlaced++;
    }
  }

  // cells about as big as the space each dot would have if
  // they were spread evenly over the picture
  cellSize = zoom * sqrt(picture.width * picture.height / (float) numberOfDots);
  gridColumns = ceil(pageWidth / cellSize);
  gridRows = ceil(pageHeight / cellSize);
  cellStart = new int[gridColumns * gridRows + 1];
  cellDots = new int[numberOfDots];
}

void draw() {
  boolean isLastRound = roundsDone == numberOfRounds;
  if (isLastRound) {
    beginRecord(PDF, "picture.pdf");
  }

  background(paperColor);
  noStroke();
  fill(pointColor);
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    circle(dotX[dotNumber], dotY[dotNumber], dotSize);
  }

  if (isLastRound) {
    endRecord();
    noLoop();
  } else {
    fill(textColor);
    textSize(12);
    text("Round " + (roundsDone + 1) + " of " + numberOfRounds, pageMargin, pageHeight - pageMargin);
    moveDots();
    roundsDone++;
  }
}

// One round: each dot moves to the center of mass of its
// Voronoi region
void moveDots() {
  sortDotsIntoCells();

  // add up each region's darkness, darkness * x, and
  // darkness * y, by giving each spot to its closest dot
  float[] sumOfDarkness = new float[numberOfDots];
  float[] sumOfDarknessX = new float[numberOfDots];
  float[] sumOfDarknessY = new float[numberOfDots];
  for (int spotNumber = 0; spotNumber < numberOfSpots; spotNumber++) {
    int closestDot = findClosestDot(spotX[spotNumber], spotY[spotNumber]);
    float darkness = spotDarkness[spotNumber];
    sumOfDarkness[closestDot] += darkness;
    sumOfDarknessX[closestDot] += darkness * spotX[spotNumber];
    sumOfDarknessY[closestDot] += darkness * spotY[spotNumber];
  }

  // move each dot to its center of mass. A dot whose region
  // weighs nothing stays where it is
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    if (sumOfDarkness[dotNumber] > 0) {
      dotX[dotNumber] = sumOfDarknessX[dotNumber] / sumOfDarkness[dotNumber];
      dotY[dotNumber] = sumOfDarknessY[dotNumber] / sumOfDarkness[dotNumber];
    }
  }
}

// The cell number that a spot on the page is in
int cellAt(float x, float y) {
  int column = constrain(int(x / cellSize), 0, gridColumns - 1);
  int row = constrain(int(y / cellSize), 0, gridRows - 1);
  return row * gridColumns + column;
}

// Fills in cellStart and cellDots: count the dots in each
// cell, work out where each cell's list starts, then put the
// dots in their lists
void sortDotsIntoCells() {
  int[] dotsInCell = new int[gridColumns * gridRows];
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    dotsInCell[cellAt(dotX[dotNumber], dotY[dotNumber])]++;
  }
  cellStart[0] = 0;
  for (int cellNumber = 0; cellNumber < gridColumns * gridRows; cellNumber++) {
    cellStart[cellNumber + 1] = cellStart[cellNumber] + dotsInCell[cellNumber];
  }
  int[] dotsListed = new int[gridColumns * gridRows];
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    int cellNumber = cellAt(dotX[dotNumber], dotY[dotNumber]);
    cellDots[cellStart[cellNumber] + dotsListed[cellNumber]] = dotNumber;
    dotsListed[cellNumber]++;
  }
}

// The dot closest to the spot x1, y1. It checks the spot's
// own cell, then the ring of cells around it, then the next
// ring out, and so on. A dot in ring number ring + 1 is at
// least ring * cellSize away, so once a dot closer than that
// is found, there is no need to look further.
//
// It compares distance squared, which is in the same order
// as distance, so sqrt isn't needed
int findClosestDot(float x1, float y1) {
  int spotColumn = constrain(int(x1 / cellSize), 0, gridColumns - 1);
  int spotRow = constrain(int(y1 / cellSize), 0, gridRows - 1);
  int closestDot = -1;
  float closestDistanceSquared = Float.MAX_VALUE;
  for (int ring = 0; ring < gridColumns + gridRows; ring++) {
    for (int row = spotRow - ring; row <= spotRow + ring; row++) {
      for (int column = spotColumn - ring; column <= spotColumn + ring; column++) {
        boolean isOnRing = abs(row - spotRow) == ring || abs(column - spotColumn) == ring;
        boolean isOnPage = row >= 0 && row < gridRows && column >= 0 && column < gridColumns;
        if (isOnRing && isOnPage) {
          int cellNumber = row * gridColumns + column;
          for (int listNumber = cellStart[cellNumber]; listNumber < cellStart[cellNumber + 1]; listNumber++) {
            int dotNumber = cellDots[listNumber];
            float x2 = dotX[dotNumber];
            float y2 = dotY[dotNumber];
            float distanceSquared = sq(x2 - x1) + sq(y2 - y1);
            if (distanceSquared < closestDistanceSquared) {
              closestDistanceSquared = distanceSquared;
              closestDot = dotNumber;
            }
          }
        }
      }
    }
    if (closestDot != -1 && closestDistanceSquared <= sq(ring * cellSize)) {
      break;
    }
  }
  return closestDot;
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     String pictureFile = "epitrochoid.png";   // a looping
                                               // curve

     String pictureFile = "wave.png";   // Hokusai's wave. Its
     float contrast = 3;                // paper is tan, so more
     int numberOfDots = 8000;           // contrast keeps the
     float dotSize = 2;                 // sky light

     int numberOfRounds = 0;     // just the random scatter,
                                 // to compare

     int numberOfDots = 1000;    // big, bold dots
     float dotSize = 5;

     int numberOfDots = 10000;   // fine detail. Each round
     float dotSize = 2;          // takes longer

     float contrast = 1;         // the yellow face fills in

     float contrast = 4;         // just the eyes and mouth

     float lightestGray = 200;   // the lightest part of the
                                 // face goes white

   =========================================================== */
