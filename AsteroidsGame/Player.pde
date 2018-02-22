class Player {
  PVector pos;
  PVector vel;
  PVector acc;
  int score = 0;
  int lifespan = 0;
  int shootCount = 0;
  float rotation;
  float spin;
  float maxSpeed = 10;
  boolean boosting = false;
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  ArrayList<Asteroid> asses = new ArrayList<Asteroid>();
  int asteroidCount = 1000;
  int lives = 0;
  boolean dead = false;
  int immortalCount = 0;
  int boostCount = 10;
  //--------AI stuff
  NeuralNet brain;
  float[] vision = new float[8];
  float[] decision = new float[4];

  int fitness;
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
    asses.add(new Asteroid(random(width), random(height), random(-1, 1), random (-1, 1), 3));
    float randX = random(width);
    float randY = -50 +floor(random(2))* (height+100);
    asses.add(new Asteroid(randX, randY, pos.x- randX, pos.y - randY, 3));    


    brain = new NeuralNet(8, 12, 4);
  }
  //------------------------------------------------------------------------------------------------------------------------------------------
  //Move player
  void move() {
    if (!dead) {
      lifespan +=1;
      shootCount --;
      asteroidCount--;
      if (asteroidCount<=0) {


        float randX = random(width);
        float randY = -50 +floor(random(2))* (height+100);
        asses.add(new Asteroid(randX, randY, pos.x- randX, pos.y - randY, 3));
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
      bullets.add(new Bullet(pos.x, pos.y, rotation, vel.mag()));
      shootCount = 80;
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
        if (asses.get(j).checkIfHit(bullets.get(i).pos)) {
          bullets.remove(i);
          score +=1;
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

  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void calculateFitness() {
    fitness = 0;
    fitness = (score+1)*(score+1);
    fitness *= lifespan;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  void mutate(float mr) {
    brain.mutate(mr);
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  Player clone() {
    Player clone = new Player();
    clone.brain = brain.clone();
    return clone;
  }


  //---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //looks in 8 directions to find asteroids
  void look() {
    vision = new float[8];
    //look left
    PVector direction;
    for (int i = 0; i< vision.length; i++) {
      direction = PVector.fromAngle(rotation + i*(PI/4));
      direction.mult(10);
      vision[i] = lookInDirection(direction);
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  


  float lookInDirection(PVector direction) {
    //set up a temp array to hold the values that are going to be passed to the main vision array

    PVector position = new PVector(pos.x, pos.y);//the position where we are currently looking for food or tail or wall
    float distance = 0;
    //move once in the desired direction before starting 
    position.add(direction);
    distance +=1;

    //look in the direction until you reach a wall
    while (distance< 60) {//!(position.x < 400 || position.y < 0 || position.x >= 800 || position.y >= 400)) {


      for (Asteroid a : asses) {
        if (a.lookForHit(position) ) {
          return  1/distance;
        }
      }

      //look further in the direction
      position.add(direction);

      //loop it
      if (position.y < -50) {
        position.y += height + 100;
      } else
        if (position.y > height + 50) {
          position.y -= height -100;
        }
      if (position.x< -50) {
        position.x += width +100;
      } else  if (position.x > width + 50) {
        position.x -= width +100;
      }


      distance +=1;
    }
    return 0;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------      
  //convert the output of the neural network to actions
  void think() {
    //get the output of the neural network
    decision = brain.output(vision);

    if (decision[0] > 0.8) {//output 0 is boosting
      boosting = true;
    } else {
      boosting = false;
    }
    if (decision[1] > 0.8) {//output 1 is turn left
      spin = -0.08;
    } else {//cant turn right and left at the same time 
      if (decision[2] > 0.8) {//output 2 is turn right
        spin = 0.08;
      } else {//if neither then dont turn
        spin = 0;
      }
    }
    //shooting
    if (decision[3] > 0.8) {//output 3 is shooting
      shoot();
    }
  }
}