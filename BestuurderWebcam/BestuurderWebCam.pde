import processing.video.*;
import oscP5.*;
import netP5.*;

Capture video;
OscP5 oscP5;
NetAddress Pilot;

int threshold = 3; // the lower the fast it will detect rotation
int width = 640;
int height = 360;

PVector lastPosition = new PVector(0,0);
ArrayList<Integer> offsets = new ArrayList<Integer>();

color trackColor;
float thresh = 25;
float dThresh = 25;
ArrayList<Blob> blobs = new ArrayList<Blob>();

float deg;
float arot, vrot;
boolean left, right;

void setup() {
  size (640, 360);
  video = new Capture(this, 640, 360);
  video.start();
  trackColor = color(255, 0, 0);
  
  oscP5 = new OscP5(this,12003);
  Pilot = new NetAddress("localhost",12001);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);
  
  stroke(255,0,0);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);



  blobs.clear();

  for (int x=0; x<video.width; x++) {
    for (int y=0; y<video.height; y++) {
      int loc = x + y *video.width;
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = dist(r1, g1, b1, r2, g2, b2);

      if (d < thresh) {
        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }
        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }
  for (Blob b : blobs) {
    if (b.size() > 100) {
      b.show();
    }
  }
  
  if (blobs.size() > 0) {
  

PVector newPosition = new PVector(
  (blobs.get(0).maxx - blobs.get(0).minx) * 0.5 + blobs.get(0).minx,
  (blobs.get(0).maxy - blobs.get(0).miny) * 0.5 + blobs.get(0).miny);


  
  int xPosInScreen = (newPosition.x >= width * 0.5) ? 1 : -1;
  int yPosInScreen = (newPosition.y >= height * 0.5) ? 1 : -1;

  PVector deltaVector = new PVector(newPosition.x - lastPosition.x, newPosition.y - lastPosition.y);

  if (xPosInScreen == 1 && yPosInScreen == -1) {
    if (deltaVector.x > 0 && deltaVector.y > 0) {
      offsets.add(1);
    } else if (deltaVector.x < 0 && deltaVector.y < 0) {
      offsets.add(-1);
    } else {
      offsets.add(0);
    }
  } else if (xPosInScreen == 1 && yPosInScreen == 1) {
    if (deltaVector.x < 0 && deltaVector.y > 0) {
      offsets.add(1);
    } else if (deltaVector.x > 0 && deltaVector.y < 0) {
      offsets.add(-1);
    } else {
      offsets.add(0);
    }
  } else if (xPosInScreen == -1 && yPosInScreen == 1) {
    if (deltaVector.x < 0 && deltaVector.y < 0) {
      offsets.add(1);
    } else if (deltaVector.x > 0 && deltaVector.y > 0) {
      offsets.add(-1);
    } else {
      offsets.add(0);
    }
  } else if (xPosInScreen == -1 && yPosInScreen == -1) {
    if (deltaVector.x > 0 && deltaVector.y < 0) {
      offsets.add(1);
    } else if (deltaVector.x < 0 && deltaVector.y > 0) {
      offsets.add(-1);
    } else {
      offsets.add(0);
    }
  }

  //PVector deltaVector = Math.sqrt(Math.pow(newPosition.x - lastPosition.x, 2) + Math.pow(newPosition.y - lastPosition.y, 2));



  int clockwise = 0;
  int counterClockwise = 0;
for (int i = 0; i < offsets.size(); i++) {
  if (offsets.get(i) == 1) {
   counterClockwise++;
  } else if (offsets.get(i) == -1) {
   clockwise++;
  }
 }

println("Clockwise: " + clockwise + " Counter clockwise: " + counterClockwise);

if (clockwise > threshold) {
  println("counter clockwise");
  right = false;
  left = true;
 } else if (counterClockwise > threshold) {
  println("clockwise");
  left = false;
  right = true;
 } else {
   left = false;
   right = false;
 }
 
 OscMessage myMessage = new OscMessage("/WebCam");
    myMessage.add(left?1:0);
    myMessage.add(right?1:0);
    oscP5.send(myMessage, Pilot); 

  lastPosition = newPosition;

  if (offsets.size() > 30) {
    offsets.remove(0); // remove first entry in list
  }
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    left = true;
  }
  if (key == 'd' || key =='D') {
    right = true;
  }
  if (key == 't') {
    dThresh++;
  } else if (key == 'y') {
    dThresh--;
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') {
    left = false;
  }
  if (key == 'd' || key =='D') {
    right = false;
  }
}

void mousePressed() {
  int loc = mouseX + mouseY * video.width;
  trackColor = video.pixels[loc];
}