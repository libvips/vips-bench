// compile with
// gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c

#include <vips/vips.h>

int 
main( int argc, char **argv )
{
	GOptionContext *context;
	VipsImage *global;
	VipsImage **t;

	GError *error = NULL;

	if( vips_init( argv[0] ) )
		return( -1 );

	context = g_option_context_new( " - VIPS benchmark program" );
	g_option_context_add_group( context, vips_get_option_group() );
	if( !g_option_context_parse( context, &argc, &argv, &error ) ) {
		if( error ) {
			fprintf( stderr, "%s\n", error->message );
			g_error_free( error );
		}

		vips_error_exit( NULL );
	}

	global = vips_image_new();
	t = (VipsImage **) vips_object_local_array( VIPS_OBJECT( global ), 5 );

	if( !(t[0] = vips_image_new_mode( argv[1], "r" )) )
		vips_error_exit( "unable to read %s", argv[1] );

	t[1] = vips_image_new_matrixv( 3, 3, 
		-1, -1, -1, -1, 16,-1, -1, -1, -1 );
	vips_image_set_double( t[1], "scale", 8 ); 

	if( vips_extract_area( t[0], &t[2], 
                100, 100, t[0]->Xsize - 200, t[0]->Ysize - 200, NULL ) ||
		vips_affine( t[2], &t[3], 0.9, 0, 0, 0.9, NULL ) ||
		vips_conv( t[3], &t[4], t[1], NULL ) ||
		vips_image_write_to_file( t[4], argv[2] ) )
		return( -1 );

	g_object_unref( global );

	return( 0 );
}
