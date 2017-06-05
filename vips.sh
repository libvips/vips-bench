#!/bin/bash

width=$(vipsheader -f Xsize $1)
height=$(vipsheader -f Ysize $1)

width=$((width - 200))
height=$((height - 200))

# set -x

vips crop $1 t1.v 100 100 $width $height
vips similarity t1.v t2.v --scale 0.9 --interpolate bilinear

cat > mask.con <<EOF
3 3 8 0
-1 -1 -1
-1 16 -1
-1 -1 -1
EOF
vips conv t2.v $2 mask.con --precision integer

rm t1.v t2.v
