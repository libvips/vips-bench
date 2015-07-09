/* compile with:

   g++ -g -Wall opencv.cc `pkg-config opencv --cflags --libs`

   code from Amadan@shacknews, thank you very much!

 */

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int
main (int argc, char **argv)
{
  Mat img = imread (argv[1]);

  if (img.empty ())
    return 1;

  Mat crop = Mat (img, Rect (100, 100, img.cols - 200, img.rows - 200));

  Mat shrunk;
  resize (crop, shrunk, Size (0, 0), 0.9, 0.9);

  float m[3][3] = { {-1, -1, -1}, {-1, 16, -1}, {-1, -1, -1} };
  Mat kernel = Mat (3, 3, CV_32F, m) / 8.0;

  Mat sharp;
  filter2D (shrunk, sharp, -1, kernel, Point (-1, -1), 0, BORDER_REPLICATE);

  imwrite (argv[2], sharp);

  return 0;
}
