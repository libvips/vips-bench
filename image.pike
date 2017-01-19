#!/usr/bin/pike

int main(int argc, array(string) argv)
{
	object image = Image.load(argv[1]);

	image = image->copy(100, 100, 
		image->xsize() - 101, image->ysize() - 101);

	image = image->scale(0.9);

	image = image->apply_matrix(
		({({-1,-1,-1}),
		  ({-1,16,-1}),
	  	  ({-1,-1,-1})}));

	Stdio.write_file(argv[2], Image.TIFF.encode(image));

	return 0;
}
