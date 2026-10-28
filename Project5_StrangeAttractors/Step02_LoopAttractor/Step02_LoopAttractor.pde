/* ===========================================================
   STEP 2 — LOOP ATTRACTOR
   ===========================================================

   Press PLAY and watch. Each colored dot follows the same
   rule over and over:

       move part of the way toward a circle, and go around

   Dots that start near the middle move out. Dots that start
   far away move in. They all end up going around on the same
   circle. This time the attractor is not a point, it is a
   loop. The circle is never drawn: it shows up because
   that's where the dots end up.

   Every few seconds, new dots start in new random places.

   THE VALUES YOU CAN CHANGE

     numberOfDots      how many dots start at once
     circleRadius      the size of the circle the dots end up
                       on
     pull              how much of the way to the circle a dot
                       moves each step. Keep it between 0 and 1
     turnAngle         how far a dot goes around each step
     framesPerStep     how long each step takes. Lower is
                       faster
     stepsPerRun       how many steps before new dots start
     dotColors         the colors of the dots
     paperColor        the color of the paper

   THE RULE

   Each dot is a distance from the center, at an angle:

       distance = distance + pull * (circleRadius - distance)
       angle = angle + turnAngle

       x = centerX + distance * cos(angle)
       y = centerY + distance * sin(angle)

   When the dot is inside the circle, circleRadius - distance
   is positive and it moves out. When it is outside, it is
   negative and it moves in.

   To keep the trails smooth, each step is split into
   framesPerStep small moves, one each frame:

       pullPerFrame = 1 - (1 - pull) ^ (1 / framesPerStep)
       turnPerFrame = turnAngle / framesPerStep

   After framesPerStep small moves, the dot is exactly where
   one step of the rule puts it.

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE RULE ------------------------------------
int numberOfDots = 6;
float circleRadius = 180;
float pull = 0.1;
float turnAngle = 0.25;

int framesPerStep = 6;
int stepsPerRun = 80;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color centerColor = color(0, 0, 0);

color[] dotColors = {
  color( 40,  90, 170),   // blue
  color(200,  60,  60),   // red
  color( 30, 140,  80),   // green
  color(230, 120,  30),   // orange
  color(100,  50, 150),   // purple
  color( 20, 120, 110),   // teal
};

float dotSize = 10;
float trailThickness = 1.5;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;
float startRadius = min(pageWidth, pageHeight) / 2 - pageMargin;
float pullPerFrame = 1 - pow(1 - pull, 1.0 / framesPerStep);
float turnPerFrame = turnAngle / framesPerStep;

// ---------- THE DRAWING ---------------------------------
float[] dotDistance = new float[numberOfDots];
float[] dotAngle = new float[numberOfDots];
PGraphics trailLayer;    // the trails are kept here, so each
                         // frame only adds the newest piece
int framesDone = 0;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  trailLayer = createGraphics(pageWidth, pageHeight, P2D);
  trailLayer.smooth(8);
  startNewDots();
}

// Starts the dots anywhere inside a circle that fits the
// page: some inside circleRadius, some outside it
void startNewDots() {
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    dotDistance[dotNumber] = random(startRadius);
    dotAngle[dotNumber] = random(TWO_PI);
  }
  trailLayer.beginDraw();
  trailLayer.clear();
  trailLayer.endDraw();
  framesDone = 0;
}

void draw() {
  if (framesDone == stepsPerRun * framesPerStep) {
    startNewDots();
  } else {
    moveOneFrame();
  }

  background(paperColor);
  image(trailLayer, 0, 0);

  noStroke();
  fill(centerColor);
  circle(centerX, centerY, 4);

  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    fill(dotColors[dotNumber % dotColors.length]);
    circle(dotPositionX(dotNumber), dotPositionY(dotNumber), dotSize);
  }
}

// Moves every dot one small move, and draws its trail
void moveOneFrame() {
  trailLayer.beginDraw();
  trailLayer.strokeWeight(trailThickness);
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    float oldX = dotPositionX(dotNumber);
    float oldY = dotPositionY(dotNumber);

    float distance = dotDistance[dotNumber];
    dotDistance[dotNumber] = distance + pullPerFrame * (circleRadius - distance);
    dotAngle[dotNumber] = dotAngle[dotNumber] + turnPerFrame;

    trailLayer.stroke(dotColors[dotNumber % dotColors.length]);
    trailLayer.line(oldX, oldY, dotPositionX(dotNumber), dotPositionY(dotNumber));
  }
  trailLayer.endDraw();
  framesDone++;
}

float dotPositionX(int dotNumber) {
  return centerX + dotDistance[dotNumber] * cos(dotAngle[dotNumber]);
}

float dotPositionY(int dotNumber) {
  return centerY + dotDistance[dotNumber] * sin(dotAngle[dotNumber]);
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float pull = 0.02;           // a slow drift onto the
                                  // circle

     float pull = 0.9;            // onto the circle almost at
                                  // once

     float circleRadius = 50;     // a small loop

     float turnAngle = 0;         // no going around: each dot
                                  // stops on the circle, wherever
                                  // it reaches it

     float turnAngle = 2.1;       // fast around the circle

     float pull = 0;              // nothing pulls them, so each
                                  // dot stays on its own circle.
                                  // No attractor

   =========================================================== */
