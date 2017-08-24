import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress sc;

int x,y;


void setup(){
  size(500,500);
  
  osc = new OscP5(this,12321);
  sc = new NetAddress("127.0.0.1", 57120);
  
  x = int(width/2);
  y = int(height/2);
}


void draw(){
  background(0);
  
  //Send x/y to SC
  float normx = norm(x, 0,width);
  float normy = norm(y, 0, height);
  osc.send("/xy", new Object[]{normx,normy}, sc);
  
  //pointer
  noStroke();
  fill(153,255,0);
  ellipseMode(CENTER);
  ellipse(x,y,15,15);
  
  //guidelines

  
}

void mouseDragged(){
  x = mouseX;
  y = mouseY;
}

void mousePressed(){
  x = mouseX;
  y = mouseY;
}