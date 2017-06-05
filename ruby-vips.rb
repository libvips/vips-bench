#!/usr/bin/ruby

require 'vips'

im = Vips::Image.new_from_file ARGV[0]

im = im.crop 100, 100, im.width - 200, im.height - 200
im = im.similarity scale: 0.9
mask = Vips::Image.new_from_array [
	[-1, -1,  -1], 
	[-1,  16, -1],
	[-1, -1,  -1]], 8
im = im.conv mask, precision: "integer"

im.write_to_file ARGV[1]

