class Asteroid {
  PVector pos;
  PVector vel; 
  int size = 3;
  float radius;
  ArrayList<Asteroid> chunks = new ArrayList<Asteroid>();
  boolean split = false;//whether the asteroid has been hit and split into to 2

  //------------------------------------------------------------------------------------------------------------------------------------------

  Asteroid(float posX, float posY, float velX, float velY, int sizeNo) {
    pos = new PVector(posX, posY);
    size = sizeNo;
    vel = new PVector(velX, velY);

    switch(sizeNo) {
    case 1:
      radius = 15;
      vel.normalize();
      vel.mult(1.5);
      break;
    case 2:
      radius = 30;
      vel.normalize();
      vel.mult(1);
      break;
    case 3:
      radius = 60;
      vel.normalize();
      vel.mult(0.75);
      break;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------

  void show() {
    if (split) {
      for (Asteroid a : chunks) {
        a.show();
      }
    } else {
      noFill();
      stroke(255);

      ellipse(pos.x, pos.y, radius*2, radius*2);
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void move() {
    if (split) {
      for (Asteroid a : chunks) {
        a.move();
      }
    } else {
      pos.add(vel);
      if (isOut(pos)) {
        loopy();
      }
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
  //------------------------------------------------------------------------------------------------------------------------------------------

  boolean checkIfHit(PVector bulletPos) {
    if (split) {
      for (Asteroid a : chunks) {
        if (a.checkIfHit(bulletPos)) {
          return true;
        }
      }
      return false;
    } else {
      if (dist(pos.x, pos.y, bulletPos.x, bulletPos.y)< radius) {
        isHit();
        return true;
      }
      return false;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  boolean checkIfHitPlayer(PVector bulletPos) {
    if (split) {
      for (Asteroid a : chunks) {
        if (a.checkIfHitPlayer(bulletPos)) {
          return true;
        }
      }
      return false;
    } else {
      if (dist(pos.x, pos.y, bulletPos.x, bulletPos.y)< radius + 15) {
        isHit();

        return true;
      }
      return false;
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------


  void isHit() {
    split = true;
    if (size == 1) {
      return;
    } else {

      chunks.add(new Asteroid(pos.x, pos.y, vel.x + randomGaussian(), vel.y + randomGaussian(), size-1)); 
      chunks.add(new Asteroid(pos.x, pos.y, vel.x+ randomGaussian(), vel.y+ randomGaussian(), size-1));
    }
  }
}