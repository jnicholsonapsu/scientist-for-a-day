/* ===========================================================
   STEP 11 — LEMNISCATE STITCHING
   ===========================================================

   Step 5's curve stitching, with both points going around
   the lemniscate from Step 10.

   Press PLAY. You should get a pattern around a sideways
   figure eight.

   THE VALUES YOU CAN CHANGE

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

   A point on a lemniscate:

       x = centerX + r * cos(theta) / (1 + sin(theta) * sin(theta))
       y = centerY + r * sin(theta) * cos(theta) / (1 + sin(theta) * sin(theta))

         r     = half the width of the lemniscate
         theta = how far around the lemniscate

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
int pointOneSpeed = 1;   // how many times point one goes around
int pointTwoSpeed = 2;   // how many times point two goes around

int numberOfSamples = 10000000;   // how many random spots to pick

// as many threads as the CPU can run at once
int numberOfThreads = Runtime.getRuntime().availableProcessors();

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color primaryColor = color(100,  50, 150);   // purple

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

// Where a point at angle theta is on a lemniscate of width
// 2 * r
PVector shapePoint(float theta, float r) {
  float x = centerX + r * cos(theta) / (1 + sin(theta) * sin(theta));
  float y = centerY + r * sin(theta) * cos(theta) / (1 + sin(theta) * sin(theta));
  return new PVector(x, y);
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     int pointOneSpeed = 2;
     int pointTwoSpeed = 3;

     int pointOneSpeed = 5;
     int pointTwoSpeed = 7;

   =========================================================== */
