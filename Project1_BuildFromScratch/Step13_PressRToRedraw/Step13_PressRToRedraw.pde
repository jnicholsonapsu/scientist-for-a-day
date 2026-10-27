/* ===========================================================
   STEP 13 — PRESS R FOR A NEW PICTURE
   ===========================================================

   So far you press PLAY to get a new picture. In this step
   you press the R key instead.

   Three things to do:
     - add noLoop(); under size()
     - move everything else out of setup() into a new draw()
       function, below setup()
     - add the keyPressed() function at the bottom

   =========================================================== */

void setup() {
  size(612, 792);
  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  noLoop();   // draw once, then wait
}

// ********************************************
// ***** MOVE EVERYTHING ELSE INTO draw() *****
// ********************************************
void draw() {
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

  float fullness = 0.9;    // 1.0 fills every cell, 0.3 is sparse

  color[] palette = {
    color( 50,  50, 149),
    color(149,  50,  99),
    color(149, 149,  50),
    color( 50, 149,  99),
  };

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

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

// *****************************
// ***** ADD THIS FUNCTION *****
// *****************************
void keyPressed() {
  if (key == 'r' || key == 'R') {
    redraw();
  }
}

/* ===========================================================
   Notes:

   setup() AND draw()

   setup() runs once, when you press PLAY. draw() is a second
   function that Processing runs for you after setup().

   Normally draw() runs over and over, many times a second.
   noLoop() stops that, so draw() runs once and then waits.

   The drawing code moved into draw() because draw() can be run
   again. setup() cannot.

   keyPressed()

   Processing runs keyPressed() every time a key is pressed.
   key holds the key that was pressed.

       if (key == 'r' || key == 'R') {

   'r' with single quotes is one character. || means "or", so
   this is true for a small r or a capital R.

   redraw() runs draw() one more time. background() at the top
   of draw() paints over the old picture, and the random
   choices come out differently, so you get a new picture.

   TRY THESE:
     // -------------------------------------------------
     // replace if (key == 'r' || key == 'R') { with this

     if (key == ' ') {          // the space bar instead

     // -------------------------------------------------
     // delete background(250, 247, 240); and press R a
     // few times

                                // nothing paints over the old
                                // picture, so the new circles
                                // pile up on top of it

     // -------------------------------------------------
     // delete noLoop(); and run it

                                // draw() runs over and over,
                                // so the picture changes many
                                // times a second

   =========================================================== */
