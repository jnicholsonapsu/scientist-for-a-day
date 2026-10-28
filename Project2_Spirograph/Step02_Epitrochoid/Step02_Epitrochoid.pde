/* ===========================================================
   STEP 2 — EPITROCHOID
   ===========================================================

   An epitrochoid is the path of a pen in a circle that rolls
   around the OUTSIDE of another circle that stays still. The
   pen does not have to be on the edge of the rolling circle.

   Change the lines marked below, then press PLAY.

   You should get a blue shape with three loops.

   THE EQUATIONS

       x = centerX + (R + r) * cos(t) - d * cos((R + r) * t / r)
       y = centerY + (R + r) * sin(t) - d * sin((R + r) * t / r)

         R = radius of the circle that stays still
         r = radius of the circle that rolls
         d = how far the pen is from the center of the
             rolling circle
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
int R = 120;   // radius of the circle that stays still
int r = 40;    // radius of the circle that rolls around it
float d = 60;    // the pen's distance from the center of
                 // the rolling circle

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
  for (int pointNumber = 0; pointNumber < numberOfSides; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    // ******************************
    // ***** CHANGE THESE LINES *****
    // ******************************
    float x = centerX + (R + r) * cos(t) - d * cos((R + r) * t / r);
    float y = centerY + (R + r) * sin(t) - d * sin((R + r) * t / r);

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

       - d * cos((R + r) * t / r)

   This is the pen, d from the center of the rolling circle.
   It spins around that center at the same time, (R + r) / r
   times for each trip around. Here that is
   (120 + 40) / 40 = 4.

   R AND r

   Processing treats capital R and small r as two different
   variables.

   WHY (R + r) * t / r AND NOT (R + r) / r * t

   R and r are ints, whole numbers. When Processing divides
   one int by another, it throws away the part after the
   decimal point, so 120 / 50 gives 2, not 2.4.

   t is a float, so (R + r) * t is a float. Dividing that by
   r keeps the decimals. Doing the multiplication first gives
   the right answer.

   THE NUMBER OF LOOPS

   R / r is the number of loops on the shape. Here it is
   120 / 40 = 3.

   TRY THESE (change a line, press PLAY, see what's different):

     int r = 24;    // 120 / 24 = 5 loops

     int r = 60;    // 120 / 60 = 2 loops

     float d = 40;    // the same as r, so the pen is on
                      // the edge of the rolling circle.
                      // The loops become sharp points.
                      // This shape is called an
                      // epicycloid

     float d = 20;    // the pen is inside the rolling
                      // circle, so the loops become
                      // gentle bumps

     int r = 50;    // 120 / 50 is not a whole
                      // number, so one trip around
                      // doesn't finish the shape.
                      // endShape(CLOSE) joins the ends
                      // with a straight line

     // -------------------------------------------------
     // replace R and r with these

     int R = 80;
     int r = 80;    // 1 loop. With d = 80 too, this
                      // shape is called a cardioid

   =========================================================== */
