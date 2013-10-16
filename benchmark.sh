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

# run a command and show peak memuse
get_mem() {
	cmd=$*

	./peakmem.pl $cmd
}

# benchmark
benchmark() {
	cmd=$*

	echo testing $cmd ...
	echo -n "time "
	get_time $cmd
	echo peak memuse
	get_mem $cmd
}

benchmark ./ei.sh $tmp/x_strip.tif $tmp/x2.tif

g++ vips.cc `pkg-config vipsCC --cflags --libs` -o vips-cc
benchmark ./vips-cc $tmp/x.tif $tmp/x2.tif

benchmark ./vips.py $tmp/x.tif $tmp/x2.tif

benchmark ./ruby-vips.rb $tmp/x.tif $tmp/x2.tif

benchmark ./vips.sh $tmp/x.tif $tmp/x2.tif

benchmark ./nip2bench.sh $tmp/x.tif -o $tmp/x2.tif

g++ -g -Wall opencv.cc `pkg-config opencv --cflags --libs` -o opencv
benchmark ./opencv $tmp/x.tif $tmp/x2.tif

benchmark ./gm.sh $tmp/x.tif $tmp/x2.tif

benchmark ./pil.py $tmp/x.tif $tmp/x2.tif

benchmark ./rmagick.rb $tmp/x.tif $tmp/x2.tif

benchmark ./im.sh $tmp/x.tif $tmp/x2.tif

gcc freeimage.c -lfreeimage -o freeimage
benchmark ./freeimage $tmp/x.tif $tmp/x2.tif

benchmark ./netpbm.sh $tmp/x.tif $tmp/x2.tif

# imagescience won't install on my work machine, how odd
# benchmark ./is.rb $tmp/x.tif $tmp/x2.tif

echo clearing test area ...
rm -rf $tmp

