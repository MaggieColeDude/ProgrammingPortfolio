// Margaret Cole | 28 Nov 2023 | Space game
import processing.sound.*;
SoundFile laser;

SpaceShip s1;
ArrayList<Rock> rocks = new ArrayList<Rock>();
ArrayList<Laser> lasers = new ArrayList<Laser>();
ArrayList<PowUp> powups = new ArrayList<PowUp>();
ArrayList<Star> stars = new ArrayList<Star>();
// Star[] stars;
Timer rockTimer, puTimer;
int score, level;
boolean play;

void setup() {
  size(800, 800);
  laser = new SoundFile(this, "laser2.wav");
  //Play
  play = false;
  //RockTimer
  rockTimer = new Timer(500);
  rockTimer.start();
  //PowTimer
  puTimer = new Timer(5000);
  puTimer.start();
  score = 0;
  level = 1;
  s1 = new SpaceShip(width/2, height/2);
}

void draw() {
  if (!play) {
    startScreen();
  } else {
    background (0);
    // Add Star
    stars.add(new Star(int(random(width)), -10));

    // Display Stars
    for (int i = 0; i < stars.size(); i++) {
      Star s = stars.get(i);
      if (s.reachedBottom()) {
        stars.remove(s);
      } else {
        s.display();
        s.move();
      }
    }

    //Level
    if (frameCount % 1000 == 10) {
      level++;
    }

    //Power Up Distrabution
    if (puTimer.isFinished()) {
      powups.add(new PowUp(int(random(width)), -100));
      puTimer.start();
    }

    //Render PowUp
    for (int i = 0; i < powups.size(); i++) {
      PowUp pu = powups.get(i);
      if (s1.intersect(pu)) {
        if (pu.type == 'a') {
          s1.ammo+=pu.val;
        } else if (pu.type == 'h') {
          s1.health+=pu.val;
        } else if (pu.type == 't') {
          if (s1.turretCount < 3 ) {
            s1.turretCount+=pu.val;
          }
        }
        powups.remove(pu);
      }
      if (pu.reachedBottom()) {
        powups.remove(pu);
      } else {
        pu.display();
        pu.move();
      }
    }

    //Rock Distrabution
    if (rockTimer.isFinished()) {
      rocks.add(new Rock(int(random(width)), -100));
      rockTimer.start();
    }

    //Render Rock
    for (int i = 0; i < rocks.size(); i++) {
      Rock r = rocks.get(i);
      if (s1.intersect(r)) {
        s1.health-=r.diam;
        score+=r.diam;
        rocks.remove(r);
      }
      if (r.reachedBottom()) {
        rocks.remove(r);
        score -= 50;
      } else {
        r.display();
        r.move();
      }
    }

    //rendering lasers
    for (int i = 0; i < lasers.size(); i++) {
      Laser l = lasers.get(i);
      for (int j = 0; j < rocks.size(); j++) {
        //Rock
        Rock r = rocks.get(j);
        if (l.intersect(r)) {
          r.diam-=20;
          if (r.diam<20) {
            rocks.remove(r);
          }
          score+=r.health;
          lasers.remove(l);
        }
      }
      if (l.reachedTop()) {
        lasers.remove(l);
      }
      l.display();
      l.move();
    }
    //SpaceShip
    s1.display();
    s1.move(mouseX, mouseY);

    //ScoreBoard
    infoPanel();

    //gameOver
    if (s1.health<1) {
      gameOver();
    }
  }
}


void infoPanel() {
  fill(127, 127);
  rectMode(CENTER);
  rect(width/2, 20, width, 40);
  fill(255);
  textSize(25);
  text("Score:" + score, 100, 35);
  text("Health:" + s1.health, 300, 35);
  text("Ammo:" + s1.ammo, 500, 35);
  text("Level:" + level, width-120, 35);
}

void startScreen() {
  background (0);
  fill (255);
  textAlign(CENTER);
  textSize(44);
  text("Aye, Space game", width/2, 200);
  text("By Maggie cole", width/2, 300);
  text("Click to begin", width/2, 400);
  if (mousePressed) {
    play = true;
  }
}
void gameOver() {
  background (0);
  fill (255);
  textAlign(CENTER);
  textSize(44);
  text("Game Over", width/2, 200);
  text("Score: "+ score, width/2, 300);
  text("Level: "+ level, width/2, 400);
  text("You suck at this game!", width/2, 500);
  noLoop();
}


void ticker() {
}

void mousePressed() {
  if (s1.fire()) {
    laser.play();
    if (s1.turretCount == 1) {
      lasers.add(new Laser(s1.x, s1.y));
      s1.ammo--;
    } else if (s1.turretCount == 2) {
      lasers.add(new Laser(s1.x+15, s1. y));
      lasers.add(new Laser(s1.x-15, s1. y));
      s1.ammo -=2;
    } else if (s1.turretCount == 3) {
      lasers.add(new Laser(s1.x, s1.y));
      lasers.add(new Laser(s1.x+15, s1. y));
      lasers.add(new Laser(s1.x-15, s1. y));
      s1.ammo -=3;
    }
  }
}

//void keyPressed() {
//  if (key == ' ') {
//    if (s1.turretCount == 1) {
//      lasers.add(new Laser(s1.x, s1.y));
//      s1.ammo--;
//    } else if (s1.turretCount == 2) {
//      lasers.add(new Laser(s1.x+15, s1. y));
//      lasers.add(new Laser(s1.x-15, s1. y));
//      s1.ammo -=2;
//    } else if (s1.turretCount == 3) {
//      lasers.add(new Laser(s1.x, s1.y));
//      lasers.add(new Laser(s1.x+15, s1. y));
//      lasers.add(new Laser(s1.x-15, s1. y));
//      s1.ammo -=3;
//    }
//  }
//}
