/* ===========================================================
   STEP 8 — TAKE THE OUTLINES AWAY
   ===========================================================

   Every step so far has added something. This one takes
   something away.

   Two things to do:
     - change the if to the checkerboard you tried in step 7
     - delete the two stroke lines in setup() and put
       noStroke() in their place

   Run it, and compare it with what you had before.

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);

  // ****************************************
  // ***** REPLACE THE TWO STROKE LINES *****
  // ****************************************
  noStroke();

  rectMode(CENTER);

  int numberOfColumns = 6;
  int numberOfRows = 8;
  float boxWidth = width / numberOfColumns;
  float boxHeight = height / numberOfRows;
  float sizeRatio = 0.7;
  float diameter = min(boxWidth, boxHeight) * sizeRatio;

  color firstBoxColor  = color(233, 196, 106);
  color secondBoxColor = color( 38,  70,  83);
  color circleColor    = color(230,  80,  70);

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      float centerX = column * boxWidth + boxWidth / 2;
      float centerY = row * boxHeight + boxHeight / 2;

      // *****************************************
      // ***** CHANGE THIS LINE TO ADD + row *****
      // *****************************************
      if ((column + row) % 2 == 0) {
        fill(firstBoxColor);
      } else {
        fill(secondBoxColor);
      }
      rect(centerX, centerY, boxWidth, boxHeight);

      fill(circleColor);
      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   WHAT noStroke() DOES

   It turns outlines off. Nothing drawn after it gets one,
   until you ask for a stroke again. It is the opposite of the
   stroke() you added in step 2.

   WHY THE OUTLINES WERE USEFUL BEFORE

   Up to step 6 every circle was the same color, so a dark
   edge was doing real work. Two circles side by side would
   otherwise have read as one shape.

   From step 7 the box colors took that job over. Gold sits
   next to dark blue everywhere, so the edges show up without
   any help, and the dark line on top of them is one thing too
   many.

   WHAT THE CHECKERBOARD DOES WITHOUT THEM

   Squares of the same color no longer sit side by side. They
   meet at their corners instead, in diagonal runs, and your
   eye starts following those diagonals rather than the rows
   and columns the code is built from.

   Try the same thing with the old column % 2 version and the
   difference is obvious: a whole column becomes one solid
   stripe of color, because every box in it is the same and
   nothing divides them any more.

   Neither version is the correct one. Outlines make a piece
   look drawn. Leaving them off makes it look printed.

   TRY THESE:
     // -------------------------------------------------
     // replace the if with one of these

     if (column % 2 == 0) {      // solid stripes down the page

     if (row % 2 == 0) {         // solid stripes across it

     if ((column + row) % 3 == 0) {
                                 // only a third of the boxes get
                                 // the first color, in diagonal
                                 // bands

   =========================================================== */
