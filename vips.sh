#!/bin/bash

width=$(vipsheader -f Xsize $1)
height=$(vipsheader -f Ysize $1)

width=$((width - 200))
height=$((height - 200))

# set -x

vips extract_area $1 t1.v 100 100 $width $height
# a bit slower
#vips shrink t1.v t2.v 1.11 1.11
vips affine t1.v t2.v "0.9 0 0 0.9" --interpolate bilinear

cat > mask.con <<EOF
3 3 8 0
-1 -1 -1
-1 16 -1
-1 -1 -1
EOF
vips conv t2.v $2 mask.con

# again a little slower for small masks
# cat > mask.con <<EOF
# 3 1 8 0
# -1 8 -1
# EOF
# vips im_convsep t2.v $2 mask.con

rm t1.v t2.v
