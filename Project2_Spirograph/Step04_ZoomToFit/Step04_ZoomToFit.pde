/* ===========================================================
   STEP 4 — ZOOM TO FIT
   ===========================================================

   This step works out how big the shape is, then zooms it in
   or out so it fits exactly inside a 1 inch margin. R, r
   and d can now be small whole numbers, like 12, 5 and 6. The picture
   is also saved as a PDF file, ready to print.

   Change and add the lines marked below, then press PLAY.

   You should get the same twelve-loop shape as Step 3,
   touching the margin on the left and right.

   THE EQUATIONS

       x = centerX + zoom * ((R + r) * cos(t) - d * cos((R + r) * t / r))
       y = centerY + zoom * ((R + r) * sin(t) - d * sin((R + r) * t / r))

         R = radius of the circle that stays still
         r = radius of the circle that rolls
         d = how far the pen is from the center of the
             rolling circle
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
int R = 12;   // radius of the circle that stays still
int r = 5;    // radius of the circle that rolls around it
float d = 6;    // the pen's distance from the center of
                // the rolling circle

int numberOfSides = 360;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(40, 90, 170);
float lineThickness = 2;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// reduce R / r to its smallest fraction
int divisor = greatestCommonDivisor(R, r);
int denominator = r / divisor;

// ***************************
// ***** ADD THESE LINES *****
// ***************************
float shapeRadius = R + r + d;   // the farthest the shape reaches
                                 // from its center
float availableRadius = min(pageWidth, pageHeight) / 2 - pageMargin;
float zoom = availableRadius / shapeRadius;

// ---------- THE DRAWING ---------------------------------
void settings() {
  size(pageWidth, pageHeight, P2D);
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
    float x = centerX + zoom * ((R + r) * cos(t) - d * cos((R + r) * t / r));
    float y = centerY + zoom * ((R + r) * sin(t) - d * sin((R + r) * t / r));

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
   center of the page. The pen is d from that center, so it
   can be up to d farther out. The farthest the shape reaches
   is

       R + r + d

   which is 12 + 5 + 6 = 23 here.

   HOW MUCH ROOM THERE IS

       float availableRadius = min(pageWidth, pageHeight) / 2 - pageMargin;

   min() picks the smaller of pageWidth and pageHeight, so the shape
   fits both ways. Here that is 612 / 2 - 72 = 234.

   THE ZOOM

       float zoom = availableRadius / shapeRadius;

   Here that is 234 / 23, about 10.2. Every point of the shape
   is multiplied by zoom, so a shape that reaches 23 from the
   center now reaches 234. If the shape is bigger than the room, zoom is
   less than 1 and the shape shrinks.

   Because of the zoom, only the proportions of R, r and d
   change the shape. R = 12, r = 5, d = 6 and R = 120, r = 50,
   d = 60 draw the same picture.

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
     // replace R, r and d with these

     int R = 3;
     int r = 1;
     float d = 2;     // 3 loops

     int R = 7;
     int r = 3;
     float d = 4;     // 7 / 3

     int R = 1;
     int r = 1;
     float d = 1;     // a cardioid

     // -------------------------------------------------
     // replace pageMargin = 72; with this

     float pageMargin = 36;   // half an inch

   =========================================================== */
