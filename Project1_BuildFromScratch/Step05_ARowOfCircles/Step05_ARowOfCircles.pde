/* ===========================================================
   STEP 5 — A ROW, USING A LOOP
   ===========================================================

   At the end of step 4 you found that every extra circle
   costs two more lines, and that they are always the same
   two lines.

   A loop is how you write those lines once and have the
   computer repeat them.

   Two things to do:
     - replace THE CIRCLES with THE ROW, and add the lines
       under WORKED OUT FROM THE NUMBERS ABOVE
     - replace everything from the first ellipse() down to
       the last one with the loop

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ******************************************
// ***** REPLACE THE CIRCLES WITH THESE *****
// ******************************************
// ---------- THE ROW -------------------------------------
int numberOfColumns = 6;
float sizeRatio = 0.9;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float cellWidth = pageWidth / numberOfColumns;
float diameter = cellWidth * sizeRatio;
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
  background(250, 247, 240);
  fill(230, 80, 70);
  noStroke();

  // ******************************************************
  // ***** REPLACE THE ellipse() LINES WITH THIS LOOP *****
  // ******************************************************
  for (int column = 0; column < numberOfColumns; column++) {
    float centerX = column * cellWidth + cellWidth / 2;
    ellipse(centerX, centerY, diameter, diameter);
  }
}

/* ===========================================================
   Notes:

   WORKED OUT FROM THE NUMBERS ABOVE

   The variables in this part are calculated from the ones
   above them. You don't change these. Change the numbers
   above, and these follow.

   Processing fills in these variables from top to bottom, so
   each one can only use the lines above it.

   Using pageWidth and pageHeight instead of typing 612 and
   792 means the row still works if you change the page
   size later.

   float

   In step 4, int could only hold a whole number. float holds
   a number that can have a decimal point, like 0.9. sizeRatio
   needs that, and so does anything worked out from it, such
   as diameter.

   DIVIDING THE PAGE INTO CELLS

       float cellWidth = pageWidth / numberOfColumns;

   Imagine the page cut into 6 equal cells, one per circle.
   Each cell is 612 / 6 = 102 wide. Nothing draws the cells;
   they are just a way to work out where things go.

       float diameter = cellWidth * sizeRatio;

   sizeRatio is how much of its cell each circle fills. At 0.9
   the circle is a little smaller than its cell, which leaves
   the gaps you can see.

   HOW TO READ A for LOOP

       for (int column = 0; column < numberOfColumns; column++) {

   The three parts between the parentheses are:

       int column = 0             start column at 0
       column < numberOfColumns   keep going while column is
                                  less than numberOfColumns
       column++                   add 1 to column each time around

   So column takes the values 0, 1, 2, 3, 4, 5 and then stops.
   Six times through. Everything inside the { } happens once
   per trip.

   column++ is shorthand for column = column + 1, the same kind
   of line you wrote by hand in step 4.

   WHERE centerX COMES FROM

   In step 4 you moved the circle along yourself, one line at
   a time. Here the loop gives you a counter, and the position
   is worked out from it inside the loop:

       float centerX = column * cellWidth + cellWidth / 2;

   column * cellWidth is the left edge of this circle's cell.
   Adding half a cell moves it to the middle, because ellipse()
   measures from the center.

       column = 0  ->  centerX =  51
       column = 1  ->  centerX = 153
       column = 2  ->  centerX = 255
       column = 3  ->  centerX = 357
       column = 4  ->  centerX = 459
       column = 5  ->  centerX = 561

   Six circles, and only one ellipse() line. Twenty circles
   would still be one ellipse() line.

   TRY THESE:
     // -------------------------------------------------
     // replace int numberOfColumns = 6; with one of these

     int numberOfColumns = 3;    // fewer, larger circles

     int numberOfColumns = 12;   // more, smaller circles

     int numberOfColumns = 18;   // they still all fit, because
                                 // the cells got narrower too

     // -------------------------------------------------
     // replace float sizeRatio = 0.9; with one of these

     float sizeRatio = 0.5;      // small circles, wide gaps

     float sizeRatio = 1.0;      // the circles exactly fill the
                                 // width, touching each other and
                                 // both page edges

     float sizeRatio = 1.3;      // too big for their cells, so
                                 // they overlap and spill off
                                 // the sides

     // -------------------------------------------------
     // replace float centerY = pageHeight / 2; with one of these

     float centerY = pageHeight / 4;   // the row moves up the page

     float centerY = 100;              // near the top. Any number
                                       // works here, but
                                       // pageHeight / 2 stays
                                       // centered if you change
                                       // pageHeight

     // -------------------------------------------------
     // add this line inside the loop, just above ellipse()

     fill(column * 40, 80, 70);  // a different color each trip,
                                 // because column changes each trip
                                 // and the fill() runs again every
                                 // time around the loop

   =========================================================== */
