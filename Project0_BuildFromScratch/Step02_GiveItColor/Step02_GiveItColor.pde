/* ===========================================================
   STEP 2 — GIVE IT COLOR
   ===========================================================

   Add the four new lines above the ellipse() line.

   Order matters. Processing draws in the order you write, so
   background() has to come first. If it comes last it paints
   over the circle.
   =========================================================== */

void setup() {
  size(600, 800);

  // ********************************
  // ***** ADD THESE FOUR LINES *****
  // ********************************
  background(250, 247, 240);   // paper color
  fill(230, 80, 70);           // inside of the circle
  stroke(30);                  // outline color
  strokeWeight(3);             // outline thickness

  ellipse(300, 400, 200, 200);
}

/* ===========================================================
   Notes:

   background(), fill(), and stroke() are all setting colors.
   
   background() and fill() each have 3 numbers.
   The numbers represent 3 color channels: RED, GREEN, BLUE.
   Each one can be a value from 0 to 255.

   This is light, not paint, so the colors add toward white.

       (255, 0, 0)       red
       (0, 255, 0)       green
       (0, 0, 255)       blue
       (255, 255, 0)     red + green = yellow
       (0, 0, 0)         black
       (255, 255, 255)   white

   stroke() only has one number. 
   When there is only one number for a color, you get a grey:

       stroke(30)   is the same as   stroke(30, 30, 30)
       
   You can use 1 number or 3 numbers with background(), fill(), and stroke()

   In step 1 you got a white circle with a thin black outline
   without asking for either. Those are Processing's defaults,
   and the lines you just added replace them.

   TRY THESE:
     fill(0, 100, 200);      // any three numbers, 0 to 255, you like
     
     fill(100);              // any one number, 0 to 255, you like
     
     fill(100, 100, 100);    // same as fill(100)
     
     noFill();               // an empty ring, paper showing
                             // through the middle

     noStroke();             // removes the outline

     strokeWeight(20);       // very heavy outline

     background(30);         // dark paper. Does your circle
                             // still read well against it?

   It is often hard to guess what (12, 200, 190)
   looks like without running it. We'll deal with that later in an upcoming step.
   
   =========================================================== */
