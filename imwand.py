#!/usr/bin/env python3

from sys import argv
from wand.image import Image

input = argv[1]
output = argv[2]

with Image(filename=input) as img:
	img.shave(100, 100)
	img.resize(round(0.9 * img.width), round(0.9 * img.height), 'triangle')
	img.morphology(method='convolve', kernel='3x3: -0.125, -0.125, -0.125, -0.125, 2, -0.125, -0.125, -0.125, -0.125')
	img.save(filename=output)
