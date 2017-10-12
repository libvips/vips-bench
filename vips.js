#!/usr/bin/env node

var vips = require('../node-vips');

image = vips.Image.newFromFile(process.argv[2], {access: 'sequential'});

image = image.crop(100, 100, image.width - 200, image.height - 200);

image = image.reduce(1.0 / 0.9, 1.0 / 0.9, {kernel: 'linear'});

mask = vips.Image.newFromArray(
    [[-1,  -1, -1], 
     [-1,  16, -1], 
     [-1,  -1, -1]], 8);
image = image.conv(mask, {precision: 'integer'});

image.writeToFile(process.argv[3]);
