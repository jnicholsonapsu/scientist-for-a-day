/* ===========================================================
   STEP 6 — A WHOLE GRID
   ===========================================================

   One row was one loop. A page of rows is a loop inside a
   loop.

   Replace your loop, and the lines just above it, with
   everything in the box.

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);
  fill(230, 80, 70);
  stroke(30);
  strokeWeight(3);

  // ***************************************
  // ***** REPLACE WITH THIS NEW LOOP ******
  // ***************************************
  int numberOfColumns = 6;
  int numberOfRows = 8;
  float boxWidth = width / numberOfColumns;
  float boxHeight = height / numberOfRows;
  float sizeRatio = 0.9;
  float diameter = min(boxWidth, boxHeight) * sizeRatio;

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      float centerX = column * boxWidth + boxWidth / 2;
      float centerY = row * boxHeight + boxHeight / 2;

      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   BOXES IN BOTH DIRECTIONS

   In step 5 you cut the page into 5 boxes across. Now it is
   cut both ways:

       float boxWidth  = width / numberOfColumns;
       float boxHeight = height / numberOfRows;

   600 / 6 = 100 wide, and 800 / 8 = 100 tall, so these boxes
   happen to be square.

   They will not always be square, so the diameter is worked
   out from whichever side is smaller:

       float diameter = min(boxWidth, boxHeight) * sizeRatio;

   min() gives the smaller of two numbers. Using it means a
   circle always fits inside its box, whatever shape the box
   turns out to be.

   WHAT THE NESTED LOOP DOES

   The outer loop picks a column and holds it. The inner loop
   then runs all the way down that column. Only then does the
   outer loop move to the next column.

       column = 0  ->  row = 0,1,2,3,4,5,6,7   first column,
                                               top to bottom
       column = 1  ->  row = 0,1,2,3,4,5,6,7   second column
       column = 2  ->  ...

   6 columns x 8 rows = 48 circles, from four lines of code.
   A loop inside a loop is the standard way to cover a grid.

   WHERE centerY COMES FROM NOW

   In step 5, centerY was one fixed number, because every
   circle sat at the same height.

       float centerX = column * boxWidth + boxWidth / 2;
       float centerY = row * boxHeight + boxHeight / 2;

   Now it is worked out from row, exactly the way centerX is
   worked out from column. Two counters, two directions, the
   same piece of arithmetic twice.

   TRY THESE:
     // -------------------------------------------------
     // replace numberOfColumns and numberOfRows together

     int numberOfColumns = 3;   int numberOfRows = 4;
                                 // fewer, much larger circles

     int numberOfColumns = 12;  int numberOfRows = 16;
                                 // four times as many, and they
                                 // still fit, because the boxes
                                 // got smaller too

     // -------------------------------------------------
     // replace int numberOfRows = 8; alone, leaving the columns

     int numberOfRows = 4;       // the boxes are now twice as
                                 // tall as they are wide, so the
                                 // circles get spread apart
                                 // down the page

     int numberOfRows = 20;      // short, wide boxes. The circles
                                 // shrink to fit their height,
                                 // which leaves gaps to the left
                                 // and right of each one

     // -------------------------------------------------
     // replace float sizeRatio = 0.9; with one of these

     float sizeRatio = 0.4;      // small dots, lots of paper

     float sizeRatio = 1.0;      // the circles touch side to side

   =========================================================== */
