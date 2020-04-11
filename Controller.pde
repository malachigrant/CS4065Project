Map<Integer, Boolean> heldKeys = new HashMap<Integer, Boolean>();
void keyPressed() {
  heldKeys.put(keyCode, true);
}
void keyReleased() {
  heldKeys.remove(keyCode);
}
boolean isKeyHeld(int code) {
  return heldKeys.getOrDefault(code, false);
}

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
  
  public int getScore() {
    return score;
  }
  
  public void setScore(int score) {
    this.score = score;
  }
  
  public void setPaddleSpeed(double speed) {
    paddle.setSpeed(speed);
  }
  
  public void increaseDifficulty(double mult) {
    paddle.increaseDifficulty(mult);
  }
  public void decreaseDifficulty(double mult) {
    paddle.decreaseDifficulty(mult);
  }
  
  public void render() {
    paddle.render();
    text("" + score, (side == Side.LEFT ? Paddle.MARGIN * 2 : width - Paddle.MARGIN * 2), 25);
  }
  public void update() {
    if (ball.detectCollision(paddle)) {
      ball.switchXDirection();
    }
    if (ball.detectScore((side == Side.LEFT ? Side.RIGHT : Side.LEFT))) {
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
    if (isKeyHeld(UP)) {
      paddle.moveUp();
    }
    if (isKeyHeld(DOWN)) {
      paddle.moveDown();
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
    if (Math.abs(diff) < Paddle.BASE_SPEED) {
      return;
    }
    if (diff > 0) {
      paddle.moveDown();
    } else {
      paddle.moveUp();
    }
  }
}

private interface ScoreListener {
  void onScore(Side side);
}
