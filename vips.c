// compile with
// gcc vips.c `pkg-config vips --cflags --libs`

#include <vips/vips.h>

int 
main (int argc, char **argv)
{
	VipsImage *in;
	VipsImage **t;
	INTMASK *m;

	if( !(in = vips_image_new_mode( argv[1], "rs" )) )
		vips_error_exit( "unable to read %s", argv[1] );
	t = (VipsImage **) vips_object_local_array( in, 4 );

	m = im_create_imaskv( "conv.mat", 3, 3, 
                -1, -1, -1, -1, 16,-1, -1, -1, -1 );
	m->scale = 8;

	if( vips_extract_area( in, &t[0], 
                100, 100, in.Xsize () - 200, in.Ysize () - 200, NULL ) ||
		vips_affine( t[0], &t[1], 0.9, 0, 0, 0.9, NULL ) ||
		im_conv( 


        vips::VImage in (argv[1]);
	m = im_create_imaskv( "conv.mat", 3, 3, 
                -1, -1, -1, -1, 16,-1, -1, -1, -1 );
	m->scale = 8;

        vips::VIMask mask (3, 3, 8, 0,
                -1, -1, -1, -1, 16,-1, -1, -1, -1);

        in.
                extract_area (100, 100, in.Xsize () - 200, in.Ysize () - 200).
                affine (0.9, 0, 0, 0.9, 0, 0,
                        0, 0, in.Xsize () * 0.9, in.Ysize () * 0.9).
                conv (mask).
                write (argv[2]);

        return 0;
}

