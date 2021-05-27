import processing.video.*;
Capture video;
PImage track;
PVector poit;
int tSize=20;
float scl;
void setup()
{
  size(640, 480);
  video=new Capture(this, 320, 240);
  video.start();
  track=new PImage(tSize, tSize);
  scl=width/video.width;
  poit=new PVector();
  
}
void draw()
{
  show();
  thread("pot");

}
void pot()
{
  video.loadPixels();
  track.loadPixels();
  float recordfit=10000;
  PVector po=new PVector();
  for (int i=0; i<video.width-track.width; i++)
  {
    for (int j=0; j<video.height-track.height; j++)
    {
      float fit=0;
      //tracks the points using simple maths i.e. the sum of the diffrences of the pixels in area.
      for (int i2=0; i2<track.width; i2++)
      {
        for (int j2=0; j2<track.height; j2++)
        {
          color t=track.pixels[(j2*track.width)+i2];
          color v=video.pixels[((j+j2)*video.width)+i+i2];
          fit+=dist(red(t), green(t), blue(t), 
            red(v), green(v), blue(v));
        }
      }
      if (recordfit>fit)
      {
        recordfit=fit;
        po.x=map(i, 0, video.width, width, 0)-track.width;
        po.y=map(j, 0, video.height, 0, height)+track.height;
      }
    }
  }
  poit=po;
  //This is the function that updates the tracking data when fitness is in a range
  //if(recordfit>2200&&recordfit<2600)
  //{
  //  tpoint(poit.x,poit.y);
  //  //println(recordfit);
  //}
  
}
void mousePressed()
{
  tpoint(mouseX,mouseY);
}
//stores tracking data
void tpoint(float x,float y)
{
  if (x<width-track.width&&y<height-track.height&&x>track.width&&y>track.height)
  {
    video.loadPixels();
    track.loadPixels();
    for (int i=0; i<track.width; i++)
    {
      for (int j=0; j<track.height; j++)
      {
        track.pixels[(j*track.width)+i]=
        video.pixels[((int(map(y, 0, height, 0, video.height)+j-track.height/2))*video.width)
                      +int(map(x, width, 0, 0, video.width)-track.width/2)+i];
      }
    }
    track.updatePixels();
  }
}
void captureEvent(Capture c)
{
  c.read();
}
//shows what ever is to be drawn
void show()
{
  drawImg(video,0,0,width,height);
  noFill();
  stroke(255,0,0);
  strokeWeight(2);
  rectMode(CENTER);
  square(poit.x, poit.y, (tSize*scl)+4);
  drawImg(track,0,0,tSize*scl,tSize*scl);
}
//draws the give picture at given points and specified sizes
void drawImg(PImage img,float x,float y,float w,float h)
{
  pushMatrix();
  translate(x+w,y);
  scale(-1,1);
  image(img, 0, 0, w, h);
  popMatrix();
}
void exit()
{
  video.stop();
  println("END");
}
