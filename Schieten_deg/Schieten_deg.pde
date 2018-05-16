import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

OscP5 oscP5;
NetAddress commander;

Minim minim; //create new variable of type Minim.
AudioOutput out; // create new variable of type AudioOutput.

Oscil Sine;
float freq;
float ownfreq;
int Ammo = 1;
int Check;

ArrayList<Sound> Notes = new ArrayList<Sound>();

PImage imgL, imgR, imgC, imgLA, imgRA;
boolean left, right;
boolean shoot;
Star[] stars = new Star [1500];
float deg;

void setup() {
  size (1280, 720);
  
  oscP5 = new OscP5(this,12000);
  commander = new NetAddress("localhost",12002);

  imgL = loadImage("Halo turret L.png");
  imgR = loadImage("Halo turret R.png");
  imgLA = loadImage("Halo turret L alt.png");
  imgRA = loadImage("Halo turret R alt.png");
  imgC = loadImage("Cockpit 3 transparent.png");


  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star ();
  }
  
   minim = new Minim(this); //create new Minim object -> save it in variabele minim
  out = minim.getLineOut(Minim.STEREO, 512); //set the output: (Stereo or mono, buffersize)
} //setup()

//--------------------------------------------------------------------------------------------------

void draw () {
  background (20);

  rotation();
  
  if(shoot) {
  shoot();
  }
  
   OscMessage myMessage = new OscMessage("/shoot");
  myMessage.add(shoot?1:0);
    oscP5.send(myMessage, commander); 

  //turret visuals
  image(imgLA, -110, height*3/5);        //turret links
  image(imgRA, width -300, height*3/5);  //turret rechts

  fill (0);
  rect(0, height-10, width, height);
  noStroke();

  PFont font;

  fill (255, 135, 0);
  rect(width/2  +180, 580, 300, 137);   //warning screen rechts
  fill (0);
  font = createFont ("Impact", 72);
  textFont (font, 72);
  text ("Fire", width/2 +275, 690);

  fill (255, 140, 0);
  rect (width/2 -500, 580, 300, 137);   // warning screen links
  fill (0);
  textFont (font, 42);
  text ("Reload", width/2 - 375, 690);

  image(imgC, 0, 0);                    //cockpit

//sound
Ammo = constrain(Ammo, 1, 12);
  ownfreq = 110 * Ammo;
  
  for (int i=0;i<Notes.size();i++) { //loop through all notes in the arraylist
     Sound oneNote = Notes.get(i); // make a temporary object for the current object in the loop
     if (oneNote.ending()) { //check if the envelope-line is running or stopped
       oneNote.clearPatch(); //if it's stopped, call the clearPatch-function in the object
       Notes.remove(i); //remove the object from the arraylist.
     }
   }
  
 
} //draw()

void sound() {
 Sine = new Oscil(freq/2, 0.2, Waves.SINE); 
}

void rotation() {
  for (int i = 0; i<stars.length; i++) {
    stars[i].update();
    stars[i].show();

    if (stars[i].xStar < 0) {
      stars[i].xStar = stars[i].xStar + 5120;
    }
    if (stars[i].xStar > 5120) {
      stars[i].xStar = stars[i].xStar -5120;
    }
  }
  
} //rotation()

void shoot() {

    stroke(255, 0, 0);
    strokeWeight (5);
    line (160, 500, width/2 - 3, 290); //laser links
    line (width - 160, 500, width/2 + 7, 290);  //laser rechts
    
  OscMessage myMessage = new OscMessage("/Ammo");
  myMessage.add(Ammo);
    oscP5.send(myMessage, commander); 
}

void Check() {
  OscMessage myMessage = new OscMessage("/CheckGun");
  myMessage.add(Check);
    oscP5.send(myMessage, commander); 
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    shoot = true;
  }
  if (key == 'd' || key =='D') {
  Notes.add(new Sound(ownfreq));
 }
 if (key == 'q' || key == 'Q') {
    Ammo += 1;
  }
  if (key == 'a' || key == 'a') {
    Ammo -= 1;
  }
  if (key == 'w' || key == 'W') {
    Check = 1;
    Check();
  }
}

void keyReleased() {
  if (key == 's' || key == 'S') {
    shoot = false;
  }
  if (key == 'w' || key == 'W') {
    Check = 0;
    Check();
  }
} 

void oscEvent(OscMessage theOscMessage){
 String msgType =  theOscMessage.addrPattern();

  if(msgType.equals("/deg")){
      float msgValue = theOscMessage.get(0).floatValue();
    deg=msgValue; 
  }
  
  if(msgType.equals("/sound")){
    float msgValue = theOscMessage.get(0).floatValue();
    freq = msgValue*110; 
    Notes.add(new Sound(freq));
    println(freq);
  }
}