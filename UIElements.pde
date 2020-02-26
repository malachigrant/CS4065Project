private class Paddle {
  static final int WIDTH = 15;
  static final int MARGIN = 50;
  static final int BASE_SPEED = 4;
  private int paddleHeight;
  private int top;
  
  public Paddle(int paddleHeight, int top) {
    this.paddleHeight = paddleHeight;
    this.top = top;
  }
  
  public void render(Side side) {
    rect((side == Side.LEFT ? MARGIN : width - MARGIN - WIDTH), top,WIDTH, paddleHeight);
  }
  public void moveUp() {
    top -= BASE_SPEED;
  }
  public void moveDown() {
    top += BASE_SPEED;
  }
}
