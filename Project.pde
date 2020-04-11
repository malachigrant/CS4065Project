import static javax.swing.JOptionPane.*;
static final int FPS = 120;
static final double DIFFICULTY_FACTOR = 1.3;
static final int WIN_SCORE = 6;

Controller p1,p2;
Ball ball;
PFont font;
ScoreListener scoreListener;
Button button;
Screen menuScreen = new Screen();
Screen surveyScreen = new Screen();
Screen currentScreen = menuScreen;
String difficulty = "";
String userId;
PrintWriter output;

void writeData(PrintWriter out, String in) {
  if (out != null) {
    out.println(in);
  }
}

void setup() {
  userId = showInputDialog("Enter user ID:");
  if (userId != null && !userId.isEmpty()) {
    output = createWriter("ExperimentalData/user_" + userId + "_scoring.txt");
  }
  writeData(output, "UserID, Difficulty, PlayerScore, AIScore");
  fullScreen();
  frameRate(FPS);
  font = createFont("times.ttf", 32);
  textFont(font);
  textAlign(CENTER, CENTER);
  
  fill(255);
  
  scoreListener = new ScoreListener() {
    public void onScore(Side side) {
      int score1 = p1.getScore();
      int score2 = p2.getScore();
      boolean isDynamic = difficulty.equals("dynamic");
      if (side == Side.RIGHT) {
        //p1.increaseDifficulty();
        if (isDynamic) {
          p2.decreaseDifficulty(Math.pow(DIFFICULTY_FACTOR, score1 - score2));
          ball.increaseDifficulty();
        }
        score1++;
      } else {
        //p1.decreaseDifficulty();
        if (isDynamic) {
          p2.increaseDifficulty(Math.pow(DIFFICULTY_FACTOR, score2 - score1));
          ball.decreaseDifficulty();
        }
        score2++;
      }
      writeData(output, userId + ", " + difficulty + ", " + score1 + ", " + score2);
      if (score1 > WIN_SCORE - 1 || score2 > WIN_SCORE - 1) {
        currentScreen = surveyScreen;
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
  ball.setListener(scoreListener);
  
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
        p2.setPaddleSpeed(1.0);
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
  menuScreen.addElement(btnEasy);
  menuScreen.addElement(btnMedium);
  menuScreen.addElement(btnHard);
  menuScreen.addElement(btnDynamic);
  menuScreen.addElement(new Label("lblDifficulty", width / 2, height / 4, "Choose a difficulty"));

  final SingleChoiceQuestion surveyQ1 = new SingleChoiceQuestion("surveyQ1", width / 2, height / 2 - 50, "Fun?");
  Button submitSurvey = new Button("btnSubmit", width / 4, 100, 3 * width / 8, 3 * height / 4, "Submit");
  submitSurvey.setClickListener(new ClickListener() {
    public void onClick(String id) {
      writeData(output, userId + ", " + difficulty + ", x, x, " + surveyQ1.getAnswer());
      if (output != null) {
        output.flush();
        output.close();
      }
      exit();
    }
  });
  surveyScreen.addElement(surveyQ1);
  surveyScreen.addElement(submitSurvey);
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
