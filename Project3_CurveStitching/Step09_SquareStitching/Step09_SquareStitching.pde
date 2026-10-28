/* ===========================================================
   STEP 9 — SQUARE STITCHING
   ===========================================================

   Step 5's curve stitching, with both points going around
   the square from Step 8.

   Press PLAY. You should get a heart shape inside a square.

   THE VALUES YOU CAN CHANGE

     rotation          how far the square is turned
     pointOneSpeed     how many times point one goes around
     pointTwoSpeed     how many times point two goes around
     numberOfSamples   how many random spots to pick. More
                       samples make a smoother picture, but
                       take longer
     numberOfThreads   how many threads to use. It starts as
                       many as the CPU can run at once
     dotsPerInch       how sharp the picture is
     paperColor        the color of the paper
     primaryColor      the color where the most spots land

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

   A point on the line between point one and point two:

       x = (1 - u) * pointOne.x + u * pointTwo.x
       y = (1 - u) * pointOne.y + u * pointTwo.y

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
float rotation = 0;   // how far the square is turned

int pointOneSpeed = 1;   // how many times point one goes around
int pointTwoSpeed = 2;   // how many times point two goes around

int numberOfSamples = 10000000;   // how many random spots to pick

// as many threads as the CPU can run at once
int numberOfThreads = Runtime.getRuntime().availableProcessors();

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color primaryColor = color( 20, 110, 100);   // teal

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// radius of each point's shape, as big as fits inside the margins
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
  int startTime = millis();

  // start the threads, each with its share of the samples
  SampleThread[] threads = new SampleThread[numberOfThreads];
  for (int threadNumber = 0; threadNumber < numberOfThreads; threadNumber++) {
    threads[threadNumber] = new SampleThread(numberOfSamples / numberOfThreads);
    threads[threadNumber].start();
  }

  // wait for every thread to finish, then add its counts in
  for (int threadNumber = 0; threadNumber < numberOfThreads; threadNumber++) {
    try {
      threads[threadNumber].join();
    } catch (InterruptedException error) {
      println("A thread was stopped early");
    }
    for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
      counts[pixelNumber] += threads[threadNumber].counts[pixelNumber];
    }
  }

  println(numberOfThreads + " threads took " + (millis() - startTime) + " ms");

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

// One thread. It picks its own random spots and keeps its own
// counts, so it never has to wait for the other threads
class SampleThread extends Thread {
  int numberOfSamplesToPick;
  int[] counts = new int[pictureWidth * pictureHeight];
  java.util.Random randomNumbers = new java.util.Random();

  SampleThread(int numberOfSamplesToPick) {
    this.numberOfSamplesToPick = numberOfSamplesToPick;
  }

  public void run() {
    for (int sampleNumber = 0; sampleNumber < numberOfSamplesToPick; sampleNumber++) {
      float t = randomNumbers.nextFloat() * TWO_PI;

      PVector pointOne = shapePoint(t * pointOneSpeed, r1);
      PVector pointTwo = shapePoint(t * pointTwoSpeed, r2);

      float u = randomNumbers.nextFloat();
      float x = (1 - u) * pointOne.x + u * pointTwo.x;
      float y = (1 - u) * pointOne.y + u * pointTwo.y;

      int column = round(x * pixelsPerPoint);
      int row = round(y * pixelsPerPoint);
      counts[row * pictureWidth + column]++;
    }
  }
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

     float rotation = QUARTER_PI;   // a diamond. Its corners
                                    // go past the margin

     int pointOneSpeed = 2;
     int pointTwoSpeed = 5;

     int pointOneSpeed = 3;
     int pointTwoSpeed = 7;

   =========================================================== */
