clc; clear; close all;

% Load grayscale image
img = imread('../data/sample_gray.jfif');

% Verify grayscale
if ndims(img) == 3
    img = rgb2gray(img);
end

figure;
imshow(img);
title('Original Grayscale Image');
%step5
img_d = im2double(img);
% Verification (important – keep for learning)
disp(class(img))
disp(class(img_d))
fprintf('Original min/max: %d / %d\n', min(img(:)), max(img(:)));
fprintf('Double min/max: %.4f / %.4f\n', min(img_d(:)), max(img_d(:)));
%step6
figure;
imhist(img_d);
title('Intensity Histogram');

if ~exist('../results','dir')
    mkdir('../results');
end

saveas(gcf, '../results/histogram.png');

%step 7
noisy_img = imnoise(img_d, 'gaussian', 0, 0.01);

figure;
imshow(noisy_img);
title('Noisy Image');

imwrite(noisy_img, '../results/noisy.png');
noise_est = std(noisy_img(:) - img_d(:));

%step 8
filtered_img = imbilatfilt(noisy_img, noise_est*1.6, 1);


figure;
imshow(filtered_img);
title('Bilateral Filtered Image');

imwrite(filtered_img, '../results/bilateral.png');

%step 9

enhanced_img = adapthisteq(filtered_img, ...
    'ClipLimit', 0.01, ...
    'Distribution', 'rayleigh');

figure;
imshow(enhanced_img);
title('Adaptive Histogram Equalization');

imwrite(enhanced_img, '../results/clahe.png');
%new
sharpened_img = imsharpen(enhanced_img, ...
    'Radius', 0.8, ...
    'Amount', 0.4);

figure;
imshow(sharpened_img);
title('Sharpened Image');

imwrite(sharpened_img, '../results/sharpened.png');

%step 10
edges = edge(sharpened_img, 'Canny');

figure;
imshow(edges);
title('Edge Detection');
imwrite(edges, '../results/edges.png');
%step 11
% Evaluate denoising only (before enhancement)
mse_val  = immse(img_d, filtered_img);
psnr_val = psnr(filtered_img, img_d);
ssim_val = ssim(filtered_img, img_d);

fprintf('Denoising MSE  = %.6f\n', mse_val);
fprintf('Denoising PSNR = %.2f dB\n', psnr_val);
fprintf('Denoising SSIM = %.4f\n', ssim_val);
%new
figure;
subplot(2,3,1), imshow(img_d), title('Original');
subplot(2,3,2), imshow(noisy_img), title('Noisy');
subplot(2,3,3), imshow(filtered_img), title('Denoised');
subplot(2,3,4), imshow(enhanced_img), title('Contrast Enhanced');
subplot(2,3,5), imshow(sharpened_img), title('Final');
subplot(2,3,6), imshow(edges), title('Edges');



