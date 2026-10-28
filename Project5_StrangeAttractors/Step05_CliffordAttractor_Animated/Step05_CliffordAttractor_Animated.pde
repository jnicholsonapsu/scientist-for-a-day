/* ===========================================================
   STEP 5 — CLIFFORD ATTRACTOR, ANIMATED
   ===========================================================

   Press PLAY and watch. This draws the attractor from Step 5
   over and over, while its numbers slowly change, one at a
   time: first a, then b, then c, then d, then a again, and so
   on forever. Each number drifts to a new random value near
   where it started, so you can watch the shape grow, twist
   and melt into new shapes. New values that make the
   attractor collapse are skipped, but on the way to a new
   value it can still collapse for a moment, and the page
   goes almost blank.

   The numbers being used are shown at the bottom of the
   page. If you see a shape you like, write them down and try
   them in Step 5.

   Each frame, the drawing is made as big as fits inside the
   margins, and the pixels are colored the same way as in
   Step 5.

   THE VALUES YOU CAN CHANGE

     a, b, c, d        the four numbers to start with
     changeSize        how far from its start a number can
                       drift
     framesPerChange   how many frames each change takes.
                       Lower is faster
     jumpsPerFrame     how many jumps are drawn each frame.
                       More is smoother, but slower
     paperColor        the color of the paper
     pointColor        the color where the dot lands most
     textColor         the color of the numbers at the bottom

   THE EQUATIONS

   The dot is at x, y. Its next spot is:

       newX = sin(a * y) + c * cos(a * x)
       newY = sin(b * x) + d * cos(b * y)

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
float a = -1.4;
float b = 1.6;
float c = 1.0;
float d = 0.7;

float changeSize = 0.5;
int framesPerChange = 240;
int jumpsPerFrame = 200000;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color pointColor = color(110,  60,  20);   // dark brown
color textColor = color(0, 0, 0);

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
// the numbers as they were at the start, so they never drift
// more than changeSize away
float[] startingValues = {a, b, c, d};

int changingNumber = -1;   // which number is changing: 0 is a,
                           // 1 is b, and so on
float changeFrom;
float changeTo;
int changeFrame = 0;

int[] counts = new int[pageWidth * pageHeight];
float x;
float y;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
}

void setup() {
  textSize(10);
  startNextChange();
}

// Moves on to the next number, and picks where it drifts to.
// Some values make the attractor collapse, so it tries up to
// 50 random values and keeps the first one that doesn't
void startNextChange() {
  changingNumber = (changingNumber + 1) % 4;
  changeFrom = getValue(changingNumber);
  for (int tryNumber = 0; tryNumber < 50; tryNumber++) {
    changeTo = startingValues[changingNumber] + random(-changeSize, changeSize);
    setValue(changingNumber, changeTo);
    if (isStrange()) {
      break;
    }
  }
  setValue(changingNumber, changeFrom);
  changeFrame = 0;
}

// A quick test: follows the dot for 5000 jumps on a rough
// 100 by 100 grid from -4 to 4. A collapsed attractor only
// lands in a few squares. A strange one lands in many
boolean isStrange() {
  boolean[] landedOn = new boolean[100 * 100];
  int squaresLandedOn = 0;
  startDot();
  for (int jumpNumber = 0; jumpNumber < 5000; jumpNumber++) {
    jump();
    int column = constrain(int((x + 4) / 8 * 100), 0, 99);
    int row = constrain(int((y + 4) / 8 * 100), 0, 99);
    if (!landedOn[row * 100 + column]) {
      landedOn[row * 100 + column] = true;
      squaresLandedOn++;
    }
  }
  return squaresLandedOn > 200;
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

  background(paperColor);
  drawAttractor();

  fill(textColor);
  text("a = " + nf(a, 1, 3) + "   b = " + nf(b, 1, 3) +
       "   c = " + nf(c, 1, 3) + "   d = " + nf(d, 1, 3),
       pageMargin, pageHeight - 5);
}

// Draws the attractor the same way as Step 5, at one pixel per
// point
void drawAttractor() {
  // First run: find how far the attractor reaches
  startDot();
  float smallestX = x;
  float biggestX = x;
  float smallestY = y;
  float biggestY = y;
  for (int jumpNumber = 0; jumpNumber < jumpsPerFrame / 10; jumpNumber++) {
    jump();
    smallestX = min(smallestX, x);
    biggestX = max(biggestX, x);
    smallestY = min(smallestY, y);
    biggestY = max(biggestY, y);
  }

  // the attractor collapsed to a fixed point: nothing to draw
  if (biggestX == smallestX || biggestY == smallestY) {
    return;
  }

  float zoom = min((pageWidth - 2 * pageMargin) / (biggestX - smallestX),
                   (pageHeight - 2 * pageMargin) / (biggestY - smallestY));
  float middleX = (smallestX + biggestX) / 2;
  float middleY = (smallestY + biggestY) / 2;

  // Second run: count the pixels the dot lands on. The first
  // run was shorter, so a few spots can land outside the
  // page. Those are skipped
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    counts[pixelNumber] = 0;
  }
  startDot();
  int biggestCount = 0;
  for (int jumpNumber = 0; jumpNumber < jumpsPerFrame; jumpNumber++) {
    jump();
    int column = int(centerX + zoom * (x - middleX));
    int row = int(centerY + zoom * (y - middleY));
    if (column >= 0 && column < pageWidth && row >= 0 && row < pageHeight) {
      int pixelNumber = row * pageWidth + column;
      counts[pixelNumber]++;
      biggestCount = max(biggestCount, counts[pixelNumber]);
    }
  }

  loadPixels();
  for (int pixelNumber = 0; pixelNumber < counts.length; pixelNumber++) {
    if (counts[pixelNumber] > 0) {
      float darkness = log(1 + counts[pixelNumber]) / log(1 + biggestCount);
      pixels[pixelNumber] = lerpColor(paperColor, pointColor, darkness);
    }
  }
  updatePixels();
}

// Puts the dot at its starting spot, then makes 100 warm-up
// jumps, so it is on the attractor before anything is counted
void startDot() {
  x = 0.1;
  y = 0.1;
  for (int jumpNumber = 0; jumpNumber < 100; jumpNumber++) {
    jump();
  }
}

// Moves the dot to its next spot
void jump() {
  float newX = sin(a * y) + c * cos(a * x);
  float newY = sin(b * x) + d * cos(b * y);
  x = newX;
  y = newY;
}

// The value of a (0), b (1), c (2) or d (3)
float getValue(int valueNumber) {
  if (valueNumber == 0) {
    return a;
  } else if (valueNumber == 1) {
    return b;
  } else if (valueNumber == 2) {
    return c;
  } else {
    return d;
  }
}

// Changes a (0), b (1), c (2) or d (3)
void setValue(int valueNumber, float value) {
  if (valueNumber == 0) {
    a = value;
  } else if (valueNumber == 1) {
    b = value;
  } else if (valueNumber == 2) {
    c = value;
  } else {
    d = value;
  }
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float changeSize = 1.5;      // wilder changes. On the way
                                  // to a new value, the
                                  // attractor can collapse for
                                  // a moment

     int framesPerChange = 60;    // faster changes

     int jumpsPerFrame = 50000;   // grainier, but smoother
                                  // motion on a slow computer

   =========================================================== */
