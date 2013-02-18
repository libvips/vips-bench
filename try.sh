#!/bin/bash

echo rmagick.rb

time ./rmagick.rb wtc_tiled_small.tif x.tif
sleep 2
time ./rmagick.rb wtc_tiled_small.tif x.tif
sleep 2
time ./rmagick.rb wtc_tiled_small.tif x.tif
sleep 2
time ./rmagick.rb wtc_tiled_small.tif x.tif
sleep 2

echo vips.py

time ./vips.py wtc_tiled_small.tif x.tif
sleep 2
time ./vips.py wtc_tiled_small.tif x.tif
sleep 2
time ./vips.py wtc_tiled_small.tif x.tif
sleep 2
time ./vips.py wtc_tiled_small.tif x.tif
sleep 2

echo ruby-vips.rb

time ./ruby-vips.rb wtc_tiled_small.tif x.tif
sleep 2
time ./ruby-vips.rb wtc_tiled_small.tif x.tif
sleep 2
time ./ruby-vips.rb wtc_tiled_small.tif x.tif
sleep 2
time ./ruby-vips.rb wtc_tiled_small.tif x.tif
sleep 2

echo nip2bench.sh

time ./nip2bench.sh wtc_tiled_small.tif -o x.tif
sleep 2
time ./nip2bench.sh wtc_tiled_small.tif -o x.tif
sleep 2
time ./nip2bench.sh wtc_tiled_small.tif -o x.tif
sleep 2
time ./nip2bench.sh wtc_tiled_small.tif -o x.tif
sleep 2

echo vips.sh

time ./vips.sh wtc_tiled_small.tif x.tif
sleep 2
time ./vips.sh wtc_tiled_small.tif x.tif
sleep 2
time ./vips.sh wtc_tiled_small.tif x.tif
sleep 2
time ./vips.sh wtc_tiled_small.tif x.tif
sleep 2

echo vips.cc

g++ vips.cc `pkg-config vipsCC --cflags --libs`
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2

echo pil.py

time ./pil.py wtc_tiled_small.tif x.tif
sleep 2
time ./pil.py wtc_tiled_small.tif x.tif
sleep 2
time ./pil.py wtc_tiled_small.tif x.tif
sleep 2
time ./pil.py wtc_tiled_small.tif x.tif
sleep 2

echo im.sh

time ./im.sh wtc_tiled_small.tif x.tif
sleep 2
time ./im.sh wtc_tiled_small.tif x.tif
sleep 2
time ./im.sh wtc_tiled_small.tif x.tif
sleep 2
time ./im.sh wtc_tiled_small.tif x.tif
sleep 2

echo gm.sh

time ./im.sh wtc_tiled_small.tif x.tif
sleep 2
time ./im.sh wtc_tiled_small.tif x.tif
sleep 2
time ./im.sh wtc_tiled_small.tif x.tif
sleep 2
time ./im.sh wtc_tiled_small.tif x.tif
sleep 2

echo freeimage.c 

gcc freeimage.c -lfreeimage
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2

echo netpbm.sh

time ./netpbm.sh wtc_tiled_small.tif x.tif
sleep 2
time ./netpbm.sh wtc_tiled_small.tif x.tif
sleep 2
time ./netpbm.sh wtc_tiled_small.tif x.tif
sleep 2
time ./netpbm.sh wtc_tiled_small.tif x.tif
sleep 2

echo is.rb

time ./is.rb wtc_tiled_small.tif x.tif
sleep 2
time ./is.rb wtc_tiled_small.tif x.tif
sleep 2
time ./is.rb wtc_tiled_small.tif x.tif
sleep 2
time ./is.rb wtc_tiled_small.tif x.tif
sleep 2

echo opencv.cc

g++ -g -Wall opencv.cc `pkg-config opencv --cflags --libs`
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2
time ./a.out wtc_tiled_small.tif x.tif
sleep 2



