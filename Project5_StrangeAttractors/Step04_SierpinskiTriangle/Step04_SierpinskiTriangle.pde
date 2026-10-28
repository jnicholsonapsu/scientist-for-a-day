/* ===========================================================
   STEP 4 — THE SIERPINSKI TRIANGLE
   ===========================================================

   This sketch plays the chaos game from Step 3 two million
   times at once, and shows the finished picture.

   The picture is the Sierpinski triangle, named after the
   Polish mathematician Waclaw Sierpinski, who described it in
   1915. It is made of three smaller copies of itself, one at
   each corner. Each of those is made of three even smaller
   copies, and so on forever. A shape made of smaller copies
   of itself is called a fractal.

   The dot starts somewhere random and makes warmUpJumps
   jumps without leaving marks, so that it is on the triangle
   before any pixel is colored. After that, every pixel it
   lands on is colored by the corner it jumped toward.

   Press PLAY. The picture is also saved as picture.pdf.

   THE VALUES YOU CAN CHANGE

     numberOfCorners   how many corners there are
     jumpFraction      how much of the way to the corner the
                       dot jumps. Keep it between 0 and 1
     warmUpJumps       how many jumps the dot makes before
                       it starts coloring pixels
     numberOfJumps     how many times the dot jumps after that
     dotsPerInch       how many pixels per inch in the picture
     cornerColors      the colors of the pixels
     paperColor        the color of the paper

   THE RULE

   The dot is at x, y. Pick a corner at random. Call it
   cornerX, cornerY.

       x = x + jumpFraction * (cornerX - x)
       y = y + jumpFraction * (cornerY - y)

   The corners are spread evenly around a circle:

       cornerX = centerX + cornerRadius * cos(cornerAngle)
       cornerY = centerY + cornerRadius * sin(cornerAngle)

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

int dotsPerInch = 100;   // how many pixels per inch in the picture

// ---------- THE RULE ------------------------------------
int numberOfCorners = 3;
float jumpFraction = 0.5;
int warmUpJumps = 20;
int numberOfJumps = 2000000;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);

color[] cornerColors = {
  color( 40,  90, 170),   // blue
  color(200,  60,  60),   // red
  color( 30, 140,  80),   // green
  color(230, 120,  30),   // orange
  color(100,  50, 150),   // purple
  color( 20, 120, 110),   // teal
};

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;
float cornerRadius = min(pageWidth, pageHeight) / 2 - pageMargin;

// the picture's size in pixels. There are 72 points in an inch
float pixelsPerPoint = dotsPerInch / 72.0;
int pictureWidth = round(pageWidth * pixelsPerPoint);
int pictureHeight = round(pageHeight * pixelsPerPoint);

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  // The first corner is at the top
  float[] cornerX = new float[numberOfCorners];
  float[] cornerY = new float[numberOfCorners];
  for (int cornerNumber = 0; cornerNumber < numberOfCorners; cornerNumber++) {
    float cornerAngle = -HALF_PI + cornerNumber * TWO_PI / numberOfCorners;
    cornerX[cornerNumber] = centerX + cornerRadius * cos(cornerAngle);
    cornerY[cornerNumber] = centerY + cornerRadius * sin(cornerAngle);
  }

  PImage picture = createImage(pictureWidth, pictureHeight, RGB);
  picture.loadPixels();
  for (int pixelNumber = 0; pixelNumber < picture.pixels.length; pixelNumber++) {
    picture.pixels[pixelNumber] = paperColor;
  }

  // the warm-up jumps leave no marks
  float x = random(pageMargin, pageWidth - pageMargin);
  float y = random(pageMargin, pageHeight - pageMargin);
  for (int jumpNumber = 0; jumpNumber < warmUpJumps; jumpNumber++) {
    int corner = int(random(numberOfCorners));
    x = x + jumpFraction * (cornerX[corner] - x);
    y = y + jumpFraction * (cornerY[corner] - y);
  }

  // play the chaos game
  for (int jumpNumber = 0; jumpNumber < numberOfJumps; jumpNumber++) {
    int corner = int(random(numberOfCorners));
    x = x + jumpFraction * (cornerX[corner] - x);
    y = y + jumpFraction * (cornerY[corner] - y);

    int column = int(x * pixelsPerPoint);
    int row = int(y * pixelsPerPoint);
    picture.pixels[row * pictureWidth + column] = cornerColors[corner % cornerColors.length];
  }
  picture.updatePixels();

  beginRecord(PDF, "picture.pdf");
  image(picture, 0, 0, pageWidth, pageHeight);
  endRecord();
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     int numberOfJumps = 20000;     // only a few pixels: the
                                    // pattern is just starting

     int numberOfCorners = 4;       // a square. It fills in
                                    // with noise: no pattern

     int numberOfCorners = 4;       // four corner squares,
     float jumpFraction = 0.667;    // each made of four more

     int numberOfCorners = 5;       // a pentagon of pentagons
     float jumpFraction = 0.618;

     int numberOfCorners = 6;       // a hexagon of hexagons
     float jumpFraction = 0.667;

   =========================================================== */
