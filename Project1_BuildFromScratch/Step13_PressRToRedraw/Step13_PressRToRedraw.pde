/* ===========================================================
   STEP 13 — PRESS R FOR A NEW PICTURE
   ===========================================================

   So far you press PLAY to get a new picture. In this step
   you press the R key instead.

   One thing to do:
     - add the keyPressed() function at the bottom

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72;   // 1 inch when printed

// ---------- THE GRID ------------------------------------
int numberOfColumns = 6;
int numberOfRows = 8;
float sizeRatio = 0.85;   // leaves room for the outline
float fullness = 0.9;    // 1.0 fills every cell, 0.3 is sparse

// ---------- THE LOOK ------------------------------------
color[] palette = {
  color( 50,  50, 149),
  color(149,  50,  99),
  color(149, 149,  50),
  color( 50, 149,  99),
};

float strokeThickness = 10;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
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
  strokeWeight(strokeThickness);

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

   WHY THE DRAWING IS IN draw()

   setup() runs only once. draw() can be run again, which is
   what redraw() does.

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
