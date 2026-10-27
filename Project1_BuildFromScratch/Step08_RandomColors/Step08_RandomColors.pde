/* ===========================================================
   STEP 8 — RANDOM COLORS
   ===========================================================

   In all the previous steps, colors were all set by rules.
   Run the same sketch twice and you get the same picture.

   Now, we'll pick random colors from a list of colors.

   This step also removes the colored cells, so the circles
   sit on plain paper.

   Four things to do:
     - change sizeRatio to 1.0
     - replace the three color lines with the palette
     - delete rectMode(CENTER);
     - delete the if / else, the rect() and the fill() that
       followed it, and add the two new lines inside the
       inner loop

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed

// ---------- THE GRID ------------------------------------
int numberOfColumns = 6;
int numberOfRows = 8;
// ****************************
// ***** CHANGE THIS LINE *****
// ****************************
float sizeRatio = 1.0;

// ---------- THE LOOK ------------------------------------
// **********************************************
// ***** REPLACE THE THREE COLORS WITH THIS *****
// **********************************************
color[] palette = {
  color(230,  57,  70),   // red
  color(244, 162,  97),   // orange
  color( 42, 157, 143),   // teal
  color( 38,  70,  83),   // dark blue
  color(233, 196, 106),   // gold
};

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float cellWidth = pageWidth / numberOfColumns;
float cellHeight = pageHeight / numberOfRows;
float diameter = min(cellWidth, cellHeight) * sizeRatio;

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

      float centerX = column * cellWidth + cellWidth / 2;
      float centerY = row * cellHeight + cellHeight / 2;

      // *******************************
      // ***** ADD THESE TWO LINES *****
      // *******************************
      int whichColor = int(random(palette.length));   // 0 to 4
      fill(palette[whichColor]);

      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   THE PALETTE IS A LIST (an array)

       color[] palette = { ... };

   color firstCellColor held one color. color[] holds a
   numbered list of them. Counting starts at zero:

       palette[0]  is  the red
       palette[1]  is  the orange
       palette[4]  is  the gold

   palette.length is the number of colors in the list, 5 here.
   If you add or remove a color, the code below still works.

   RANDOM

       random(5)        a decimal between 0 and 5, never 5 itself
       int(random(5))   drops the decimal part: 0, 1, 2, 3 or 4

   Those are the positions in the palette.

   Press PLAY several times. Each run gives a different picture.

   TRY THESE:
     // -------------------------------------------------
     // replace the five colors in the palette with one of these

     color( 43,  45,  66),   // dark grey
     color(141, 153, 174),   // light grey
     color( 92, 103, 125),   // grey
     color(239,  35,  60),   // red
     color(217,   4,  41),   // deep red
                             // one bright color against greys

     color( 96, 108,  56),   // olive
     color( 40,  54,  24),   // dark green
     color(183, 163, 111),   // khaki
     color(221, 161,  94),   // sand
     color(188, 108,  37),   // rust
                             // earth tones

     color(230,  57,  70),   // red
     color(230,  57,  70),   // red
     color(230,  57,  70),   // red
     color( 38,  70,  83),   // dark blue
     color(233, 196, 106),   // gold
                             // the red is listed three times, so it
                             // comes up more often than the others

     // -------------------------------------------------
     // delete one color so there are only four

     color[] palette = {
       color(230,  57,  70),   // red
       color(244, 162,  97),   // orange
       color( 42, 157, 143),   // teal
       color( 38,  70,  83),   // dark blue
     };                        // still works, because of
                               // palette.length

     // -------------------------------------------------
     // move BOTH new lines out of the loops, to just
     // above the first for line

     int whichColor = int(random(palette.length));
     fill(palette[whichColor]);
                             // every circle gets the same color,
                             // because the color is picked once,
                             // before the loops start

                             // If you move only the fill() line,
                             // the sketch will not run, because
                             // whichColor only exists inside
                             // the loop

   =========================================================== */
