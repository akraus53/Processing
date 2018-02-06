class Dna {
  PVector[] genes = new PVector[lifespan];


  Dna(PVector[] genes) {
    if (genes != null) {
      this.genes = genes;
    } 

    // If no genes just create random dna
    else {
      for (int i = 0; i < lifespan; i++) {
        // Gives random vectors
        this.genes[i] = PVector.random2D();
        // Sets maximum force of vector to be applied to a rocket
        this.genes[i].setMag(maxforce);
      }
    }
  }

  Dna crossover(Dna partner) {
    PVector[] newgenes = new PVector[lifespan];

    int mid = floor(random(this.genes.length));

    for (int i = 0; i < this.genes.length; i++) {
      if (mid < lifespan) {
        newgenes[i] = this.genes[i];
      } else {
        newgenes[i] = partner.genes[i];
      }
    }      

    return new Dna(newgenes);
  }

  void mutation() {
    // swap out a snippet of DNA for a new one

    int end = floor(random(0, bestTime));
    int start = floor(random(0, end));

    for (int i = start; i < end; i++) {
      // if random number less than 0.01, new gene is then random vector
      if (random(1) < 0.05) {
        this.genes[i] = PVector.random2D();
        this.genes[i].setMag(maxforce);
      }
    }
  }
}