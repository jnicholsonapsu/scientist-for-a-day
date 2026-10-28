/* ===========================================================
   STEP 3 — CURVE STITCHING, ANIMATED
   ===========================================================

   Press PLAY and watch. Point 1 (red) moves one dot at a
   time. Point 2 (green) moves two dots at a time. After each
   move, a line joins them. The lines build up a curve.

   =========================================================== */

// ---------- THE PAGE -------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE SHAPE ------------------------------------
float r = 250;           // radius of the circle
int numberOfPoints = 50;
int pointOneSpeed = 1;
int pointTwoSpeed = 2;

int framesPerLine = 40;  // lower this to make it draw faster
int pauseFrames = 180;   // how long the finished shape stays
                         // on screen before it starts again

// ---------- THE LOOK -------------------------------------
color paperColor = color(250, 247, 240);
color circleColor = color(150, 150, 150);
color dotColor = color(0, 0, 0);
color lineColor = color(40, 90, 170);
color newLineColor = color(230, 120, 30);
color pointOneColor = color(200, 60, 60);
color pointTwoColor = color(30, 140, 80);
color textColor = color(0, 0, 0);
float lineThickness = 1;
float newLineThickness = 3;
float dotSize = 5;
float pointSize = 14;
float labelSize = 18;
float labelGap = 20;     // how far a label sits outside the circle

// ---------- WORKED OUT FROM THE NUMBERS ABOVE ------------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;
int framesToMove = framesPerLine / 2;   // the rest of each step
                                        // shows the new line
int cycleFrames = numberOfPoints * framesPerLine + pauseFrames;

// ---------- THE DRAWING ----------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void draw() {
  background(paperColor);

  int frameInCycle = frameCount % cycleFrames;
  int stepNumber = min(frameInCycle / framesPerLine, numberOfPoints - 1);
  int frameInStep = frameInCycle - stepNumber * framesPerLine;
  boolean finished = frameInCycle >= numberOfPoints * framesPerLine;

  // how far along the points are, counted in steps. During the
  // first part of each step they slide from the last step's
  // dots to this step's dots
  float position = stepNumber;
  if (stepNumber > 0 && frameInStep < framesToMove && !finished) {
    position = stepNumber - 1 + (float) frameInStep / framesToMove;
  }
  boolean lineIsShowing = finished || stepNumber == 0 || frameInStep >= framesToMove;

  // the circle
  noFill();
  stroke(circleColor);
  strokeWeight(lineThickness);
  circle(centerX, centerY, 2 * r);

  // the lines from earlier steps
  stroke(lineColor);
  strokeWeight(lineThickness);
  int linesDone = finished ? numberOfPoints : stepNumber;
  for (int lineNumber = 0; lineNumber < linesDone; lineNumber++) {
    line(pointX(lineNumber, pointOneSpeed), pointY(lineNumber, pointOneSpeed),
         pointX(lineNumber, pointTwoSpeed), pointY(lineNumber, pointTwoSpeed));
  }

  // the dots
  noStroke();
  fill(dotColor);
  for (int dotNumber = 0; dotNumber < numberOfPoints; dotNumber++) {
    circle(pointX(dotNumber, 1), pointY(dotNumber, 1), dotSize);
  }

  if (finished) {
    return;
  }

  float pointOneX = pointX(position, pointOneSpeed);
  float pointOneY = pointY(position, pointOneSpeed);
  float pointTwoX = pointX(position, pointTwoSpeed);
  float pointTwoY = pointY(position, pointTwoSpeed);

  // the newest line
  if (lineIsShowing) {
    stroke(newLineColor);
    strokeWeight(newLineThickness);
    line(pointOneX, pointOneY, pointTwoX, pointTwoY);
  }

  // the two points, with their labels
  noStroke();
  fill(pointOneColor);
  circle(pointOneX, pointOneY, pointSize);
  fill(pointTwoColor);
  circle(pointTwoX, pointTwoY, pointSize);

  textSize(labelSize);
  textAlign(CENTER, CENTER);
  fill(pointOneColor);
  text("1", pointX(position, pointOneSpeed, r + labelGap), pointY(position, pointOneSpeed, r + labelGap));
  fill(pointTwoColor);
  text("2", pointX(position, pointTwoSpeed, r + labelGap), pointY(position, pointTwoSpeed, r + labelGap));

  // which dots the points are on
  int pointOneDot = stepNumber * pointOneSpeed % numberOfPoints;
  int pointTwoDot = stepNumber * pointTwoSpeed % numberOfPoints;
  fill(textColor);
  textAlign(CENTER, TOP);
  text("step " + stepNumber
       + ":   point 1 is on dot " + pointOneDot
       + ",   point 2 is on dot " + pointTwoDot,
       centerX, 60);
}

// Where a point with this speed is after this many steps
float pointX(float steps, int speed) {
  return pointX(steps, speed, r);
}

float pointY(float steps, int speed) {
  return pointY(steps, speed, r);
}

float pointX(float steps, int speed, float distance) {
  float theta = steps * TWO_PI / numberOfPoints * speed;
  return centerX + distance * cos(theta);
}

float pointY(float steps, int speed, float distance) {
  float theta = steps * TWO_PI / numberOfPoints * speed;
  return centerY + distance * sin(theta);
}
