/* ===========================================================
   STEP 7 — CHEN-LEE ATTRACTOR
   ===========================================================

   This strange attractor is 3D. It comes from Hsien-Keng Chen
   and Ching-I Lee, who found it in 2004 while studying how a
   spinning solid object, like a satellite, tumbles.

   Steps 5 and 6 jump from spot to spot. This dot doesn't
   jump: it flows smoothly through space, like a speck of dust
   in the wind. The equations say how fast x, y and z are
   changing. Each step, the dot moves a tiny bit, for a tiny
   amount of time, dt.

   The dot moves in 3D, but the page is flat. The drawing
   shows the attractor from the side, with x going up and
   down. viewAngle turns the attractor around that up-down
   line, so you can look at it from different sides.

   The pixels are colored the same way as in Step 5:
   paper where the dot never landed, the point color where it
   landed most, and in between for the rest.

   The drawing is made as big as fits inside the margins.

   Press PLAY. It takes a few seconds. The picture is also
   saved as picture.pdf.

   Not every a, b and c makes a strange attractor. Some make
   the attractor collapse to a fixed point (like Step 1).
   Others make the dot fly off to infinity, which is called
   unbounded. When that happens, a message says so.

   THE VALUES YOU CAN CHANGE

     a, b, c           the three numbers in the equations
     dt                how much time passes each step. Keep it
                       small, or the dot is thrown off its
                       path
     viewAngle         how far the attractor is turned, in
                       radians. 1.571 is a quarter turn
     warmUpSteps       how many steps the dot makes before
                       it starts counting pixels
     numberOfSteps     how many steps the dot makes after
                       that. More steps make a smoother
                       picture, but take longer
     dotsPerInch       how sharp the picture is
     paperColor        the color of the paper
     pointColor        the color where the dot lands most

   THE EQUATIONS

   How fast x, y and z are changing:

       dx/dt = a * x - y * z
       dy/dt = b * y + x * z
       dz/dt = c * z + x * y / 3

   Each step:

       x = x + dx/dt * dt
       y = y + dy/dt * dt
       z = z + dz/dt * dt

   Turning the view and flattening it onto the page:

       across = y * cos(viewAngle) + z * sin(viewAngle)
       up     = x

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

int dotsPerInch = 100;   // how many pixels per inch in the picture

// ---------- THE SHAPE -----------------------------------
float a = 5;
float b = -10;
float c = -0.38;
float dt = 0.001;

float viewAngle = 1.2;

int warmUpSteps = 20000;
int numberOfSteps = 10000000;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color pointColor = color(100, 100,  20);   // olive

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
float z;

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
  float smallestAcross = across();
  float biggestAcross = across();
  float smallestUp = x;
  float biggestUp = x;
  for (int stepNumber = 0; stepNumber < numberOfSteps; stepNumber++) {
    step();

    // The dot is flying off to infinity. Written as "not
    // less than" so it also catches x, y or z becoming NaN
    // (not a number), which happens once they get too big
    if (!(abs(x) + abs(y) + abs(z) < 1000000)) {
      println("The dot flew off to infinity (unbounded).");
      println("Try different values for a, b and c.");
      return;
    }

    smallestAcross = min(smallestAcross, across());
    biggestAcross = max(biggestAcross, across());
    smallestUp = min(smallestUp, x);
    biggestUp = max(biggestUp, x);
  }

  // If the dot stops on one spot (a fixed point, like Step 1),
  // there is no shape to make fit
  if (biggestAcross == smallestAcross || biggestUp == smallestUp) {
    println("The attractor collapsed to a fixed point.");
    println("Try different values for a, b and c.");
    return;
  }

  // as big as fits inside the margins, without stretching.
  // A small attractor is made bigger, a big one smaller
  float zoom = min((pageWidth - 2 * pageMargin) / (biggestAcross - smallestAcross),
                   (pageHeight - 2 * pageMargin) / (biggestUp - smallestUp));
  float middleAcross = (smallestAcross + biggestAcross) / 2;
  float middleUp = (smallestUp + biggestUp) / 2;

  // Second run: count the pixels the dot lands on. Up on the
  // page is a smaller pageY, so up is subtracted
  startDot();
  for (int stepNumber = 0; stepNumber < numberOfSteps; stepNumber++) {
    step();
    float pageX = centerX + zoom * (across() - middleAcross);
    float pageY = centerY - zoom * (x - middleUp);
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

  // If the dot slows to a stop, it lands on only a few pixels
  if (pixelsLandedOn < 100) {
    println("The attractor collapsed to a fixed point.");
    println("Try different values for a, b and c.");
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
// steps, so it is on the attractor before anything is counted
void startDot() {
  x = 1;
  y = 1;
  z = 1;
  for (int stepNumber = 0; stepNumber < warmUpSteps; stepNumber++) {
    step();
  }
}

// Moves the dot a tiny bit along its path
void step() {
  float dxdt = a * x - y * z;
  float dydt = b * y + x * z;
  float dzdt = c * z + x * y / 3;
  x = x + dxdt * dt;
  y = y + dydt * dt;
  z = z + dzdt * dt;
}

// How far across the page the dot is, after turning the view
float across() {
  return y * cos(viewAngle) + z * sin(viewAngle);
}

/* ===========================================================
   TRY THESE (change the numbers, press PLAY, see what's
   different):

     float viewAngle = 0;       // looking straight along z

     float viewAngle = 1.571;   // a quarter turn: looking
                                // straight along y

     float viewAngle = 2.2;

     float c = -0.6;     // a fuller picture

     float a = 6;

     float a = 3;        // only a few loops

     int numberOfSteps = 100000;   // a quick, grainy picture

   =========================================================== */
