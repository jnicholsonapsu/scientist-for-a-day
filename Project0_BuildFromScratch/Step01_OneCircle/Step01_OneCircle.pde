/* ===========================================================
   STEP 1 — ONE CIRCLE
   ===========================================================

   Type the four lines that are colored below, that is,
   the setup() function.

   You don't need to type the light gray text. Those are comments.
   They don't affect how the code works.

   Then press PLAY (the triangle, top left).

   You should get a grey window with a white circle in it. The
   thin dark outline around the circle is Processing's default.
   =========================================================== */

void setup() {
  size(600, 800);
  ellipse(300, 400, 200, 200);
}

/* ===========================================================
   Notes:

   size(600, 800);
       Make a window 600 wide and 800 tall.

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

   =========================================================== */
