class CompPlayer extends Player // 
{
  Game g; //internal representation
  float[][] table = {{3, 4, 5, 7, 5, 4, 3}, 
    {4, 6, 8, 10, 8, 6, 4}, 
    {5, 8, 11, 13, 11, 8, 5}, 
    {5, 8, 11, 13, 11, 8, 5}, 
    {4, 6, 8, 10, 8, 6, 4}, 
    {3, 4, 5, 7, 5, 4, 3}};
  float eval;
  TranspositionTable<Integer, Float[]> trans;
  final int MAXTIME;

  public CompPlayer(Game g, int m) {
    this.g = new Game(g);
    eval = 0;
    trans = new TranspositionTable<Integer, Float[]>(10000000);
    MAXTIME = m;
  }

  int getMove() {
    int depth = 1;
    int t1 = millis();
    float max1 = -1001;
    int move1 = -1;
    while ((depth == 0 || millis() - t1 < MAXTIME) && depth < 42-g.numMoves + 1) {
      //while(depth < 9) {
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
      max1 = max;
      move1 = move;
      depth++;
    }
    //println("MAX DEPTH: " + (depth-1));
    //println("EVAL: " + max1);
    return move1;
  }

  float evalMove(Game g, int depth, float alpha, float beta) { //negamax alpha beta
    if (g.gameState != -1) {
      if (g.gameState == 0) return 0;
      else return -1000;
    } else if (depth == 0) return heuristicEval1(g);

    Float[] v = trans.get(g.hashCode());
    if (v != null && v[1] >= depth) {
      if (v[0] > alpha) alpha = v[0];
      return v[0];
    }

    ArrayList<Integer> move = orderMoves(g);

    float bestVal = -1002;
    for (int i = 0; i < move.size(); i++) {
      updateBoard(move.get(i));
      float val = -1*evalMove(g, depth-1, -1*beta, -1*alpha);
      undo(move.get(i));
      bestVal = max(bestVal, val);
      if (bestVal >= beta) break;
      else if (bestVal > alpha) alpha = bestVal;
    }

    trans.put(g.hashCode(), new Float[] {bestVal, (float) depth});
    return bestVal;
  }




  ArrayList<Integer> orderMoves(Game g) {  // orders the moves 1-7 based on SOMETHING and returns in a list -- must check for filled column!
    ArrayList<Integer> moves = new ArrayList<Integer>();
    //ArrayList<Float> values = new ArrayList<Float>();
    //for (int i = 1; i <= 7; i++) {
    //  if (g.board[5][i-1] == 0) {
    //    g.play(i);
    //    Float va[] = (trans.get(g.hashCode()));
    //    g.unplay(i);
    //    Float val;
    //    if (va != null) val = va[0];
    //    else val = null;      
    //    if (val == null) {
    //      if (values.size() > 0) {
    //        moves.add(moves.size()-1, i);
    //        values.add(values.size()-1, -1000.);
    //      } else {
    //        moves.add(i);
    //        values.add(-1000.);
    //      }
    //    } else {
    //      if (values.size() > 0) {
    //        int j = 0;
    //        while (j < values.size() && val < values.get(j)) {
    //          j++;
    //        }
    //        values.add(j, val);
    //        moves.add(j, i);
    //      } else {
    //        values.add(val);
    //        moves.add(i);
    //      }
    //    }
    //  }
    //}
    //Collections.reverse(moves);

    int move = 4;
    int factor = 1;
    for (int i = 1; i <= 7; i++) {
      if (g.board[5][move-1] == 0) {
        moves.add(move);
      }
      move += factor * i;
      factor *= -1;
    }
    return moves;
  }

  void resetTrans() {
    trans = new TranspositionTable<Integer, Float[]>(10000000);
  }


  float heuristicEval1(Game g) { 
    //returns a float between 10 and -10 (inclusive) to represent how good the move is

    int factor = 1;
    if (g.currPlayer == 2) factor = -1;
    return factor * eval;
  }



  void updateBoard(int move) {
    g.play(move);

    int i = 5;
    while (g.board[i][move-1] == 0) i--;
    if (g.board[i][move-1] == 1) eval += table[i][move-1];
    else eval -= table[i][move-1];
  }

  void undo(int move) {
    int i = 5;
    while (g.board[i][move-1] == 0) i--;
    if (g.board[i][move-1] == 1) eval -= table[i][move-1];
    else eval += table[i][move-1];

    g.unplay(move);
  }

  void reset() {
    g = new Game();
  }
}



class TranspositionTable<K, V> extends LinkedHashMap<K, V> {
  private final int maxSize;

  public TranspositionTable(int maxSize) {
    this.maxSize = maxSize;
  }

  @Override
    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
    return size() > maxSize;
  }
}
