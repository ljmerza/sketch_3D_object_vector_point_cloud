import processing.opengl.*;
import SimpleOpenNI.*;

// current rotation of window
float rotateX;
float rotateY;

//kinect object
SimpleOpenNI kinect;

float s = 1;

void setup() 
{
  // create a new kinect object
  kinect = new SimpleOpenNI(this);
  // enable the deoth camera
  kinect.enableDepth();
  // enable the color camera
  kinect.enableRGB();
  
  // set size of window
  size(kinect.depthWidth(),kinect.depthHeight());
}

void draw() 
{ 
  // set background color to black
  background(0);
  //update kinect images
  kinect.update();
  // get current image from rgb sensor
  PImage rgbImage = kinect.rgbImage();
  // flip it around to see in window
  translate(width/2, height/2, -1000);
  // rotate x axis to adjust y axis
  rotateX(radians(180));
  // 
  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  translate(0, 0, s*-1000);
  scale(s);
  // turn on lights
  lights();
  noStroke();
  
  // isolate model transformations
  pushMatrix();
  // adjust for default orientation
  // of the model
  rotateX(radians(-90));
  rotateZ(radians(180));
  model.draw();
  popMatrix();
  stroke(255);
  
  PVector[] depthPoints = kinect.depthMapRealWorld();
  for (int i = 0; i < depthPoints.length; i+=100) 
  {
    //stroke(rgbImage.pixels[i]);
    PVector currentPoint = depthPoints[i];
    // draw the lines darkly with alpha
    stroke(100, 30);
    line(0,0,0, currentPoint.x, currentPoint.y, currentPoint.z);
    // draw the dots bright green
    stroke(0,255,0);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
}

void keyPressed()
{
  if (keyCode == 38) 
  {
    s = s + 0.01;
  }
  if (keyCode == 40) 
  {
    s = s - 0.01;
  }
}
