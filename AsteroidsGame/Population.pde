class Population {
  Player[] players;
  float mutationRate;
  long fitnessSum;
  int bestPlayerNo;
  int gen = 1;
  int globalBest = 4;
  int currentBest = 4;
  int currentBestplayer = 0;
  long globalBestFitness = 0;
  Player bestPlayer;

  //------------------------------------------------------------------------------------------------------------------------------------------

  Population(int size, float mr) {
    players = new Player[size];
    for (int i =0; i<players.length; i++) {
      players[i] = new Player();
    }
    mutationRate = mr;
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void updateAlive() {
    int count = 0;
    for (int i = 0; i< players.length; i++) {
      if (!players[i].dead) {
        players[i].look();
        players[i].think();
        players[i].update();
        if (!showBest || i ==0) {
          players[i].show();
        }
        count++;
      }
    }
    println("alive",count);
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void setBestPlayer() {
    float max =0;
    int maxIndex = 0;
    for (int i =0; i<players.length; i++) {
      if (players[i].fitness > max) {
        max = players[i].fitness;
        maxIndex = i;
      }
    }

    bestPlayerNo = maxIndex;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------

  boolean done() {
    for (int i = 0; i< players.length; i++) {
      if (!players[i].dead) {

        return false;
      }
    }

    return true;
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void calcFitness() {
    for (int i = 0; i< players.length; i++) {

      players[i].calculateFitness();
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void naturalSelection() {


    Player[] newPlayers = new Player[players.length];//Create new players array for the next generation

    setBestPlayer();//set which player is the best

    newPlayers[0] = players[bestPlayerNo].clone();//add the best player of this generation to the next generation without mutation
    for (int i = 1; i<players.length; i++) {
      //for each remaining spot in the next generation
      newPlayers[i] = selectPlayer().clone();//select a random player(based on fitness) and clone it
      newPlayers[i].mutate(mutationRate); //mutate it
    }

    players = newPlayers.clone();
    gen+=1;
  }

  //------------------------------------------------------------------------------------------------------------------------------------------


  Player selectPlayer() {
    fitnessSum = 0;
    for (int i =0; i<players.length; i++) {
      fitnessSum += players[i].fitness;
    }
    int rand = floor(random(fitnessSum));
    //summy is the current fitness sum
    int summy = 0;

    for (int i = 0; i< players.length; i++) {
      summy += players[i].fitness; 
      if (summy > rand) {
        return players[i];
      }
    }
    //unreachable code
    return players[0];
  }

  //------------------------------------------------------------------------------------------------------------------------------------------


  void mutate() {
    for (int i =1; i<players.length; i++) {
      players[i].mutate(mutationRate);
    }
  }
  //------------------------------------------------------------------------------------------------------------------------------------------

  void calculateFitness() {
    for (int i =1; i<players.length; i++) {
      players[i].calculateFitness();
    }
  }
}