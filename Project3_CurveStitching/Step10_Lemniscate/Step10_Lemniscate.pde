/* ===========================================================
   STEP 10 — LEMNISCATE
   ===========================================================

   This sketch draws a lemniscate as one line.

   A lemniscate is a figure eight lying on its side, like
   the infinity sign.

   Press PLAY. You should get a sideways figure eight.

   THE VALUES YOU CAN CHANGE

     lineColor         the color of the line
     lineThickness     how thick the line is

   THE EQUATIONS

   A point on a lemniscate:

       x = centerX + r * cos(theta) / (1 + sin(theta) * sin(theta))
       y = centerY + r * sin(theta) * cos(theta) / (1 + sin(theta) * sin(theta))

         r     = half the width of the lemniscate
         theta = how far around the lemniscate

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
int numberOfSides = 1000;   // how many short lines make up the curve

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(100,  50, 150);   // purple
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

// Where a point at angle theta is on a lemniscate of width
// 2 * r
PVector shapePoint(float theta, float r) {
  float x = centerX + r * cos(theta) / (1 + sin(theta) * sin(theta));
  float y = centerY + r * sin(theta) * cos(theta) / (1 + sin(theta) * sin(theta));
  return new PVector(x, y);
}
