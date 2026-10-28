/* ===========================================================
   STEP 8 — SQUARE
   ===========================================================

   This sketch draws a square as one line.

   A square, drawn by going around the center and finding
   where each angle meets the square's edge.

   Press PLAY. You should get a square.

   THE VALUES YOU CAN CHANGE

     rotation          how far the square is turned
     lineColor         the color of the line
     lineThickness     how thick the line is

   THE EQUATIONS

   A point on a square is where a line from the center, at
   angle theta, crosses the square's edge. For the right
   edge of a square that reaches from -1 to 1:

       x = 1
       y = tan(theta)

   The other three edges work the same way. Then the square
   is made r wide and turned by rotation:

       x = centerX + r * edgeX * cos(rotation) - r * edgeY * sin(rotation)
       y = centerY + r * edgeY * cos(rotation) + r * edgeX * sin(rotation)

         r        = half the width of the square
         theta    = the angle around the square
         rotation = how far the square is turned

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
float rotation = 0;   // how far the square is turned

int numberOfSides = 1000;   // how many short lines make up the curve

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color( 20, 110, 100);   // teal
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// how far the shape reaches, as big as fits inside the margins
float r = min(pageWidth, pageHeight) / 2 - pageMargin;

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
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  beginShape();
  for (int sideNumber = 0; sideNumber < numberOfSides; sideNumber++) {
    float theta = TWO_PI * sideNumber / numberOfSides;
    PVector point = shapePoint(theta, r);
    vertex(point.x, point.y);
  }
  endShape(CLOSE);

  endRecord();
}

// Where a point at angle theta is on a square. r is half the
// width of the square
PVector shapePoint(float theta, float r) {
  // the same angle, moved into the range 0 up to TWO_PI
  float angle = theta % TWO_PI;
  if (angle < 0) {
    angle += TWO_PI;
  }

  // where a line from the center at this angle crosses the
  // edge of a square that reaches from -1 to 1
  float edgeX;
  float edgeY;
  if (angle >= QUARTER_PI && angle < 3 * QUARTER_PI) {
    // the bottom edge
    edgeX = cos(angle) / sin(angle);
    edgeY = 1;
  } else if (angle >= 3 * QUARTER_PI && angle < 5 * QUARTER_PI) {
    // the left edge
    edgeX = -1;
    edgeY = -tan(angle);
  } else if (angle >= 5 * QUARTER_PI && angle < 7 * QUARTER_PI) {
    // the top edge
    edgeX = -cos(angle) / sin(angle);
    edgeY = -1;
  } else {
    // the right edge
    edgeX = 1;
    edgeY = tan(angle);
  }

  // make it r wide, then turn it by rotation
  float squareX = r * edgeX;
  float squareY = r * edgeY;
  float x = centerX + squareX * cos(rotation) - squareY * sin(rotation);
  float y = centerY + squareY * cos(rotation) + squareX * sin(rotation);
  return new PVector(x, y);
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float rotation = 0.785;   // a diamond. Its corners
                               // go past the margin

     float rotation = 0.3;

   =========================================================== */
