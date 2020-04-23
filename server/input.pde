import java.util.regex.Pattern;
import java.util.regex.Matcher;

String userInput = "";
boolean sendMessage = false;

String whiteSpacePattern = "^\\s+$"; // If the whole message is whitespace (LEGEND: ^ = beginning; \\s = whitspace; $ = end)
Pattern pattern = Pattern.compile(whiteSpacePattern);


// Example 18-1: User input

PFont f;

// Variable to store text currently being typed
String typing = "";

void keyboardInput() {

  //println(keyCode);
  int[] forbiddenKeys = {37, 38, 40, 39, 18, 17, 34, 33, 36, 35, 0, 0, 61440, 61441, 61442, 61443, 12, 9, 127}; // (127) Needs arrows keys or mouse cursor

  for (int i = 0; i < forbiddenKeys.length; i ++) {
    if (keyCode == forbiddenKeys[i]) {
      if (typing.length() != 0) { // Null check
        typing = typing.substring(0, typing.length()-1); // Deletes character typed by user that are forbidden
      }
    }
  }

  boolean displayText = false;

  switch (keyCode) {
  case 10: // Return key
      Matcher matcher = pattern.matcher(typing);
      if (matcher.find()) {
          logEvent("User tried to send an empty string (<Enter> pressed) " + typing, 'i');
      } else {
          displayText = false;
          sendMessage = true; // Sending the message to the receiver
      }

      // typing = typing.replaceAll(":[Ss]mile:", "SMILEY");

    break;
  case 16: // Shift key
    displayText = false;
    break;
  case 8: // Delete key
    if (typing.length() != 0) // Null check
    {
      typing = typing.substring(0, typing.length()-1);
    }
    displayText = false;
    break;
  case 127: // Forward delete key
    // Needs arrow keys or mouse to work
    break;
  case 27: // Escape key
    // Close program or some sub area of program
    break;
  default:
    displayText = true;
    break;
  }

  if (displayText == true) {
    typing += key;
  }

  userInput = typing;
}
