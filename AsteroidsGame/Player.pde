class Player {
  PVector pos;
  PVector vel;
  PVector acc;
  boolean canShoot;
  int shootCount = 0;
  float rotation;
  float spin;
  float maxSpeed = 10;
  boolean boosting = false;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  ArrayList<Asteroid> asses = new ArrayList<Asteroid>();
  int asteroidCount = 1000;
  int lives = 300;
  boolean dead = false;
  // boolean immortal = false;//is true for a few seconds after dying
  int immortalCount = 0;
  int boostCount = 10;
  //------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Player() {
    pos = new PVector(width/2, height/2);
    vel = new PVector();
    acc = new PVector();  
    rotation = 0;
    asses.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 3));
    asses.add(new Asteroid(random(width), 0, random(-1, 1), random (-1, 1), 3));
    asses.add(new Asteroid(0, random(height), random(-1, 1), random (-1, 1), 3));
    asses.add(new Asteroid(0, random(height), random(-1, 1), random (-1, 1), 3));
    asses.add(new Asteroid(random(width), random(height), random(-1, 1), random (-1, 1), 3));
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //Move player
  void move() {
    if (!dead) {
      shootCount --;
      asteroidCount--;
      if (asteroidCount<=0) {
        asses.add(new Asteroid(-50, random(height), random(-1, 1), random (-1, 1), 3));
        asteroidCount = 1000;
      }
      rotatePlayer();
      if (boosting) {
        boost();
      } else {
        boostOff();
      }
      vel.add(acc);//velocity += acceleration
      vel.limit(maxSpeed);
      vel.mult(0.99);
      pos.add(vel);//position += velocity

      for (int i = 0; i < bullets.size(); i++) {
        bullets.get(i).move();
      }

      for (int i = 0; i < asses.size(); i++) {
        asses.get(i).move();
      }
      if (isOut(pos)) {
        loopy();
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //booster
  void boost() {
    acc = PVector.fromAngle(rotation); 
    acc.setMag(0.1);
  }
  
//------------------------------------------------------------------------------------------------------------------------------------------

  void boostOff() {
    acc.setMag(0);
  }
//------------------------------------------------------------------------------------------------------------------------------------------

  void rotatePlayer() {
    rotation += spin;
  }
//------------------------------------------------------------------------------------------------------------------------------------------

  void show() {
    if (!dead) {
      for (int i = 0; i < bullets.size(); i++) {
        bullets.get(i).show();
      }
      if (immortalCount >0) {
        immortalCount --;
      }
      if (immortalCount >0 && floor(((float)immortalCount)/5)%2 ==0) {
      } else {
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rotation);

        fill(0);
        //noFill();
        noStroke();
        beginShape();
        int size = 12;
        vertex(-size-2, -size);
        vertex(-size-2, size);
        vertex(2* size -2, 0);
        endShape(CLOSE);
        stroke(255);
        line(-size-2, -size, -size-2, size);
        line(2* size -2, 0, -22, 15);
        line(2* size -2, 0, -22, -15);
        if (boosting ) {
          boostCount --;
          if (floor(((float)boostCount)/3)%2 ==0) {
            line(-size-2, 6, -size-2-12, 0);
            line(-size-2, -6, -size-2-12, 0);
          }
        }

        popMatrix();
      }
    }
    for (int i = 0; i < asses.size(); i++) {
      asses.get(i).show();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void shoot() {
    if (shootCount <=0) {
      bullets.add(new Bullet(pos.x, pos.y, rotation));
      shootCount = 20;
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void update() {
    for (int i = 0; i < bullets.size(); i++) {
      if (bullets.get(i).off) {
        bullets.remove(i);
        i--;
      }
    }    
    move();
    checkPositions();
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void checkPositions() {
    for (int i = 0; i < bullets.size(); i++) {
      for (int j = 0; j < asses.size(); j++) {
        if ( asses.get(j).checkIfHit(bullets.get(i).pos)) {
          //asses.remove(j);
          bullets.remove(i);
          //i--;
          break;
        }
      }
    }
    if (immortalCount <=0) {
      for (int j = 0; j < asses.size(); j++) {
        if (asses.get(j).checkIfHitPlayer(pos)) {
          playerHit();
        }
      }
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void playerHit() {
    if (lives == 0) {
      dead = true;
    } else {
      lives -=1;
      immortalCount = 100;
      resetPositions();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void resetPositions() {
    pos = new PVector(width/2, height/2);
    vel = new PVector();
    acc = new PVector();  
    bullets = new ArrayList<Bullet>();
    rotation = 0;
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