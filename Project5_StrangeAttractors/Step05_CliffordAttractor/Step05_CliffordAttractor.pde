/* ===========================================================
   STEP 5 — CLIFFORD ATTRACTOR
   ===========================================================

   A real strange attractor. This one comes from Clifford
   Pickover, who wrote about it in his book "Chaos in
   Wonderland" (1994).

   Like the chaos game, a dot follows a rule over and over,
   and the pixels it lands on are counted. This time there are
   no corners and nothing is random. The rule is a pair of
   equations, and the dot wanders all over the attractor
   without ever landing in the same place twice.

   The pixels are colored the same way as in curve stitching:
   paper where the dot never landed, the point color where it
   landed most, and in between for the rest.

   The drawing is made as big as fits inside the margins.

   Press PLAY. It takes a few seconds. The picture is also
   saved as picture.pdf.

   Not every a, b, c and d makes a strange attractor. Some
   make the attractor collapse: the dot ends up on one spot,
   called a fixed point (like Step 1), or hopping between the
   same few spots forever, called a cycle (like Step 2's loop,
   but with jumps). When that happens, a message says so.

   THE VALUES YOU CAN CHANGE

     a, b, c, d        the four numbers in the equations. Small
                       changes give a whole new shape
     warmUpJumps       how many jumps the dot makes before
                       it starts counting pixels
     numberOfJumps     how many times the dot jumps after that.
                       More jumps make a smoother picture, but
                       take longer
     dotsPerInch       how sharp the picture is
     paperColor        the color of the paper
     pointColor        the color where the dot lands most

   THE EQUATIONS

   The dot is at x, y. Its next spot is:

       newX = sin(a * y) + c * cos(a * x)
       newY = sin(b * x) + d * cos(b * y)

   Then x = newX and y = newY, and it jumps again.

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

int dotsPerInch = 100;   // how many pixels per inch in the picture

// ---------- THE SHAPE -----------------------------------
float a = -1.4;
float b = 1.6;
float c = 1.0;
float d = 0.7;

int warmUpJumps = 100;
int numberOfJumps = 10000000;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color pointColor = color(110,  60,  20);   // dark brown

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// the picture's size in pixels. There are 72 points in an inch
float pixelsPerPoint = dotsPerInch / 72.0;
int pictureWidth = round(pageWidth * pixelsPerPoint);
int pictureHeight = round(pageHeight * pixelsPerPoint);

// how many times the dot landed on each pixel
int[] counts = new int[pictureWidth * pictureHeight];

// ---------- THE DRAWING ---------------------------------
float x;
float y;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  // First run: find how far the attractor reaches, so it can
  // be made to fit. Nothing is random, so the second run
  // follows exactly the same path
  startDot();
  float smallestX = x;
  float biggestX = x;
  float smallestY = y;
  float biggestY = y;
  for (int jumpNumber = 0; jumpNumber < numberOfJumps; jumpNumber++) {
    jump();
    smallestX = min(smallestX, x);
    biggestX = max(biggestX, x);
    smallestY = min(smallestY, y);
    biggestY = max(biggestY, y);
  }

  // Some values make the attractor collapse. If the dot stops
  // on one spot (a fixed point, like Step 1), there is no
  // shape to make fit
  if (biggestX == smallestX || biggestY == smallestY) {
    println("The attractor collapsed to a fixed point.");
    println("Try different values for a, b, c and d.");
    return;
  }

  // as big as fits inside the margins, without stretching.
  // A small attractor is made bigger, a big one smaller
  float zoom = min((pageWidth - 2 * pageMargin) / (biggestX - smallestX),
                   (pageHeight - 2 * pageMargin) / (biggestY - smallestY));
  float middleX = (smallestX + biggestX) / 2;
  float middleY = (smallestY + biggestY) / 2;

  // Second run: count the pixels the dot lands on
  startDot();
  for (int jumpNumber = 0; jumpNumber < numberOfJumps; jumpNumber++) {
    jump();
    float pageX = centerX + zoom * (x - middleX);
    float pageY = centerY + zoom * (y - middleY);
    int column = min(int(pageX * pixelsPerPoint), pictureWidth - 1);
    int row = min(int(pageY * pixelsPerPoint), pictureHeight - 1);
    counts[row * pictureWidth + column]++;
  }

  // find the biggest count, and how many pixels the dot
  // landed on
  int biggestCount = 0;
  int pixelsLandedOn = 0;
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    biggestCount = max(biggestCount, counts[pixelNumber]);
    if (counts[pixelNumber] > 0) {
      pixelsLandedOn++;
    }
  }

  // If the dot settles on one spot (a fixed point) or hops
  // between the same few spots forever (a cycle), it lands on
  // only a few pixels. The attractor collapsed, but those
  // spots are still drawn
  if (pixelsLandedOn == 1) {
    println("The attractor collapsed to a fixed point.");
    println("Try different values for a, b, c and d.");
  } else if (pixelsLandedOn < 100) {
    println("The attractor collapsed to a cycle of " + pixelsLandedOn + " spots.");
    println("Try different values for a, b, c and d.");
  }

  // color each pixel: paper where the dot never landed, the
  // point color where it landed most, and in between for the
  // rest
  PImage picture = createImage(pictureWidth, pictureHeight, RGB);
  picture.loadPixels();
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    float darkness = log(1 + counts[pixelNumber]) / log(1 + biggestCount);
    picture.pixels[pixelNumber] = lerpColor(paperColor, pointColor, darkness);
  }
  picture.updatePixels();

  beginRecord(PDF, "picture.pdf");
  image(picture, 0, 0, pageWidth, pageHeight);
  endRecord();
}

// Puts the dot at its starting spot, then makes the warm-up
// jumps, so it is on the attractor before anything is counted
void startDot() {
  x = 0.1;
  y = 0.1;
  for (int jumpNumber = 0; jumpNumber < warmUpJumps; jumpNumber++) {
    jump();
  }
}

// Moves the dot to its next spot
void jump() {
  float newX = sin(a * y) + c * cos(a * x);
  float newY = sin(b * x) + d * cos(b * y);
  x = newX;
  y = newY;
}

/* ===========================================================
   TRY THESE (change the numbers, press PLAY, see what's
   different):

     float a = -1.7;
     float b = 1.3;
     float c = -0.1;
     float d = -1.2;

     float a = 1.5;
     float b = -1.8;
     float c = 1.6;
     float d = 0.9;

     float a = -1.8;
     float b = -2.0;
     float c = -0.5;
     float d = -0.9;

     float a = 1.7;
     float b = 1.7;
     float c = 0.06;
     float d = 1.2;

     int numberOfJumps = 100000;   // a quick, grainy picture

   =========================================================== */
