class CompPlayer2 extends Player
{
  Game g; //internal representation
  int player;
  float[][] table = {{3, 4, 5, 7, 5, 4, 3},
    {4, 6, 8, 10, 8, 6, 4},
    {5, 8, 11, 13, 11, 8, 5},
    {5, 8, 11, 13, 11, 8, 5},
    {4, 6, 8, 10, 8, 6, 4},
    {3, 4, 5, 7, 5, 4, 3}};
   float eval;
   int depth;

  public CompPlayer2(Game g, int player, int d) {
    this.g = new Game(g);
    this.player = player;
    eval = 0;
    depth = d;
  }

  int getMove() {
    float max = -1001;
    int move = -1;
    ArrayList<Integer> m = orderMoves(g);
    for (int i : m) {
      updateBoard(i);
      float eval = -1*evalMove(g, depth, -1001, 1001);
      undo(i);
      if (eval>max) {
        max = eval;
        move = i;
      }
    }
    //println("MAX EVAL: " + max);
    return move;
  }

  float evalMove(Game g, int depth, float alpha, float beta) { //negamax alpha beta
    if (g.gameState != -1) {
      if (g.gameState == 0) return 0;
      else return -1000;
    } else if (depth == 0) return heuristicEval1(g);

    ArrayList<Integer> move = orderMoves(g);

    float bestVal = -1001;
    for (int i = 0; i < move.size(); i++) {
      updateBoard(move.get(i));
      float val = -1*evalMove(g, depth-1, -1*beta, -1*alpha);
      undo(move.get(i));
      bestVal = max(bestVal, val);
      if (bestVal >= beta) break;
      else if (bestVal > alpha) alpha = bestVal;
    }
    return bestVal;
  }




  ArrayList<Integer> orderMoves(Game g) {  // orders the moves 1-7 based on SOMETHING and returns in a list -- must check for filled column!
    ArrayList<Integer> moves = new ArrayList<Integer>();
    for (int i = 0; i < 7; i++) {
      if (g.board[5][i] == 0) moves.add(i+1);
    }
    return moves;
  }


  float heuristicEval1(Game g) {
    //returns a float between 10 and -10 (inclusive) to represent how good the move is
   
    int factor = 1;
    if(g.currPlayer == 2) factor = -1;
    return factor * eval;
  }



  void updateBoard(int move) {
    g.play(move);
   
    int i = 5;
    while(g.board[i][move-1] == 0) i--;
    if(g.board[i][move-1] == 1) eval += table[i][move-1];
    else eval -= table[i][move-1];
  }
 
  void undo(int move) {
    int i = 5;
    while(g.board[i][move-1] == 0) i--;
    if(g.board[i][move-1] == 1) eval -= table[i][move-1];
    else eval += table[i][move-1];
   
    g.unplay(move);
  }
  
  void reset() {
    g = new Game(); 
  }
}
