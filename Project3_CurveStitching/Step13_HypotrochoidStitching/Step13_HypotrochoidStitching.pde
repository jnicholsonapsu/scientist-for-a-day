/* ===========================================================
   STEP 13 — HYPOTROCHOID STITCHING
   ===========================================================

   Step 5's curve stitching, with both points going around
   the hypotrochoid from Step 12.

   Press PLAY. You should get a pattern around five loops.

   THE VALUES YOU CAN CHANGE

     R                 radius of the circle that stays still
     r                 radius of the circle that rolls inside
     d                 how far the pen is from the center of
                       the rolling circle. When d is the same
                       as r, the pen is on the edge, and the
                       shape is called a hypocycloid
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

   A point on a hypotrochoid:

       x = centerX + zoom * ((R - r) * cos(theta) + d * cos((R - r) * theta / r))
       y = centerY + zoom * ((R - r) * sin(theta) - d * sin((R - r) * theta / r))

         R     = radius of the circle that stays still
         r     = radius of the circle that rolls inside it
         d     = how far the pen is from the center of the
                 rolling circle
         theta = the angle the rolling circle has traveled

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
int R = 5;   // radius of the circle that stays still
int r = 3;   // radius of the circle that rolls inside it
float d = 2;   // the pen's distance from the center of
               // the rolling circle

int pointOneSpeed = 1;   // how many times point one goes around
int pointTwoSpeed = 2;   // how many times point two goes around

int numberOfSamples = 10000000;   // how many random spots to pick

// as many threads as the CPU can run at once
int numberOfThreads = Runtime.getRuntime().availableProcessors();

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color primaryColor = color(190,  80,  20);   // burnt orange

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
      float t = randomNumbers.nextFloat() * TWO_PI * denominator;

      PVector pointOne = shapePoint(t * pointOneSpeed);
      PVector pointTwo = shapePoint(t * pointTwoSpeed);

      float u = randomNumbers.nextFloat();
      float x = (1 - u) * pointOne.x + u * pointTwo.x;
      float y = (1 - u) * pointOne.y + u * pointTwo.y;

      int column = round(x * pixelsPerPoint);
      int row = round(y * pixelsPerPoint);
      counts[row * pictureWidth + column]++;
    }
  }
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

     int pointOneSpeed = 2;
     int pointTwoSpeed = 3;

     int pointOneSpeed = 3;
     int pointTwoSpeed = 5;

   =========================================================== */
