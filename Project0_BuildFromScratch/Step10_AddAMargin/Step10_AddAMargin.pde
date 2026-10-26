/* ===========================================================
   STEP 10 — ADD A MARGIN
   ===========================================================

   Right now the circles run all the way to the edge of the
   page. In this step you leave an empty border, called a
   margin, around the grid.

   Keep your palette from step 9.

   Three things to do:
     - add the pageMargin line
     - replace the lines from cellWidth down to diameter
       with the marked lines
     - change the two lines that work out centerX and centerY

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);
  noStroke();

  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  float pageMargin = 72;   // about 1 inch when printed

  int numberOfColumns = 6;
  int numberOfRows = 8;

  // *********************************************************
  // ***** REPLACE cellWidth DOWN TO diameter WITH THESE *****
  // *********************************************************
  float drawingWidth = width - 2 * pageMargin;
  float drawingHeight = height - 2 * pageMargin;
  float cellSize = min(drawingWidth / numberOfColumns, drawingHeight / numberOfRows);
  float sizeRatio = 1.0;
  float diameter = cellSize * sizeRatio;

  float gridLeft = (width - numberOfColumns * cellSize) / 2;
  float gridTop = (height - numberOfRows * cellSize) / 2;

  color[] palette = {
    color( 50,  50, 149),
    color(149,  50,  99),
    color(149, 149,  50),
    color( 50, 149,  99),
  };

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      // **********************************
      // ***** CHANGE THESE TWO LINES *****
      // **********************************
      float centerX = gridLeft + column * cellSize + cellSize / 2;
      float centerY = gridTop + row * cellSize + cellSize / 2;

      int whichColor = int(random(palette.length));
      fill(palette[whichColor]);

      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   THE MARGIN

       float pageMargin = 72;

   Nothing is drawn closer than 72 to any edge of the page.

   drawingWidth and drawingHeight are what is left of the
   page after taking a margin off both sides:

       drawingWidth  = 600 - 2 * 72 = 456
       drawingHeight = 800 - 2 * 72 = 656

   SQUARE CELLS

       float cellSize = min(drawingWidth / numberOfColumns,
                            drawingHeight / numberOfRows);

   Before, cellWidth and cellHeight were worked out
   separately, so a cell could be any shape. Now there is one
   cellSize, the smaller of the two, so every cell is a
   square:

       456 / 6 = 76      656 / 8 = 82      cellSize = 76

   CENTERING THE GRID

   6 cells of 76 make the grid 456 wide, and 8 cells make it
   608 tall. That leaves space the grid does not use:

       float gridLeft = (width - numberOfColumns * cellSize) / 2;
       float gridTop  = (height - numberOfRows * cellSize) / 2;

   Each line takes that leftover space and splits it in half,
   so the grid sits in the middle of the page:

       gridLeft = (600 - 456) / 2 = 72
       gridTop  = (800 - 608) / 2 = 96

   centerX and centerY now start from gridLeft and gridTop
   instead of from the edge of the page.

   TRY THESE:
     // -------------------------------------------------
     // replace float pageMargin = 72; with one of these

     float pageMargin = 36;      // half an inch

     float pageMargin = 150;     // a wide border, and smaller
                                 // circles to fit inside it

     float pageMargin = 0;       // no margin. The circles run to
                                 // the edge again

     // -------------------------------------------------
     // replace numberOfColumns and numberOfRows together

     int numberOfColumns = 6;   int numberOfRows = 6;
                                 // a square grid. The leftover
                                 // space goes above and below it

     int numberOfColumns = 3;   int numberOfRows = 8;
                                 // a narrow grid. The leftover
                                 // space goes left and right

     // -------------------------------------------------
     // replace float sizeRatio = 1.0; with this

     float sizeRatio = 0.8;      // gaps between the circles

   =========================================================== */
