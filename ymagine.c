/* compile with

YMAGINE=/home/john/ymagine
gcc \
	-I $YMAGINE/framework/ymagine/jni/include \
	-I $YMAGINE/framework/yosal/include \
	-L $YMAGINE/out/target/linux-x86_64 \
	ymagine.c \
	-l yahoo_ymagine \
	-o ymagine-c

 */

#include "ymagine/ymagine.h"

#include <unistd.h>
#include <fcntl.h>

#ifndef O_BINARY
#define O_BINARY 0
#endif

/* Using a callback to set output options dynamically based on input image */

static int
progressCallback(YmagineFormatOptions *options,
                int format, int width, int height)
{
  /* scaleMode can be YMAGINE_SCALE_CROP or YMAGINE_SCALE_LETTERBOX */
  int scaleMode = YMAGINE_SCALE_LETTERBOX;
  int pad = 100;
  int cropwidth;
  int cropheight;
  int outwidth;
  int outheight;

  if (width <= 2 * pad || height <= 2 * pad) {
    return YMAGINE_OK;
  }

  cropwidth = width - 2 * pad;
  cropheight = height - 2 * pad;
  YmagineFormatOptions_setCrop(options, pad, pad, cropwidth, cropheight);

  outwidth = (cropwidth * 90) / 100;
  outheight = (cropheight * 90) / 100;
  if (outwidth < 1) {
    outwidth = 1;
  }
  if (outheight < 1) {
    outheight = 1;
  }
  YmagineFormatOptions_setResize(options, outwidth, outheight, scaleMode);

  return YMAGINE_OK;
}

int main(int argc, const char* argv[])
{
  int fdin;
  int fdout;
  const char* infile;
  const char* outfile;
  int rc = YMAGINE_ERROR;

  if (argc < 3) {
    fprintf(stdout, "usage: bench <infile> <outfile>\n");
    return 0;
  }

  infile = argv[1];
  outfile = argv[2];

  fdin = open(infile, O_RDONLY | O_BINARY);
  if (fdin < 0) {
    fprintf(stdout, "failed to open input file \"%s\"\n", infile);
  } else {
    int fmode = O_WRONLY | O_CREAT | O_BINARY;

    /* Truncate file if it already exisst */
    fmode |= O_TRUNC;

    fdout = open(outfile, fmode, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
    if (fdout < 0) {
      fprintf(stdout, "failed to open output file \"%s\"\n", outfile);
    } else {
      Ychannel *channelin = YchannelInitFd(fdin, 0);
      Ychannel *channelout = YchannelInitFd(fdout, 1);
      YmagineFormatOptions *options;

      options = YmagineFormatOptions_Create();
      YmagineFormatOptions_setFormat(options, YMAGINE_IMAGEFORMAT_JPEG);
      YmagineFormatOptions_setSharpen(options, 0.1);
      YmagineFormatOptions_setCallback(options, progressCallback);
      rc = YmagineTranscode(channelin, channelout, options);
      YmagineFormatOptions_Release(options);

      YchannelRelease(channelout);
      YchannelRelease(channelin);

      close(fdout);
    }

    close(fdin);
  }

  return 0;
}
