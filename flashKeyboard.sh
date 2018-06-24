#!/bin/bash
sudo dfu-programmer atmega16u2 erase
echo "Erased"
sudo dfu-programmer atmega16u2 flash firmware/Arduino-keyboard-0.3.hex
echo "Flashed"
sudo dfu-programmer atmega16u2 reset
echo "Resetted"
sudo dfu-programmer atmega16u2 start
echo "Ardunio started, script done!"
