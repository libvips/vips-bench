#!/usr/bin/env php
<?php

if (!extension_loaded("imagick")) {
	dl('imagick.' . PHP_SHLIB_SUFFIX);
}

$im = new imagick($argv[1]);

$geo = $im->getImageGeometry(); 
$im->cropImage($geo['width'] - 200, $geo['height'] - 200, 100, 100);

$geo = $im->getImageGeometry(); 
$im->resizeImage($geo['width'] * 0.9, $geo['height'] * 0.9, imagick::FILTER_TRIANGLE, 1);

$kernel = [-1, -1, -1, -1, 8, -1, -1, -1, -1];
$im->convolveImage($kernel);

$im->writeImage($argv[2]);

$im->destroy();
