/* ===========================================================
   STEP 7 — ALTERNATING CELL COLORS
   ===========================================================

   Up to now the cells have been imaginary. We worked out
   where they were, but nothing ever drew them.

   Now we fill each one in, and alternate the color as we go:
   even columns get one color, odd columns get the other. The
   circle is drawn on top afterwards.

   Four things to do:
     - change sizeRatio to 0.7
     - add THE LOOK, with its three color lines
     - delete the fill(230, 80, 70); line, and add
       rectMode(CENTER); in its place
     - add the if / else and the two drawing lines inside the
       inner loop

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE GRID ------------------------------------
int numberOfColumns = 6;
int numberOfRows = 8;
// ****************************
// ***** CHANGE THIS LINE *****
// ****************************
float sizeRatio = 0.7;

// ***************************
// ***** ADD THESE LINES *****
// ***************************
// ---------- THE LOOK ------------------------------------
color firstCellColor  = color(233, 196, 106);
color secondCellColor = color( 38,  70,  83);
color circleColor     = color(230,  80,  70);

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float cellWidth = pageWidth / numberOfColumns;
float cellHeight = pageHeight / numberOfRows;
float diameter = min(cellWidth, cellHeight) * sizeRatio;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight);
  pixelDensity(1);   // one pixel for every point on the page
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  background(250, 247, 240);
  noStroke();
  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  rectMode(CENTER);       // measure cells from the middle

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      float centerX = column * cellWidth + cellWidth / 2;
      float centerY = row * cellHeight + cellHeight / 2;

      // ********************************
      // ***** ADD EVERYTHING BELOW *****
      // ********************************
      if (column % 2 == 0) {
        fill(firstCellColor);
      } else {
        fill(secondCellColor);
      }
      rect(centerX, centerY, cellWidth, cellHeight);

      fill(circleColor);
      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   WE CAN SEE THE CELLS NOW

       rect(centerX, centerY, cellWidth, cellHeight);

   That one line fills in the cell this circle belongs to. The
   cells were always there in the arithmetic. Now, we are
   coloring them so that we can see them.

   rectMode(CENTER) tells rect() to measure from the middle,
   the way ellipse() already does. Without it, every cell would
   be shifted down and to the right by half its size.

   ORDER MATTERS

   The rect() comes first and the ellipse() second, so the
   circle lands on top of its cell. Swap those two lines and
   the cells cover the circles completely.

   That is the same rule as step 2, where background() had to
   come before the circle.

   A NEW TYPE: color

       color firstCellColor = color(233, 196, 106);

   color is a type, the same way int and float are types, and
   a variable of that type holds one color.

   The color() function builds one out of the same three
   numbers you have been giving fill() since step 2: red,
   green and blue, each from 0 to 255.

   Naming them means the same color can be used in more than
   one place, and changed from one line.

   circleColor is the same red the circles have been since
   step 2. It has to differ from both cell colors, or half the
   circles would sink into the cells behind them.

   if AND else

       if (something is true) {
         do this
       } else {
         otherwise do this
       }

   One of the two blocks runs, never both. Here it decides
   which fill() to use, and the rect() drawn afterwards gets
   whichever color won.

   THE % SIGN

   % gives the remainder left over after dividing.

       0 % 2 = 0        1 % 2 = 1
       2 % 2 = 0        3 % 2 = 1
       4 % 2 = 0        5 % 2 = 1

   So column % 2 is 0 for even columns and 1 for odd ones,
   which is exactly the question we want to ask.

   Note the double equals in column % 2 == 0. One equals sign
   would mean "put 0 into column", which is not a question at
   all.

   TRY THESE:
     // -------------------------------------------------
     // replace if (column % 2 == 0) { with one of these

     if (row % 2 == 0) {         // stripes across instead of down

     if ((column + row) % 2 == 0) {
                                 // a checkerboard. Adding the two
                                 // counters together flips the
                                 // answer on every step in either
                                 // direction

     if (column % 3 == 0) {      // every third column

     if (column < 3) {           // not alternating at all. The
                                 // left half is one color and the
                                 // right half the other

     // -------------------------------------------------
     // replace the three colors with one of these sets

     color firstCellColor  = color(230,  57,  70);
     color secondCellColor = color( 38,  70,  83);
     color circleColor     = color(233, 196, 106);
                                 // red and dark blue cells, gold
                                 // circles

     color firstCellColor  = color( 26,  26,  26);
     color secondCellColor = color(141, 153, 174);
     color circleColor     = color(230,  80,  70);
                                 // near-black and grey cells, red
                                 // circles

     color firstCellColor  = color( 42, 157, 143);
     color secondCellColor = color(233, 196, 106);
     color circleColor     = color(230,  80,  70);
                                 // teal and gold cells, red circles.
                                 // All three are strong, so the
                                 // picture is louder than the others

   Whatever three you pick, keep all of them different from
   the paper color. Anything that matches the paper
   disappears.

     // -------------------------------------------------
     // replace float sizeRatio = 0.7; with one of these

     float sizeRatio = 0.3;      // small circles, and most of what
                                 // you see is the cells

     float sizeRatio = 1.0;      // each circle touches the top
                                 // and bottom of its cell

     // -------------------------------------------------
     // swap the rect() and ellipse() lines around

                                 // the cells are drawn last, so
                                 // they cover the circles and you
                                 // see no circles at all

   =========================================================== */
