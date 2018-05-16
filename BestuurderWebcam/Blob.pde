class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  boolean isNear(float x, float y) {
    float cx = max(min(x,maxx),minx);
    float cy = max(min(y,maxy),miny);

    float d = dist(cx, cy, x, y);
    if (d < dThresh) {
      return true;
    } else {
      return false;
    }
  }
  
  void add (float x, float y) {
    minx = min(minx,x);
    miny = min(miny,y);
    maxx = max(maxx,x);
    maxy = max(maxy,y);
  }
  
  void show() {
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx,miny,maxx,maxy);
  }
}