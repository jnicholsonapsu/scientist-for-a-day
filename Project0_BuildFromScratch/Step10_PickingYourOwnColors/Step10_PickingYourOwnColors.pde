/* ===========================================================
   STEP 10 — PICKING YOUR OWN COLORS
   ===========================================================

   In this step, you pick your own colors.

   Replace your palette with the marked lines below. That
   gives you three colors, all black for now.

   Then go to the palette and change each color(0, 0, 0) to a
   color you choose. Keep every color different from the
   paper color, as in step 7.

   Each number in a color must be a whole number from 0 up
   to and including 255.

   =========================================================== */

void setup() {
  size(600, 800);

  background(250, 247, 240);
  noStroke();

  int numberOfColumns = 6;
  int numberOfRows = 8;
  float cellWidth = width / numberOfColumns;
  float cellHeight = height / numberOfRows;
  float sizeRatio = 1.0;
  float diameter = min(cellWidth, cellHeight) * sizeRatio;

  // ******************************************
  // ***** REPLACE YOUR PALETTE WITH THIS *****
  // ******************************************
  color[] palette = {
    color(0, 0, 0),   // each color needs 3 numbers,
    color(0, 0, 0),   // and each number must be a whole
    color(0, 0, 0),   // number from 0 up to and
                      // including 255
  };

  for (int column = 0; column < numberOfColumns; column++) {
    for (int row = 0; row < numberOfRows; row++) {

      float centerX = column * cellWidth + cellWidth / 2;
      float centerY = row * cellHeight + cellHeight / 2;

      int whichColor = int(random(palette.length));   // 0 to 2
      fill(palette[whichColor]);

      ellipse(centerX, centerY, diameter, diameter);
    }
  }
}

/* ===========================================================
   Notes:

   HOW DO YOUR COLORS LOOK TOGETHER?

   There is a good chance your three colors do not work well
   together. That is normal. Colors picked without a plan
   clash more often than they match, even when each one looks
   fine on its own.

   PICKING COLORS THAT GO TOGETHER

   Color theory is a set of rules for picking colors that work
   well together. Most of the rules use a color wheel. Three
   common rules are:

       complementary   two colors opposite each other
       analogous       colors next to each other
       triadic         three colors spaced evenly around
                       the wheel

   Triadic and analogous each give three colors, one for each
   line in your palette.

   Go to

       https://pikka.app/color-wheel

   and make sure Triadic is selected. Move the dots in the
   circle, change the sliders for Hue Angle, Saturation, and
   Lightness / Value until you find the three colors on the
   right that you like. Under each color is a line like this
   one:

       rgb(121, 165, 236)

   Copy it and paste it over one of the color(0, 0, 0) lines
   in your palette. Then change rgb to color, so it reads

       color(121, 165, 236)

   Do the same for the other two colors, and press PLAY.

   You don't always have to use Triadic, which gives three
   colors. Any of the other rules on the Pikka page will work
   too. Just make sure your palette has one color line for
   each color the rule gives you. The palette.length takes
   care of the rest, as in step 9.

   =========================================================== */
