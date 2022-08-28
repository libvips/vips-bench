#!/bin/bash

# we crop on load, it's a bit quicker and saves some memory
# we can't crop 100 pixels with the crop-on-load syntax, so we have to
# find the width and height ourselves
width=$(vipsheader -f Xsize $1)
height=$(vipsheader -f Ysize $1)

width=$((width - 200))
height=$((height - 200))

# set -x

# -filter triangle acts as bilinear with -resize and small size changes

magick "$1[${width}x${height}+100+100]" \
	-filter triangle -resize 90x90% \
	-convolve "-1, -1, -1, -1, 16, -1, -1, -1, -1" \
	$2
