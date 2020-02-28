private class Vector {
  private float x, y;
  public Vector(float x, float y) {
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
  
  public void setX(float x) {
    this.x = x;
  }
  public void setY(float y) {
    this.y = y;
  }
  
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
}
private class Ball {
  
  private static final float INITIAL_X_SPEED = 4;
  private static final float INITIAL_Y_SPEED = 4;
  private static final float BALL_RADIUS = 25;
  private Vector position;
  private Vector velocity;
  
  public Ball(Side side) {
    init(side);
  }
  public void init(Side side) {
    position = new Vector(width / 2, height / 2);
    float xDirection = (side == Side.LEFT ? -1 : 1);
    velocity = new Vector(INITIAL_X_SPEED * xDirection, INITIAL_Y_SPEED);
  }
  
  public Vector getPosition() {
    return position;
  }
  
  public void switchXDirection() {
    velocity.mult(new Vector(-1, 1));
  }
  
  public boolean detectCollision(Paddle paddle) {
    Vector paddlePosition = paddle.getPosition();
    float edgeX = position.getX();
    float edgeY = position.getY();
    if (position.getX() < paddlePosition.getX()) {
      edgeX = paddlePosition.getX();
    } else if (position.getX() > paddlePosition.getX() + Paddle.WIDTH) {
      edgeX = paddlePosition.getX() + Paddle.WIDTH;
    }
    if (position.getY() < paddlePosition.getY()) {
      edgeY = paddlePosition.getY();
    } else if (position.getY() > paddlePosition.getY() + paddle.getHeight()) {
      edgeY = paddlePosition.getY() + paddle.getHeight();
    }
    float distance = sqrt(pow(edgeX - position.getX(), 2) + pow(edgeY - position.getY(), 2));
    
    return distance < BALL_RADIUS;
  }
  
  public void update() {
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
    circle(position.getX(), position.getY(), BALL_RADIUS * 2);
  }
}

private class Paddle {
  static final int WIDTH = 15;
  static final int MARGIN = 50;
  static final int BASE_SPEED = 4;
  private int paddleHeight;
  private int top;
  private Side side;
  
  public Paddle(int paddleHeight, int top, Side side) {
    this.paddleHeight = paddleHeight;
    this.top = top;
    this.side = side;
  }
  
  public int getHeight() {
    return paddleHeight;
  }
  public Vector getPosition() {
    return new Vector((side == Side.LEFT ? MARGIN : width - MARGIN - WIDTH), top);
  }
  
  public void render() {
    Vector position = getPosition();
    rect(position.getX(), position.getY(), WIDTH, paddleHeight);
  }
  public void moveUp() {
    top -= BASE_SPEED;
  }
  public void moveDown() {
    top += BASE_SPEED;
  }
}
