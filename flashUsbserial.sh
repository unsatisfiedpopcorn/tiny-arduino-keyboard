#!/bin/bash
sudo dfu-programmer atmega16u2 erase
echo "Erased"
sudo dfu-programmer atmega16u2 flash firmware/Arduino-usbserial-uno.hex
echo "Flashed"
sudo dfu-programmer atmega16u2 reset
echo "Resetted"
sudo dfu-programmer atmega16u2 start
echo "Ardunio started, script done!"
