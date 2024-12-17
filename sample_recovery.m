clc;
close all;
clear all;

hazy=imread("F:\DB\Hazy_all_st\0418_1_0.04.png");
GT=imread("F:\DB\GT compressed\0418_1_0.04.png");
Transmission=imread("F:\Study-2\Journal 4\code\IETE latex\revision 2 resuls\High Haze\5x2\Trans Map\0418_1_0.04.png");

Hazy_d=im2double(hazy);
GT_d=im2double(GT);
Hazy_d=imresize(Hazy_d,[360 480]);
GT_d=imresize(GT_d,[360 480]);
Transmission=im2double(Transmission);
Transmission=im2gray(Transmission);

max_transmission = repmat(max(Transmission, 0.1), [1, 1, 3]);

imshow(max_transmission);title('max_transmission');
        drawnow;
        
        pause(2);

win_size = 15;
dark_channel=get_dark_channel(Hazy_d,win_size);
        
imshow(dark_channel);title('Dark Channel');
        drawnow;
        
        pause(2);
        
        Atmospheric_Light=get_atmosphere(Hazy_d,dark_channel);
        
        [m, n, ~] = size(Hazy_d);

        rep_atmosphere = repmat(reshape(Atmospheric_Light, [1, 1, 3]), m, n);
        
radiance = ((Hazy_d - rep_atmosphere) ./ max_transmission) + rep_atmosphere;

imshow([GT_d radiance]);title('GT vs radiance');
        drawnow;
imwrite(radiance,"0418_1_0.04.png");
        pause(2);
