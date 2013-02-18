#!/bin/bash

set -x

gm convert $1 \
	-shave 100x100 \
	-resize 90x90% \
	-convolve "-1, -1, -1, -1, 16, -1, -1, -1, -1" \
	$2
