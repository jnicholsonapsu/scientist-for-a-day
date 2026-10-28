/* ===========================================================
   STEP 2 — THREE PENDULUMS
   ===========================================================

   The classic harmonograph. Three pendulums hang through a
   table, and each one can swing in any direction, as in
   Step 1.

   Pendulums 1 and 2 each hold up an arm, and the two arms
   are hinged together at the pen, so both of them move the
   pen. Pendulum 3 holds up the paper. The line on the paper
   comes from all three moving at once.

   This models the harmonograph described here:

       https://www.karlsims.com/harmonograph/

   Press PLAY. You should get a woven, looping pattern that
   spirals in toward the middle. The picture is also saved as
   a PDF file, picture.pdf, in the sketch folder.

   Press R for a random machine. Press PLAY again to go back
   to the starting values.

   THE VALUES YOU CAN CHANGE

     f1, f2, f3        how many times each pendulum swings
                       each second. These matter most. When
                       one is close to, but not exactly, a
                       simple ratio with another, the curve
                       turns slowly as it dies down, which
                       weaves the mesh
     A1x, A1y, ...     how far each pendulum swings left and
                       right, and up and down. All the A's
                       are compared with each other, and the
                       drawing is zoomed to fit inside the
                       margin
     p1x, p1y, ...     where in its swing each pendulum
                       starts, left and right, and up and down
     d1, d2, ...       how fast each pendulum's swinging dies
                       down. Keep each between 0 and 1. 0.01
                       to 0.08 works well
     numberOfSteps     how many points to plot. More is finer
     timeStep          how much time passes between points
     inkColor          the color of the ink
     inkAlpha          how see-through the ink is
     lineThickness     how thick the line is

   THE EQUATIONS

       x = centerX + zoom * (A1x * sin(f1 * TWO_PI * t + p1x) * exp(-d1 * t)
                           + A2x * sin(f2 * TWO_PI * t + p2x) * exp(-d2 * t)
                           + A3x * sin(f3 * TWO_PI * t + p3x) * exp(-d3 * t))

       y = centerY + zoom * (A1y * sin(f1 * TWO_PI * t + p1y) * exp(-d1 * t)
                           + A2y * sin(f2 * TWO_PI * t + p2y) * exp(-d2 * t)
                           + A3y * sin(f3 * TWO_PI * t + p3y) * exp(-d3 * t))

         f = how many times a pendulum swings each second
         A = how far a pendulum swings
         p = where in its swing a pendulum starts
         d = how fast a pendulum's swinging dies down
         t = the time, in seconds
         zoom = how much the drawing is grown or shrunk to fit
                inside the margin

   Each pendulum has one f, because a pendulum swings at the
   same speed in every direction. Each one has its own d,
   because each one loses energy at its own rate. These
   equations are the simple version: they treat every swing
   as small.

   Each exp(-d * t) starts at 1 and shrinks toward 0 as time
   passes, so the drawing spirals inward. This is what a real
   pendulum does as it loses energy to friction.

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE PENDULUMS -------------------------------
// pendulum 1 moves the pen, through its arm
float f1 = 3;
float A1x = 1;
float A1y = 0.3;
float p1x = 0;
float p1y = 1.571;
float d1 = 0.02;   // how fast it dies down: 0 < d1 < 1

// pendulum 2 moves the pen, through its arm
float f2 = 2;
float A2x = 0.3;
float A2y = 1;
float p2x = 1.571;
float p2y = 0;
float d2 = 0.02;   // how fast it dies down: 0 < d2 < 1

// pendulum 3 moves the paper
float f3 = 2.01;
float A3x = 0.8;
float A3y = 0.8;
float p3x = 1.571;
float p3y = 0;
float d3 = 0.015;  // how fast it dies down: 0 < d3 < 1

int numberOfSteps = 60000;   // how many points to plot
float timeStep = 0.002;      // seconds between points

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color inkColor = color(43, 45, 66);   // dark slate
int inkAlpha = 90;   // how see-through the ink is. 20 is very
                     // faint, 255 is solid. Faint ink makes
                     // the places where lines cross darker
float lineThickness = 0.6;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// how much to grow or shrink the drawing so it reaches the
// margin, worked out by fitDrawing()
float zoom = fitDrawing();

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  beginRecord(PDF, "picture.pdf");

  background(paperColor);
  noFill();
  strokeWeight(lineThickness);
  stroke(inkColor, inkAlpha);

  float previousX = 0;
  float previousY = 0;

  for (int stepNumber = 0; stepNumber < numberOfSteps; stepNumber++) {
    float t = stepNumber * timeStep;
    float decay1 = exp(-d1 * t);
    float decay2 = exp(-d2 * t);
    float decay3 = exp(-d3 * t);

    float x = centerX + zoom * (A1x * sin(f1 * TWO_PI * t + p1x) * decay1
                              + A2x * sin(f2 * TWO_PI * t + p2x) * decay2
                              + A3x * sin(f3 * TWO_PI * t + p3x) * decay3);
    float y = centerY + zoom * (A1y * sin(f1 * TWO_PI * t + p1y) * decay1
                              + A2y * sin(f2 * TWO_PI * t + p2y) * decay2
                              + A3y * sin(f3 * TWO_PI * t + p3y) * decay3);

    if (stepNumber > 0) {
      line(previousX, previousY, x, y);
    }

    previousX = x;
    previousY = y;
  }

  endRecord();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    randomMachine();
    redraw();
  }
}

// Picks a random machine. The paper's frequency stays close
// to one of the pen's, which keeps the result readable
void randomMachine() {
  f1 = int(random(1, 5));
  f2 = int(random(1, 5));
  if (random(1) < 0.5) {
    f3 = f1 + random(-0.02, 0.02);
  } else {
    f3 = f2 + random(-0.02, 0.02);
  }
  A1x = random(0.2, 1);
  A1y = random(0.2, 1);
  A2x = random(0.2, 1);
  A2y = random(0.2, 1);
  A3x = random(0.4, 0.9);
  A3y = random(0.4, 0.9);
  p1x = random(TWO_PI);
  p1y = random(TWO_PI);
  p2x = random(TWO_PI);
  p2y = random(TWO_PI);
  p3x = random(TWO_PI);
  p3y = random(TWO_PI);
  zoom = fitDrawing();

  println("f1 = " + nf(f1, 1, 3) + "   f2 = " + nf(f2, 1, 3)
        + "   f3 = " + nf(f3, 1, 3));
}

// The drawing reaches at most A1x + A2x + A3x left and right
// of the center, and A1y + A2y + A3y above and below it. This
// works out the zoom that makes it reach the margin in
// whichever direction runs out of room first
float fitDrawing() {
  float zoomAcross = (pageWidth / 2 - pageMargin) / (abs(A1x) + abs(A2x) + abs(A3x));
  float zoomDown = (pageHeight / 2 - pageMargin) / (abs(A1y) + abs(A2y) + abs(A3y));
  return min(zoomAcross, zoomDown);
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     float f3 = 2;        // exactly the same as f2. The curve
                          // closes on itself and never turns

     float f3 = 3.01;     // close to f1 instead

     float A3x = 0;
     float A3y = 0;       // the paper stays still, so only the
                          // pen moves

     float A1y = 0;
     float A2x = 0;       // each pen pendulum only moves the
                          // pen one way

     float d1 = 0.008;
     float d2 = 0.008;
     float d3 = 0.008;    // a long, slow unwinding

     float d3 = 0.05;     // the paper stops early, and the
                          // pen finishes on its own

   =========================================================== */
