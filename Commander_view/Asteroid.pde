class asteroid {
 
  float x, y, ar;
  float vx, vy;
  boolean alive;
  float astlife;
  int type;
 
  asteroid(float ang) {
    init(ang);
  }
 
  void init(float ang){
    float vel=random(0.05, 0.3);
    x=int(cos(ang)*(width/2));
    y=int(sin(ang)*(height)/2);
    vy=-vel*sin(ang);    
    vx=-vel*cos(ang); 
    ar=int(random(30, 70));
    astlife = ar;
    type = int(random(1,12));
    alive=true;
    //println(toString());   
    //println(ang);
  }
 
  @ Override
  String toString(){
    String s="x="+x;
    s+="\ny "+y;
    s+="\nvx "+vx;
    s+="\nvy "+vy;
    s+="\n";
    return s;
  }
 
 
  void draw() {
    x+=vx;
    y+=vy;
    stroke(50,205,50);
    strokeWeight(2);
    fill (0,255,127);
    ellipse(x, y, ar, ar);
    fill(0);
    text(type, x - 2,y + 3);
    //println(x+" "+y);
 
    if (abs(x)<(ar/2) && abs(y)<(ar/2)){
      lives -= 1;
      alive=false;
      }
     if (astlife < 0) {
       points = points+ (int(ar) * 10); 
      alive = false; 
     }
  }
  
}