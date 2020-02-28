private abstract class Controller {
  Paddle paddle;
  private Side side;
  private Ball ball;
  
  public Controller(Side side, Ball ball) {
    this.side = side;
    this.ball = ball;
    this.paddle = new Paddle(250, 25, side);
  }
  
  public void render() {
    paddle.render();
  }
  public void update() {
    if (ball.detectCollision(paddle)) {
      ball.switchXDirection();
    }
  }
}
enum Side {
  LEFT, RIGHT
}

private class Player extends Controller {
  public Player(Side side, Ball ball) {
    super(side, ball);
  }
  
  public void update() {
    super.update();
    if (keyPressed) {
      if (keyCode == UP) {
        paddle.moveUp();
      } else if (keyCode == DOWN) {
        paddle.moveDown();
      }
    }
  }
}

private class AI extends Controller {
  public AI(Side side, Ball ball) {
    super(side, ball);
  }
  
  public void update() {
    super.update();
    if (ball.getPosition().getY() > paddle.getPosition().getY() + paddle.getHeight() / 2) {
      paddle.moveDown();
    } else if (ball.getPosition().getY() < paddle.getPosition().getY() + paddle.getHeight() / 2) {
      paddle.moveUp();
    }
  }
}
