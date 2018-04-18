#!/usr/bin/python

import sys
from PIL import Image, ImageFilter, __version__

# just to confirm we are getting the right version
# print 'pillow.py: __version__ =', __version__

im = Image.open(sys.argv[1])

# Crop 100 pixels off all edges.
im = im.crop((100, 100, im.width - 100, im.height - 100))

# Shrink by 10%
im = im.resize((int(im.width * 0.9), int(im.height * 0.9)), Image.BILINEAR)

# sharpen
filter = ImageFilter.Kernel((3, 3),
	      (-1, -1, -1,
	       -1, 16, -1,
	       -1, -1, -1))
im = im.filter(filter)

# write back again
im.save(sys.argv[2])

