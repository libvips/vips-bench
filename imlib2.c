/* compile with
 *
 * gcc -g -Wall imlib2.c `pkg-config imlib2 --cflags --libs`
 */

#include <string.h>
#include <stdlib.h>

#include <Imlib2.h>

int
main( int argc, char **argv )
{
	Imlib_Image image;
	int width;
	int height;
	char *tmp;
		    
	if( argc != 3 ) 
		exit( 1 );

	if( !(image = imlib_load_image( argv[1] )) )
		exit( 1 );

	/* set the image we loaded as the current context image to work on 
	 */
	imlib_context_set_image( image );
	width = imlib_image_get_width();
	height = imlib_image_get_height();
	if( !(image = imlib_create_cropped_scaled_image( 100, 100, 
		width - 200, height - 200,
		(width - 200) * 0.9,
		(height - 200) * 0.9 )) )
		exit( 1 );
	imlib_free_image();
	imlib_context_set_image( image );

	imlib_image_sharpen( 1 );

	if( (tmp = strrchr( argv[2], '.' )) )
		imlib_image_set_format( tmp + 1 );

	/* save the image 
	 */
	imlib_save_image( argv[2] );
	imlib_free_image();

	return( 0 );
}
