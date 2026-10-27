/* ===========================================================
   STEP 5 — HYPOTROCHOID
   ===========================================================

   A hypotrochoid is the path of a pen in a circle that rolls
   around the INSIDE of another circle that stays still. The
   pen does not have to be on the edge of the rolling circle.

   This is what a Spirograph toy draws.

   Change and add the lines marked below, then press PLAY.

   You should get a blue pattern with eight loops.

   THE EQUATIONS

       x = centerX + zoom * ((R - r) * cos(t) + d * cos((R - r) / r * t))
       y = centerY + zoom * ((R - r) * sin(t) - d * sin((R - r) / r * t))

         R = radius of the circle that stays still
         r = radius of the circle that rolls inside it
         d = how far the pen is from the center of the
             rolling circle
         t = the angle the rolling circle has traveled
             around the still one

   =========================================================== */

void setup() {
  size(612, 792);
  background(250, 247, 240);

  noFill();
  stroke(40, 90, 170);
  strokeWeight(2);

  float centerX = width / 2;
  float centerY = height / 2;

  float pageMargin = 72;   // 1 inch when printed

  // *******************************
  // ***** CHANGE THESE LINES *****
  // *******************************
  float R = 8;    // radius of the circle that stays still
  float r = 3;    // radius of the circle that rolls inside it
  // ***************************
  // ***** ADD THIS LINE *****
  // ***************************
  float d = 4;    // the pen's distance from the center of
                  // the rolling circle

  int numberOfSides = 360;

  // reduce R / r to its smallest fraction
  int divisor = greatestCommonDivisor(int(R), int(r));
  int denominator = int(r) / divisor;

  // *****************************
  // ***** CHANGE THIS LINE *****
  // *****************************
  float shapeRadius = R - r + d;   // the farthest the shape reaches
                                   // from its center
  float availableRadius = min(width, height) / 2 - pageMargin;
  float zoom = availableRadius / shapeRadius;

  beginShape();
  for (int pointNumber = 0; pointNumber < numberOfSides * denominator; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    // *******************************
    // ***** CHANGE THESE LINES *****
    // *******************************
    float x = centerX + zoom * ((R - r) * cos(t) + d * cos((R - r) / r * t));
    float y = centerY + zoom * ((R - r) * sin(t) - d * sin((R - r) / r * t));

    vertex(x, y);
  }
  endShape(CLOSE);
}

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

   WHAT CHANGED FROM STEP 4

   R + r became R - r, because the circle now rolls inside.
   The pen part now uses d instead of r, because the pen is
   d from the center of the rolling circle, not on its edge.

   HOW BIG THE SHAPE IS

   The center of the rolling circle is always R - r from the
   center of the page, and the pen is d farther out at most.
   So the farthest the shape reaches is

       R - r + d

   which is 8 - 3 + 4 = 9 here.

   THE NUMBER OF LOOPS

   Reduce R / r to its smallest fraction:

       8 / 3

   The numerator, 8, is how many loops the pattern has. The
   denominator, 3, is how many trips around it takes to
   finish.

   TRY THESE (change a line, press PLAY, see what's different):

     float d = 3;     // the pen is on the edge of the
                      // rolling circle, so the loops
                      // become sharp points

     float d = 0;     // the pen is at the center, so all
                      // you get is a circle

     float r = 5;     // 8 / 5

     float r = 7;     // 8 / 7

     float r = 1;     // 8 / 1

   =========================================================== */
