/* ===========================================================
   STEP 1 — POINT ATTRACTOR
   ===========================================================

   Press PLAY and watch. Each colored dot follows the same
   rule over and over:

       move a little closer to the center, and turn a little

   The dots start in different places, but they all spiral in
   to the same place: the small black dot in the center. That
   center point is called an attractor. No matter where a dot
   starts, it ends up at the center.

   Every few seconds, new dots start in new random places.

   THE VALUES YOU CAN CHANGE

     numberOfDots      how many dots start at once
     shrinkFactor      how much of its distance from the
                       center a dot keeps each step. 0.9
                       keeps 90%. Keep it between 0 and 1
     turnAngle         how far a dot turns around the center
                       each step
     framesPerStep     how long each step takes. Lower is
                       faster
     stepsPerRun       how many steps before new dots start
     dotColors         the colors of the dots
     paperColor        the color of the paper

   THE RULE

       x = centerX + shrinkFactor * ((x - centerX) * cos(turnAngle)
                                   - (y - centerY) * sin(turnAngle))

       y = centerY + shrinkFactor * ((y - centerY) * cos(turnAngle)
                                   + (x - centerX) * sin(turnAngle))

   The x and y on the right are the dot's old position. The
   x and y on the left are its new one.

   To keep the trails smooth, each step is split into
   framesPerStep small moves, one each frame:

       shrinkPerFrame = shrinkFactor ^ (1 / framesPerStep)
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
float shrinkFactor = 0.9;
float turnAngle = 0.3;

int framesPerStep = 10;
int stepsPerRun = 50;

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
float shrinkPerFrame = pow(shrinkFactor, 1.0 / framesPerStep);
float turnPerFrame = turnAngle / framesPerStep;

// ---------- THE DRAWING ---------------------------------
float[] dotX = new float[numberOfDots];
float[] dotY = new float[numberOfDots];
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
// page, so that turning never takes them off the page
void startNewDots() {
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    float distance = random(startRadius);
    float angle = random(TWO_PI);
    dotX[dotNumber] = centerX + distance * cos(angle);
    dotY[dotNumber] = centerY + distance * sin(angle);
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
    circle(dotX[dotNumber], dotY[dotNumber], dotSize);
  }
}

// Moves every dot one small move, and draws its trail
void moveOneFrame() {
  trailLayer.beginDraw();
  trailLayer.strokeWeight(trailThickness);
  for (int dotNumber = 0; dotNumber < numberOfDots; dotNumber++) {
    float x = dotX[dotNumber];
    float y = dotY[dotNumber];

    float newX = centerX + shrinkPerFrame * ((x - centerX) * cos(turnPerFrame)
                                           - (y - centerY) * sin(turnPerFrame));
    float newY = centerY + shrinkPerFrame * ((y - centerY) * cos(turnPerFrame)
                                           + (x - centerX) * sin(turnPerFrame));

    trailLayer.stroke(dotColors[dotNumber % dotColors.length]);
    trailLayer.line(x, y, newX, newY);

    dotX[dotNumber] = newX;
    dotY[dotNumber] = newY;
  }
  trailLayer.endDraw();
  framesDone++;
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float shrinkFactor = 0.98;   // a slow, wide spiral

     float shrinkFactor = 0.5;    // straight in, almost at once

     float turnAngle = 0;         // no turning: each dot goes
                                  // straight to the center

     float turnAngle = 2.5;       // big turns: the dots whirl
                                  // around fast on the way in

     float shrinkFactor = 1;      // nothing pulls them in, so
                                  // they go around in circles
                                  // forever. No attractor

     float shrinkFactor = 1.05;   // pushed out instead of in.
                                  // The dots fly off the page

   =========================================================== */
