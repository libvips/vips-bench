// compile with
// g++ vips.cc `pkg-config vipsCC --cflags --libs`

#include <vips/vips8>

int 
main(int argc, char **argv)
{
        vips::VImage in = vips::VImage::new_from_file( argv[1] );

        vips::VImage mask = vips::VImage::new_from_args( 3, 3, 
                -1, -1, -1, -1, 16, -1, -1, -1, -1 );
	mask.set( "scale", 8 ); 

        in.
                extract_area( 100, 100, in.width() - 200, in.height() - 200 ).
                affine( to_vector( 4, 0.9, 0.0, 0.0, 0.9 ) ).
                conv( mask ).
                write_to_file( argv[2] );

        return 0;
}
