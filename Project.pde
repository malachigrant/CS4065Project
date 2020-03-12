Controller p1,p2;
Ball ball;
static final int FPS = 120;

PFont font;

void setup() {
  fullScreen();
  frameRate(FPS);
  font = createFont("times.ttf", 32);
  textFont(font);
  textAlign(CENTER, CENTER);
  
  fill(255);
  
  ball = new Ball();
  p1 = new Player(Side.LEFT, ball);
  p2 = new AI(Side.RIGHT, ball);
}

void draw() {
  ball.update();
  p1.update();
  p2.update();
  
  background(0);
  
  ball.render();
  p1.render();
  p2.render();
  
}
