import processing.net.*;
import processing.sound.*;

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

void splashScreen () {
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
    splashScreenAlpha /= 1.02;
    if (splashScreenAlpha < 160) {
      splashScreenAlpha -= 2;
    }
    if (splashScreenAlpha <= 3 || developerMode) {
      scene = "menu";
    }
  }
}

void loadAssets () {
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
