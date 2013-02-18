#!/usr/bin/ruby

# gem install rmagick

require 'rubygems'
require 'RMagick'
include Magick

im = ImageList.new(ARGV[0])

im = im.shave(100, 100)
im = im.scale(0.9)
kernel = [-1, -1, -1, -1, 16, -1, -1, -1, -1]
im = im.convolve(3, kernel)
                   
im.write(ARGV[1])
