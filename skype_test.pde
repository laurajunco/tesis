import processing.video.*;
import processing.serial.*;
import cc.arduino.*;

Capture cam;
Arduino arduino;

int x, y, z;
int ax, ay, az;

int led = 13;
int tol = 25;

boolean firstTime = true;
boolean freeze = false;

void setup() {
  size(640, 360);

  String[] cameras = Capture.list();
  println(Arduino.list());

  //if (cameras.length == 0) {
  //  println("There are no cameras available for capture.");
  //  exit();
  //} else {
  //  println("Available cameras:");
  //  for (int i = 0; i < cameras.length; i++) {
  //    println(cameras[i]);
  //  }

  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino.pinMode(led, Arduino.OUTPUT);

  cam = new Capture(this, cameras[0]);
  cam.start();
}
void draw() {
  if (cam.available() == true) {
    cam.read();
  }

  if (firstTime) {

    ax = arduino.analogRead(0);
    ay = arduino.analogRead(1);
    az = arduino.analogRead(2);

    firstTime = false;
  } else {

    x = arduino.analogRead(0);
    y = arduino.analogRead(1);
    z = arduino.analogRead(2);

    if (abs(x - ax) > tol || abs(y - ay) > tol || abs(z - az) > tol) {

      arduino.digitalWrite(led, Arduino.HIGH);
      delay((int)random(200, 3000));
    }

    image(cam, 0, 0, 640, 360);
    arduino.digitalWrite(led, Arduino.LOW);
    
    ax = x;
    ay = y;
    az = z;
  }
}
