class Lorenz {
  float x = 0.1;
  float y = 0.1;
  float z = 0.1;

  float a = 8.5;
  float b = 24.5;
  float c = 11.0/3.0;

  int count = 0;
  float hu = 200;
  PVector[] pos = new PVector[3000];

  Lorenz() {
    for (int i = 0; i< pos.length; i++) {
      float dt = 0.01;
      float dx = (a*(y-x))*dt;
      float dy = (x*(b-z)-y)*dt;
      float dz = (x*y - c*z)*dt;

      x = x+dx;
      y = y+dy;
      z = z+dz;
      //println(x, y); 

      pos[i] = new PVector(x, y);

      pos[i].x = x;
      pos[i].y = y;


      hu+=0.01;
      println(i, x, y);
    }
  }

  void display() {
    translate(width/2, height/2);
    scale(1);
    noFill();
    rotate(-3);
    beginShape();
    strokeWeight(1);

    for (int i = 0; i<pos.length; i++) {
      smooth();
      stroke(200);
      vertex((float)pos[i].x*7f, (float)pos[i].y*7f);
      hu+=1;
    }
    endShape();
  }
}