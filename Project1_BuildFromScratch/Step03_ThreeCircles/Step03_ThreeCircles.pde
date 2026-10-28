/* ===========================================================
   STEP 3 — THREE CIRCLES
   ===========================================================

   We want a row of circles across the page.

   Replace your one ellipse() line with the three new ellipse()
   lines below.

   =========================================================== */

void settings() {
  size(612, 792, P2D);
  pixelDensity(1);   // one pixel for every point on the page
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  background(250, 247, 240);
  fill(230, 80, 70);
  noStroke();

  // ******************************************
  // ***** REPLACE WITH THESE THREE LINES *****
  // ******************************************
  ellipse(100, 400, 160, 160);
  ellipse(300, 400, 160, 160);
  ellipse(500, 400, 160, 160);
}

/* ===========================================================
   Notes:

   A COLOR STAYS SET UNTIL YOU CHANGE IT

   There is one fill() line, and three circles. All three come
   out the same red.

   fill() does not draw anything. It sets the color that every
   shape after it will use, and it keeps that setting until
   another fill() changes it.

   TRY THESE:
     // -------------------------------------------------
     // add this line between the first and second ellipse()

     fill(60, 120, 180);     // only the circles BELOW this line
                             // change. The first one was already
                             // drawn, so it keeps the old color

     // Try adding a different fill() for each circle.

     // -------------------------------------------------
     // replace the three ellipse() lines with these

     ellipse(100, 400, 160, 160);   // By adjusting the values
     ellipse(300, 300, 160, 160);   // we can reposition the shapes.
     ellipse(500, 200, 160, 160);


   =========================================================== */
