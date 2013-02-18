/* Compile with:
 *
 *    gcc freeimage.c -lfreeimage
 *
 *     */

#include <FreeImage.h>

int
main (int argc, char **argv)
{       
  FIBITMAP *t1;
  FIBITMAP *t2;
  int width;
  int height;

  FreeImage_Initialise (FALSE);

  t1 = FreeImage_Load (FIF_TIFF, argv[1], TIFF_DEFAULT);

  width = FreeImage_GetWidth (t1); 
  height = FreeImage_GetHeight (t1); 

  t2 = FreeImage_Copy (t1, 100, 100, width - 100, height - 100); 
  FreeImage_Unload (t1); 

  t1 = FreeImage_Rescale (t2, (width - 200) * 0.9, (height - 200) * 0.9,
                          FILTER_BILINEAR);
  FreeImage_Unload (t2); 

  /* FreeImage does not have a sharpen operation, so we skip that.
 *    */

  FreeImage_Save (FIF_TIFF, t1, argv[2], TIFF_DEFAULT);
  FreeImage_Unload (t1); 

  FreeImage_DeInitialise ();

  return 0;
}      

