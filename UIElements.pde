import java.util.*;

interface UIElement {
 public void render();
 public void update();
}
interface ClickListener {
  public void onClick(String id);
}
class Label implements UIElement {
  private int positionX;
  private int positionY;
  private String text;
  
  public Label(int px, int py, String text) {
    positionX = px;
    positionY = py;
    this.text = text;
  }
  
  public void render() {
    push();
    fill(0);
    text(this.text, positionX, positionY);
    pop();
  }
  public void update() {
    // no updates necessary
  }
}
class Button implements UIElement {
 private String id;
 private int sizeX;
 private int sizeY;
 private int positionX;
 private int positionY;
 private String text;
 private ClickListener listener;
 
 private boolean _prevMousePressed = false;
 
 public Button(String id, int sx, int sy, int px, int py, String text) {
   this.id = id;
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
     listener.onClick(id);
   }
   _prevMousePressed = mousePressed;
 }
}

class Screen {
  private List<UIElement> elements;
  
  public Screen() {
    elements = new ArrayList();
  }
  
  public void addElement(UIElement element) {
    elements.add(element);
  }
  
  public void render() {
    background(200);
    for (UIElement element : elements) {
      element.update();
      element.render();
    }
  }
}
