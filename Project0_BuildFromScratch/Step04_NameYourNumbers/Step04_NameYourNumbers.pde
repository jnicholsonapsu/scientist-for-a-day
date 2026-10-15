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

   Replace your three ellipse() lines with everything inside
   the box below.

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
  int x = 100;
  int y = 400;

  ellipse(x, y, diameter, diameter);

  x = x + 200;
  ellipse(x, y, diameter, diameter);

  x = x + 200;
  ellipse(x, y, diameter, diameter);
}

/* ===========================================================
   Notes:

   In this line, diameter is a "variable".

       int diameter = 160;

   A variable has a name, for example, "diameter",
   and we can assgn values to it, for example, 160. 
   From then on, writing diameter is the same as 
   writing 160.

   The "int" means the name holds a whole number. If you 
   replace the 160 with 160.5, the code won't work. 

   Now read the ellipse() line again:

       ellipse(x, y, diameter, diameter);

   You can tell what every part is for without needeing to
   remember specific values.

   All three circles use the same diameter. Change that one
   line at the top to 100 and all three circles change.

   That is the real reason to name a number. A number can 
   be written in one place, but we can use a variable, which
   has a name, everywhere the number is needed.
   
   CHANGIN VARIBLES
   
   Look at this line:

     x = x + 200

   The = does not mean "is equal to". It means "work out the
   right side, then put the answer in the name on the left".

   So x = x + 200 means: take whatever x is now, add 200, and
   that becomes the new x.

       x starts at 100
       x = x + 200   ->   x is now 300
       x = x + 200   ->   x is now 500

   Which is why the three circles land at 100, 300 and 500,
   without you typing those numbers anywhere.

   TRY THESE:
     // -------------------------------------------------
     // replace int diameter = 160; with one of these

     int diameter = 100;     // all three circles change at once

     int diameter = 220;     // big enough that they overlap

     // -------------------------------------------------
     // replace int y = 400; with this

     int y = 200;            // the whole row moves up the page

     // -------------------------------------------------
     // replace both x = x + 200; lines with one of these

     x = x + 120;            // the circles bunch together

     x = x + 250;            // the last one runs off the edge

     // -------------------------------------------------
     // add a fourth circle: copy these two lines onto the end

     x = x + 200;
     ellipse(x, y, diameter, diameter);

   =========================================================== */
