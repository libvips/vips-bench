#!/bin/bash

# set -x

# use mmap for image input
#export MAGICK_MMAP_READ=TRUE

gm convert $1 \
	-shave 100x100 \
	-filter triangle -resize 90x90% \
	-convolve "-1, -1, -1, -1, 16, -1, -1, -1, -1" \
	$2
