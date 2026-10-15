/* ===========================================================
   STEP 3 — THREE CIRCLES
   ===========================================================

   We want a row of circles across the page.

   Replace your one ellipse() line with these three. Type all
   three out, even though it is repetitive. The next step
   depends on you having felt the repetition.

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);
  fill(230, 80, 70);
  stroke(30);
  strokeWeight(3);

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
   another fill() changes it. The same is true of stroke() and
   strokeWeight().

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
