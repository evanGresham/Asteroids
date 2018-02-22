//playing asteroids
Player testPlayer;
Population pop;
//------------------------------------------------------------------------------------------------------------------------------------------
boolean showBest = false;
void setup() {
  size(1200, 675);
  testPlayer = new Player();
  pop = new Population(100, 0.1);
  frameRate(200);
}
//------------------------------------------------------------------------------------------------------------------------------------------

void draw() {
  background(0); 
  if (!pop.done()) {
    pop.updateAlive();
  } else {
    pop.calculateFitness(); 
    pop.naturalSelection();
  }
}
//------------------------------------------------------------------------------------------------------------------------------------------

void keyPressed() {
  switch(key) {
  case ' ':
    showBest = !showBest;
    break;
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------

boolean isOut(PVector pos) {
  if (pos.x < -50 || pos.y < -50 || pos.x > width+ 50 || pos.y > 50+height) {
    return true;
  }
  return false;
}