/* ===========================================================
   STEP 1 — THE TRAVELING SALESMAN PROBLEM
   ===========================================================

   A salesman has to visit every city on a map once, then go
   back home. What order of cities makes the shortest trip?
   That is the Traveling Salesman Problem. Mathematicians have
   studied it since at least 1930, when Karl Menger wrote
   about it.

   It sounds easy, but the number of possible trips grows
   very fast. With 10 cities there are 181,440 different
   trips. With 200 cities there are more trips than there are
   atoms in the universe, so no computer can check them all.

   Instead, this sketch finds a good trip in five parts. The
   method was found in 1976 by Nicos Christofides, and on its
   own by Anatoliy Serdyukov. Its trip is never more than 1.5
   times as long as the shortest possible trip.

     1. Grow the shortest network that joins every city.
        Start at home, and keep adding the shortest road from
        a joined city to a city not joined yet. This is
        Prim's method (Robert Prim, 1957, and Vojtech Jarnik,
        1930 before him).

     2. Circle the cities with an odd number of network
        roads. There is always an even number of them.

     3. Pair up the circled cities, adding a road between
        each pair, so the new roads are as short as possible
        in total. Now every city has an even number of roads.

     4. Walk along every road exactly once and end up back
        home. Leonhard Euler showed in 1736 that this can be
        done when every city has an even number of roads: each
        time you walk into a city, there is a road left to
        walk out on.

     5. Follow the walk, but skip any city already visited,
        going straight to the next new one. That is the trip.

   Press PLAY and watch. Every road between two cities is
   drawn in gray, with its length. The words at the bottom
   say what each part is doing, and the trip's length is
   added up as it is made. When the trip is done, a new map
   is made and it starts again.

   THE VALUES YOU CAN CHANGE

     numberOfCities    how many cities to visit. Up to 14.
                       Part 3 tries every way of pairing up
                       cities, which gets slow with more
     cityGap           how close two cities can be
     framesPerMove     how many frames each move stays on
                       the screen
     framesHolding     how many frames the finished trip
                       stays before a new map
     paperColor        the color of the paper
     roadColor         the color of all the roads
     treeColor         the color of the network
     pairColor         the color of the circles and the
                       roads between pairs
     lookColor         the color of the walk
     lineColor         the color of the trip
     pointColor        the color of the cities
     textColor         the color of the words
     citySize          how big each city's dot is

   THE EQUATIONS

   The length of the road between two cities, at x1, y1 and
   x2, y2, rounded to a whole number:

       distance = sqrt((x2 - x1)^2 + (y2 - y1)^2)

   The length of the trip is the lengths of its roads added
   up.

   =========================================================== */

// ---------- THE PAGE ------------------------------------
int pageWidth = 612;     // 8.5 inches when printed
int pageHeight = 792;    // 11 inches when printed
float pageMargin = 72 / 4.0;   // a quarter inch when printed

// ---------- THE CITIES ----------------------------------
int numberOfCities = 10;
float cityGap = 90;

int framesPerMove = 90;
int framesHolding = 300;

// ---------- THE LOOK ------------------------------------
color paperColor = color(250, 247, 240);
color roadColor = color(180, 175, 165);   // warm gray
color treeColor = color( 60, 100, 190);   // cobalt blue
color pairColor = color(110, 160,  20);   // lime green
color lookColor = color(220,  70,  40);   // vermilion
color lineColor = color(150, 105,  10);   // dark gold
color pointColor = color( 70,  30,  60);   // dark plum
color textColor = color(0, 0, 0);
float citySize = 24;

// ---------- WORKED OUT FROM THE NUMBERS ABOVE -----------
float centerX = pageWidth / 2;

// room at the bottom of the page for the words
float wordsHeight = 80;

// how far in from the edges a city's center can be, so its
// whole dot is inside the margins
float edgeSpace = pageMargin + citySize / 2;

// ---------- THE DRAWING ---------------------------------
float[] cityX = new float[numberOfCities];
float[] cityY = new float[numberOfCities];
String cityNames = "ABCDEFGHIJKLMN";

// part 1: the network's roads, in the order they are added
int[] treeFrom = new int[numberOfCities - 1];
int[] treeTo = new int[numberOfCities - 1];

// part 2: the circled cities
int[] oddCities = new int[numberOfCities];
int numberOfOddCities;

// part 3: the roads between pairs
int[] pairFrom = new int[numberOfCities / 2];
int[] pairTo = new int[numberOfCities / 2];
int numberOfPairs;
int[] partner = new int[numberOfCities];       // used while
int[] bestPartner = new int[numberOfCities];   // trying every
int bestPairTotal;                             // pairing

// part 4: the walk, as the cities in the order walked
int[] walk = new int[numberOfCities * 2];
int walkLength;

// part 5: the trip, as the cities in the order visited
int[] trip = new int[numberOfCities];

// when each part starts, counted in moves
int treeStart;
int oddMove;
int pairStart;
int walkStart;
int tripStart;
int doneMove;

int animationFrame = 0;

void settings() {
  size(pageWidth, pageHeight, P2D);
  pixelDensity(1);
  smooth(8);
}

void setup() {
  makeNewMap();
}

// Scatters the cities, at least cityGap apart, and works out
// all five parts
void makeNewMap() {
  for (int cityNumber = 0; cityNumber < numberOfCities; cityNumber++) {
    // try spots until one is far enough from the other cities.
    // Give up after a while, in case there isn't room
    for (int tryNumber = 0; tryNumber < 1000; tryNumber++) {
      cityX[cityNumber] = random(edgeSpace, pageWidth - edgeSpace);
      cityY[cityNumber] = random(edgeSpace, pageHeight - wordsHeight - edgeSpace);
      boolean isFarEnough = true;
      for (int otherCity = 0; otherCity < cityNumber; otherCity++) {
        if (distanceBetween(cityNumber, otherCity) < cityGap) {
          isFarEnough = false;
        }
      }
      if (isFarEnough) {
        break;
      }
    }
  }

  // 1. the shortest network: start at home, city 0, and keep
  // adding the shortest road from a joined city to a city not
  // joined yet
  boolean[] isJoined = new boolean[numberOfCities];
  isJoined[0] = true;
  for (int roadNumber = 0; roadNumber < numberOfCities - 1; roadNumber++) {
    int shortestDistance = Integer.MAX_VALUE;
    for (int joinedCity = 0; joinedCity < numberOfCities; joinedCity++) {
      for (int newCity = 0; newCity < numberOfCities; newCity++) {
        if (isJoined[joinedCity] && !isJoined[newCity]
            && distanceBetween(joinedCity, newCity) < shortestDistance) {
          shortestDistance = distanceBetween(joinedCity, newCity);
          treeFrom[roadNumber] = joinedCity;
          treeTo[roadNumber] = newCity;
        }
      }
    }
    isJoined[treeTo[roadNumber]] = true;
  }

  // 2. the cities with an odd number of network roads
  int[] roadCount = new int[numberOfCities];
  for (int roadNumber = 0; roadNumber < numberOfCities - 1; roadNumber++) {
    roadCount[treeFrom[roadNumber]]++;
    roadCount[treeTo[roadNumber]]++;
  }
  numberOfOddCities = 0;
  for (int cityNumber = 0; cityNumber < numberOfCities; cityNumber++) {
    if (roadCount[cityNumber] % 2 == 1) {
      oddCities[numberOfOddCities] = cityNumber;
      numberOfOddCities++;
    }
  }

  // 3. pair up the circled cities, trying every pairing and
  // keeping the shortest
  for (int oddNumber = 0; oddNumber < numberOfOddCities; oddNumber++) {
    partner[oddNumber] = -1;
  }
  bestPairTotal = Integer.MAX_VALUE;
  tryPairings(0);
  numberOfPairs = 0;
  for (int oddNumber = 0; oddNumber < numberOfOddCities; oddNumber++) {
    if (bestPartner[oddNumber] > oddNumber) {
      pairFrom[numberOfPairs] = oddCities[oddNumber];
      pairTo[numberOfPairs] = oddCities[bestPartner[oddNumber]];
      numberOfPairs++;
    }
  }

  // 4. walk every road once, starting and ending at home. Put
  // all the roads in one list, then keep walking along roads
  // not used yet. At a dead end, back up, and add the cities
  // to the walk as you back up through them
  int numberOfRoads = numberOfCities - 1 + numberOfPairs;
  int[] roadFrom = new int[numberOfRoads];
  int[] roadTo = new int[numberOfRoads];
  for (int roadNumber = 0; roadNumber < numberOfCities - 1; roadNumber++) {
    roadFrom[roadNumber] = treeFrom[roadNumber];
    roadTo[roadNumber] = treeTo[roadNumber];
  }
  for (int pairNumber = 0; pairNumber < numberOfPairs; pairNumber++) {
    roadFrom[numberOfCities - 1 + pairNumber] = pairFrom[pairNumber];
    roadTo[numberOfCities - 1 + pairNumber] = pairTo[pairNumber];
  }
  boolean[] isUsed = new boolean[numberOfRoads];
  int[] path = new int[numberOfRoads + 1];
  int pathLength = 1;
  path[0] = 0;
  walkLength = 0;
  while (pathLength > 0) {
    int here = path[pathLength - 1];
    int nextCity = -1;
    for (int roadNumber = 0; roadNumber < numberOfRoads && nextCity == -1; roadNumber++) {
      if (!isUsed[roadNumber] && roadFrom[roadNumber] == here) {
        nextCity = roadTo[roadNumber];
        isUsed[roadNumber] = true;
      } else if (!isUsed[roadNumber] && roadTo[roadNumber] == here) {
        nextCity = roadFrom[roadNumber];
        isUsed[roadNumber] = true;
      }
    }
    if (nextCity == -1) {
      walk[walkLength] = here;
      walkLength++;
      pathLength--;
    } else {
      path[pathLength] = nextCity;
      pathLength++;
    }
  }

  // 5. follow the walk, skipping cities already visited
  boolean[] isVisited = new boolean[numberOfCities];
  int stop = 0;
  for (int walkNumber = 0; walkNumber < walkLength; walkNumber++) {
    if (!isVisited[walk[walkNumber]]) {
      trip[stop] = walk[walkNumber];
      isVisited[walk[walkNumber]] = true;
      stop++;
    }
  }

  // one move for each road added, plus one to show the map and
  // one to circle the cities
  treeStart = 1;
  oddMove = treeStart + numberOfCities - 1;
  pairStart = oddMove + 1;
  walkStart = pairStart + numberOfPairs;
  tripStart = walkStart + walkLength - 1;
  doneMove = tripStart + numberOfCities;

  animationFrame = 0;
}

// Tries every way to pair up the circled cities that aren't
// paired yet, and keeps the one with the shortest total
void tryPairings(int totalSoFar) {
  if (totalSoFar >= bestPairTotal) {
    return;   // already longer than the best, so stop early
  }
  int first = 0;
  while (first < numberOfOddCities && partner[first] != -1) {
    first++;
  }
  if (first == numberOfOddCities) {
    // everyone is paired, and this is the best so far
    bestPairTotal = totalSoFar;
    for (int oddNumber = 0; oddNumber < numberOfOddCities; oddNumber++) {
      bestPartner[oddNumber] = partner[oddNumber];
    }
    return;
  }
  for (int second = first + 1; second < numberOfOddCities; second++) {
    if (partner[second] == -1) {
      partner[first] = second;
      partner[second] = first;
      tryPairings(totalSoFar + distanceBetween(oddCities[first], oddCities[second]));
      partner[first] = -1;
      partner[second] = -1;
    }
  }
}

void draw() {
  int move = min(animationFrame / framesPerMove, doneMove);

  // how many roads of each part are showing
  int treeShowing = constrain(move - treeStart + 1, 0, numberOfCities - 1);
  int pairsShowing = constrain(move - pairStart + 1, 0, numberOfPairs);
  int walkShowing = constrain(move - walkStart + 1, 0, walkLength - 1);
  int tripShowing = constrain(move - tripStart + 1, 0, numberOfCities);

  background(paperColor);
  textAlign(CENTER, CENTER);

  // every road, in gray
  for (int firstCity = 0; firstCity < numberOfCities; firstCity++) {
    for (int secondCity = firstCity + 1; secondCity < numberOfCities; secondCity++) {
      drawRoad(firstCity, secondCity, roadColor, 1);
    }
  }

  // the network and the pairs
  for (int roadNumber = 0; roadNumber < treeShowing; roadNumber++) {
    drawRoad(treeFrom[roadNumber], treeTo[roadNumber], treeColor, 3);
  }
  for (int pairNumber = 0; pairNumber < pairsShowing; pairNumber++) {
    drawRoad(pairFrom[pairNumber], pairTo[pairNumber], pairColor, 3);
  }

  // the walk, until the trip starts
  if (move < tripStart) {
    for (int walkNumber = 0; walkNumber < walkShowing; walkNumber++) {
      drawRoad(walk[walkNumber], walk[walkNumber + 1], lookColor, 5);
    }
  }

  // the trip
  for (int stop = 1; stop <= tripShowing; stop++) {
    drawRoad(trip[stop - 1], trip[stop % numberOfCities], lineColor, 5);
  }

  // circles around the odd cities, until the trip starts
  if (move >= oddMove && move < tripStart) {
    noFill();
    stroke(pairColor);
    strokeWeight(3);
    for (int oddNumber = 0; oddNumber < numberOfOddCities; oddNumber++) {
      circle(cityX[oddCities[oddNumber]], cityY[oddCities[oddNumber]], citySize + 12);
    }
  }

  // the cities, on top of the roads
  for (int cityNumber = 0; cityNumber < numberOfCities; cityNumber++) {
    noStroke();
    fill(pointColor);
    circle(cityX[cityNumber], cityY[cityNumber], citySize);
    fill(paperColor);
    textSize(13);
    text(cityNames.charAt(cityNumber), cityX[cityNumber], cityY[cityNumber] - 1);
  }

  // what is happening, in words
  String saying;
  if (move == doneMove) {
    saying = "Done! At most 1.5 times as long as the shortest trip.";
  } else if (move >= tripStart) {
    int from = trip[tripShowing - 1];
    int to = trip[tripShowing % numberOfCities];
    saying = "5. Follow the walk, skipping visited cities: " + roadName(from, to) + ".";
  } else if (move >= walkStart) {
    saying = "4. Walk every road once, ending at home. Now at "
           + cityNames.charAt(walk[walkShowing]) + ".";
  } else if (move >= pairStart) {
    int pairNumber = pairsShowing - 1;
    saying = "3. Pair up circled cities, shortest in total: "
           + roadName(pairFrom[pairNumber], pairTo[pairNumber]) + ".";
  } else if (move == oddMove) {
    saying = "2. Circle the cities with an odd number of network roads.";
  } else if (move >= treeStart) {
    int roadNumber = treeShowing - 1;
    saying = "1. Grow the shortest network: "
           + roadName(treeFrom[roadNumber], treeTo[roadNumber]) + ".";
  } else {
    saying = "Every road between two cities, with its length.";
  }

  // the trip's length so far, added up
  String addingUp = "";
  if (tripShowing > 0) {
    int tripLength = 0;
    for (int stop = 1; stop <= tripShowing; stop++) {
      int distance = distanceBetween(trip[stop - 1], trip[stop % numberOfCities]);
      tripLength += distance;
      if (stop > 1) {
        addingUp += " + ";
      }
      addingUp += distance;
    }
    addingUp = "Trip length: " + addingUp + " = " + tripLength;
  }

  fill(textColor);
  textSize(14);
  text(saying, centerX, pageHeight - pageMargin - 50);
  textSize(12);
  text(addingUp, centerX, pageHeight - pageMargin - 20);

  animationFrame++;
  if (animationFrame >= doneMove * framesPerMove + framesHolding) {
    makeNewMap();
  }
}

// A road's name and length, like "B to H (120)"
String roadName(int firstCity, int secondCity) {
  return cityNames.charAt(firstCity) + " to " + cityNames.charAt(secondCity)
       + " (" + distanceBetween(firstCity, secondCity) + ")";
}

// Draws the road between two cities, with its length in the
// middle
void drawRoad(int firstCity, int secondCity, color roadLook, float thickness) {
  stroke(roadLook);
  strokeWeight(thickness);
  line(cityX[firstCity], cityY[firstCity], cityX[secondCity], cityY[secondCity]);

  // the length, on a patch of paper so the road doesn't run
  // through it
  String label = str(distanceBetween(firstCity, secondCity));
  float middleX = (cityX[firstCity] + cityX[secondCity]) / 2;
  float middleY = (cityY[firstCity] + cityY[secondCity]) / 2;
  textSize(10);
  noStroke();
  fill(paperColor);
  rect(middleX - textWidth(label) / 2 - 2, middleY - 7, textWidth(label) + 4, 13);
  fill(roadLook);
  text(label, middleX, middleY - 1);
}

// The length of the road between two cities, from the
// equation above
int distanceBetween(int firstCity, int secondCity) {
  float x1 = cityX[firstCity];
  float y1 = cityY[firstCity];
  float x2 = cityX[secondCity];
  float y2 = cityY[secondCity];
  return round(sqrt(sq(x2 - x1) + sq(y2 - y1)));
}

/* ===========================================================
   TRY THESE (change a value, press PLAY, see what's different):

     int numberOfCities = 5;     // small enough to find the
                                 // shortest trip yourself

     int numberOfCities = 14;    // a busy map
     float cityGap = 70;

     int framesPerMove = 180;    // slower, to talk it through

   =========================================================== */
