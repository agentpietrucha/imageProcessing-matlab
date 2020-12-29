clear all; close all; clc;

img = imread('lines.bmp');
img = img(:,:,1);
figure(1);
image(img);
colormap(gray);
title('Input image');
[height, width] = size(img);

rho = ceil(sqrt(width^2 + height^2));
acc = zeros(rho, 271);
for i = 1:height
    for j = 1:width
        if img(height -i+1, j) == 0
            for a = -90:180
                r = (round(j*cos((a*pi)/180.0) + i*sin((a*pi)/180.0)));
                if (r > 0) && (r <= rho)
                    acc(rho - (r + 1), a + 91) = acc(rho - (r + 1), a + 91) + 1;
                end
            end
        end
    end
end

acc = (acc./max(acc, [], 'all')) .* 255;
figure(2);
image(acc);
colormap(gray);
title('Accumulator')

for a = 1:3
    m = 0;
    x = 0;
    y = 0;
    for i = 1:rho
        for j = 1:271
            if (acc(i, j) > m) 
                m = acc(i, j);
                x = i;
                y = j;
            end
        end
    end
    acc(x-3:x+3, y-3:y+3) = 0;
    for i = 1:height
        for j = 1:width    
            if abs(round(x - rho+1)) == round(j*cos((y-91)*pi/180.0) + i*sin((y-91)*pi/180.0))
                img(height - i+1, j) = 0;
            end
        end
    end
    
end
figure(3);
image(acc);
colormap(gray);
title('Accumulator with cutted maximums');


figure(4);
image(img);
colormap(gray);
title('Detected lines');