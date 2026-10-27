/* ===========================================================
   STEP 7 — HYPOTROCHOID
   ===========================================================

   A hypotrochoid is the path of a pen in a circle that rolls
   around the INSIDE of another circle that stays still. The
   pen does not have to be on the edge of the rolling circle.

   This is what a Spirograph toy draws.

   Change and add the lines marked below, then press PLAY.

   You should get a pattern with eight loops, teal on the
   left and orange on the right, thin at the top and thick at
   the bottom.

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

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72;   // 1 inch when printed

// ---------- THE SHAPE -----------------------------------
// ******************************
// ***** CHANGE THESE LINES *****
// ******************************
float R = 8;    // radius of the circle that stays still
float r = 3;    // radius of the circle that rolls inside it
// *************************
// ***** ADD THIS LINE *****
// *************************
float d = 4;    // the pen's distance from the center of
                // the rolling circle

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);

// ******************************
// ***** CHANGE THESE LINES *****
// ******************************
color[] palette = {
  color( 20, 120, 110),   // teal, on the left
  color(230, 120,  30),   // orange, on the right
};

float thinnestLine = 0.5;   // at the top of the shape
float thickestLine = 6;     // at the bottom of the shape

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// reduce R / r to its smallest fraction
int divisor = greatestCommonDivisor(int(R), int(r));
int denominator = int(r) / divisor;

// ****************************
// ***** CHANGE THIS LINE *****
// ****************************
float shapeRadius = abs(R - r) + d;   // the farthest the shape reaches
                                      // from its center
float availableRadius = min(pageWidth, pageHeight) / 2 - pageMargin;
float zoom = availableRadius / shapeRadius;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  beginRecord(PDF, "picture.pdf");

  background(paperColor);
  strokeCap(ROUND);   // rounded ends, so the segments join smoothly

  float previousX = 0;
  float previousY = 0;

  for (int pointNumber = 0; pointNumber <= numberOfSides * denominator; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    // ******************************
    // ***** CHANGE THESE LINES *****
    // ******************************
    float x = centerX + zoom * ((R - r) * cos(t) + d * cos((R - r) / r * t));
    float y = centerY + zoom * ((R - r) * sin(t) - d * sin((R - r) / r * t));

    if (pointNumber > 0) {
      float distanceFromCenter = previousX - centerX;
      float colorAmount = map(distanceFromCenter, -availableRadius, availableRadius, 0, 1);
      stroke(lerpColor(palette[0], palette[1], colorAmount));

      float distanceBelowCenter = previousY - centerY;
      float thickness = map(distanceBelowCenter, -availableRadius, availableRadius, thinnestLine, thickestLine);
      strokeWeight(thickness);

      line(previousX, previousY, x, y);
    }

    previousX = x;
    previousY = y;
  }

  endRecord();
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

   WHAT CHANGED FROM STEP 6

   R + r became R - r, because the circle now rolls inside.
   The pen part now uses d instead of r, because the pen is
   d from the center of the rolling circle, not on its edge.

   HOW BIG THE SHAPE IS

   The center of the rolling circle is always R - r from the
   center of the page, and the pen is d farther out at most.
   So the farthest the shape reaches is

       abs(R - r) + d

   which is 5 + 4 = 9 here.

   abs() drops the minus sign. If r is bigger than R, then
   R - r is negative, but a distance can't be. Without abs(),
   shapeRadius comes out too small, the zoom is wrong, and the
   shape spills past the margin.

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
