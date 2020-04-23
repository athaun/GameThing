import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 
import processing.sound.*; 
import processing.net.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GameThing extends PApplet {

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

public void setup () {

  germanica = createFont("fonts/Plain Germanica.ttf", 32);
  simple = loadFont("fonts/simpleFont.vlw");

  // fullScreen(P2D, 1);
  
  background(0);

  textFont(germanica);
  textAlign(CENTER, CENTER);

  splashScreen();

  noise = new OpenSimplexNoise();
  backgroundImage = loadImage("worldMap.png");

}



public void draw () {

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
/**
Contains all Graphical user interface classes and methods like buttons, modals, the minimap, etc.
*/

class Panel {

  int xPosition;
  int yPosition;
  int panelWidth;
  int panelHeight;

  boolean active;
  boolean goUp = false;
  boolean goDown = false;

  int animationSpeed = 50;

  Panel (int xPosition_, int panelWidth_, int panelHeight_) {
      xPosition = xPosition_;
      yPosition = height - 30;
      panelWidth = panelWidth_;
      panelHeight = panelHeight_;
  }

  public void draw () {

    if (!active) {
        fill(20);
        rect(xPosition, yPosition, panelWidth, panelHeight, 5);
        fill(200);
        if (mouseX > xPosition && mouseX < xPosition + panelWidth && mouseY > yPosition && mouseY < yPosition + 30) {
            strokeWeight(4);
            stroke(200);
            line(xPosition + panelWidth / 2 - 40, yPosition + 15, xPosition + panelWidth / 2, yPosition + 10); // up arrow
            line(xPosition + panelWidth / 2, yPosition + 10, xPosition + panelWidth / 2 + 40, yPosition + 15);
            cursor(HAND);
            if (mousePressed) {
                goUp = true;
                buttonClickSound.play();
            }
        } else {
            noStroke();
            rect(xPosition + panelWidth / 2 - 40, yPosition + 15, 80, 4);
            cursor(ARROW);
        }
        if (goUp) {
            yPosition -= animationSpeed;
            if (yPosition + panelHeight < height) {
              yPosition = height - panelHeight;
              goUp = false;
              active = true;
            }
        }
    } else {
        fill(20);
        rect(xPosition, yPosition, panelWidth, panelHeight, 5);
        fill(200);
        if (mouseX > xPosition && mouseX < xPosition + panelWidth && mouseY > yPosition && mouseY < yPosition + 30) {
            strokeWeight(4);
            stroke(200);
            line(xPosition + panelWidth / 2 - 40, yPosition + 15, xPosition + panelWidth / 2, yPosition + 20); // down arrow
            line(xPosition + panelWidth / 2, yPosition + 20, xPosition + panelWidth / 2 + 40, yPosition + 15);
            cursor(HAND);
            if (mousePressed) {
                goDown = true;
                buttonClickSound.play();
            }
        } else {
            noStroke();
            rect(xPosition + panelWidth / 2 - 40, yPosition + 15, 80, 4);
            cursor(ARROW);
        }
        if (goDown) {
            yPosition += animationSpeed;
            if (yPosition + 30 > height) {
              yPosition = height - 30;
              goDown = false;
              active = false;
            }
        }
    }

    noStroke();
  }

}

class Button {

  float xPosition = 0;
  float yPosition = 0;
  boolean pressed = false;
  int buttonWidth;
  int buttonHeight;
  String buttonTitle;
  float buttonHoverY = 0;

  Button (float xPos, float yPos, int btnWidth, int btnHeight, String btnTitle){
      xPosition = xPos;
      yPosition = yPos;
      buttonTitle = btnTitle;
      buttonWidth = btnWidth;
      buttonHeight = btnHeight;
  };

  public void draw (){
    if (mouseX > xPosition && mouseX < xPosition + buttonWidth && mouseY > yPosition && mouseY < yPosition + buttonHeight) {
        fill(50);
        if(mousePressed) {
            buttonClickSound.play();
            pressed = true;
            transitionStage = 1;
        }
    } else {
        fill(38);
        pressed = false;
    }

    noStroke();
    rect(xPosition, yPosition, buttonWidth, buttonHeight, 5);
    textAlign(CENTER, CENTER);
    fill(200);
    textSize(25);
    text(buttonTitle, xPosition + buttonWidth/2, yPosition + buttonHeight/2);
  }
}

int switchBtnColor = color(255);
class SwitchBtn {

  int x, y;
  // int bx, by;
  Boolean active;
  int slider;
  int sliderColor;
  boolean done;
  String title;

  SwitchBtn(int X, int Y, String _title) {
    x = X;
    y = Y;
    // bx = X;
    // by = Y;
    active = false;
    slider = 0;
    sliderColor = switchBtnColor;
    done = false;
    title = _title;
  }

  public void draw () {
    // fill(33);
    noFill();
    stroke(switchBtnColor);
    strokeWeight(5);
    if (mouseX > x - 2 && mouseX < x + 42 && mouseY > y - 2 && mouseY < y + 21) {
      cursor(HAND);
      if (mousePressed && !active && !done) {
        active = true; //turn it on
        done = true;
      } else if (mousePressed && done && active) {
        done = false;
        active = false;//turn it off
      }
    } else {
      cursor(ARROW);
    }
    if (active && done) {
      active = true;
      sliderColor = color(50);
      slider += 2;
      if (slider > 20) {
        slider = 20;
        done = true;
      }
      fill(switchBtnColor);
    } else {
      sliderColor = switchBtnColor;
      slider -= 2;
      if (slider < 0) {
        slider = 0;
        done = false;
      }
    } //off
    rect(x, y, 40, 19, 10);

    pushMatrix();
    translate(x + 10, y + 10);
    noStroke();
    fill(sliderColor);
    ellipse(slider, 0, 10, 10);
    popMatrix();
    textFont(simple);
    textAlign(LEFT, CENTER);
    textSize(18);
    fill(255);
    text("" + title, x + 50, y + 19/2);
    //return active;
  }
}

class Slider {
  int value;
  int max;
  int x, y;

  Slider(int X, int Y, int Max){
    value = 150;
    max = Max;
    x = X;
    y = Y;
  }

  public int round10(final int n) {
    return (n + 5) / 10 * 10;
  }

  public void draw () {

    fill(255);
    rect(x, y, max, 7, 20);
    fill(150);
    rect(value, y, max - value + 22, 7, 20);
    fill(255);
    ellipse(value, y + 7/2, 15, 15);

    int current = round10(value - 22);
    textAlign(TOP, LEFT);
    text(round(current * 0.666666667f) + "%", 178, 68);
    if (mouseX > x && mouseX < x + max) {
      if (mouseY > y - 15 && mouseY < y + 15) {
        if (mousePressed) {
          value = mouseX;
          // VLCInstance.setVolume(round(value));
        }
      }
    }
  }
}

float closeGameOpacity = 2.1f;
public void closeGame () {
  fill(0, 0, 0, closeGameOpacity);
  rect(0, 0, width, height);
  closeGameOpacity *= 1.073f;
  if (closeGameOpacity < 100) {
    closeGameOpacity += 2;
  } else if (closeGameOpacity > 355) {
    logEvent("User closed game", 'i');
    exit();
  }
}

public void closeGamePrompt () {
  fill(0, 0, 0, closeGameOpacity);
  rectMode(CENTER);
  rect(width/2, height/2, width/3 - 50, height/3 - 50, 10);
  rectMode(CORNER);
  fill(255, 255, 255, closeGameOpacity + 55);
  textAlign(CENTER, CENTER);
  textSize(width/70);
  textFont(germanica);
  text("Do you want to close the game?", width/2, height/2 - 40);

  closeGameOpacity *= 1.073f;
  if (closeGameOpacity < 100) {
    closeGameOpacity += 2;
  } else if (closeGameOpacity > 200) {
    closeGameOpacity = 200;
    exitPromptYes.draw();
    exitPromptNo.draw();

    if (exitPromptYes.pressed) {
        exit();
    } else if (exitPromptNo.pressed){
      exitPromptNo.pressed = false;
      exitGamePrompt = false;
      closeGameOpacity = 0;
    }
  }
  textFont(simple);
}

float screenOverlayOpacity = 0;
int transitionStage = 1;
float transitionSpeed = 15;
public void gotoScene (String nextScene) {
    fill(0, 0, 0, screenOverlayOpacity);
    rect(0, 0, width, height);
    switch (transitionStage) {
        case 1:
            screenOverlayOpacity += 3;
            if (screenOverlayOpacity >= 40) {
                transitionStage = 2;
            }
            break;
        case 2:
            screenOverlayOpacity += transitionSpeed;
            if (screenOverlayOpacity >= 255) {
                transitionStage = 3;
                logEvent("transitioning from: " + scene + " to: " + nextScene, 'i');
                scene = nextScene;
                screenOverlayOpacity = 255;
            }
            break;
        default:
            logEvent("Unable to transition to scene: " + nextScene + ". Defaulting to menu scene.", 'e');
            scene = "menu";
            break;
    }
} // smoothly transition from scene to scene with fade

public void finishTransition () {
  fill(0, 0, 0, screenOverlayOpacity);
  rect(0, 0, width, height);
  switch (transitionStage) {
      case 3:
          screenOverlayOpacity -= transitionSpeed - 5.2f;
          if (screenOverlayOpacity <= 7) {
              transitionStage = 4;
          }
          break;
      case 4:
          screenOverlayOpacity --;
          if (screenOverlayOpacity <= 0) {
              screenOverlayOpacity = 0;
              transitionStage = 1;
          }
          break;
  }
}
Panel economics;
Panel military;

Panel networkStats;

Button dock;
Button mill;
Button farm;

Button toggleDevMode;
Button exitGameButton;
Button menu; // in game button to return to menu
Button menuFromCredits; // button to return to menu from credits screen

boolean exitGamePrompt = false;
Button exitPromptYes;
Button exitPromptNo;

boolean GUI_OBJECTS_INITIALIZED = false;
boolean OPTIONS_GUI_OBJECTS_INITIALIZED = false;
public void guiManager () {
  if (!GUI_OBJECTS_INITIALIZED) {
    dock = new Button(270, 5, 90, 35, "Dock");
    mill = new Button(370, 5, 190, 35, "Lumber Mill");
    farm = new Button(570, 5, 90, 35, "Farm");

    exitGameButton = new Button(width - 100, 5, 90, 35, "Exit");
    toggleDevMode = new Button(width - 320, 5, 210, 35, "Developer Mode");
    menu = new Button(width - 420, 5, 90, 35, "Menu");

    networkStats = new Panel(50, width / 2 - 100, 500);

    economics = new Panel(50, width / 2 - 100, 500);
    military = new Panel(width / 2 + 50, width / 2 - 100, 500);

    menuFromCredits = new Button(width / 2 - 60, height - 100, 120, 40, "Back");

    exitPromptYes = new Button(width/2 + 10, height/2, 120, 40, "Yes");
    exitPromptNo = new Button(width/2 - 130, height/2, 120, 40, "No");

    logEvent("GUI objects initialized", 's');

    GUI_OBJECTS_INITIALIZED = true;
  }

  if (scene == "game") {
    if (exitGameButton.pressed) {
      exitGame = true;
    }
    if (toggleDevMode.pressed) {

    }
    if (menu.pressed) {
      gotoMainMenu = true;
      goneToGameOnStart = true;
    }


    economics.draw(); // Panels
    military.draw();

    fill(20); // Top bar
    rect(0, 0, width, 45);

    dock.draw(); // Buttons
    mill.draw();
    farm.draw();

    exitGameButton.draw();
    toggleDevMode.draw();
    menu.draw();

    textFont(simple);
    textSize(15);
    textAlign(CORNER);
    text("Gold: " + gold.amountCollected + " | Food: " + food.amountCollected + " | Wood: " + wood.amountCollected, 10, 30);

    // HoveredTile tooltip
    fill(20, 20, 20, 100);
    rect(mouseX + 13, mouseY - 10, 100, 30);
    fill(255);
    textAlign(LEFT, CENTER);
    String hoveredTileType = null;
    switch (hoveredTile) {
        case 't':
          hoveredTileType = "Forest";
        break;
        case 'g':
          hoveredTileType = "Grass";
        break;
        case 's':
          hoveredTileType = "Sand";
        break;
        case 'w':
          hoveredTileType = "Water";
        break;
        case 'm':
          hoveredTileType = "Mountain";
        break;
    }
    text(hoveredTileType + " tile", mouseX + 15, mouseY + 4);
  }
  if (scene == "credits") {
    menuFromCredits.draw();
    if (menuFromCredits.pressed) {
      gotoMainMenu = true;
    }
  }
  if (scene == "multiplayer") {
      networkStats.draw();
      if (networkStats.active) {
          if (localClient.available() > 0) {
              text(localClient.readString(), 100, height - 300);
          }
      }
  }

  sceneTransitions();
  if (exitGamePrompt) {
    closeGamePrompt();
  }
  if (exitGame) {
    closeGame();
  }

}

public void sceneTransitions () {
  if (gotoGame) {
      gotoScene("game");
      if (scene == "game") {
          gotoGame = false;
      }
  } if (gotoMultiplayerScene) {
      gotoScene("multiplayer");
      if (scene == "multiplayer") {
          gotoMultiplayerScene = false;
      }
  } if (gotoCreditsScene) {
      gotoScene("credits");
      if (scene == "credits") {
          gotoCreditsScene = false;
      }
  } if (gotoOptionsScene) {
      gotoScene("options");
      if (scene == "options") {
          gotoOptionsScene = false;
      }
  } if (gotoMainMenu) {
      gotoScene("menu");
      if (scene == "menu") {
          gotoMainMenu = false;
      }
  }
  finishTransition();
}

SwitchBtn soundEffects;
Button menuFromOptions; // button to return to menu from credits screen

public void optionsScreenGuiManager () {
    if (!OPTIONS_GUI_OBJECTS_INITIALIZED) {
        soundEffects = new SwitchBtn(130, 130, "Sound effects");
        menuFromOptions = new Button(width - 200, height - 150, 90, 40, "Back");
        OPTIONS_GUI_OBJECTS_INITIALIZED = true;
    }
    soundEffects.draw();
    menuFromOptions.draw();

    if (menuFromOptions.pressed) {
        gotoMainMenu = true;
    }
}
int startingResources = 200;
boolean givenStartingResources = false;

public void game () {

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
float mouseScroll = 0;
public void mouseWheel(MouseEvent event) {
  mouseScroll = event.getCount();
  if (scene == "game") {
      if (mouseScroll >= 1) {
        gameZoom -= 0.1f;
      }
      if (mouseScroll <= -1) {
        gameZoom += 0.1f;
      }
  }
}

public void mousePressed () {
  mousePressed = true;
}

public void resetInputVariables () {
  /**
    called once at the end of the draw.
    use to reset input variables only
  */
  mouseScroll = 0;
  mousePressed = false;
}

public void keyPressed() {

    if (scene == "game") {
        if (keyCode == '1') {
            if (economics.active) {
                economics.goDown = true;
            } else {
                economics.goUp = true;
            }
        }
        if (keyCode == '2') {
            if (military.active) {
                military.goDown = true;
            } else {
                military.goUp = true;
            }
        }
    }
    if (key == ESC) {
      key = 0;
      exitGamePrompt = true;
    }

}



String backgroundMusicPath = "backgroundMusic.mp3";

SoundFile backgroundMusic;
SoundFile buttonClickSound;

boolean initialized = false;
float splashScreenAlpha = 255;

PImage mountainSprite;
PImage tree1Sprite;
PImage tree2Sprite;
PImage houseSprite;

boolean heightmapCreated = false;
PImage terrainImg;

public void splashScreen () {
  if (!initialized) {
    background(0);
    fill(255);
    text("Game Studio", width/2, height/2);
  } else {
    image(terrainImg, 0, 0, width, height); // change to the menu background later
    fill(0, 0, 0, splashScreenAlpha);
    rect(0, 0, width, height);
    fill(255, 255, 255, splashScreenAlpha);
    text("Game Studio", width/2, height/2);
    splashScreenAlpha /= 1.02f;
    if (splashScreenAlpha < 160) {
      splashScreenAlpha -= 2;
    }
    if (splashScreenAlpha <= 3 || developerMode) {
      scene = "menu";
    }
  }
}

public void loadAssets () {
  if (!initialized) {
    // load music
    // backgroundMusic = new SoundFile(this, "sounds/music/backgroundMusic.mp3");
    // backgroundMusic.play();
    // backgroundMusic.loop();

    buttonClickSound = new SoundFile(this, "sounds/effects/ButtonClick.mp3");

    mountainSprite = loadImage("images/sprites/world/mtn.png");
    tree1Sprite = loadImage("images/sprites/world/tree.png");
    tree2Sprite = loadImage("images/sprites/world/twoTrees.png");
    houseSprite = loadImage("images/sprites/buildings/house.png");

    // create heightmap
    if (!heightmapCreated) {
      createHeightMapValues(); // Generate noise values for heightmap
      drawHeightMap(); // Draw using for loops once
      terrainImg = get(0, 0, width, height); // Create an image of the terrain
      heightmapCreated = true; // Never call this again
      logEvent("Heightmap created", 's');
    }
    logEvent("Finished loading assets", 's');
    initialized = true;
  }
}
float menuButtonBackgroundOpacity = 1.1f;
String menuButtonTitles[] = {"Campaign", "Multiplayer", "options", "credits", "Exit to Desktop"};

Button menuButtons[] = new Button[7];
int buttonCount = 0;

boolean gotoCreditsScene = false;
boolean gotoGame = false;
boolean gotoMainMenu = false;
boolean gotoOptionsScene = false;
boolean gotoMultiplayerScene = false;

boolean buttonObjectsInitialized = false;

public void createMenuButton (int x, int y, int btnWidth, int btnHeight, String title) {
  menuButtons[buttonCount] = new Button(x, y, btnWidth, btnHeight, title);
  if (buttonCount < menuButtons.length - 1) {
    buttonCount += 1;
  }
}

public void menu () {

  // create the button objects
  if (!buttonObjectsInitialized) {
    for (int i = 0; i < menuButtonTitles.length; i ++) {
      createMenuButton(200, i * 100 - 600, 230, 60, menuButtonTitles[i]);
    }
    if (buttonCount >= 6) {
      buttonObjectsInitialized = true;
    }
  }

  // Animate the elements
  menuButtonBackgroundOpacity *= 1.08f;
  menuButtonBackgroundOpacity ++;
  if (menuButtonBackgroundOpacity > 100) {
    menuButtonBackgroundOpacity = 100;
  }
  if (menuButtons[0].yPosition <= 200) {
    for (int i = 0; i < buttonCount - 1; i ++) {
      menuButtons[i].yPosition += 15;
    }
  }

  // Draw the stuff
  image(terrainImg, 0, 0, width, height);
  fill(0, 0, 0, menuButtonBackgroundOpacity);
  rect(170, 0, 290, height);
  textFont(germanica);
  fill(255);
  text("GameThing", 315, menuButtons[0].yPosition - 50);
  for (int i = 0; i < buttonCount - 1; i ++) {
    menuButtons[i].draw();
  }

  // register clicks
  if (menuButtons[0].pressed) {
    gotoGame = true;
  } if (menuButtons[1].pressed) {
    gotoMultiplayerScene = true;
  } if (menuButtons[2].pressed) {
    gotoOptionsScene = true;
  } if (menuButtons[3].pressed) {
    gotoCreditsScene = true;
  } if (menuButtons[4].pressed) {
    exitGame = true;
  }
}
String ANSI_RESET = "\u001B[0m";
String ANSI_RED = "\u001B[31m";
String ANSI_GREEN = "\u001B[32m";
String ANSI_YELLOW = "\u001B[33m";
String ANSI_BLUE = "\u001B[34m";
String ANSI_WHITE = "\u001B[37m";
public void logEvent (String log, char type) {
    String ANSI_COLOR = ANSI_WHITE;
    String logType = "[INFO]";
    switch (type) {
        case 's':
            ANSI_COLOR = ANSI_GREEN;
            logType = "[SUCCESS]";
        break;
        case 'i':
            ANSI_COLOR = ANSI_BLUE;
            logType = "[INFO]";
        break;
        case 'w':
            ANSI_COLOR = ANSI_YELLOW;
            logType = "[WARNING]";
        break;
        case 'e':
            ANSI_COLOR = ANSI_RED;
            logType = "[ERROR]";
        break;
        case 'f':
            ANSI_COLOR = ANSI_RED;
            logType = "[FATAL]";
        break;
    }
    println(ANSI_COLOR + logType + " " + log + ANSI_RESET);
}
/**

This code can sucessfully receive messages from chatApp
requires port 8080 to be open so that you can connect over the WWW.
figure out if LAN reuires a port.

*/



Client localClient;
String serverAddress = "68.185.198.252";
int defaultPort = 8080;
boolean connectedToServer = false;

public void connectToServer () {
    if (!connectedToServer) {
        try {
            logEvent("Attempting to connet to server " + serverAddress + " on port " + defaultPort, 'i');
            localClient = new Client(this, serverAddress, defaultPort); // EDIT - SEE TODO
            connectedToServer = true;
        } catch (Exception e) {
            logEvent("Couldn't connect to server " + serverAddress + " on port " + defaultPort + "\n" + e, 'w'); // EDIT THIS PLEASE!!!!!
        }
    }
    if (localClient.available() > 0) {
        println(localClient.readString());
    }

}
Gold gold = new Gold();
Wood wood = new Wood();
Food food = new Food();
class Resource {

  int amountCollected;
  int increase; // Per second

  Resource () {

  }

  public void computeAmounts () {
    amountCollected += increase;
  }

  public void addResource (int amount) {
    amountCollected += amount;
  }

  public void removeResource (int amount) {
    amountCollected -= amount;
  }

}

class Gold extends Resource {

}

class Wood extends Resource {

}

class Food extends Resource {

}
float creditTextOpacity = 0;
public void creditsScreen () {
    textFont(simple);
    background(0);
    textSize(width/70);
    fill(255, 255, 255, creditTextOpacity);
    text("Programming:\nEthan Grandin \nAsher Haun\n\nMusic:\nNightrain - Airtone\n\nLibraries:\nOpen Simplex Noise\nProcessing 3", width / 2, height / 2);
    creditTextOpacity += 3;
}

public void optionsScreen () {
    image(terrainImg, 0, 0, width, height);
    fill(0, 0, 0, 100);
    rect(100, 100, width - 200, height - 200);
    optionsScreenGuiManager();
}
/** Create Heightmap and save to a PImage */
int chunkWidth = 900; // chunkSize * blockSize should fill the entire screen
int chunkHeight = 600;
int blockSize = width/27;
// int blockSize = 10;
float increment = 0.013f; // the fineness of the noise map

float[][] terrain = new float[chunkWidth][chunkHeight]; // create an empty 2D array with the dimensions of chunkSize

public void createHeightMapValues () {
  float yoff = 0;
  // these loops fill the terrain array with a perlin noise map, that creates integer height values between 0 and 100
  for (int x = 0; x < chunkWidth; x ++) {
    float xoff = 0;
    for (int y = 0; y < chunkHeight; y ++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, 0, 50);
      terrain[x][y] += map((float) noise.eval(xoff, yoff), -1, 1, 0, 50);
      xoff += increment;
    }
    yoff += increment;
  }
};

// these are the height levels that change the color of individual tiles according to the terrain array
float deepWater = 67;
float shallowWater = 60;
float sand = 57;
float grass = 40;
float treeline = 0;

public void drawHeightMap () {
  for (int x = 0; x < chunkWidth; x ++) {
    for (int y = 0; y < chunkHeight; y ++) {
      // changes the rect fill based on the height given by each index in terrain at x, y
      if (terrain[x][y] >= deepWater) {
        fill(35, 81, 128); // deep water
      } else if (terrain[x][y] >= shallowWater) {
        fill(37, 91, 148); // shallow water
      } else if (terrain[x][y] >= sand) {
        fill(199, 174, 46); // sand
      } else if (terrain[x][y] >= grass) {
        fill(31, 97, 9); // light green grass
      } else if (terrain[x][y] >= treeline) {
        fill(34, 77, 19); // dark green grass
      }
      noStroke();
      rect(x * blockSize, y * blockSize, 40, 40);
      // fill(0, 0, 0, random(0, 30));
      // rect(x * blockSize, y * blockSize, 40, 40);
    }
  }
};

/** Draw the grid the player interacts with and draw sprites */

String currentMouseTile;
//char[][] tileMap = new char[chunkWidth][chunkHeight];

int tileSize = 10;
char[][] tileMap = new char[chunkWidth][chunkHeight]; // create an empty 2D array with the dimensions of chunkSize

char hoveredTile = 'x';

boolean createdSpriteLocations = false;

int[] displayMountainSprite = {30};
int[][] treeType = new int[chunkWidth][chunkHeight]; // create an empty 2D array with the dimensions of chunkSize

public void tileGrid () {

  int increment = tileSize;
  for (int x = 0; x < chunkWidth; x += increment) {
    for (int y = 0; y < chunkHeight; y += increment) {

      // Check the index in terrain every ten (or whatever value is within increment)
      noFill();
      if (tileMap[x][y] != 'm') {
        if (terrain[x][y] >= treeline) {
          tileMap[x][y] = 't';
        } if (terrain[x][y] >= grass - 1) {
          tileMap[x][y] = 'g';
        } if (terrain[x][y] >= sand - 3) {
          tileMap[x][y] = 's';
        } if (terrain[x][y] >= deepWater - 2) {
          tileMap[x][y] = 'w';
        }
      }

      if (!createdSpriteLocations) {
        if (random(0, 10) < 0.3f && terrain[x][y] < deepWater - 10) {
          tileMap[x][y] = 'm';
        }
        if (terrain[x][y] >= treeline) {
          if (random(0, 10) < 5) {
            treeType[x][y] = 1;
          } else {
            treeType[x][y] = 2;
          }
        }
        if (x > chunkWidth - increment*3 && y > chunkHeight/2) {
          createdSpriteLocations = true;
        }
      }

      strokeWeight(1);
      noStroke();

      int tileX = x * tileSize / increment * blockSize - tileSize;
      int tileY = y * tileSize / increment * blockSize - tileSize;
      int ts = tileSize * blockSize;

      if (mouseX > tileX && mouseY > tileY && mouseX < tileX + ts && mouseY < tileY + ts) {
        fill(0, 0, 0, 100);
        hoveredTile = tileMap[x][y];
      } else {
        noFill();
      }

      rect(tileX, tileY, ts, ts);
      fill(20, 20, 20, 200);
      textAlign(CENTER, CENTER);
      // text(tileMap[x][y], tileX + ts / 2, tileY + ts / 2);
      if (tileMap[x][y] == 'm') {
        // println("called: X: " + x + ", Y: " + y);
        image(mountainSprite, tileX, tileY);
      }
      if (tileMap[x][y] == 't') {
        if (treeType[x][y] == 1) {
          image(tree1Sprite, tileX, tileY);
        } else {
          image(tree2Sprite, tileX, tileY);
        }
      }
    }
  }
}
  public void settings() {  size(1600, 900, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GameThing" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
