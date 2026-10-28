/* ===========================================================
   STEP 14 — LISSAJOUS
   ===========================================================

   This sketch draws a Lissajous curve as one line.

   A Lissajous curve is what you get when x and y each swing
   back and forth, at different speeds. It fills a rectangle
   instead of a circle, so it can use the whole page.

   Press PLAY. With delta = 0.785 the curve doubles back on
   itself, so it looks like an open curve with its ends in
   the top corners.

   THE VALUES YOU CAN CHANGE

     a                 how many times it swings left and right
     b                 how many times it swings up and down
     delta             how far ahead the left-right swing
                       starts
     lineColor         the color of the line
     lineThickness     how thick the line is

   THE EQUATIONS

   A point on a Lissajous curve:

       x = centerX + A * sin(a * theta + delta)
       y = centerY + B * sin(b * theta)

         A     = how far it swings left and right
         B     = how far it swings up and down
         a     = how many times it swings left and right
         b     = how many times it swings up and down
         delta = how far ahead the left-right swing starts
         theta = how far along the curve

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
int a = 3;   // swings left and right
int b = 2;   // swings up and down
float delta = 0.785;   // an eighth of a turn ahead

int numberOfSides = 1000;   // how many short lines make up the curve

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color( 40, 110,  50);   // green
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// as wide and as tall as fits inside the margins
float A = pageWidth / 2 - pageMargin;
float B = pageHeight / 2 - pageMargin;

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
    PVector point = shapePoint(theta);
    vertex(point.x, point.y);
  }
  endShape(CLOSE);

  endRecord();
}

// Where a point at angle theta is on the Lissajous curve
PVector shapePoint(float theta) {
  float x = centerX + A * sin(a * theta + delta);
  float y = centerY + B * sin(b * theta);
  return new PVector(x, y);
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float delta = 0;

     float delta = 0.5;     // the curve opens up into loops

     int a = 5;
     int b = 4;

     int a = 1;
     int b = 2;

   =========================================================== */
