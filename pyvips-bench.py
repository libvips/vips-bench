#!/usr/bin/python

import sys
import pyvips

im = pyvips.Image.new_from_file(sys.argv[1], access='sequential')

im = im.crop(100, 100, im.width - 200, im.height - 200)
im = im.similarity(scale = 0.9, 
                   interpolate = pyvips.Interpolate.new('bilinear'))
mask = pyvips.Image.new_from_array([[-1, -1,  -1], 
                                    [-1,  16, -1], 
                                    [-1, -1,  -1]], scale=8)
im = im.conv(mask, precision='integer')

im.write_to_file(sys.argv[2])
