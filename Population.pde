class Population {
  Rocket[] rockets; 

  Rocket[] matingPool;

  Population() {
    this.rockets = new Rocket[popSize];
    for (int i = 0; i < popSize; i++) {
      this.rockets[i] = new Rocket();
    }
  }

  void evaluate() {
    float maxFit = 0;

    for (int i = 0; i< popSize; i++) {
      this.rockets[i].calcFitness();
      if (this.rockets[i].fitness > maxFit) {
        maxFit = this.rockets[i].fitness;
      }
    }


    // Normalises fitnesses
    for (int i = 0; i < popSize; i++) {
      this.rockets[i].fitness /= maxFit;
    }

    int lengthOfMatingPool = 0;
    for (int i = 0; i < popSize; i++) {
      int n = (int) (this.rockets[i].fitness * 100);
      lengthOfMatingPool += n;
    }

    int currentIndex = 0;

    this.matingPool = new Rocket[lengthOfMatingPool];
    for (int i = 0; i < popSize; i++) {
      int n = (int) (this.rockets[i].fitness * 100);
      for (int j = 0; j < n; j++) {
        this.matingPool[currentIndex]= this.rockets[i];
        currentIndex++;
      }
    }
  }

  void selection() {
    Rocket[] newRockets = new Rocket[this.rockets.length];

    for (int i = 0; i< (popSize-randomOnes); i++) {
      // Picks random indexes for crossover
      int parentAindex = floor(random(this.matingPool.length));
      int parentBindex = floor(random(this.matingPool.length));

      Rocket parentA = this.matingPool[parentAindex];
      Rocket parentB = this.matingPool[parentBindex];


      // Creates child by using crossover function
      Dna child = parentA.dna.crossover(parentB.dna);

      child.mutation();

      // Creates new rocket with child dna
      newRockets[i] = new Rocket(child);

      // The color of the "child" is a mix of the parents' colors 
      newRockets[i].paint = (parentA.paint + parentB.paint) / 2;
    }

    for (int i = (popSize-randomOnes); i<popSize; i++) {
      newRockets[i] = new Rocket();
    }
    this.rockets = newRockets;
  }


  boolean allCrashed() {
    boolean crashed = true;
    // if there's an alive rocket, not all have crashed
    for (int i = 0; i < this.rockets.length; i++) {
      if (!this.rockets[i].crashed && !this.rockets[i].completed) {
        crashed = false;
      }
    }
    return crashed;
  }
  // Calls for update and show functions
  void run() {
    for (int i = 0; i < this.rockets.length; i++) {
      if (!this.rockets[i].completed) {
        this.rockets[i].update(count);
        // Displays rockets to screen
      }

      if (this.rockets[i].completed && !timeLogged) {
        bestTime = this.rockets[i].time;
        timeLogged = true;
        bestRocket = new Rocket(this.rockets[i].dna);
      }
      this.rockets[i].show();
    }
  }
}