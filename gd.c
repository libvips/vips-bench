// compile with
// gcc -Wall gd.c `pkg-config gdlib --cflags --libs` -o gd

#include <stdio.h>
#include <stdlib.h>

#include <gd.h>

int
main( int argc, char **argv )
{
	FILE *fp;
	gdImagePtr original, cropped,resized;
	if( argc != 3 ) {
		printf( "usage: %s in-jpeg out-jpeg\n", argv[0] );
		exit( 1 );
	}

	if( !(fp = fopen( argv[1], "r" )) ) {
		printf( "unable to open \"%s\"\n", argv[1] );
		exit( 1 );
	}
	if( !(original = gdImageCreateFromJpeg( fp )) ) {
		printf( "unable to load \"%s\"\n", argv[1] );
		exit( 1 );
	}
	fclose( fp );


  gdRect crop;
  crop.x = 100;
  crop.y = 100;
  crop.width = original->sx - 200;
  crop.height = original->sy - 200;
  cropped = gdImageCrop(original, &crop);
  gdImageDestroy( original );
  original = 0;

  if( !(cropped) ) {
    printf( "unable to crop image\n" ); 
    exit( 1 );
  }
  

  resized = gdImageScale(cropped, crop.width * 0.9, crop.height * 0.9);
  gdImageDestroy( cropped );
  cropped = 0;

  if( !(resized) ) {
    printf( "unable to resize image\n" ); 
    exit( 1 );
  }

  //gdImageSharpen is extremely slow
	//gdImageSharpen( resized, 75 );

	if( !(fp = fopen( argv[2], "w" )) ) {
		printf( "unable to open \"%s\"\n", argv[2] );
		exit( 1 );
	}
	gdImageJpeg( resized, fp, -1 );
	fclose( fp );

	gdImageDestroy( resized );

	return( 0 ); 
}

