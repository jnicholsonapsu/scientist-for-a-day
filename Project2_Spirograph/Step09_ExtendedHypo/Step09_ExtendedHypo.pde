/* ===========================================================
   STEP 9 — EXTENDED HYPO
   ===========================================================

   Step 8 again, but this time B rolls around the inside of
   A, and C rolls around the inside of B, the way Step 7's
   circle rolls inside.

   Change and add the lines marked below, then press PLAY.

   THE EQUATIONS

       x = centerX + zoom * ((R - r) * cos(t)
                           + (r - c) * cos((2 * r - R) * t / r)
                           + d * cos((R - r) * t / r + (r - c) * t / c))

       y = centerY + zoom * ((R - r) * sin(t)
                           + (r - c) * sin((2 * r - R) * t / r)
                           - d * sin((R - r) * t / r + (r - c) * t / c))

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
int R = 9;    // radius of circle A, which stays still
int r = 4;    // radius of circle B, which rolls inside A
int c = 1;    // radius of circle C, which rolls inside B
float d = 2;    // the pen's distance from the center of C

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
float shapeRadius = abs(R - r) + abs(r - c) + d;   // the farthest the shape
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

  for (int pointNumber = 0; pointNumber <= numberOfSides * numberOfTrips; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    // ******************************
    // ***** CHANGE THESE LINES *****
    // ******************************
    float x = centerX + zoom * ((R - r) * cos(t)
                              + (r - c) * cos((2 * r - R) * t / r)
                              + d * cos((R - r) * t / r + (r - c) * t / c));
    float y = centerY + zoom * ((R - r) * sin(t)
                              + (r - c) * sin((2 * r - R) * t / r)
                              - d * sin((R - r) * t / r + (r - c) * t / c));

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

       (r - c) * cos((2 * r - R) * t / r)

   The center of C. It is r - c from the center of B, and it
   goes once around B for every trip B makes around A. B is
   spinning at the same time, which is where the
   (2 * r - R) * t / r comes from.

       d * cos((R - r) * t / r + (r - c) * t / c)

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

     int R = 10;
     int r = 4;
     int c = 1;
     float d = 1;     // sharp points instead of loops

     int R = 8;
     int r = 3;
     int c = 1;
     float d = 2;

     int R = 12;
     int r = 5;
     int c = 2;
     float d = 2;     // 10 trips around, very busy

     // -------------------------------------------------
     // replace c = 1; with this

     int c = 4;     // the same as r, so you get the
                      // two-circle pattern back

   =========================================================== */
