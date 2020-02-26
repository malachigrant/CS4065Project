Player p1,p2;

void setup() {
  fullScreen();
  frameRate(60);
  p1 = new Player(Side.LEFT);
  p2 = new Player(Side.RIGHT);
}

void draw() {
  p1.update();
  p2.update();
  
  background(185);
  
  p1.render();
  p2.render();
}
