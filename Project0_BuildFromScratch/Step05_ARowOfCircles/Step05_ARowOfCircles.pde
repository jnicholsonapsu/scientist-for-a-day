/* ===========================================================
   STEP 5 — A ROW, USING A LOOP
   ===========================================================

   At the end of step 4 you found that every extra circle
   costs two more lines, and that they are always the same
   two lines.

   A loop is how you write those lines once and have the
   computer repeat them.

   Replace everything from int diameter down to the last
   ellipse() with the marked lines below.

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);
  fill(230, 80, 70);
  stroke(30);
  strokeWeight(3);

  // ********************************
  // ***** REPLACE WITH THESE *******
  // ********************************
  int numberOfColumns = 5;
  float cellWidth = width / numberOfColumns;
  float sizeRatio = 0.9;
  float diameter = cellWidth * sizeRatio;
  float centerY = height / 2;

  for (int column = 0; column < numberOfColumns; column++) {
    float centerX = column * cellWidth + cellWidth / 2;
    ellipse(centerX, centerY, diameter, diameter);
  }
}

/* ===========================================================
   Notes:

   width AND height

   You never declared these two, but you can use them anyway.
   Processing makes them for you out of the size() line, so
   width is 600 and height is 800.

   Using them instead of typing 600 and 800 means the row
   still works if you change the size() line later.

   float

   In step 4, int could only hold a whole number. float holds
   a number that can have a decimal point, like 0.9. sizeRatio
   needs that, and so does anything worked out from it, such
   as diameter.

   DIVIDING THE PAGE INTO CELLS

       float cellWidth = width / numberOfColumns;

   Imagine the page cut into 5 equal cells, one per circle.
   Each cell is 600 / 5 = 120 wide. Nothing draws the cells;
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

   So column takes the values 0, 1, 2, 3, 4 and then stops.
   Five times through. Everything inside the { } happens once
   per trip.

   column++ is shorthand for column = column + 1, the same kind
   of line you wrote by hand in step 4.

   WHERE centerX COMES FROM

   In step 4 you moved the circle along yourself, one line at
   a time. Here the loop gives you a counter, and the position
   is worked out from it:

       float centerX = column * cellWidth + cellWidth / 2;

   column * cellWidth is the left edge of this circle's cell.
   Adding half a cell moves it to the middle, because ellipse()
   measures from the center.

       column = 0  ->  centerX =  60
       column = 1  ->  centerX = 180
       column = 2  ->  centerX = 300
       column = 3  ->  centerX = 420
       column = 4  ->  centerX = 540

   Five circles, and only one ellipse() line. Twenty circles
   would still be one ellipse() line.

   TRY THESE:
     // -------------------------------------------------
     // replace int numberOfColumns = 5; with one of these

     int numberOfColumns = 3;    // fewer, larger circles

     int numberOfColumns = 12;   // more, smaller circles

     int numberOfColumns = 20;   // they still all fit, because
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
     // replace float centerY = height / 2; with one of these

     float centerY = height / 4;   // the row moves up the page

     float centerY = 100;          // near the top. Any number
                                   // works here, but height / 2
                                   // stays centered if you change
                                   // the size() line

     // -------------------------------------------------
     // add this line inside the loop, just above ellipse()

     fill(column * 40, 80, 70);  // a different color each trip,
                                 // because column changes each trip
                                 // and the fill() runs again every
                                 // time around the loop

   =========================================================== */
