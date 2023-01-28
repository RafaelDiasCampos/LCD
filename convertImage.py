from imageio.v2 import imread, imwrite

image = imread('image.png')

red = image[:, :, 0]
green = image[:, :, 1]
blue = image[:, :, 2]

with open("init.mi", "w") as f:
    f.write("#File_format=Bin\n")
    f.write(f"#Address_depth={blue.shape[0] * blue.shape[1]}\n")
    f.write("#Data_width=16\n")
    for row in range(blue.shape[0]):
        for col in range(blue.shape[1]):
            r_val = str(bin(red[row][col]))[2:].zfill(8)[0:5]
            g_val = str(bin(green[row][col]))[2:].zfill(8)[0:6]
            b_val = str(bin(blue[row][col]))[2:].zfill(8)[0:5]

            f.write(f"{r_val}{g_val}{b_val}\n")

            # Write back to image
            image[row][col][0] = int(r_val, 2) << 3
            image[row][col][1] = int(g_val, 2) << 2
            image[row][col][2] = int(b_val, 2) << 3

# Save image
imwrite('image2.png', image)