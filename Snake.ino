int jxValue = 0;                      //Defining components
int jyValue = 0;
int bValue = 0;
const int buzzer = 9;

void setup()
{
  Serial.begin(9600);               //Communicating with components and software
  pinMode(2, INPUT_PULLUP);
  pinMode(buzzer, OUTPUT);
}

void loop()
{
  jxValue = analogRead(A0);         //Getting info from components
  jyValue = analogRead(A1);
  bValue = digitalRead(2);

  Serial.print(jxValue);            //Communicating data to software
  Serial.print(",");
  Serial.print(jyValue);
  Serial.print(",");
  Serial.print(bValue);
  Serial.print (",");
  Serial.print("\n");

  {
    if (Serial.available() > 0) {   //Gathering info from processing
      char buzzerState = Serial.read();

      if (buzzerState == '1') {     //Altering sounds
        tone(buzzer, 1750);
        delay(500);
        noTone(buzzer);
        delay(1000);
      }

      if (buzzerState == '0') {
        tone(buzzer, 1000);
        delay(4000);
        noTone(buzzer);
        delay(1000);
      }
    }
  }
}
