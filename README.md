# Tang Nano 9K LCD Driver

This is a simple LCD driver made for the Tang Nano 9K based on the official code at https://github.com/sipeed/TangNano-9K-example and adapted to a 1280x600 LCD display. It implements a frame buffer in B-SRAM to store a 205x120 image (1/5 of the display resolution).

The `convertImage.py` python code can be used to generate a memory initialization file from an image file named `image.png`. This memory initialization file can then be used to change the displayed image on the screen.