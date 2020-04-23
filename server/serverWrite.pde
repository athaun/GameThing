String lastUserInput = "";
String myName = "Asher";
void serverWrite() {
  if (sendMessage == true && keyCode != 0 && userInput != "") {
    if (userInput != lastUserInput) {
      gameServer.write(myName + "/divider " + userInput + "/end");// sends message to client (s)
      lastUserInput = userInput;
      userInput = ""; // Clears the input text box
      typing = "";
    } else {
      // if (keyCode != 0 && userInput != "") {
        // just spams the client with nothing if no messages have been sent yet (dirty fix for a null check on the client side)
        // myServer.write(myName + "/divider nothing/end");
      // }
    }
    sendMessage  = false;
  }
}
