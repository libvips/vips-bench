#!/usr/bin/env php
<?php

include '../vips.php';

$im = VImage::new_from_file($argv[1], ["access" => "sequential"]);

$im = $im->crop(100, 100, $im->width - 200, $im->height - 200);

$im = $im->similarity(["scale" => 0.9]);  

$mask = VImage::new_from_array(
		  [[-1,  -1, -1], 
		   [-1,  16, -1], 
		   [-1,  -1, -1]], 8);
$im = $im->conv($mask);

$im->write_to_file($argv[2]);

?>
