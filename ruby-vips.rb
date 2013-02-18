#!/usr/bin/ruby

require 'rubygems'
require 'vips'
include VIPS

im = Image.new(ARGV[0])

im = im.extract_area(100, 100, im.x_size - 200, im.y_size - 200)
im = im.affinei(:bilinear, 0.9, 0, 0, 0.9, 0, 0)
mask = [
	[-1, -1,  -1], 
	[-1,  16, -1,],
	[-1, -1,  -1]
]
m = VIPS::Mask.new mask, 8, 0
im = im.conv(m)

im.write(ARGV[1])

