import java.util.*;

class Cell {
 int x, y, parent_x, parent_y;
 double f, g, h;
}

// Function to check if a cell row/col is within range
boolean isValid(Cell cell) {
  return (cell.x >= 0) && (cell.x < 50) && 
         (cell.y >= 0) && (cell.y < 50);
}

// Function to check if a cell is occupied by wall
boolean isBlocked(int[][] gameboard, Cell cell) {
   return gameboard[cell.x][cell.y] == 999; 
}

boolean isDestination(Cell source, Cell dest) {
 return source.x == dest.x && source.y == dest.y; 
}

double calculateH(Cell source, Cell dest) {
 return dist(source.x, source.y, dest.x, dest.y); 
}

void astar(Cell source, Cell dest, int[][] gameboard) {
  Stack<Cell> openList = new Stack<Cell>();
  boolean closedList[][] = new boolean[50][50];
  
  if (!isValid(source) && !isValid(dest)) {
    println("Source or target is invalid.");
  }
  
  if (isBlocked(gameboard, source) || isBlocked(gameboard, dest)) {
    println("Source or target is blocked.");      
  }
  
  if (isDestination(source, dest)) {
     println("Already at destination."); 
  }
  
  int x = source.x, y = source.y;
  source.f = 0.0;
  source.g = 0.0;
  source.h = 0.0;
  source.parent_x = x;
  source.parent_y = y;
  
  openList.push(source);
  
  boolean foundDest = false;
  
  while (!openList.empty()) {
    
  }
}
