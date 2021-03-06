import java.awt.geom.*;

private class Vector {
  private double x, y;
  
  public Vector(double x, double y) {
    this.x = x;
    this.y = y;
  }
  
  public void add(Vector v) {
    this.x += v.getX();
    this.y += v.getY();
  }
  public void mult(Vector v) {
    this.x *= v.getX();
    this.y *= v.getY();
  }
  
  public void setX(double x) {
    this.x = x;
  }
  public void setY(double y) {
    this.y = y;
  }
  
  public double getX() {
    return x;
  }
  public double getY() {
    return y;
  }
}

public Vector addVectors(Vector v1, Vector v2) {
  return new Vector(v1.getX() + v2.getX(), v1.getY() + v2.getY());
}
public Line2D lineFromVectors(Vector v1, Vector v2) {
  return new Line2D.Double(v1.getX(), v1.getY(), v2.getX(), v2.getY());
}

public double clamp(double num, double min, double max) {
  if (num < min) {
    return min;
  } else if (num > max) {
    return max;
  }
  return num;
}

private class Ball {
  
  private static final double INITIAL_X_SPEED = 500 / FPS;
  private static final double INITIAL_Y_SPEED = 400 / FPS;
  private static final double BALL_RADIUS = 25;
  private static final double SPEED_MULT_STEP = 0.01;
  private static final double SPEED_MULT_MAX = 1.1;
  private static final double SPEED_MULT_MIN = 1.01;
  private Vector position;
  private Vector velocity;
  private ScoreListener listener;
  private double speedMult = 1.05; // applied every time the ball is redirected by a paddle
  private int delay; // wait a second before ball starts moving
  private int ballColor = 255;
  
  public Ball() {
    init();
  }
  
  public void setListener(ScoreListener listener) {
    this.listener = listener;
  }
  
  public void init() {
    delay = FPS;
    Side side = (random(1) < 0.5 ? Side.LEFT : Side.RIGHT);
    double yDirection = (random(1) < 0.5 ? -1 : 1);
    position = new Vector(width / 2, height / 2);
    double xDirection = (side == Side.LEFT ? -1 : 1);
    velocity = new Vector(INITIAL_X_SPEED * xDirection, INITIAL_Y_SPEED * yDirection);
  }
  
  public void increaseDifficulty() {
    speedMult = clamp(speedMult + SPEED_MULT_STEP, SPEED_MULT_MIN, SPEED_MULT_MAX);
  }
  public void decreaseDifficulty() {
    speedMult = clamp(speedMult - SPEED_MULT_STEP, SPEED_MULT_MIN, SPEED_MULT_MAX);  }
  
  public Vector getPosition() {
    return position;
  }
  
  public void switchXDirection() {
    velocity.mult(new Vector(-speedMult, speedMult));
  }
  
  public boolean detectScore(Side side) {
    boolean result = false;
    if (side == Side.LEFT && position.getX() < 0) {
      result = true;
    } else if (side == Side.RIGHT && position.getX() > width) {
      result = true;
    }
    
    if (result == true) {
      if (listener != null) {
        listener.onScore(side);
      }
      init();
    }
    return result;
  }
  
  // This is probably a terrible way to detect collisions.
  public boolean detectCollision(Paddle paddle) {
    Line2D paddleLine = paddle.getCollisionLine();
    if (paddle.getSide() == Side.LEFT && velocity.getX() > 0
        || paddle.getSide() == Side.RIGHT && velocity.getX() < 0) {
      return false;
    }
    /* double threshold = Math.abs(velocity.getX()) * 20;
    if ((paddle.getSide() == Side.LEFT && paddleLine.getX1() - (position.getX() - BALL_RADIUS) > threshold)
        || (paddle.getSide() == Side.RIGHT && (position.getX() + BALL_RADIUS) - paddleLine.getX1() > threshold)){
      println(paddleLine.getX1() - (position.getX() - BALL_RADIUS), velocity.getX());
      // ball is too far gone... ignore
      return false;
    }*/
    
    double angle = Math.atan(velocity.y / velocity.x) + Math.PI / 2;
    Vector oldPosition = addVectors(position, new Vector(-velocity.getX(), -velocity.getY()));
    Vector rayOffset = new Vector(Math.cos(angle) * BALL_RADIUS, Math.sin(angle) * BALL_RADIUS);
    Vector start1 = addVectors(oldPosition, rayOffset);
    rayOffset.mult(new Vector(-1, -1));
    Vector start2 = addVectors(oldPosition, rayOffset);
    Line2D ray1 = lineFromVectors(start1, addVectors(start1, velocity));
    Line2D ray2 = lineFromVectors(start2, addVectors(start2, velocity));
    Line2D ray3 = lineFromVectors(addVectors(position, new Vector(BALL_RADIUS, 0)), addVectors(position, new Vector(-BALL_RADIUS, 0)));
    // Uncomment below for debugging collision detecting
    /* stroke(255, 0, 0);
    line((float)ray1.getX1(), (float)ray1.getY1(), (float)ray1.getX2(), (float)ray1.getY2());
    line((float)ray3.getX1(), (float)ray3.getY1(), (float)ray3.getX2(), (float)ray3.getY2());
    line((float)ray2.getX1(), (float)ray2.getY1(), (float)ray2.getX2(), (float)ray2.getY2());
    stroke(255); */
    if (ray1.intersectsLine(paddleLine) || ray2.intersectsLine(paddleLine) || ray3.intersectsLine(paddleLine)) {
      if (velocity.getX() < 0) {
        //position.add(new Vector((paddleLine.getX1() - (position.getX() - BALL_RADIUS)) * 2, 0));
      } else {
        //position.add(new Vector(-((position.getX() + BALL_RADIUS) - paddleLine.getX1()) * 2, 0));
      }
      return true;
    }
    
    return false;
  }
  
  public void update() {
    if (delay > 0) {
      delay--;
      if (delay % (FPS / 3) == 0) {
        ballColor = 0;
      } else if ((delay + FPS / 6) % (FPS / 3) == 0) {
        ballColor = 255;
      }
      return;
    }
    ballColor = 255;
    position.add(velocity);
    Vector invertVertical = new Vector(1, -1);
    if (position.getY() < BALL_RADIUS) {
      position.setY(BALL_RADIUS);
      velocity.mult(invertVertical);
    } else if (position.getY() > height - BALL_RADIUS) {
      position.setY(height - BALL_RADIUS);
      velocity.mult(invertVertical);
    }
  }
  public void render() {
    push();
    fill(ballColor);
    circle((float)position.getX(), (float)position.getY(), (float)BALL_RADIUS * 2);
    pop();
  }
}

private class Paddle {
  public static final int WIDTH = 15;
  public static final int MARGIN = 100;
  public static final int BASE_SPEED = 480 / FPS;
  private static final double SPEED_DIFFICULTY_STEP = 0.25;
  private static final double SPEED_DIFFICULTY_MAX = 10;
  private static final double SPEED_DIFFICULTY_MIN = 0.5;
  private double speedMult = 1;
  private int paddleHeight;
  private double top;
  private Side side;
  
  public Paddle(int paddleHeight, double top, Side side) {
    this.paddleHeight = paddleHeight;
    this.top = top;
    this.side = side;
  }
  
  public void setSpeed(double speed) {
    speedMult = speed;
  }
  
  public void increaseDifficulty(double mult) {
    speedMult = clamp(speedMult - mult * SPEED_DIFFICULTY_STEP,  SPEED_DIFFICULTY_MIN, SPEED_DIFFICULTY_MAX);
    println("increase, " + speedMult);
  }
  public void decreaseDifficulty(double mult) {
    speedMult = clamp(speedMult + mult * SPEED_DIFFICULTY_STEP,  SPEED_DIFFICULTY_MIN, SPEED_DIFFICULTY_MAX);
    println("decrease, " + speedMult);
  }
  
  public Side getSide() {
    return side;
  }
  
  public Line2D getCollisionLine() {
    double xPosition = getPosition().getX() + (side == Side.LEFT ? WIDTH : 0);
    return new Line2D.Double(xPosition, top, xPosition, top + paddleHeight);
  }
  
  public int getHeight() {
    return paddleHeight;
  }
  public Vector getPosition() {
    return new Vector((side == Side.LEFT ? MARGIN : width - MARGIN - WIDTH), top);
  }
  
  public Vector getCenter() {
    return new Vector(getPosition().getX() + WIDTH / 2, getPosition().getY() + paddleHeight / 2);
  }
  
  public void render() {
    Vector position = getPosition();
    rect((float)position.getX(), (float)position.getY(), WIDTH, paddleHeight);
  }
  public void moveUp() {
    top -= BASE_SPEED * speedMult;
    if (top < 0) {
      top = 0;
    }
  }
  public void moveDown() {
    top += BASE_SPEED * speedMult;
    if (top + paddleHeight > height) {
      top = height - paddleHeight;
    }
  }
}
