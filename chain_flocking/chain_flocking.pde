/*
  Chain Flocking
  --------------
  This program was inspired by the boids flocking algorithm. It is a test to play around with the emergent behaviours of simple rules.
  There are only two main rules:
    1. Each ball randomly follows another ball in the list.
    2. Balls will repel one another if they get to close.
    
  From these two simple rules intesting chain-like structures form and the balls start to order themselves into "flocks" of balls.
  
  
  written by Adrian Margel, Summer 2018
*/

class Ball{
  //x pos of the ball
  float x;
  //x pos of the ball
  float y;
  //x speed of the ball
  float sx;
  //x speed of the ball
  float sy;
  //the id of the ball to be followed
  int follow;
  
  //simple constructor to set the position 
  //amount is the total number of balls
  //self is the id of this ball
  Ball(float x,float y,int amount,int self){
    this.x=x;
    this.y=y;
    sx=0;
    sy=0;
    
    //set the follow to an id other than the id of this ball
    follow=(int)random(0,amount);
    while(follow==self){
      follow=(int)random(0,amount);
    }
  }
  
  //applies forces to balls
  void run(ArrayList<Ball> balls){
    for(int i=0;i<balls.size();i++){
      //repel this ball away from all other balls
      if(balls.get(i)!=this){
        //calculate distance between balls
        float diffX=x-balls.get(i).x;
        float diffY=y-balls.get(i).y;
        float mag=sqrt(sq(diffX)+sq(diffY));
        
        //only apply force if the ball is within a set radius
        if(mag<150){
          float angle=atan2(diffY,diffX);
          mag=10/sq(max(mag,10));
          sy+=sin(angle)*mag;
          sx+=cos(angle)*mag;
        }
      }
    }
    
    //the target ball being followed
    Ball target=balls.get(follow);
    
    //attract this ball towards the target
    //calculate angle to target
    float diffX=x-target.x;
    float diffY=y-target.y;
    float angle=atan2(diffY,diffX);
    //apply force
    sy+=sin(angle)*-0.3;
    sx+=cos(angle)*-0.3;
    
    
    //apply resistance to ball speed
    sx*=0.9;
    sy*=0.9;
    
  }
  
  //moves the ball's physical location
  void move(){
    //add speed to position
    x+=sx;
    y+=sy;
    
    //if ball is outside of a radius then have it collide with the bounding circle
    float rad=height/2/zoom;
    float dx=rad-x;
    float dy=rad-y;
    float angle=atan2(dy,dx);
    float dist=sqrt(sq(dx)+sq(dy));
    float over=rad-dist;
    if(over<0){
      x-=cos(angle)*over;
      y-=sin(angle)*over;
      sx+=cos(angle)*0.2;
      sy+=sin(angle)*0.2;
    }
  }
  
  void display(){
    point(x*zoom,y*zoom);
  }
}

//how much the display of the balls is scaled by
float zoom=0.5;
//the list of all balls
ArrayList<Ball> allBalls= new ArrayList<Ball>();

void setup(){
  //size of window
  size(800,800);
  
  //number of balls
  int balls=1000;
  
  //how large of an area they are initially spread over
  int spread=400;
  for(int i=0;i<balls;i++){
    allBalls.add(new Ball(400/zoom+random(-spread,spread),400/zoom+random(-spread,spread),balls,i));
  }
  
  //set background to black
  background(0);
  //turn of anit-aliasing for faster framerate
  noSmooth();
  //set framerate really high so it'll max out
  frameRate(2000);
}

void draw() {
  //draw a rectangle to make the screen slowly fade to black over time
  fill(0,15);
  noStroke();
  rect(0,0,width,height);
  
  //calculate all ball attractions
  for(Ball b: allBalls){
    b.run(allBalls);
  }
  
  //set ball color to white
  stroke(255);
  
  //update all ball positions and display them to screen
  for(Ball b: allBalls){
    b.move();
    b.display();
  }
}
