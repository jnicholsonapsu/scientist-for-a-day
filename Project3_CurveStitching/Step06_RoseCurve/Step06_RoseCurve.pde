/* ===========================================================
   STEP 6 — ROSE CURVE
   ===========================================================

   This sketch draws a rose curve as one line.

   A rose curve is a curve with petals, like a flower.

   Press PLAY. You should get a flower with four petals.

   THE VALUES YOU CAN CHANGE

     k                 sets how many petals the rose has.
                       Odd numbers give k petals, even
                       numbers give 2 * k
     lineColor         the color of the line
     lineThickness     how thick the line is

   THE EQUATIONS

   A point on a rose:

       x = centerX + r * cos(k * theta) * cos(theta)
       y = centerY + r * cos(k * theta) * sin(theta)

         r     = how far the petals reach
         k     = sets how many petals there are
         theta = the angle around the rose

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
int k = 2;   // 4 petals. Odd numbers give k petals, even
             // numbers give 2 * k

int numberOfSides = 1000;   // how many short lines make up the curve

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(170,  30,  90);   // crimson
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

// Where a point at angle theta is on a rose of radius r
PVector shapePoint(float theta, float r) {
  float x = centerX + r * cos(k * theta) * cos(theta);
  float y = centerY + r * cos(k * theta) * sin(theta);
  return new PVector(x, y);
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     int k = 3;     // 3 petals

     int k = 5;

     int k = 4;

   =========================================================== */
