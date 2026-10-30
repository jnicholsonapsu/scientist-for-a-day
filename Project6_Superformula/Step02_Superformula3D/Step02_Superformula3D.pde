/* ===========================================================
   STEP 2 — SUPERFORMULA 3D
   ===========================================================

   The superformula from Step 1 can make 3D shapes too. A
   globe is drawn with two angles: theta goes around the
   globe, like longitude, and phi goes from the bottom to the
   top, like latitude. Here each angle gets its own
   superformula, with its own m, n1, n2 and n3. The "around"
   superformula gives the shape seen from the top, and the
   "upDown" superformula gives the shape seen from the side.

   The shape can be drawn two ways. As a wire frame, it is
   lines going around it, like lines of latitude, and lines
   going over it from bottom to top, like lines of longitude.
   The lines at the back show through the front. As a solid,
   it is lots of small patches, each one shaded by how much
   it faces the light.

   The page is flat, so the shape is turned and tilted, then
   flattened onto the page, like in Project 5's Chen-Lee
   attractor. The drawing is made as big as fits inside the
   margins.

   Press PLAY. You should see a spiky star. The picture is
   also saved as picture.pdf.

   THE VALUES YOU CAN CHANGE

     aroundM, aroundN1,
     aroundN2, aroundN3      the superformula going around,
                             seen from the top
     upDownM, upDownN1,
     upDownN2, upDownN3      the superformula going from
                             bottom to top, seen from the side
     turnAngle               how far the shape is turned
                             around its up-down line, in
                             radians
     tiltAngle               how far the top is tilted
                             toward you, in radians
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

   Turning around the up-down line, then tilting:

       x1 = x * cos(turnAngle) - y * sin(turnAngle)
       y1 = x * sin(turnAngle) + y * cos(turnAngle)
       z1 = y1 * sin(tiltAngle) + z * cos(tiltAngle)

   Then x1 is drawn across the page and z1 up the page. For
   the solid, how far away each patch is comes from:

       y2 = y1 * cos(tiltAngle) - z * sin(tiltAngle)

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
// the edges of the page drawing, set in draw()
float smallestX;
float biggestX;
float smallestY;
float biggestY;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);   // keeps the PDF the same size as the window
}

void setup() {
  noLoop();   // draw once, then wait
}

void draw() {
  smallestX = Float.MAX_VALUE;
  biggestX = -Float.MAX_VALUE;
  smallestY = Float.MAX_VALUE;
  biggestY = -Float.MAX_VALUE;

  beginRecord(PDF, "picture.pdf");
  background(paperColor);
  if (drawAsSolid) {
    drawSolid();
  } else {
    drawWireFrame();
  }
  endRecord();
}

// A point on the shape, turned, tilted and flattened. x is
// across the page, y is up the page, and z is how far away it
// is: smaller z is closer to you
PVector shapePoint(float theta, float phi) {
  float r1 = superformula(theta, aroundM, aroundN1, aroundN2, aroundN3);
  float r2 = superformula(phi, upDownM, upDownN1, upDownN2, upDownN3);
  float x = r1 * cos(theta) * r2 * cos(phi);
  float y = r1 * sin(theta) * r2 * cos(phi);
  float z = r2 * sin(phi);

  float x1 = x * cos(turnAngle) - y * sin(turnAngle);
  float y1 = x * sin(turnAngle) + y * cos(turnAngle);
  float z1 = y1 * sin(tiltAngle) + z * cos(tiltAngle);
  float y2 = y1 * cos(tiltAngle) - z * sin(tiltAngle);

  PVector point = new PVector(x1, z1, y2);
  smallestX = min(smallestX, point.x);
  biggestX = max(biggestX, point.x);
  smallestY = min(smallestY, point.y);
  biggestY = max(biggestY, point.y);
  return point;
}

// Where a flattened point goes on the page: as big as fits
// inside the margins, without stretching. Up on the page is a
// smaller pageY, so y is subtracted
float pageX(PVector point) {
  float zoom = min((pageWidth - 2 * pageMargin) / (biggestX - smallestX),
                   (pageHeight - 2 * pageMargin) / (biggestY - smallestY));
  return centerX + zoom * (point.x - (smallestX + biggestX) / 2);
}

float pageY(PVector point) {
  float zoom = min((pageWidth - 2 * pageMargin) / (biggestX - smallestX),
                   (pageHeight - 2 * pageMargin) / (biggestY - smallestY));
  return centerY - zoom * (point.y - (smallestY + biggestY) / 2);
}

// Lines going around, like latitude, and lines going from
// bottom to top, like longitude
void drawWireFrame() {
  // work out every point first, so the edges are known
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

     float tiltAngle = 0;       // straight from the side

     float tiltAngle = 1.571;   // straight down from the top

     int numberOfLines = 60;    // a finer wire frame

   =========================================================== */
