/**
 * Words. 
 * 
 * The text() function is used for writing words to the screen.
 * The letters can be aligned left, center, or right with the 
 * textAlign() function. 
 */

PFont f;
PFont g;
boolean cont = false;
boolean guessing = true;

String[] actions= {
  "Hit", "Stay", "Double", "Split"
};

void setup() {
  size(640, 360);

  // Create the font
  // printArray(PFont.list());
  f = createFont("Georgia", 24);
  textFont(f);

  g = createFont("Georgia", 30);

  screenSetup();
}

void draw() {
  if (mousePressed) {
    screenSetup();
    tableSetup(width);
    for (int i = 0; i < actions.length; i++) {
      if (nearWord(actions[i])) {
        bigBoxAround(actions[i], true);
      }
    }
  }
}

void tableSetup(float x) {
  textFont(f);
  String myCardOne=randCard();
  String myCardTwo=randCard();
  String dealerCardOne=randCard();
  fill(204);
  String bestAction=basicStrategy(cardValue(myCardOne), cardValue(myCardTwo), cardValue(dealerCardOne));
  text(bestAction, x/2, 150);
  text(myCardOne+"  "+myCardTwo, x/4, 100);
  text(dealerCardOne, 3*x/4, 100);
  if (bestAction!="Blackjack!") {
    smallBoxAround(bestAction);
  }
  delay(500);
}

String basicStrategy(int firstCard, int secondCard, int dealerCard) {
  if (firstCard==secondCard) { 
    if (firstCard==2||firstCard==3) {
      if (dealerCard>7) {
        return "Hit";
      } else {
        return "Split";
      }
    } else if (firstCard==4) {
      if (dealerCard==5||dealerCard==6) {
        return "Split";
      } else {
        return "Hit";
      }
    } else if (firstCard==5) {
      if (dealerCard<10) {
        return "Split";
      } else {
        return "Hit";
      }
    } else if (firstCard==6) {
      if (dealerCard<7) {
        return "Split";
      } else {
        return "Hit";
      }
    } else if (firstCard==7) {
      if (dealerCard<8) {
        return "Split";
      } else {
        return "Hit";
      }
    } else if (firstCard==8) {
      return "Split";
    } else if (firstCard==9) {
      if (dealerCard<10&&dealerCard!=7) {
        return "Split";
      } else {
        return "Stay";
      }
    } else if (firstCard==10) {
      return "Stay";
    } else if (firstCard==11) {
      return "Split";
    }
  }
  int twoSum=firstCard+secondCard;
  if (twoSum==21) {
    return "Blackjack!";
  }
  if (firstCard!=11&&secondCard!=11) { //No Ace
    if (twoSum<9) {
      return "Hit";
    } else if (twoSum==9&&dealerCard>2&&dealerCard<7) {
      return "Double";
    } else if (twoSum==9) {
      return "Hit";
    } else if (twoSum==10&&dealerCard<10) {
      return "Double";
    } else if (twoSum==10) {
      return "Hit";
    } else if (twoSum==11&&dealerCard<11) {
      return "Double";
    } else if (twoSum==11) {
      return "Hit";
    } else if (twoSum==12&&dealerCard>3&&dealerCard<7) {
      return "Stay";
    } else if (twoSum==12) {
      return "Hit";
    } else if (twoSum>12&&twoSum<17&&dealerCard>6) {
      return "Hit";
    } else if (twoSum>12) {
      return "Stay";
    } else {
      return "I don't know";
    }
  } else { //Dealt an ace
    int otherCard;
    if (firstCard==11) {
      otherCard=secondCard;
    } else {
      otherCard=firstCard;
    }
    if (otherCard==2||otherCard==3) {
      if (dealerCard>4&&dealerCard<7) {
        return "Double";
      } else {
        return "Hit";
      }
    } else if (otherCard==4||otherCard==5) {
      if (dealerCard>3&&dealerCard<7) {
        return "Double";
      } else {
        return "Hit";
      }
    } else if (otherCard==6) {
      if (dealerCard>2&&dealerCard<7) {
        return "Double";
      } else {
        return "Hit";
      }
    } else if (otherCard==7) {
      if (dealerCard>2&&dealerCard<7) {
        return "Double";
      } else if (dealerCard<9) {
        return "Stay";
      } else {
        return "Hit";
      }
    } else if (otherCard>7) {
      return "Stay";
    } else {
      return "What's going on?";
    }
  }
}

int cardValue(String card) {
  int value;
  if (card=="A") {
    value=11;
  } else if (card=="K" || card=="Q" || card=="J") {
    value=10;
  } else {
    value=parseInt(card);
  }
  return value;
}

String randCard() {
  String[] cardList= { 
    "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"
  };
  int index= int(random(cardList.length));
  return cardList[index];
}

void screenSetup() {
  background(102);
  fill(204);
  textAlign(CENTER);
  textFont(g);
  text("My Cards", width/4, 65);
  text("Dealer Card", 3*width/4, 65);

  for (int i = 0; i < actions.length; i++) {
    text(actions[i], boxX(actions[i]), boxY(actions[i]));
  }
}

void smallBoxAround(String action) {
  int cX=boxX(action);
  int cY=boxY(action);  
  strokeWeight(10);
  stroke (0);
  line(cX-60, cY-40, cX+60, cY-40);
  line(cX+60, cY-40, cX+60, cY+20);
  line(cX+60, cY+20, cX-60, cY+20);
  line(cX-60, cY+20, cX-60, cY-40);
}

void bigBoxAround(String action, boolean correct) {
  int cX=boxX(action);
  int cY=boxY(action);  
  strokeWeight(10);
  if (correct) {
    stroke (0, 255, 0);
  } else {
    stroke (255, 0, 0);
  }
  line(cX-70, cY-50, cX+70, cY-50);
  line(cX+70, cY-50, cX+70, cY+30);
  line(cX+70, cY+30, cX-70, cY+30);
  line(cX-70, cY+30, cX-70, cY-50);
}

int boxX(String action) {
  if (action=="Hit" || action=="Double") {
    return width/4;
  } else if (action=="Stay"||action=="Split") {
    return width*3/4;
  } else {
    return 0;
  }
}

int boxY(String action) {
  if (action=="Hit" || action=="Stay") {
    return height*5/8;
  } else if (action=="Double"||action=="Split") {
    return height*7/8;
  } else {
    return 0;
  }
}

boolean inRegion(int minX, int minY, int maxX, int maxY) {
  if (minX<mouseX&&mouseX<maxX) {
    if (minY<mouseY&&mouseY<maxY) {
      return true;
    }
  }
  return false;
}

boolean nearWord(String action) {
  int cX=boxX(action);
  int cY=boxY(action);
  return inRegion(cX-70, cY-50, cX+70, cY+30);
}