class Game {
  int [][] board; //[row][col]
  int currPlayer; //1 or 2 = red or blue
  int gameState; // 1 or 2 for winner, -1 for still in progress, 0 for tie
  int numMoves;

  public Game() {
    currPlayer = 1;
    board = new int[6][7];
    gameState = -1;
    numMoves = 0;
  }

  public Game(Game g) {
    board = new int[6][7];
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 7; col++) {
        this.board[row][col] = g.board[row][col];
      }
    }
    gameState = g.gameState;
    currPlayer = g.currPlayer;
    numMoves = g.numMoves;
  }

  void reset() {
    currPlayer = 1;
    board = new int[6][7];
    gameState = -1;
    numMoves = 0;
  }

  boolean play(int move) {//input 1-7
    if (gameState >= 0) return false;
    int row = -1;
    int col = move-1;
    for (int i = 0; i < 6; i++) {
      if (board[i][move-1] == 0) {
        board[i][move-1] = currPlayer; 
        row = i;
        i = 6;
      }
      if (i == 5) return false;
    }
    numMoves++;
    // check if game over.  Move is at board[row][col]
    // WHORIZONTLE
    int low = max(col - 3, 0);
    int high = min(col + 3, 6);
    int counter = 0;
    for (int i = low; i<= high; i++) {
      if (board[row][i] == currPlayer)
        counter++;
      else counter = 0;
      if (counter == 4) {
        gameState = currPlayer;
        return true;
      }
    }

    //vertical
    low = max(row - 3, 0);
    high = min(row + 3, 5);
    counter = 0;
    for (int i = low; i <= high; i++) {
      if (board[i][col] == currPlayer) counter++;
      else counter = 0;
      if (counter == 4) {
        gameState = currPlayer;
        return true;
      }
    }

    //diags
    //positive slope
    counter = 0;
    int displaceN = -3;
    if (col - 3 < 0) displaceN = -1 * col;
    if (row + displaceN < 0) displaceN = -1 * row;
    int displaceP = 3;
    if (col + 3 > 6) displaceP = 6 - col;
    if (row + displaceP > 5) displaceP = 5 - row;
    for (int i = displaceN; i<= displaceP; i++) {
      if (board[row + i][col + i] == currPlayer) counter++;
      else counter = 0;
      if (counter == 4) {
        gameState = currPlayer;
        return true;
      }
    }

    // negative slope
    counter = 0;
    displaceN = -3;
    if (col - 3 < 0) displaceN = -1 * col;
    if (row - displaceN > 5) displaceN = row - 5;
    displaceP = 3;
    if (col + 3 > 6) displaceP = 6 - col;
    if (row - displaceP < 0) displaceP = row;
    for (int i = displaceN; i<= displaceP; i++) {
      if (board[row - i][col + i] == currPlayer) counter++;
      else counter = 0;
      if (counter == 4) {
        gameState = currPlayer;
        return true;
      }
    }

    //tie
    for (int i = 0; i < 7; i++) {
      if (board[5][i] == 0) i = 7;
      if (i == 6) {
        gameState = 0;
        return true;
      }
    }
    currPlayer = currPlayer % 2 + 1;
    return true;
  }

  boolean unplay(int move) {  //input 1-7
    for (int i = 5; i >= 0; i--) {
      if (board[i][move - 1] != 0) {
        board[i][move - 1] = 0;
        break;
      }
      if (i == 0) return false;
    }
    if (gameState == -1) currPlayer = currPlayer % 2 + 1;
    gameState = -1;
    numMoves--;
    return true;
  }

  int isOver() { //returns -1 if in progress, 0 if tie, otherwise winner (1 or 2)
    return gameState;
  } 

  void show() {
    //grid lines
    stroke(0);
    strokeWeight(3);
    int h = height-100;
    int w = width-100;
    for (int i = 1; i <= 6; i++) {
      line(50, i*h/6+50, width-50, i*h/6+50);
    }
    for (int i = 0; i <= 7; i++) {
      line(i*w/7+50, 50, i*w/7+50, height-50);
    }


    //colors
    noStroke();
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[0].length; col++) {
        if (board[5-row][col] == 1) fill(255, 0, 0);
        else if (board[5-row][col] == 2) fill(0, 0, 255);
        if (board[5-row][col] != 0)
          ellipse(51+w*col/7+w/14, 51+h*row/6+w/14, h/8, h/8);
      }
    }
  }


  boolean isEqual(Object ga) {
    Game g = (Game) ga;
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 7; col++) {
        if (this.board[row][col] != g.board[row][col]) {
          return false;
        }
      }
    }
    return true;
  }


  int hashCode() {
    String code = "";
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 7; col++) {
        code += board[row][col];
      }
    }
    return code.hashCode();
  }
  
  ArrayList<Integer> getLegalMoves() {
   // orders the moves 1-7 based on SOMETHING and returns in a list -- must check for filled column!
    ArrayList<Integer> moves = new ArrayList<Integer>();
    int move = 4;
    int factor = 1;
    for (int i = 1; i <= 7; i++) {
      if (board[5][move-1] == 0) {
        moves.add(move);
      }
      move += factor * i;
      factor *= -1;
    }
    return moves;
  }
}
