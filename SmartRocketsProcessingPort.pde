/*******************************+
 * Author: Alexander Kraus (@akraus53)
 * in large parts inspired by Daniel Shiffman (@shiffman)
 * (c) 2017-18
 */


Population population;
int lifespan = 500;
int count = 0; //current frame of Lap
float maxforce = 2; // set screw for acceleration
int popSize = 250; // number of rockets launched every Lap 
int randomOnes = 10; // number of new, random rockets launched


boolean allCrashed;
Rocket bestRocket;
boolean drawingLine = false;


// Game statistics
int totalHits;
int hitsThisRound;
int allTimeBestHits;

boolean timeLogged = false;
int bestTime = lifespan;
int allTimeBestTime = lifespan;
int lap = 0;

// target and barrier vars
PVector target;
int rw, rx, ry, rh, bw, bx, by, bh;

void setup() {
  size(1600, 900);
  population = new Population();
  target = new PVector(width/2, 50);

  // barrier 1
  rw = floor(width*0.7);
  rx = floor((width-1.5*rw)/2);
  ry = floor(height*0.7);
  rh = 30;

  //barrier 2
  bw = rw;
  bx = floor((2*width-2*rw)/2);
  by = floor(height * 0.35);
  bh = 30;
}

void draw() {
  background(0);
  population.run();

  count++;

  // If every rocket has crashed, there's no need to wait for all of the loops to finish
  if (population.allCrashed()) {
    count = lifespan;
  }

  if (count == lifespan) {
    population.evaluate();
    population.selection();

    updateHighscores();
    resetStatistics();
  }


  // draw the barriers and the target
  noStroke();
  fill(255);
  rectMode(CORNER);
  rect(rx, ry, rw, rh);
  rect(bx, by, bw, bh);

  ellipse(target.x, target.y, 16, 16);

  drawBestPath();
  showStats();
}

void updateHighscores() {
  if (hitsThisRound > allTimeBestHits) {
    allTimeBestHits = hitsThisRound;
  }

  if (bestTime < allTimeBestTime) {
    allTimeBestTime = bestTime;
  }
}

void resetStatistics() {
  lap++;
  hitsThisRound = 0;
  count = 0;
  timeLogged = false;
  bestTime = lifespan;
}

void showStats() {
  fill(255);
  textSize(30);
  textAlign(TOP);
  text(("Hits this round:" + hitsThisRound), 10, 30);
  text(("Highscore:" + allTimeBestHits), 10, 60);

  text(("Best time in this round:" + bestTime), 10, 90);
  text(("Best time ever:" + allTimeBestTime), 10, 120);
  text(("Lap #" + (lap+1)), 10, 150);
  text(count, 10, 180);
}

void drawBestPath() {
  // Draw a dotted line where the rocket with the fastest path was 

  strokeWeight(5);
  stroke(255);
  beginShape(LINES);

  if (timeLogged || drawingLine) {
    drawingLine = true;
    
    // rocket has to be reset after every drawing cycle
    bestRocket.pos = new PVector(width/2, height -30);
    bestRocket.vel.mult(0);
    bestRocket.acc.mult(0);
    bestRocket.completed = false;
    bestRocket.crashed = false;

    for (int i = 0; i<lifespan; i++) {
      if (!bestRocket.crashed && !bestRocket.completed) {

        bestRocket.update(i);
      }
      vertex(bestRocket.pos.x, bestRocket.pos.y);
    }
    hitsThisRound--;
  }
}