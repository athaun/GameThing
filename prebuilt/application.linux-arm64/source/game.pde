int startingResources = 200;
boolean givenStartingResources = false;

void game () {

  gold.computeAmounts();
  food.computeAmounts();
  wood.computeAmounts();

  // Starting resources
  if (!givenStartingResources) {
    gold.addResource(100);
    food.addResource(100);
    wood.addResource(100);
    givenStartingResources = true;
  }
}
