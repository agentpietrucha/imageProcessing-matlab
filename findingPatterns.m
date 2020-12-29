close all; clear all; clc;

img = imread('cancer.bmp');
pattern = imread('cell.bmp');

img = double(img);
pattern = double(pattern);
img = (img(:,:,1) + img(:,:,2) + img(:,:,3)) ./ 3;
pattern = (pattern(:,:,1) + pattern(:,:,2) + pattern(:,:,3)) ./ 3;
img = uint8(img);
img_copy = img;
pattern = uint8(pattern);

[iheight, iwidth] = size(img);
[pheight, pwidth] = size(pattern);

figure(1);
image(img);
colormap(gray);
figure(2);
image(pattern);
colormap(gray);

acc = zeros(iheight-pheight+1, iwidth-pwidth+1);

for i = 1:iheight-pheight+1
    for j = 1:iwidth-pwidth+1
        acc(i, j) = 255*pwidth*pheight-sum(abs(img(i:i+pheight-1, j:j+pwidth-1)-pattern), 'all');
    end
end
figure(4);
surf(acc);

for k=1:8
    maxVal = 0;
    x = 0;
    y = 0;
    for i=1:iheight - pheight + 1
        for j=1:iwidth - pwidth + 1
            if acc(i, j) > maxVal
                maxVal = acc(i, j);
                x = j;
                y = i;
            end
        end
    end
    img(y:y+pwidth-1, x:x+pheight-1) = 0;
    acc(y:y+pwidth-1, x:x+pheight-1) = min(acc, [], 'all');
end
figure(5);
surf(acc);

figure(3);
image(img);
colormap(gray);