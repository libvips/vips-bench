# vips-bench 

We've written programs using number of different image processing systems to
load a TIFF image, crop 100 pixels off every edge, shrink by 10% with bilinear
interpolation, sharpen with a 3x3 convolution and save again. It's a trivial
test but it does give some idea of the speed and memory behaviour of these
libraries (and it's also quite fun to compare the code). 

Bilinear interpolation is poor quality and no one would use it, but it is
available everywhere. 

# Running the test

1. Put your system into performance mode with eg.:

```
   echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

3. Install any packages you are missing with eg.:

```
	sudo apt-get install imagemagick graphicsmagick libopencv-dev \
		python-imaging netpbm libfreeimage-dev \
		exactimage gegl composer libvips nip2
```

4. Make a venv for python and install the python and ruby packages

```
    python3 -m venv ~/vips
    . ~/vips/bin/activate
    pip install pyvips Pillow-SIMD gdlib 
	gem install rmagick ruby-vips image_science
```

Then run the driver script:

	./benchmark.sh

to generate the test image and run all the benchmarks. 

The program is very simple and doesn't do much error checking. You'll need
to look through the output and make sure everything is working correctly. In
particular, make sure you have all the packages installed. 

# Results

The [speed and memory use
page](https://github.com/libvips/libvips/wiki/Speed-and-memory-use) on the
libvips website has a table of results.

# TODO

The peakmem.pl program doesn't seem to be working correctly, investigate.

