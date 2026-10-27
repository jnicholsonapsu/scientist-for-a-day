/* ===========================================================
   STEP 10 — ADD A MARGIN
   ===========================================================

   Right now the circles run all the way to the edge of the
   page. In this step you leave an empty border, called a
   margin, around the grid.

   Keep your palette from step 9.

   Three things to do:
     - add the pageMargin line
     - replace the lines under WORKED OUT FROM THE NUMBERS
       ABOVE with the marked lines
     - change the two lines that work out centerX and centerY

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
// *************************
// ***** ADD THIS LINE *****
// *************************
float pageMargin = 72;   // 1 inch when printed

// ---------- THE GRID ------------------------------------
int numberOfColumns = 6;
int numberOfRows = 8;
float sizeRatio = 1.0;

// ---------- THE LOOK ------------------------------------
color[] palette = {
  color( 50,  50, 149),
  color(149,  50,  99),
  color(149, 149,  50),
  color( 50, 149,  99),
};

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
// ******************************************
// ***** REPLACE THESE LINES WITH THESE *****
// ******************************************
float drawingWidth = pageWidth - 2 * pageMargin;
float drawingHeight = pageHeight - 2 * pageMargin;
float cellSize = min(drawingWidth / numberOfColumns, drawingHeight / numberOfRows);
float diameter = cellSize * sizeRatio;

float gridLeft = (pageWidth - numberOfColumns * cellSize) / 2;
float gridTop = (pageHeight - numberOfRows * cellSize) / 2;

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

       drawingWidth  = 612 - 2 * 72 = 468
       drawingHeight = 792 - 2 * 72 = 648

   SQUARE CELLS

       float cellSize = min(drawingWidth / numberOfColumns,
                            drawingHeight / numberOfRows);

   Before, cellWidth and cellHeight were worked out
   separately, so a cell could be any shape. Now there is one
   cellSize, the smaller of the two, so every cell is a
   square:

       468 / 6 = 78      648 / 8 = 81      cellSize = 78

   CENTERING THE GRID

   6 cells of 78 make the grid 468 wide, and 8 cells make it
   624 tall. That leaves space the grid does not use:

       float gridLeft = (pageWidth - numberOfColumns * cellSize) / 2;
       float gridTop  = (pageHeight - numberOfRows * cellSize) / 2;

   Each line takes that leftover space and splits it in half,
   so the grid sits in the middle of the page:

       gridLeft = (612 - 468) / 2 = 72
       gridTop  = (792 - 624) / 2 = 84

   centerX and centerY now start from gridLeft and gridTop
   instead of from the edge of the page.

   TRY THESE:
     // -------------------------------------------------
     // replace float pageMargin = 72; with one of these

     float pageMargin = 36;      // half an inch

     float pageMargin = 150;     // a wide border, and smaller
                                 // circles to fit inside it

     float pageMargin = 0;       // no margin. The circles reach
                                 // the top and bottom edges again

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
