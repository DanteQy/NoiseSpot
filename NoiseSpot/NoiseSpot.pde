import ddf.minim.analysis.*;
import ddf.minim.*;

formaOnda onda;

PImage img, cuffie;

FFT fftLin;
FFT fftLog;

Minim minim;

AudioPlayer song;
AudioPlayer rumore;

Lorenz l = new Lorenz();

PFont font, font_1, font_2;
float camzoom;
float maxX = 0;
float maxY = 0; 
float maxZ = 0;
float minX = 0;
float minY = 0;
float minZ = 0;

float r, g, b;
color c = color(255, 252, 127);

void setup() {
  size(1000, 500, P3D);
  noStroke();
  frameRate(60);
  img = loadImage("glass.png");
  cuffie = loadImage("cuffie.png");
  cuffie.resize(0,500);
  font_1 = createFont("GoodMorningAfternoon.ttf", 45, true);
  font_2 = createFont("Lato-Regular.ttf", 45, true);

  minim = new Minim(this);
  rumore = minim.loadFile("street.mp3");
  song = minim.loadFile("AriaDaCapoEFine.mp3");


  fftLog = new FFT(song.bufferSize(), song.sampleRate());
  fftLog.logAverages(22, 4);     //adjust numbers to adjust spacing

  float w = float (width/fftLog.avgSize());
  float x = w;
  float y = 0;
  float z = 0;

  float raggio = 10;  
  onda = new formaOnda(x, y, z, raggio);
}

float zoom;
PVector focus;
PVector cam;

int o = 0;
int t = 255; 
int fadeIn = 0;

void draw() {
  background(25);

  /*----------------------------------
   -------------------------------------*/

  if (frameCount< 200) {
    //size(1000, 500);
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    tint(255, 45);
    image(cuffie, width/2-cuffie.width/2, 0);
    if (frameCount >= 100) {
      song.play();
    }
    textAlign(CENTER);
    smooth();
    textFont(font_2);
    if (frameCount > 180) { 
      t = t - 255/20;
    }

    textSize(55);
    fill(255, t);
    text("Just listen", width/2, height/2);
    popMatrix();
  }

  /*----------------------------------hint(DISABLE_DEPTH_TEST)
   
   -------------------------------------*/

  if ((frameCount> 200 && frameCount < 600) || 
    ((frameCount> 875 && frameCount < 1150)) ||
    (frameCount> 1550 && frameCount < 1850)) {
    //size(1000, 500, P3D);
    hint(ENABLE_DEPTH_TEST);
    pushMatrix();

    for (int i = 0; i < fftLog.avgSize(); i++) {
      zoom = 1.5;
      focus = new PVector(onda.x-width/2, onda.y, 0);
      cam = new PVector(zoom, zoom+100, zoom);
      camera(focus.x+cam.x, focus.y+cam.y, focus.z+cam.z-height/3, focus.x, focus.y-height/5, focus.z+25, 0, 0, 1);
    }
    //riprodurre canzone
    fftLog.forward(song.mix);
    if ((frameCount > 875 && frameCount <900) ||
      (frameCount> 1550 && frameCount < 1570)) {
      r = r + red(c)/45 ;
      g = g + green(c)/45 ;
      b = b + blue(c)/45;
      onda.setColore(color(r, g, b));
    }
    if ((frameCount >570  && frameCount <600)||
      (frameCount> 1820 && frameCount < 1850)) {
      r = red(onda.getColore()) - red(onda.getColore())/20 ;
      g = green(onda.getColore())- green(onda.getColore())/20 ;
      b = blue(onda.getColore()) - blue(onda.getColore())/20 ;
      onda.setColore(color(r, g, b));
    }
    if (frameCount==598) {
      background(25);
    }

    onda.update();
    onda.disegnaTraccia();

    if (frameCount>=876 && frameCount < 1150) {
      //println(song.getGain());
      rumore.play();
      if(mousePressed) { onda.rumore();}
      float gainX = map(mouseX, 0, 1000, -40.0, 40.0);
      float gainY = map(mouseY, 0, 500, 0, 40.0);
      rumore.setGain(gainX);
      song.setGain(gainY);
      if (frameCount == 1145) {
        song.setGain(20);
        if(onda.rumore() == false) {onda.rumore();}
      }
    }
    popMatrix();
  }

  /*----------------------------------
   -------------------------------------*/

  if (frameCount> 600 && frameCount< 850) {
    tint(255, 50);
    image(cuffie, width/2-cuffie.width/2, 0);
    if (frameCount == 601) { 
      t = 255;
    }
    //size(1000, 500);
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    textAlign(CENTER);
    smooth();
    textFont(font_2);
    if (frameCount > 830) { 
      t = t - 255/20;
    }
    textSize(12);
    text("Move the mouse to find the correct position where there'isnt noise\nPress the mouse to bring order ", width/2, height*9/10);
    textSize(55);
    fill(255, t);
    text("Silence is soothing", width/2, height/2);
    
    /*if (frameCount > 750) {
      if (fadeIn <255  ) { 
        fadeIn = fadeIn + 255/15;
      }
      fill(fadeIn, t);*/
      text("But fragile", width/2, height*3/5);

      if (frameCount==849) {
        onda.rumore();
      }
    //}
    popMatrix();
  }


  /*----------------------------------
   -------------------------------------*/
  if (frameCount> 1200 && frameCount< 1500) {
    tint(255, 45);
    image(cuffie, width/2-cuffie.width/2, 0);
    if (frameCount == 1201) { 
      t = 255;
      fadeIn = 0;
      onda.rumore();
      rumore.close();
    }
    //size(1000, 500);
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    textAlign(CENTER);
    smooth();
    textFont(font_2);
    if (frameCount > 1450 && t >=0) { 
      t = t - 255/20;
    }

    textSize(55);
    fill(255, t);
    text("Protect it with No-Ise \nNoise-Cancelling headphones ", width/2, height*2/5);

    //if(frameCount >= 1150){onda.setColore(color(255, 252, 127));}
    popMatrix();
  }

  /*----------------------------------
   -------------------------------------*/
  if (frameCount >1850 && frameCount<2100 ) {
    tint(255, 45);
    image(cuffie, width/2-cuffie.width/2, 0);
    //size(1000, 500);
    hint(DISABLE_DEPTH_TEST);

    if (frameCount == 1851) { 
      t = 255;
      fadeIn = 0;
    }
    textFont(font_1);
    background(25);
    fill(255);
    textSize(55);

    if (frameCount > 2025 && t >=0) { 
      t = t - 255/20;
    }
    if (frameCount > 1925) {
      if (fadeIn <255  ) { 
        fadeIn = fadeIn + 255/15;
      }
      text("No   Ise", width*3/5, height/3);
    }
    tint(fadeIn, t);
    tint(255, t);
    l.display();
    if (frameCount == 2029) {
      song.close();
      exit();
    }
  }
  //println(frameRate);
}
/*----------------------------------
 -------------------------------------*/
void mousePressed() {
  if (frameCount >750 && frameCount<1150) {
    tint(255, 200);
    image(img, 0, 0);
  }
}

void stop() {
  rumore.close();
  song.close();
  minim.stop();
  super.stop();
}