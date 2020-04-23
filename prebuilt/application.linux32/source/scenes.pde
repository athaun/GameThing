float creditTextOpacity = 0;
void creditsScreen () {
    textFont(simple);
    background(0);
    textSize(width/70);
    fill(255, 255, 255, creditTextOpacity);
    text("Programming:\nEthan Grandin \nAsher Haun\n\nMusic:\nNightrain - Airtone\n\nLibraries:\nOpen Simplex Noise\nProcessing 3", width / 2, height / 2);
    creditTextOpacity += 3;
}

void optionsScreen () {
    image(terrainImg, 0, 0, width, height);
    fill(0, 0, 0, 100);
    rect(100, 100, width - 200, height - 200);
    optionsScreenGuiManager();
}
