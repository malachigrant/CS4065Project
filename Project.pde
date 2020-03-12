Controller p1,p2;
Ball ball;
static final int FPS = 120;

void setup() {
  fullScreen();
  frameRate(FPS);
  ball = new Ball(Side.LEFT);
  p1 = new Player(Side.LEFT, ball);
  p2 = new AI(Side.RIGHT, ball);
}

void draw() {
  
  background(185);
  ball.render();
  p1.render();
  p2.render();
  ball.update();
  p1.update();
  p2.update();
  
}
