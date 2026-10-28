/* ===========================================================
   STEP 3 — CURVE STITCHING
   ===========================================================

   Two points travel around the circle at different speeds.
   At each step, a straight line joins them. The lines are
   all straight, but together they show a curve. The picture
   is also saved as a PDF file, ready to print.

   Add the lines marked below, then press PLAY.

   You should get a heart shape made of blue lines.

   THE EQUATIONS

   A point on a circle:

       x = centerX + r * cos(t)
       y = centerY + r * sin(t)

         r = radius of the circle
         t = the angle around the circle

   =========================================================== */

// *************************
// ***** ADD THIS LINE *****
// *************************
import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
int numberOfSides = 360;

int numberOfPoints = 100;   // how many dots go around the circle

// ***************************
// ***** ADD THESE LINES *****
// ***************************
int pointOneSpeed = 1;   // how many times point one goes around
int pointTwoSpeed = 2;   // how many times point two goes around

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color lineColor = color(40, 90, 170);
float lineThickness = 1;

color dotColor = color(0, 0, 0);
float dotSize = 4;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;
// radius of the circle, as big as fits inside the margins
float r = min(pageWidth, pageHeight) / 2 - pageMargin;

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
  for (int sideNumber = 0; sideNumber < numberOfSides; sideNumber++) {
    float t = TWO_PI * sideNumber / numberOfSides;

    float x = centerX + r * cos(t);
    float y = centerY + r * sin(t);

    vertex(x, y);
  }
  endShape(CLOSE);

  // ***************************
  // ***** ADD THESE LINES *****
  // ***************************
  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    float pointOneTheta = pointNumber * TWO_PI / numberOfPoints * pointOneSpeed;
    float pointTwoTheta = pointNumber * TWO_PI / numberOfPoints * pointTwoSpeed;

    float pointOneX = centerX + r * cos(pointOneTheta);
    float pointOneY = centerY + r * sin(pointOneTheta);
    float pointTwoX = centerX + r * cos(pointTwoTheta);
    float pointTwoY = centerY + r * sin(pointTwoTheta);

    line(pointOneX, pointOneY, pointTwoX, pointTwoY);
  }

  noStroke();
  fill(dotColor);

  for (int pointNumber = 0; pointNumber < numberOfPoints; pointNumber++) {
    float t = TWO_PI / numberOfPoints * pointNumber;

    float x = centerX + r * cos(t);
    float y = centerY + r * sin(t);

    circle(x, y, dotSize);
  }

  // *************************
  // ***** ADD THIS LINE *****
  // *************************
  endRecord();
}

/* ===========================================================
   Notes:

   THE TWO POINTS

       float pointOneTheta = pointNumber * TWO_PI / numberOfPoints * pointOneSpeed;
       float pointTwoTheta = pointNumber * TWO_PI / numberOfPoints * pointTwoSpeed;

   pointNumber * TWO_PI / numberOfPoints is the angle of dot
   number pointNumber, as in Step 2. Multiplying by a speed
   moves the point that many times as far around.

   With speeds 1 and 2, point one goes around the circle
   once while point two goes around twice. At pointNumber
   10, point one is on dot 10 and point two is on dot 20.

   The line uses the stroke() and strokeWeight() set at the
   top of draw(), the same as the circle.

   The dots are drawn last so they sit on top of the lines.

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

     int pointOneSpeed = 2;
     int pointTwoSpeed = 3;

     int pointOneSpeed = 3;
     int pointTwoSpeed = 5;

     int pointOneSpeed = 2;
     int pointTwoSpeed = 7;

     int numberOfPoints = 200;   // more lines, smoother curve

     int numberOfPoints = 20;    // few enough to follow each
                                 // line by hand

   =========================================================== */
