Table hardTable;
Table softTable;
Table splitTable;
PFont f;

void setup() {
  size(200, 200);
  f = createFont("Georgia", 72);
  textFont(f);
  textAlign(CENTER);

  hardTable = loadTable("BasicStrategyHard.csv", "header");
  softTable = loadTable("BasicStrategySoft.csv", "header");
  splitTable = loadTable("BasicStrategySplit.csv", "header");
  boolean isSoft=false;
  boolean canSplit=false;
  int dealerCard=11;
  int myHandVal=16;

  String action=(strategy(dealerCard, myHandVal, isSoft, canSplit));
  text(action,100, 100);
}

String strategy(int dealerCard, int myHandVal, boolean isSoft, boolean canSplit) {
  Table table;
  int row;
  int column=dealerCard-2;
  if (myHandVal==21) {
    return("S");
  }
  if (myHandVal>21) {
    return("L");
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

