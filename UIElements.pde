import java.util.*;

abstract class UIElement {
 private String id;
 public String getId() {
   return id;
 }
 public UIElement(String id) {
   this.id = id;
 }
 abstract void render();
 abstract void update();
}
interface ClickListener {
  public void onClick(String id);
}
class Label extends UIElement {
  private int positionX;
  private int positionY;
  private String text;
  int size;
  
  public Label(String id, int px, int py, String text, int size) {
    super(id);
    positionX = px;
    positionY = py;
    this.text = text;
    this.size = size;
  }
  public Label(String id, int px, int py, String text) {
    this(id, px, py, text, 32);
  }
  
  public void render() {
    push();
    fill(0);
    textSize(size);
    text(this.text, positionX, positionY);
    pop();
  }
  public void update() {
    // no updates necessary
  }
}
class Button extends UIElement {
 private int sizeX;
 private int sizeY;
 private int positionX;
 private int positionY;
 private String text;
 private ClickListener listener;
 
 private boolean _prevMousePressed = false;
 
 public Button(String id, int sx, int sy, int px, int py, String text) {
   super(id);
   sizeX = sx;
   sizeY = sy;
   positionX = px;
   positionY = py;
   this.text = text;
 }
 public void setClickListener(ClickListener listener) {
   this.listener = listener;
 }
 
 public void render() {
   push();
   textSize(32);
   fill(isMouseOver() ? 210 : 255);
   rect(positionX, positionY, sizeX, sizeY);
   fill(0);
   text(this.text, positionX + (sizeX / 2), positionY + (sizeY / 2));
   pop();
 }
 private boolean isMouseOver() {
   return mouseX > positionX && mouseX < positionX + sizeX
       && mouseY > positionY && mouseY < positionY + sizeY;
 }
 public void update() {
   if (listener != null && !_prevMousePressed && mousePressed && isMouseOver()) {
     listener.onClick(getId());
   }
   _prevMousePressed = mousePressed;
 }
}

class Circle extends UIElement {
  int radius;
  int positionX;
  int positionY;
  boolean filled = false;
  boolean _prevMousePressed = false;
  ClickListener listener;
  
  public Circle(String id, int px, int py, int radius) {
    super(id);
    positionX = px;
    positionY = py;
    this.radius = radius;
  }
  
  public void setFilled(boolean filled) {
    this.filled = filled;
  }
  public boolean getFilled() {
    return filled;
  }
  
  public void setClickListener(ClickListener listener) {
    this.listener = listener;
  }
  
  public void render() {
    push();
    fill(255);
    circle(positionX, positionY, radius * 2);
    if (filled) {
      fill(0);
      circle(positionX, positionY, radius * 1.3);
    }
    pop();
  }
  
  boolean isMouseOver() {
    return Math.sqrt(Math.pow(mouseX - positionX, 2) + Math.pow(mouseY - positionY, 2)) < radius;
  }
  
  public void update() {
    if (listener != null && !_prevMousePressed && mousePressed && isMouseOver()) {
     listener.onClick(getId());
   }
   
    _prevMousePressed = mousePressed;
  }
}

class SingleChoiceQuestion extends UIElement {
  Label label1;
  Label label2;
  Label label3;
  Label label4;
  Circle[] circles;
  public SingleChoiceQuestion(String id, int px, int py, String text) {
    super(id);
    label1 = new Label("lbl" + id, px, py, text);
    label2 = new Label("lblDisagree" + id, px - 100, py + 80, "Disagree", 16);
    label3 = new Label("lblNeutral" + id, px, py + 80, "Neutral", 16);
    label4 = new Label("lblAgree" + id, px + 105, py + 80, "Agree", 16);
    circles = new Circle[5];
    ClickListener listener = new ClickListener() {
        void onClick(String id) {
          for (Circle circle : circles) {
            if (circle.getId().equals(id)) {
              circle.setFilled(true);
            } else {
              circle.setFilled(false);
            }
          }
        }
    };
    for (int i = -2; i < 3; i++) {
      circles[i + 2] = new Circle("circle(" + i + ")" + id, px + 50 * i, py + 50, 20);
      circles[i + 2].setClickListener(listener);
    }
  }
  
  int getAnswer() {
    for (int i = 0; i < 5; i++) {
      if (circles[i].getFilled()) {
        return i;
      }
    }
    return -1;
  }
  
  void render() {
    label1.render();
    label2.render();
    label3.render();
    label4.render();
    for (Circle circle : circles) {
      circle.render();
    }
  }
  void update() {
    for (Circle circle : circles) {
      circle.update();
    }
  }
}

class Screen {
  private Map<String, UIElement> elements;
  
  public Screen() {
    elements = new HashMap();
  }
  
  public void addElement(UIElement element) {
    elements.put(element.getId(), element);
  }
  
  public UIElement getElementById(String id) {
    return elements.getOrDefault(id, null);
  }
  
  public void render() {
    background(200);
    for (UIElement element : elements.values()) {
      element.update();
      element.render();
    }
  }
}
