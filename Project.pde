static final int FPS = 120;

Controller p1,p2;
Ball ball;
PFont font;
ScoreListener scoreListener;
Button button;
Screen menu = new Screen();
Screen currentScreen = menu;
String difficulty = "";
void setup() {
  fullScreen();
  frameRate(FPS);
  font = createFont("times.ttf", 32);
  textFont(font);
  textAlign(CENTER, CENTER);
  
  fill(255);
  
  scoreListener = new ScoreListener() {
    public void onScore(Side side) {
      if (side == Side.RIGHT) {
        //p1.increaseDifficulty();
        p2.decreaseDifficulty(Math.pow(1.1, p1.getScore() - p2.getScore()));
        ball.increaseDifficulty();
      } else {
        //p1.decreaseDifficulty();
        p2.increaseDifficulty(Math.pow(1.1, p2.getScore() - p1.getScore()));
        ball.decreaseDifficulty();
      }
    }
  };
  button = new Button("btnDebug", 200, 75, 150, 150, "Hello");
  button.setClickListener(new ClickListener() {
    public void onClick(String id) {
      scoreListener.onScore(Side.RIGHT);
    }
  });
  
  ball = new Ball();
  p1 = new Player(Side.LEFT, ball);
  p2 = new AI(Side.RIGHT, ball);
  
  // create menu screen
  int buttonWidth = width / 4 - 50;
  int buttonHeight = 100;
  Button btnEasy = new Button("easy", buttonWidth, buttonHeight, 25, height / 2 - buttonHeight / 2, "Easy");
  Button btnMedium = new Button("medium", buttonWidth, buttonHeight, buttonWidth + 75, height / 2 - buttonHeight / 2, "Medium");
  Button btnHard = new Button("hard", buttonWidth, buttonHeight, 2 * buttonWidth + 125, height / 2 - buttonHeight / 2, "Hard");
  Button btnDynamic = new Button("dynamic", buttonWidth, buttonHeight, 3 * buttonWidth + 175, height / 2 - buttonHeight / 2, "Dynamic");
  ClickListener listener = new ClickListener() {
    public void onClick(String id) {
      difficulty = id;
      if (difficulty.equals("dynamic")) {
        ball.setListener(scoreListener);
      } else if (difficulty.equals("hard")) {
        p2.setPaddleSpeed(1.5);
      } else if (difficulty.equals("medium")) {
        p2.setPaddleSpeed(1.2);
      } else {
        p2.setPaddleSpeed(0.9);
      }
      currentScreen = null;
    }
  };
  btnEasy.setClickListener(listener);
  btnMedium.setClickListener(listener);
  btnHard.setClickListener(listener);
  btnDynamic.setClickListener(listener);
  menu.addElement(btnEasy);
  menu.addElement(btnMedium);
  menu.addElement(btnHard);
  menu.addElement(btnDynamic);
  menu.addElement(new Label(width / 2, height / 4, "Choose a difficulty"));
}

void draw() {
  if (currentScreen != null) {
    currentScreen.render();
  } else {
    ball.update();
    p1.update();
    p2.update();
    //button.update();
    
    background(0);
    
    //button.render();
    ball.render();
    p1.render();
    p2.render();
  }
}
