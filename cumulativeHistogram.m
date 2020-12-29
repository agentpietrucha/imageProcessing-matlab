% fixing image using cumulative histogram
% displaying R, G, B channels of input image

clear all; close all; clc;

img = imread('chest-xray_3.bmp');
img = double(img);
[height, width, channels] = size(img);
figure(1);
image(uint8(img));
title('original image');

img_gray = img;
img_gray(:,:,1) = (img(:,:,1) + img(:,:,2) + img(:,:,3)) ./ 3;
img_gray(:,:,2) = img_gray(:,:,1);
img_gray(:,:,3) = img_gray(:,:,1);
img_gray = uint8(img_gray);
figure(2);
image(img_gray);
title('gray image');


imgRED = img; imgGREEN = img; imgBLUE = img;
imgRED(:,:,2) = img(:,:,2) * 0;
imgRED(:,:,3) = img(:,:,3) * 0;
imgRED = uint8(imgRED);
figure(3);
image(imgRED);
title('red channel');

imgGREEN(:,:,1) = img(:,:,1) * 0;
imgGREEN(:,:,3) = img(:,:,3) * 0;
imgGREEN = uint8(imgGREEN);
figure(4);
image(imgGREEN);
title('green channel');

imgBLUE(:,:,1) = img(:,:,1) * 0;
imgBLUE(:,:,2) = img(:,:,2) * 0;
imgBLUE = uint8(imgBLUE);
figure(5);
image(imgBLUE);
title('blue channel');

hist = zeros(1, 256);
histRed = zeros(1, 256);
histGreen = zeros(1, 256);
histBlue = zeros(1, 256);
cum = zeros(1, 256);
for i = 1:height
    for j = 1:width
        if (img_gray(i, j) >= 0) && (img_gray(i, j) <= 255)
            hist(img_gray(i, j) + 1) = hist(img_gray(i, j) + 1) + 1;
        end
        if (img(i, j, 1) >= 0) && (img(i, j, 1) <= 255)
            histRed(img(i, j, 1) + 1) = histRed(img(i, j, 1) + 1) + 1;
        end
        if (img(i, j, 2) >= 0) && (img(i, j, 2) <= 255)
            histGreen(img(i, j, 2) + 1) = histGreen(img(i, j, 2) + 1) + 1;
        end
        if (img(i, j, 3) >= 0) && (img(i, j, 3) <= 255)
            histBlue(img(i, j, 3) + 1) = histBlue(img(i, j, 3) + 1) + 1;
        end
    end
end
figure(6)
plot(hist, 'k')
hold on
plot(histRed, 'r')
plot(histGreen, 'g')
plot(histBlue, 'b')
hold off

cum = zeros(1, 256);
for i = 2:256
    cum(i) = cum(i - 1) + hist(i);
end
figure(7)
plot(cum)

cumImg = img_gray(:,:,1);
gray = img_gray(:,:,1);

for i = 1:height
    for j = 1:width
        if cumImg(i, j) < 0
            cumImg(i, j) = 0;
        elseif cumImg(i, j) > 255
            cumImg(i, j) = 255;
        else            
            cumImg(i, j) = (255 * cum(gray(i, j)) / cum(255)); 
        end
    end
end

cumImg(:,:,1) = cumImg;
cumImg(:,:,2) = cumImg(:,:,1);
cumImg(:,:,3) = cumImg(:,:,1);

figure(8);
image(uint8(cumImg));
title('cumulative image');

cumHist = zeros(1, 256);

for i = 1:height
    for j = 1:width
        if(cumImg(i, j) >= 0) && (cumImg(i, j) <= 255)
            cumHist(cumImg(i, j) + 1) = cumHist(cumImg(i, j) + 1) + 1;
        end
    end
end

figure(9);
bar(cumHist);
title('cumulative histogram');