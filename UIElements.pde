interface UIElement {
 public void render();
 public void update();
}
interface ClickListener {
  public void onClick();
}
class Button implements UIElement {
 private int sizeX;
 private int sizeY;
 private int positionX;
 private int positionY;
 private String text;
 private ClickListener listener;
 
 private boolean _prevMousePressed = false;
 
 public Button(int sx, int sy, int px, int py, String text) {
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
   fill(255);
   rect(positionX, positionY, sizeX, sizeY);
   fill(0);
   text(this.text, positionX + (sizeX / 2), positionY + (sizeY / 2));
   pop();
 }
 public void update() {
   if (!_prevMousePressed && mousePressed && mouseX > positionX && mouseX < positionX + sizeX
       && mouseY > positionY && mouseY < positionY + sizeY) {
     listener.onClick();
   }
   _prevMousePressed = mousePressed;
 }
}
