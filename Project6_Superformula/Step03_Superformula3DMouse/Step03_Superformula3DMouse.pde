/* ===========================================================
   STEP 3 — SUPERFORMULA 3D WITH THE MOUSE
   ===========================================================

   The 3D superformula from Step 2, but now you can turn it
   with the mouse, around all three directions. Hold the
   mouse button down and drag: left and right turns the
   shape, and up and down tilts it. Hold SHIFT too, and left
   and right spins it like a wheel facing you.

   Whenever you let go of the mouse button, the picture is
   saved as a PDF in the sketch folder. Each one gets its own
   number, like picture-0412.pdf, so none are replaced. To
   find them, use Sketch > Show Sketch Folder.

   As in Step 2, each angle gets its own superformula. The
   "around" superformula gives the shape seen from the top,
   and the "upDown" superformula gives the shape seen from
   the side.

   The shape can be drawn two ways. As a wire frame, it is
   lines going around it, like lines of latitude, and lines
   going over it from bottom to top, like lines of longitude.
   The lines at the back show through the front. As a solid,
   it is lots of small patches, each one shaded by how much
   it faces the light.

   The page is flat, so the shape is turned and tilted, then
   flattened onto the page. The size stays the same while it
   turns: the shape is made as big as it can be while still
   fitting inside the margins however it is turned.

   Press PLAY, then drag the shape around.

   THE VALUES YOU CAN CHANGE

     aroundM, aroundN1,
     aroundN2, aroundN3      the superformula going around,
                             seen from the top
     upDownM, upDownN1,
     upDownN2, upDownN3      the superformula going from
                             bottom to top, seen from the side
     turnAngle               how far the shape is turned
                             around the up-down line at the
                             start, in radians
     tiltAngle               how far the top is tilted
                             toward you at the start, in
                             radians
     spinAngle               how far the shape is spun like a
                             wheel facing you at the start, in
                             radians
     turnSpeed               how far the shape turns for each
                             pixel the mouse moves, in radians
     drawAsSolid             false for a wire frame, true for
                             a solid
     numberOfLines           how many lines go each way in
                             the wire frame
     pointsPerLine           how many points are in each line
     solidDetail             how many patches go each way in
                             the solid
     paperColor              the color of the paper
     middleColor             the color around the middle of
                             the shape
     endsColor               the color at the top and bottom
                             of the shape. In between, the
                             color blends from one to the
                             other
     lineThickness           how thick the wire frame is
     shadowColor             the color of the solid where it
                             faces away from the light

   THE EQUATIONS

   The superformula, from Step 1, with a and b at 1:

       r = ( |cos(m * angle / 4)| ^ n2
           + |sin(m * angle / 4)| ^ n3 ) ^ (-1 / n1)

   r1 is the "around" superformula at theta, and r2 is the
   "upDown" superformula at phi. A point on the shape is:

       x = r1 * cos(theta) * r2 * cos(phi)
       y = r1 * sin(theta) * r2 * cos(phi)
       z = r2 * sin(phi)

   theta goes from -PI to PI, and phi from -HALF_PI (the
   bottom) to HALF_PI (the top).

   TURNING THE SHAPE

   Each drag turns the shape around one of the screen's own
   three directions: the up-down line, the left-right line,
   or the line pointing straight at you. That way, dragging
   left and right always turns it left and right, however it
   is already turned.

   To keep track of how the shape is turned, the sketch keeps
   three arrows, called across, up and away. Each one says how
   much of the shape's x, y and z goes across the screen, up
   the screen and away from you. A point on the screen is:

       screenX = across.x * x + across.y * y + across.z * z
       screenY = up.x * x + up.y * y + up.z * z
       depth   = away.x * x + away.y * y + away.z * z

   Turning by an angle around the up-down line changes across
   and away, the two arrows that turn:

       newAcross = across * cos(angle) - away * sin(angle)
       newAway   = across * sin(angle) + away * cos(angle)

   Tilting changes away and up the same way, and spinning
   changes across and up.

   =========================================================== */

import processing.pdf.*;

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE SHAPE -----------------------------------
float aroundM = 7;
float aroundN1 = 0.2;
float aroundN2 = 1.7;
float aroundN3 = 1.7;

float upDownM = 7;
float upDownN1 = 0.2;
float upDownN2 = 1.7;
float upDownN3 = 1.7;

float turnAngle = 0.6;
float tiltAngle = 0.5;
float spinAngle = 0;
float turnSpeed = 0.01;

boolean drawAsSolid = true;

int numberOfLines = 30;
int pointsPerLine = 200;
int solidDetail = 100;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color middleColor = color(110, 160, 200);   // sky blue
color endsColor = color(230, 110,  80);     // coral
color shadowColor = color( 20,  40,  70);   // dark navy

float lineThickness = 0.5;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;
float centerY = pageHeight / 2;

// ---------- THE DRAWING ---------------------------------
float zoom;               // set in setup()

// How the shape is turned: see TURNING THE SHAPE above. At
// the start, x goes across, z goes up and y goes away
PVector across = new PVector(1, 0, 0);
PVector up = new PVector(0, 0, 1);
PVector away = new PVector(0, 1, 0);
boolean savePDF = false;  // set to true when the mouse button
                          // is let go

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  // turn to the starting angles
  turnArrows(across, away, turnAngle);
  turnArrows(away, up, tiltAngle);
  turnArrows(across, up, spinAngle);

  // Find the point farthest from the center. However the
  // shape is turned, no point is farther than that, so this
  // zoom always fits inside the margins
  float farthest = 0;
  for (int row = 0; row <= solidDetail; row++) {
    for (int column = 0; column <= solidDetail; column++) {
      float theta = -PI + TWO_PI * column / solidDetail;
      float phi = -HALF_PI + PI * row / solidDetail;
      farthest = max(farthest, shapePoint(theta, phi).mag());
    }
  }
  zoom = (min(pageWidth, pageHeight) / 2 - pageMargin) / farthest;

  println("Hold the mouse button down and drag to move the shape:");
  println("  left and right turns it, up and down tilts it.");
  println("Hold SHIFT while dragging left and right to spin it.");
  println("Let go of the button to save a PDF.");
}

void draw() {
  // #### in the file name is replaced by the frame number
  if (savePDF) {
    beginRecord(PDF, "picture-####.pdf");
  }

  background(paperColor);
  if (drawAsSolid) {
    drawSolid();
  } else {
    drawWireFrame();
  }

  if (savePDF) {
    endRecord();
    savePDF = false;
    println("Saved picture-" + nf(frameCount, 4) + ".pdf in the sketch folder.");
  }
}

// Dragging turns and tilts the shape, or spins it if SHIFT is
// held down. pmouseX and pmouseY are where the mouse was one
// frame ago
void mouseDragged() {
  if (keyPressed && keyCode == SHIFT) {
    turnArrows(across, up, (mouseX - pmouseX) * turnSpeed);
  } else {
    turnArrows(across, away, (mouseX - pmouseX) * turnSpeed);
    turnArrows(away, up, (mouseY - pmouseY) * turnSpeed);
  }
  straightenArrows();
}

// Turns two of the arrows by an angle, around the third one
void turnArrows(PVector first, PVector second, float angle) {
  PVector newFirst = PVector.sub(PVector.mult(first, cos(angle)), PVector.mult(second, sin(angle)));
  PVector newSecond = PVector.add(PVector.mult(first, sin(angle)), PVector.mult(second, cos(angle)));
  first.set(newFirst);
  second.set(newSecond);
}

// Tiny rounding errors add up after many turns, and the arrows
// slowly stop being square to each other. This makes each one
// 1 long and square to the others again
void straightenArrows() {
  across.normalize();
  away.sub(PVector.mult(across, away.dot(across)));
  away.normalize();
  up.set(across.cross(away));
}

// Letting go of the button saves the next frame as a PDF
void mouseReleased() {
  savePDF = true;
}

// A point on the shape, turned and flattened. x is across the
// page, y is up the page, and z is how far away it is: smaller
// z is closer to you
PVector shapePoint(float theta, float phi) {
  float r1 = superformula(theta, aroundM, aroundN1, aroundN2, aroundN3);
  float r2 = superformula(phi, upDownM, upDownN1, upDownN2, upDownN3);
  float x = r1 * cos(theta) * r2 * cos(phi);
  float y = r1 * sin(theta) * r2 * cos(phi);
  float z = r2 * sin(phi);

  float screenX = across.x * x + across.y * y + across.z * z;
  float screenY = up.x * x + up.y * y + up.z * z;
  float depth = away.x * x + away.y * y + away.z * z;

  return new PVector(screenX, screenY, depth);
}

// Where a flattened point goes on the page. Up on the page is
// a smaller pageY, so y is subtracted
float pageX(PVector point) {
  return centerX + zoom * point.x;
}

float pageY(PVector point) {
  return centerY - zoom * point.y;
}

// Lines going around, like latitude, and lines going from
// bottom to top, like longitude
void drawWireFrame() {
  PVector[][] points = new PVector[2 * numberOfLines][pointsPerLine + 1];
  for (int lineNumber = 0; lineNumber < 2 * numberOfLines; lineNumber++) {
    for (int pointNumber = 0; pointNumber <= pointsPerLine; pointNumber++) {
      if (lineNumber < numberOfLines) {
        // going around, at one height. The + 0.5 keeps the
        // lines off the very top and bottom
        float theta = -PI + TWO_PI * pointNumber / pointsPerLine;
        float phi = -HALF_PI + PI * (lineNumber + 0.5) / numberOfLines;
        points[lineNumber][pointNumber] = shapePoint(theta, phi);
      } else {
        // going from bottom to top, at one angle around
        float theta = -PI + TWO_PI * (lineNumber - numberOfLines) / numberOfLines;
        float phi = -HALF_PI + PI * pointNumber / pointsPerLine;
        points[lineNumber][pointNumber] = shapePoint(theta, phi);
      }
    }
  }

  noFill();
  strokeWeight(lineThickness);

  // the lines going around are each at one height, so each is
  // one color
  for (int lineNumber = 0; lineNumber < numberOfLines; lineNumber++) {
    stroke(colorAtPhi(-HALF_PI + PI * (lineNumber + 0.5) / numberOfLines));
    beginShape();
    for (int pointNumber = 0; pointNumber <= pointsPerLine; pointNumber++) {
      vertex(pageX(points[lineNumber][pointNumber]), pageY(points[lineNumber][pointNumber]));
    }
    endShape();
  }

  // The lines going from bottom to top change color along the
  // way, so each short piece is drawn on its own, in the color
  // for its height. A PDF can only give a line one color
  for (int lineNumber = numberOfLines; lineNumber < 2 * numberOfLines; lineNumber++) {
    for (int pointNumber = 0; pointNumber < pointsPerLine; pointNumber++) {
      stroke(colorAtPhi(-HALF_PI + PI * (pointNumber + 0.5) / pointsPerLine));
      PVector start = points[lineNumber][pointNumber];
      PVector end = points[lineNumber][pointNumber + 1];
      line(pageX(start), pageY(start), pageX(end), pageY(end));
    }
  }
}

// The color for a height on the shape: middleColor at the
// middle (phi = 0), endsColor at the top and bottom (phi =
// HALF_PI and -HALF_PI), and blended in between. The colors
// stay with the shape as it turns
color colorAtPhi(float phi) {
  return lerpColor(middleColor, endsColor, abs(phi) / HALF_PI);
}

// The surface, cut into small four-sided patches. Each patch
// is shaded by which way it faces, and the patches are drawn
// from the farthest to the closest, so close ones cover far
// ones. This is called the painter's algorithm, because a
// painter paints the background first
void drawSolid() {
  // a grid of points over the whole surface
  PVector[][] points = new PVector[solidDetail + 1][solidDetail + 1];
  for (int row = 0; row <= solidDetail; row++) {
    for (int column = 0; column <= solidDetail; column++) {
      float theta = -PI + TWO_PI * column / solidDetail;
      float phi = -HALF_PI + PI * row / solidDetail;
      points[row][column] = shapePoint(theta, phi);
    }
  }

  // one patch for each square of the grid
  ArrayList<Patch> patches = new ArrayList<Patch>();
  for (int row = 0; row < solidDetail; row++) {
    for (int column = 0; column < solidDetail; column++) {
      float middlePhi = -HALF_PI + PI * (row + 0.5) / solidDetail;
      patches.add(new Patch(points[row][column], points[row][column + 1],
                            points[row + 1][column + 1], points[row + 1][column],
                            colorAtPhi(middlePhi)));
    }
  }

  // farthest first
  java.util.Collections.sort(patches);

  // The light comes from behind you, up and to the left.
  // normalize() makes it 1 long
  PVector light = new PVector(-1, 1, -0.7);
  light.normalize();

  for (Patch patch : patches) {
    // Which way the patch faces: the cross product of two of
    // its sides points straight out of it. The more it faces
    // the light, the brighter it is
    PVector side1 = PVector.sub(patch.corners[1], patch.corners[0]);
    PVector side2 = PVector.sub(patch.corners[3], patch.corners[0]);
    PVector facing = side1.cross(side2);
    if (facing.mag() == 0) {
      continue;   // a patch squeezed to a line, at the top or bottom
    }
    facing.normalize();

    // Turn it to point toward you, since that is the side you
    // see. Smaller z is closer to you
    if (facing.z > 0) {
      facing.mult(-1);
    }
    float brightness = max(0, facing.dot(light));
    color patchColor = lerpColor(shadowColor, patch.baseColor, brightness);

    // the outline in the same color hides tiny gaps between
    // patches
    fill(patchColor);
    stroke(patchColor);
    strokeWeight(0.5);
    beginShape();
    for (int cornerNumber = 0; cornerNumber < 4; cornerNumber++) {
      vertex(pageX(patch.corners[cornerNumber]), pageY(patch.corners[cornerNumber]));
    }
    endShape(CLOSE);
  }
}

// One four-sided patch of the surface. Patches can be sorted
// by how far away they are, farthest first
class Patch implements Comparable<Patch> {
  PVector[] corners;
  float distance;
  color baseColor;   // its color before shading

  Patch(PVector corner1, PVector corner2, PVector corner3, PVector corner4, color patchBaseColor) {
    corners = new PVector[] {corner1, corner2, corner3, corner4};
    distance = (corner1.z + corner2.z + corner3.z + corner4.z) / 4;
    baseColor = patchBaseColor;
  }

  public int compareTo(Patch other) {
    return Float.compare(other.distance, distance);
  }
}

// The superformula, with a and b at 1, for any m, n1, n2, n3
float superformula(float angle, float m, float n1, float n2, float n3) {
  float cosinePart = pow(abs(cos(m * angle / 4)), n2);
  float sinePart = pow(abs(sin(m * angle / 4)), n3);
  return pow(cosinePart + sinePart, -1 / n1);
}

/* ===========================================================
   TRY THESE (change the numbers, press PLAY, see what's
   different):

     A sphere: with m = 4 and the n's at 2, each
     superformula is a circle.

     float aroundM = 4;
     float aroundN1 = 2;
     float aroundN2 = 2;
     float aroundN3 = 2;
     float upDownM = 4;
     float upDownN1 = 2;
     float upDownN2 = 2;
     float upDownN3 = 2;

     A diamond with eight flat sides: a square from the top
     and from the side.

     float aroundM = 4;
     float aroundN1 = 1;
     float aroundN2 = 1;
     float aroundN3 = 1;
     float upDownM = 4;
     float upDownN1 = 1;
     float upDownN2 = 1;
     float upDownN3 = 1;

     A rounded triangle from the top, a rounded square from
     the side.

     float aroundM = 3;
     float aroundN1 = 4.5;
     float aroundN2 = 10;
     float aroundN3 = 10;
     float upDownM = 4;
     float upDownN1 = 12;
     float upDownN2 = 15;
     float upDownN3 = 15;

     boolean drawAsSolid = false;  // a see-through wire frame

     float turnSpeed = 0.03;    // turns faster

     int numberOfLines = 60;    // a finer wire frame

   =========================================================== */
