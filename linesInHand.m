% finding lines in xray image of hand

clear all; close all; clc;

img = imread('hand.jpg');
img = img(:,:,1);
size(img)
figure(1);
image(img);
colormap(gray);
title('original image');

imgD = im2double(img);

Gx = [1 1 1; -1 -2 1; -1 -1 1];
Gy = [1 -1 -1; 1 -2 -1; 1 1 1];
Ix = conv2(imgD,Gx,'same');
Iy = conv2(imgD,Gy,'same');

figure(2);
image(Ix,'CDataMapping','scaled');
colormap('gray');
title('Ix');

figure(3);
image(Iy,'CDataMapping','scaled');
colormap('gray');
title('Iy');

edgeFIS = mamfis('Name','edgeDetection');
edgeFIS = addInput(edgeFIS,[-4 4],'Name','Ix');
edgeFIS = addInput(edgeFIS,[-4 4],'Name','Iy');

sx = 0.3;
sy = 0.3;
edgeFIS = addMF(edgeFIS,'Ix','gaussmf',[sx 0],'Name','zero');
edgeFIS = addMF(edgeFIS,'Iy','gaussmf',[sy 0],'Name','zero');

edgeFIS = addOutput(edgeFIS,[0 1],'Name','Iout');

wa = 0.1;
wb = 1;
wc = 1;
ba = 0;
bb = 0;
bc = 0.7;
edgeFIS = addMF(edgeFIS,'Iout','trimf',[wa wb wc],'Name','white');
edgeFIS = addMF(edgeFIS,'Iout','trimf',[ba bb bc],'Name','black');

r1 = "If Ix is zero and Iy is zero then Iout is white";
r2 = "If Ix is not zero or Iy is not zero then Iout is black";
edgeFIS = addRule(edgeFIS,[r1 r2]);
edgeFIS.Rules

Ieval = zeros(size(imgD));
for ii = 1:size(imgD,1)
    Ieval(ii,:) = evalfis(edgeFIS,[(Ix(ii,:));(Iy(ii,:))]');
end

figure(4)
image(Ieval,'CDataMapping','scaled')
colormap('gray')
title('Edges')


imgthresh = Ieval;
[h, w] = size(Ieval);
max(Ieval, [], 'all')
Ieval = (Ieval./max(Ieval, [], 'all')) .* 255;
for i = 1:h
    for j = 1:w
        if Ieval(i, j) > 230
            imgthresh(i, j) = 255;
        else
            imgthresh(i, j) = 0;
        end
    end
end

figure(5);
image(imgthresh);
colormap('gray');
title('Threshold');


[height, width] = size(imgthresh);

rho = ceil(sqrt(width^2 + height^2));
acc = zeros(rho, 271);
for i = 1:height
    for j = 1:width
        if imgthresh(height -i + 1, j) == 0
            for a = -90:180
                r = (round(j*cos((a*pi)/180.0) + i*sin((a*pi)/180.0)));
                if (r > 0) && (r <= rho)
                    acc(rho - (r + 0), a + 91) = acc(rho - (r + 0), a + 91) + 1;
                end
            end
        end
    end
end
acc = (acc./max(acc, [], 'all')) .* 255;
acc = uint8(acc);
figure(6);
image(acc);
colormap('gray');
title('Accumulator');
numOfLines = 0;
rhoList = [];
angleList = [];
a = 0;
while (numOfLines < 8) && (a < rho) % 7 git
    tmp = true;
    a = a+1;
    m = 0;
    x = 0;
    y = 0;
    for i = round(rho/2):rho-20
        for j = 1:150
            if acc(i, j) > m
                m = acc(i, j);
                x = i;
                y = j;
            end
        end
    end
    acc(x:x, y:y) = 0;
    if a > 1
        for z = 1:size(rhoList, 2)
            if (abs(rhoList(z) - x) < 10) && (abs(angleList(z) - y) < 10)    
                tmp = false;
            end
        end
        if tmp == false
            continue;
        else
            rhoList(size(rhoList, 2)+1) = x;
            angleList(size(angleList, 2)+1) = y;
        end
    else
        rhoList(1) = x;
        angleList(1) = y;
    end
    numOfLines = numOfLines + 1;
    for i = 1:height
        for j = 1:width    
            if abs(round(x - rho+1)) == round(j*cos((y-91)*pi/180.0) + i*sin((y-91)*pi/180.0))
                img(height - i+1, j) = 255;
            end
        end
    end
end

figure(7);
image(img);
colormap(gray);
title('Detected lines');