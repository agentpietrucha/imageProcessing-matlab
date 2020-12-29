clear all; close all; clc;

img_org = imread('chest-xray.jpg');
[height, width, ch] = size(img_org);
figure(1);
image(img_org);
title('original');
img = imread('chest-xray_3.bmp');
img = double(img);
img_gray = img;
img_gray(:,:,1) = (img(:,:,1) + img(:,:,2) + img(:,:,3)) ./ 3;
img_gray(:,:,2) = img_gray(:,:,1);
img_gray(:,:,3) = img_gray(:,:,1);
img_gray = uint8(img_gray);
figure(2);
image(img_gray);
title('gray damaged');

brightness_procent = -20;
brightness = (brightness_procent / 100) * 255;
b_img_org = img_org + brightness;
for i = 1:height
    for j = 1:width
        if b_img_org(i, j, 1) > 255
            b_img_org(i, j, 1) = 255;
        end
        if b_img_org(i, j, 1) < 0
            b_img_org(i, j, 1) = 0;
        end
        if b_img_org(i, j, 2) > 255
            b_img_org(i, j, 2) = 255;
        end
        if b_img_org(i, j, 2) < 0
            b_img_org(i, j, 2) = 0;
        end
        if b_img_org(i, j, 3) > 255
            b_img_org(i, j, 3) = 255;
        end
        if b_img_org(i, j, 3) < 0
            b_img_org(i, j, 3) = 0;
        end
    end
end
figure(3);
image(b_img_org);
title('brightness');


contrast_procent = 100;
contrast = (contrast_procent/100) + 1;
contrast_img = img_org .* contrast;
for i = 1:height
    for j = 1:width
        if contrast_img(i, j, 1) > 255
            contrast_img(i, j, 1) = 255;
        end
        if contrast_img(i, j, 1) < 0
            contrast_img(i, j, 1) = 0;
        end
        if contrast_img(i, j, 2) > 255
            contrast_img(i, j, 2) = 255;
        end
        if contrast_img(i, j, 2) < 0
            contrast_img(i, j, 2) = 0;
        end
        if contrast_img(i, j, 3) > 255
            contrast_img(i, j, 3) = 255;
        end
        if contrast_img(i, j, 3) < 0
            contrast_img(i, j, 3) = 0;
        end
    end
end
figure(4);
image(img_org .* contrast);
title('contrast')



img_gray_d = double(img_gray);
res = img_gray_d;
res(:,:,1) = 255 .* ((img_gray_d(:,:,1) - min(img_gray_d(:,:,1), [], 'all')) ./ (max(img_gray_d(:,:,1), [], 'all') - min(img_gray_d(:,:,1), [], 'all')));
res(:,:,2) = res(:,:,1);
res(:,:,3) = res(:,:,1);
figure(5);
image(uint8(res));
title('regular normalization');


hist = zeros(1, 256);
for i = 1:height
    for j = 1:width
        if (img_gray(i, j, 1) >= 0) && (img_gray(i, j, 1) <= 255)
            hist(img_gray(i, j, 1) + 1) = hist(img_gray(i, j, 1) + 1) + 1;
        end
    end
end


cum = zeros(1, 256);
for i = 2:256
    cum(i) = cum(i - 1) + hist(i);
end

cumImg = img_gray;
gray = img_gray;

for i = 1:height
    for j = 1:width
        if cumImg(i, j, 1) < 0
            cumImg(i, j, 1) = 0;
        elseif cumImg(i, j, 1) > 255
            cumImg(i, j, 1) = 255;
        else            
            cumImg(i, j, 1) = (255 * cum(gray(i, j, 1)) / cum(255)); 
        end
    end
end
cumImg(:,:,2) = cumImg(:,:,1);
cumImg(:,:,3) = cumImg(:,:,1);
figure(6);
image(cumImg);
title('cum');



tmp = (img_gray .* contrast) + brightness;
for i = 1:height
    for j = 1:width
        if tmp(i, j, 1) > 255
            tmp(i, j, 1) = 255;
        end
        if tmp(i, j, 1) < 0
            tmp(i, j, 1) = 0;
        end
        if tmp(i, j, 2) > 255
            tmp(i, j, 2) = 255;
        end
        if tmp(i, j, 2) < 0
            tmp(i, j, 2) = 0;
        end
        if tmp(i, j, 3) > 255
            tmp(i, j, 3) = 255;
        end
        if tmp(i, j, 3) < 0
            tmp(i, j, 3) = 0;
        end
    end
end
figure(7);
image(tmp);
title('contrast + brightness');




