#!/bin/bash

# subdir we keep image temps in for the benchmark
tmp=tmp

echo clearing test area ...
rm -rf $tmp
mkdir $tmp

echo building test image ...
vips colourspace sample2.v $tmp/t1.v srgb
vips colourspace sample2.v $tmp/t1.v srgb
vips replicate $tmp/t1.v $tmp/t2.v 20 15
vips extract_area $tmp/t2.v $tmp/x.tif[tile] 0 0 5000 5000
vips copy $tmp/x.tif $tmp/x_strip.tif
vips copy $tmp/x.tif $tmp/x.jpg
vips copy $tmp/x.tif $tmp/x.ppm
vipsheader $tmp/x.tif

# run a command three times, return the fastest real time

# sleep for two secs between runs to let the system settle -- after a run
# there's a short period of disc chatter we want to avoid

# check that services like tracker are not running

get_time() {
	cmd=$*

	sleep 2
	t1=$(/usr/bin/time -f %e $cmd 2>&1) 
	sleep 2
	t2=$(/usr/bin/time -f %e $cmd 2>&1) 
	sleep 2
	t3=$(/usr/bin/time -f %e $cmd 2>&1) 

	if [[ $t2 < $t1 ]]; then
		t1=$t2
	fi
	if [[ $t3 < $t1 ]]; then
		t1=$t3
	fi

	# remove any newlines
	t1=$(echo $t1)

	cmd_time=$t1
}

# run a command and get a trace of memuse in a csv file
get_mem() {
	name=$1
	cmd=$2

	rm -f $tmp/vipsbench.lock
	(while [ ! -f $tmp/vipsbench.lock ]; do 
		ps u
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

	echo -n $name 
	get_time $cmd
	echo -n , $cmd_time
	get_mem "$name" "$cmd"
	echo -n , $cmd_mem 
	echo 

	echo "time, $cmd_time, " >> "$name.csv"
}

rm -f *.csv

echo "program, time (s), peak memory (MB)"

gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c
benchmark vips-c "./vips-c $tmp/x.tif $tmp/x2.tif"

g++ vips.cc `pkg-config vipsCC --cflags --libs` -o vips-cc
benchmark vips-cc "./vips-cc $tmp/x.tif $tmp/x2.tif"

gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c
echo -n ppm-
benchmark vips-c "./vips-c $tmp/x.ppm $tmp/x2.ppm"

benchmark vips.py "./vips.py $tmp/x.tif $tmp/x2.tif"

benchmark ruby-vips "./ruby-vips.rb $tmp/x.tif $tmp/x2.tif"

g++ vips8.cc `pkg-config vips-cpp --cflags --libs` -o vips8-cc
benchmark vips8-cc "./vips8-cc $tmp/x.tif $tmp/x2.tif"

benchmark vips8.py "./vips8.py $tmp/x.tif $tmp/x2.tif"

# still in development
benchmark ruby-vips8 "./ruby-vips8.rb $tmp/x.tif $tmp/x2.tif"

gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c
echo -n jpg-
benchmark vips-c "./vips-c $tmp/x.jpg $tmp/x2.jpg"

benchmark vips "./vips.sh $tmp/x.tif $tmp/x2.tif"

benchmark nip2 "./vips.nip2 $tmp/x.tif -o $tmp/x2.tif"

g++ -g -Wall opencv.cc `pkg-config opencv --cflags --libs` -o opencv
benchmark opencv "./opencv $tmp/x.tif $tmp/x2.tif"

echo -n ppm-
benchmark gm "./gm.sh $tmp/x.ppm $tmp/x2.ppm"

benchmark gm "./gm.sh $tmp/x.tif $tmp/x2.tif"

echo -n jpg-
benchmark gm "./gm.sh $tmp/x.jpg $tmp/x2.jpg"

benchmark pnm "./netpbm.sh $tmp/x_strip.tif $tmp/x2.tif"

# this needs careful config, see
# https://github.com/jcupitt/vips-bench/issues/4
#YMAGINE=/home/john/ymagine
#gcc \
#	-I $YMAGINE/framework/ymagine/jni/include \
#	-I $YMAGINE/framework/yosal/include \
#	-L $YMAGINE/out/target/linux-x86_64 \
#	ymagine.c \
#	-l yahoo_ymagine \
#	-o ymagine-c
#echo -n jpg-
#benchmark ymagine-c "./ymagine-c $tmp/x.jpg $tmp/x2.jpg"

benchmark convert "./im.sh $tmp/x.tif $tmp/x2.tif"

benchmark econvert "./ei.sh $tmp/x_strip.tif $tmp/x2.tif"

benchmark rmagick "./rmagick.rb $tmp/x.tif $tmp/x2.tif"

# benchmark pil "./pil.py $tmp/x.tif $tmp/x2.tif"
benchmark pillow "./pillow.py $tmp/x.tif $tmp/x2.tif"

benchmark gmic "./gmic.sh $tmp/x.tif $tmp/x2.tif"

gcc freeimage.c -lfreeimage -o freeimage
benchmark freeimage "./freeimage $tmp/x.tif $tmp/x2.tif"

gcc -Wall gd.c `pkg-config gdlib --cflags --libs` -o gd
echo -n jpg-
benchmark gd "./gd $tmp/x.jpg $tmp/x2.jpg"

benchmark oiio "./oiio.sh $tmp/x.tif $tmp/x2.tif"

gcc -Wall gegl.c `pkg-config gegl-0.3 --cflags --libs` -o gegl
echo -n jpg-
benchmark gegl "./gegl $tmp/x.jpg $tmp/x2.jpg"

benchmark is "./is.rb $tmp/x.tif $tmp/x2.tif"

# octave image load is broken in 15.04, see 
# https://bugs.launchpad.net/ubuntu/+source/octave/+bug/1372202
# benchmark ./octave.m $tmp/x.tif $tmp/x2.tif

./combine.rb *.csv > memtrace.csv

echo "combined memory traces in memtrace.csv"

echo clearing test area ...
rm -rf $tmp

