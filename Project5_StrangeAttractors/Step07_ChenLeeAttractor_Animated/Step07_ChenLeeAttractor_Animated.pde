/* ===========================================================
   STEP 7 — CHEN-LEE ATTRACTOR, ANIMATED
   ===========================================================

   Press PLAY and watch. This is the attractor from Step 7,
   drawn as one long line: the path of the dot. Two things
   happen at once:

   It slowly turns around all three directions, x, y and z,
   so you can see it from every side. The turning wanders at
   random, speeding up, slowing down and changing direction.

   Its numbers slowly change, one at a time: first a, then b,
   then c, then a again, and so on forever. Each number drifts
   to a new random value near where it started. The dot keeps
   moving the whole time, and its path slowly takes on the
   new shape. New values that make the attractor collapse or
   fly off to infinity are skipped.

   The numbers being used are shown at the bottom of the
   page. If you see a shape you like, write them down and try
   them in Step 7.

   THE VALUES YOU CAN CHANGE

     a, b, c           the three numbers to start with
     changeFraction    how far a number can drift from its
                       start. 0.05 is 5% of its starting
                       value
     framesPerChange   how many frames each change takes.
                       Lower is faster
     dt                how much time passes each step
     warmUpSteps       how many steps the dot makes before
                       the path starts
     numberOfPoints    how many steps of the path are drawn
     stepsPerFrame     how many new steps are added to the
                       path each frame. Higher is faster
     turnSpeed         the fastest the attractor turns, in
                       radians each frame
     wanderSpeed       how quickly the turning changes
     lineColor         the color of the path
     lineOpacity       how see-through the path is, from 0
                       (invisible) to 255 (solid)
     paperColor        the color of the paper
     textColor         the color of the numbers at the bottom

   THE EQUATIONS

   The path, from Step 7:

       dx/dt = a * x - y * z
       dy/dt = b * y + x * z
       dz/dt = c * z + x * y / 3

   Turning a point around x, then y, then z:

       y1 = y * cos(angleX) - z * sin(angleX)
       z1 = y * sin(angleX) + z * cos(angleX)

       x2 = x * cos(angleY) + z1 * sin(angleY)

       x3 = x2 * cos(angleZ) - y1 * sin(angleZ)
       y3 = x2 * sin(angleZ) + y1 * cos(angleZ)

   Then x3 is drawn across the page and y3 up the page. z is
   left out, which flattens the picture.

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
float a = 5;
float b = -10;
float c = -0.38;

float changeFraction = 0.05;
int framesPerChange = 600;

float dt = 0.001;
int warmUpSteps = 20000;
int numberOfPoints = 30000;
int stepsPerFrame = 100;

float turnSpeed = 0.01;
float wanderSpeed = 0.003;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(100, 100,  20);   // olive
color textColor = color(0, 0, 0);

int lineOpacity = 120;
float lineThickness = 0.75;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
float[] pathX = new float[numberOfPoints];
float[] pathY = new float[numberOfPoints];
float[] pathZ = new float[numberOfPoints];

int pathEnd = 0;   // where the newest point is. The path
                   // wraps around to the start
float x;
float y;
float z;
float zoom = 0;

float angleX = 0;
float angleY = 0;
float angleZ = 0;

// the numbers as they were at the start, so they never drift
// too far away
float[] startingValues = {a, b, c};

int changingNumber = -1;   // which number is changing: 0 is a,
                           // 1 is b, 2 is c
float changeFrom;
float changeTo;
int changeFrame = 0;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  textSize(10);
  startNextChange();
  startPath();
}

// Moves on to the next number, and picks where it drifts to.
// It tries up to 50 random values and keeps the first one
// that doesn't collapse or fly off to infinity
void startNextChange() {
  changingNumber = (changingNumber + 1) % 3;
  changeFrom = getValue(changingNumber);
  float startingValue = startingValues[changingNumber];
  for (int tryNumber = 0; tryNumber < 50; tryNumber++) {
    changeTo = startingValue + random(-1, 1) * changeFraction * abs(startingValue);
    setValue(changingNumber, changeTo);
    if (makesAPath()) {
      break;
    }
  }
  setValue(changingNumber, changeFrom);
  changeFrame = 0;
}

// A quick test of the numbers as they are now, using its own
// dot. Gives back false if that dot stops on a fixed point or
// flies off to infinity
boolean makesAPath() {
  float testX = 1;
  float testY = 1;
  float testZ = 1;
  float smallestX = 0;
  float biggestX = 0;
  for (int stepNumber = 0; stepNumber < warmUpSteps * 2; stepNumber++) {
    float dxdt = a * testX - testY * testZ;
    float dydt = b * testY + testX * testZ;
    float dzdt = c * testZ + testX * testY / 3;
    testX = testX + dxdt * dt;
    testY = testY + dydt * dt;
    testZ = testZ + dzdt * dt;

    // "Not less than" also catches a number becoming NaN (not
    // a number), which happens once they get too big
    if (!(abs(testX) + abs(testY) + abs(testZ) < 1000000)) {
      return false;
    }

    if (stepNumber == warmUpSteps) {
      smallestX = testX;
      biggestX = testX;
    }
    smallestX = min(smallestX, testX);
    biggestX = max(biggestX, testX);
  }

  // a path smaller than 0.01 across has stopped on a fixed
  // point
  return biggestX - smallestX > 0.01;
}

// Puts the dot at its starting spot, makes the warm-up steps,
// then fills the whole path
void startPath() {
  x = 1;
  y = 1;
  z = 1;
  for (int stepNumber = 0; stepNumber < warmUpSteps; stepNumber++) {
    step();
  }
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    step();
    addToPath();
  }
}

// Moves the dot a tiny bit along its path, with the numbers
// as they are now
void step() {
  float dxdt = a * x - y * z;
  float dydt = b * y + x * z;
  float dzdt = c * z + x * y / 3;
  x = x + dxdt * dt;
  y = y + dydt * dt;
  z = z + dzdt * dt;
}

// Puts the dot's spot at the newest end of the path, in place
// of the oldest
void addToPath() {
  pathEnd = (pathEnd + 1) % numberOfPoints;
  pathX[pathEnd] = x;
  pathY[pathEnd] = y;
  pathZ[pathEnd] = z;
}

void draw() {
  // drift the changing number a little. The cosine makes it
  // start and stop gently
  changeFrame++;
  float along = (1 - cos(PI * changeFrame / framesPerChange)) / 2;
  setValue(changingNumber, lerp(changeFrom, changeTo, along));
  if (changeFrame == framesPerChange) {
    startNextChange();
  }

  // Each turn speed wanders between -turnSpeed and turnSpeed.
  // noise() gives smooth random numbers between 0 and 1, and
  // each direction uses a different part of it
  angleX = angleX + turnSpeed * (2 * noise(frameCount * wanderSpeed, 0) - 1);
  angleY = angleY + turnSpeed * (2 * noise(frameCount * wanderSpeed, 100) - 1);
  angleZ = angleZ + turnSpeed * (2 * noise(frameCount * wanderSpeed, 200) - 1);

  // The dot keeps going, using the numbers as they are now.
  // Each frame adds stepsPerFrame new steps to the path and
  // drops the oldest ones, so the shape changes smoothly. If
  // the dot ever flies off to infinity, it starts over
  for (int stepNumber = 0; stepNumber < stepsPerFrame; stepNumber++) {
    step();
    addToPath();
  }
  if (!(abs(x) + abs(y) + abs(z) < 1000000)) {
    startPath();
  }

  background(paperColor);
  drawPath();

  fill(textColor);
  text("a = " + nf(a, 1, 3) + "   b = " + nf(b, 1, 3) + "   c = " + nf(c, 1, 3),
       pageMargin, pageHeight - 5);
}

// Turns the path, flattens it, and draws it as big as fits
// inside the margins however it is turned
void drawPath() {
  float middleX = (min(pathX) + max(pathX)) / 2;
  float middleY = (min(pathY) + max(pathY)) / 2;
  float middleZ = (min(pathZ) + max(pathZ)) / 2;
  float farthest = 0;
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    farthest = max(farthest, mag(pathX[pointNumber] - middleX,
                                 pathY[pointNumber] - middleY,
                                 pathZ[pointNumber] - middleZ));
  }

  // ease toward the new zoom, so the size changes smoothly
  float newZoom = (min(pageWidth, pageHeight) / 2 - pageMargin) / farthest;
  if (zoom == 0) {
    zoom = newZoom;
  }
  zoom = lerp(zoom, newZoom, 0.05);

  noFill();
  stroke(lineColor, lineOpacity);
  strokeWeight(lineThickness);

  // from the oldest point to the newest
  beginShape();
  for (int age = numberOfPoints - 1; age >= 0; age--) {
    int pointNumber = (pathEnd - age + numberOfPoints) % numberOfPoints;
    float pointX = pathX[pointNumber] - middleX;
    float pointY = pathY[pointNumber] - middleY;
    float pointZ = pathZ[pointNumber] - middleZ;

    float y1 = pointY * cos(angleX) - pointZ * sin(angleX);
    float z1 = pointY * sin(angleX) + pointZ * cos(angleX);

    float x2 = pointX * cos(angleY) + z1 * sin(angleY);

    float x3 = x2 * cos(angleZ) - y1 * sin(angleZ);
    float y3 = x2 * sin(angleZ) + y1 * cos(angleZ);

    vertex(centerX + zoom * x3, centerY - zoom * y3);
  }
  endShape();
}

// The value of a (0), b (1) or c (2)
float getValue(int valueNumber) {
  if (valueNumber == 0) {
    return a;
  } else if (valueNumber == 1) {
    return b;
  } else {
    return c;
  }
}

// Changes a (0), b (1) or c (2)
void setValue(int valueNumber, float value) {
  if (valueNumber == 0) {
    a = value;
  } else if (valueNumber == 1) {
    b = value;
  } else {
    c = value;
  }
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float changeFraction = 0.2;  // bigger changes

     int framesPerChange = 60;    // faster changes

     float turnSpeed = 0.03;      // turns faster

     float wanderSpeed = 0.02;    // changes direction more
                                  // often

     int numberOfPoints = 5000;   // a shorter path: fewer
                                  // loops

   =========================================================== */
