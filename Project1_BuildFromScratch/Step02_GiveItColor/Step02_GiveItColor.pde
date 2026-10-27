/* ===========================================================
   STEP 2 — GIVE IT COLOR
   ===========================================================

   Change the background() line to the paper color, and add
   the fill() line below it.

   Order matters. Processing runs functions in the order you write
   them, so background() has to come first. If it comes last,
   it paints over the circle.

   =========================================================== */

void setup() {
  size(612, 792);

  // **********************************************
  // ***** CHANGE background() AND ADD fill() *****
  // **********************************************
  background(250, 247, 240);   // paper color
  fill(230, 80, 70);           // inside of the circle

  noStroke();

  ellipse(300, 400, 200, 200);
}

/* ===========================================================
   Notes:

   background() and fill() both set colors.

   In the starter code, background() and fill() each have 3 numbers.
   The numbers represent 3 color channels: RED, GREEN, BLUE.
   Each one can be a value from 0 to 255.

   This is light, not paint, so the colors add toward white.

       (255, 0, 0)       red
       (0, 255, 0)       green
       (0, 0, 255)       blue
       (255, 255, 0)     red + green = yellow
       (0, 0, 0)         black
       (255, 255, 255)   white

   When there is only one number for a color, you get a grey:

       fill(100)   is the same as   fill(100, 100, 100)

   You can use 1 number or 3 numbers with background() and
   fill().

   In step 1 you got a white circle without asking for one.
   White is Processing's default, and fill() replaces it.

   TRY THESE:
     // -------------------------------------------------
     // replace fill(230, 80, 70);  with one of these

     fill(0, 100, 200);      // any three numbers, 0 to 255, you like

     fill(100);              // any one number, 0 to 255, you like

     fill(100, 100, 100);    // same as fill(100)

     // -------------------------------------------------
     // replace background(250, 247, 240); with this

     background(30);         // dark paper

   =========================================================== */
