int state;

//NAPKIN DRAWING STUFF
// Instance variables
  // colors jljl
color liquid;
//color choice1 = color(255,223,128);
color choice1 = color(0,0,0);
color choice2 = color(23,0,117);
color choice3 = color(128,0,64);
color choice4 = color(0,110,64);
//color choice5 = color(229,255,255);

// Effects Tracker
ArrayList effects = new ArrayList();

// Straw Variables
int strawOffset = 20;
int offset;
int flvl;
int fmax = 250;
int fmin = 0;

// Color Menu Variables
int xalign = 1000;
int yalign = 600;
int boxSize = 40;

int yPallete = 145;
int xPallete = 408;

// Effect Variables
int dOffset = 8;
int w =  232;

//*** title animation ***//
ArrayList<Brush> brushes; 

int currPhase;
int timer;

String theme;

void setup() {
  state = 0;
  gameSetup();
  size(1000,600);
}

void gameSetup() {
  effects = new ArrayList();
  timer = 3;
  currPhase = 1;
  smooth();
  liquid = choice1;
  flvl = fmax;
  offset = strawOffset;
  noCursor();
  frameRate(180);
  brushes = new ArrayList<Brush>();
  for (int i = 0; i < 50; i++) {
    brushes.add(new Brush());
  }
  theme = getTheme();
}

void draw() {
  switch(state) {
    case 0:
      title();
      break;
    case 1:
      game();
      break;
    case 2:
      directions();
      break;
    case 3:
      transition();
      break;
    case 4:
      end();
      break;
    case 5:
      begin();
      break;
  }
}

void title() {
  PImage panda = loadImage("panda.jpg");
  background(panda);
  //background(255);
  for (Brush brush : brushes) {
    brush.paint();
  }
  //key pressed
  if (keyPressed) {
    if (key == ' ') {
      state = 5;
      gameSetup();
    }
    if (keyCode == SHIFT) {
      state = 2;
    }
  }
}

//*** Directions ***//
void directions(){
  PImage directions = loadImage("directions.jpg");
  background(directions);
  if (key == BACKSPACE) {
    state = 0;
  }
}

void game() {
  drawBackground(); 
  drawColorMenu();
      
   // Draw effects  
  if(effects.size() > 0){
    for(int i = 0; i < effects.size(); i++){
      Effect e = (Effect)effects.get(i);
      
      // color blend
      if(effects.size() > 1){
      for(int j = 0; j < effects.size();j++){
        if(j == i){
          continue;
        }
        Effect e2 = (Effect)effects.get(j);
        
        if(dist(e.getX(),e.getY(),e2.getX(),e2.getY()) < 10 && 
            (e.isBlended() == false ||
            e2.isBlended() == false))
        {
          color mix1 = e.getColor();
          color mix2 = e2.getColor();
          float r,g,b,r2,g2,b2,nr,ng,nb;
          color newColor;
         
          
          r = red(mix1);
          g = green(mix1);
          b = blue(mix1);
          r2 = red(mix2);
          g2 = green(mix2);
          b2 = blue(mix2);
               
          nr = max(r,r2) - (min(r,r2)/10);
          ng = max(g,g2) - (min(g,g2)/10);
          nb = max(b,b2) - (min(b,b2)/10);
      
          newColor = color(nr,ng,nb);
                  
          effects.set(i,new Effect(e.getX(),e.getY(),e.getXOffset(),e.getYOffset(),newColor,e.getSpread(),true));
          effects.set(j,new Effect(e2.getX(),e2.getY(),e2.getXOffset(),e2.getYOffset(),newColor,e2.getSpread(),true));
        }
      }
      }
      
      e.drawEffect();
    } 
  }
  
//  drawStraw();
  
  drawBrush();
  
  
  // Bounding boxes
  /*
  noFill();
  stroke(0);
  rect(25,65,290,370);
  rect(180,160,230,310);
  */
  
  // Mouse conditionals
  if(mousePressed){
    offset = 0;
    
    
   // ((mouseX > 25 && mouseX < 495) && (mouseY > 25 && mouseY < 490))
   //  ||
   //     ((mouseX > 25 && mouseX < 410) && (mouseY > 160 && mouseY < 580))
    
    
    // Make effect
    if(
        ((mouseX > 20 && mouseX < 360) && (mouseY > 10 && mouseY < 580))
     ||
        ((mouseX > 20 && mouseX < 980) && (mouseY > 180 && mouseY < 580))
     ||
        ((mouseX > 640 && mouseX < 990) && (mouseY > 10 && mouseY < 580))    )
    {
       flvl = flvl - 2;
       if(flvl < fmin){
         flvl = fmin;
         state = 3;
       }
       if(flvl > fmin){
         effects.add(new Effect(mouseX,mouseY,liquid,0,false));
         
         //mirrored
         effects.add(new Effect(mouseX*-1 + 1000, mouseY, liquid, 0, false));
       }         
    }
    
    
    // Refill
    
    //if(mouseX > 400 && mouseX < 600){
    //   if(mouseY > 0 && mouseY < 50){
    //     flvl+=17;
    //     if(flvl >= fmax){
    //       flvl = fmax;
    //     }
    //   }
    //}
    
   // if(mouseX > 360 && mouseX < 500){
   //    if(mouseY > 0 && mouseY < 100){
   //      flvl+=17;
   //      if(flvl >= fmax){
   //        flvl = fmax;
   //      }
   //    }
   // }
    
    
    // Color Change
    if(mouseY > yPallete-50 && mouseY < yPallete + 45){
       // Color choice 1
       if(mouseX > 375 && 
           mouseX < 375+62.5){
         liquid = choice1;
       }
       // Color choice 2
       if(mouseX > 375+62.5 && 
           mouseX < 375+62.5*2){
         liquid = choice2;
       }
       // Color choice 3
       if(mouseX > 375+62.5*2 && 
           mouseX < 375+62.5*3){
         liquid = choice3;
       }
       // Color choice 4
       if(mouseX > 375+62.5*3 && 
           mouseX < 375+62.5*4){
         liquid = choice4;
       }
       // Color choice 5
      // if(mouseX > xPallete+60 && 
      //     mouseX < xPallete+60){
      //   liquid = choice5;
     //  }
       
    }
    
  }
  else{
    offset = strawOffset;
  }
  
  // Reseter
  //if(keyPressed)
  //{
  //  if(key == ' '){
  //    effects.clear();
  //  }
    
  //  if (key == 'q') {
  //    fill(0);
  //    rect(500, 0, 500, 580);
  //  }
    
  //  if (key == '1') {
  //    liquid = choice1;
  //  }
  //  if (key == '2') {
  //    liquid = choice2;
  //  }
  //  if (key == '3') {
  //    liquid = choice3;
  //  }
  //  if (key == '4') {
  //    liquid = choice4;
  //  }
  //}
}

void transition() {
  drawBackground();
  drawColorMenu();
  for(int i = 0; i < effects.size(); i++) {
      Effect e = (Effect)effects.get(i);
      e.drawEffect();
  }
  fill(0);
  textAlign(CENTER);
  if(timer > 0) {
    if(currPhase == 1) {
      textSize(32);
      text("Switch to the 2nd player", 500, 300);
      textSize(50);
      text(timer, 500, 400);
    }else if(currPhase == 2) {
      textSize(32);
      text("Switch to the 1st player", 500, 300);
      textSize(50);
      text(timer, 500, 400);
    }
  }else {
    timer = 4;
    flvl = fmax;
    state = 1;
    
    if(currPhase == 1) {
      currPhase = 2;
    }else if(currPhase == 2) {
      currPhase = 3;
    }else {
      state = 4;
    }
  }
  timer --;
  delay(1000);
}

void end() {
  drawBackground();
  drawColorMenu();
  for(int i = 0; i < effects.size(); i++) {
      Effect e = (Effect)effects.get(i);
      e.drawEffect();
  }
  
  fill(0);
  textAlign(CENTER);
  textSize(30);
  text("Finished!", 500, 485);
  text("Observer, can you guess the theme?", 500, 525);
  text("Press Enter to go to the Main Menu", 500, 565);
  
  if (keyPressed) {
    if (key == RETURN || key == ENTER) {
      state = 0;
    }
  }
}

void begin() {
  drawBackground();
  drawColorMenu();
  drawBrush();
  fill(0);
  textAlign(CENTER);
  textSize(30);
  text("The theme is:", 500, 250);
  text(theme, 500, 350);
  text("When ready, press Enter.", 500, 450);
  
  if (keyPressed) {
    if (key == RETURN || key == ENTER) {
      state = 1;
      timer = 3;
    }
  }
}

//brush drawing
void drawBrush() {
  
  //the shadow--------------
  color brushShadow = color(168, 161, 148,150);
  fill(brushShadow);
  noStroke();
  ellipse(mouseX-5, mouseY+5, 15, 8);
  ellipse(mouseX, mouseY+2, 13, 10);
  quad(mouseX-10,mouseY+7,
      mouseX+50,mouseY-53,
      mouseX+190,mouseY-150,
      mouseX+75,mouseY-20);
  
  //the brush'es color------------------
  color brushWood = color(227,186,129);
  color brushMetal = color(224,224,224);
  color brushHighlight = color(255,221,173);
  color brushy = color(69,60,48);
  
  //the actual brush-----------------
  fill(brushy);
  noStroke();
  ellipse(mouseX-3+offset,mouseY+5-offset,15,15);
  quad(mouseX-20+offset,mouseY+11-offset,
      mouseX-8+offset,mouseY-offset,
      mouseX+offset,mouseY-offset,
      mouseX-2+offset,mouseY+12-offset);
      ellipse(mouseX-10+offset,mouseY+11-offset,20,7);
      
  //metal part of brush-----------------
  fill(brushMetal);
  stroke(color(46,85,191));
  quad(mouseX-5+offset,mouseY-5-offset,
      mouseX+6+offset,mouseY-53-offset,
      mouseX+50+offset,mouseY-30-offset,
      mouseX+5+offset,mouseY+5-offset);
    ellipse(mouseX+offset,mouseY-offset,13,13);
    noStroke();
    ellipse(mouseX+2+offset,mouseY-1-offset,14,13);
    stroke(color(46,85,191));
    ellipse(mouseX+26+offset,mouseY-35-offset,48,30);
    ellipse(mouseX+32+offset,mouseY-47-offset,53,42);
    
    //bottom metal brush highlight------------
    noStroke();
    fill(255);
    quad(mouseX-2+offset,mouseY-5-offset,
      mouseX+4+offset,mouseY-25-offset,
      mouseX+8+offset,mouseY-21-offset,
      mouseX+offset,mouseY-offset);


  //wooden part brush--------------------------
  stroke(color(105,64,7));
  fill(brushWood);
  quad(mouseX+7+offset,mouseY-53-offset,
      mouseX+170+offset,mouseY-300-offset,
      mouseX+180+offset,mouseY-298-offset,
      mouseX+55+offset,mouseY-37-offset);
  noStroke();
  ellipse(mouseX+32+offset,mouseY-47-offset,52,42);
  quad(mouseX+8+offset,mouseY-53-offset,
      mouseX+171+offset,mouseY-300-offset,
      mouseX+180+offset,mouseY-298-offset,
      mouseX+55+offset,mouseY-37-offset);
  stroke(color(105,64,7));
  ellipse(mouseX+175+offset,mouseY-offset-298,11,10);
  noStroke();
  ellipse(mouseX+174+offset,mouseY-offset-296,10,10);
  
  //brush highlight----------------------------
  fill(brushHighlight);
  noStroke();
  quad(mouseX+15+offset,mouseY-53-offset,
      mouseX+170+offset,mouseY-295-offset,
      mouseX+170+offset,mouseY-294-offset,
      mouseX+19+offset,mouseY-48-offset);
  ellipse(mouseX+17+offset,mouseY-51-offset,6,7);
  
  
  if(flvl <= fmin){
    fill(255);
  }else{
    fill(liquid);
  }
  
  // fill level indicator
  noStroke();
  /*
  quad(mouseX-30+offset,mouseY-10-offset,
      mouseX-30+offset,mouseY-(flvl)-10-offset,
      mouseX-25+offset,mouseY-(flvl)-10-offset,
      mouseX-25+offset,mouseY-10-offset);
 */     
  int iLvl = int(((float)flvl)/((float)fmax) * 1000);
  quad(0, 580,
      iLvl, 580,
      iLvl, 600,
      0, 600); 
  //println(int(((float)flvl)/((float)fmax) * 1000));
}

//NAPKIN DRAWING STUFF
//void drawStraw() { 
//  fill(225);
//  noStroke();
//  ellipse(mouseX,mouseY,13,13);
//  fill(255);
//  stroke(0);
//  quad(mouseX-5+offset,mouseY-5-offset,
//      mouseX+60+offset,mouseY-120-offset,
//      mouseX+77+offset,mouseY-92-offset,
//      mouseX+5+offset,mouseY+5-offset);
//  for(int i=0; i<5;i++){
//    ellipse(mouseX+70+offset+i*3,mouseY-105-offset-i*2,28,38);
//  }
//  quad(mouseX+80+offset,mouseY-132-offset,
//      mouseX+120+offset,mouseY-151-offset,
//      mouseX+120+offset,mouseY-109-offset,
//      mouseX+83+offset,mouseY-94-offset);
//  noStroke();
//  quad(mouseX+79+offset,mouseY-130-offset,
//      mouseX+120+offset,mouseY-150-offset,
//      mouseX+120+offset,mouseY-108-offset,
//      mouseX+82+offset,mouseY-94-offset);
//  stroke(0);
// ellipse(mouseX+120+offset,mouseY-offset-130,32,42);
//  if(flvl <= fmin){
//    fill(255);
//  }
//  else{
//    fill(liquid);
//  }
//  ellipse(mouseX+offset,mouseY-offset,13,13);
  
  // fill level indicator
//  noStroke();
//  quad(mouseX-5+offset,mouseY-2-offset,
//      mouseX+(flvl/2)+offset,mouseY-(flvl)-offset,
//      mouseX+(flvl*3/4)+offset,mouseY-(flvl*7/8)-offset,
//      mouseX+5+offset,mouseY+5-offset);
  
//} // -- End of DrawStraw --

void drawColorMenu(){
   // shadow
//  int shadowOffset = 4;
//  fill(225);
//  noStroke();
//  rect(xalign+shadowOffset,yalign+shadowOffset,boxSize,boxSize*(11/2));
  
    // choices
//  stroke(0);
//  fill(choice1);
//  rect(xalign,yalign,boxSize,boxSize);
//  fill(choice2);
//  rect(xalign,yalign+boxSize*(3/2),boxSize,boxSize);
 // fill(choice3);
//  rect(xalign,yalign+boxSize*(5/2),boxSize,boxSize);
//  fill(choice4);
//  rect(xalign,yalign+boxSize*(7/2),boxSize,boxSize);
//  fill(choice5);
//  rect(xalign,yalign+boxSize*(9/2),boxSize,boxSize); 
  
  stroke(255);
  fill(choice1);
  ellipse(xPallete,yPallete,45,35);
  stroke(255);
  fill(choice2);
  ellipse(xPallete + 60,yPallete-10,45,35);
  stroke(255);
  fill(choice3);
  ellipse(xPallete + 120,yPallete-10,45,35);
  stroke(255);
  fill(choice4);
  ellipse(xPallete + 180,yPallete,45,35);
  
} // -- End of drawColorMenu
//capjdflasjdlasjdlasjdlasjdlkjdddddddddddddddd


void drawBackground(){
  background(color(255,255,255));
  
  // napkin
//  fill(175);
//  stroke(175);
//  quad(10,50,460,14,450,530,10,480);
//  fill(255);
//  stroke(255);
//  quad(10,50,460,14,430,530,-30,450);
  
  // cup
  
  
    for (int i=0; i<10; i++){
    color cupColor = color(153-i*10,179-i*10,204-i*10);
    fill(cupColor);
    stroke(cupColor);
    rect(375,0-i*5,250,110);
  }
  fill(255);
  rect(390,0,220,60);
  fill(color(50,60,100));
  stroke(80);
  rect(395,0,210,55);
  fill(liquid);
  stroke(160);
  rect(400,0,200,50);
    
  //for (int i=0; i<10; i++){
  //  color cupColor = color(153-i*10,179-i*10,204-i*10);
  //  fill(cupColor);
  //  stroke(cupColor);
  //  ellipse(475-i*2,0-i*5,300,300);
 // }
 // fill(255);
 // ellipse(460,-20,280,280);
 // fill(color(79,119,156));
 // stroke(80);
 // ellipse(460,-20,270,270);
 // fill(liquid);
 // stroke(160);
 // ellipse(460,-2,237,230);
    
}



//void drawBackground(){
//  background(color(102,51,0));
  
  // napkin
//  fill(175);
//  stroke(175);
//  quad(10,50,460,14,450,530,10,480);
//  fill(255);
//  stroke(255);
//  quad(10,50,460,14,430,530,-30,450);
  
  // cup
//  for (int i=0; i<10; i++){
//    color cupColor = color(153-i*10,179-i*10,204-i*10);
//    fill(cupColor);
//    stroke(cupColor);
//    ellipse(475-i*2,0-i*5,300,300);
//  }
//  fill(255);
//  ellipse(460,-20,280,280);
//  fill(color(79,119,156));
//  stroke(80);
//  ellipse(460,-20,270,270);
//  fill(liquid);
//  stroke(160);
//  ellipse(460,-2,237,230);
    
//} // --- End of drawBackground ---

class Effect{
  private int x;
  private int y;
  private float xOffset;
  private float yOffset;
  private int spread;
  private float d;
  private color baseColor;
  private float bRed;
  private float bGreen;
  private float bBlue;
  private float redShift;
  private float greenShift;
  private float blueShift;
  private int t;
  private boolean blended;
  
  
  Effect(int x, int y, color baseColor, int spread, boolean blended){
   this.x = x;
   this.y = y;
   this.xOffset = random(dOffset*2)-dOffset;
   this.yOffset = random(dOffset*2)-dOffset;
   this.spread = spread;
   this.d = random(dOffset*2)+dOffset;
   this.baseColor = baseColor; 
   this.bRed = red(baseColor);
   this.bGreen = green(baseColor);
   this.bBlue = blue(baseColor);
   this.blended = blended;
  }
  
  Effect(int x, int y, float xOffset, float yOffset, color baseColor, int spread, boolean blended){
   this.x = x;
   this.y = y;
   this.xOffset = xOffset;
   this.yOffset = yOffset;
   this.spread = spread;
   this.d = random(dOffset*2)+dOffset;
   this.baseColor = baseColor; 
   this.bRed = red(baseColor);
   this.bGreen = green(baseColor);
   this.bBlue = blue(baseColor);
   this.blended = blended;
  }
  
  void drawEffect(){
    noStroke();
    
   if(spread < 90){
     spread++;
   }
   int f = spread/10;
   
   if(blended){
     t = 4;
   }
   else{
     t = 2;
   }
   // spread effect
   //for(int t=0; t < 9; t++){
     redShift = (f-t)*(w-bRed)/15;
     greenShift = (f-t)*(w-bGreen)/15;
     blueShift = (f-t)*(w-bBlue)/15;
   
     baseColor = color(bRed+redShift,bGreen+greenShift,bBlue+blueShift);
     fill(baseColor);
   
   //  ellipse(x+xOffset,y+yOffset,d+(f-t)*2,d+(f-t)*2);
   //  ellipse(x,y,d+10,d+3);
       ellipse(x+xOffset, y+yOffset, 5,5);
       ellipse(x+xOffset, y+yOffset+10, 4,5);
       ellipse(x+xOffset, y+yOffset+10, 13.5,12);
       ellipse(x,y,4,4);
       ellipse(x-xOffset, y-yOffset, 2,1);
       ellipse(x-xOffset, y-yOffset-8, 1,1);
       ellipse(x-xOffset, y+yOffset+25, 2,1);
       ellipse(x-xOffset-10, y-yOffset, 6,0.5);
       ellipse(x+xOffset+5, y-yOffset+2, 1,4);
 //}
   
   
  }
  
  int getX(){
    return this.x;
  }
  
  int getY(){
    return this.y;
  }
  
  float getXOffset(){
    return this.xOffset;
  }
  
  float getYOffset(){
    return this.yOffset;
  }

  
  color getColor(){
    return this.baseColor;
  }
  
  boolean isBlended(){
    return this.blended;
  }
  
  int getSpread(){
    return this.spread;
  }
  
  
} // --- End of Effect Class ---

String getTheme() {
  String[] themeArray = {"clowns", "sadness", "happiness", "love", "dogs", "Batman", "home", "travel", "art", "cars", "pizza", "war", "peace", 
  "music", "basketball", "baseball", "soccer", "family", "winter", "spring", "summer", "autumn"};
  return themeArray[int(random(22))];
}  