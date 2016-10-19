int slider;

void setup() {
  //Begin serial communications
  Serial.begin(9600);
}

void loop() {
  
  //Wait for cSound to send a 'I am ready' byte  
  if(Serial.available() > 0){
    
  //Read the slider
  slider = analogRead(A0)/4;

  //Write the slider value devided by four so it fits in a single byte
  Serial.write(slider);

  //Delay the loop
  delay(10);
  
  }
  
}
