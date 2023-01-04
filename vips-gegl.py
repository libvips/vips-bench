#!/usr/bin/python3

# use pyvips, but try to match the exact processing that the gegl code is
# doing, so everything is float, RGBA, and in linear light

import sys
import pyvips

im = pyvips.Image.new_from_file(sys.argv[1])

im = im.bandjoin(255)
im = im.colourspace('scrgb')

im = im.crop(100, 100, im.width - 200, im.height - 200)
im = im.reduce(1.0 / 0.9, 1.0 / 0.9, kernel='linear')
mask = pyvips.Image.new_from_array([[-1, -1,  -1], 
                                    [-1,  16, -1], 
                                    [-1, -1,  -1]], scale=8)
im = im.conv(mask, precision='integer')

im = im.colourspace('srgb')
im = im.extract_band(0, n=3)

im.write_to_file(sys.argv[2])
