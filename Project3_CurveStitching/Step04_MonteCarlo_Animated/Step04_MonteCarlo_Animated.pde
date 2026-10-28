/* ===========================================================
   STEP 4 — MONTE CARLO, ANIMATED
   ===========================================================

   Press PLAY and watch. The first few samples go slowly:
   pick a random angle t, find point 1 and point 2, then pick
   a random spot u along the line between them and count it.
   Then it speeds up, and the counts build up the picture.

   =========================================================== */

// ---------- THE PAGE -------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE SHAPE ------------------------------------
float r = 270;           // radius of the circle
int pointOneSpeed = 1;
int pointTwoSpeed = 2;

int slowSamples = 8;           // how many samples to show one at a time
int framesPerSample = 90;      // how long each slow sample takes
int speedUp = 8;               // how fast the samples per frame grow
int mostSamplesPerFrame = 20000;
int totalSamples = 1000000;
int pauseFrames = 240;         // how long the finished picture stays
                               // on screen before it starts again

// ---------- THE LOOK -------------------------------------
color paperColor = color(250, 247, 240);
color circleColor = color(150, 150, 150);
color primaryColor = color(40, 90, 170);
color sampleLineColor = color(150, 150, 150);
color spotColor = color(230, 120, 30);
color pointOneColor = color(200, 60, 60);
color pointTwoColor = color(30, 140, 80);
color textColor = color(0, 0, 0);
float pointSize = 14;
float spotSize = 8;
float labelSize = 18;
float labelGap = 20;     // how far a label sits outside the circle

// ---------- WORKED OUT FROM THE NUMBERS ABOVE ------------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ----------------------------------
int[] counts = new int[pageWidth * pageHeight];
int biggestCount = 0;
int samplesDone = 0;
PImage picture;
boolean pictureIsOutOfDate = false;

// the slow samples
float t;
float u;
int frameInSample = 0;
float[] spotX = new float[slowSamples];
float[] spotY = new float[slowSamples];

// the fast samples
int fastFrame = 0;
int pauseFramesLeft = 0;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  picture = createImage(pageWidth, pageHeight, RGB);
  startOver();
}

void startOver() {
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    counts[pixelNumber] = 0;
  }
  biggestCount = 0;
  samplesDone = 0;
  frameInSample = 0;
  fastFrame = 0;
  pictureIsOutOfDate = true;
}

void draw() {
  if (pauseFramesLeft > 0) {
    pauseFramesLeft--;
    if (pauseFramesLeft == 0) {
      startOver();
    }
  } else if (samplesDone >= slowSamples) {
    int samplesThisFrame = min((fastFrame + 1) * speedUp, mostSamplesPerFrame);
    samplesThisFrame = min(samplesThisFrame, totalSamples - samplesDone);
    for (int sampleNumber = 0; sampleNumber < samplesThisFrame; sampleNumber++) {
      float sampleT = random(TWO_PI);
      float sampleU = random(1);
      addCount(spotX(sampleT, sampleU), spotY(sampleT, sampleU));
    }
    fastFrame++;
    if (samplesDone >= totalSamples) {
      pauseFramesLeft = pauseFrames;
    }
  }

  if (pictureIsOutOfDate) {
    updatePicture();
  }

  background(paperColor);
  image(picture, 0, 0);

  noFill();
  stroke(circleColor);
  strokeWeight(1);
  circle(centerX, centerY, 2 * r);

  textSize(labelSize);
  if (samplesDone < slowSamples && pauseFramesLeft == 0) {
    drawSlowSample();
  } else {
    fill(textColor);
    textAlign(CENTER, TOP);
    text(nfc(samplesDone) + " samples", centerX, 40);
  }
}

// One sample, shown in three parts: the two points and their
// line, then the spot sliding along to u, then the spot held
void drawSlowSample() {
  if (frameInSample == 0) {
    t = random(TWO_PI);
    u = random(1);
  }
  int partLength = framesPerSample / 3;

  // the spots from earlier samples
  noStroke();
  fill(spotColor);
  for (int spotNumber = 0; spotNumber < samplesDone; spotNumber++) {
    circle(spotX[spotNumber], spotY[spotNumber], spotSize);
  }

  float pointOneX = centerX + r * cos(t * pointOneSpeed);
  float pointOneY = centerY + r * sin(t * pointOneSpeed);
  float pointTwoX = centerX + r * cos(t * pointTwoSpeed);
  float pointTwoY = centerY + r * sin(t * pointTwoSpeed);

  stroke(sampleLineColor);
  strokeWeight(1.5);
  line(pointOneX, pointOneY, pointTwoX, pointTwoY);

  noStroke();
  fill(pointOneColor);
  circle(pointOneX, pointOneY, pointSize);
  fill(pointTwoColor);
  circle(pointTwoX, pointTwoY, pointSize);

  textAlign(CENTER, CENTER);
  fill(pointOneColor);
  text("1", centerX + (r + labelGap) * cos(t * pointOneSpeed),
            centerY + (r + labelGap) * sin(t * pointOneSpeed));
  fill(pointTwoColor);
  text("2", centerX + (r + labelGap) * cos(t * pointTwoSpeed),
            centerY + (r + labelGap) * sin(t * pointTwoSpeed));

  // the spot slides from point 1 to u
  String caption = "sample " + (samplesDone + 1) + ":   t = " + nf(t, 1, 2);
  if (frameInSample >= partLength) {
    float slide = min(1, (float) (frameInSample - partLength) / partLength);
    float shownU = u * slide;
    fill(spotColor);
    circle(spotX(t, shownU), spotY(t, shownU), spotSize);
    caption += ",   u = " + nf(shownU, 1, 2);
  }
  fill(textColor);
  textAlign(CENTER, TOP);
  text(caption, centerX, 40);

  frameInSample++;
  if (frameInSample == framesPerSample) {
    spotX[samplesDone] = spotX(t, u);
    spotY[samplesDone] = spotY(t, u);
    addCount(spotX(t, u), spotY(t, u));
    frameInSample = 0;
  }
}

void addCount(float x, float y) {
  int pixelNumber = round(y) * pageWidth + round(x);
  counts[pixelNumber]++;
  biggestCount = max(biggestCount, counts[pixelNumber]);
  samplesDone++;
  pictureIsOutOfDate = true;
}

void updatePicture() {
  picture.loadPixels();
  float logOfBiggest = log(1 + biggestCount);
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    float darkness = 0;
    if (counts[pixelNumber] > 0) {
      darkness = log(1 + counts[pixelNumber]) / logOfBiggest;
    }
    picture.pixels[pixelNumber] = lerpColor(paperColor, primaryColor, darkness);
  }
  picture.updatePixels();
  pictureIsOutOfDate = false;
}

// Where the spot u of the way along the line at angle t is
float spotX(float t, float u) {
  float pointOneX = centerX + r * cos(t * pointOneSpeed);
  float pointTwoX = centerX + r * cos(t * pointTwoSpeed);
  return (1 - u) * pointOneX + u * pointTwoX;
}

float spotY(float t, float u) {
  float pointOneY = centerY + r * sin(t * pointOneSpeed);
  float pointTwoY = centerY + r * sin(t * pointTwoSpeed);
  return (1 - u) * pointOneY + u * pointTwoY;
}
