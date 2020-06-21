int [][] gameboard;
int playerX, playerY;
int hoverX, hoverY;
Stack<Cell> path;
Stack<Cell> clearPath;

void setup() {
  size(500, 500);
  background(255);
  gameboard  = new int[50][50];
  
  // Create the 'player' and spawn them in a random location.
  playerX = (int)random(0, 50);
  playerY = (int)random(0, 50);
 
  gameboard[playerX][playerY] = 1;
  
  // Create  10 'enemies' in random locations.
  for (int i = 0; i < 10; i++) {
   int x = 0;
   int y = 0;
   
   do {
     x = (int)random(0, 50);
     y = (int)random(0, 50);
   }
   while (gameboard[x][y] == 1 || gameboard[x][y] == 2);

   gameboard[x][y] = 2;
  }
  
  // Create 10 'walls' in random locations
  for (int i = 0; i < 10; i++) {
    int x = 0;
    int y = 0;
    
    do {
      x = (int)random(0, 50);
      y = (int) random(0, 50);
    }
    while (gameboard[x][y] == 1 || gameboard[x][y] == 2 || gameboard[x][y] == 999);
    
    setWall(x, y);
    drawGrid();
  }
  
  path = new Stack<Cell>();
  clearPath = new Stack<Cell>();
}

void draw() {
  // Iterates over gameboard and colors the cells
  // based on their values:
  // 1 - Player (Green)
  // 2 - Enemy (Red)
  // 999 - Wall (Black)
  for (int i = 0; i < 50; i++) {
    for (int j = 0; j < 50; j++) {
      if (gameboard[i][j] == 1) {
        drawPlayer(i, j);
      }
      
      if (gameboard[i][j] == 2) {
        drawEnemy(i, j); 
      }
      
      if (gameboard[i][j] == 999) {
        drawWall(i, j);
      }
    }
  }
  
  // Colors the cell yellow when the user hovers the cursor over it.
  clearHover(hoverX, hoverY);
  hoverX = ((int)mouseX / 10) * 10;
  hoverY = ((int)mouseY / 10) * 10;
  hover(hoverX, hoverY);
  
  // Generate new path (every 5 ms to ease computational load).
  if (millis() % 5 == 0) {
    // Clear the previous path from the board
    while (clearPath != null && !clearPath.empty()) {
      Cell cell = clearPath.pop();
      clearPath(cell);
    }
    
    // Perform A* search for path from player to cursor.
    Cell source = new Cell(playerX, playerY);
    Cell dest = new Cell(hoverX / 10, hoverY / 10);
    path = astar(source, dest, gameboard);
    
    while (path != null && !path.empty()) {
      Cell cell = path.pop();
      clearPath.push(cell);
      drawPath(cell);
    }
  }
}

void keyPressed() {
  // Simple key-based movement. Not sure how necessary this is but I figured
  // it might be useful.
  if (key == CODED) {
    if (keyCode == UP) {
      if (playerY > 0 && gameboard[playerX][playerY - 1] != 2 && gameboard[playerX][playerY - 1] != 999) {
        clearCell(playerX, playerY);
        
        playerY--;
        drawPlayer(playerX, playerY);
      }
    }
    
    if (keyCode == DOWN) {
      if (playerY < 49 && gameboard[playerX][playerY + 1] != 2 && gameboard[playerX][playerY + 1] != 999) {
        clearCell(playerX, playerY);
        
        playerY++;
        drawPlayer(playerX, playerY);
      }
    }
      
    if (keyCode == LEFT) {
      if (playerX > 0 && gameboard[playerX - 1][playerY] != 2 && gameboard[playerX - 1][playerY] != 999) {
        clearCell(playerX, playerY);
        
        playerX--;
        drawPlayer(playerX, playerY);
      }
    }
      
    if (keyCode == RIGHT) {
      if (playerX < 49 && gameboard[playerX + 1][playerY] != 2 && gameboard[playerX + 1][playerY] != 999) {
        clearCell(playerX, playerY);
        
        playerX++;
        drawPlayer(playerX, playerY);
      }
    }
  }
  println("Player X coord: " + playerX + "\nPlayer Y coord: " + playerY);
}

void mousePressed() {
  // Updates location of player based on user's click.
  if (gameboard[(int)mouseX / 10][(int)mouseY / 10] != 999) {
    updatePlayerPos((int)mouseX / 10, (int)mouseY / 10);
  }
  
  while (clearPath != null && !clearPath.empty()) {
    Cell cell = clearPath.pop();
    clearPath(cell);
  }
}

/*
 * Draws player (green square) at x/y location.
 */
void drawPlayer(int x, int y) {
  fill(0, 255, 0);
  stroke(0);
  square((x * 10), (y * 10), 10);
  gameboard[x][y] = 1;
}

/*
 * Draws enemy (red square) at x/y location.
 */
void drawEnemy(int x, int y) {
  fill(255, 0, 0);
  stroke(0);
  square((x * 10), (y * 10), 10);
}

/*
 * Draws wall (black square) at x/y location.
 */
void drawWall(int x, int y) {
  fill(0);
  square(x * 10, y * 10, 10);
}

/*
 * Draws one cell of the path from player to the location
 * of their hovering cursor.
 */
void drawPath(Cell cell) {
  // Do not draw if the cell is the player cell or the destination cell
  if ((cell.x == playerX && cell.y == playerY) || (cell.x == hoverX / 10 && cell.y == hoverY / 10)) {
    return;
  }
  
  fill(0, 0, 255);
  stroke(0);
  square((cell.x * 10), (cell.y * 10), 10);
}

/*
 * Sets the gameboard locations of the randomly generated walls
 */
void setWall(int x, int y) {
  // There's probably a better way to do this, but I wanted a random
  // variable to control whether the generated wall was horizontal 
  // or vertical. 
  int orientation = (int)random(0, 2);
  
  // Makes a horizontal wall that is five cells long
  // (unless it runs into the edge of the map/player/enemy/another wall).
  if (orientation == 0) {
    for (int i = 0; i < 5; i++) {
      if ((x + i) > 49 ||
          gameboard[x + i][y] == 1 || 
          gameboard[x + i][y] == 2 || 
          gameboard[x + i][y] == 999) {
        break;
      }
      
      gameboard[x + i][y] = 999;
    }
  }
  // Makes a vertical wall that is five cells long
  // (unless it runs into the edge of the map/player/enemy/another wall).
  else {
    for (int i = 0; i < 5; i++) {
      if ((y + i) > 49 ||
          gameboard[x][y + i] == 1 ||
          gameboard[x][y + i] == 2 ||
          gameboard[x][y + i] == 999) {
           break; 
          }
          
       gameboard[x][y + i] = 999;
    }
  }
}

/*
 * Fills cell with yellow square at x/y location
 * (unless a wall is present in the cell).
 */
void hover(int x, int y) {
  if (gameboard[x / 10][y / 10] != 999) {  
    if (gameboard[x / 10][y / 10] == 1) {
      fill(0, 255, 0);
      stroke(255,255, 0);
    }
    else if (gameboard[x / 10][y / 10] == 2) {
      fill(255, 0, 0);
      stroke(255, 255, 0);
    }
    else {
      fill(255, 255, 0);
      stroke(0);
    }
    square(x, y, 10);
  }
}

/*
 * Resets the gameboard value and 
 * fills the cell with a white square.
 */
void clearCell(int x, int y) {
  gameboard[x][y] = 0;
  fill(255);
  stroke(0);
  square(x * 10, y * 10, 10);
  
}

/*
 * Resets the cell back to its appearance before a 
 * path was drawn on it.
 */
void clearPath(Cell cell) {
  if (!(cell.x == playerX && cell.y == playerY) && !(cell.x == hoverX / 10 && cell.y == hoverY / 10)) {
    fill(255);
    stroke(0);
    square(cell.x * 10, cell.y * 10, 10);
  }
}

/* 
 * Visually resets the cell back to its white background
 */
void clearHover(int x, int y) {
  if (gameboard[x / 10][y / 10] != 999) {
    fill(255);
    stroke(0);
    square(x, y, 10);
  }
}

/*
 * Draws the 50x50 grid
 */
void drawGrid() {
  stroke(2);
  for (int i = 0; i < 501; i++) {
    if (i % 10 == 0) {
      line(i, 0, i, 500);
      line(0, i, 500, i);
    }
  }
}

/*
 * Changes the cell of the player (green square) when 
 * the user clicks on a grid cell
 */
void updatePlayerPos(int x, int y) {
  // Clear the old location of the player
  clearCell(playerX, playerY);
  
  // Update player location and draw
  playerX = x;
  playerY = y;
  gameboard[playerX][playerY] = 1;
  drawPlayer(playerX, playerY);
}
