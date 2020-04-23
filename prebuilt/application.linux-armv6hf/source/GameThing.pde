/**
* Panels are done, either press on a panel to open it, or use the number keys to toggle them
* scene transition animations work now but need polishing

 CHANGELOG:
 2.2.2020
 - added tree and mountain sprites
 2.3.2020
 - cleaned up code
 - added exit prompt
 - made house sprite
*/



PImage backgroundImage;

PFont germanica;
PFont simple;

String scene = "load";

boolean mousePressed = false;

boolean exitGame = false;

/**
  used for development only, sends the user into the game on game start
*/
boolean goneToGameOnStart = false;
boolean developerMode = false;

OpenSimplexNoise noise;

float gameZoom = 1;

void setup () {

  germanica = createFont("fonts/Plain Germanica.ttf", 32);
  simple = loadFont("fonts/simpleFont.vlw");

  // fullScreen(P2D, 1);
  size(1600, 900, P2D);
  background(0);

  textFont(germanica);
  textAlign(CENTER, CENTER);

  splashScreen();

  noise = new OpenSimplexNoise();
  backgroundImage = loadImage("worldMap.png");

}



void draw () {

  switch (scene) {
    case "load":
        loadAssets();
        splashScreen();
    break;
    case "menu":
        menu();
        // if (!goneToGameOnStart) {
        //   scene = "game"; // FOR DEV
        //   goneToGameOnStart = true;
        // }
    break;
    case "credits":
        creditsScreen();
    break;
    case "options":
        optionsScreen();
    break;
    case "game":
        background(0, 0, 0);
        image(terrainImg, 0, 0, width, height); // Draw an image of the terrain, instead of using for loops
        tileGrid(); // Update the mouse/tile grid
        game();
    break;
    case "multiplayer":
        background(0, 0, 0);
        image(terrainImg, 0, 0, width, height); // Draw an image of the terrain, instead of using for loops
        tileGrid(); // Update the mouse/tile grid
        game();
        
        connectToServer();
    break;
  }

  guiManager(); // Calls all GUI elements
  resetInputVariables();

}
