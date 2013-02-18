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

	sudo apt-get install imagemagick
	sudo apt-get install graphicsmagick
	sudo apt-get install libopencv-dev
	sudo apt-get install python-imaging
	sudo apt-get install netpbm
	sudo apt-get install libvips
	sudo apt-get install nip2
	sudo apt-get install libfreeimage-dev

	gem install rmagick
	gem install ruby-vips
	gem install image_science

You may need more recent versions of some packages. The netpbm in Ubuntu is
very old and installing from the website is a good idea. Ubuntu libvips tends
to lag as well.

# Results

The
[http://www.vips.ecs.soton.ac.uk/index.php?title=Speed_and_Memory_Use][speed 
and memory use page] on the libvips website has a table of results. 

# TODO

The peakmem.pl program doesn't seem to be working correctly, investigate.
