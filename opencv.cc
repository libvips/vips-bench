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
  Mat img (t1);

  Mat crop (img, Rect (100, 100, img.cols - 200, img.rows - 200));

  Mat shrunk;
  resize (crop, shrunk, Size (0, 0), 0.9, 0.9);

  float m[3][3] = { {-1, -1, -1}, {-1, 16, -1}, {-1, -1, -1} };
  Mat kernel = Mat (3, 3, CV_32F, m) / 8.0;

  Mat sharp;
  filter2D (shrunk, sharp, -1, kernel, Point (-1, -1), 0, BORDER_REPLICATE);
  CvMat cvimg = sharp;
  cvSaveImage (argv[2], &cvimg);

  return 0;
}
