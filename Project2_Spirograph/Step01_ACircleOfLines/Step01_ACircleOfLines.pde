/* ===========================================================
   STEP 1 — A CIRCLE OF LINES
   ===========================================================

   This step draws a circle as a path of 360 short straight
   lines, one for each degree.

   Type the code below, then press PLAY.

   You should get a blue circle outline on cream paper.

   THE EQUATIONS

   A point on a circle:

       x = centerX + r * cos(t)
       y = centerY + r * sin(t)

         r = radius of the circle
         t = the angle around the circle

   =========================================================== */

void setup() {
  size(612, 792);
  background(250, 247, 240);

  noFill();
  stroke(40, 90, 170);
  strokeWeight(2);

  float centerX = width / 2;
  float centerY = height / 2;
  float r = 200;

  int numberOfSides = 360;

  beginShape();
  for (int pointNumber = 0; pointNumber < numberOfSides; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    float x = centerX + r * cos(t);
    float y = centerY + r * sin(t);

    vertex(x, y);
  }
  endShape(CLOSE);
}

/* ===========================================================
   Notes:

   noFill();
       Draw shapes with no color inside, so only the outline
       shows.

   stroke(40, 90, 170);
       The color of the lines.

   strokeWeight(2);
       How thick the lines are.

   beginShape(), vertex() AND endShape(CLOSE)

       beginShape() starts a path. Each vertex(x, y) adds a
       point, and a straight line joins it to the point
       before. endShape(CLOSE) finishes the path and joins
       the last point back to the first.

   TWO_PI

       Processing measures angles in radians, not degrees.
       A full turn is TWO_PI radians, which is 360 degrees.

       float t = TWO_PI * pointNumber / numberOfSides;

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
