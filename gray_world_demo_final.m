close all
clear all
clc

%% Read input image

%I=imread('909_img_.png'); %blue dominant
I=imread('107_img_.png');  %red dominant
figure(1);imshow(I);title('Original image');
I=double(I)/255;

%% Split Image into RGB channels
Ir=I(:,:,1);
Ig=I(:,:,2);
Ib=I(:,:,3);
%% Compute averages

avg_r=mean(mean(Ir));
avg_g=mean(mean(Ig));
avg_b=mean(mean(Ib));

%% Normalize using max average
max_avg=max(max(avg_r,avg_g),avg_b);
scale_r=max_avg/avg_r;
scale_g=max_avg/avg_g;
scale_b=max_avg/avg_b;

gray_world_output(:,:,1)=Ir*scale_r;
gray_world_output(:,:,2)=Ig*scale_g;
gray_world_output(:,:,3)=Ib*scale_b;

%output=histeq(output);

figure(2);imshow(gray_world_output);title('Gray world output');
%% simple chromadpt
% 
% illuminant = [avg_r,avg_g,avg_b];
% simple_output = chromadapt(I,illuminant,'ColorSpace','linear-rgb');
% figure(2);imshow(simple_output);title('Gray world output-Simple');

%% 

alpha=1;
[M,N]=size(I);

for i=1:M
    for j=1:N/3
        r=I(i,j,1);
        g=I(i,j,2);
        b=I(i,j,3);
        comp_b=b;
        comp_r=r;
        comp_r=r+(avg_g - avg_r)*(1-r)*g;
        comp_b=b+(avg_g - avg_b)*(1-b)*g;
        new_I(i,j,1)=comp_r;
        new_I(i,j,2)=g;
        new_I(i,j,3)=comp_b;
    end
end

figure(3);imshow(new_I);title('Pixel wise compensated output');

%new_I=rgb2lin(new_I);

new_Ir=double(new_I(:,:,1))/255;
new_Ig=double(new_I(:,:,2))/255;
new_Ib=double(new_I(:,:,3))/255;

new_avg_r=mean(mean(new_Ir));
new_avg_g=mean(mean(new_Ig));
new_avg_b=mean(mean(new_Ib));

%% Normalize using max average
max_new_avg=max(max(new_avg_r,new_avg_g),new_avg_b);
scale_r=max_new_avg/new_avg_r;
scale_g=max_new_avg/new_avg_g;
scale_b=max_new_avg/new_avg_b;

%% Appling normalization on each channel in output image
output(:,:,1)=new_Ir*scale_r*255;
output(:,:,2)=new_Ig*scale_g*255;
output(:,:,3)=new_Ib*scale_b*255;
%output=histeq(output);

figure(4);imshow(output);title('Gray world output after color compensation');
imwrite(output,"909_white_balanced.jpg")
%% Gamma correction
% 
% gamma=1.5
% c=255/(max(max(output/255)).^2);
% gamma_corrected=c*(output/255.^(gamma));
gamma_corrected=lin2rgb(output);
figure(5);imshow(gamma_corrected);title('White balanced and Gamma corrected image');

%% Normalised unsharp masking
sharpened=imsharpen(output);
figure(6),imshow(sharpened),title('Sharpened after white balancing');

Ix=double(output).*255;
G = imgaussfilt(Ix);
x=imsubtract(Ix,G);
x=x-min(min(x));
x=(x./max(max(x)).*255);
sharpened=(Ix + histeq(x))/2;
figure(7),imshow(uint8(sharpened)),title('Normalized unsharp masking');

%% Colour fusion
XFUSmean = wfusimg(gamma_corrected,sharpened,'db2',5,'mean','mean');
figure(8),imshow(uint8(XFUSmean));title('After colour fusion');