import controlP5.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress pilot, gunner;

 ArrayList<Bullet> bullets = new ArrayList<Bullet>();

PImage img;
int lives = 3;
int shoot, AmmoUsed;
float deg, rad;
float ang = random(2* PI);
float Rotation, AmmoType;
int CheckGun, CheckPilot;
int points;

asteroid ast0;

ControlP5 controlP5;

Slider s1, s2;
Button b1, b2;


//---------------------------------------------------------------------------------

void setup() {
  size (800, 800);
  
 

  //OSC Routing
  oscP5 = new OscP5(this, 12002);
  pilot = new NetAddress("10.3.23.12", 12001);
  gunner = new NetAddress("localhost", 12000);

  //turret load
  deg = 0;
  img = loadImage("turret upperview 2.png");

  //asteroids
  ast0=new asteroid(radians(ang));


  controlP5 = new ControlP5(this);
  // Parameters: Name,Min,Max,DefaultValue,X,Y,Width,Height
  s1 = controlP5.addSlider("Rotation", 0, 360, 0, 50, 780, 150, 10);
  s2 = controlP5.addSlider("AmmoType")
                .setPosition(600,780)
                .setSize(150,10)
                .setRange(1, 12)
                .setNumberOfTickMarks(12)
                ;
  b1 = controlP5.addButton("SendRotation")
                .setValue(0)
                .setPosition(50,760)
                .setSize(150,10)
                ;
  b2 = controlP5.addButton("SendAmmoType")
                .setValue(0)
                .setPosition(600,760)
                .setSize(150,10)
                ;
  

  
} //setup()

//----------------------------------------------------------------------------------------

void draw() {
  background(20);
  
  //bullets
  if (shoot == 1 && frameCount % 15 ==0 ) {
    bullets.add(new Bullet(deg));
  }
  for(int i = 0; i < bullets.size(); i++){
    Bullet bullet = bullets.get(i);
    bullet.display();
    bullet.update();
    if (!bullet.inScreen()) {
     bullets.remove(i); 
     i--;
    }
  }
  
  //CheckWarnings
  if(CheckPilot == 1) {
    fill(255,140,0);
  } else {
    fill(20);
    }
  stroke(255);
  rect(50, 720, 30, 30);
  fill(20);
  text("!", 63, 740);
  
  if(CheckGun == 1) {
    fill(255,140,0);
  } else {
    fill(20);
    }
  stroke(255);
  rect(720, 720, 30, 30);
  fill(20);
  text("!", 733, 740);

  //radar visuals
  stroke(50, 205, 50);
  fill(152, 251, 152);
  ellipse(width/2, height/2, width, height);
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
  noFill();
  ellipse(width/2, height/2, width/4, height/4);
  ellipse(width/2, height/2, width/2, height/2);
  ellipse(width/2, height/2, width*3/4, height*3/4);

  //rode richtlijn
  pushMatrix();
    translate(width/2, height/2);
    rotate(radians(Rotation));
    stroke(255,0,0);
    line(0, 0, 0, -400);
  popMatrix();

  //turret visuals
  pushMatrix();
    translate (width/2, height/2);
    rotate(radians(deg));
      strokeWeight(2);
      stroke(40, 180, 40);
        line (0, 0, -0.5*sqrt(2) *width/2, -0.5*sqrt(2)*height/2);
        line (0, 0, 0.5*sqrt(2) *width/2, -0.5*sqrt(2)*height/2);
        image (img, -8, -26.5, img.width/4, img.height/4);
  popMatrix();

  //asteroid creation
  pushMatrix();
    translate(width/2, height/2);
      ast0.draw();
      if (ast0.alive==false) {
        ast0.init(random(2*PI));
      }
  popMatrix();
  
  image(img, 30, 20, img.width/3, img.height/3);
  fill(255);
  text(lives+"x", 70, 50);
  text("Score: "+ points, 680, 50);
  
  if(lives <0) {
   GameOver(); 
  }
  

} //draw()


//----------------------------------------------------------------------
public void SendRotation() {
  OscMessage soundForward = new OscMessage("/sound");
  soundForward.add(Rotation);
  oscP5.send(soundForward, pilot); 
}
//----------------------------------------------------------------------

public void SendAmmoType() {
  OscMessage soundForward = new OscMessage("/sound");
  soundForward.add(AmmoType);
  oscP5.send(soundForward, gunner); 
}
//----------------------------------------------------------------------

void GameOver(){
 background(0);
 fill(255);
 textSize(38);
 text("Game Over",width/2 - 100,height/2);
 text("Score: " +points,width/2 - 80,height/2 + 50);
 noLoop();
 print(lives);
}

//----------------------------------------------------------------------
void oscEvent(OscMessage theOscMessage) {

  //Receiving message
  String msgType =  theOscMessage.addrPattern();
  
  if (msgType.equals("/deg")) {
    float degValue = theOscMessage.get(0).floatValue();   
    deg = degValue;
  }
  if (msgType.equals("/shoot")) {
    int shootValue = theOscMessage.get(0).intValue(); 
    shoot = shootValue;
  }
  if (msgType.equals("/Ammo")) {
    int AmmoValue = theOscMessage.get(0).intValue(); 
    AmmoUsed = AmmoValue;
    print(AmmoUsed);
  }
  if (msgType.equals("/CheckGun")) {
    int CheckValue = theOscMessage.get(0).intValue();   
    CheckGun = CheckValue;
  }
  if (msgType.equals("/CheckPilot")) {
    int CheckValue = theOscMessage.get(0).intValue();   
    CheckPilot = CheckValue;
  }

  //Forwarding
  OscMessage degForward = new OscMessage("/deg");
  degForward.add(deg);
  oscP5.send(degForward, gunner); 

  OscMessage shootForward = new OscMessage("/shoot");
  shootForward.add(shoot);
  oscP5.send(shootForward, pilot);
} // oscEvent()