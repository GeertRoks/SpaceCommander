import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

OscP5 oscP5;
NetAddress Commander;

Minim minim; //create new variable of type Minim.
AudioOutput out; // create new variable of type AudioOutput.
Oscil Sine;
float freq;
float ownfreq;
int CheckPilot;

ArrayList<Sound> Notes = new ArrayList<Sound>();

PImage img;
boolean left, right, shoot;
float deg;
float arot, vrot;

void setup() {
  size (400, 400);
  
  oscP5 = new OscP5(this,12001);
  Commander = new NetAddress("10.3.20.21",12002);
  
  deg = 0;
  img = loadImage("turret upperview 2.png");
  
  minim = new Minim(this); //create new Minim object -> save it in variabele minim
  out = minim.getLineOut(Minim.STEREO, 512); //set the output: (Stereo or mono, buffersize)
}

void draw() {
  background(20);

  //turret visuals
  pushMatrix();
  translate (width/2, height/2);
  rotate(radians((float)deg));
  if (shoot && frameCount % 10 == 0) {
  stroke (255,0,0);
  } else {
   stroke(20); 
  }
  strokeWeight(7);
  line (20, 0, 20, -height);
  line (-18, 0, -18, -height);
  image (img, - 51, - 160);
  popMatrix();
  
  rotation();
  deg();
  
  //sound
  ownfreq = 80 + deg*4;
  
  for (int i=0;i<Notes.size();i++) {
     Sound oneNote = Notes.get(i); 
     if (oneNote.ending()) { 
       oneNote.clearPatch(); 
       Notes.remove(i); 
     }
   }
  
  //uitleg
   fill(255);
  text("Press W for direction from Commander, Press S to hear current rotation.", 10, 390);
  
} //draw()

void sound() {
 Sine = new Oscil(freq/2, 0.2, Waves.SINE); 
}

void rotation() {
  if (left) {
    if (vrot < 0 || vrot == 0) {
          if (vrot > -0.75){
            arot = - 0.002;
          } else {
            arot = 0;
          }
    }
    if (vrot > 0) {
     arot = -0.01; 
    }
  }
  
    if (right) {
      if (vrot > 0 || vrot == 0) {
            if (vrot < 0.75) {
              arot = 0.002;
            } else {
             arot = 0; 
            }
      }
      if (vrot < 0) {
         arot = 0.01; 
      }
    }
  
      if (left == right) {
        if (vrot != 0) {
          if (vrot < 0) {
            arot =  0.008;
          }
          if (vrot > 0) {
            arot = -0.008;
          }
        }
        if (vrot > -0.01 && vrot <0.01) {
         arot = 0;
         vrot = 0;
        }
      }  
    
    
          vrot = vrot + arot;
          deg = deg + vrot;
          
          if (deg > 360) {
            deg = deg - 360;
          }
          if (deg < 0) {
           deg = deg +360; 
          }
    
} //rotation()

void CheckPilot() {
  OscMessage myMessage = new OscMessage("/CheckPilot");
    myMessage.add(CheckPilot);
    oscP5.send(myMessage, Commander); 
}

void deg(){
    OscMessage myMessage = new OscMessage("/deg");
    myMessage.add(deg); // add a number
    oscP5.send(myMessage, Commander); 
}

void keyPressed() {
 if (key == 'a' || key == 'A') {
   left = true;
  }
 if (key == 'd' || key =='D') {
  right = true; 
 }
 if (key == 's' || key =='S') {
  Notes.add(new Sound(ownfreq));
 }
 if (key == 'w' || key =='W') {
  CheckPilot = 1; 
  CheckPilot();
 }
}

void keyReleased() {
  if (key == 'a' || key == 'A') {
   left = false;
  }
 if (key == 'd' || key =='D') {
  right = false; 
 }
 if (key == 'w' || key =='W') {
  CheckPilot = 0;
  CheckPilot();
 }
}

void oscEvent(OscMessage theOscMessage) {
  String msgType =  theOscMessage.addrPattern();
  
  if(msgType.equals("/shoot")){
    int msgValue = theOscMessage.get(0).intValue();
    shoot=(msgValue==0?false:true); 
  }
  
  if(msgType.equals("/sound")){
    float msgValue = theOscMessage.get(0).floatValue();
    freq = 80 + msgValue*4; 
    Notes.add(new Sound(freq));
  }
  
  if(msgType.equals("/WebCam")){
    int msgValueLeft = theOscMessage.get(0).intValue();
    right=(msgValueLeft==0?false:true); 
    int msgValueRight = theOscMessage.get(1).intValue();
    left = (msgValueRight==0?false:true); 
}
}