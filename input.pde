float mouseScroll = 0;
void mouseWheel(MouseEvent event) {
  mouseScroll = event.getCount();
  if (scene == "game") {
      if (mouseScroll >= 1) {
        gameZoom -= 0.1;
      }
      if (mouseScroll <= -1) {
        gameZoom += 0.1;
      }
  }
}

void mousePressed () {
  mousePressed = true;
}

void resetInputVariables () {
  /**
    called once at the end of the draw.
    use to reset input variables only
  */
  mouseScroll = 0;
  mousePressed = false;
}

void keyPressed() {

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
