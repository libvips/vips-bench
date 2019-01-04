#!/usr/bin/python

import sys
from PIL import Image, ImageFilter, PILLOW_VERSION

# just to confirm we are getting the right version
# print 'pillow.py: PILLOW_VERSION =', PILLOW_VERSION

im = Image.open(sys.argv[1])
width, height = im.size

# Crop 100 pixels off all edges.
im = im.crop((100, 100, width - 100, height - 100))

# Shrink by 10%
width, height = im.size
im = im.resize((int(width * 0.9), int(height * 0.9)), Image.BILINEAR)

# sharpen
filter = ImageFilter.Kernel((3, 3),
	      (-1, -1, -1,
	       -1, 16, -1,
	       -1, -1, -1))
im = im.filter(filter)

# write back again
im.save(sys.argv[2])

