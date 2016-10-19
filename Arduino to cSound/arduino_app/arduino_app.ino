int slider;

void setup() {
  //Begin serial communications
  Serial.begin(9600);
}

void loop() {
  //Read the slider
  slider = analogRead(A0)/4;

  //
  Serial.println(slider);

  delay(10);
  
}
