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

  void draw () {

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

  void draw (){
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

color switchBtnColor = color(255);
class SwitchBtn {

  int x, y;
  // int bx, by;
  Boolean active;
  int slider;
  color sliderColor;
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

  void draw () {
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

  int round10(final int n) {
    return (n + 5) / 10 * 10;
  }

  void draw () {

    fill(255);
    rect(x, y, max, 7, 20);
    fill(150);
    rect(value, y, max - value + 22, 7, 20);
    fill(255);
    ellipse(value, y + 7/2, 15, 15);

    int current = round10(value - 22);
    textAlign(TOP, LEFT);
    text(round(current * 0.666666667) + "%", 178, 68);
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

float closeGameOpacity = 2.1;
void closeGame () {
  fill(0, 0, 0, closeGameOpacity);
  rect(0, 0, width, height);
  closeGameOpacity *= 1.073;
  if (closeGameOpacity < 100) {
    closeGameOpacity += 2;
  } else if (closeGameOpacity > 355) {
    logEvent("User closed game", 'i');
    exit();
  }
}

void closeGamePrompt () {
  fill(0, 0, 0, closeGameOpacity);
  rectMode(CENTER);
  rect(width/2, height/2, width/3 - 50, height/3 - 50, 10);
  rectMode(CORNER);
  fill(255, 255, 255, closeGameOpacity + 55);
  textAlign(CENTER, CENTER);
  textSize(width/70);
  textFont(germanica);
  text("Do you want to close the game?", width/2, height/2 - 40);

  closeGameOpacity *= 1.073;
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
void gotoScene (String nextScene) {
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

void finishTransition () {
  fill(0, 0, 0, screenOverlayOpacity);
  rect(0, 0, width, height);
  switch (transitionStage) {
      case 3:
          screenOverlayOpacity -= transitionSpeed - 5.2;
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
