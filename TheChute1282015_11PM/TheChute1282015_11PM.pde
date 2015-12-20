int noOfDecks=2;
int noOfCards=52;
int cardIndex=0;

Card[] deck=new Card[noOfCards*noOfDecks];
String[] suits={"Hearts", "Clubs", "Diamonds", "Spades"};

void setup() {
  size(200, 200);

  for (int index=0; index<(noOfCards*noOfDecks); index++) { //set up all cards in order
    int s=index%4;
    int v=(index%noOfCards-s)/4+2;
    deck[index]=new Card(v, suits[s]);
  }

  // Set up 3 players and Dealer
  Player Lenny=new Player("Lenny");
  Player Me=new Player("Me");
  Player Carl=new Player("Carl");
  Player Dealer=new Player("Dealer");
}

class Card { //A card has a value and a suit
  int rank;
  String suit;
  Card(int r, String s) {
    rank=r;
    suit=s;
  }
  void display() { // shows both the value and suit of card
    print(rank);
    println(suit);
  }
}

class Hand {
  Card[] cards={}; // Start hand with zero cards

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

  int value() {
    int v=0; //initialize value "v" at zero;
    int aceCount=0;
    for (Card c : cards) {
      v=v+valueRank(c.rank);
      if (c.rank==14) {
        aceCount++;
      }
    }
    if (aceCount==0) {
      return v;
    } else {
      if (v>21) {
        v=v-10*aceCount;
      } 
      return v;
    }
  }

  void display() { // Show all cards currently in a hand
    for (Card c : cards) {
      c.display();
    }
  }
}

class Player { // Each player has a name 
  String name;
  Hand[] hands={}; // Starts out with zero hands

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