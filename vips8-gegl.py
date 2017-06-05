#!/usr/bin/python

import sys

import gi
gi.require_version('Vips', '8.0')
from gi.repository import Vips 

im = Vips.Image.new_from_file(sys.argv[1])

im = im.bandjoin(255)
im = im.colourspace("scrgb")

im = im.crop(100, 100, im.width - 200, im.height - 200)
im = im.similarity(scale = 0.9, 
                   interpolate = Vips.Interpolate.new("bilinear"))
mask = Vips.Image.new_from_array([[-1, -1,  -1], 
                                  [-1,  16, -1], 
                                  [-1, -1,  -1]], scale = 8)
im = im.conv(mask, precision = "integer")

im = im.colourspace("srgb")
im = im.extract_band(0, n = 3)

im.write_to_file(sys.argv[2])
