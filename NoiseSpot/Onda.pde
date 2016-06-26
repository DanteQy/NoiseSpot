class formaOnda {
  float x, y, z;
  float raggio;

  color col = color(255, 252, 127);
  PVector[] punti = new PVector[fftLog.avgSize()];
  //creo una versione per il suono corretto ed una per quella rumorosa
  PVector[] traccia = new PVector[0];
  PVector[] traccia_r = new PVector[0];  

  formaOnda(float entrata_x, float entrata_y, float entrata_z, float entrata_raggio) {
    x = entrata_x;
    y = entrata_y;
    z = entrata_z;
    raggio = entrata_raggio;
  }

  void update() {
    plot();
  }

  void plot() {
    for (int i = 0; i < fftLog.avgSize(); i++) {
      int w = int(width/fftLog.avgSize());

      x = i*w;
      y = frameCount*5;
      z = height/4-fftLog.getAvg(i)*6.5;

      stroke(1);
      point(x, y, z);
      punti[i] = new PVector(x, y, z);
      //aggiunge una posizione finale all'array ognivolta
      traccia = (PVector[]) expand(traccia, traccia.length+1);
      traccia_r = (PVector[]) expand(traccia_r, traccia_r.length+1);
      //assegna alla posizione precedente i valori ottenuti dai punti
      traccia[traccia.length-1] = new PVector(punti[i].x, punti[i].y, punti[i].z);
      traccia_r[traccia_r.length-1] = new PVector(punti[i].x+random(-10, 10), punti[i].y+random(-10, 10), punti[i].z+random(-10, 10));
    }
  }
  boolean rumore  = false;
  boolean rumore() {
    if (rumore == false) {
      rumore = true;
    } else {
      rumore = false;
    }
    return rumore;
  }
  void setColore(color c) {
    col = c;
  }
  color getColore() {
    return col;
  }
  void disegnaTraccia() {

    int freq = 2;
    int inc = fftLog.avgSize();
    stroke(col);
    noFill();

    for (int i=0; i<traccia.length; i+=inc*freq) {
      smooth();
      beginShape();

      for (int j=0; j<inc; j+=freq) {
        if (rumore) {
          curveVertex(traccia_r[i+j].x, traccia_r[i+j].y, traccia_r[i+j].z);
        } else {
          curveVertex(traccia[i+j].x, traccia[i+j].y, traccia[i+j].z);
        }
      }
      endShape();
    }
  }
}