/* ===========================================================
   STEP 1 — SUPERFORMULA 2D, ANIMATED
   ===========================================================

   Press PLAY and watch. This draws the superformula from
   Step 1 over and over, while its six numbers slowly change,
   one at a time, forever. Each time, one of the numbers is
   picked at random and drifts to a new random value, so you
   can watch the shape melt from one form into the next.

   m only makes a closed shape when it is a whole number, so
   m always changes to another whole number. While it
   changes, the old shape blends into the new one.

   When a and b are different and m is odd, going around once
   leaves a gap in the line. Going around twice always closes
   it, so this sketch goes around twice.

   The numbers being used are shown at the bottom of the
   page. If you see a shape you like, write them down and try
   them in Step 1.

   Each frame, the drawing is made as big as fits inside the
   margins.

   THE VALUES YOU CAN CHANGE

     m, n1, n2, n3,
     a, b              the numbers to start with
     biggestM          the biggest m it can change to
     smallestN         the smallest n1, n2 or n3 it can
                       change to
     biggestN          the biggest n1, n2 or n3 it can change
                       to
     smallestAB        the smallest a or b it can change to
     biggestAB         the biggest a or b it can change to
     framesPerChange   how many frames each change takes.
                       Lower is faster
     numberOfPoints    how many points go around the shape
     paperColor        the color of the paper
     lineColor         the color of the line
     lineThickness     how thick the line is
     textColor         the color of the numbers at the bottom

   THE EQUATIONS

   The superformula, from Step 1:

       r = ( |cos(m * phi / 4) / a| ^ n2
           + |sin(m * phi / 4) / b| ^ n3 ) ^ (-1 / n1)

       x = r * cos(phi)
       y = r * sin(phi)

   While a number changes, r is blended between the old and
   new values:

       r = lerp(oldR, newR, along)

   along goes from 0 to 1 as the change happens.

   With big n's or small a's and b's, r can be too big or too
   small for the computer to hold, so the sketch works with
   log(r) instead, and scales each shape so its farthest
   point is 1. That doesn't change the shape, and the drawing
   is made to fit the margins anyway.

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
float m = 5;
float n1 = 2;
float n2 = 7;
float n3 = 7;
float a = 1;
float b = 1;

int biggestM = 30;
float smallestN = 0.05;
float biggestN = 30;
float smallestAB = 0.05;
float biggestAB = 30;

int framesPerChange = 180;
int numberOfPoints = 4000;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(120,  20,  40);   // maroon
color textColor = color(0, 0, 0);
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
float[] shapeX = new float[numberOfPoints];
float[] shapeY = new float[numberOfPoints];
float[] oldLogR = new float[numberOfPoints];
float[] newLogR = new float[numberOfPoints];

int changingNumber = -1;   // which number is changing: 0 is m,
                           // 1 is n1, 2 is n2, 3 is n3,
                           // 4 is a, 5 is b
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
}

// Picks a different number at random to change, and where it
// drifts to
void startNextChange() {
  int lastNumber = changingNumber;
  while (changingNumber == lastNumber) {
    changingNumber = int(random(6));
  }

  changeFrom = getValue(changingNumber);
  if (changingNumber == 0) {
    // a different whole number from 1 to biggestM
    changeTo = changeFrom;
    while (changeTo == changeFrom) {
      changeTo = int(random(1, biggestM + 1));
    }
  } else if (changingNumber <= 3) {
    changeTo = random(smallestN, biggestN);
  } else {
    changeTo = random(smallestAB, biggestAB);
  }
  changeFrame = 0;
}

void draw() {
  // how far along the change is, from 0 to 1. The cosine
  // makes it start and stop gently
  changeFrame++;
  float along = (1 - cos(PI * changeFrame / framesPerChange)) / 2;

  // work out log(r) for every point, for the shape with the
  // old value and the shape with the new one
  setValue(changingNumber, changeFrom);
  float biggestOldLogR = -Float.MAX_VALUE;
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    oldLogR[pointNumber] = superformulaLogR(pointPhi(pointNumber));
    biggestOldLogR = max(biggestOldLogR, oldLogR[pointNumber]);
  }
  setValue(changingNumber, changeTo);
  float biggestNewLogR = -Float.MAX_VALUE;
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    newLogR[pointNumber] = superformulaLogR(pointPhi(pointNumber));
    biggestNewLogR = max(biggestNewLogR, newLogR[pointNumber]);
  }

  // Scale both shapes so their farthest point is 1. That
  // doesn't change their shapes, and turns log(r) back into a
  // number that fits. Then blend the old shape into the new one
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    float oldR = exp(oldLogR[pointNumber] - biggestOldLogR);
    float newR = exp(newLogR[pointNumber] - biggestNewLogR);
    float r = lerp(oldR, newR, along);
    float phi = pointPhi(pointNumber);
    shapeX[pointNumber] = r * cos(phi);
    shapeY[pointNumber] = r * sin(phi);
  }

  // as big as fits inside the margins, without stretching
  float zoom = min((pageWidth - 2 * pageMargin) / (max(shapeX) - min(shapeX)),
                   (pageHeight - 2 * pageMargin) / (max(shapeY) - min(shapeY)));
  float middleX = (min(shapeX) + max(shapeX)) / 2;
  float middleY = (min(shapeY) + max(shapeY)) / 2;

  background(paperColor);
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  beginShape();
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    vertex(centerX + zoom * (shapeX[pointNumber] - middleX),
           centerY - zoom * (shapeY[pointNumber] - middleY));
  }
  endShape(CLOSE);

  // the number shown for the changing one is partway between
  // its old and new values
  setValue(changingNumber, lerp(changeFrom, changeTo, along));
  fill(textColor);
  text("m = " + nf(m, 1, 2) + "   n1 = " + nf(n1, 1, 2) +
       "   n2 = " + nf(n2, 1, 2) + "   n3 = " + nf(n3, 1, 2) +
       "   a = " + nf(a, 1, 2) + "   b = " + nf(b, 1, 2),
       pageMargin, pageHeight - 5);
  setValue(changingNumber, changeTo);

  if (changeFrame == framesPerChange) {
    startNextChange();
  }
}

// The angle phi for a point. It goes around twice
float pointPhi(int pointNumber) {
  return 2 * TWO_PI * pointNumber / numberOfPoints;
}

// log(r) for the angle phi. This is the superformula, worked
// out with logs, using these rules:
//
//     log(x ^ n) = n * log(x)
//     log(x + y) = log(x) + log(1 + y / x)
//
// so that numbers too big or too small for the computer never
// come up
float superformulaLogR(float phi) {
  float logCosinePart = n2 * log(abs(cos(m * phi / 4) / a));
  float logSinePart = n3 * log(abs(sin(m * phi / 4) / b));
  float bigger = max(logCosinePart, logSinePart);
  float smaller = min(logCosinePart, logSinePart);
  float logSum = bigger + log(1 + exp(smaller - bigger));
  return -logSum / n1;
}

// The value of m (0), n1 (1), n2 (2), n3 (3), a (4) or b (5)
float getValue(int valueNumber) {
  if (valueNumber == 0) {
    return m;
  } else if (valueNumber == 1) {
    return n1;
  } else if (valueNumber == 2) {
    return n2;
  } else if (valueNumber == 3) {
    return n3;
  } else if (valueNumber == 4) {
    return a;
  } else {
    return b;
  }
}

// Changes m (0), n1 (1), n2 (2), n3 (3), a (4) or b (5)
void setValue(int valueNumber, float value) {
  if (valueNumber == 0) {
    m = value;
  } else if (valueNumber == 1) {
    n1 = value;
  } else if (valueNumber == 2) {
    n2 = value;
  } else if (valueNumber == 3) {
    n3 = value;
  } else if (valueNumber == 4) {
    a = value;
  } else {
    b = value;
  }
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     int framesPerChange = 60;    // faster changes

     int biggestM = 8;            // fewer points and bumps

     float smallestN = 1;         // softer, rounder shapes
     float biggestN = 3;

     float smallestAB = 0.5;      // less lopsided shapes
     float biggestAB = 2;

   =========================================================== */
