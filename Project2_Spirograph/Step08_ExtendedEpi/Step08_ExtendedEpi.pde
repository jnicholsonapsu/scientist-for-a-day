/* ===========================================================
   STEP 8 — EXTENDED EPI
   ===========================================================

   Step 6 has two circles: A stays still and B rolls around
   the outside of it. This step adds a third circle, C, which
   rolls around the outside of B while B rolls around the
   outside of A. The pen is in C.

   Change and add the lines marked below, then press PLAY.

   THE EQUATIONS

       x = centerX + zoom * ((R + r) * cos(t)
                           + (r + c) * cos((R + 2 * r) * t / r)
                           - d * cos((R + r) * t / r + (r + c) * t / c))

       y = centerY + zoom * ((R + r) * sin(t)
                           + (r + c) * sin((R + 2 * r) * t / r)
                           - d * sin((R + r) * t / r + (r + c) * t / c))

         R = radius of circle A, which stays still
         r = radius of circle B, which rolls around A
         c = radius of circle C, which rolls around B
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
int R = 5;    // radius of circle A, which stays still
int r = 3;    // radius of circle B, which rolls around A
int c = 1;    // radius of circle C, which rolls around B
float d = 2;    // the pen's distance from the center of C

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);

// ******************************
// ***** CHANGE THESE LINES *****
// ******************************
color[] palette = {
  color( 40,  90, 170),   // blue, on the left
  color(200,  60,  60),   // red, on the right
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
int denominatorB = r / greatestCommonDivisor(R, r);
// trips around for C, from r / c in its smallest fraction
int denominatorC = c / greatestCommonDivisor(r, c);
// the smallest number of trips that finishes both
int numberOfTrips = denominatorB * denominatorC
                  / greatestCommonDivisor(denominatorB, denominatorC);

// ****************************
// ***** CHANGE THIS LINE *****
// ****************************
float shapeRadius = (R + r) + (r + c) + d;   // the farthest the shape
                                              // reaches from its center
float availableRadius = min(pageWidth, pageHeight) / 2 - pageMargin;
float zoom = availableRadius / shapeRadius;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
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
    float x = centerX + zoom * ((R + r) * cos(t)
                              + (r + c) * cos((R + 2 * r) * t / r)
                              - d * cos((R + r) * t / r + (r + c) * t / c));
    float y = centerY + zoom * ((R + r) * sin(t)
                              + (r + c) * sin((R + 2 * r) * t / r)
                              - d * sin((R + r) * t / r + (r + c) * t / c));

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

       (R + r) * cos(t)

   The center of B, going around A, as in Step 6.

       (r + c) * cos((R + 2 * r) * t / r)

   The center of C. It is r + c from the center of B, and it
   goes once around B for every trip B makes around A. B is
   spinning at the same time, which is where the
   (R + 2 * r) * t / r comes from.

       - d * cos((R + r) * t / r + (r + c) * t / c)

   The pen, d from the center of C. C spins because it rolls
   around B, and B spins because it rolls around A, so the two
   spins add up.

   HOW MANY TRIPS AROUND

   B finishes after denominatorB trips, from R / r. C finishes
   after denominatorC trips, from r / c. The whole pattern
   finishes after the smallest number of trips that both of
   those go into evenly. For 5, 3 and 1:

       5 / 3 = 5 / 3     denominatorB = 3
       3 / 1 = 3 / 1     denominatorC = 1
                         numberOfTrips = 3

   HOW BIG THE SHAPE IS

       (R + r) + (r + c) + d

   The three distances, all lined up. 8 + 4 + 2 = 14 here.

   TRY THESE (change a line, press PLAY, see what's different):

     // -------------------------------------------------
     // replace R, r, c and d with one of these sets

     int R = 4;
     int r = 3;
     int c = 1;
     float d = 2;

     int R = 5;
     int r = 2;
     int c = 1;
     float d = 1;

     int R = 9;
     int r = 4;
     int c = 1;
     float d = 2;     // 4 trips around, very busy

   =========================================================== */
