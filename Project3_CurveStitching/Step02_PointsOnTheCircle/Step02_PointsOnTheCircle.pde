/* ===========================================================
   STEP 2 — POINTS ON THE CIRCLE
   ===========================================================

   Step 1, with small black dots spaced evenly around the
   circle.

   Add the lines marked below, then press PLAY.

   You should get the thin blue circle with 100 black dots
   on it.

   THE EQUATIONS

   A point on a circle:

       x = centerX + r * cos(t)
       y = centerY + r * sin(t)

         r = radius of the circle
         t = the angle around the circle

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
int numberOfSides = 360;

// *************************
// ***** ADD THIS LINE *****
// *************************
int numberOfPoints = 100;   // how many dots go around the circle

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(40, 90, 170);
float lineThickness = 1;

// ***************************
// ***** ADD THESE LINES *****
// ***************************
color dotColor = color(0, 0, 0);
float dotSize = 4;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;
// radius of the circle, as big as fits inside the margins
float r = min(pageWidth, pageHeight) / 2 - pageMargin;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // one pixel for every point on the page
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  background(paperColor);
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  beginShape();
  for (int sideNumber = 0; sideNumber < numberOfSides; sideNumber++) {
    float t = TWO_PI * sideNumber / numberOfSides;

    float x = centerX + r * cos(t);
    float y = centerY + r * sin(t);

    vertex(x, y);
  }
  endShape(CLOSE);

  // ***************************
  // ***** ADD THESE LINES *****
  // ***************************
  noStroke();
  fill(dotColor);

  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    float t = TWO_PI / numberOfPoints * pointNumber;

    float x = centerX + r * cos(t);
    float y = centerY + r * sin(t);

    circle(x, y, dotSize);
  }
}

/* ===========================================================
   Notes:

   SPACING THE DOTS

       float t = TWO_PI / numberOfPoints * pointNumber;

   TWO_PI / numberOfPoints is the angle between one dot and
   the next. With 100 points, that is a hundredth of a full
   turn. Dot number 0 is at angle 0, dot number 1 is one
   step around, dot number 2 is two steps around, and so on.

   This is the same equation as the circle, so every dot
   lands exactly on the line.

   noStroke() AND fill()

       The dots are filled in with dotColor and have no
       outline.

   circle(x, y, dotSize)

       Draws a circle centered at (x, y). dotSize is how wide
       it is.

   TRY THESE (change a line, press PLAY, see what's different):

     int numberOfPoints = 10;    // easy to count

     int numberOfPoints = 360;   // one for every degree

     float dotSize = 10;         // bigger dots

   =========================================================== */
