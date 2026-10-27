/* ===========================================================
   STEP 8 — THREE CIRCLES
   ===========================================================

   Step 7 has two circles: A stays still and B rolls around
   inside it. This step adds a third circle, C, which rolls
   around inside B while B rolls around inside A. The pen is
   in C.

   Change and add the lines marked below, then press PLAY.

   THE EQUATIONS

       x = centerX + zoom * ((R - r) * cos(t)
                           + (r - c) * cos((2 * r - R) / r * t)
                           + d * cos(((R - r) / r + (r - c) / c) * t))

       y = centerY + zoom * ((R - r) * sin(t)
                           + (r - c) * sin((2 * r - R) / r * t)
                           - d * sin(((R - r) / r + (r - c) / c) * t))

         R = radius of circle A, which stays still
         r = radius of circle B, which rolls inside A
         c = radius of circle C, which rolls inside B
         d = how far the pen is from the center of C
         t = the angle B has traveled around A

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
float R = 9;    // radius of circle A, which stays still
float r = 4;    // radius of circle B, which rolls inside A
float c = 1;    // radius of circle C, which rolls inside B
float d = 2;    // the pen's distance from the center of C

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);

color[] palette = {
  color( 20, 120, 110),   // teal, on the left
  color(230, 120,  30),   // orange, on the right
};

float thinnestLine = 0.5;   // at the top of the shape
float thickestLine = 6;     // at the bottom of the shape

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// *************************************************
// ***** REPLACE THE FRACTION LINES WITH THESE *****
// *************************************************
// trips around for B, from R / r in its smallest fraction
int denominatorB = int(r) / greatestCommonDivisor(int(R), int(r));
// trips around for C, from r / c in its smallest fraction
int denominatorC = int(c) / greatestCommonDivisor(int(r), int(c));
// the smallest number of trips that finishes both
int numberOfTrips = denominatorB * denominatorC
                  / greatestCommonDivisor(denominatorB, denominatorC);

// ****************************
// ***** CHANGE THIS LINE *****
// ****************************
float shapeRadius = abs(R - r) + abs(r - c) + d;   // the farthest the shape
                                                    // reaches from its center
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

  // ****************************
  // ***** CHANGE THIS LINE *****
  // ****************************
  for (int pointNumber = 0; pointNumber <= numberOfSides * numberOfTrips; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    // ******************************
    // ***** CHANGE THESE LINES *****
    // ******************************
    float x = centerX + zoom * ((R - r) * cos(t)
                              + (r - c) * cos((2 * r - R) / r * t)
                              + d * cos(((R - r) / r + (r - c) / c) * t));
    float y = centerY + zoom * ((R - r) * sin(t)
                              + (r - c) * sin((2 * r - R) / r * t)
                              - d * sin(((R - r) / r + (r - c) / c) * t));

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

   THE THREE PARTS OF THE EQUATION

       (R - r) * cos(t)

   The center of B, going around A, as in Step 7.

       (r - c) * cos((2 * r - R) / r * t)

   The center of C. It is r - c from the center of B, and it
   goes once around B for every trip B makes around A. B is
   spinning at the same time, which is where the
   (2 * r - R) / r comes from.

       d * cos(((R - r) / r + (r - c) / c) * t)

   The pen, d from the center of C. C spins because it rolls
   inside B, and B spins because it rolls inside A, so the two
   spins add up.

   If c is the same as r, then r - c is 0, C sits exactly on
   top of B, and you get Step 7's hypotrochoid back.

   HOW MANY TRIPS AROUND

   B finishes after denominatorB trips, from R / r. C finishes
   after denominatorC trips, from r / c. The whole pattern
   finishes after the smallest number of trips that both of
   those go into evenly. For 9, 4 and 1:

       9 / 4 = 9 / 4     denominatorB = 4
       4 / 1 = 4 / 1     denominatorC = 1
                         numberOfTrips = 4

   HOW BIG THE SHAPE IS

       abs(R - r) + abs(r - c) + d

   The three distances, all lined up. 5 + 3 + 2 = 10 here.

   TRY THESE (change a line, press PLAY, see what's different):

     // -------------------------------------------------
     // replace R, r, c and d with one of these sets

     float R = 10;
     float r = 4;
     float c = 1;
     float d = 1;     // sharp points instead of loops

     float R = 8;
     float r = 3;
     float c = 1;
     float d = 2;

     float R = 12;
     float r = 5;
     float c = 2;
     float d = 2;     // 10 trips around, very busy

     // -------------------------------------------------
     // replace c = 1; with this

     float c = 4;     // the same as r, so you get the
                      // two-circle pattern back

   =========================================================== */
