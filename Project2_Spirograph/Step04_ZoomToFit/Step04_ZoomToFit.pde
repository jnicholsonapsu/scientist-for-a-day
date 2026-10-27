/* ===========================================================
   STEP 4 — ZOOM TO FIT
   ===========================================================

   This step works out how big the shape is, then zooms it in
   or out so it fits exactly inside a 1 inch margin. R and r
   can now be small whole numbers, like 12 and 5. The picture
   is also saved as a PDF file, ready to print.

   Change and add the lines marked below, then press PLAY.

   You should get the same twelve-point shape as Step 3,
   touching the margin on the left and right.

   THE EQUATIONS

       x = centerX + zoom * ((R + r) * cos(t) - r * cos((R + r) / r * t))
       y = centerY + zoom * ((R + r) * sin(t) - r * sin((R + r) / r * t))

         R = radius of the circle that stays still
         r = radius of the circle that rolls
         t = the angle the rolling circle has traveled
             around the still one

   =========================================================== */

// *************************
// ***** ADD THIS LINE *****
// *************************
import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
// *************************
// ***** ADD THIS LINE *****
// *************************
float pageMargin = 72;   // 1 inch when printed

// ---------- THE SHAPE -----------------------------------
// ******************************
// ***** CHANGE THESE LINES *****
// ******************************
float R = 12;   // radius of the circle that stays still
float r = 5;    // radius of the circle that rolls around it

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(40, 90, 170);
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// reduce R / r to its smallest fraction
int divisor = greatestCommonDivisor(int(R), int(r));
int denominator = int(r) / divisor;

// ***************************
// ***** ADD THESE LINES *****
// ***************************
float shapeRadius = R + 2 * r;   // the farthest the shape reaches
                                 // from its center
float availableRadius = min(pageWidth, pageHeight) / 2 - pageMargin;
float zoom = availableRadius / shapeRadius;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  beginRecord(PDF, "picture.pdf");

  background(paperColor);
  noFill();
  stroke(lineColor);
  strokeWeight(lineThickness);

  beginShape();
  for (int pointNumber = 0; pointNumber < numberOfSides * denominator; pointNumber++) {
    float t = TWO_PI * pointNumber / numberOfSides;

    // ******************************
    // ***** CHANGE THESE LINES *****
    // ******************************
    float x = centerX + zoom * ((R + r) * cos(t) - r * cos((R + r) / r * t));
    float y = centerY + zoom * ((R + r) * sin(t) - r * sin((R + r) / r * t));

    vertex(x, y);
  }
  endShape(CLOSE);

  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  endRecord();
}

// The biggest whole number that divides both a and b
int greatestCommonDivisor(int a, int b) {
  while (b != 0) {
    int remainder = a % b;
    a = b;
    b = remainder;
  }
  return a;
}

/* ===========================================================
   Notes:

   HOW BIG THE SHAPE IS

   The center of the rolling circle is always R + r from the
   center of the page. The pen is on its edge, so it can be up
   to r farther out. The farthest the shape reaches is

       R + 2 * r

   which is 12 + 2 * 5 = 22 here.

   HOW MUCH ROOM THERE IS

       float availableRadius = min(pageWidth, pageHeight) / 2 - pageMargin;

   min() picks the smaller of pageWidth and pageHeight, so the shape
   fits both ways. Here that is 612 / 2 - 72 = 234.

   THE ZOOM

       float zoom = availableRadius / shapeRadius;

   Here that is 234 / 22, about 10.6. Every point of the shape
   is multiplied by zoom, so a shape 22 across from the center
   becomes 234. If the shape is bigger than the room, zoom is
   less than 1 and the shape shrinks.

   Because of the zoom, only the fraction R / r changes the
   shape. R = 12, r = 5 and R = 120, r = 50 draw the same
   picture.

   SAVING A PDF

       import processing.pdf.*;

   Saving a PDF is not built into Processing. This line loads
   the extra part of Processing that can do it.

       beginRecord(PDF, "picture.pdf");

   Everything drawn between beginRecord() and endRecord() goes
   to the screen and into the PDF file. endRecord() finishes
   the file.

       pixelDensity(1);

   Some screens, such as most Macs, pack two pixels into every
   point of the window. Without this line, the PDF gets drawn
   twice as big as the window, and only the top-left quarter
   fits on the page.

   picture.pdf is saved in your sketch folder, and each run
   replaces the one before. To open it, use
   Sketch > Show Sketch Folder.

   TRY THESE (change a line, press PLAY, see what's different):

     // -------------------------------------------------
     // replace R and r with these

     float R = 3;
     float r = 1;     // 3 points

     float R = 7;
     float r = 3;     // 7 / 3

     float R = 1;
     float r = 1;     // a cardioid

     // -------------------------------------------------
     // replace pageMargin = 72; with this

     float pageMargin = 36;   // half an inch

   =========================================================== */
