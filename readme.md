# Tiny Ardunio Keyboard

Attempt to design and code a macro keyboard for a school project.

![](https://image.ibb.co/juFX3o/A1-Poster-Better-EST.jpg)

# Initialisation (Obseolete)

You will require a [DFU Programmer](https://www.arduino.cc/en/Hacking/DFUProgramming8U2) to flash your arduino as a keyboard.

Script is written for ATMEGA16U2

`firmware` is a directory for arduino firmwares that will be accessed by the script.

TODO: Write the rest of the readme

# Updates:

Attempt to update the specific keyboard's firmware everytime a key's mapping changes proved to be quite problematic.
-  The developed App has dependencies on core files that would allow for the building and flashing of .hex files to the deveice.
-  Interfacing with the keyboard at such a low level required physical shorting of hardware pins before changes can be processed.
-  Solution is not as general as we would like it to be, success can only be localised to specific hardware.

### Change in direction to a higher-level solution:

With the following `frameworks` (??) below, we could approach the remapping of keys from another angle.

#### Quartz(Higher-Level):
- Keycodes would be intercepted via Quartz Event Taps and virtually remapped.
- To my understanding - this may be wrong - Quartz is able to capture the data stream from HID devices, but is unable to interface directly with the properties of each HID device, hence isolating mapped keycodes to an external device rather than the user's main keyboard.

#### IO Kit(Lower-Level):
-  The IO Kit can interface with devices directly.
