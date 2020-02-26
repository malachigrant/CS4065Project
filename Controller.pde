private abstract class Controller {
  Paddle paddle;
  private Side side;
  
  public Controller(Side side) {
    this.side = side;
    this.paddle = new Paddle(250, 25);
  }
  
  public void render() {
    paddle.render(side);
  }
  public abstract void update();
}
enum Side {
  LEFT, RIGHT
}

private class Player extends Controller {
  public Player(Side side) {
    super(side);
  }
  
  public void update() {
    if (keyPressed) {
      if (keyCode == UP) {
        paddle.moveUp();
      } else if (keyCode == DOWN) {
        paddle.moveDown();
      }
    }
  }
}
