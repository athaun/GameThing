/** Create Heightmap and save to a PImage */
int chunkWidth = 900; // chunkSize * blockSize should fill the entire screen
int chunkHeight = 600;
int blockSize = width/27;
// int blockSize = 10;
float increment = 0.013; // the fineness of the noise map

float[][] terrain = new float[chunkWidth][chunkHeight]; // create an empty 2D array with the dimensions of chunkSize

void createHeightMapValues () {
  float yoff = 0;
  // these loops fill the terrain array with a perlin noise map, that creates integer height values between 0 and 100
  for (int x = 0; x < chunkWidth; x ++) {
    float xoff = 0;
    for (int y = 0; y < chunkHeight; y ++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, 0, 50);
      terrain[x][y] += map((float) noise.eval(xoff, yoff), -1, 1, 0, 50);
      xoff += increment;
    }
    yoff += increment;
  }
};

// these are the height levels that change the color of individual tiles according to the terrain array
float deepWater = 67;
float shallowWater = 60;
float sand = 57;
float grass = 40;
float treeline = 0;

void drawHeightMap () {
  for (int x = 0; x < chunkWidth; x ++) {
    for (int y = 0; y < chunkHeight; y ++) {
      // changes the rect fill based on the height given by each index in terrain at x, y
      if (terrain[x][y] >= deepWater) {
        fill(35, 81, 128); // deep water
      } else if (terrain[x][y] >= shallowWater) {
        fill(37, 91, 148); // shallow water
      } else if (terrain[x][y] >= sand) {
        fill(199, 174, 46); // sand
      } else if (terrain[x][y] >= grass) {
        fill(31, 97, 9); // light green grass
      } else if (terrain[x][y] >= treeline) {
        fill(34, 77, 19); // dark green grass
      }
      noStroke();
      rect(x * blockSize, y * blockSize, 40, 40);
      // fill(0, 0, 0, random(0, 30));
      // rect(x * blockSize, y * blockSize, 40, 40);
    }
  }
};

/** Draw the grid the player interacts with and draw sprites */

String currentMouseTile;
//char[][] tileMap = new char[chunkWidth][chunkHeight];

int tileSize = 10;
char[][] tileMap = new char[chunkWidth][chunkHeight]; // create an empty 2D array with the dimensions of chunkSize

char hoveredTile = 'x';

boolean createdSpriteLocations = false;

int[] displayMountainSprite = {30};
int[][] treeType = new int[chunkWidth][chunkHeight]; // create an empty 2D array with the dimensions of chunkSize

void tileGrid () {

  int increment = tileSize;
  for (int x = 0; x < chunkWidth; x += increment) {
    for (int y = 0; y < chunkHeight; y += increment) {

      // Check the index in terrain every ten (or whatever value is within increment)
      noFill();
      if (tileMap[x][y] != 'm') {
        if (terrain[x][y] >= treeline) {
          tileMap[x][y] = 't';
        } if (terrain[x][y] >= grass - 1) {
          tileMap[x][y] = 'g';
        } if (terrain[x][y] >= sand - 3) {
          tileMap[x][y] = 's';
        } if (terrain[x][y] >= deepWater - 2) {
          tileMap[x][y] = 'w';
        }
      }

      if (!createdSpriteLocations) {
        if (random(0, 10) < 0.3 && terrain[x][y] < deepWater - 10) {
          tileMap[x][y] = 'm';
        }
        if (terrain[x][y] >= treeline) {
          if (random(0, 10) < 5) {
            treeType[x][y] = 1;
          } else {
            treeType[x][y] = 2;
          }
        }
        if (x > chunkWidth - increment*3 && y > chunkHeight/2) {
          createdSpriteLocations = true;
        }
      }

      strokeWeight(1);
      noStroke();

      int tileX = x * tileSize / increment * blockSize - tileSize;
      int tileY = y * tileSize / increment * blockSize - tileSize;
      int ts = tileSize * blockSize;

      if (mouseX > tileX && mouseY > tileY && mouseX < tileX + ts && mouseY < tileY + ts) {
        fill(0, 0, 0, 100);
        hoveredTile = tileMap[x][y];
      } else {
        noFill();
      }

      rect(tileX, tileY, ts, ts);
      fill(20, 20, 20, 200);
      textAlign(CENTER, CENTER);
      // text(tileMap[x][y], tileX + ts / 2, tileY + ts / 2);
      if (tileMap[x][y] == 'm') {
        // println("called: X: " + x + ", Y: " + y);
        image(mountainSprite, tileX, tileY);
      }
      if (tileMap[x][y] == 't') {
        if (treeType[x][y] == 1) {
          image(tree1Sprite, tileX, tileY);
        } else {
          image(tree2Sprite, tileX, tileY);
        }
      }
    }
  }
}
