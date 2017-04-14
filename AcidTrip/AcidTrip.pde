import hypermedia.video.*;
import java.awt.Point;
import pSmile.PSmile;
OpenCV opencv;

PSmile smile;

int w, h;
float res, factor;
int threshold_val = 90;
int MIN_AREA = 10 * 10;
int MAX_AREA = 700 * 750;
int MAX_BLOBS = 100;
color[] c = new color[MAX_BLOBS];

PImage[] emoji = new PImage[3];

void setup() {
  
  for(int i = 0; i < 3; i++) {
    emoji[i] = loadImage("data/emoji/" + i + ".png");
  }
  noStroke();
  size( displayWidth, displayHeight );
  // open video stream
  smooth();
  opencv = new OpenCV( this );
  opencv.capture( 400, 300 );

  smile = new PSmile(this, 400, 300);

  res = 0.0;
  factor = 0.0;
  for ( int i = 0; i < MAX_BLOBS; i++ ) {
    c[i] = color(random(255), random(255), random(255));
  }
}

void draw() {
  background(0);
  fill(255);
  opencv.read();           // grab frame from camera
  PImage refImage = opencv.image();
  opencv.threshold(threshold_val);    // set black & white threshold 
  // find blobs
  Blob[] blobs = opencv.blobs( MIN_AREA, MAX_AREA, MAX_BLOBS, true, OpenCV.MAX_VERTICES * 4 );
  // draw blob results
  pushMatrix();
  scale(3);
  for ( int i=0; i<blobs.length; i++ ) {
    fill(c[i]);
    Point centroid = blobs[i].centroid;
    // DRAWING THE SHAPE
    beginShape();
    for ( int j=0; j<blobs[i].points.length; j++ ) {
      vertex( blobs[i].points[j].x, blobs[i].points[j].y );
    }
    endShape(CLOSE);
  }
  popMatrix();
//  println(threshold_val);

  res = smile.getSmile(refImage);

  image(refImage, 0, 0, 320, 180);
  
  if(res < 0) {
    image(emoji[0], displayWidth - 128, displayHeight - 128);
  } else if (res < 2) {
    image(emoji[1], displayWidth - 128, displayHeight - 128);
  } else {
    image(emoji[2], displayWidth - 128, displayHeight - 128);
  }
  
  text(""+res, displayWidth - 128, displayHeight - 128 );
  
//  if (res>0) {
//    factor = factor*0.8 + res*0.2;
    
    
    
//    float t_h = factor*30;
//    fill(255);
//    rect(width/2-20, height-t_h-30, 40, t_h);
//
//    String str = nf(res, 1, 4);
//    text(str, width/2, 10);
//  }
  
  println(res);

  saveFrame("test video/######.tiff");
}
void mouseDragged() {
  threshold_val = int( map(mouseX, 0, width, 0, 255) );
}
void mouseReleased() {
  println(threshold_val);
}
void keyReleased() {
  saveFrame("data/####-ads.tiff");
}

