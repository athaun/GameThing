float menuButtonBackgroundOpacity = 1.1;
String menuButtonTitles[] = {"Campaign", "Multiplayer", "options", "credits", "Exit to Desktop"};

Button menuButtons[] = new Button[7];
int buttonCount = 0;

boolean gotoCreditsScene = false;
boolean gotoGame = false;
boolean gotoMainMenu = false;
boolean gotoOptionsScene = false;
boolean gotoMultiplayerScene = false;

boolean buttonObjectsInitialized = false;

void createMenuButton (int x, int y, int btnWidth, int btnHeight, String title) {
  menuButtons[buttonCount] = new Button(x, y, btnWidth, btnHeight, title);
  if (buttonCount < menuButtons.length - 1) {
    buttonCount += 1;
  }
}

void menu () {

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
  menuButtonBackgroundOpacity *= 1.08;
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
