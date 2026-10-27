/* ===========================================================
   STEP 12 — LET SOME CELLS BE EMPTY
   ===========================================================

   In this step some cells are left empty, picked at random.

   Two things to do:
     - add the fullness line
     - wrap everything inside the inner loop in the new if

   Watch the braces. Everything that was inside the inner loop
   now sits one level deeper, and needs one more closing brace
   at the end.

   =========================================================== */

void setup() {
  size(612, 792);

  background(250, 247, 240);

  float strokeThickness = 10;
  strokeWeight(strokeThickness);

  float pageMargin = 72;   // 1 inch when printed

  int numberOfColumns = 6;
  int numberOfRows = 8;

  float drawingWidth = width - 2 * pageMargin;
  float drawingHeight = height - 2 * pageMargin;
  float cellSize = min(drawingWidth / numberOfColumns, drawingHeight / numberOfRows);
  float sizeRatio = 0.85;   // leaves room for the outline
  float diameter = cellSize * sizeRatio;

  float gridLeft = (width - numberOfColumns * cellSize) / 2;
  float gridTop = (height - numberOfRows * cellSize) / 2;

  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  float fullness = 0.9;    // 1.0 fills every cell, 0.3 is sparse

  color[] palette = {
    color( 50,  50, 149),
    color(149,  50,  99),
    color(149, 149,  50),
    color( 50, 149,  99),
  };

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      // **********************************************
      // ***** ADD THIS if, AND ITS CLOSING BRACE *****
      // **********************************************
      if (random(1) < fullness) {

        float centerX = gridLeft + column * cellSize + cellSize / 2;
        float centerY = gridTop + row * cellSize + cellSize / 2;

        int whichColor = int(random(palette.length));
        fill(palette[whichColor]);

        int whichStrokeColor = int(random(palette.length));
        stroke(palette[whichStrokeColor]);

        ellipse(centerX, centerY, diameter, diameter);
      }
    }
  }
}

/* ===========================================================
   Notes:

   HOW THE TEST WORKS

       random(1)             a decimal between 0 and 1
       random(1) < 0.9       true about 90% of the time

   So with fullness = 0.9, about nine cells in ten get a
   circle. Which ones changes every run.

   IF IT STOPPED WORKING

   The braces are the likely cause. Press Ctrl-T (Cmd-T on a
   Mac) to auto-format. If the indentation comes out looking
   wrong, the braces are wrong, and the shape of the code will
   show you where.

   TRY THESE:
     // -------------------------------------------------
     // replace float fullness = 0.9; with one of these

     float fullness = 1.0;    // every cell filled, as in step 11

     float fullness = 0.5;    // about half the cells

     float fullness = 0.35;   // mostly empty

     float fullness = 0.05;   // two or three circles on the page

   =========================================================== */
