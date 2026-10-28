/* ===========================================================
   STEP 2 — EPITROCHOID, ANIMATED
   ===========================================================

   Press PLAY and watch. This sketch shows how an
   epitrochoid is made: the blue circle rolls around the
   outside of the black circle, and the pen at the end of
   d draws the path.

   =========================================================== */

// ---------- THE PAGE -------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE SHAPE ------------------------------------
int R = 80;      // radius of the circle that stays still
int r = 64;      // radius of the circle that rolls around it
float d = 96;    // the pen's distance from the center of
                 // the rolling circle

int numberOfSides = 360;
int pointsPerFrame = 1;  // raise this to make it draw faster
int pauseFrames = 120;   // how long the finished shape stays
                         // on screen before it starts again

// ---------- THE LOOK -------------------------------------
color paperColor = color(250, 247, 240);
color stillCircleColor = color(0, 0, 0);
color rollingCircleColor = color(60, 140, 230);
color armColor = color(90, 90, 90);
color pathColor = color(40, 90, 170);
float circleThickness = 1.5;
float pathThickness = 2;
float dotSize = 7;
float labelSize = 18;
float labelGap = 14;     // how far a label sits from its line

// ---------- WORKED OUT FROM THE NUMBERS ABOVE ------------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// reduce R / r to its smallest fraction
int divisor = greatestCommonDivisor(R, r);
int denominator = r / divisor;
int totalPoints = numberOfSides * denominator;

// ---------- THE DRAWING ----------------------------------
PGraphics pathLayer;     // the path is kept here, so only the newest
                         // piece has to be drawn each frame
int pointsOnLayer = 0;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  pathLayer = createGraphics(pageWidth, pageHeight, P2D);
  pathLayer.smooth(8);
}

void draw() {
  background(paperColor);

  int framesToDraw = ceil((float) totalPoints / pointsPerFrame);
  int frameInCycle = frameCount % (framesToDraw + pauseFrames);
  int pointsSoFar = min(frameInCycle * pointsPerFrame, totalPoints);
  float t = TWO_PI * pointsSoFar / numberOfSides;

  // the path so far: clear it when a new cycle starts, then add
  // only the pieces that are new since the last frame
  pathLayer.beginDraw();
  if (pointsSoFar < pointsOnLayer || frameInCycle == 0) {
    pathLayer.clear();
    pointsOnLayer = 0;
  }
  pathLayer.stroke(pathColor);
  pathLayer.strokeWeight(pathThickness);
  for (int pointNumber = pointsOnLayer + 1; pointNumber <= pointsSoFar; pointNumber++) {
    float startT = TWO_PI * (pointNumber - 1) / numberOfSides;
    float endT = TWO_PI * pointNumber / numberOfSides;
    pathLayer.line(pathX(startT), pathY(startT), pathX(endT), pathY(endT));
  }
  pointsOnLayer = pointsSoFar;
  pathLayer.endDraw();
  image(pathLayer, 0, 0);

  noFill();

  // the circle that stays still
  stroke(stillCircleColor);
  strokeWeight(circleThickness);
  ellipse(centerX, centerY, 2 * R, 2 * R);

  // the rolling circle
  float rollingX = centerX + (R + r) * cos(t);
  float rollingY = centerY + (R + r) * sin(t);
  stroke(rollingCircleColor);
  ellipse(rollingX, rollingY, 2 * r, 2 * r);

  // R, from the center of the still circle to where the circles touch
  float touchX = centerX + R * cos(t);
  float touchY = centerY + R * sin(t);
  stroke(stillCircleColor);
  line(centerX, centerY, touchX, touchY);

  // r, from where the circles touch to the center of the rolling circle
  stroke(rollingCircleColor);
  line(touchX, touchY, rollingX, rollingY);

  // d, from the center of the rolling circle to the pen
  float penX = rollingX - d * cos((R + r) * t / r);
  float penY = rollingY - d * sin((R + r) * t / r);
  stroke(armColor);
  line(rollingX, rollingY, penX, penY);

  // the centers, and the pen
  noStroke();
  fill(stillCircleColor);
  ellipse(centerX, centerY, dotSize, dotSize);
  fill(rollingCircleColor);
  ellipse(rollingX, rollingY, dotSize, dotSize);
  fill(pathColor);
  ellipse(penX, penY, dotSize, dotSize);

  // the labels
  textSize(labelSize);
  textAlign(CENTER, CENTER);
  drawLabel("R", centerX, centerY, touchX, touchY, stillCircleColor);
  drawLabel("r", touchX, touchY, rollingX, rollingY, rollingCircleColor);
  drawLabel("d", rollingX, rollingY, penX, penY, armColor);
}

// Writes a label next to the middle of a line, off to one side
void drawLabel(String label, float startX, float startY, float endX, float endY, color labelColor) {
  float angle = atan2(endY - startY, endX - startX);
  float labelX = (startX + endX) / 2 - labelGap * sin(angle);
  float labelY = (startY + endY) / 2 + labelGap * cos(angle);
  fill(labelColor);
  text(label, labelX, labelY);
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

// Where the pen is at angle t
float pathX(float t) {
  return centerX + (R + r) * cos(t) - d * cos((R + r) * t / r);
}

float pathY(float t) {
  return centerY + (R + r) * sin(t) - d * sin((R + r) * t / r);
}
