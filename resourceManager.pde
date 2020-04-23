class Resource {

  int amountCollected;
  int increase; // Per second

  Resource () {

  }

  void computeAmounts () {
    amountCollected += increase;
  }

  void addResource (int amount) {
    amountCollected += amount;
  }

  void removeResource (int amount) {
    amountCollected -= amount;
  }

}

class Gold extends Resource {

}

class Wood extends Resource {

}

class Food extends Resource {

}
