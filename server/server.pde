import processing.net.*;
Server gameServer;
int port = 8080;
String latestMessage;

void setup () {
    size(500, 700);
    gameServer = new Server(this, port);
}

void draw () {
    background(30);
    Client clients[] = gameServer.clients;
    for (int i = 0; i < gameServer.clientCount; i++) {
        if (clients[i].active()) {
            while (clients[i].available() > 0) {
                // checks each client for available bits, if so it reads them
                latestMessage = clients[i].readString();
            }
        }
    }
    serverWrite();

    text(userInput, 10, 10);
}

void keyPressed () {
    keyboardInput();
}
