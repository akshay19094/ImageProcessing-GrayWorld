clear all;
clc;
close all;

%% Read image
I = imread("white_balanced.jpg");
%figure(1);imshow(I);title('Original image');


% %% Gamma correction on white balanced image
% Gamma = rgb2lin(I);
% figure(1),title('White balanced and Gamma corrected image'),imshow(Gamma)
% 
% I=double(Gamma)

%% Normalised unsharp masking
I=double(I);
G = imgaussfilt(I);
%figure(3),imshow(uint8(G)),title('Gaussian blur');

x=imsubtract(I,G);
x=x-min(min(x));
x=(x./max(max(x)).*255);
sharpened=(I + histeq(x))/2;
%figure(2),imshow(uint8(sharpened)),title('Normalized unsharp masking');
imwrite(uint8(sharpened),"107_unsharp_masking.jpg");


I=sharpened
%% Laplacian Contrast weight

laplacian=-1*ones(3);
laplacian(2,2)=8;
wl=convn(double(I), laplacian, 'same');
wl=wl-min(min(wl));
wl=(wl./max(max(wl)).*255);
%figure(3),imshow(uint8(wl)),title('Laplacian contrast weight');
imwrite(uint8(wl),"107_wl.jpg");
%% Saturation weight
[M,N]=size(I);

for i=1:M
    for j=1:N/3
        rk=I(i,j,1);
        gk=I(i,j,2);
        bk=I(i,j,3);
        lk=(rk+gk+bk)/3;
        wsat(i,j)=sqrt(([(rk-lk).^2+(bk-lk).^2+(gk-lk).^2]/3));
    end
end
wsat=wsat-min(min(wsat));
wsat=(wsat./max(max(wsat)).*255);
%figure(4),imshow(uint8(wsat)),title('Saturated Weighted Image');
imwrite(uint8(wsat),"107_wsat.jpg");
%% Saliency weight balanced

ws=imread("salency_unsharp_masking.jpeg");
ws=double(ws);


%% Wk
wk=wl+wsat+ws;
%figure(5),imshow(uint8(wk)),title('Aggregated weighted map');

%% Read image
I2 = imread("white_balanced.jpg");
%figure(1);imshow(I2);title('Original image');


%% Gamma correction on white balanced image
Gamma = rgb2lin(I2);
%figure(1),title('White balanced and Gamma corrected image'),imshow(Gamma)

I2=double(Gamma);
imwrite(uint8(Gamma),"107_gamma_corrected.jpg");
%% Laplacian Contrast weight

laplacian=-1*ones(3);
laplacian(2,2)=8;
wl2=convn(double(I2), laplacian, 'same');
wl2=wl2-min(min(wl2));
wl2=(wl2./max(max(wl2)).*255);
%figure(3),imshow(uint8(wl2)),title('Laplacian contrast weight');
imwrite(uint8(wl2),"107_wl2.jpg");
%% Saturation weight
[M,N]=size(I);

for i=1:M
    for j=1:N/3
        rk=I(i,j,1);
        gk=I(i,j,2);
        bk=I(i,j,3);
        lk=(rk+gk+bk)/3;
        wsat2(i,j)=sqrt(([(rk-lk).^2+(bk-lk).^2+(gk-lk).^2]/3));
    end
end
wsat2=wsat2-min(min(wsat2));
wsat2=(wsat2./max(max(wsat2)).*255);
%figure(4),imshow(uint8(wsat2)),title('Saturated Weighted Image');
imwrite(uint8(wsat2),"107_wsat2.jpg");
%% Saliency weight balanced

ws2=imread("salency_gamma_corrected.jpeg");
ws2=double(ws2);


%% Wk
wk2=wl2+wsat2+ws2;
%figure(5),imshow(uint8(wk2)),title('Aggregated weighted map');

%%
delta=0.1;

wk_1=(wk+delta)./(wk+wk2+2*delta);
wk_2=(wk2+delta)./(wk+wk2+2*delta);

%% Naive Fusion

Rx=wk_1.*I+wk_2.*I2;

wk_2=wk_2-min(min(wk_2));
wk_2=(wk_2./max(max(wk_2)).*255);

wk_1=wk_1-min(min(wk_1));
wk_1=(wk_1./max(max(wk_1)).*255);

figure(1),imshow(uint8(wk_1)),title('WK_1');
figure(2),imshow(uint8(wk_2)),title('WK_2');

imwrite(uint8(wk_1),"107_wk_1.jpg")
imwrite(uint8(wk_2),"107_wk_2.jpg")

figure(3),imshow(uint8(Rx)),title('Naive Fusion output');


