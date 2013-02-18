// compile with
// g++ vips.cc `pkg-config vipsCC --cflags --libs`

#include <vips/vips>

int main (int argc, char **argv)
{
        vips::VImage in (argv[1], "rs");
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
