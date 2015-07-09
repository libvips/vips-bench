/* compile with:

   g++ -g -Wall opencv-umat.cc `pkg-config opencv --cflags --libs`

   code from Amadan@shacknews, thank you very much!

   this uses the opencv3 thing that lets it chose to use opencl, or threading, 
   or whatever 
   
   unfortunately, ubuntu is still on opencv 2.4.9 so we can't try this yet

   Amadan says that on his machine this code is only about 10% faster than 
   regular opencv2, I guess it's spending a lot of time in tiff load and save

 */

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int
main (int argc, char **argv)
{
  UMat img;
  imread (argv[1]).copyTo (img);

  if (img.empty ())
    return 1;

  UMat crop = UMat (img, Rect (100, 100, img.cols - 200, img.rows - 200));

  UMat shrunk;
  resize (crop, shrunk, Size (0, 0), 0.9, 0.9);

  float m[3][3] = { {-1, -1, -1}, {-1, 16, -1}, {-1, -1, -1} };
  Mat kernel = Mat (3, 3, CV_32F, m) / 8.0;
  UMat k;
  kernel.copyTo (k);

  UMat sharp;
  filter2D (shrunk, sharp, -1, k, Point (-1, -1), 0, BORDER_REPLICATE);

  imwrite (argv[2], sharp);

  return 0;
}
