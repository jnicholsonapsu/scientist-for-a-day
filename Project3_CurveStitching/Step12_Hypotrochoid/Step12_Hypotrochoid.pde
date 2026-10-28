/* ===========================================================
   STEP 12 — HYPOTROCHOID
   ===========================================================

   This sketch draws a hypotrochoid as one line.

   As in Project 2, a circle rolls around the inside of a
   circle that stays still, and the pen is d from the center
   of the rolling circle. The shape is zoomed to fit inside
   the margins.

   Press PLAY. You should get five loops that meet in the
   middle.

   THE VALUES YOU CAN CHANGE

     R                 radius of the circle that stays still
     r                 radius of the circle that rolls inside
     d                 how far the pen is from the center of
                       the rolling circle. When d is the same
                       as r, the pen is on the edge, and the
                       shape is called a hypocycloid
     lineColor         the color of the line
     lineThickness     how thick the line is

   THE EQUATIONS

   A point on a hypotrochoid:

       x = centerX + zoom * ((R - r) * cos(theta) + d * cos((R - r) * theta / r))
       y = centerY + zoom * ((R - r) * sin(theta) - d * sin((R - r) * theta / r))

         R     = radius of the circle that stays still
         r     = radius of the circle that rolls inside it
         d     = how far the pen is from the center of the
                 rolling circle
         theta = the angle the rolling circle has traveled

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
int R = 5;   // radius of the circle that stays still
int r = 3;   // radius of the circle that rolls inside it
float d = 2;   // the pen's distance from the center of
               // the rolling circle

int numberOfSides = 1000;   // how many short lines make up the curve

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(190,  80,  20);   // burnt orange
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// reduce R / r to its smallest fraction. The shape closes
// after denominator trips around
int denominator = r / greatestCommonDivisor(R, r);

float shapeRadius = abs(R - r) + d;   // the farthest the shape
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
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  beginShape();
  for (int sideNumber = 0; sideNumber < numberOfSides * denominator; sideNumber++) {
    float theta = TWO_PI * sideNumber / numberOfSides;
    PVector point = shapePoint(theta);
    vertex(point.x, point.y);
  }
  endShape(CLOSE);

  endRecord();
}

// Where a point at angle theta is on the hypotrochoid
PVector shapePoint(float theta) {
  float x = centerX + zoom * ((R - r) * cos(theta) + d * cos((R - r) * theta / r));
  float y = centerY + zoom * ((R - r) * sin(theta) - d * sin((R - r) * theta / r));
  return new PVector(x, y);
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
   TRY THESE (change a value, press PLAY, see what's different):

     float d = 3;     // the same as r: a hypocycloid

     int r = 2;
     float d = 2;     // a hypocycloid with five points

     int R = 8;
     int r = 3;
     float d = 4;     // eight loops, three trips around

   =========================================================== */
