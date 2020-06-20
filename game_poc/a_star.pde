import java.util.*;

class Cell {
 int x, y, parent_x, parent_y;
 double f, g, h;
 
 public Cell(int _x, int _y) {
   x = _x;
   y = _y;
 }
}

// Function to check if a cell row/col is within range
boolean isValid(int x, int y) {
  return (x >= 0) && (x < 50) && 
         (y >= 0) && (y < 50);
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

Stack<Cell> astar(Cell source, Cell dest, int[][] gameboard) {
  Stack<Cell> openList = new Stack<Cell>();
  boolean closedList[][] = new boolean[50][50];
  
  if (!isValid(source.x, source.y) || !isValid(dest.x, dest.y)) {
    println("Source or target is invalid.");
    return null;
  }
  
  if (isBlocked(gameboard, source) || isBlocked(gameboard, dest)) {
    println("Source or target is blocked.");
    return null;
  }
  
  if (isDestination(source, dest)) {
     println("Already at destination."); 
     return null;
  }
  
  Cell[][] cellDetails = new Cell[50][50];
  
  for (int i = 0; i < 50; i++) {
     for (int j = 0; j < 50; j++) {
       cellDetails[i][j] = new Cell(i, j);
       cellDetails[i][j].f = Double.MAX_VALUE;
       cellDetails[i][j].g = Double.MAX_VALUE;
       cellDetails[i][j].h = Double.MAX_VALUE;
       cellDetails[i][j].parent_x = -1;
       cellDetails[i][j].parent_y = -1;
     }
  }
  
  int x = source.x, y = source.y;
  cellDetails[x][y].f = 0.0;
  cellDetails[x][y].g = 0.0;
  cellDetails[x][y].h = 0.0;
  cellDetails[x][y].parent_x = x;
  cellDetails[x][y].parent_y = y;
  
  openList.push(source);
  
  while (!openList.empty()) {
    Cell cell = openList.pop();
    x = cell.x;
    y = cell.y;
    closedList[x][y] = true;
    
    double gNew, hNew, fNew;
    
    // Check cell north of current cell
    if (isValid(cell.x, cell.y - 1) == true) {
      
      Cell north = new Cell(cell.x, cell.y - 1);
      
      if (isDestination(north, dest) == true) {
        cellDetails[north.x][north.y].parent_x = x;
        cellDetails[north.x][north.y].parent_y = y;
        println("The destination cell was found north of cell[" + x + "][" + y + "] at cell[" + north.x + "][" + north.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[north.x][north.y] == false &&
               isBlocked(gameboard, north) == false) {
        gNew = cellDetails[x][y].g + 1.0;
        hNew = calculateH(north, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[north.x][north.y].f == Double.MAX_VALUE ||
            cellDetails[north.x][north.y].f > fNew) {
          openList.push(north);
          
          cellDetails[north.x][north.y].f = fNew;
          cellDetails[north.x][north.y].g = gNew;
          cellDetails[north.x][north.y].h = hNew;
          cellDetails[north.x][north.y].parent_x = x;
          cellDetails[north.x][north.y].parent_y = y;
        }
      }
    }
    
    // Check cell south of current cell
    if (isValid(cell.x, cell.y + 1) == true) {
      
      Cell south = new Cell(cell.x, cell.y + 1);
      
      if (isDestination(south, dest) == true) {
        cellDetails[south.x][south.y].parent_x = x;
        cellDetails[south.x][south.y].parent_y = y;
        println("The destination cell was found south of cell[" + x + "][" + y + "] at cell[" + south.x + "][" + south.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[south.x][south.y] == false &&
               isBlocked(gameboard, south) == false) {
        gNew = cellDetails[x][y].g + 1.0;
        hNew = calculateH(south, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[south.x][south.y].f == Double.MAX_VALUE ||
            cellDetails[south.x][south.y].f > fNew) {
          openList.push(south);
          
          cellDetails[south.x][south.y].f = fNew;
          cellDetails[south.x][south.y].g = gNew;
          cellDetails[south.x][south.y].h = hNew;
          cellDetails[south.x][south.y].parent_x = x;
          cellDetails[south.x][south.y].parent_y = y;
        }
      }
    }
    
    // Check cell east of current cell
    if (isValid(cell.x + 1, cell.y) == true) {
      
      Cell east = new Cell(cell.x + 1, cell.y);
      
      if (isDestination(east, dest) == true) {
        cellDetails[east.x][east.y].parent_x = x;
        cellDetails[east.x][east.y].parent_y = y;
        println("The destination cell was found east of cell[" + x + "][" + y + "] at cell[" + east.x + "][" + east.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[east.x][east.y] == false &&
               isBlocked(gameboard, east) == false) {
        gNew = cellDetails[x][y].g + 1.0;
        hNew = calculateH(east, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[east.x][east.y].f == Double.MAX_VALUE ||
            cellDetails[east.x][east.y].f > fNew) {
          openList.push(east);
          
          cellDetails[east.x][east.y].f = fNew;
          cellDetails[east.x][east.y].g = gNew;
          cellDetails[east.x][east.y].h = hNew;
          cellDetails[east.x][east.y].parent_x = x;
          cellDetails[east.x][east.y].parent_y = y;
        }
      }
    }
    
    // Check cell west of current cell
    if (isValid(cell.x - 1, cell.y) == true) {
      
      Cell west = new Cell(cell.x - 1, cell.y);
      
      if (isDestination(west, dest) == true) {
        cellDetails[west.x][west.y].parent_x = x;
        cellDetails[west.x][west.y].parent_y = y;
        println("The destination cell was found west of cell[" + x + "][" + y + "] at cell[" + west.x + "][" + west.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[west.x][west.y] == false &&
               isBlocked(gameboard, west) == false) {
        gNew = cellDetails[x][y].g + 1.0;
        hNew = calculateH(west, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[west.x][west.y].f == Double.MAX_VALUE ||
            cellDetails[west.x][west.y].f > fNew) {
          openList.push(west);
          
          cellDetails[west.x][west.y].f = fNew;
          cellDetails[west.x][west.y].g = gNew;
          cellDetails[west.x][west.y].h = hNew;
          cellDetails[west.x][west.y].parent_x = x;
          cellDetails[west.x][west.y].parent_y = y;
        }
      }
    }
    
    // Check cell northeast of current cell
    if (isValid(cell.x + 1, cell.y - 1) == true) {
      
      Cell northEast = new Cell(cell.x + 1, cell.y - 1);
      
      if (isDestination(northEast, dest) == true) {
        cellDetails[northEast.x][northEast.y].parent_x = x;
        cellDetails[northEast.x][northEast.y].parent_y = y;
        println("The destination cell was found west of cell[" + x + "][" + y + "] at cell[" + northEast.x + "][" + northEast.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[northEast.x][northEast.y] == false &&
               isBlocked(gameboard, northEast) == false) {
        gNew = cellDetails[x][y].g + 1.414;
        hNew = calculateH(northEast, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[northEast.x][northEast.y].f == Double.MAX_VALUE ||
            cellDetails[northEast.x][northEast.y].f > fNew) {
          openList.push(northEast);
          
          cellDetails[northEast.x][northEast.y].f = fNew;
          cellDetails[northEast.x][northEast.y].g = gNew;
          cellDetails[northEast.x][northEast.y].h = hNew;
          cellDetails[northEast.x][northEast.y].parent_x = x;
          cellDetails[northEast.x][northEast.y].parent_y = y;
        }
      }
    }
    
    // Check cell southeast of current cell
    if (isValid(cell.x + 1, cell.y + 1) == true) {
      
      Cell southEast = new Cell(cell.x + 1, cell.y + 1);
      
      if (isDestination(southEast, dest) == true) {
        cellDetails[southEast.x][southEast.y].parent_x = x;
        cellDetails[southEast.x][southEast.y].parent_y = y;
        println("The destination cell was found west of cell[" + x + "][" + y + "] at cell[" + southEast.x + "][" + southEast.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[southEast.x][southEast.y] == false &&
               isBlocked(gameboard, southEast) == false) {
        gNew = cellDetails[x][y].g + 1.414;
        hNew = calculateH(southEast, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[southEast.x][southEast.y].f == Double.MAX_VALUE ||
            cellDetails[southEast.x][southEast.y].f > fNew) {
          openList.push(southEast);
          
          cellDetails[southEast.x][southEast.y].f = fNew;
          cellDetails[southEast.x][southEast.y].g = gNew;
          cellDetails[southEast.x][southEast.y].h = hNew;
          cellDetails[southEast.x][southEast.y].parent_x = x;
          cellDetails[southEast.x][southEast.y].parent_y = y;
        }
      }
    }
    
    // Check cell southwest of current cell
    if (isValid(cell.x - 1, cell.y + 1) == true) {
      
      Cell southWest = new Cell(cell.x - 1, cell.y + 1);
      
      if (isDestination(southWest, dest) == true) {
        cellDetails[southWest.x][southWest.y].parent_x = x;
        cellDetails[southWest.x][southWest.y].parent_y = y;
        println("The destination cell was found west of cell[" + x + "][" + y + "] at cell[" + southWest.x + "][" + southWest.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[southWest.x][southWest.y] == false &&
               isBlocked(gameboard, southWest) == false) {
        gNew = cellDetails[x][y].g + 1.414;
        hNew = calculateH(southWest, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[southWest.x][southWest.y].f == Double.MAX_VALUE ||
            cellDetails[southWest.x][southWest.y].f > fNew) {
          openList.push(southWest);
          
          cellDetails[southWest.x][southWest.y].f = fNew;
          cellDetails[southWest.x][southWest.y].g = gNew;
          cellDetails[southWest.x][southWest.y].h = hNew;
          cellDetails[southWest.x][southWest.y].parent_x = x;
          cellDetails[southWest.x][southWest.y].parent_y = y;
        }
      }
    }
    
    // Check cell northwest of current cell
    if (isValid(cell.x - 1, cell.y - 1) == true) {
       
      Cell northWest = new Cell(cell.x - 1, cell.y - 1);
      
      if (isDestination(northWest, dest) == true) {
        cellDetails[northWest.x][northWest.y].parent_x = x;
        cellDetails[northWest.x][northWest.y].parent_y = y;
        println("The destination cell was found west of cell[" + x + "][" + y + "] at cell[" + northWest.x + "][" + northWest.y + "].");
        return tracePath(cellDetails, dest);
      }
      else if (closedList[northWest.x][northWest.y] == false &&
               isBlocked(gameboard, northWest) == false) {
        gNew = cellDetails[x][y].g + 1.414;
        hNew = calculateH(northWest, dest);
        fNew = gNew + hNew;
        
        if (cellDetails[northWest.x][northWest.y].f == Double.MAX_VALUE ||
            cellDetails[northWest.x][northWest.y].f > fNew) {
          openList.push(northWest);
          
          cellDetails[northWest.x][northWest.y].f = fNew;
          cellDetails[northWest.x][northWest.y].g = gNew;
          cellDetails[northWest.x][northWest.y].h = hNew;
          cellDetails[northWest.x][northWest.y].parent_x = x;
          cellDetails[northWest.x][northWest.y].parent_y = y;
        }
      }
    }
  }
  
  println("Failed to find destination."); 
  
  return null;
}

Stack<Cell> tracePath(Cell[][] cellDetails, Cell dest) {
  Stack<Cell> path = new Stack<Cell>();
  
  int x = dest.x;
  int y = dest.y;
  
  while (!(cellDetails[x][y].parent_x == x && cellDetails[x][y].parent_y == y )) { 
    path.push(new Cell(x, y));
    int parent_x = cellDetails[x][y].parent_x; 
    int parent_y = cellDetails[x][y].parent_y; 
    x = parent_x;
    y = parent_y;
  } 
  
  path.push(new Cell(x, y));
  
  return path;
}
