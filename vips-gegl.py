#!/usr/bin/python

import sys
from vipsCC import *

im = VImage.VImage (sys.argv[1])

# add an all-255 alpha
alpha = VImage.VImage.black (1, 1, 1).lin (1, 255)
alpha = alpha.clip2fmt (VImage.VImage.FMTUCHAR)
alpha = alpha.embed (1, 0, 0, im.Xsize (), im.Ysize ())
im = im.bandjoin (alpha)

# turn to linear float 0 - 1
gamma = 2.4
lut = VImage.VImage.identity (1)
lut = lut.pow (1.0 / gamma)
lut = lut.lin (1.0 / pow (255, 1.0 / 2.4), 0)
im = im.maplut (lut)

im = im.extract_area (100, 100, im.Xsize () - 200, im.Ysize () - 200)

im = im.affine (0.9, 0, 0, 0.9, 0, 0, 0, 0,
        int (im.Xsize() * 0.9), int (im.Ysize() * 0.9))

mask = VMask.VIMask (3, 3, 8, 0, 
		  [-1, -1, -1, 
		   -1,  16, -1, 
		   -1, -1, -1])
im = im.conv (mask)

# back to non-linear 0 - 65535
im = im.lin (65535, 0)
# im = im.pow (2.4)

# back to uint16
im = im.clip2fmt (VImage.VImage.FMTUSHORT)

im.write (sys.argv[2])
