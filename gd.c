// compile with
// gcc -Wall gd.c `pkg-config gdlib --cflags --libs` -o gd

#include <stdio.h>
#include <stdlib.h>

#include <gd.h>

int
main( int argc, char **argv )
{
	FILE *fp;
	gdImagePtr im, x;
	int dx, dy;

	if( argc != 3 ) {
		printf( "usage: %s in-jpeg out-jpeg\n", argv[0] );
		exit( 1 );
	}

	if( !(fp = fopen( argv[1], "r" )) ) {
		printf( "unable to open \"%s\"\n", argv[1] );
		exit( 1 );
	}
	if( !(im = gdImageCreateFromJpeg( fp )) ) {
		printf( "unable to load \"%s\"\n", argv[1] );
		exit( 1 );
	}
	fclose( fp );

	dx = 0.9 * (im->sx - 200);
	dy = 0.9 * (im->sy - 200);
	if( !(x = gdImageCreateTrueColor( dx, dy )) ) {
		printf( "unable to create temp image\n" ); 
		exit( 1 );
	}
	gdImageCopyResampled( x, im, 
		0, 0, 100, 100, 
		dx, dy, im->sx - 200, im->sy - 200 ); 
	gdImageDestroy( im );
	im = x;

	gdImageSharpen( im, 75 );

	if( !(fp = fopen( argv[2], "w" )) ) {
		printf( "unable to open \"%s\"\n", argv[2] );
		exit( 1 );
	}
	gdImageJpeg( im, fp, -1 );
	fclose( fp );

	gdImageDestroy( im );

	return( 0 ); 
}

