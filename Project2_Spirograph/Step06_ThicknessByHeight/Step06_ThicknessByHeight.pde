/* ===========================================================
   STEP 6 — THICKNESS BY HEIGHT
   ===========================================================

   Step 5, with one change: the line gets thinner toward the
   top of the page and thicker toward the bottom. The color
   still blends from left to right.

   Three things to do:
     - replace lineThickness with the two marked lines
     - delete strokeWeight(lineThickness); from draw()
     - add the three marked lines inside the loop

   THE EQUATIONS

       x = centerX + zoom * ((R + r) * cos(t) - d * cos((R + r) * t / r))
       y = centerY + zoom * ((R + r) * sin(t) - d * sin((R + r) * t / r))

         R = radius of the circle that stays still
         r = radius of the circle that rolls
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
int R = 12;   // radius of the circle that stays still
int r = 5;    // radius of the circle that rolls around it
float d = 6;    // the pen's distance from the center of
                // the rolling circle

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);

color[] palette = {
  color( 40,  90, 170),   // blue, on the left
  color(200,  60,  60),   // red, on the right
};

// ********************************************
// ***** REPLACE lineThickness WITH THESE *****
// ********************************************
float thinnestLine = 0.5;   // at the top of the shape
float thickestLine = 6;     // at the bottom of the shape

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// reduce R / r to its smallest fraction
int divisor = greatestCommonDivisor(R, r);
int denominator = r / divisor;

float shapeRadius = R + r + d;   // the farthest the shape reaches
                                 // from its center
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

  for (int pointNumber = 0; pointNumber <= numberOfSides * denominator; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    float x = centerX + zoom * ((R + r) * cos(t) - d * cos((R + r) * t / r));
    float y = centerY + zoom * ((R + r) * sin(t) - d * sin((R + r) * t / r));

    if (pointNumber > 0) {
      float distanceFromCenter = previousX - centerX;
      float colorAmount = map(distanceFromCenter, -availableRadius, availableRadius, 0, 1);
      stroke(lerpColor(palette[0], palette[1], colorAmount));

      // ***************************
      // ***** ADD THESE LINES *****
      // ***************************
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

   THE THICKNESS

       float distanceBelowCenter = previousY - centerY;

   How far the start of the segment is below the center of
   the page. It is negative above the center and positive
   below it, because y counts down from the top.

       float thickness = map(distanceBelowCenter, -availableRadius, availableRadius, thinnestLine, thickestLine);

   map() turns that into a thickness. The top of the shape
   gets thinnestLine, the bottom gets thickestLine, and the
   center gets halfway between.

   strokeWeight() is now called for every segment, just
   before line(), instead of once at the top of draw().

   TRY THESE (change a line, press PLAY, see what's different):

     // -------------------------------------------------
     // swap the two numbers

     float thinnestLine = 6;
     float thickestLine = 0.5;   // thick at the top, thin at
                                 // the bottom

     // -------------------------------------------------
     // replace thickestLine = 6; with this

     float thickestLine = 15;    // a much bigger change from
                                 // top to bottom

   =========================================================== */
