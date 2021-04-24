final int mainMenu = 0;                     //Defining classes deviding game from menu
final int game = 1;
final int pause = 2;

float delay = 25;           //Delay of blinking window

import processing.serial.*; //Importing serial data from Arduino 

Serial port;                //Defining serial port

int jx;                     //Defining analog controls and needed values
int jy;   
int b = 0;  
int pb = 0;
int r = 0;
String portName;
PFont f;

//Creating game grid and properties
ArrayList<Integer> x = new ArrayList<Integer>(), y = new ArrayList<Integer>();
int speedinv = 8;           //Snake speed, my laptop is slow so this might be too fast
int scl = 10;               //Grid scale
int hx = 1, hy = 1, apx = int(int(random(scl, width-scl))/scl), apy = int(int(random(scl, height-scl))/scl), dir = 1, start = 0;
int[] dx = {0, 1, 0, -1}; 
int[] dy = {-1, 0, 1, 0};

void setup() {
  portName = "COM4";        //Establishing communication with arduino
  port = new Serial(this, "COM4", 9600);

                            //Establishing text properties
  f = createFont("Arial", 32, true); 
  textFont(f, 32);

  size(400, 400);            //Defining board size and boundaries
  background(250);
  stroke(250);
  strokeWeight(3);
  for (int i = 0; i < width; i+=scl) {
    line(0+i, 0, 0+i, height);
  };
  for (int i = 0; i < height; i+=scl) {
    line(0, 0+i, width, 0+i);
  };
  x.add(1);
  y.add(1);
}

void draw() {
  if (b != pb) {              //Converting button to state change
    if (b == 0) { 
      //if(r==1) r=0;
      //else r=1;         
      r++;
      if (r>2) r=1;
    }
    pb = b;
  }

  switch(r) {                  //state change code

  case mainMenu:               //Menu code

    background(75);
    stroke(75);
    for (int i = 0; i < width; i+=scl) {
      line(0+i, 0, 0+i, height);
    };
    for (int i = 0; i < height; i+=scl) {
      line(0, 0+i, width, 0+i);
    };
    stroke(250);
    strokeWeight(14);
    line(0, 0, width, 0);
    line(width, 0, width, height);
    line(width, height, 0, height);
    line(0, height, 0, 0);

    textAlign(CENTER);            //Menu Text
    fill (250);
    text("Snake", width/2, height/3); 
    rectMode(CENTER);
    if (frameCount%(2*delay)<delay) fill(75);
    rect(width/2, height/2-12, 90, 50);
    fill(75);
    if (frameCount%(2*delay)<delay) fill(250);
    text("Start", width/2, height/2);
    scale(0.5);
    fill (250);
    if (frameCount%(2*delay)<delay) fill(75);
    text("Push to Play and Pause", width, height*7/4);  

    break;                        //Game code
  case game:

    background(75);
    stroke(75);
    for (int i = 0; i < width; i+=scl) {
      line(0+i, 0, 0+i, height);
    };
    for (int i = 0; i < height; i+=scl) {
      line(0, 0+i, width, 0+i);
    };
    stroke(250);
    strokeWeight(14);
    line(0, 0, width, 0);
    line(width, 0, width, height);
    line(width, height, 0, height);
    line(0, height, 0, 0);
    strokeWeight(1);
    for (int i = 0; i < x.size(); i++) {
      fill(255, 250, 0);
      circle(x.get(i)*scl, y.get(i)*scl, scl);
      fill(255, 0, 0);
      circle(apx*scl, apy*scl, scl);
    }

    if (frameCount%speedinv==0) {      //Direction controls and growth code
      if ((dir == 0) && (hy > 0)) {
        hy -= 1;
      };
      if ((dir == 1) && (hx<width/scl-1)) {
        hx += 1;
      };
      if ((dir == 2) && (hy<height/scl-1)) {
        hy += 1;
      };
      if ((dir == 3) && (hx > 0)) {
        hx -= 1;
      };
      x.add(0, x.get(0)+dx[dir]);
      y.add(0, y.get(0)+dy[dir]);
      for (int i=1; i<x.size(); i++) {
        if (x.get(0)==x.get(i)&&y.get(0)==y.get(i)) {
          exit();
        }
      };


      if (hx == apx && hy == apy) {    //Food placement
        port.write('1');
        apx = int(int(random(scl, width-scl))/scl);
        apy = int(int(random(scl, height-scl))/scl);
      } else {
        x.remove(x.size()-1);
        y.remove(y.size()-1);
      }

      //Death tone - Flatline
      if (hx - 1 == -1) {
        port.write('0');
        exit();
      };
      if (hy - 1 == -1) {
        port.write('0');
        exit();
      };
      if (hx - (width/scl-2) > 0) {
        port.write('0');
        exit();
      };
      if (hy - (height/scl-2) > 0) {
        port.write('0');
        exit();
      }
    }
                                //Joystick movement
    if ((jy < 510) && (dir != 2) && (hy > 0)) {
      dir = 0;
    };
    if ((jx > 506) && (dir != 3) && (hx<width/scl-1)) {
      dir = 1;
    };
    if ((jy > 516) && (dir != 0) && (hy<height/scl-1)) {
      dir = 2;
    };
    if ((jx < 500) && (dir != 1) && (hx > 0)) {
      dir = 3;
    };  


    //void keyPressed() {          //Keyboard movement
    //if ((key == 'w') && (dir != 2) && (hy > 0)) {dir = 0;};if ((key == 'd') && (dir != 3) && (hx<width/scl-1)) {dir = 1;};if ((key == 's') && (dir != 0) && (hy<height/scl-1)) {dir = 2;};if ((key == 'a') && (dir != 1) && (hx > 0)) {dir = 3;};
    //}

    break;                        //Pause Code
  case pause:

    fill(75);
    if (frameCount%(2*delay)<delay) fill(250);
    text("Pause", width/2, height/2);
  }
}
void serialEvent(Serial port)  //Communication for when there's no input
{

  String input = port.readStringUntil(10);

  if (input != null)
  {

    int[] vals = int(splitTokens(input, ","));
    jx = vals [0];
    jy = vals [1];
    b = vals [2];
  }
}
