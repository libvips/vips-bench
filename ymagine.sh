#!/bin/sh

#set -x

YMAGINE=/home/john/ymagine/out/target/linux-x86_64/bin/ymagine

width=$(vipsheader -f width $1)
height=$(vipsheader -f height $1)

width=$((width - 200))
height=$((height - 200))

shrunk_width=`bc <<EOF
$width * 0.9
EOF`
shrunk_height=`bc <<EOF
$height * 0.9
EOF`

$YMAGINE transcode \
	-crop ${width}x${height}@100,100 \
	-width $shrunk_width -height $shrunk_height \
	-sharpen 0.1 \
	-format jpg -force $1 $2
