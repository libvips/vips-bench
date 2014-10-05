#!/bin/bash

width=$(vipsheader -f Xsize $1)
height=$(vipsheader -f Ysize $1)
crop_width=$((width - 200))
crop_height=$((height - 200))

gmic \
	-verbose - \
	-input $1 \
	-crop 100,100,$crop_width,$crop_height \
	-resize 90%,90%,1,3,3,1 \
	"(-1,-1,-1;-1,9,-1;-1,-1,-1)" -convolve[-2] [-1] -keep[-2] \
	-type uchar \
	-output $2
