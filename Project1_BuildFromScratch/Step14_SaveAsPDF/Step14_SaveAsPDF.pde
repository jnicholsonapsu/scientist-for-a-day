/* ===========================================================
   STEP 14 — SAVE IT AS A PDF
   ===========================================================

   In this step the picture on screen is also saved as a PDF
   file, ready to print.

   Four things to do:
     - add the import line at the very top of the file
     - add pixelDensity(1); under size()
     - add the beginRecord() line at the top of draw()
     - add the endRecord() line at the bottom of draw()

   =========================================================== */

// *************************
// ***** ADD THIS LINE *****
// *************************
import processing.pdf.*;

void setup() {
  size(612, 792);
  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  pixelDensity(1);   // keeps the PDF the same size as the window
  noLoop();   // draw once, then wait
}

void draw() {
  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  beginRecord(PDF, "picture.pdf");

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

  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  endRecord();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    redraw();
  }
}

/* ===========================================================
   Notes:

   import processing.pdf.*;

   Saving a PDF is not built into Processing. This line loads
   the extra part of Processing that can do it.

   beginRecord() AND endRecord()

       beginRecord(PDF, "picture.pdf");

   Everything drawn between beginRecord() and endRecord() goes
   to the screen and into the PDF file. endRecord() finishes
   the file.

   pixelDensity(1)

   Some screens, such as most Macs, pack two pixels into every
   point of the window to make it look sharper. Without this
   line, the PDF gets drawn twice as big as the window, and
   only the top-left quarter of the picture fits on the page.

   THE FILE NAME

   The PDF is always called picture.pdf. Each new picture
   replaces the one before, so picture.pdf always matches what
   is on screen.

   WHERE THE FILE GOES

   picture.pdf is saved in your sketch folder. To open it, use
   Sketch > Show Sketch Folder.

   TRY THESE:
     // -------------------------------------------------
     // replace the beginRecord() line with this

     beginRecord(PDF, "sunset.pdf");   // your own file name

   =========================================================== */
