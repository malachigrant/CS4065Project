private abstract class Controller {
  Paddle paddle;
  private Side side;
  private Ball ball;
  private int score = 0;
  
  public Controller(Side side, Ball ball) {
    this.side = side;
    this.ball = ball;
    this.paddle = new Paddle(150, 25, side);
  }
  
  public void render() {
    paddle.render();
    text("" + score, (side == Side.LEFT ? Paddle.MARGIN * 2 : width - Paddle.MARGIN * 2), 25);
  }
  public void update() {
    if (ball.detectCollision(paddle)) {
      ball.switchXDirection();
    }
    if (ball.detectScore(side)) {
      score++;
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
    double diff = ball.getPosition().getY() - paddle.getCenter().getY();
    if (diff > Paddle.BASE_SPEED) {
      paddle.moveDown();
    } else if (diff < -Paddle.BASE_SPEED) {
      paddle.moveUp();
    }
  }
}
