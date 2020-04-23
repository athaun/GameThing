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
void guiManager () {
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

void sceneTransitions () {
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

void optionsScreenGuiManager () {
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
