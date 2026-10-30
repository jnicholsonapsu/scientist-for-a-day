/* ===========================================================
   STEP 3 — TSP ART
   ===========================================================

   Step 2's dots become the cities of a Traveling Salesman
   Problem, and one trip through all of them draws the
   picture as a single line that never lifts off the paper.
   This idea is called TSP art. Craig Kaplan and Robert Bosch
   came up with it in 2005.

   With 4000 cities, Step 1's method is far too slow: pairing
   up the circled cities in the best way takes too long. Kaplan
   and Bosch point out that for TSP art, what matters most is
   that the trip takes small steps from each city to a nearby
   one, more than that it is the shortest possible. So this
   sketch uses three quick rules:

     1. Nearest neighbor: start at a city, and always go to
        the closest city not visited yet. When every city is
        visited, go back to the start. This makes a good trip
        fast, but it crosses itself in places and makes some
        long jumps near the end, when the only cities left
        are far apart.

     2. 2-opt, from G. A. Croes, 1958: look at every two roads
        in the trip, a to b and c to d. If going a to c and
        b to d instead is shorter, swap them, by turning
        around the part of the trip between b and c. Two roads
        that cross can always be swapped this way to make the
        trip shorter.

     3. Or-opt, from Ilhan Or, 1976: pick up a short run of
        1, 2 or 3 cities in a row, and try putting it between
        every other two cities next to each other in the trip,
        either way around. If the trip gets shorter, move it
        there. This fixes many of nearest neighbor's long
        jumps, by moving a city that got skipped to a spot
        near its neighbors.

   2-opt and Or-opt take turns. Each one keeps going while it
   makes the trip shorter, then the other gets a turn. When
   neither can make it any shorter, the trip is done. By
   then, 2-opt has checked the finished trip and found
   nothing to swap, so the line never crosses itself. They
   always finish, since every move makes the trip shorter
   and it can't get shorter forever, but on some pictures it
   can take a long time. So they also stop after maxPasses
   passes. Stopped early, the line may still cross itself.

   Kaplan and Bosch used a program called Concorde, which
   uses a stronger rule from Shen Lin and Brian Kernighan,
   1973.

   The picture is smiley.png, in this sketch's data folder.
   The folder also has epitrochoid.png, a looping curve
   like the ones from Project 2, drawn with a thick line, and
   wave.png, The Great Wave off Kanagawa, a woodblock print
   by Katsushika Hokusai from about 1831.
   To use your own, put a picture in the data folder and
   change pictureFile.

   Press PLAY. Step 2's stippling is done first, without
   showing the rounds, so the window stays blank for a few
   seconds. Then you see the nearest neighbor trip, and each
   frame after that is one pass of 2-opt or Or-opt over the
   whole trip, until neither helps or maxPasses is reached. The pass and the trip's
   length are shown at the bottom. When it is done, the
   picture is saved as picture.pdf.

   THE VALUES YOU CAN CHANGE

     pictureFile       the picture to draw
     numberOfDots      how many dots, which become the cities.
                       More shows more detail but takes longer
     contrast          how much more the dark parts count
                       than the light parts
     lightestGray      grays lighter than this, from 0 to
                       255, count as white and get no dots
     numberOfRounds    how many times the dots move
     sampleStep        how many pixels apart the picture is
                       checked
     longestRun        the most cities in a row Or-opt picks
                       up and moves at once
     maxPasses         the most passes of 2-opt and Or-opt to
                       make before stopping, even if they
                       could still make the trip shorter
     drawAsCurve       true draws a smooth curve through the
                       cities, as Kaplan and Bosch do. false
                       draws straight roads
     paperColor        the color of the paper
     lineColor         the color of the line
     lineThickness     how thick the line is
     textColor         the color of the words at the bottom

   THE EQUATIONS

   Step 2's equations place the dots. The distance between
   two cities, at x1, y1 and x2, y2:

       distance = sqrt((x2 - x1)^2 + (y2 - y1)^2)

   A 2-opt swap of the roads a to b and c to d is made if:

       distance(a, c) + distance(b, d) < distance(a, b) + distance(c, d)

   An Or-opt move takes a run, from first to last, out from
   between before and after, and puts it between a and b.
   Taking it out saves:

       saved = distance(before, first) + distance(last, after)
             - distance(before, after)

   Putting it in adds:

       added = distance(a, first) + distance(last, b)
             - distance(a, b)

   or, with the run the other way around:

       added = distance(a, last) + distance(first, b)
             - distance(a, b)

   The move is made if added is less than saved.

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

// ---------- THE TRIP ------------------------------------
int longestRun = 3;
int maxPasses = 50;
boolean drawAsCurve = false;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color( 60,  20,  90);   // dark violet
float lineThickness = 1;
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

int[] trip = new int[numberOfDots];   // the dot numbers, in the
                                      // order visited
int passesDone = 0;
boolean isUsingOrOpt = false;   // false while 2-opt has its turn
int passesWithoutChange = 0;
String lastPass = "Nearest neighbor";
boolean isFinished = false;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
  smooth(8);
}

void setup() {
  picture = loadImage(pictureFile);

  // as big as fits inside the margins, without stretching,
  // leaving room for the line at the edges
  float zoom = min((pageWidth - 2 * pageMargin - lineThickness) / picture.width,
                   (pageHeight - 2 * pageMargin - lineThickness) / picture.height);
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

  // Step 2's stippling, all at once
  for (int roundNumber = 0; roundNumber < numberOfRounds; roundNumber++) {
    moveDots();
  }

  makeNearestNeighborTrip();
}

void draw() {
  if (isFinished) {
    beginRecord(PDF, "picture.pdf");
  }

  background(paperColor);

  // the trip, closed into a loop to get back to the start
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);
  beginShape();
  if (drawAsCurve) {
    // a curve needs one extra point before the start and two
    // after the end to close smoothly
    curveVertex(dotX[trip[numberOfDots - 1]], dotY[trip[numberOfDots - 1]]);
    for (int stop = 0; stop < numberOfDots; stop++) {
      curveVertex(dotX[trip[stop]], dotY[trip[stop]]);
    }
    curveVertex(dotX[trip[0]], dotY[trip[0]]);
    curveVertex(dotX[trip[1]], dotY[trip[1]]);
    endShape();
  } else {
    for (int stop = 0; stop < numberOfDots; stop++) {
      vertex(dotX[trip[stop]], dotY[trip[stop]]);
    }
    endShape(CLOSE);
  }

  if (isFinished) {
    endRecord();
    noLoop();
    println("Done after " + passesDone + " passes of 2-opt and Or-opt. The trip is "
            + round(tripLength()) + " pixels long");
  } else {
    fill(textColor);
    textSize(12);
    text(lastPass + ": the trip is " + round(tripLength()) + " pixels long",
         pageMargin, pageHeight - pageMargin);

    // 2-opt and Or-opt take turns. Each keeps going while it
    // makes the trip shorter. When one can't, the other gets a
    // turn. When neither can, one right after the other, the
    // trip is done
    boolean isShorter;
    passesDone++;
    if (isUsingOrOpt) {
      isShorter = orOptPass();
      lastPass = "Or-opt, pass " + passesDone;
    } else {
      isShorter = twoOptPass();
      lastPass = "2-opt, pass " + passesDone;
    }
    if (isShorter) {
      passesWithoutChange = 0;
    } else {
      passesWithoutChange++;
      isUsingOrOpt = !isUsingOrOpt;
    }
    if (passesWithoutChange == 2 || passesDone == maxPasses) {
      isFinished = true;
    }
  }
}

// Nearest neighbor: start at dot 0, then keep going to the
// closest dot not visited yet
void makeNearestNeighborTrip() {
  boolean[] isVisited = new boolean[numberOfDots];
  trip[0] = 0;
  isVisited[0] = true;
  for (int stop = 1; stop < numberOfDots; stop++) {
    int here = trip[stop - 1];
    int closestDot = -1;
    float closestDistance = Float.MAX_VALUE;
    for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
      if (!isVisited[dotNumber]) {
        float distance = distanceBetween(here, dotNumber);
        if (distance < closestDistance) {
          closestDistance = distance;
          closestDot = dotNumber;
        }
      }
    }
    trip[stop] = closestDot;
    isVisited[closestDot] = true;
  }
}

// One pass of 2-opt: tries every two roads in the trip, and
// swaps them if that makes the trip shorter. Returns true if
// any swap was made
boolean twoOptPass() {
  boolean isShorter = false;
  for (int first = 0; first < numberOfDots - 2; first++) {
    for (int second = first + 2; second < numberOfDots; second++) {
      // the roads a to b and c to d. When first is 0 and second
      // is the last stop, c to d ends at a, touching a to b,
      // so there is nothing to swap
      if (first == 0 && second == numberOfDots - 1) {
        continue;
      }
      int a = trip[first];
      int b = trip[first + 1];
      int c = trip[second];
      int d = trip[(second + 1) % numberOfDots];
      if (distanceBetween(a, c) + distanceBetween(b, d)
          < distanceBetween(a, b) + distanceBetween(c, d) - 0.001) {
        turnAround(first + 1, second);
        isShorter = true;
      }
    }
  }
  return isShorter;
}

// Turns around the part of the trip from stop start to stop
// end, so it is visited in the opposite order
void turnAround(int start, int end) {
  while (start < end) {
    int saved = trip[start];
    trip[start] = trip[end];
    trip[end] = saved;
    start++;
    end--;
  }
}

// One pass of Or-opt: tries picking up every run of 1, 2 and 3
// cities in a row, and moving it between two other cities
// next to each other in the trip, a and b. The run can go in
// either way around. It moves if that makes the trip shorter.
// Returns true if any run was moved
boolean orOptPass() {
  boolean isShorter = false;
  for (int runLength = 1; runLength <= longestRun; runLength++) {
    for (int start = 0; start < numberOfDots; start++) {
      // the run goes from first to last. before and after are
      // the cities on each side of it
      int first = trip[start];
      int last = trip[(start + runLength - 1) % numberOfDots];
      int before = trip[(start - 1 + numberOfDots) % numberOfDots];
      int after = trip[(start + runLength) % numberOfDots];
      float savedByTakingOut = distanceBetween(before, first) + distanceBetween(last, after)
                             - distanceBetween(before, after);

      // the rest of the trip starts at after and ends at
      // before. Try putting the run between each two cities
      // next to each other in it
      int restLength = numberOfDots - runLength;
      for (int restStop = 0; restStop < restLength - 1; restStop++) {
        int a = trip[(start + runLength + restStop) % numberOfDots];
        int b = trip[(start + runLength + restStop + 1) % numberOfDots];
        float addedFacingForward = distanceBetween(a, first) + distanceBetween(last, b)
                                 - distanceBetween(a, b);
        float addedFacingBackward = distanceBetween(a, last) + distanceBetween(first, b)
                                  - distanceBetween(a, b);
        if (min(addedFacingForward, addedFacingBackward) < savedByTakingOut - 0.001) {
          moveRun(start, runLength, restStop, addedFacingBackward < addedFacingForward);
          isShorter = true;
          break;
        }
      }
    }
  }
  return isShorter;
}

// Moves the run of runLength cities starting at stop start, to
// just after stop restStop of the rest of the trip. If
// isBackward is true, the run is put in the other way around
void moveRun(int start, int runLength, int restStop, boolean isBackward) {
  int[] newTrip = new int[numberOfDots];
  int newStop = 0;
  int restLength = numberOfDots - runLength;

  // the rest of the trip, up to and including a
  for (int restNumber = 0; restNumber <= restStop; restNumber++) {
    newTrip[newStop] = trip[(start + runLength + restNumber) % numberOfDots];
    newStop++;
  }

  // the run
  for (int runNumber = 0; runNumber < runLength; runNumber++) {
    int runStop = runNumber;
    if (isBackward) {
      runStop = runLength - 1 - runNumber;
    }
    newTrip[newStop] = trip[(start + runStop) % numberOfDots];
    newStop++;
  }

  // the rest of the trip, from b on
  for (int restNumber = restStop + 1; restNumber < restLength; restNumber++) {
    newTrip[newStop] = trip[(start + runLength + restNumber) % numberOfDots];
    newStop++;
  }

  trip = newTrip;
}

// The length of the whole trip, back to the start
float tripLength() {
  float total = 0;
  for (int stop = 0; stop < numberOfDots; stop++) {
    total += distanceBetween(trip[stop], trip[(stop + 1) % numberOfDots]);
  }
  return total;
}

// The distance between two dots, from the equation above
float distanceBetween(int firstDot, int secondDot) {
  float x1 = dotX[firstDot];
  float y1 = dotY[firstDot];
  float x2 = dotX[secondDot];
  float y2 = dotY[secondDot];
  return sqrt(sq(x2 - x1) + sq(y2 - y1));
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
                                        // contrast keeps the
                                        // sky light

     boolean drawAsCurve = true;   // a smooth, flowing line

     int numberOfDots = 1500;      // a looser, loopier line
     float lineThickness = 2;

     int numberOfDots = 8000;      // more detail. This one
     float lineThickness = 0.5;    // takes a while

     float contrast = 4;           // just the eyes and mouth

   =========================================================== */
