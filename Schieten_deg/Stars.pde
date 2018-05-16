class Star {
 double xStar, yStar, starweight, pdeg, deltadeg;
  
  Star () {
    xStar = random(5120);
    yStar = random(height);
    starweight = random(1,6);
    }
  
  void update() {
   deltadeg = deg - pdeg;
    pdeg = deg;
   xStar = xStar - deltadeg*5120/360;
  }
  
  void show () {
  stroke (255);
  strokeWeight ((float)starweight);
    point((float)xStar,(float)yStar);
  }
  
}