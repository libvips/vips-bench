#!/usr/bin/env ruby

# gem install mini_magick

require 'rubygems'
require 'mini_magick'

im = MiniMagick::Image.open(ARGV[0])

im = im.shave('100x100')
# Triangle is bilinear for small size changes
im = im.filter('Triangle').resize("#{im.width * 0.9}x#{im.height * 0.9}")
kernel = [-1, -1, -1, -1, 16, -1, -1, -1, -1]
im = im.convolve(kernel.join(','))

im.write(ARGV[1])
