/* ===========================================================
   STEP 11 — COLORED OUTLINES
   ===========================================================

   In this step every circle gets a thick outline, in a
   random color from your palette.

   Keep your palette from step 9.

   Three things to do:
     - replace noStroke(); with the two marked lines
     - change sizeRatio to 0.85
     - add the two stroke lines inside the inner loop

   =========================================================== */

void setup() {
  size(612, 792);

  background(250, 247, 240);

  // *****************************************
  // ***** REPLACE noStroke() WITH THESE *****
  // *****************************************
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

  color[] palette = {
    color( 50,  50, 149),
    color(149,  50,  99),
    color(149, 149,  50),
    color( 50, 149,  99),
  };

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      float centerX = gridLeft + column * cellSize + cellSize / 2;
      float centerY = gridTop + row * cellSize + cellSize / 2;

      int whichColor = int(random(palette.length));
      fill(palette[whichColor]);

      // *******************************
      // ***** ADD THESE TWO LINES *****
      // *******************************
      int whichStrokeColor = int(random(palette.length));
      stroke(palette[whichStrokeColor]);

      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   stroke() AND strokeWeight()

       strokeWeight(strokeThickness);
       stroke(palette[whichStrokeColor]);

   noStroke() turned outlines off. stroke() turns them back on
   and sets their color, the same way fill() sets the color
   inside. strokeWeight() sets how thick they are.

   Each circle picks its own outline color, separately from its
   fill color. Sometimes the two match, and that circle just
   looks a little bigger.

   WHY sizeRatio IS 0.85

   An outline is drawn centered on the edge of the circle, so
   half of it sits outside the circle. With 10 for the
   thickness, the circle plus its outline is 10 wider than the
   circle alone:

       cellSize                 78
       diameter = 78 * 0.85     66.3
       plus the outline         66.3 + 10 = 76.3

   76.3 is less than 78, so every outline stays inside its
   cell.

   TRY THESE:
     // -------------------------------------------------
     // replace float strokeThickness = 10; with one of these

     float strokeThickness = 4;     // thin outlines

     float strokeThickness = 20;    // very thick. 66.3 + 20 is
                                    // more than 78, so the
                                    // outlines of neighbors
                                    // overlap

     // -------------------------------------------------
     // replace float sizeRatio = 0.85; with this

     float sizeRatio = 0.5;         // small circles, so the
                                    // outline is a bigger part
                                    // of each one

   =========================================================== */
