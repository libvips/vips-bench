/*
   g++ -g -Wall opencv.cc `pkg-config opencv --cflags --libs`

   best run

   $ time ./a.out wtc_tiled_small.tif out.tif

   real	0m0.973s
   user	0m0.690s
   sys	0m0.260s

   peak mem, 185mb
 */

#include <cv.h>
#include <highgui.h>

using namespace cv;

int
main (int argc, char **argv)
{
  Ptr < IplImage > t1;

  if (!(t1 = cvLoadImage (argv[1])))
    return 1;
  cvSaveImage (argv[2], t1);

  return 0;
}
