import java.util.*;

Game g;
int mouseCol;
CompPlayer p;
boolean first = false; //compPlayer
Player m;
Player m2;

Player[] ms;

void setup() {
  size(700, 600);
  g = new Game();
  mouseCol = -1;
  ms = new Player[] {
    new MonteCarlo2(g, 1000, 1.4, 0),
    new MonteCarlo2(g, 1000, 1., .8), 
    new MonteCarlo2(g, 1000, 1.4, .8),
    new CompPlayer2(g, 1, 9)
  };

  m = new MonteCarlo(g, 1000);
  m2 = new MonteCarlo2(g, 500, 1.4, .8);

  //CompPlayer2 b = new CompPlayer2(g, 1, 8);
  //CompPlayer a = new CompPlayer(g, 1);
  for (int n = 0; n < ms.length; n++) {
    println("P" + n + " VS:");
    for (int m = 0; m < ms.length; m++) {
      if (n != m) {
        print("P" + m + "[ ");
        Player a = ms[n];
        Player b = ms[m];

        int aWin = 0;
        int bWin = 0;
        int tie = 0;
        for (int i = 0; i < 0; i++) {
          while (g.isOver() < 0) {
            int am = a.getMove();
            g.play(am);
            a.updateBoard(am);
            b.updateBoard(am);
            //print("a: " + am + ", ");
            if (g.isOver() < 0) {
              int bm = b.getMove();
              g.play(bm);
              b.updateBoard(bm);
              a.updateBoard(bm);
            }
          }
          if (g.isOver() == 1) aWin++;
          else if (g.isOver() == 2) bWin++;
          else tie++;
          g.reset();
          a.reset();
          b.reset();
        }
        print(aWin + ", " + bWin + ", " + tie + " ], ");
      }
      else print("----------");
    }
    println();
  }


  if (!first)
    p = new CompPlayer(g, 300);
  else {
    p = new CompPlayer(g, 200);
    int move = m2.getMove();
    g.play(move);
    m2.updateBoard(move);
  }
}


void draw() {
  background(255);
  g.show();
}

void mousePressed() {
  mouseCol = floor((mouseX - 50.)*7/(width-100)) + 1; 
  if (0 < mouseCol && mouseCol <= 7) {
    g.play(mouseCol);
    m2.updateBoard(mouseCol);
    if (g.isOver() < 0) {
      float t1 = millis();
      int move = m2.getMove();
      float t2 = millis();
      //println("TIME: " + (t2-t1));
      g.play(move);
      m2.updateBoard(move);
    }
  }
}
