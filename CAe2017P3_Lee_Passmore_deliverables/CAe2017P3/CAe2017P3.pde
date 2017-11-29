// Base code for Cae 2017 Project 3 on Animation Aesthetics
// Authors: Austin Passmore & Seunghwan Lee 

// variables to control display
boolean showConstruction=true; // show construction edges and circles
boolean showControlFrames=false;  // show start and end poses
boolean showStrobeFrames=false; // shows 5 frames of animation
boolean computingBlendRadii=true; // toggles whether blend radii are computed or adjusted with mouse ('b' or 'd' with vertical mouse moves)
boolean showKeyFrames = true; // shows created keyFrames
boolean moveControlPoints = false; // toggles whether control points can be moved
boolean showControls = true; // toggles the display of the control menu
boolean presetAnimations = false; // toggles the preset animations

// Variables that control the shape
float g = 350;            // ground height measured downward from top of canvas
float x0 = 160, x1 = 850; // initial & final coordinate of disk center 
float y0 =  200;           // initial & final vertical coordinate of disk center above ground (y is up)
float x = x0, y = y0;     // current coordinates of disk center 
float r0 = 50;            // initial & final disk radius

float r = r0;             // current disk radius
float b0 = 150, d0 = 90;   // initial & final values of the width of bottom of dress (on both sides of x)
float b = b0, d = d0;     // current values of the width of bottom of dress (on both sides of x)
float _p = b0, _q = d0;     // global values of the radii of the left and right arcs of the dress (user edited)

// Animation
boolean animating = false; // animation status: running/stopped
float t=0.0;               // current animaiton time
int animateKeyFrames = 0;  // Counter to keep track of which keyframes to animate through
float speed = 0.0;

// Emotion
String emotion = "";

// snapping a picture
import processing.pdf.*;    // to save screen shots as PDFs
boolean snapPic=false;
String PicturesOutputPath="data/PDFimages";
int pictureCounter=0;
//void snapPicture() {saveFrame("PICTURES/P"+nf(pictureCounter++,3)+".jpg"); }

// Filming
boolean filming=false;  // when true frames are captured in FRAMES for a movie
int frameCounter=0;     // count of frames captured (used for naming the image files)
boolean change=false;   // true when the user has presed a key or moved the mouse

// Keyframe Lists
ArrayList keyFrames_x = new ArrayList();
ArrayList keyFrames_y = new ArrayList();
ArrayList keyFrames_b = new ArrayList();
ArrayList keyFrames_d = new ArrayList();
ArrayList keyFrames_r = new ArrayList();

// Control Points
ArrayList controlPoints_x = new ArrayList();
ArrayList controlPoints_y = new ArrayList();
int currControlPoint = 0;

// Saved animations
//Discouraged
float[] keyFrames_x_discouraged = {186.0, 285.0, 378.0, 420.0, 512.0, 564.0, 659.0, 721.0};
float[] keyFrames_y_discouraged = {204.0, 98.0, 119.0, 88.0, 115.0, 82.0, 114.0, 82.0};
float[] keyFrames_b_discouraged = {128.0, 191.0, 191.0, 191.0, 191.0, 191.0, 191.0, 191.0};
float[] keyFrames_d_discouraged = {109.0, -11.0, -11.0, -28.0, -28.0, -38.0, -28.0, -40.0};
float[] keyFrames_r_discouraged = {82.0, 82.0, 82.0, 82.0, 82.0, 82.0, 82.0, 82.0};
float[] controlPoints_x_discouraged = {280.0, 301.0, 413.0, 430.0, 545.0, 575.0, 690.0};
float[] controlPoints_y_discouraged = {185.0, 63.0, 157.0, 35.0, 154.0, 30.0, 157.0};

//Happy
float[] keyFrames_x_happy = {172.0, 251.0, 308.0, 416.0, 464.0, 572.0, 625.0, 730.0, 791.0};
float[] keyFrames_y_happy = {143.0, 210.0, 102.0, 212.0, 97.0, 204.0, 89.0, 204.0, 99.0};
float[] keyFrames_b_happy = {194.0, 194.0, 194.0, 194.0, 194.0, 194.0, 194.0, 194.0, 194.0};
float[] keyFrames_d_happy = {31.0, 31.0, 31.0, 31.0, 31.0, 31.0, 15.0, 15.0, 2.0};
float[] keyFrames_r_happy = {77.0, 77.0, 77.0, 77.0, 77.0, 77.0, 77.0, 77.0, 77.0};
float[] controlPoints_x_happy = {234.0, 282.0, 409.0, 430.0, 546.0, 604.0, 710.0, 760.0};
float[] controlPoints_y_happy = {250.0, 69.0, 268.0, 45.0, 269.0, 30.0, 273.0, 56.0};

//Scared
float[] keyFrames_x_scared = {350.0, 492.0, 525.0, 331.0, 27.0};
float[] keyFrames_y_scared = {120.0, 125.0, 253.0, 35.0, 20.0};
float[] keyFrames_b_scared = {37.0, 177.0, 250.0, 250.0, 61.0};
float[] keyFrames_d_scared = {161.0, 5.0, 16.0, 60.0, 157.0};
float[] keyFrames_r_scared = {81.0, 81.0, 97.0, 20.0, 20.0};
float[] controlPoints_x_scared = {431.0, 531.0, 387.0, 273.0};
float[] controlPoints_y_scared = {98.0, 178.0, 105.0, -5.0};


void setup()              // run once
  {
  size(1000, 400, P2D); 
  frameRate(30);        // draws new frame 30 times a second
    int n = 7;
    for(int i=0; i<n; i++) println("i="+i);
  }
 
void draw()             // loops forever
  {
  if(snapPic) beginRecord(PDF,PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); // start recording for PDF image capture
  if(animating) {computeParametersForAnimationTime(t);}
  background(255);      // erase canvas at each frame
  stroke(0);            // change drawing color to black
  line(0, g, width, g); // draws gound
  noStroke(); 
  if(showControlFrames) {fill(0,255,255); paintShape(x0,y0,r0,b0,d0); fill(255,0,255); paintShape(x1,y0,r0,b0,d0);}
  if(showStrobeFrames) 
    {
    float xx=x, yy=y, rr=r, bb=b, dd=d;
    int n = 7;
    for(int j=0; j<n; j++)
      {
      fill(255-(200.*j)/n,(200.*j)/n,155); 
      float tt = (float)j / (n-1); // println("j="+j+", t="+t);
      computeParametersForAnimationTime(tt);
      paintShape(x,y,r,b,d); 
      }
    println();
    x=xx; y=yy; r=rr; b=bb; d=dd;
    }
  
  // Draws keyframes 
  if (showKeyFrames && keyFrames_x.size() > 0) {
    int n = keyFrames_x.size();
    for (int k = 0; k < n; k++) {
      fill(255-(25.*k),50.+45.*k,(15.*k));
      float xx = (float)keyFrames_x.get(k);
      float yy = (float)keyFrames_y.get(k);
      float bb = (float)keyFrames_b.get(k);
      float dd = (float)keyFrames_d.get(k);
      float rr = (float)keyFrames_r.get(k);
      paintShape(xx,yy,rr,bb,dd); 
      fill(50,50,50); strokeWeight(40); textSize(20); text(k,xx,g-yy); // show keyframe number
    }
    // Draws control points
    if (controlPoints_y.size() > 0) {
      for (int c = 0; c < controlPoints_y.size(); c++) {
        strokeWeight(2);
        stroke(0, 0, 255);
        textSize(16);
        if (moveControlPoints && c == currControlPoint) {
          fill(0, 0, 255);
          ellipse((float)controlPoints_x.get(c), g - (float)controlPoints_y.get(c), 30, 30);
          fill(255, 255, 255);
          text("c" + c, (float)controlPoints_x.get(c) - 9.0, g - (float)controlPoints_y.get(c) + 4.0);
        } else {
          noFill();
          ellipse((float)controlPoints_x.get(c), g - (float)controlPoints_y.get(c), 30, 30);
          fill(0, 0, 0);
          text("c" + c, (float)controlPoints_x.get(c) - 9.0, g - (float)controlPoints_y.get(c) + 4.0);
        }
      }
    }
    // Draws curves
    if (controlPoints_y.size() > 0) {
      for (float a = 0.0; a <= 1.0; a += 0.01){
        for (int i = 0; i < controlPoints_y.size(); i++) {
          float xa = calcPoint((float)keyFrames_x.get(i), (float)controlPoints_x.get(i), a);
          float ya = calcPoint((float)keyFrames_y.get(i), (float)controlPoints_y.get(i), a);
          float xb = calcPoint((float)controlPoints_x.get(i), (float)keyFrames_x.get(i+1), a);
          float yb = calcPoint((float)controlPoints_y.get(i), (float)keyFrames_y.get(i+1), a);
          
          float curveX = calcPoint(xa, xb, a);
          float curveY = calcPoint(ya, yb, a);
          
          fill(255, 0, 0);
          noStroke();
          ellipse(curveX, g - curveY, 5, 5);
        }
      }
    }
  }
  
  // Draws Controls
  if (showControls) {
    fill(50, 50, 50); rect(575, 10, 400, 210); fill(0, 0, 255); rect(575, 10, 400, 25); // draws the menu box
    fill(255, 255, 255); textSize(24); text("Controls", 725, 31); // Controls text
    textSize(18); text("Hold & Move Mouse", 585, 55); strokeWeight(0.75); stroke(255, 255, 255); line(585, 60, 760, 60); // Hold text
    textSize(18); text("Press", 850, 55); strokeWeight(0.75); stroke(255, 255, 255); line(850, 60, 895, 60); // Press text  
    textSize(12); text("R  -  change head radius", 585, 75);
    text("X  -  move character", 585, 90);
    text("B or D  - adjust neck", 585, 105);
    text("Z  -  move control point", 585, 120);
    text("' (apostraphe)  -  screenshot", 795, 75);
    text("~ (tilda)  -  toggle filming", 795, 90);
    text("K  -  create keyframe", 795, 105);
    text("L  -  view keyframe GUI", 795, 120);
    text("P  -  delete last keyframe", 795, 135);
    text("N  -  clear keyframes", 795, 150);
    text("M  -  toggle edit control points", 795, 165);
    text("[ or ]  -  select keyframe", 795, 180);
    text("1, 2, or 3  -  select emotion", 795, 195);
    text("C  -  toggle red & green circles", 795, 210);
    textSize(16); text("Q - toggle control menu", 585, 175);
    textSize(14);text("Y - toggle preset animations", 585, 195);
    noStroke();
  }
  
  textSize(24);
  fill(0, 0, 0);
  text("Emotion: " + emotion, 10, 25);
  
  fill(0); paintShape(x,y,r,b,d); // displays current shape
  
  if(showConstruction) {noFill(); showConstruction(x,y,r,b,d);} // displays blend construction lines and circles
  showGUI(); // shows mouse location and key pressed
  if(snapPic) {endRecord(); snapPic=false;} // end saving a .pdf of the screen
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif"); // saves a movie frame 
  if(animating) {t+=(speed);} //if(t>=1.025) {t=1.025; animating=false;}} // increments timing and stops when animation is complete
  change=false; // reset to avoid rendering movie frames for which nothing changes
  }

void keyPressed()
  {
  if(key=='`') snapPic=true; // to snap an image of the canvas and save as zoomable a PDF
  if(key=='~') {
    filming=!filming;  // filming on/off capture frames into folder FRAMES
    if (filming) {
      println("Filming started...");
    } else {
      println("Filming stopped");
    }
  }
  if(key=='.') computingBlendRadii=!computingBlendRadii; // toggles computing radii automatically
  if(key=='f') showControlFrames=!showControlFrames;
  if(key=='c') showConstruction=!showConstruction;
  if(key=='q') showControls = !showControls;
  if(key=='s') showStrobeFrames=!showStrobeFrames;
  if(key=='a') // start animation
    {
      if (animating == false && keyFrames_x.size() > 0)
        {
          x = (float)keyFrames_x.get(0);
          y = (float)keyFrames_y.get(0);
          b = (float)keyFrames_b.get(0);
          d = (float)keyFrames_d.get(0);
          r = (float)keyFrames_r.get(0);
        }
      animating=!animating;
      t=0.0;
      animateKeyFrames = 0;
    }
  // Creates a keyFrame
  if(key=='k') {
    keyFrames_x.add(x);
    keyFrames_y.add(y);
    keyFrames_b.add(b);
    keyFrames_d.add(d);
    keyFrames_r.add(r);
    println(x, y, b, d, r);
    println("New keyframe added");
    
    if (keyFrames_x.size() > 1) {
      controlPoints_x.add(keyFrames_x.get(keyFrames_x.size() - 2));
      controlPoints_y.add(keyFrames_y.get(keyFrames_x.size() - 1));
    }
  }
  if(key=='l') {
    showKeyFrames = !showKeyFrames;
    if (showKeyFrames) {
      println("Show keyframes");
    } else {
      println("Turned off keyframes");
    }
  }
  if(key=='p') {
    if (keyFrames_x.size() > 0) {
      keyFrames_x.remove(keyFrames_x.size() - 1);
      keyFrames_y.remove(keyFrames_y.size() - 1);
      keyFrames_b.remove(keyFrames_b.size() - 1);
      keyFrames_d.remove(keyFrames_d.size() - 1);
      keyFrames_r.remove(keyFrames_r.size() - 1);
      println("Last keyframe removed");
    }
    if (controlPoints_y.size() > 0 && currControlPoint == controlPoints_y.size() - 1) {
      currControlPoint--;;
    }
    if (controlPoints_x.size() > 0) {
      controlPoints_x.remove(controlPoints_y.size() - 1);
      controlPoints_y.remove(controlPoints_y.size() - 1);
      println("Last control point removed");
    }
  }
  if(key=='n') {
    keyFrames_x.clear();
    keyFrames_y.clear();
    keyFrames_b.clear();
    keyFrames_d.clear();
    keyFrames_r.clear();
    println("Keyframes cleared");
    controlPoints_x.clear();
    controlPoints_y.clear();
    currControlPoint = 0;
    println("Control points cleared");
  }
  if (key=='m') {
    moveControlPoints = !moveControlPoints;
    if (moveControlPoints) {
      println("Editing control points...");
      currControlPoint = 0;
    }
  }
  if (key=='[' && moveControlPoints && controlPoints_x.size() > 0) {
    currControlPoint--;
    if (currControlPoint < 0) {
      currControlPoint = controlPoints_x.size() - 1;
    }
    println("controlpoints: " + controlPoints_x.get(currControlPoint) + ", " + controlPoints_y.get(currControlPoint));
  }
  if (key==']' && moveControlPoints && controlPoints_x.size() > 0) {
    currControlPoint++;
    if (currControlPoint >= controlPoints_x.size()) {
      currControlPoint = 0;
    }
    println("controlpoints: " + controlPoints_x.get(currControlPoint) + ", " + controlPoints_y.get(currControlPoint));
  }
  if (key=='1') {
    println("Emotion: Discouraged");
    emotion = "Discouraged";
    if (presetAnimations) {
      keyFrames_x.clear();
      keyFrames_y.clear();
      keyFrames_b.clear();
      keyFrames_d.clear();
      keyFrames_r.clear();
      controlPoints_x.clear();
      controlPoints_y.clear();
      currControlPoint = 0;
      for (int i = 0; i < keyFrames_x_discouraged.length; i++) {
        keyFrames_x.add(keyFrames_x_discouraged[i]);
        keyFrames_y.add(keyFrames_y_discouraged[i]);
        keyFrames_b.add(keyFrames_b_discouraged[i]);
        keyFrames_d.add(keyFrames_d_discouraged[i]);
        keyFrames_r.add(keyFrames_r_discouraged[i]);
      }
      for (int j = 0; j < controlPoints_x_discouraged.length; j++) {
        controlPoints_x.add(controlPoints_x_discouraged[j]);
        controlPoints_y.add(controlPoints_y_discouraged[j]);
      }
    }
  }
  if (key=='2') {
    println("Emotion: Happy");
    emotion = "Happy";
    if (presetAnimations) {
      keyFrames_x.clear();
      keyFrames_y.clear();
      keyFrames_b.clear();
      keyFrames_d.clear();
      keyFrames_r.clear();
      controlPoints_x.clear();
      controlPoints_y.clear();
      currControlPoint = 0;
      for (int i = 0; i < keyFrames_x_happy.length; i++) {
        keyFrames_x.add(keyFrames_x_happy[i]);
        keyFrames_y.add(keyFrames_y_happy[i]);
        keyFrames_b.add(keyFrames_b_happy[i]);
        keyFrames_d.add(keyFrames_d_happy[i]);
        keyFrames_r.add(keyFrames_r_happy[i]);
      }
      for (int j = 0; j < controlPoints_x_happy.length; j++) {
        controlPoints_x.add(controlPoints_x_happy[j]);
        controlPoints_y.add(controlPoints_y_happy[j]);
      }
    }
  }
  if (key=='3') {
    println("Emotion: Scared");
    emotion = "Scared";
    if (presetAnimations) {
      keyFrames_x.clear();
      keyFrames_y.clear();
      keyFrames_b.clear();
      keyFrames_d.clear();
      keyFrames_r.clear();
      controlPoints_x.clear();
      controlPoints_y.clear();
      currControlPoint = 0;
      for (int i = 0; i < keyFrames_x_scared.length; i++) {
        keyFrames_x.add(keyFrames_x_scared[i]);
        keyFrames_y.add(keyFrames_y_scared[i]);
        keyFrames_b.add(keyFrames_b_scared[i]);
        keyFrames_d.add(keyFrames_d_scared[i]);
        keyFrames_r.add(keyFrames_r_scared[i]);
      }
      for (int j = 0; j < controlPoints_x_scared.length; j++) {
        controlPoints_x.add(controlPoints_x_scared[j]);
        controlPoints_y.add(controlPoints_y_scared[j]);
      }
    }
  }
  if (key=='y') {
    presetAnimations = !presetAnimations;
    if (presetAnimations) {
      println("Preset animations turned on");
    } else {
      println("Preset animations turned off");
    }
  }
  
  change=true; // reset to render movie frames for which something changes
  }
  
void mouseMoved() // press and hold the key you want and then move the mouse (do not press any mouse button)
  {
  if(keyPressed)
    {
    if(key=='r') r+=mouseX-pmouseX;
    if(key=='x') {x+=mouseX-pmouseX; y-=mouseY-pmouseY;}
    if(key=='b') {b-=mouseX-pmouseX; _p-=mouseY-pmouseY;}
    if(key=='d') {d+=mouseX-pmouseX; _q-=mouseY-pmouseY;}
    if(key=='z' && moveControlPoints && controlPoints_x.size() > 0) {
      controlPoints_x.set(currControlPoint, (float)controlPoints_x.get(currControlPoint) + (mouseX - pmouseX));
      controlPoints_y.set(currControlPoint, (float)controlPoints_y.get(currControlPoint) - (mouseY - pmouseY));
    }
    }
  change=true; // reset to render movie frames for which something changes
  }

// display shape defined by the 5 parameters (and by _p and _q when these are not to be recomputed automatically
void paintShape(float x, float y, float r, float b, float d)
  {
  float p=_p, q=_q; // use gobal values (user controlled) in case we do not want to recompute them automatically
  if(computingBlendRadii)
    {
    p=blendRadius(b,y,r);
    q=blendRadius(d,y,r);
    }

  int n = 30; // number of samples
  
  beginShape(); // starts drawing shape
 
    // sampling the left arc
    float u0=-PI/2, u1 = atan2(y-p,b); 
    float du = (u1-u0)/(n-1);
    for (int i=0; i<n; i++) // loop to sample let arc
      {
      float s=u0+du*i;
      vertex(x-b+p*cos(s),g-p-p*sin(s)); 
      }

    // sampling the right arc
    float v0=-PI/2, v1 = atan2(y-q,d); 
    float dv = (v1-v0)/(n-1);
    for (int i=n-1; i>=0; i--) // loop to sample let arc
      {
      float s=v0+dv*i;
      vertex(x+d-q*cos(s),g-q-q*sin(s));
      }

  endShape(CLOSE);  // Closes the shape 
  
  ellipse(x,g-y,r*2,r*2);  // draw disk
  }

// shows construction lines for shape defined by the 5 parameters (and by _p and _q when these are not to be recomputed automatically
void showConstruction(float x, float y, float r, float b, float d) 
  {
  // compute blend radii
  float p=_p, q=_q; // use gobal values (user controlled) in case we do not want to recompute them automatically
  if(computingBlendRadii)
    {
    p=blendRadius(b,y,r);
    q=blendRadius(d,y,r);
    }
  
  strokeWeight(2);  
  // draw left arc
  stroke(200,0,0);      // change line  color to red
  line(x-b,g,x-b,g-p);  // draw vertical edge to center of left circle
  line(x-b,g-p,x,g-y);  // draw diagonal edge from center of left circle to center of disk
  ellipse(x-b,g-p,p*2,p*2);  // draw left circle

  // draw right arc
  stroke(0,150,0);      // change line color to darker green
  line(x+d,g,x+d,g-q);  // draw vertical edge to center of right circle
  line(x+d,g-q,x,g-y);  // draw diagonal edge from center of right circle to center of disk
  ellipse(x+d,g-q,q*2,q*2);  // draw left circle
  }
  
// show Mouse and key pressed
void showGUI()
  {
  noFill(); stroke(155,155,0);
  if(mousePressed) strokeWeight(3); else strokeWeight(1);
  ellipse(mouseX,mouseY,30,30);
  if(keyPressed) {fill(155,155,0); strokeWeight(2); text(key,mouseX-6,mouseY);}
  strokeWeight(1);
  }
  
//*********** TO BE PROVIDED BY STUDENTS    
// computes current values of parameters x, y, r, b, d for animation parameter t
// so as to produce a smooth and aesthetically pleasing animation
// that conveys a specific emotion/enthusiasm of the moving shape
void computeParametersForAnimationTime(float t) // computes parameters x, y, r, b, d for current t value
  {
  if (keyFrames_x.size() != 0 && animateKeyFrames < keyFrames_x.size() - 1)
    {
      float xStart = (float)keyFrames_x.get(animateKeyFrames);
      float xEnd = (float)keyFrames_x.get(animateKeyFrames + 1);
      float yStart = (float)keyFrames_y.get(animateKeyFrames);
      float yEnd = (float)keyFrames_y.get(animateKeyFrames + 1);
      float bStart = (float)keyFrames_b.get(animateKeyFrames);
      float bEnd = (float)keyFrames_b.get(animateKeyFrames + 1);
      float dStart = (float)keyFrames_d.get(animateKeyFrames);
      float dEnd = (float)keyFrames_d.get(animateKeyFrames + 1);
      float rStart = (float)keyFrames_r.get(animateKeyFrames);
      float rEnd = (float)keyFrames_r.get(animateKeyFrames + 1);
      
      if (emotion == "Discouraged")
      {
        if (yStart > yEnd) // going down
        {
          speed = 0.04;
        }
        else
        {
          speed = 0.03;
        }
      }
      else if (emotion == "Happy")
      {
        if (yStart > yEnd)
        {
          speed = 0.08;
        }
        else
        {
          speed = 0.08;
        }
      }
      else if (emotion == "Scared")
      {
        if (animateKeyFrames == 0)
        {
          speed = 0.02;
        }
        else if (animateKeyFrames == 1)
        {
          speed = 0.1;
        } 
        else
        {
          speed = 0.04;
        }
      }
      
      // Move along curves
      float xa = calcPoint(xStart, (float)controlPoints_x.get(animateKeyFrames), t);
      float ya = calcPoint(yStart, (float)controlPoints_y.get(animateKeyFrames), t);
      float xb = calcPoint((float)controlPoints_x.get(animateKeyFrames), xEnd, t);
      float yb = calcPoint((float)controlPoints_y.get(animateKeyFrames), yEnd, t);
      
      float curveX = calcPoint(xa, xb, t);
      float curveY = calcPoint(ya, yb, t);
      
      //x = xStart + 1.01*sin(t * 0.3 * PI / 2)*sin(t * 0.3 * PI / 2)*(xEnd-xStart);
      //y = yStart + 1.01*sin(t * 0.3 * PI / 2)*sin(t * 0.3 * PI / 2)*(yEnd-yStart);
      x = curveX;
      y = curveY;
      b = bStart + sin(t * PI / 2)*sin(t * PI / 2)*(bEnd-bStart);
      d = dStart + sin(t * PI / 2)*sin(t * PI / 2)*(dEnd-dStart);
      r = rStart + sin(t * PI / 2)*sin(t * PI / 2)*(rEnd-rStart);
      
      //b = bStart + t*(bEnd-bStart);
      //d = dStart + t*(dEnd-dStart);
      //r = rStart + t*(rEnd-rStart);
      
      //println("x = " + x + "; xStart = " + xStart + "; xEnd = " + xEnd);
      
      if((xStart < xEnd && x >= xEnd) || (xStart > xEnd && x <= xEnd))
        {
          println("keyframe changed");
          this.animateKeyFrames++;
          this.t = 0.0;
        } 
      //println("animateKeyFrames == " + animateKeyFrames);
    }
  }
  
//*********** TO BE PROVIDED BY STUDENTS  
// compute blend radius tangent to x-axis at point (0,0) and circle of center (b,y) and radius r   
float blendRadius(float b, float y, float r) 
  {
  return (y * y + b * b - r * r) / (2.0 * (r + y));
  //println("y = " + y + ";   b = " + b + ";   r = " + r + ";   return = " + centerDist);
  //return centerDist; // replace with your formula
  }


// computes a point based off of a LERP, used for creating curves
float calcPoint(float n1, float n2, float t)
{
  float diff = n2 - n1;
  return n1 + (diff * t);
  //return n1 + (diff * sin(t * PI / 2) * sin(t * PI / 2) * 1.005);
}