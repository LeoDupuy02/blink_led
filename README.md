**Objective :**
Create an ensemble of functions to make a led blink according to the Fibonacci sequence and controlled by a button.

**Details :**
The code is made for an ESP32-C3 (RISC-V architecture). It combines codes in C and in Asssembly langage.
To be flashed on the ESP it needs to be used (compiled) with ESP-IDF framework.
Button pin : GPIO6
LED pin : GPIO8

**Branchs :**
- The main branch code generates the fibonacci sequence first and then blink the led if the button is pressed.
- the build_.. branch code generates the fibonacci sequence term by term and blink the led each time the button is pressed.
