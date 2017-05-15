#!/usr/bin/python

import sys
from PIL import Image, ImageFilter, PILLOW_VERSION

# just to confirm we are getting the right version
# print("pillow.py: PILLOW_VERSION =", PILLOW_VERSION)

im = Image.open(sys.argv[1])

# Crop 100 pixels off all edges.
im = im.crop((100, 100, im.size[0] - 100, im.size[1] - 100))

# Shrink by 10%

# starting with 2.7, Pillow uses a high-quality convolution-based resize for 
# BILINEAR ... the other systems in this benchmark are using affine + bilinear,
# so this is rather unfair. Use NEAREST instead, it gets closest to what
# everyone else is doing

# pillow-simd reduces the LANCZOS time down to only 10% more than NEAREST

im = im.resize((int (im.size[0] * 0.9), int (im.size[1] * 0.9)), 
#               Image.LANCZOS)
               Image.NEAREST)

# sharpen
filter = ImageFilter.Kernel((3, 3),
	      (-1, -1, -1,
	       -1, 16, -1,
	       -1, -1, -1))
im = im.filter(filter)

# write back again
im.save(sys.argv[2])

