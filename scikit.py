#!/usr/bin/python3

import sys
import numpy as np
from scipy import ndimage, misc
from PIL import Image

im = ndimage.imread(sys.argv[1])

width, height, bands = im.shape
im = im[100:(width - 100), 100:(height - 100)]

im = misc.imresize(im, 0.9, interp='bilinear')

ker = (1.0 / 8.0) * np.array([[-1, -1,  -1], 
                              [-1,  16, -1], 
                              [-1, -1,  -1]])
im = ndimage.convolve(im, [ker, ker, ker])

# save via PIL is slightly quicker
out = Image.fromarray(im)
out.save(sys.argv[2])
