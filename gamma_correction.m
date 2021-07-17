clear all;
clc;
close all;

%% Read image
I = imread("white_balanced.jpg");
figure(1);imshow(I);title('Original image');


%% Gamma correction on white balanced image
Gamma = rgb2lin(I);
figure(1),title('White balanced and Gamma corrected image'),imshow(Gamma)

I=double(Gamma)
%% Laplacian Contrast weight

laplacian=-1*ones(3);
laplacian(2,2)=8;
wl=convn(double(I), laplacian, 'same');
wl=wl-min(min(wl));
wl=(wl./max(max(wl)).*255);
figure(3),imshow(uint8(wl)),title('Laplacian contrast weight');

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
figure(4),imshow(uint8(wsat)),title('Saturated Weighted Image');

%% Saliency weight balanced

ws=imread("saliency_gamma_corrected.jpeg");
ws=double(ws);


%% Wk
wk=wl+wsat+ws;
figure(5),imshow(uint8(wk)),title('Aggregated weighted map');




