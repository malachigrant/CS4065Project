Controller p1,p2;
Ball ball;
static final int FPS = 120;

PFont font;

ScoreListener scoreListener;
Button button;
void setup() {
  fullScreen();
  frameRate(FPS);
  font = createFont("times.ttf", 32);
  textFont(font);
  textAlign(CENTER, CENTER);
  
  fill(255);
  
  scoreListener = new ScoreListener() {
    public void onScore(Side side) {
      if (side == Side.RIGHT) {
        p1.increaseDifficulty();
        p2.decreaseDifficulty();
        ball.increaseDifficulty();
      } else {
        p1.decreaseDifficulty();
        p2.increaseDifficulty();
        ball.decreaseDifficulty();
      }
    }
  };
  button = new Button(200, 75, 150, 150, "Hello");
  button.setClickListener(new ClickListener() {
    public void onClick() {
      scoreListener.onScore(Side.RIGHT);
    }
  });
  
  ball = new Ball();
  p1 = new Player(Side.LEFT, ball);
  p2 = new AI(Side.RIGHT, ball);
  ball.setListener(scoreListener);
}

void draw() {
  ball.update();
  p1.update();
  p2.update();
  //button.update();
  
  background(0);
  
  //button.render();
  ball.render();
  p1.render();
  p2.render();
  
}
