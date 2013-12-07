# vips-bench 

We've written programs using number of different image processing system to
load a TIFF image, crop 100 pixels off every edge, shrink by 10% with bilinear
interpolation, sharpen with a 3x3 convolution and save again. It's a trivial
test but it does give some idea of the speed and memory behaviour of these
libraries (and it's also quite fun to compare the code). 

# Running the test

There's a driver program -- run

	./benchmark.sh

to generate the test image and run all the benchmarks. 

The program is very simple and doesn't do much error checking. You'll need
to look through the output and make sure everything is working correctly. In
particular, make sure you have all the packages installed. On Ubuntu, you
can do this by running

	sudo apt-get install imagemagick graphicsmagick libopencv-dev \
		python-imaging netpbm libvips nip2 libfreeimage-dev \
		exactimage

	gem install rmagick ruby-vips

There's stuff here to test imagescience as well, but it's not installing for 
me for some reason. It might work for you:

	gem install image_science

You may need more recent versions of some packages. The netpbm in Ubuntu is
very old and installing from the website is a good idea. Ubuntu libvips tends
to lag as well.

# Results

The
[speed and memory use page](http://www.vips.ecs.soton.ac.uk/index.php?title=Speed_and_Memory_Use) on the libvips website has a table of results. 

# TODO

The peakmem.pl program doesn't seem to be working correctly, investigate.

The Octave test (vips.m) segvs for me on Ubuntu 13.04, try again later. 

why is vips-cc faster than vips-c? 


