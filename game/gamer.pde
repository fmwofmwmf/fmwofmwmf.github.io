int chairTall = 0;

float woodboost = 0;
int woodpile = 3000;
int wood = 1000;
float woodcounter = 0;
float woodcap = 30;

float rockboost = 0;
int rockpile = 0;
int rock = 30;
float rockcounter = 0;
float rockcap = 69;

int tables = 1;
int tablecost = 100;
int logs = 8;
int stools = 5;
int chairs = 2;
int Tstools = 0;

int areaProgress = 1;
int stackProgress = -1;
int chairProgress = -1;
int chairUpgrades = 0;
int rlevel = 0;

IntList stack;
int tab=1;
boolean reStack = false;

String notification = "nothing";

Button[] button = new Button[6];
Button[] cbutton = new Button[5];
Button[] sbutton = new Button[5];
Button[] rbutton = new Button[3];

void setup() {
  size(800, 600);
  stack=new IntList();

  button[0]=new Button(150, 0, 100, 25, 0, "Tree", "nothing", "other");
  button[1]=new Button(250, 0, 100, 25, 1, "Workbench", "nothing", "other");
  button[2]=new Button(350, 0, 100, 25, 2, "Empty Cave", "nothing", "other");
  button[3]=new Button(350, 100, 100, 25, 3, "Boost Wood", "nothing", "other");
  button[4]=new Button(350, 100, 100, 25, 4, "Put table", "nothing", "other");
  button[5]=new Button(350, 130, 100, 25, 5, "Add 20 wood", "nothing", "other");

  sbutton[0]=new Button(350, 65, 100, 25, 0, "Remove Stack", "nothing", "stack");
  sbutton[1]=new Button(175, 50, 100, 25, 1, "Stack Log", "nothing", "stack");
  sbutton[2]=new Button(175, 75, 100, 25, 2, "Stack Stool", "nothing", "stack");
  sbutton[3]=new Button(175, 100, 100, 25, 3, "Stack Chair", "nothing", "stack");
  sbutton[4]=new Button(175, 125, 100, 25, 4, "Stack TStool", "nothing", "stack");

  cbutton[0]=new Button(175, 250, 100, 100, 0, "Table", "100 wood", "chair");
  cbutton[1]=new Button(175, 50, 100, 100, 1, "log", "20 wood", "chair");
  cbutton[2]=new Button(275, 50, 100, 100, 2, "stool", "10 wood, 3 logs", "chair");
  cbutton[3]=new Button(375, 50, 100, 100, 3, "chair", "60 wood, 4 logs", "chair");
  cbutton[4]=new Button(475, 50, 100, 100, 4, "Tstool", "12 logs, 1 stool", "chair");
  
  rbutton[0]=new Button(175, 70, 100, 25, 1, "Shovel", "30 rock, 1 log,  1 screw", "advance");
  rbutton[1]=new Button(300, 70, 100, 25, 2, "Rock Stool", "60 rock, 3 screws", "advance");
  rbutton[2]=new Button(425, 70, 100, 25, 3, "Blueprint", "1 table, 1 design1", "advance");
}

void draw() {
  background(255);
  for (Button buttons : button) buttons.display();
  for (Button buttons : cbutton) buttons.display();
  for (Button buttons : sbutton) buttons.display();
  for (Button buttons : rbutton) buttons.display();

  line(150, 25, 800, 25);
  progress();

  stack();
  boost();
  harvest();
  resources();
  if (tab==1) {
    treeTab();
  } else if (tab==2) {
    chairTab();
  } else if (tab==3) {
    researchTab();
  }
  menu();
  notification();
}

//----------------Numbers
void progress() {
  //cProg
  if (logs>0 && chairProgress < 0) {
    chairProgress = 0;
  } else if (stools>0 && chairProgress < 1) {
    chairProgress = 1;
  } else if (chairs>0 && chairProgress < 2) {
    chairProgress = 2;
  } else if (Tstools>0 && chairProgress < 3) {
    chairProgress = 3;
  }
  //sProg
  if (chairTall>0 && stackProgress < 0) stackProgress = 0;
  //AProg

  if (wood>=100 && areaProgress < 2) {
    areaProgress = 2;
    notification="You found a saw while harvesting wood";
  } else if (chairTall>=5 && areaProgress < 3) {
    areaProgress = 3;
    notification="You have towered up to a cave entrance";
  }
}

void resources() {
  int down = 0;
  line(150, 0, 150, 600);
  noStroke();
  fill(0);
  text("Height: " + chairTall, 20, 20);
  text("Wood: " + wood, 20, 40);

  if (rlevel>2) {
    text("Rocks: " + rock, 20, 60); 
    down=20;
  }

  text("Tables: " + tables, 20, 80+down);
  if (chairProgress>=0) text("Logs: " + logs, 20, 100+down);
  if (chairProgress>=1) text("Stools: " + stools, 20, 120+down);
  if (chairProgress>=2) text("Chairs: " + chairs, 20, 140+down);
  if (chairProgress>=3) text("TStools: " + Tstools, 20, 160+down);
}

//-----------------Counters
void harvest() {
  if (woodpile>0) {
    woodcounter+=1;
    if (woodcounter>=woodcap) {
      wood+=floor(woodcounter/woodcap);
      woodpile-=floor(woodcounter/woodcap);
      woodcounter%=woodcap;
    }
  }
  if (rockpile>0) {
    rockcounter+=1;
    if (rockcounter>=rockcap) {
      rock+=floor(rockcounter/rockcap);
      rockpile-=floor(rockcounter/rockcap);
      rockcounter%=rockcap;
    }
  }
}

//-----------------Buttons

void menu() {
  if (areaProgress>=1)button[0].display=true;
  if (areaProgress>=2)button[1].display=true;
  if (areaProgress>=3)button[2].display=true;
}

void treeTab() {
  for (Button buttons : button) buttons.display=false;
  for (Button buttons : sbutton) buttons.display=false;
  for (Button buttons : cbutton) buttons.display=false;
  for (Button buttons : rbutton) buttons.display=false;

  button[3].display=true;
  if (stackProgress>=0) sbutton[0].display=true;
  if (chairProgress>=0) sbutton[1].display=true;
  if (chairProgress>=1) sbutton[2].display=true;
  if (chairProgress>=2) sbutton[3].display=true;
  if (chairProgress>=3) sbutton[4].display=true;
  text("Wood left:" + woodpile, 500, 100);

  if (rlevel>2) {
    button[5].display = true;
    fill(255);
    stroke(0);
    rect(500, 120, 100, 25);
    fill(200);
    rect(500, 120, rockpile, 25);
    fill(0);
    text("Rocks left:" + rockpile, 515, 125);
  }
}

void chairTab() {
  for (Button buttons : button) buttons.display=false;
  for (Button buttons : sbutton) buttons.display=false;
  for (Button buttons : cbutton) buttons.display=false;
  for (Button buttons : rbutton) buttons.display=false;

  if (areaProgress>=3) cbutton[0].display=true;
  cbutton[1].display=true;
  if (chairProgress>=0) cbutton[2].display=true;
  if (chairProgress>=1) cbutton[3].display=true;
  if (chairProgress>=2) cbutton[4].display=true;
}

void researchTab() {
  for (Button buttons : button) buttons.display=false;
  for (Button buttons : cbutton) buttons.display=false;
  for (Button buttons : sbutton) buttons.display=false;
  for (Button buttons : rbutton) buttons.display=false;
  
  if (areaProgress>=3) button[4].display=true;
  if (rlevel>=4) {
    rbutton[0].display=true;
    rbutton[1].display=true;
    rbutton[2].display=true;
  }
}

//-------------functions
void boost() {
  woodcap=30;
  if (woodboost>0) {
    woodboost--;
    woodcap*=0.5;
  }
}

void stack() {
  int logc = 0;
  int stoolc = 0;
  int chairc = 0;
  int Tstoolc = 0;
  int sheight = 0;
  for (int i = 0; i<stack.size(); i++) {
    String name = "ff";
    if (stack.get(i)==0) {
      name = "log";
      logc+=1;
      sheight+=1;
    } else if (stack.get(i)==1) {
      name = "stool";
      stoolc+=1;
      sheight+=1;
    } else if (stack.get(i)==2) {
      name = "chair";
      chairc+=1;
      sheight+=2;
    } else if (stack.get(i)==3) {
      name = "Tstool";
      Tstoolc+=1;
      sheight+=3;
    }
    fill(0);
    text(name, 700, 580-i*20);
  }
  chairTall=sheight;
  if (logc>2||stoolc>5) {
    collapse(logc, stoolc, chairc, Tstoolc, 0.5);
    notification="Your stack has collapsed. :(";
  }
  if (reStack&&chairTall!=0) {
    reStack=false;
    collapse(logc, stoolc, chairc, Tstoolc, 1);
    notification="Took down the stack.";
  }
}

void collapse(int ln_, int sn_, int cn_, int tn_, float re) {
  int ln = floor(ln_*re);
  int sn = floor(sn_*re);
  int cn = floor(cn_*re);
  int tn = floor(tn_*re);

  logs+=ln;
  stools+=sn;
  chairs+=cn;
  Tstools+=tn;
  stack.clear();
}

void notification() {
  if (notification!="nothing") {
    stroke(0);
    fill(255);
    rect(350, 250, 100, 100);
    fill(0);
    text(notification, 360, 260, 80, 80);
  }
}

void mousePressed() {
  notification="nothing";
  for (Button buttons : button) buttons.press();
  for (Button buttons : cbutton) buttons.press();
  for (Button buttons : sbutton) buttons.press();
  for (Button buttons : rbutton) buttons.press();
}

class Button {
  PVector position = new PVector(0, 0);
  PVector size = new PVector(0, 0);
  int function;
  boolean display=false;
  String text = "nothing";
  String cost = "nothing";
  String type = "nothing";
  Button(int px, int py, int sx, int sy, int fn, String tx, String cs, String tp) {
    position.x = px;
    position.y = py;
    size.x = sx;
    size.y = sy;
    function = fn;
    text=tx;
    cost=cs;
    type=tp;
  }

  void press() {
    if (mouseX>position.x&&mouseX<position.x+size.x&&
      mouseY>position.y&&mouseY<position.y+size.y&&display) {
      if (type=="other") {
        if (function==0) {
          tab=1;
        } else if (function==1) {
          tab=2;
        } else if (function==2) {
          if (chairTall>=5) 
            tab=3;
        } else if (function==3) {
          if (woodboost==0) {
            woodboost=100;
          }
        } else if (function==4) {
          if (tables>=1&&rlevel==0) {
            tables-=1;
            rlevel=1;
            text="Put chair";
          } else if (chairs>=1&&rlevel==1) {
            chairs-=1;
            rlevel=2;
            size.y=40;
            text="Create rocking chair";
            cost="150 wood, 1 chair";
          } else if (chairs>=1&&wood>150&&rlevel==2) {
            chairs-=1;
            wood-=150;
            rlevel=3;
            size.y=25;
            text="Finish big table";
            cost="30 rocks, 8 logs";
          } else if (rock>=30&&logs>=8&&rlevel==3) {
            rock-=30;
            logs-=8;
            rlevel=4;
            position.x = 425;
            position.y = 40;
          }
        } else if (function==5) {
          if (wood>=20 && rockpile<100) {
            rockpile+=10;
            wood-=20;
            if (rockpile>100) {
              rockpile=100;
            }
          }
        } else if (function==6) {
        }
      } else if (type=="chair") {
        if (function==0) {
          if (wood>=tablecost) {
            tables+=1;
            wood-=tablecost;
            tablecost*=1.5;
            cost=str(tablecost)+" wood";
          }
        } else if (function==1) {
          if (wood>=20) {
            logs+=1;
            wood-=20;
          }
        } else if (function==2) {
          if (wood>=10 && logs>=3) {
            logs-=3;
            wood-=10;
            stools+=1;
          }
        } else if (function==3) {
          if (wood>=60 && logs>=4) {
            logs-=4;
            wood-=60;
            chairs+=1;
          }
        } else if (function==4) {
          if (logs>=12 && stools>=1) {
            logs-=12;
            stools-=1;
            Tstools+=1;
          }
        } else if (function==5) {
        } else if (function==6) {
        }
      } else if (type=="stack") {
        if (function==0) {
          reStack = true;
        } else if (function==1) {
          if (logs>0) {
            stack.append(0);
            logs--;
          }
        } else if (function==2) {
          if (stools>0) {
            stack.append(1);
            stools--;
          }
        } else if (function==3) {
          if (chairs>0) {
            stack.append(2);
            chairs--;
          }
        } else if (function==4) {
          if (Tstools>0) {
            stack.append(3);
            Tstools--;
          }
        } else if (function==5) {
        } else if (function==6) {
        }
      } else if (type=="advance") {
        if (function==0) {
        } else if (function==1) {
          
        } else if (function==2) {
        } else if (function==3) {
        }
      }
    }
  }

  void display() {
    if (display) {
      if (type=="other") {
        if (function==tab-1) {
          fill(200);
        } else {
          fill(255);
        }
        stroke(0);
        rect(position.x, position.y, size.x, size.y);
        if (function==3) {
          fill(200);
          rect(position.x, position.y, woodboost, size.y);
        }
        if (text!="nothing") {
          fill(0);
          text(text, position.x+10, position.y+5, size.x, size.y);
        }
        if (cost!="nothing") {
          fill(0);
          text(cost, position.x+10, position.y+size.y+5, size.x, size.y*2);
        }
      } else if (type=="chair") {
        fill(255);
        stroke(0);
        rect(position.x, position.y, size.x, size.y);
        textAlign(CENTER, TOP);
        fill(0);
        text(text, position.x+50, position.y+20);
        text(cost, position.x+50, position.y+80);
        textAlign(LEFT, TOP);
      } else if (type=="stack") {
        if (display) {
          fill(255);
          stroke(0);
          rect(position.x, position.y, size.x, size.y);
          fill(0);
          textAlign(LEFT, TOP);
          text(text, position.x+10, position.y+5);
        }
      } else if (type=="advance") {
        fill(255);
        stroke(0);
        rect(position.x, position.y, size.x, size.y);
        fill(0);
        if (text!="nothing") {
          text(text, position.x+10, position.y+5, size.x, size.y);
        }
        if (cost!="nothing") {
          text(cost, position.x+10, position.y+size.y+5, size.x, size.y*2);
        }
      }
    }
  }
}