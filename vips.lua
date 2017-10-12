#!/usr/bin/luajit

local vips = require("vips")

image = vips.Image.new_from_file(arg[1], {access = "sequential"})

image = image:crop(100, 100, image:width() - 200, image:height() - 200)

image = image:reduce(1.0 / 0.9, 1.0 / 0.9, {kernel = "linear"})

mask = vips.Image.new_from_array(
    {{-1,  -1, -1}, 
     {-1,  16, -1}, 
     {-1,  -1, -1}}, 8)
image = image:conv(mask, {precision = "integer"})

image:write_to_file(arg[2]);
