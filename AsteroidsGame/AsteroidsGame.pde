//playing asteroids
Player testPlayer;
  //------------------------------------------------------------------------------------------------------------------------------------------

void setup() {
  size(1200, 675);
  testPlayer = new Player();
}
  //------------------------------------------------------------------------------------------------------------------------------------------

void draw() {
  background(0); 
  testPlayer.update();
  testPlayer.show();
}
  //------------------------------------------------------------------------------------------------------------------------------------------

void keyPressed() {
  switch(key) {
  case 'w':
    testPlayer.boosting = true;
    break;
  case 'a':
    testPlayer.spin = -0.08;
    break;
  case 'd':
    testPlayer.spin = 0.08;
    break;
  case ' ':
    testPlayer.shoot();
    break;
  }
}
  //------------------------------------------------------------------------------------------------------------------------------------------

void keyReleased() {
  switch(key) {
  case 'w':
    testPlayer.boosting = false;
    break;
  case 'a':
    testPlayer.spin = 0;
    break;
  case 'd':
    testPlayer.spin = 0;
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