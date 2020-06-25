private int [][] gameboard;
private int playerX, playerY;
private int updatedX, updatedY;
private int hoverX, hoverY;
private final int board_size = 75;
private Stack<Cell> path;
private int playerMovementCap = 7;
private boolean castingSpell = false;

void setup() {
  // Size can't be set using variale so if 
  // board_size is changed, the size must be manually
  // changed (value is board_size * 10).
  size(750, 850);
  background(255);
  
  gameboard  = new int[board_size][board_size];
  generateMap();
  
  path = new Stack<Cell>();
}

void generateMap() {
  // Create the 'player' and spawn them in a random location.
  playerX = (int)random(0, board_size);
  playerY = (int)random(0, board_size);
 
  gameboard[playerX][playerY] = 1;
  
  // Create  n 'enemies' in random locations.
  for (int i = 0; i < board_size; i++) {
   int x = 0;
   int y = 0;
   
   do {
     x = (int)random(0, board_size);
     y = (int)random(0, board_size);
   }
   while (gameboard[x][y] == 1 || gameboard[x][y] == 2);

   gameboard[x][y] = 2;
  }
  
  // Create n 'walls' in random locations
  for (int i = 0; i < board_size; i++) {
    int x = 0;
    int y = 0;
    
    do {
      x = (int)random(0, board_size);
      y = (int) random(0, board_size);
    }
    while (gameboard[x][y] == 1 || gameboard[x][y] == 2 || gameboard[x][y] == 999);
    
    setWall(x, y);
  }
}

void draw() {
  drawGrid();
  // Iterates over gameboard and colors the cells
  // based on their values:
  // 1 - Player (Green)
  // 2 - Enemy (Red)
  // 999 - Wall (Black)
  for (int i = 0; i < board_size; i++) {
    for (int j = 0; j < board_size; j++) {
      if (gameboard[i][j] == 1 && !castingSpell) {
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
  hoverX = ((int)mouseX / 10) * 10;
  hoverY = ((int)mouseY / 10) * 10;
  hover(hoverX, hoverY);
  
  if (!castingSpell) {
    // Perform A* search for path from player to cursor.
    Cell source = new Cell(playerX, playerY);
    Cell dest = new Cell(hoverX / 10, hoverY / 10);
    path = astar(source, dest, gameboard, true);
    
    int i = 0;
    
    while (path != null && !path.empty() && i < playerMovementCap) {
      Cell cell = path.pop();
      drawPath(cell);
      if (path.size() != 1) {
        updatedX = cell.x;
        updatedY = cell.y;
      }
      
      i++;
    }
  }
  else {
    coneOfFire();
  }
  textAlign(CENTER);
  text("Press Q to toggle spell cast", ((board_size * 10) / 2), (board_size * 10) + 50);
}

void keyPressed() {
  // Simple key-based movement. Not sure how necessary this is but I figured
  // it might be useful.
  if (key == CODED) {
    if (keyCode == UP) {
      if (playerY > 0 && gameboard[playerX][playerY - 1] != 2 && gameboard[playerX][playerY - 1] != 999) {
        updatePlayerPos(playerX, playerY, playerX, playerY - 1);
      }
    }
    
    if (keyCode == DOWN) {
      if (playerY < board_size - 1 && gameboard[playerX][playerY + 1] != 2 && gameboard[playerX][playerY + 1] != 999) {
        updatePlayerPos(playerX, playerY, playerX, playerY + 1);
      }
    }
      
    if (keyCode == LEFT) {
      if (playerX > 0 && gameboard[playerX - 1][playerY] != 2 && gameboard[playerX - 1][playerY] != 999) {
        updatePlayerPos(playerX, playerY, playerX - 1, playerY);
      }
    }
      
    if (keyCode == RIGHT) {
      if (playerX < board_size - 1 && gameboard[playerX + 1][playerY] != 2 && gameboard[playerX + 1][playerY] != 999) {
        updatePlayerPos(playerX, playerY, playerX + 1, playerY);
      }
    }
  }
  
  if (key == 'q') {
    castingSpell = !castingSpell;
  }
}

void coneOfFire() {
  drawCone();
}

void drawCone() {
  // middle line
  //line((playerX * 10) + 5, (playerY * 10) + 5, hoverX + 5, hoverY + 5);
  int posX = (playerX * 10) + 5;
  int posY = (playerY * 10) + 5;
  float angle = (float)Math.atan2(mouseY-posY, mouseX-posX);

  translate(posX, posY);
  rotate(angle + radians(-90));

  stroke(0);
  fill(255, 185, 0);
  beginShape();
  vertex(0, 0);
  vertex(20, 60);
  curveVertex(15, 63);
  curveVertex(10, 65);
  curveVertex(5, 66);
  curveVertex(0, 67);
  curveVertex(-5, 66);
  curveVertex(-10, 65);
  curveVertex(-15, 63);
  vertex(-20, 60);
  vertex(0, 0);
  endShape();
}

void mousePressed() {
  // Updates location of player based on the path to the user's
  // hovering cursor.
  if (castingSpell) {
    
  }
  else if (isValidMovement(mouseX, mouseY) && 
           gameboard[(int)mouseX / 10][(int)mouseY / 10] != 999 &&
           !(hoverX / 10 == playerX && hoverY / 10 == playerY)) {
    updatePlayerPos(playerX, playerY, updatedX, updatedY);
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
      if ((x + i) > board_size - 1 ||
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
      if ((y + i) > board_size - 1 ||
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
  if (isValidMovement(mouseX, mouseY)) {
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
}

/*
 * Draws the 50x50 grid
 */
void drawGrid() {
  background(255);
  stroke(2);
  for (int i = 0; i < (board_size * 10) + 1; i++) {
    if (i % 10 == 0) {
      line(i, 0, i, (board_size * 10));
      line(0, i, (board_size * 10), i);
    }
  }
}

/*
 * Changes the cell of the player (green square) when 
 * the user clicks on a grid cell
 */
void updatePlayerPos(int oldX, int oldY, int x, int y) {
  // Clear the old location of the player
  gameboard[oldX][oldY] = 0;
  
  // Update player location and draw
  playerX = x;
  playerY = y;
  gameboard[playerX][playerY] = 1;
}

boolean isValidMovement(int x, int y) {
  return ((x >= 0) && (x < board_size * 10) && (y >= 0) && (y < board_size * 10));
}
