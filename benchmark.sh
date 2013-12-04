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
header $tmp/x.tif

# run a command three times, return the fastest real time

# sleep for two secs between runs to let the system settle -- after a run
# there's a short period of disc chatter we want to avoid

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

	echo $t1
}

# run a command and get a trace of memuse in a csv file
get_mem() {
	name=$1
	cmd=$2

	(top -b -d 0.01 | ./parse-top.rb $name) > $name.csv &
	$cmd
	killall top 
	tail -1 $name.csv | awk '{ print $3 }'
}

# benchmark
benchmark() {
	name=$1
	cmd=$2

	echo testing $name ...
	echo -n "time "
	get_time $cmd
	echo -n "peak mem"
	get_mem $name "$cmd"
}

benchmark econvert "./ei.sh $tmp/x_strip.tif $tmp/x2.tif"

g++ vips.cc `pkg-config vipsCC --cflags --libs` -o vips-cc
benchmark vips-cc "./vips-cc $tmp/x.tif $tmp/x2.tif"

benchmark vips.py "./vips.py $tmp/x.tif $tmp/x2.tif"

benchmark ruby-vips.rb "./ruby-vips.rb $tmp/x.tif $tmp/x2.tif"

benchmark vips "./vips.sh $tmp/x.tif $tmp/x2.tif"

benchmark nip2 "./nip2bench.sh $tmp/x.tif -o $tmp/x2.tif"

g++ -g -Wall opencv.cc `pkg-config opencv --cflags --libs` -o opencv
benchmark opencv "./opencv $tmp/x.tif $tmp/x2.tif"

benchmark gm "./gm.sh $tmp/x.tif $tmp/x2.tif"

benchmark pil "./pil.py $tmp/x.tif $tmp/x2.tif"

benchmark rmagick "./rmagick.rb $tmp/x.tif $tmp/x2.tif"

benchmark convert "./im.sh $tmp/x.tif $tmp/x2.tif"

gcc freeimage.c -lfreeimage -o freeimage
benchmark freeimage "./freeimage $tmp/x.tif $tmp/x2.tif"

benchmark pnm "./netpbm.sh $tmp/x_strip.tif $tmp/x2.tif"

# imagescience won't install on my work machine, how odd
# benchmark ./is.rb $tmp/x.tif $tmp/x2.tif

pr -tmJ -s, *.csv > memtrace.csv

echo "memory traces in memtrace.csv"

echo clearing test area ...
rm -rf $tmp

