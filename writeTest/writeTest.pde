  
PrintWriter output;

void setup() {
  // Create a new file in the sketch directory
  output = createWriter("positions.csv"); 
}

void draw() {
  point(mouseX, mouseY);
  output.print(mouseX + ",");  // Write the X coordinate to the file
  output.println(mouseY);  // Write the Y coordinate to the file
}

void keyPressed() {
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  exit();  // Stops the program
}