/* ===========================================================
   STEP 2 — EPICYCLOID
   ===========================================================

   An epicycloid is the path of a point on the edge of a
   circle that rolls around the OUTSIDE of another circle
   that stays still.

   Change the lines marked below, then press PLAY.

   You should get a blue shape with three points, like a
   three-leaf clover.

   THE EQUATIONS

       x = centerX + (R + r) * cos(t) - r * cos((R + r) / r * t)
       y = centerY + (R + r) * sin(t) - r * sin((R + r) / r * t)

         R = radius of the circle that stays still
         r = radius of the circle that rolls
         t = the angle the rolling circle has traveled
             around the still one

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE SHAPE -----------------------------------
// ******************************
// ***** CHANGE THESE LINES *****
// ******************************
float R = 120;   // radius of the circle that stays still
float r = 40;    // radius of the circle that rolls around it

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(40, 90, 170);
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight);
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
  for (int pointNumber = 0; pointNumber < numberOfSides; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    // ******************************
    // ***** CHANGE THESE LINES *****
    // ******************************
    float x = centerX + (R + r) * cos(t) - r * cos((R + r) / r * t);
    float y = centerY + (R + r) * sin(t) - r * sin((R + r) / r * t);

    vertex(x, y);
  }
  endShape(CLOSE);
}

/* ===========================================================
   Notes:

   HOW THE EQUATION WORKS

   Each x and y is made of two parts.

       (R + r) * cos(t)

   This is the center of the rolling circle. It goes around
   a circle of radius R + r, the same way the point in Step 1
   went around its circle.

       - r * cos((R + r) / r * t)

   This is the pen on the edge of the rolling circle. It spins
   around that center at the same time. (R + r) / r is how
   many times it spins for each trip around. Here that is
   (120 + 40) / 40 = 4.

   R AND r

   Processing treats capital R and small r as two different
   variables.

   THE NUMBER OF POINTS

   R / r is the number of points on the shape. Here it is
   120 / 40 = 3.

   TRY THESE (change a line, press PLAY, see what's different):

     float r = 24;    // 120 / 24 = 5 points

     float r = 60;    // 120 / 60 = 2 points. This
                      // shape is called a nephroid

     float r = 50;    // 120 / 50 is not a whole
                      // number, so one trip around
                      // doesn't finish the shape.
                      // endShape(CLOSE) joins the ends
                      // with a straight line

     // -------------------------------------------------
     // replace R and r with these

     float R = 80;
     float r = 80;    // 1 point. This shape is
                      // called a cardioid

   =========================================================== */
