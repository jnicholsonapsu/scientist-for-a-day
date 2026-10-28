/* ===========================================================
   STEP 9 — EXTENDED HYPO, ANIMATED
   ===========================================================

   Press PLAY and watch. Circle B (blue) rolls around the
   inside of circle A (black), and circle C (green) rolls
   around the inside of B at the same time. The pen at the
   end of d draws the path.

   =========================================================== */

// ---------- THE PAGE -------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE SHAPE ------------------------------------
int R = 270;     // radius of circle A, which stays still
int r = 120;     // radius of circle B, which rolls inside A
int c = 30;      // radius of circle C, which rolls inside B
float d = 60;    // the pen's distance from the center of C

int numberOfSides = 360;
int pointsPerFrame = 1;  // raise this to make it draw faster
int pauseFrames = 120;   // how long the finished shape stays
                         // on screen before it starts again

// ---------- THE LOOK -------------------------------------
color paperColor = color(250, 247, 240);
color circleAColor = color(0, 0, 0);
color circleBColor = color(60, 140, 230);
color circleCColor = color(30, 140, 80);
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

// trips around for B, from R / r in its smallest fraction
int denominatorB = r / greatestCommonDivisor(R, r);
// trips around for C, from r / c in its smallest fraction
int denominatorC = c / greatestCommonDivisor(r, c);
// the smallest number of trips that finishes both
int numberOfTrips = denominatorB * denominatorC
                  / greatestCommonDivisor(denominatorB, denominatorC);
int totalPoints = numberOfSides * numberOfTrips;

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
  strokeWeight(circleThickness);

  // circle A, which stays still
  stroke(circleAColor);
  ellipse(centerX, centerY, 2 * R, 2 * R);

  // circle B
  float centerBX = centerX + (R - r) * cos(t);
  float centerBY = centerY + (R - r) * sin(t);
  stroke(circleBColor);
  ellipse(centerBX, centerBY, 2 * r, 2 * r);

  // circle C
  float angleC = (2 * r - R) * t / r;
  float centerCX = centerBX + (r - c) * cos(angleC);
  float centerCY = centerBY + (r - c) * sin(angleC);
  stroke(circleCColor);
  ellipse(centerCX, centerCY, 2 * c, 2 * c);

  // R, from the center of A to where A and B touch
  float touchX = centerX + R * cos(t);
  float touchY = centerY + R * sin(t);
  stroke(circleAColor);
  line(centerX, centerY, touchX, touchY);

  // r, from the center of B out to its edge, at a right angle
  // to the R line
  float radiusBEndX = centerBX - r * sin(t);
  float radiusBEndY = centerBY + r * cos(t);
  stroke(circleBColor);
  line(centerBX, centerBY, radiusBEndX, radiusBEndY);

  // the line from the center of B to the center of C
  line(centerBX, centerBY, centerCX, centerCY);

  // c, from the center of C out to its edge, at a right angle
  // to the line from B's center
  float radiusCEndX = centerCX - c * sin(angleC);
  float radiusCEndY = centerCY + c * cos(angleC);
  stroke(circleCColor);
  line(centerCX, centerCY, radiusCEndX, radiusCEndY);

  // d, from the center of C to the pen
  float penAngle = (R - r) * t / r + (r - c) * t / c;
  float penX = centerCX + d * cos(penAngle);
  float penY = centerCY - d * sin(penAngle);
  stroke(armColor);
  line(centerCX, centerCY, penX, penY);

  // the centers, and the pen
  noStroke();
  fill(circleAColor);
  ellipse(centerX, centerY, dotSize, dotSize);
  fill(circleBColor);
  ellipse(centerBX, centerBY, dotSize, dotSize);
  fill(circleCColor);
  ellipse(centerCX, centerCY, dotSize, dotSize);
  fill(pathColor);
  ellipse(penX, penY, dotSize, dotSize);

  // the labels
  textSize(labelSize);
  textAlign(CENTER, CENTER);
  drawLabel("R", centerX, centerY, touchX, touchY, circleAColor);
  drawLabel("r", centerBX, centerBY, radiusBEndX, radiusBEndY, circleBColor);
  drawLabel("c", centerCX, centerCY, radiusCEndX, radiusCEndY, circleCColor);
  drawLabel("d", centerCX, centerCY, penX, penY, armColor);
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
  return centerX + (R - r) * cos(t)
                 + (r - c) * cos((2 * r - R) * t / r)
                 + d * cos((R - r) * t / r + (r - c) * t / c);
}

float pathY(float t) {
  return centerY + (R - r) * sin(t)
                 + (r - c) * sin((2 * r - R) * t / r)
                 - d * sin((R - r) * t / r + (r - c) * t / c);
}
