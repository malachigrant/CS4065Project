Controller p1,p2;
Ball ball;

void setup() {
  fullScreen();
  frameRate(60);
  ball = new Ball(Side.LEFT);
  p1 = new Player(Side.LEFT, ball);
  p2 = new AI(Side.RIGHT, ball);
}

void draw() {
  ball.update();
  p1.update();
  p2.update();
  
  background(185);
  
  ball.render();
  p1.render();
  p2.render();
}
