#!/usr/bin/env python3

import sys
import pyvips

im = pyvips.Image.new_from_file(sys.argv[1])

im = im.crop(100, 100, im.width - 200, im.height - 200)
im = im.reduce(1.0 / 0.9, 1.0 / 0.9, kernel='linear')
mask = pyvips.Image.new_from_array([[-1, -1,  -1], 
                                    [-1,  16, -1], 
                                    [-1, -1,  -1]], scale=8)
im = im.conv(mask, precision='integer')

im.write_to_file(sys.argv[2])
