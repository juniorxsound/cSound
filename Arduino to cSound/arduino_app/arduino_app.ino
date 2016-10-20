int button = 4;
int slider;

int lastState;
int currentState;

void setup() {
  // enable serial communication
  Serial.begin(9600);

  pinMode(13, OUTPUT);

}

void loop() {
      currentState = digitalRead(4);
      
      if(currentState == 1 && lastState == 0){
        Serial.write("1");
      }
        // while we are here, get our knob value and send it to csound
        //int sensorValue = analogRead(A0);
        //Serial.write(sensorValue/4); // scale to 1-byte range (0-255)
       lastState = currentState;

}
