Table hardTable;
Table softTable;
Table splitTable;
PFont f;

boolean surrenderAllowed=false;
boolean splitToDoubleAllowed=false;

int noOfDecks=2;
int noOfCards=52;
int cardIndex=0;

Card[] deck=new Card[noOfCards*noOfDecks];
String[] suits= {
  "Hearts", "Clubs", "Diamonds", "Spades"
};

void setup() {
  size(200, 200);
  f = createFont("Georgia", 72);
  textFont(f);
  textAlign(CENTER);

  hardTable = loadTable("BasicStrategyHard.csv", "header");
  softTable = loadTable("BasicStrategySoft.csv", "header");
  splitTable = loadTable("BasicStrategySplit.csv", "header");

  for (int index=0; index< (noOfCards*noOfDecks); index++) { //set up all cards in order
    int s=index%4;
    int v=(index%noOfCards-s)/4+2;
    deck[index]=new Card(v, suits[s]);
  }
  //deck=shuff(deck); // Shuffle the deck

  //Player Lenny=new Player("Lenny");
  //Player Me=new Player("Me");
  //Player Carl=new Player("Carl");
  //Player Dealer=new Player("Dealer");

  Hand d1= new Hand();
  print("Dealer ");
  d1.hit();

  Hand h1= new Hand();
  h1.hit();
  h1.hit();

  //while (dealerStrategy (d1.value ()).equals("H")) {
  //  d1.hit();
  //  println(d1.value());
  //}
  while (h1.action(d1.value()).equals("H")) {
    println(h1.value());
    h1.hit();
  }
  println(h1.value());
  println(h1.action(d1.value()));

  //String action=(basicStrategy(dealerCard, myHandVal, isSoft, canSplit));
  //text(action, 100, 100);
  println("Done");
}

class Card { //A card has a value and a suit
  int rank;
  String suit;
  Card(int r, String s) {
    rank=r;
    suit=s;
  }
  void display() { // shows both the value and suit of card
    print(nameRank(rank));
    println(suit);
  }
}

class Hand {
  Card[] cards= {
  }; // Start hand with zero cards
  
  boolean isSoft=(value()==rawVal)&&aceCount>0;
  boolean canSplit=canSplit();
  
  Hand () { // No parameters to make a hand.
  }

  void addCard(Card c) { // Add a card "c" to a hand
    Card[] newCards= new Card[cards.length+1];
    for (int i=0; i<cards.length; i++) {
      newCards[i]=cards[i];
    }
    cards=newCards;
    cards[cards.length-1]=c;
  }  

  void hit() {
    addCard(deck[cardIndex]);
    deck[cardIndex].display();
    cardIndex++;
  }

  boolean canSplit() {
    String c0rank=nameRank(cards[0].rank);
    String c1rank=nameRank(cards[1].rank);
    boolean two= (cards.length==2);
    boolean match=c0rank.equals(c1rank);
    boolean b= two&&match;
    println("Can Split");
    return b;
  }

  int value() {
    int v=0; //initialize value "v" at zero;
    int aceCount=0;
    for (Card c : cards) {
      v=v+valueRank(c.rank);
      if (c.rank==14) {
        aceCount++;
      }
    } 
    while (v>21 && aceCount>0) {
      v=v-10;
      aceCount--;
    }
    return v;
  }

  void display() { // Show all cards currently in a hand
    for (Card c : cards) {
      c.display();
    }
  }

  String action(int dealerCard) {
    int aceCount=0;
    int rawVal=0;
    for (Card c : cards) {
      rawVal=rawVal+valueRank(c.rank);
      if (c.rank==14) {
        aceCount++;
      }
    }
    if (isSoft) {
      println("Soft");
    }
    return basicStrategy(dealerCard, value(), isSoft, canSplit());
  }
}

class Player { // Each player has a name 
  String name;
  Hand[] hands= {
  }; // Starts out with zero hands

  Player (String n) {
    name=n;
  }

  void addHand() { // Give a player one more hand
    Hand[] newHands= new Hand[hands.length+1];
    for (int i=0; i<hands.length; i++) {
      newHands[i]=hands[i];
    }
    hands=newHands;
  }
}

String nameRank(int r) { // Based on number used to generate the card, the actual rank is returned.
  if (r<11) {
    return str(r);
  } else if (r==11) {
    return "J";
  } else if (r==12) {
    return "Q";
  } else if (r==13) {
    return "K";
  } else if (r==14) {
    return "A";
  }
  return "Nada";
}

int valueRank(int r) {
  if (r<11) {
    return r;
  } else if (r<14) {
    return 10;
  } else {
    return 11;
  }
}

Card[] shuff(Card[] d) {
  Card temp;
  for (int i=0; i<d.length; i++) {
    int tempIndex=int(random(0, noOfCards*noOfDecks));
    temp=d[tempIndex];
    d[tempIndex]=d[i];
    d[i]=temp;
    //disp(a);
  }
  return d;
}

String basicStrategy(int dealerCard, int myHandVal, boolean isSoft, boolean canSplit) {
  Table table;
  int row;
  int column=dealerCard-2;
  if (myHandVal==21) {
    return("S");
  }
  if (myHandVal>21) {
    return("B");
  }
  if (isSoft) {
    table=softTable;
    row=myHandVal-13;
  } else if (canSplit) {
    table=splitTable;
    row=round(myHandVal/2)-2;
  } else {
    table=hardTable;
    row=myHandVal-4;
  }
  String ans=table.getString(row, column);
  return ans;
}

String basicStrategyUpdate(Hand dealerHand, Hand playerHand) {//(int dealerCard, int myHandVal, boolean isSoft, boolean canSplit) {
  int dhVal=dealerHand.value();
  int phVal=playerHand.value();
  String strat;
  
  Table table;
  int row;
  int column=dhVal-2;
  if (phVal==21) {
    return("S");
  }
  if (phVal>21) {
    return("B");
  }
  if (playerHand.isSoft) {
    table=softTable;
    row=phVal-13;
  } else if (playerHand.canSplit) {
    table=splitTable;
    row=round(phVal/2)-2;
  } else {
    table=hardTable;
    row=phVal-4;
  }
  String tableVal=table.getString(row, column);
  if (!surrenderAllowed && tableVal.equals("RH")) {
    strat="H";
  } else if (!splitToDoubleAllowed && tableVal.equals("PH")) {
    strat="P";
  } else {
    strat=tableVal;
  }
  return strat;
}

String dealerStrategy(int dealerHandVal) {
  if (dealerHandVal<17) {
    return "H";
  } else if (dealerHandVal<22) {
    return "S";
  } else {
    return "B";
  }
}