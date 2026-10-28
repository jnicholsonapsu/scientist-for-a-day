/* ===========================================================
   STEP 3 — FINISHING THE SHAPE
   ===========================================================

   In Step 2, r = 50 left a straight line across the shape,
   because one trip around was not enough to finish it.

   This step works out how many trips around are needed, and
   loops that many times.

   Change and add the lines marked below, then press PLAY.

   You should get a blue shape with twelve loops that
   overlap, and no straight line.

   THE EQUATIONS

       x = centerX + (R + r) * cos(t) - d * cos((R + r) * t / r)
       y = centerY + (R + r) * sin(t) - d * sin((R + r) * t / r)

         R = radius of the circle that stays still
         r = radius of the circle that rolls
         d = how far the pen is from the center of the
             rolling circle
         t = the angle the rolling circle has traveled
             around the still one

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE SHAPE -----------------------------------
int R = 120;   // radius of the circle that stays still
// ****************************
// ***** CHANGE THIS LINE *****
// ****************************
int r = 50;    // radius of the circle that rolls around it
float d = 60;    // the pen's distance from the center of
                 // the rolling circle

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(40, 90, 170);
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ***************************
// ***** ADD THESE LINES *****
// ***************************
// reduce R / r to its smallest fraction
int divisor = greatestCommonDivisor(R, r);
int denominator = r / divisor;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // one pixel for every point on the page
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  background(paperColor);
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  beginShape();
  // ****************************
  // ***** CHANGE THIS LINE *****
  // ****************************
  for (int pointNumber = 0; pointNumber < numberOfSides * denominator; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    float x = centerX + (R + r) * cos(t) - d * cos((R + r) * t / r);
    float y = centerY + (R + r) * sin(t) - d * sin((R + r) * t / r);

    vertex(x, y);
  }
  endShape(CLOSE);
}

// ***************************
// ***** ADD THESE LINES *****
// ***************************
// The biggest whole number that divides both a and b
int greatestCommonDivisor(int a, int b) {
  while (b != 0) {
    int remainder = a % b;
    a = b;
    b = remainder;
  }
  return a;
}

/* ===========================================================
   Notes:

   HOW MANY TRIPS AROUND

   Reduce R / r to its smallest fraction:

       120 / 50  =  12 / 5

   The numerator, 12, is the number of loops on the shape.
   The denominator, 5, is how many trips around it takes to
   finish the shape. So the loop now runs

       numberOfSides * denominator

   times, which is 360 * 5 = 1800.

   greatestCommonDivisor()

   This finds the biggest whole number that divides both R
   and r. Dividing both by it gives the smallest fraction.
   For 120 and 50 it is 10.

   It uses Euclid's method, which is over 2,000 years old:
   replace the two numbers with the smaller one and the
   remainder, until the remainder is 0.

       a = 120, b = 50    remainder 20
       a =  50, b = 20    remainder 10
       a =  20, b = 10    remainder  0
       a =  10, b =  0    so the answer is 10

   TRY THESE (change a line, press PLAY, see what's different):

     int r = 45;    // 120 / 45 = 8 / 3

     int r = 35;    // 120 / 35 = 24 / 7

     int r = 40;    // 120 / 40 = 3 / 1, so one trip
                      // around is enough, as in Step 2

   =========================================================== */
