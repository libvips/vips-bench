// compile with
// gcc -Wall vips.c `pkg-config vips --cflags --libs` -o vips-c

#include <vips/vips.h>

int 
main( int argc, char **argv )
{
        VipsImage *global;
        VipsImage **t;

        if( VIPS_INIT( argv[0] ) )
                return( -1 );

        global = vips_image_new();
        t = (VipsImage **) vips_object_local_array( VIPS_OBJECT( global ), 5 );

        if( !(t[0] = vips_image_new_from_file( argv[1], NULL )) )
                vips_error_exit( NULL );

        t[1] = vips_image_new_matrixv( 3, 3, 
                -1.0, -1.0, -1.0, 
                -1.0, 16.0, -1.0,
                -1.0, -1.0, -1.0 );
        vips_image_set_double( t[1], "scale", 8 );

        if( vips_crop( t[0], &t[2], 
                100, 100, t[0]->Xsize - 200, t[0]->Ysize - 200, NULL ) ||
			/* lanczos2 version, handy for testing against pillow
		vips_reduce( t[2], &t[3], 1.0 / 0.9, 1.0 / 0.9, 
			"kernel", VIPS_KERNEL_LANCZOS2,
			NULL ) ||
			 */
		vips_reduce( t[2], &t[3], 1.0 / 0.9, 1.0 / 0.9, 
			"kernel", VIPS_KERNEL_LINEAR,
			NULL ) ||
                vips_conv( t[3], &t[4], t[1], 
			"precision", VIPS_PRECISION_INTEGER,
			NULL ) ||
                vips_image_write_to_file( t[4], argv[2], NULL ) )
                vips_error_exit( NULL ); 

        g_object_unref( global );

        return( 0 );
}
