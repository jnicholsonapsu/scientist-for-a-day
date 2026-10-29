/* ===========================================================
   STEP 4 — SUPERFORMULA 3D, ANIMATED
   ===========================================================

   Press PLAY and watch. This is the 3D superformula from
   Steps 2 and 3, with two things happening at once, forever:

   Its twelve numbers slowly change, one at a time, like in
   Step 1's animation. Each time, one of the numbers is picked
   at random and drifts to a new random value, so you can
   watch the shape melt from one form into the next. An m
   only makes a closed shape when it is a whole number, so
   the m's always change to another whole number, and the old
   shape blends into the new one.

   Going around the shape, an odd m with a and b different
   leaves a crack where the surface meets back up with
   itself. So whenever the "around" a and b are different,
   the "around" m only changes to even numbers, and while the
   "around" m is odd, its a and b are left alone. Going from
   bottom to top never meets back up, so the "upDown" numbers
   can be anything.

   It slowly turns around all three directions, like Step 3,
   but on its own. The turning wanders at random, speeding
   up, slowing down and changing direction.

   The numbers being used are shown at the bottom of the
   page. If you see a shape you like, write them down and try
   them in Step 2 or 3.

   THE VALUES YOU CAN CHANGE

     aroundM, aroundN1,
     aroundN2, aroundN3,
     aroundA, aroundB        the "around" numbers to start
                             with, seen from the top
     upDownM, upDownN1,
     upDownN2, upDownN3,
     upDownA, upDownB        the "upDown" numbers to start
                             with, seen from the side
     biggestM                the biggest m it can change to
     smallestN               the smallest n it can change to
     biggestN                the biggest n it can change to
     smallestAB              the smallest a or b it can change
                             to
     biggestAB               the biggest a or b it can change
                             to
     framesPerChange         how many frames each change
                             takes. Lower is faster
     turnSpeed               the fastest the shape turns, in
                             radians each frame
     wanderSpeed             how quickly the turning changes
     drawAsSolid             false for a wire frame, true for
                             a solid
     gridSize                how many patches go each way
                             around the shape
     linesEvery              the wire frame has a line on
                             every linesEvery-th row and
                             column of patches
     paperColor              the color of the paper
     lineColor               the color of the wire frame
     lineThickness           how thick the wire frame is
     surfaceColor            the color of the solid where it
                             faces the light
     shadowColor             the color of the solid where it
                             faces away
     textColor               the color of the numbers at the
                             bottom

   THE EQUATIONS

   The superformula, from Step 1:

       r = ( |cos(m * angle / 4) / a| ^ n2
           + |sin(m * angle / 4) / b| ^ n3 ) ^ (-1 / n1)

   A point on the shape, from Step 2:

       x = r1 * cos(theta) * r2 * cos(phi)
       y = r1 * sin(theta) * r2 * cos(phi)
       z = r2 * sin(phi)

   While a number changes, each r is blended between the old
   and new values:

       r = lerp(oldR, newR, along)

   along goes from 0 to 1 as the change happens.

   With big n's, r can be too big or too small for the
   computer to hold, so the sketch works with log(r), like
   Step 1's animation, and scales r1 and r2 so their biggest
   values are 1. That doesn't change the shape.

   The turning works like Step 3: three arrows, across, up
   and away, keep track of how the shape is turned, and each
   turn moves two of them around the third.

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
float aroundM = 7;
float aroundN1 = 0.2;
float aroundN2 = 1.7;
float aroundN3 = 1.7;
float aroundA = 1;
float aroundB = 1;

float upDownM = 7;
float upDownN1 = 0.2;
float upDownN2 = 1.7;
float upDownN3 = 1.7;
float upDownA = 1;
float upDownB = 1;

int biggestM = 30;
float smallestN = 0.05;
float biggestN = 30;
float smallestAB = 0.05;
float biggestAB = 30;

int framesPerChange = 180;

float turnSpeed = 0.01;
float wanderSpeed = 0.003;

boolean drawAsSolid = true;

int gridSize = 120;
int linesEvery = 4;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color( 50,  70,  90);   // slate
float lineThickness = 0.5;

color surfaceColor = color(110, 160, 200);   // sky blue
color shadowColor = color( 20,  40,  70);    // dark navy

color textColor = color(0, 0, 0);

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
// How the shape is turned, as in Step 3. At the start, x goes
// across, z goes up and y goes away
PVector across = new PVector(1, 0, 0);
PVector up = new PVector(0, 0, 1);
PVector away = new PVector(0, 1, 0);

float zoom = 0;

int changingNumber = -1;   // which number is changing: 0 to 5
                           // are the "around" m, n1, n2, n3,
                           // a, b, and 6 to 11 the "upDown"
                           // ones
float changeFrom;
float changeTo;
int changeFrame = 0;

// every point of the grid over the surface, turned and
// flattened
PVector[][] points = new PVector[gridSize + 1][gridSize + 1];

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  textSize(10);

  // start a little turned and tilted, like Step 2
  turnArrows(across, away, 0.6);
  turnArrows(away, up, 0.5);

  startNextChange();
}

// Picks a different number at random to change, and where it
// drifts to
void startNextChange() {
  // While the "around" m is odd, the "around" a and b (4 and
  // 5) are skipped, so they can't make a crack
  boolean aroundMIsOdd = aroundM % 2 == 1;
  int lastNumber = changingNumber;
  while (changingNumber == lastNumber ||
         (aroundMIsOdd && (changingNumber == 4 || changingNumber == 5))) {
    changingNumber = int(random(12));
  }

  changeFrom = getValue(changingNumber);
  if (changingNumber == 0 || changingNumber == 6) {
    // a different whole number from 1 to biggestM. If the
    // "around" a and b are different, the "around" m must be
    // even
    boolean mustBeEven = changingNumber == 0 && aroundA != aroundB;
    changeTo = changeFrom;
    while (changeTo == changeFrom || (mustBeEven && changeTo % 2 == 1)) {
      changeTo = int(random(1, biggestM + 1));
    }
  } else if (changingNumber == 4 || changingNumber == 5 ||
             changingNumber == 10 || changingNumber == 11) {
    changeTo = random(smallestAB, biggestAB);
  } else {
    changeTo = random(smallestN, biggestN);
  }
  changeFrame = 0;
}

void draw() {
  // how far along the change is, from 0 to 1. The cosine
  // makes it start and stop gently
  changeFrame++;
  float along = (1 - cos(PI * changeFrame / framesPerChange)) / 2;

  // r1 for every theta and r2 for every phi, with the old
  // value and with the new one, then blended
  setValue(changingNumber, changeFrom);
  float[] oldAroundR = radii(true);
  float[] oldUpDownR = radii(false);
  setValue(changingNumber, changeTo);
  float[] newAroundR = radii(true);
  float[] newUpDownR = radii(false);

  // Each turn speed wanders between -turnSpeed and turnSpeed.
  // noise() gives smooth random numbers between 0 and 1, and
  // each direction uses a different part of it
  turnArrows(across, away, turnSpeed * (2 * noise(frameCount * wanderSpeed, 0) - 1));
  turnArrows(away, up, turnSpeed * (2 * noise(frameCount * wanderSpeed, 100) - 1));
  turnArrows(across, up, turnSpeed * (2 * noise(frameCount * wanderSpeed, 200) - 1));
  straightenArrows();

  // every point of the grid, and the farthest from the center
  float farthest = 0;
  for (int row = 0; row <= gridSize; row++) {
    float phi = -HALF_PI + PI * row / gridSize;
    float r2 = lerp(oldUpDownR[row], newUpDownR[row], along);
    for (int column = 0; column <= gridSize; column++) {
      float theta = -PI + TWO_PI * column / gridSize;
      float r1 = lerp(oldAroundR[column], newAroundR[column], along);
      float x = r1 * cos(theta) * r2 * cos(phi);
      float y = r1 * sin(theta) * r2 * cos(phi);
      float z = r2 * sin(phi);
      farthest = max(farthest, mag(x, y, z));

      float screenX = across.x * x + across.y * y + across.z * z;
      float screenY = up.x * x + up.y * y + up.z * z;
      float depth = away.x * x + away.y * y + away.z * z;
      points[row][column] = new PVector(screenX, screenY, depth);
    }
  }

  // Big enough to fill the margins, but small enough to stay
  // inside them however it is turned. It eases toward the new
  // zoom, so the size changes smoothly
  float newZoom = (min(pageWidth, pageHeight) / 2 - pageMargin) / farthest;
  if (zoom == 0) {
    zoom = newZoom;
  }
  zoom = lerp(zoom, newZoom, 0.1);
  zoom = min(zoom, newZoom);

  background(paperColor);
  if (drawAsSolid) {
    drawSolid();
  } else {
    drawWireFrame();
  }

  // the number shown for the changing one is partway between
  // its old and new values
  setValue(changingNumber, lerp(changeFrom, changeTo, along));
  fill(textColor);
  text("around:   m = " + nf(aroundM, 1, 2) + "   n1 = " + nf(aroundN1, 1, 2) +
       "   n2 = " + nf(aroundN2, 1, 2) + "   n3 = " + nf(aroundN3, 1, 2) +
       "   a = " + nf(aroundA, 1, 2) + "   b = " + nf(aroundB, 1, 2),
       pageMargin, pageHeight - 17);
  text("upDown:   m = " + nf(upDownM, 1, 2) + "   n1 = " + nf(upDownN1, 1, 2) +
       "   n2 = " + nf(upDownN2, 1, 2) + "   n3 = " + nf(upDownN3, 1, 2) +
       "   a = " + nf(upDownA, 1, 2) + "   b = " + nf(upDownB, 1, 2),
       pageMargin, pageHeight - 5);
  setValue(changingNumber, changeTo);

  if (changeFrame == framesPerChange) {
    startNextChange();
  }
}

// r1 for every theta (around is true) or r2 for every phi
// (around is false), scaled so the biggest is 1
float[] radii(boolean around) {
  float[] logR = new float[gridSize + 1];
  float biggestLogR = -Float.MAX_VALUE;
  for (int step = 0; step <= gridSize; step++) {
    if (around) {
      float theta = -PI + TWO_PI * step / gridSize;
      logR[step] = superformulaLogR(theta, aroundM, aroundN1, aroundN2, aroundN3, aroundA, aroundB);
    } else {
      float phi = -HALF_PI + PI * step / gridSize;
      logR[step] = superformulaLogR(phi, upDownM, upDownN1, upDownN2, upDownN3, upDownA, upDownB);
    }
    biggestLogR = max(biggestLogR, logR[step]);
  }

  float[] r = new float[gridSize + 1];
  for (int step = 0; step <= gridSize; step++) {
    r[step] = exp(logR[step] - biggestLogR);
  }
  return r;
}

// log(r) for an angle, worked out with logs like Step 1's
// animation, so numbers too big or too small for the computer
// never come up:
//
//     log(x ^ n) = n * log(x)
//     log(x + y) = log(x) + log(1 + y / x)
float superformulaLogR(float angle, float m, float n1, float n2, float n3, float a, float b) {
  float logCosinePart = n2 * log(abs(cos(m * angle / 4) / a));
  float logSinePart = n3 * log(abs(sin(m * angle / 4) / b));
  float bigger = max(logCosinePart, logSinePart);
  float smaller = min(logCosinePart, logSinePart);
  float logSum = bigger + log(1 + exp(smaller - bigger));
  return -logSum / n1;
}

// Where a flattened point goes on the page. Up on the page is
// a smaller pageY, so y is subtracted
float pageX(PVector point) {
  return centerX + zoom * point.x;
}

float pageY(PVector point) {
  return centerY - zoom * point.y;
}

// A line along every linesEvery-th row and column of the grid
void drawWireFrame() {
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  // going around, at one height
  for (int row = linesEvery / 2; row < gridSize; row = row + linesEvery) {
    beginShape();
    for (int column = 0; column <= gridSize; column++) {
      vertex(pageX(points[row][column]), pageY(points[row][column]));
    }
    endShape();
  }

  // going from bottom to top, at one angle around
  for (int column = 0; column < gridSize; column = column + linesEvery) {
    beginShape();
    for (int row = 0; row <= gridSize; row++) {
      vertex(pageX(points[row][column]), pageY(points[row][column]));
    }
    endShape();
  }
}

// The surface as shaded patches, drawn farthest first, as in
// Step 2
void drawSolid() {
  ArrayList<Patch> patches = new ArrayList<Patch>();
  for (int row = 0; row < gridSize; row++) {
    for (int column = 0; column < gridSize; column++) {
      patches.add(new Patch(points[row][column], points[row][column + 1],
                            points[row + 1][column + 1], points[row + 1][column]));
    }
  }
  java.util.Collections.sort(patches);

  // the light comes from behind you, up and to the left
  PVector light = new PVector(-1, 1, -0.7);
  light.normalize();

  for (Patch patch : patches) {
    PVector side1 = PVector.sub(patch.corners[1], patch.corners[0]);
    PVector side2 = PVector.sub(patch.corners[3], patch.corners[0]);
    PVector facing = side1.cross(side2);
    if (facing.mag() == 0) {
      continue;   // a patch squeezed to a line or a point
    }
    facing.normalize();
    if (facing.z > 0) {
      facing.mult(-1);
    }
    float brightness = max(0, facing.dot(light));
    color patchColor = lerpColor(shadowColor, surfaceColor, brightness);

    fill(patchColor);
    stroke(patchColor);
    strokeWeight(0.5);
    beginShape();
    for (int cornerNumber = 0; cornerNumber < 4; cornerNumber++) {
      vertex(pageX(patch.corners[cornerNumber]), pageY(patch.corners[cornerNumber]));
    }
    endShape(CLOSE);
  }
}

// One four-sided patch of the surface, as in Step 2
class Patch implements Comparable<Patch> {
  PVector[] corners;
  float distance;

  Patch(PVector corner1, PVector corner2, PVector corner3, PVector corner4) {
    corners = new PVector[] {corner1, corner2, corner3, corner4};
    distance = (corner1.z + corner2.z + corner3.z + corner4.z) / 4;
  }

  public int compareTo(Patch other) {
    return Float.compare(other.distance, distance);
  }
}

// Turns two of the arrows by an angle, around the third one
void turnArrows(PVector first, PVector second, float angle) {
  PVector newFirst = PVector.sub(PVector.mult(first, cos(angle)), PVector.mult(second, sin(angle)));
  PVector newSecond = PVector.add(PVector.mult(first, sin(angle)), PVector.mult(second, cos(angle)));
  first.set(newFirst);
  second.set(newSecond);
}

// Keeps the arrows 1 long and square to each other, as in
// Step 3
void straightenArrows() {
  across.normalize();
  away.sub(PVector.mult(across, away.dot(across)));
  away.normalize();
  up.set(across.cross(away));
}

// The value of number 0 to 11: the "around" m, n1, n2, n3, a,
// b, then the "upDown" ones
float getValue(int valueNumber) {
  if (valueNumber == 0) {
    return aroundM;
  } else if (valueNumber == 1) {
    return aroundN1;
  } else if (valueNumber == 2) {
    return aroundN2;
  } else if (valueNumber == 3) {
    return aroundN3;
  } else if (valueNumber == 4) {
    return aroundA;
  } else if (valueNumber == 5) {
    return aroundB;
  } else if (valueNumber == 6) {
    return upDownM;
  } else if (valueNumber == 7) {
    return upDownN1;
  } else if (valueNumber == 8) {
    return upDownN2;
  } else if (valueNumber == 9) {
    return upDownN3;
  } else if (valueNumber == 10) {
    return upDownA;
  } else {
    return upDownB;
  }
}

// Changes number 0 to 11
void setValue(int valueNumber, float value) {
  if (valueNumber == 0) {
    aroundM = value;
  } else if (valueNumber == 1) {
    aroundN1 = value;
  } else if (valueNumber == 2) {
    aroundN2 = value;
  } else if (valueNumber == 3) {
    aroundN3 = value;
  } else if (valueNumber == 4) {
    aroundA = value;
  } else if (valueNumber == 5) {
    aroundB = value;
  } else if (valueNumber == 6) {
    upDownM = value;
  } else if (valueNumber == 7) {
    upDownN1 = value;
  } else if (valueNumber == 8) {
    upDownN2 = value;
  } else if (valueNumber == 9) {
    upDownN3 = value;
  } else if (valueNumber == 10) {
    upDownA = value;
  } else {
    upDownB = value;
  }
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     boolean drawAsSolid = true;   // a shaded solid

     int framesPerChange = 60;     // faster changes

     float turnSpeed = 0.03;       // turns faster

     int biggestM = 8;             // fewer points and bumps

     float smallestN = 1;          // softer, rounder shapes
     float biggestN = 3;

     float smallestAB = 0.5;       // less lopsided shapes
     float biggestAB = 2;

   =========================================================== */
