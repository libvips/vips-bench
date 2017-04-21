makeRectangle(100, 100, 4800, 4800);
run("Crop");
run("Size...", "width=4320 height=4271 constrain average interpolation=Bilinear");
run("Convolve...", "text1=[-1 -1 -1\n-1 16 -1\n-1 -1 -1\n] normalize");
saveAs("tiff", "tmp/x2.tif");
