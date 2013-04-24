#!/bin/bash

width=`header -f Xsize $1`
height=`header -f Ysize $1`

width=$((width - 200))
height=$((height - 200))

# set -x

econvert -i $1 \
	--crop "100,100,$width,$height" \
	--bilinear-scale 0.9 \
	--convolve "-1, -1, -1, -1, 16, -1, -1, -1, -1" \
	-o $2
