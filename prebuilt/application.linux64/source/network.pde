/**

This code can sucessfully receive messages from chatApp
requires port 8080 to be open so that you can connect over the WWW.
figure out if LAN reuires a port.

*/

import processing.net.*;

Client localClient;
String serverAddress = "68.185.198.252";
int defaultPort = 8080;
boolean connectedToServer = false;

void connectToServer () {
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
