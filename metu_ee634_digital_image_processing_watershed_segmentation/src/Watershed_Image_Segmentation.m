%% PARROTS
clear
close all
% Reading in image, converting to intensity gray values.
I = imread('color-768x512-17.png');
I_hsv = rgb2hsv(I);
I_gray = I_hsv(:,:,3);
% Contrast adjustment by TOP/BOTTOM HAT filters
Itop = imtophat(I_gray,strel('disk',10));
Ibot = imbothat(I_gray,strel('disk',10));
A= imadjust(I_gray+Itop-Ibot);
% Morphological smoothing by TOP/BOTTOM HAT filters
Itop = imtophat(A,strel('disk',10));
Ibot = imbothat(A,strel('disk',10));
B= imadjust(Ibot+Itop);
% Gradient and threshold to get a marker image, also emphasize marker 
% regions.
thr = 0.57;
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(B), hy, 'replicate');
Ix = imfilter(double(B), hx, 'replicate');
Bgrad = imadjust(sqrt(Ix.^2 + Iy.^2));
Z = imerode(Bgrad<thr,strel('disk',12));
X = imfill(Z,'holes');
% Gradient of the gray-scale image
Iy = imfilter(double(I_gray), hy, 'replicate');
Ix = imfilter(double(I_gray), hx, 'replicate');
Igrad = sqrt(Ix.^2 + Iy.^2);
% Impose markers and take watershed segments
D = imimposemin(Igrad,X);
L = watershed(D);
rgb = label2rgb(L,'jet','k','shuffle');
% Visualize results in two distinct ways
figure
imshow(rgb)
title('Watershed Segmented Image','FontSize',15)
figure
imshow(I)
hold on
himage = imshow(imdilate(L==0,ones(2)));
himage.AlphaData = 0.5;
title('Watershed Ridge Lines Overlay on Original Image','FontSize',15)
%% BEACH
clear 
close all
% Reading in image, converting to intensity gray values.
I = imread('color-768x512-09.png');
I_hsv = rgb2hsv(I);
I_gray = I_hsv(:,:,3);
% Contrast adjustment by TOP/BOTTOM HAT filters
Itop = imtophat(I_gray,strel('disk',10));
Ibot = imbothat(I_gray,strel('disk',10));
A= imadjust(I_gray+Itop-Ibot);
% Morphological smoothing by TOP/BOTTOM HAT filters
Itop = imtophat(A,strel('disk',20));
Ibot = imbothat(A,strel('disk',10));
B= imadjust(Ibot+Itop);
% Gradient and threshold to get a marker image, also emphasize marker 
% regions.
thr = 0.3;
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(B), hy, 'replicate');
Ix = imfilter(double(B), hx, 'replicate');
Bgrad = imadjust(sqrt(Ix.^2 + Iy.^2));
Z = imerode(Bgrad<thr,strel('disk',10));
X = imfill(Z,'holes');
% Gradient of the gray-scale image
Iy = imfilter(double(I_gray), hy, 'replicate');
Ix = imfilter(double(I_gray), hx, 'replicate');
Igrad = sqrt(Ix.^2 + Iy.^2);
% Impose markers and take watershed segments
D = imimposemin(Igrad,X);
L = watershed(D);
rgb = label2rgb(L,'jet','k','shuffle');
% Visualize results in two distinct ways
figure
imshow(rgb)
title('Watershed Segmented Image','FontSize',15)
figure
imshow(I)
hold on
himage = imshow(imdilate(L==0,ones(2)));
himage.AlphaData = 0.5;
title('Watershed Ridge Lines Overlay on Original Image','FontSize',15)
%% HATS
clear 
close all
% Reading in image, converting to intensity gray values.
I = imread('color-768x512-03.png');
I_hsv = rgb2hsv(I);
I_gray = I_hsv(:,:,3);
% Contrast adjustment by TOP/BOTTOM HAT filters
Itop = imtophat(I_gray,strel('disk',20));
Ibot = imbothat(I_gray,strel('disk',10));
A= imadjust(I_gray+Itop-Ibot);
% Morphological smoothing by TOP/BOTTOM HAT filters
Itop = imtophat(A,strel('disk',15));
Ibot = imbothat(A,strel('disk',10));
B= imadjust(Ibot+Itop);
% Gradient and threshold to get a marker image, also emphasize marker 
% regions.
thr = 0.41;
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(B), hy, 'replicate');
Ix = imfilter(double(B), hx, 'replicate');
Bgrad = imadjust(sqrt(Ix.^2 + Iy.^2));
Z = imerode(Bgrad<thr,strel('disk',13));
X = imfill(Z,'holes');
% Gradient of the gray-scale image
Iy = imfilter(double(I_gray), hy, 'replicate');
Ix = imfilter(double(I_gray), hx, 'replicate');
Igrad = sqrt(Ix.^2 + Iy.^2);
% Impose markers and take watershed segments
D = imimposemin(Igrad,X);
L = watershed(D);
rgb = label2rgb(L,'jet','k','shuffle');
% Visualize results in two distinct ways
figure
imshow(rgb)
title('Watershed Segmented Image','FontSize',15)
figure
imshow(I)
hold on
himage = imshow(imdilate(L==0,ones(2)));
himage.AlphaData = 0.5;
title('Watershed Ridge Lines Overlay on Original Image','FontSize',15)
%% PEPPERS
clear 
close all
% Reading in image, converting to intensity gray values.
I = imread('color-512x512-06.png');
I_hsv = rgb2hsv(I);
I_gray = I_hsv(:,:,3);
% Contrast adjustment by TOP/BOTTOM HAT filters
Itop = imtophat(I_gray,strel('disk',10));
Ibot = imbothat(I_gray,strel('disk',10));
A= imadjust(I_gray+Itop-Ibot);
% Morphological smoothing by TOP/BOTTOM HAT filters
Itop = imtophat(A,strel('disk',10));
Ibot = imbothat(A,strel('disk',10));
B= imadjust(Ibot+Itop);
% Gradient and threshold to get a marker image, also emphasize marker 
% regions.
thr = 0.5;
hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(B), hy, 'replicate');
Ix = imfilter(double(B), hx, 'replicate');
Bgrad = imadjust(sqrt(Ix.^2 + Iy.^2));
Z = imerode(Bgrad<thr,strel('disk',10));
X = imfill(Z,'holes');
% Gradient of the gray-scale image
Iy = imfilter(double(I_gray), hy, 'replicate');
Ix = imfilter(double(I_gray), hx, 'replicate');
Igrad = sqrt(Ix.^2 + Iy.^2);
% Impose markers and take watershed segments
D = imimposemin(Igrad,X);
L = watershed(D);
rgb = label2rgb(L,'jet','k','shuffle');
% Visualize results in two distinct ways
figure
imshow(rgb)
title('Watershed Segmented Image','FontSize',15)
figure
imshow(I)
hold on
himage = imshow(imdilate(L==0,ones(2)));
himage.AlphaData = 0.5;
title('Watershed Ridge Lines Overlay on Original Image','FontSize',15)
%% CANDIES
clear 
close all
% Reading in image, converting to intensity gray values.
I = imread('color-256x256-04.png');
I_gray = rgb2gray(I);
I_gray = imadjust(I_gray,stretchlim(I_gray));

B1 = imquantize(I_gray,multithresh(I_gray,10));
B2 = zeros(size(B1),'uint8');
B2(B1<10) = 255;
B2 = imclearborder(B2);
B2 = imopen(B2,strel('disk',1));
B3 = imdilate(B2,strel('disk',1));

I1 = imerode(I_gray,strel('square',2));
I1 = imreconstruct(I1,I_gray);
I2 = imregionalmax(I1);
I2 = imdilate(I2,strel('disk',1));

h = fspecial('Sobel');
I_filt = sqrt(imfilter(double(I_gray), h, 'replicate').^2 + imfilter(double(I_gray), h', 'replicate').^2);
I_filt2 = imquantize(I_filt,multithresh(I_filt,10));
I_filt2 = I_filt2>2;
I_filt3 = bwareaopen(I_filt2,40);

basin = ~(~I2&B3);

D = imimposemin(im2double(I_filt3),basin);

L = watershed(D);
rgb = label2rgb(L,'jet','k','shuffle');

figure
imshow(rgb)
title('Watershed Segmented Image','FontSize',15)

figure
imshow(I)
hold on
himage = imshow(imdilate(L==0,ones(2)));
himage.AlphaData = 0.5;
title('Watershed Ridge Lines Overlay on Original Image','FontSize',15)