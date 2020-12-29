clear all; close all; clc;

%    pt1   pt2
%    pt3   pt4
% pt1 wygładzający
% pt2 wyostrzający
% pt3 medianowy
% pt4 gaussa

img = imread('skull.jpg');
img = double(img);
[height, width, ch] = size(img);

pt1 = img(1:height/2, 1:width/2, :);
pt2 = img(1:height/2, width/2:width-1, :);
pt3 = img(height/2:height-1, 1:width/2, :);
pt4 = img(height/2:height-1, width/2:width-1, :);

filter1 = [1 1 1;
           1 2 1;
           1 1 1];
[f1_height, f1_width] = size(filter1);
f1Sum = sum(filter1, 'all');
filter2 = [1 -2  1;
          -2  5 -2;
           1 -2  1];
[f2_height, f2_width] = size(filter2);

tmp1_R = double(padarray(pt1(:,:,1), [(f1_height-1)/2 (f1_height-1)/2], 0, 'both'));
tmp1_G = double(padarray(pt1(:,:,2), [(f1_height-1)/2 (f1_height-1)/2], 0, 'both'));
tmp1_B = double(padarray(pt1(:,:,3), [(f1_height-1)/2 (f1_height-1)/2], 0, 'both'));

pt1_work(:,:,1) = tmp1_R;
pt1_work(:,:,2) = tmp1_G;
pt1_work(:,:,3) = tmp1_B;

[height1, width1] = size(tmp1_R);

for i=1:height1-f1_height+1
    for j=1:width1-f1_width+1
        pt1_work(i+(f1_height-1)/2, j+(f1_width-1)/2, 1) = sum(tmp1_R(i:i+f1_height-1, j:j+f1_width-1) .* double(filter1), 'all');
        pt1_work(i+(f1_height-1)/2, j+(f1_width-1)/2, 2) = sum(tmp1_G(i:i+f1_height-1, j:j+f1_width-1) .* double(filter1), 'all');
        pt1_work(i+(f1_height-1)/2, j+(f1_width-1)/2, 3) = sum(tmp1_B(i:i+f1_height-1, j:j+f1_width-1) .* double(filter1), 'all');
    end
end
pt1_res(:,:,1) = pt1_work(1+(f1_height-1)/2:height1-(f1_height-1)/2, 1+(f1_width-1)/2:width1-(f1_width-1)/2, 1)./f1Sum;
pt1_res(:,:,2) = pt1_work(1+(f1_height-1)/2:height1-(f1_height-1)/2, 1+(f1_width-1)/2:width1-(f1_width-1)/2, 2)./f1Sum;
pt1_res(:,:,3) = pt1_work(1+(f1_height-1)/2:height1-(f1_height-1)/2, 1+(f1_width-1)/2:width1-(f1_width-1)/2, 3)./f1Sum;

tmp2_R = double(padarray(pt2(:,:,1), [(f2_height-1)/2 (f2_height-1)/2], 0, 'both'));
tmp2_G = double(padarray(pt2(:,:,2), [(f2_height-1)/2 (f2_height-1)/2], 0, 'both'));
tmp2_B = double(padarray(pt2(:,:,3), [(f2_height-1)/2 (f2_height-1)/2], 0, 'both'));

[height2, width2] = size(tmp2_R);

pt2_work = zeros(height2, width2, 3);
pt2_work(:,:,1) = tmp2_R;
pt2_work(:,:,2) = tmp2_G;
pt2_work(:,:,3) = tmp2_B;



for i=1:height2-f2_height+1
    for j=1:width2-f2_width+1
        pt2_work(i+(f1_height-1)/2, j+(f1_width-1)/2, 1) = sum(tmp2_R(i:i+f2_height-1, j:j+f2_width-1) .* double(filter2), 'all');
        pt2_work(i+(f1_height-1)/2, j+(f1_width-1)/2, 2) = sum(tmp2_G(i:i+f2_height-1, j:j+f2_width-1) .* double(filter2), 'all');
        pt2_work(i+(f1_height-1)/2, j+(f1_width-1)/2, 3) = sum(tmp2_B(i:i+f2_height-1, j:j+f2_width-1) .* double(filter2), 'all');
    end
end

mxR = max(pt2_work(:,:,1), [], 'all');
mxG = max(pt2_work(:,:,2), [], 'all');
mxB = max(pt2_work(:,:,3), [], 'all');

mnR = min(pt2_work(:,:,1), [], 'all');
mnG = min(pt2_work(:,:,2), [], 'all');
mnB = min(pt2_work(:,:,3), [], 'all');

pt2_res(:,:,1) = pt2_work(1+(f2_height-1)/2:height2-(f2_height-1)/2, 1+(f2_width-1)/2:width2-(f2_width-1)/2, 1);
pt2_res(:,:,2) = pt2_work(1+(f2_height-1)/2:height2-(f2_height-1)/2, 1+(f2_width-1)/2:width2-(f2_width-1)/2, 2);
pt2_res(:,:,3) = pt2_work(1+(f2_height-1)/2:height2-(f2_height-1)/2, 1+(f2_width-1)/2:width2-(f2_width-1)/2, 3);

median_size = 33;

tmp3_R = double(padarray(pt3(:,:,1), [(median_size-1)/2 (median_size-1)/2], 0, 'both'));
tmp3_G = double(padarray(pt3(:,:,2), [(median_size-1)/2 (median_size-1)/2], 0, 'both'));
tmp3_B = double(padarray(pt3(:,:,3), [(median_size-1)/2 (median_size-1)/2], 0, 'both'));

[height3, width3] = size(tmp3_R);

pt3_work = zeros(height3, width3, 3);
pt3_work(:,:,1) = tmp3_R;
pt3_work(:,:,2) = tmp3_G;
pt3_work(:,:,3) = tmp3_B;

for i=1:height3-median_size+1
    for j=1:width3-median_size+1
        pt3_work(i+(median_size-1)/2, j+(median_size-1)/2, 1) = median(tmp3_R(i:i+median_size-1, j:j+median_size-1), 'all');
        pt3_work(i+(median_size-1)/2, j+(median_size-1)/2, 2) = median(tmp3_G(i:i+median_size-1, j:j+median_size-1), 'all');
        pt3_work(i+(median_size-1)/2, j+(median_size-1)/2, 3) = median(tmp3_B(i:i+median_size-1, j:j+median_size-1), 'all');
    end
end


pt3_res(:,:,1) = pt3_work(1+(median_size-1)/2:height3-(median_size-1)/2, 1+(median_size-1)/2:width3-(median_size-1)/2, 1);
pt3_res(:,:,2) = pt3_work(1+(median_size-1)/2:height3-(median_size-1)/2, 1+(median_size-1)/2:width3-(median_size-1)/2, 2);
pt3_res(:,:,3) = pt3_work(1+(median_size-1)/2:height3-(median_size-1)/2, 1+(median_size-1)/2:width3-(median_size-1)/2, 3);

sigma = 1.76;
gmasksize = 2;
[x, y] = meshgrid(-gmasksize:gmasksize,-gmasksize:gmasksize);
exp_comp = -(x.^2+y.^2)/(2*sigma*sigma);
kernel= exp(exp_comp)/(2*pi*sigma*sigma);
[kheight, kwidth] = size(kernel);


tmp4_R = double(padarray(pt4(:,:,1), [gmasksize gmasksize], 0, 'both'));
tmp4_G = double(padarray(pt4(:,:,2), [gmasksize gmasksize], 0, 'both'));
tmp4_B = double(padarray(pt4(:,:,3), [gmasksize gmasksize], 0, 'both'));

[height4, width4] = size(tmp4_R);

pt4_work = zeros(height4, width4, 3);
pt4_work(:,:,1) = tmp4_R;
pt4_work(:,:,2) = tmp4_G;
pt4_work(:,:,3) = tmp4_B;

for i=1:height4-kheight+1
    for j=1:width4-kheight+1
        pt4_work(i+(kheight-1)/2, j+(kwidth-1)/2, 1) = sum(double(tmp4_R(i:i+kheight-1, j:j+kwidth-1)) .* kernel, 'all');
        pt4_work(i+(kheight-1)/2, j+(kwidth-1)/2, 2) = sum(double(tmp4_G(i:i+kheight-1, j:j+kwidth-1)) .* kernel, 'all');
        pt4_work(i+(kheight-1)/2, j+(kwidth-1)/2, 3) = sum(double(tmp4_B(i:i+kheight-1, j:j+kwidth-1)) .* kernel, 'all');
    end
end


pt4_res(:,:,1) = pt4_work(1+(kheight-1)/2:height4-(kheight-1)/2, 1+(kwidth-1)/2:width4-(kwidth-1)/2, 1);
pt4_res(:,:,2) = pt4_work(1+(kheight-1)/2:height4-(kheight-1)/2, 1+(kwidth-1)/2:width4-(kwidth-1)/2, 2);
pt4_res(:,:,3) = pt4_work(1+(kheight-1)/2:height4-(kheight-1)/2, 1+(kwidth-1)/2:width4-(kwidth-1)/2, 3);

manual_res = [pt1_res pt2_res; pt3_res pt4_res];
figure(1);
image(uint8(manual_res));
title('manual filters')

pt1_ref(:,:,1) = conv2(pt1(:,:,1), filter1, 'same')./f1Sum;
pt1_ref(:,:,2) = conv2(pt1(:,:,2), filter1, 'same')./f1Sum;
pt1_ref(:,:,3) = conv2(pt1(:,:,3), filter1, 'same')./f1Sum;

pt2_ref(:,:,1) = conv2(pt2(:,:,1), filter2, 'same');
pt2_ref(:,:,2) = conv2(pt2(:,:,2), filter2, 'same');
pt2_ref(:,:,3) = conv2(pt2(:,:,3), filter2, 'same');

pt3_ref(:,:,1) = medfilt2(pt3(:,:,1), [median_size median_size]);
pt3_ref(:,:,2) = medfilt2(pt3(:,:,2), [median_size median_size]);
pt3_ref(:,:,3) = medfilt2(pt3(:,:,3), [median_size median_size]);

tmp = fspecial('Gaussian',[gmasksize*2+1 gmasksize*2+1],1.27);
pt4_ref(:,:,1) = imfilter(pt4(:,:,1), tmp, 'same');
pt4_ref(:,:,2) = imfilter(pt4(:,:,2), tmp, 'same');
pt4_ref(:,:,3) = imfilter(pt4(:,:,3), tmp, 'same');

ref_res = [pt1_ref pt2_ref; pt3_ref pt4_ref];
figure(2);
image(uint8(ref_res));