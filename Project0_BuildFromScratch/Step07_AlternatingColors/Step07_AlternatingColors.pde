/* ===========================================================
   STEP 7 — ALTERNATING BOX COLORS
   ===========================================================

   Up to now the boxes have been imaginary. We worked out
   where they were, but nothing ever drew them.

   Now we fill each one in, and alternate the color as we go:
   even columns get one color, odd columns get the other. The
   circle is drawn on top afterwards.

   Three things to do:
     - add rectMode(CENTER); and change sizeRatio to 0.7
     - delete the fill(230, 80, 70); line, and add the three
       color lines in its place
     - add the if / else and the two drawing lines inside the
       inner loop

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);
  stroke(30);
  strokeWeight(3);

  // **************************
  // ***** ADD THIS LINE ******
  // **************************
  rectMode(CENTER);       // measure boxes from the middle

  int numberOfColumns = 6;
  int numberOfRows = 8;
  float boxWidth = width / numberOfColumns;
  float boxHeight = height / numberOfRows;
  float sizeRatio = 0.7;
  float diameter = min(boxWidth, boxHeight) * sizeRatio;

  // *********************************
  // ***** ADD THESE THREE LINES *****
  // *********************************
  color firstBoxColor  = color(233, 196, 106);
  color secondBoxColor = color( 38,  70,  83);
  color circleColor    = color(230,  80,  70);

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      float centerX = column * boxWidth + boxWidth / 2;
      float centerY = row * boxHeight + boxHeight / 2;

      // ***********************************
      // ***** ADD EVERYTHING BELOW ********
      // ***********************************
      if (column % 2 == 0) {
        fill(firstBoxColor);
      } else {
        fill(secondBoxColor);
      }
      rect(centerX, centerY, boxWidth, boxHeight);

      fill(circleColor);
      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   WE CAN SEE THE BOXES NOW

       rect(centerX, centerY, boxWidth, boxHeight);

   That one line fills in the box this circle belongs to. The
   boxes were always there in the arithmetic. Now, we are
   coloring them so that we can see them.

   rectMode(CENTER) tells rect() to measure from the middle,
   the way ellipse() already does. Without it, every box would
   be shifted down and to the right by half its size.

   ORDER MATTERS

   The rect() comes first and the ellipse() second, so the
   circle lands on top of its box. Swap those two lines and
   the boxes cover the circles completely.

   That is the same rule as step 2, where background() had to
   come before the circle.

   A NEW TYPE: color

       color firstBoxColor = color(233, 196, 106);

   color is a type, the same way int and float are types, and
   a variable of that type holds one color.

   The color() function builds one out of the same three
   numbers you have been giving fill() since step 2: red,
   green and blue, each from 0 to 255.

   Naming them means the same color can be used in more than
   one place, and changed from one line.

   circleColor is the same red the circles have been since
   step 2. It has to differ from both box colors, or half the
   circles would sink into the boxes behind them.

   if AND else

       if (something is true) {
         do this
       } else {
         otherwise do this
       }

   One of the two blocks runs, never both. Here it decides
   which fill() to use, and the rect() drawn afterwards gets
   whichever color won.

   THE % SIGN

   % gives the remainder left over after dividing.

       0 % 2 = 0        1 % 2 = 1
       2 % 2 = 0        3 % 2 = 1
       4 % 2 = 0        5 % 2 = 1

   So column % 2 is 0 for even columns and 1 for odd ones,
   which is exactly the question we want to ask.

   Note the double equals in column % 2 == 0. One equals sign
   would mean "put 0 into column", which is not a question at
   all.

   TRY THESE:
     // -------------------------------------------------
     // replace if (column % 2 == 0) { with one of these

     if (row % 2 == 0) {         // stripes across instead of down

     if ((column + row) % 2 == 0) {
                                 // a checkerboard. Adding the two
                                 // counters together flips the
                                 // answer on every step in either
                                 // direction

     if (column % 3 == 0) {      // every third column

     if (column < 3) {           // not alternating at all. The
                                 // left half is one color and the
                                 // right half the other

     // -------------------------------------------------
     // replace the three colors with one of these sets

     color firstBoxColor  = color(230,  57,  70);
     color secondBoxColor = color( 38,  70,  83);
     color circleColor    = color(233, 196, 106);
                                 // red and dark blue boxes, gold
                                 // circles

     color firstBoxColor  = color( 26,  26,  26);
     color secondBoxColor = color(141, 153, 174);
     color circleColor    = color(230,  80,  70);
                                 // near-black and grey boxes, red
                                 // circles

     color firstBoxColor  = color( 42, 157, 143);
     color secondBoxColor = color(233, 196, 106);
     color circleColor    = color(230,  80,  70);
                                 // teal and gold boxes, red circles.
                                 // All three are strong, so the
                                 // picture is louder than the others

   Whatever three you pick, keep all of them different from
   the paper color. Anything that matches the paper disappears
   once the outlines come off.

     // -------------------------------------------------
     // replace float sizeRatio = 0.7; with one of these

     float sizeRatio = 0.3;      // small circles, and most of what
                                 // you see is the boxes

     float sizeRatio = 1.0;      // the circles cover their boxes
                                 // almost completely

     // -------------------------------------------------
     // swap the rect() and ellipse() lines around

                                 // the boxes are drawn last, so
                                 // they cover the circles and you
                                 // see no circles at all

   =========================================================== */
