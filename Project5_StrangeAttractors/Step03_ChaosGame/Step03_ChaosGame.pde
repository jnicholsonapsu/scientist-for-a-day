/* ===========================================================
   STEP 3 — THE CHAOS GAME
   ===========================================================

   Press PLAY and watch. There are three corners and one dot.
   The dot follows this rule over and over:

       pick a corner at random, and jump halfway to it

   Wherever the dot lands, it leaves a small colored mark. The line
   shows the last jump, and the corner it jumped toward is
   lit up. The game starts slowly, speeds up a little with
   each jump, and keeps going forever, one jump at a time.

   The corners are picked at random, so you might expect the
   marks to fill the triangle with noise. They
   don't. They make a pattern of triangles inside triangles.
   The dot jumps around that pattern forever, never settling
   down, but never leaving it. That pattern is a strange
   attractor.

   Each mark is colored by the corner the dot jumped toward.

   THE VALUES YOU CAN CHANGE

     numberOfCorners       how many corners there are
     jumpFraction          how much of the way to the corner
                           the dot jumps. Keep it between 0
                           and 1
     warmUpJumps           how many jumps the dot makes before
                           it starts leaving marks
     firstFramesPerJump    how long the first jump takes
     framesPerJump         how long each jump takes once it
                           has sped up. Lower is faster
     jumpsToSpeedUp        how many jumps it takes to speed up
     markSize              the size of the marks
     cornerColors          the colors of the marks
     paperColor            the color of the paper

   THE RULE

   The dot is at x, y. Pick a corner at random. Call it
   cornerX, cornerY.

       x = x + jumpFraction * (cornerX - x)
       y = y + jumpFraction * (cornerY - y)

   The corners are spread evenly around a circle:

       cornerX = centerX + cornerRadius * cos(cornerAngle)
       cornerY = centerY + cornerRadius * sin(cornerAngle)

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE RULE ------------------------------------
int numberOfCorners = 3;
float jumpFraction = 0.5;

int warmUpJumps = 20;
int firstFramesPerJump = 60;
int framesPerJump = 10;
int jumpsToSpeedUp = 30;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color jumpLineColor = color(0, 0, 0);
color cornerColor = color(0, 0, 0);

color[] cornerColors = {
  color( 40,  90, 170),   // blue
  color(200,  60,  60),   // red
  color( 30, 140,  80),   // green
  color(230, 120,  30),   // orange
  color(100,  50, 150),   // purple
  color( 20, 120, 110),   // teal
};

float markSize = 3;
float dotSize = 10;
float cornerSize = 12;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;
float cornerRadius = min(pageWidth, pageHeight) / 2 - pageMargin;

// ---------- THE DRAWING ---------------------------------
float[] cornerX = new float[numberOfCorners];
float[] cornerY = new float[numberOfCorners];
float x;
float y;
float oldX;
float oldY;
int lastCorner = -1;    // -1 means no corner picked yet
int jumpsDone = 0;
int framesUntilJump = 0;
PGraphics markLayer;    // the marks are kept here, so each
                        // frame only adds the newest one

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  // The first corner is at the top
  for (int cornerNumber = 0; cornerNumber < numberOfCorners; cornerNumber++) {
    float cornerAngle = -HALF_PI + cornerNumber * TWO_PI / numberOfCorners;
    cornerX[cornerNumber] = centerX + cornerRadius * cos(cornerAngle);
    cornerY[cornerNumber] = centerY + cornerRadius * sin(cornerAngle);
  }

  markLayer = createGraphics(pageWidth, pageHeight, P2D);
  markLayer.smooth(8);

  // The dot starts somewhere random, so its first few jumps
  // can land off the pattern. Each jump brings it closer to
  // the pattern, so after warmUpJumps it is on it. These jumps
  // leave no marks
  x = random(pageMargin, pageWidth - pageMargin);
  y = random(pageMargin, pageHeight - pageMargin);
  for (int jumpNumber = 0; jumpNumber < warmUpJumps; jumpNumber++) {
    int corner = int(random(numberOfCorners));
    x = x + jumpFraction * (cornerX[corner] - x);
    y = y + jumpFraction * (cornerY[corner] - y);
  }
  oldX = x;
  oldY = y;
}

void draw() {
  framesUntilJump--;
  if (framesUntilJump <= 0) {
    jump();
    jumpsDone++;

    // each jump waits a little less than the one before,
    // until the wait is framesPerJump
    float speedUpDone = min(jumpsDone / float(jumpsToSpeedUp), 1);
    framesUntilJump = round(lerp(firstFramesPerJump, framesPerJump, speedUpDone));
  }

  background(paperColor);
  image(markLayer, 0, 0);

  noStroke();
  for (int cornerNumber = 0; cornerNumber < numberOfCorners; cornerNumber++) {
    fill(cornerColor);
    if (cornerNumber == lastCorner) {
      fill(cornerColors[cornerNumber % cornerColors.length]);
    }
    circle(cornerX[cornerNumber], cornerY[cornerNumber], cornerSize);
  }

  // show the last jump
  stroke(jumpLineColor);
  strokeWeight(1);
  line(oldX, oldY, x, y);
  noStroke();
  fill(jumpLineColor);
  circle(x, y, dotSize);
}

// Makes the dot jump once, and leaves a mark where it lands
void jump() {
  int corner = int(random(numberOfCorners));
  oldX = x;
  oldY = y;
  x = x + jumpFraction * (cornerX[corner] - x);
  y = y + jumpFraction * (cornerY[corner] - y);

  markLayer.beginDraw();
  markLayer.noStroke();
  markLayer.fill(cornerColors[corner % cornerColors.length]);
  markLayer.circle(x, y, markSize);
  markLayer.endDraw();
  lastCorner = corner;
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     int numberOfCorners = 4;      // a square. The marks fill
                                   // it with noise: no pattern

     int numberOfCorners = 4;      // a square again, but with
     float jumpFraction = 0.667;   // longer jumps. Now there is
                                   // a pattern

     int numberOfCorners = 5;      // a pentagon of pentagons
     float jumpFraction = 0.618;

     int numberOfCorners = 6;      // a hexagon of hexagons
     float jumpFraction = 0.667;

     float jumpFraction = 0.3;     // short jumps: the triangles
                                   // overlap

     int jumpsToSpeedUp = 100;     // a longer, slower start

     int framesPerJump = 1;        // ends up as fast as it goes

     float markSize = 1;           // tiny marks: the pattern is
                                   // sharper, but takes longer
                                   // to show up

   =========================================================== */
