%% read input image
clear all
close all
clc
I=imread('107_img_.png');
%I=imread('909_img_.png');
figure(1),title('Original image'),imshow(I)

%% Apply white balancing
%method=["bradford", "vonkries", "simple"]
method=["bradford"]
for i=1:numel(method)
    A_lin = rgb2lin(I); %Gamma correction 
    illuminant = illumgray(A_lin);

    B_lin = chromadapt(A_lin,illuminant,'ColorSpace','linear-rgb','method',method(i));
    figure(2),title('White balanced image'),imshow(B_lin)

%% Gamma correction on white balanced image
    B = lin2rgb(B_lin);
    figure(3),title('White balanced and Gamma corrected image'),imshow(B)

%% Sharpening on white balanced image
    B_lin=imgaussfilt(B_lin);
    sharpened=imsharpen(B_lin);
    figure(4),title('Sharpened after white balancing'),imshow(sharpened)

%% Fusion of sharpened and gamma corrected image

%using mean
    XFUSmean = wfusimg(B,sharpened,'db2',5,'mean','mean');
    %figure(i+1),imshow(uint8(XFUSmean))
    figure(5),imshow(uint8(XFUSmean))
end

