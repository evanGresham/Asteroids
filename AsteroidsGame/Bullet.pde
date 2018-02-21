class Bullet {
  PVector pos;
  PVector vel;
  float speed = 10; // set sppeed to be 10+ palyer speed
  boolean off = false;
  int lifespan = 60;
  //------------------------------------------------------------------------------------------------------------------------------------------

  Bullet(float x, float y, float r) {

    pos = new PVector(x, y);
    vel = new PVector();
    vel = PVector.fromAngle(r);
    vel.mult(speed);
  }

  //------------------------------------------------------------------------------------------------------------------------------------------

  void move() {
    lifespan --;
    if (lifespan<0) {
      off = true;
    } else {
      pos.add(vel);   
      if (isOut(pos)) {
        loopy();
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------

  void show() {
    if (!off) {
      fill(255);
      ellipse(pos.x, pos.y, 3, 3);
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------

  void loopy() {
    if (pos.y < -50) {
      pos.y = height + 50;
    } else
      if (pos.y > height + 50) {
        pos.y = -50;
      }
    if (pos.x< -50) {
      pos.x = width +50;
    } else  if (pos.x > width + 50) {
      pos.x = -50;
    }
  }
}   