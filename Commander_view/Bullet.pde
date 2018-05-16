class Bullet {
  
 PVector loc; 
 float angle;
 final static float speed =  4;
 
 //starpunt vector
 // hoek
 // snelheid
 
 public Bullet(float angle) {
   loc = new PVector (405,405);
   this.angle = angle - 90;
 }
 void update() {
   loc.x += cos(radians(angle)) * speed;
   loc.y += sin(radians(angle)) * speed;
 }
 
 
 boolean inScreen(){
   //print("inScreen");
  if (loc.x > 810){
    return false;
  }
  if (loc.x < -10){
    return false;
  }
  if (loc.y > 810) {
    return false;
  }
  if (loc.y < - 10) {
  return false;
 }
 if ((dist(loc.x - 400, loc.y - 400, ast0.x, ast0.y) < ast0.ar *0.8) && ast0.type == AmmoUsed ){
   ast0.astlife -= 10;
   return false;
  }
 return true;
 }
 
 void display() {
   pushMatrix();
   translate (loc.x, loc.y);
   rotate (radians(angle - 90));
   translate (-loc.x, -loc.y);
   fill (0);
   noStroke();
   rect (loc.x, loc.y, 10, 20);
   popMatrix();
 }
}