/* ===========================================================
   STEP 1 — SUPERFORMULA 2D
   ===========================================================

   The superformula is one equation that can draw circles,
   squares, triangles, stars, flowers, leaves and shells, just
   by changing six numbers. Johan Gielis, a Belgian plant
   scientist, published it in 2003 to describe the shapes of
   plants and other things in nature.

   It works like a circle, except the radius r changes as you
   go around. For each angle phi, the superformula gives r,
   and the point is drawn that far from the center. Going all
   the way around draws the shape as one line.

   The drawing is made as big as fits inside the margins.

   Press PLAY. You should see a starfish. The picture is also
   saved as picture.pdf.

   THE VALUES YOU CAN CHANGE

     m                 how many times the pattern repeats
                       going around: the number of points or
                       bumps
     n1                how puffed out or pinched in the shape
                       is. Small values pinch it into spikes
     n2, n3            how rounded or sharp the bumps are.
                       Different values make lopsided bumps
     a, b              stretch every other bump. Keep them
                       at 1 to start. If m is odd, changing
                       them leaves a gap in the line
     numberOfPoints    how many points go around the shape
     paperColor        the color of the paper
     lineColor         the color of the line
     lineThickness     how thick the line is

   THE EQUATIONS

   The superformula:

       r = ( |cos(m * phi / 4) / a| ^ n2
           + |sin(m * phi / 4) / b| ^ n3 ) ^ (-1 / n1)

   |...| means the size of a number without its sign, and ^
   means "to the power of". In code, they are abs() and pow().

   A point on the shape, like a point on a circle:

       x = r * cos(phi)
       y = r * sin(phi)

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
float m = 5;
float n1 = 2;
float n2 = 7;
float n3 = 7;
float a = 1;
float b = 1;

int numberOfPoints = 2000;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(120,  20,  40);   // maroon
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
float[] shapeX = new float[numberOfPoints];
float[] shapeY = new float[numberOfPoints];

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  // work out every point, and how far the shape reaches
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    float phi = TWO_PI * pointNumber / numberOfPoints;
    float r = superformula(phi);
    shapeX[pointNumber] = r * cos(phi);
    shapeY[pointNumber] = r * sin(phi);
  }

  // as big as fits inside the margins, without stretching
  float zoom = min((pageWidth - 2 * pageMargin) / (max(shapeX) - min(shapeX)),
                   (pageHeight - 2 * pageMargin) / (max(shapeY) - min(shapeY)));
  float middleX = (min(shapeX) + max(shapeX)) / 2;
  float middleY = (min(shapeY) + max(shapeY)) / 2;

  beginRecord(PDF, "picture.pdf");

  background(paperColor);
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  // y goes up in the equations but down on the page, so it is
  // subtracted
  beginShape();
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    vertex(centerX + zoom * (shapeX[pointNumber] - middleX),
           centerY - zoom * (shapeY[pointNumber] - middleY));
  }
  endShape(CLOSE);

  endRecord();
}

// How far from the center the shape is at the angle phi
float superformula(float phi) {
  float cosinePart = pow(abs(cos(m * phi / 4) / a), n2);
  float sinePart = pow(abs(sin(m * phi / 4) / b), n3);
  return pow(cosinePart + sinePart, -1 / n1);
}

/* ===========================================================
   TRY THESE (change the numbers, press PLAY, see what's
   different):

     float m = 4;      // a circle: with m = 4 and all the
     float n1 = 2;     // n's at 2, the formula becomes the
     float n2 = 2;     // circle equation
     float n3 = 2;

     float m = 4;      // a rounded square
     float n1 = 12;
     float n2 = 15;
     float n3 = 15;

     float m = 3;      // a rounded triangle
     float n1 = 4.5;
     float n2 = 10;
     float n3 = 10;

     float m = 6;      // six thin petals
     float n1 = 1;
     float n2 = 7;
     float n3 = 8;

     float m = 16;     // a spiky sun
     float n1 = 0.5;
     float n2 = 0.5;
     float n3 = 16;

     float m = 2;      // a lens
     float n1 = 1;
     float n2 = 1;
     float n3 = 1;

     float m = 6;      // every other bump stretches, so six
     float n1 = 2;     // bumps become three big ones and
     float n2 = 7;     // three small ones
     float n3 = 7;
     float a = 2;

   =========================================================== */
