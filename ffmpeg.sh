#!/bin/bash

crop="iw-200:ih-200:100:100"
scale="iw*.9:ih*.9"
kernel="-1 -1 -1 -1 16 -1 -1 -1 -1"
conv="$kernel:$kernel:$kernel:$kernel:1/8:1/8:1/8:1/8"

ffmpeg -y -i $1 -vf "crop=$crop, scale=$scale, convolution=$conv" $2
