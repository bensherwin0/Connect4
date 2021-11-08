class MonteCarlo extends Player {
  Game g;
  float c; //exploration param
  final int MAXTIME;

  public MonteCarlo(Game g, int m) {
    this.g = new Game(g);
    MAXTIME = m;
    c = 1.4;
  }

  int getMove() {
    GameTree tree = new GameTree(g);
    int t1 = millis();

    while (millis() - t1 < MAXTIME) {
      Position node = tree.root;
      while (node.g.isOver() < 0 && node.children != null) {
        node = getNextChild(node);
      }
      if (node.g.isOver() >= 0) {
        if (node.g.isOver() == 0) node.backprop(0.5);
        else if (node.g.isOver() != node.player) node.backprop(0.);
        else node.backprop(1.0);
      } else {
        node.probeChildren();
        Position p = node.children.get(0);
        p.backprop(randomPlayout(p));
      }
    }

    float max = -1;
    int move = -1;
    int index = -1;
    for (int i = 0; i < tree.root.children.size(); i++) {
      if (tree.root.children.get(i).checked > max) {
        max = tree.root.children.get(i).checked;
        move = g.getLegalMoves().get(i);
        index = i;
      }
    }
    Position m = tree.root.children.get(index);
    //println("EVAL1: " + (m.value / m.checked));
    return move;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  Position getNextChild(Position p) {
    if (p.g.isOver() >= 0 || p.children == null) return null;
    Position nextChild = null;
    float maxval = -1;
    for (Position child : p.children) {
      if (child.checked == 0) return child;
      float val = (child.value / child.checked) + c * (float) Math.sqrt(Math.log(p.checked) / child.checked);
      if (val > maxval) {
        maxval = val;
        nextChild = child;
      }
    }
    return nextChild;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  float randomPlayout(Position p) {
    Game newgame = new Game(p.g);
    while (newgame.isOver() == -1) {
      ArrayList<Integer> legalMoves = newgame.getLegalMoves();
      int choice = (int) Math.random() * legalMoves.size();
      newgame.play(legalMoves.get(choice));
    }
    if (newgame.isOver() == 0) return 0.5;
    else if (newgame.isOver() != p.player) return 1.;
    else return 0.0;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  void updateBoard(int move) {
    g.play(move);
  }
  
  void reset() {
    g = new Game();
  }
}
