class GameTree {
  Position root;

  public GameTree(Game g) {
    root = new Position(null, g);
    root.children = new ArrayList<Position>();
    for (Integer move : g.getLegalMoves()) {
      Game newGame = new Game(g);
      newGame.play(move);
      root.children.add(new Position(root, newGame));
    }
  }
}

class Position {
  float value;
  float checked;
  int player;
  int over;
  Game g;
  Position parent;
  ArrayList<Position> children;

  public Position(Position p, Game g) {
    value = 0;
    checked = 0;
    this.g = g;
    player = g.currPlayer;
    parent = p;
    children = null;
    over = g.isOver();
  }

  ArrayList<Position> probeChildren() {
    if (over == -1) {
      children = new ArrayList<Position>();
      for (Integer move : g.getLegalMoves()) {
        Game newGame = new Game(g);
        newGame.play(move);
        children.add(new Position(this, newGame));
      }
      Collections.shuffle(children);
    }
    return children;
  }

  void backprop(float val) {
    checked++;
    value += val;
    if (parent != null) {
      parent.backprop(1 - val);
    }
  }
}

abstract class Player {
   abstract int getMove();
   abstract void updateBoard(int m);
   abstract void reset();
}
