#!/bin/bash

width=$(vipsheader -f Xsize $1)
height=$(vipsheader -f Ysize $1)

crop_width=$((width - 200))
crop_height=$((height - 200))

resize_width=$((crop_width * 9 / 10))

# set -x

sips \
	--cropToHeightWidth $crop_height $crop_width \
	--resampleWidth $resize_width \
	$1 --out $2 &> /dev/null

