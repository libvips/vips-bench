#!/bin/bash

# subdir we keep image temps in for the benchmark
tmp=tmp

echo clearing test area ...
rm -rf $tmp
mkdir $tmp

echo building test image ...
vips colourspace sample2.v $tmp/t1.v srgb
#vips replicate $tmp/t1.v $tmp/t2.v 20 15
vips replicate $tmp/t1.v $tmp/t2.v 40 30
vips extract_area $tmp/t2.v $tmp/x.tif[tile] 0 0 10000 10000
vips copy $tmp/x.tif $tmp/x.jpg
vips copy $tmp/x.tif $tmp/x.ppm
vips copy $tmp/x.tif $tmp/x-strip.tif
vipsheader $tmp/x.tif

# needed for vips.php below
composer install

# try to find the real time a command took to run
real_time() {
	# capture command output to y, time output to x
	(time -p $* &> tmp/y) &> tmp/x

	# get just the "real 0.2" line
	real=($(cat tmp/x | grep real))

	# and just the number
	return_real_time=${real[1]}
}

# run a command several times, return the fastest real time

# sleep for two secs between runs to let the system settle -- after a run
# there's a short period of disc chatter we want to avoid

# you should check that services like tracker are not running

get_time() {
	cmd=$*

	times=()
	for i in {1..5}; do
		sleep 2
		real_time $cmd
		times+=($return_real_time)
	done

	IFS=$'\n' times=($(sort -g <<<"${times[*]}"))
	unset IFS

	cmd_time=$times
}

# run a command and get a trace of memuse in a csv file
get_mem() {
	name=$1
	cmd=$2
	user=$(whoami)

	rm -f $tmp/vipsbench.lock
	(while [ ! -f $tmp/vipsbench.lock ]; do 
		ps u -u $user 
		sleep 0.01
	 done | ./parse-ps.rb "$name" > "$name.csv") &
	$cmd 
	touch $tmp/vipsbench.lock
	sleep 1
	cmd_mem=$(tail -1 "$name.csv" | awk '{ print $3 }')
}

# benchmark
benchmark() {
	name=$1
	cmd=$2

	get_time $cmd
	get_mem "$name" "$cmd"
	echo $name, $cmd_time, $cmd_mem 

	echo "time, $cmd_time, " >> "$name.csv"
}

rm -f *.csv

echo "program, time (s), peak memory (MB)"

# gm, im etc. control concurreny with this ... but leave at the default
export OMP_NUM_THREADS=16

# don't use hyperthreading with libvips: this is an int workload and sees no
# benefit, and in fact a slight slowdown due to thread management
export VIPS_CONCURRENCY=16

gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c
echo -n ppm-
benchmark vips-c "./vips-c $tmp/x.ppm $tmp/x2.ppm"

benchmark tiffcp "tiffcp -m 400000000 -s $tmp/x.tif $tmp/x2.tif"

gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c
benchmark vips-c "./vips-c $tmp/x.tif $tmp/x2.tif"

benchmark vips.php "./vips.php $tmp/x.tif $tmp/x2.tif"

g++ vips.cc `pkg-config vips-cpp --cflags --libs` -o vips-cc
benchmark vips-cc "./vips-cc $tmp/x.tif $tmp/x2.tif"

benchmark vips.py "./vips.py $tmp/x.tif $tmp/x2.tif"

benchmark lua-vips.lua "./lua-vips.lua $tmp/x.tif $tmp/x2.tif"

benchmark ruby-vips "./ruby-vips.rb $tmp/x.tif $tmp/x2.tif"

benchmark vips-gegl.py "./vips-gegl.py $tmp/x.jpg $tmp/x2.jpg"

gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c
export VIPS_CONCURRENCY=1
echo -n 1thread-
benchmark vips-c "./vips-c $tmp/x.tif $tmp/x2.tif"
unset VIPS_CONCURRENCY

gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c
echo -n jpg-
benchmark vips-c "./vips-c $tmp/x.jpg $tmp/x2.jpg"

benchmark pillow-simd "./pillow.py $tmp/x-strip.tif $tmp/x2.tif"

benchmark vips-cli "./vips.sh $tmp/x.tif $tmp/x2.tif"

# sadly bitrotted in the shifting sands of node 
# benchmark vips.js "./vips.js $tmp/x.tif $tmp/x2.tif"

echo -n ppm-
benchmark gm "./gm.sh $tmp/x.ppm $tmp/x2.ppm"

benchmark gm "./gm.sh $tmp/x.tif $tmp/x2.tif"

echo -n jpg-
benchmark gm "./gm.sh $tmp/x.jpg $tmp/x2.jpg"

benchmark nip2 "./vips.nip2 $tmp/x.tif -o $tmp/x2.tif"

benchmark nip4 "./vips.nip4 $tmp/x.tif -o $tmp/x2.tif"

# OS X only
# benchmark sips "./sips.sh $tmp/x.tif $tmp/x2.tif"

# pnm hates tiled tiff
benchmark pnm "./netpbm.sh $tmp/x-strip.tif $tmp/x2.tif"

benchmark rmagick "./rmagick.rb $tmp/x.tif $tmp/x2.tif"

# this needs careful config, see
# https://github.com/jcupitt/vips-bench/issues/4
YMAGINE=/home/john/ymagine
if [ -d $YMAGINE ]; then
  export LD_LIBRARY_PATH=$YMAGINE/out/target/linux-x86_64:$LD_LIBRARY_PATH
  gcc \
    -I $YMAGINE/framework/ymagine/jni/include \
    -I $YMAGINE/framework/yosal/include \
    -L $YMAGINE/out/target/linux-x86_64 \
    ymagine.c \
    -l yahoo_ymagine \
    -o ymagine-c
  echo -n jpg-
  benchmark ymagine-c "./ymagine-c $tmp/x.jpg $tmp/x2.jpg"
fi

benchmark convert "./im.sh $tmp/x.tif $tmp/x2.tif"

benchmark imwand.py "./imwand.py $tmp/x.tif $tmp/x2.tif"

echo -n jpg-
benchmark convert "./im.sh $tmp/x.jpg $tmp/x2.jpg"

g++ -g -Wall opencv.cc `pkg-config opencv4 --cflags --libs` -o opencv
benchmark opencv "./opencv $tmp/x.tif $tmp/x2.tif"

benchmark oiio "./oiio.sh $tmp/x.tif $tmp/x2.tif"

benchmark imagej "imagej -x 1000 -i $tmp/x-strip.tif -b bench.ijm"

benchmark econvert "./ei.sh $tmp/x-strip.tif $tmp/x2.tif"

gcc -Wall imlib2.c `pkg-config imlib2 --cflags --libs` -o imlib2
benchmark imlib2 "./imlib2 $tmp/x.tif $tmp/x2.tif"

benchmark magick "./im7.sh $tmp/x.tif $tmp/x2.tif"

gcc freeimage.c -lfreeimage -o freeimage
benchmark freeimage "./freeimage $tmp/x-strip.tif $tmp/x2.tif"

# broken, again, in ruby 2.7
# benchmark is "./is.rb $tmp/x-strip.tif $tmp/x2.tif"

gcc -Wall gd.c `pkg-config gdlib --cflags --libs` -o gd
echo -n jpg-
benchmark gd "./gd $tmp/x.jpg $tmp/x2.jpg"

benchmark imagick "./imagick.php $tmp/x.tif $tmp/x2.tif"

gcc -Wall gegl.c `pkg-config gegl-0.4 --cflags --libs` -o gegl
# gegl-0.4 doesn't have tiff support built in
# echo -n tiff-
# benchmark gegl "./gegl $tmp/x.tif $tmp/x2.tif"
# this fails with an assert() error on ubuntu 19.04
# don't use opencl and threads ... we want to avoid opencl's thread system
export GEGL_THREADS=16
export GEGL_USE_OPENCL=no
echo -n jpg-
benchmark gegl "./gegl $tmp/x.jpg $tmp/x2.jpg"

# no longer in ubuntu 22.04
# benchmark pike "./image.pike $tmp/x.tif $tmp/x2.tif"

benchmark gmic "./gmic.sh $tmp/x.tif $tmp/x2.tif"

# this has stopped working and needs fixing
# benchmark scikit "./scikit.py $tmp/x-strip.tif $tmp/x2.tif"

benchmark octave "./octave.m $tmp/x.tif $tmp/x2.tif"

./combine.rb *.csv > memtrace.csv

echo "combined memory traces in memtrace.csv"

echo clearing test area ...
rm -rf $tmp

