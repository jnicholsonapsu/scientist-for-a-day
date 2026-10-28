/* ===========================================================
   STEP 4 — MONTE CARLO
   ===========================================================

   Step 3 draws lines. With lots of lines, they overlap into
   stripes and blobs. This sketch draws no lines at all.
   Instead, it picks random spots on random lines, many
   thousands of times, and counts how often each pixel gets
   picked. The more often a pixel is picked, the darker it
   gets.

   Picking things at random, many times, to build up an
   answer is called a Monte Carlo method, after the casino.

   Press PLAY. You should get a speckled heart shape.

   THE VALUES YOU CAN CHANGE

     pointOneSpeed     how many times point one goes around
     pointTwoSpeed     how many times point two goes around
     numberOfSamples   how many random spots to pick. More
                       samples make a smoother picture, but
                       take longer
     dotsPerInch       how sharp the picture is
     paperColor        the color of the paper
     primaryColor      the color where the most spots land

   THE EQUATIONS

   A point on a circle:

       x = centerX + r * cos(t)
       y = centerY + r * sin(t)

   A point on the line between point one and point two:

       x = (1 - u) * pointOneX + u * pointTwoX
       y = (1 - u) * pointOneY + u * pointTwoY

         r = radius of the circle
         t = the angle around the circle
         u = how far along the line, from 0 (at point one)
             to 1 (at point two)

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

int dotsPerInch = 100;   // how many pixels per inch in the picture

// ---------- THE SHAPE -----------------------------------
int pointOneSpeed = 1;   // how many times point one goes around
int pointTwoSpeed = 2;   // how many times point two goes around

int numberOfSamples = 20000;   // how many random spots to pick

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color primaryColor = color(40, 90, 170);

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// radius of each point's circle, as big as fits inside the margins
float r1 = min(pageWidth, pageHeight) / 2 - pageMargin;
float r2 = r1;

// the picture's size in pixels. There are 72 points in an inch
float pixelsPerPoint = dotsPerInch / 72.0;
int pictureWidth = round(pageWidth * pixelsPerPoint);
int pictureHeight = round(pageHeight * pixelsPerPoint);

// how many times each pixel was picked
int[] counts = new int[pictureWidth * pictureHeight];

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  // pick the random spots, and count them
  for (int sampleNumber = 0; sampleNumber < numberOfSamples; sampleNumber++) {
    float t = random(TWO_PI);

    float pointOneTheta = t * pointOneSpeed;
    float pointTwoTheta = t * pointTwoSpeed;

    float pointOneX = centerX + r1 * cos(pointOneTheta);
    float pointOneY = centerY + r1 * sin(pointOneTheta);
    float pointTwoX = centerX + r2 * cos(pointTwoTheta);
    float pointTwoY = centerY + r2 * sin(pointTwoTheta);

    float u = random(1);
    float x = (1 - u) * pointOneX + u * pointTwoX;
    float y = (1 - u) * pointOneY + u * pointTwoY;

    int column = round(x * pixelsPerPoint);
    int row = round(y * pixelsPerPoint);
    counts[row * pictureWidth + column]++;
  }

  // find the biggest count
  int biggestCount = 0;
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    biggestCount = max(biggestCount, counts[pixelNumber]);
  }

  // color each pixel: paper where nothing landed, the line
  // color where the most landed, and in between for the rest
  PImage picture = createImage(pictureWidth, pictureHeight, RGB);
  picture.loadPixels();
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    float darkness = log(1 + counts[pixelNumber]) / log(1 + biggestCount);
    picture.pixels[pixelNumber] = lerpColor(paperColor, primaryColor, darkness);
  }
  picture.updatePixels();

  beginRecord(PDF, "picture.pdf");
  image(picture, 0, 0, pageWidth, pageHeight);
  endRecord();
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     int numberOfSamples = 200000;

     int numberOfSamples = 2000000;   // takes a few seconds

     int pointOneSpeed = 2;
     int pointTwoSpeed = 3;

     int pointOneSpeed = 3;
     int pointTwoSpeed = 5;

   =========================================================== */
