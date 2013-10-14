import processing.pdf.*;
SimpleSpreadsheetManager sm;


String[] months = {
  "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
};


String line;
PShape cross;
int MAX_LINES = 100;
int monthsStartx = 1400;
int monthsStarty = 80;
int currentIndex = 3 ;

int numRows;

//TEXT RADIUS
int w=620;

//ARRAYS FROM SPREADSHEET
String[] name; 
int[] start;
int[] end;
color[] c;
int[] index;

String heading;

void setup() {
  size(2100, 2000, PDF, "clock.pdf");

  background(255);
  smooth();
  // Open the file from the createWriter() example
  //reader = createReader("data.csv");
  cross = loadShape("cross.svg");
  shapeMode(CENTER);
  strokeCap(SQUARE);
  ellipseMode(CENTER);
  PFont f = createFont("Futura-Medium-48.vlw",12);
  

  //READ FROM GOOGLE SPREADSHEET
  SimpleSpreadsheetManager sm = new SimpleSpreadsheetManager();
  sm.init("Phenologydata", "email", "password");
  sm.fetchSheetByKey("0AspZRjIECCvPdDRrMmd0WHF4VVk2VzM0Rmd4Unpzc0E", 0);

  numRows = sm.currentTotalRows-1;
  println(numRows);
  name = new String[numRows];
  start = new int[numRows];
  end = new int[numRows];
  c = new int[numRows];  
  index = new int[numRows];

  //PUT COLUMNS OF GOOGLE SPREADSHEET INTO ARRAYS
  //USING GOOGLE SPREAD SHEET CALLED SM
  for (int i=0;i < numRows; i++) {
    index[i] = int(sm.getCellValue(0, i+1));
    name[i] = sm.getCellValue(1, i+1);
    start[i] = int(sm.getCellValue(4, i+1))-1;
    end[i] = int(sm.getCellValue(5, i+1));
    c[i] = unhex("FF"+sm.getCellValue(6, i+1));
    
  }
heading = (sm.getCellValue(0,0));
}


void draw() {

  pushMatrix();
  translate(width/2-400, height/2-200);
  rotate(-PI/2);

  //USING GOOGLE SPREAD SHEET CALLED SM
  for (int i=0;i < numRows-1; i++) {
    currentIndex=index[i];
    noStroke();
    drawArc(new PVector(0, 0), currentIndex*22, 0, TWO_PI);
    noFill();
    stroke(c[i]);
    strokeWeight(10);
    float startTheta = map(start[i], 0, 12, 0, TWO_PI);
    float endTheta = map(end[i], 0, 12, 0, TWO_PI);
    drawArc(new PVector(0, 0), currentIndex*22, startTheta, endTheta);
    //currentIndex++;
  }


  drawCross();
  popMatrix();



  drawMonths();
  drawCircleMonths();
  drawSmallLine(); 



  PImage title = loadImage("title.png");
  title.resize(650, 0);
  image(title, 0, 0);
 textSize(32);
  fill(150);
  text(heading,95,120);

  exit();
}

void drawLine(PVector start, float l1, float l2, int j) {
  strokeWeight(0);
  stroke(j, j, j);
  line(0, -l1, 0, -l2);
}


//ARC FUNCTION
void drawArc(PVector center, float size, float startAngle, float stopAngle) {
  //arc(x, y, width, height, start, stop)
  arc(center.x, center.y, size, size, startAngle, stopAngle);
}

void drawSmallLine() {
  float s = 0;
  for (int i=0;i<360;i++) {
    pushMatrix();
    translate(width/2-400, height/2-200);
    rotate( s );
    drawLine(new PVector(0, 0), w-10, w-2, 0); 

    popMatrix();
    //DRAW LINE START Y AND END Y
    s+= (TWO_PI/360);
  }
}


  void drawCircleMonths() {
    float t = 0;

    for (int i=0; i<months.length; i++) {    

      fill(0);
      textSize(12);

      pushMatrix();
      translate(width/2-400, height/2-200);
      rotate( t );
      //MULTIPLIER DEFINES RADIUS 
      text(months[i], 2, -w);
      drawLine(new PVector(0, 0), w-10, w+10, 0); 

      popMatrix();
      //DRAW LINE START Y AND END Y

      t+= (TWO_PI/12);
    }
  }

  //X CLINIC CROSS 
  void drawCross() {
    pushMatrix();
    scale(2);
    shape(cross, 0, 0);
    popMatrix();
  }

  void drawMonths() {
    currentIndex = 0;
    //RUN THROUGH DATA ARRAYS
    for (int i=0; i<=numRows-1; i++) {

currentIndex= index[i];
      //GET NAME, START, END, COLOUR
      //NAME OF SPECIES
      noStroke();      
      fill(c[i]);
      ellipse(monthsStartx+(35*start[i]), monthsStarty+40+(currentIndex*30), 20, 20);
      fill(0);
      textSize(12);
      text(name[i], monthsStartx+15+(35*start[i]), monthsStarty+43+(currentIndex*30));
      //currentIndex++;
    }

    for (int i=0; i<months.length; i++) {
      pushMatrix();
      translate(monthsStartx+(i*35), monthsStarty);
      fill(0);
      rotate(-PI/2);
      text(months[i], 0, 0);
      popMatrix();
    }
    println("MonthsDrawn");
  }

