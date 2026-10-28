/* ===========================================================
   STEP 1 — A CIRCLE OF LINES
   ===========================================================

   This step draws a circle as a path of 360 short straight
   lines, one for each degree.

   The file is in four parts:
     - the page:    its size and margin
     - the shape:   the numbers you change to get a new shape
     - the look:    colors and line thickness
     - the drawing: settings(), setup() and draw()

   Type the code below, then press PLAY.

   You should get a blue circle outline on cream paper.

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

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(40, 90, 170);
float lineThickness = 1;

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
}

/* ===========================================================
   Notes:

   HOW THE FILE IS ARRANGED

   Everything you might want to change is at the top, outside
   any function. Those variables can be used anywhere in the
   file.

   The variables under WORKED OUT FROM THE NUMBERS ABOVE are
   calculated from the ones before them. Processing fills in
   these variables from top to bottom, so each one can only
   use the lines above it.

   settings(), setup() AND draw()

   settings() runs first. size() has to go here, because it
   uses the variables pageWidth and pageHeight instead of
   plain numbers.

   setup() runs next. noLoop() tells Processing to run draw()
   only once, since the picture doesn't move.

   draw() does the drawing.

   pageMargin

   72 / 4.0 is 18 points, a quarter of an inch. Writing 4.0
   instead of 4 makes sure the answer is a decimal number.

   THE RADIUS

       float r = min(pageWidth, pageHeight) / 2 - pageMargin;

   min() gives the smaller of two numbers. Half the narrow
   side of the page, less the margin, is the biggest circle
   that fits.

   pageWidth AND pageHeight

   Processing has its own width and height, but they are not
   set until size() runs, which is too late for the variables
   at the top of the file.

   noFill();
       Draw shapes with no color inside, so only the outline
       shows.

   stroke(lineColor);
       The color of the lines.

   strokeWeight(lineThickness);
       How thick the lines are.

   beginShape(), vertex() AND endShape(CLOSE)

       beginShape() starts a path. Each vertex(x, y) adds a
       point, and a straight line joins it to the point
       before. endShape(CLOSE) finishes the path and joins
       the last point back to the first.

   TWO_PI

       Processing measures angles in radians, not degrees.
       A full turn is TWO_PI radians, which is 360 degrees.

       float t = TWO_PI * sideNumber / numberOfSides;

       This splits one full turn into numberOfSides equal
       steps. With 360 sides, each step is 1 degree.

   cos() AND sin()

       For any angle t, cos(t) says how far across and
       sin(t) says how far down a point on a circle of
       radius 1 is. Multiplying by r makes the circle
       bigger. Adding centerX and centerY moves it to the
       middle of the page.

   TRY THESE (change a line, press PLAY, see what's different):

     int numberOfSides = 6;      // a hexagon

     int numberOfSides = 3;      // a triangle

     int numberOfSides = 12;     // at what number does it stop
                                 // looking like a polygon and
                                 // start looking like a circle?

     // -------------------------------------------------
     // replace endShape(CLOSE); with this

     endShape();                 // with 6 sides, one side is
                                 // missing. The path is not
                                 // joined back to its start

     // -------------------------------------------------
     // replace the y line with this

     float y = centerY + r * sin(2 * t);
                                 // y now goes around twice for
                                 // every once that x does

   =========================================================== */
