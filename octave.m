#!/usr/bin/octave -qf

% this segvs for me on (amost) any image, strange

pkg load image

im = imread(argv(){1});
im = im(101:end-100, 101:end-100);        % Crop
im = imresize(im, 0.9, 'linear');         % Shrink    
myFilter = [-1 -1 -1
            -1 16 -1
	    -1 -1 -1]; 
im = conv2(double(im), myFilter);         % Sharpen
im = max(0, im ./ (max(max(im)) / 255));  % Renormalize
imwrite(uint8(im), argv(){2}); 		  % write back

