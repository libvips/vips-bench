#!/bin/bash

width=$(vipsheader -f Xsize $1)
height=$(vipsheader -f Ysize $1)

width=$((width - 200))
height=$((height - 200))

# resize with triangle is bilinear

# this will blur rather than sharpen, but the speed should be the same

oiiotool $1 \
	--crop $widthx$height+100+100 --origin +0+0 --fullpixels \
	--resize:filter=triangle 90% \
	--kernel gaussian 3x3 --convolve \
	-o $2
