/* ===========================================================
   STEP 1 — ONE CIRCLE
   ===========================================================

   Type the six lines that are colored below, that is,
   the setup() function.

   You don't need to type the light gray text. Those are comments.
   They don't affect how the code works.

   Then press PLAY (the triangle, top left).

   You should get a blue window with a white circle in it.
   =========================================================== */

void setup() {
  size(612, 792);
  background(40, 90, 170);
  noStroke();
  ellipse(300, 400, 200, 200);
}

/* ===========================================================
   Notes:

   size(612, 792);
       Make a window 612 wide and 792 tall, the shape of a
       sheet of letter paper.

   background(40, 90, 170);
       Fill the whole window with one color. These three
       numbers make blue.

   noStroke();
       Draw shapes without an outline.

   ellipse(300, 400, 200, 200);
       This draws a circle. The four numbers mean:
         300 = how far ACROSS      (x coordinate)
         400 = how far DOWN        (y coordinate)
         200 = how wide
         200 = how tall

   WATCH OUT:
       y counts DOWN from the top

       (0, 0) is the top-left corner of the window.

   TRY THESE (change or add a line, press PLAY, see what's different):

     ellipse(0, 0, 200, 200);       // Change the numbers.
                                    // Where does the circle go? Only a
                                    // quarter of it is visible

     ellipse(300, 400, 400, 100);   // Change the numbers.
                                    // This function is really for
                                    // an ellipse. If the height and
                                    // width are the same, you get a
                                    // circle

     ellipse(100, 100, 50, 50);     // add this one, so that there
                                    // are two ellipse() calls in
                                    // setup()

     // -------------------------------------------------
     // delete noStroke(); and run it

                                    // a thin black outline appears
                                    // around the circle. That is
                                    // Processing's default

   =========================================================== */
