uint8_t buf[8] = { 
  0 };   /* Keyboard report buffer */

const uint8_t keyNull[8] = {0}; /*Keyboard release buffer*/

#define PIN_SNIP 5

#define KEY_LEFT_SHIFT 0x02

int state = 1;

void setup() {
  Serial.begin(9600);

  pinMode(PIN_SNIP, INPUT);
  // Enable internal pull-ups
  digitalWrite(PIN_SNIP, 1); 

  delay(200);
}

void loop() {
  state = digitalRead(PIN_SNIP);
  if (state != 1) {
    buf[0] = KEY_LEFT_SHIFT;   // Left Shift 
//    buf[2] = 227;    // CMD
//    buf[3] = 92;     // 4
    Serial.write(buf, 8); // Send keypress
    releaseKey();
  }
}

void releaseKey() 
{
  buf[0] = 0;
  buf[2] = 0;
  buf[3] = 0;
//  memcpy(buf, keyNull, 8);
  Serial.write(buf, 8);  // Release key  
}
