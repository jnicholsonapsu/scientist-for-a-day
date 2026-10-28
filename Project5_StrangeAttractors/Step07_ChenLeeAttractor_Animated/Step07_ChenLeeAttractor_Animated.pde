/* ===========================================================
   STEP 7 — CHEN-LEE ATTRACTOR, ANIMATED
   ===========================================================

   Press PLAY and watch. This is the attractor from Step 7,
   drawn as one long line: the path of the dot. It slowly
   turns around all three directions, x, y and z, so you can
   see it from every side. The turning wanders at random,
   speeding up, slowing down and changing direction.

   THE VALUES YOU CAN CHANGE

     a, b, c           the three numbers in the equations
     dt                how much time passes each step
     warmUpSteps       how many steps the dot makes before
                       the path starts
     numberOfPoints    how many steps of the path are drawn
     turnSpeed         the fastest the attractor turns, in
                       radians each frame
     wanderSpeed       how quickly the turning changes
     lineColor         the color of the path
     lineOpacity       how see-through the path is, from 0
                       (invisible) to 255 (solid)
     paperColor        the color of the paper

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
float dt = 0.001;

int warmUpSteps = 20000;
int numberOfPoints = 30000;

float turnSpeed = 0.01;
float wanderSpeed = 0.003;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(100, 100,  20);   // olive

int lineOpacity = 120;
float lineThickness = 0.75;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
float[] pathX = new float[numberOfPoints];
float[] pathY = new float[numberOfPoints];
float[] pathZ = new float[numberOfPoints];

float zoom;
float angleX = 0;
float angleY = 0;
float angleZ = 0;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  // follow the dot, skipping the warm-up steps so it is on
  // the attractor
  float x = 1;
  float y = 1;
  float z = 1;
  for (int stepNumber = 0; stepNumber < warmUpSteps + numberOfPoints; stepNumber++) {
    float dxdt = a * x - y * z;
    float dydt = b * y + x * z;
    float dzdt = c * z + x * y / 3;
    x = x + dxdt * dt;
    y = y + dydt * dt;
    z = z + dzdt * dt;
    if (stepNumber >= warmUpSteps) {
      pathX[stepNumber - warmUpSteps] = x;
      pathY[stepNumber - warmUpSteps] = y;
      pathZ[stepNumber - warmUpSteps] = z;
    }
  }

  // move the path so its middle is at 0, 0, 0, the spot it
  // turns around
  float middleX = (min(pathX) + max(pathX)) / 2;
  float middleY = (min(pathY) + max(pathY)) / 2;
  float middleZ = (min(pathZ) + max(pathZ)) / 2;
  float farthest = 0;
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    pathX[pointNumber] = pathX[pointNumber] - middleX;
    pathY[pointNumber] = pathY[pointNumber] - middleY;
    pathZ[pointNumber] = pathZ[pointNumber] - middleZ;
    farthest = max(farthest, mag(pathX[pointNumber], pathY[pointNumber], pathZ[pointNumber]));
  }

  // big enough to fill the margins, but small enough to stay
  // inside them however it is turned
  zoom = (min(pageWidth, pageHeight) / 2 - pageMargin) / farthest;
}

void draw() {
  // Each turn speed wanders between -turnSpeed and turnSpeed.
  // noise() gives smooth random numbers between 0 and 1, and
  // each direction uses a different part of it
  angleX = angleX + turnSpeed * (2 * noise(frameCount * wanderSpeed, 0) - 1);
  angleY = angleY + turnSpeed * (2 * noise(frameCount * wanderSpeed, 100) - 1);
  angleZ = angleZ + turnSpeed * (2 * noise(frameCount * wanderSpeed, 200) - 1);

  background(paperColor);
  noFill();
  stroke(lineColor, lineOpacity);
  strokeWeight(lineThickness);

  beginShape();
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    float x = pathX[pointNumber];
    float y = pathY[pointNumber];
    float z = pathZ[pointNumber];

    float y1 = y * cos(angleX) - z * sin(angleX);
    float z1 = y * sin(angleX) + z * cos(angleX);

    float x2 = x * cos(angleY) + z1 * sin(angleY);

    float x3 = x2 * cos(angleZ) - y1 * sin(angleZ);
    float y3 = x2 * sin(angleZ) + y1 * cos(angleZ);

    vertex(centerX + zoom * x3, centerY - zoom * y3);
  }
  endShape();
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float turnSpeed = 0.03;      // turns faster

     float wanderSpeed = 0.02;    // changes direction more
                                  // often

     int numberOfPoints = 5000;   // a shorter path: fewer
                                  // loops

     float c = -0.6;              // a fuller attractor

   =========================================================== */
