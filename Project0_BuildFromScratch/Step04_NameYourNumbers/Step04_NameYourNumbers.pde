/* ===========================================================
   STEP 4 — GIVE YOUR NUMBERS NAMES
   ===========================================================

   Look at what you typed in step 3:

       ellipse(100, 400, 160, 160);
       ellipse(300, 400, 160, 160);
       ellipse(500, 400, 160, 160);

   Twelve numbers, and nothing tells you what any of them
   mean. You have to remember that the third and fourth ones
   are the width and the height.

   So we give the numbers names first, and use the names
   instead.

   Replace your three ellipse() lines with the marked lines
   below.

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);
  fill(230, 80, 70);
  stroke(30);
  strokeWeight(3);

  // **********************************
  // ***** REPLACE WITH THESE NINE ****
  // **********************************
  int diameter = 160;
  int centerX = 100;
  int centerY = 400;

  ellipse(centerX, centerY, diameter, diameter);

  centerX = centerX + 200;
  ellipse(centerX, centerY, diameter, diameter);

  centerX = centerX + 200;
  ellipse(centerX, centerY, diameter, diameter);
}

/* ===========================================================
   Notes:

   In this line, diameter is a "variable".

       int diameter = 160;

   A variable has a name, for example, "diameter",
   and we can assign values to it, for example, 160.
   From then on, writing diameter is the same as
   writing 160.

   The "int" means the name holds a whole number. If you
   replace the 160 with 160.5, the code won't work.

   Now read the ellipse() line again:

       ellipse(centerX, centerY, diameter, diameter);

   You can tell what every part is for without needing to
   remember specific values.

   The names say centerX and centerY because ellipse()
   measures from the middle of the circle, not from a corner.

   All three circles use the same diameter. Change that one
   line at the top to 100 and all three circles change.

   That is the real reason to name a number. A number can
   be written in one place, but we can use a variable, which
   has a name, everywhere the number is needed.

   CHANGING VARIABLES

   Look at this line:

     centerX = centerX + 200

   The = does not mean "is equal to". It means "work out the
   right side, then put the answer in the name on the left".

   So centerX = centerX + 200 means: take whatever centerX is
   now, add 200, and that becomes the new centerX.

       centerX starts at 100
       centerX = centerX + 200   ->   centerX is now 300
       centerX = centerX + 200   ->   centerX is now 500

   Which is why the three circles land at 100, 300 and 500,
   without you typing those numbers anywhere.

   TRY THESE:
     // -------------------------------------------------
     // replace int diameter = 160; with one of these

     int diameter = 100;     // all three circles change at once

     int diameter = 220;     // big enough that they overlap

     // -------------------------------------------------
     // replace int centerY = 400; with this

     int centerY = 200;      // the whole row moves up the page

     // -------------------------------------------------
     // replace both centerX = centerX + 200; lines with one of these

     centerX = centerX + 120;   // the circles bunch together

     centerX = centerX + 250;   // the last one runs off the edge

     // -------------------------------------------------
     // add a fourth circle: copy these two lines onto the end

     centerX = centerX + 200;
     ellipse(centerX, centerY, diameter, diameter);

   =========================================================== */
