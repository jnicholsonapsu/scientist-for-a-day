/* ===========================================================
   STEP 5 — COLOR BY DISTANCE
   ===========================================================

   This step draws the shape as separate line segments
   instead of one path, so each segment can have its own
   color. The color blends from the first palette color at
   the left margin to the second at the right margin.

   Change and add the lines marked below, then press PLAY.

   You should get the same twelve-point shape as Step 4,
   blue on the left, red on the right, and purple where they
   meet in the middle.

   THE EQUATIONS

       x = centerX + zoom * ((R + r) * cos(t) - r * cos((R + r) / r * t))
       y = centerY + zoom * ((R + r) * sin(t) - r * sin((R + r) / r * t))

         R = radius of the circle that stays still
         r = radius of the circle that rolls
         t = the angle the rolling circle has traveled
             around the still one

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72;   // 1 inch when printed

// ---------- THE SHAPE -----------------------------------
float R = 12;   // radius of the circle that stays still
float r = 5;    // radius of the circle that rolls around it

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

float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// reduce R / r to its smallest fraction
int divisor = greatestCommonDivisor(int(R), int(r));
int denominator = int(r) / divisor;

float shapeRadius = R + 2 * r;   // the farthest the shape reaches
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
  strokeWeight(lineThickness);
  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  strokeCap(ROUND);   // rounded ends, so the segments join smoothly

  // ******************************
  // ***** CHANGE THESE LINES *****
  // ******************************
  float previousX = 0;
  float previousY = 0;

  for (int pointNumber = 0; pointNumber <= numberOfSides * denominator; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    float x = centerX + zoom * ((R + r) * cos(t) - r * cos((R + r) / r * t));
    float y = centerY + zoom * ((R + r) * sin(t) - r * sin((R + r) / r * t));

    // ******************************
    // ***** CHANGE THESE LINES *****
    // ******************************
    if (pointNumber > 0) {
      float distanceFromCenter = previousX - centerX;
      float colorAmount = map(distanceFromCenter, -availableRadius, availableRadius, 0, 1);
      stroke(lerpColor(palette[0], palette[1], colorAmount));

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

   THE LINE SEGMENTS

   A path made with beginShape() can only have one color, so
   each short piece is drawn on its own with line(). noFill()
   is gone too, since a line has no inside to fill. lineColor
   is replaced by the palette.

   A line needs two ends. Each time around the loop, x and y
   are the new end, and previousX and previousY remember the
   end from the time before. At the bottom of the loop the
   new end becomes the previous one.

       if (pointNumber > 0)

   The first time around there is no previous point yet, so
   nothing is drawn.

       pointNumber <= numberOfSides * denominator

   This is <= now, not <. The last point lands back on the
   first one, which closes the shape. That used to be the job
   of endShape(CLOSE).

   THE COLOR

       float distanceFromCenter = previousX - centerX;

   How far the start of the segment is from the center of the
   page. It is negative on the left and positive on the right.

       float colorAmount = map(distanceFromCenter, -availableRadius, availableRadius, 0, 1);

   map() turns a number from one range into another. Here
   -availableRadius, the left margin, becomes 0, and
   availableRadius, the right margin, becomes 1. The center
   becomes 0.5.

       stroke(lerpColor(palette[0], palette[1], colorAmount));

   lerpColor() blends two colors. 0 gives the first color, 1
   gives the second, and 0.5 gives halfway between.

   TRY THESE (change a line, press PLAY, see what's different):

     // -------------------------------------------------
     // replace the palette with this

     color[] palette = {
       color(230,  80,  70),   // coral
       color( 50, 149,  99),   // green
     };

     // -------------------------------------------------
     // replace the distanceFromCenter line with this

     float distanceFromCenter = previousY - centerY;
                      // blue at the top and red at
                      // the bottom

     // -------------------------------------------------
     // replace lineThickness = 2; with this

     float lineThickness = 5;

   =========================================================== */
