close all;

% Read image
originalImage = imread('peppers.png');

% Display original image
figure;
imshow(originalImage);
title('Original');

% Red channel
redChannel = originalImage;
redChannel(:,:,2:3) = 0;
figure;
imshow(redChannel);
title('Red Channel');

% Blue channel
blueChannel = originalImage;
blueChannel(:,:,1:2) = 0;
figure;
imshow(blueChannel);
title('Blue Channel');

% Green channel
greenChannel = originalImage;
greenChannel(:,:,1) = 0;
greenChannel(:,:,3) = 0;
figure;
imshow(greenChannel);
title('Green Channel');



% B.1. Edge Detection
sobelKernel = [-1 0 1; -2 0 2; -1 0 1];
edgeImage = zeros(size(originalImage));
for i = 1:3
    edgeImage(:, :, i) = conv2(double(originalImage(:, :, i)), sobelKernel, 'same');
end
figure;
subplot(1, 2, 1); imshow(originalImage); title('Original Image');
subplot(1, 2, 2); imshow(uint8(edgeImage), []); title('Edge Detection');

% B.2. Image Sharpening
laplacianKernel = [0 -1 0; -1 5 -1; 0 -1 0];
sharpenedImage = zeros(size(originalImage));
for i = 1:3
    sharpenedImage(:, :, i) = conv2(double(originalImage(:, :, i)), laplacianKernel, 'same');
end
figure;
subplot(1, 2, 1); imshow(originalImage); title('Original Image');
subplot(1, 2, 2); imshow(uint8(sharpenedImage), []); title('Image Sharpening');

% Display original image
figure;
imshow(originalImage);
title('Original');

% B.3. Blurring (Averaging) 
blurSize = 5; % Adjust the blur size as needed
blurKernel = ones(blurSize) / blurSize^2;

blurredImage = zeros(size(originalImage));
for i = 1:3
    blurredImage(:, :, i) = conv2(double(originalImage(:, :, i)), blurKernel, 'same');
end

% Display blurred image
figure;
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 2, 2);
imshow(uint8(blurredImage), []);
title('Blurring (Averaging) ');

% B.4. Motion Blurring (Horizontal) 
motionBlurLength = 15; % Adjust the motion blur length as needed
motionBlurKernel = zeros(1, motionBlurLength);
motionBlurKernel(1:motionBlurLength) = 1 / motionBlurLength;

motionBlurredImage = zeros(size(originalImage));
for i = 1:3
    motionBlurredImage(:, :, i) = conv2(double(originalImage(:, :, i)), motionBlurKernel, 'same');
end

% Display motion blurred image
figure;
subplot(1, 2, 1);
imshow(originalImage);
title('Original Image');

subplot(1, 2, 2);
imshow(uint8(motionBlurredImage), []);
title('Motion Blurring (Horizontal) ');



original_image = imread('peppers.png');
motion_kernel = ones(1, 30) / 30;

motional_image(:,:,1) = conv2(original_image(:,:,1), motion_kernel);
motional_image(:,:,2) = conv2(original_image(:,:,2), motion_kernel);
motional_image(:,:,3) = conv2(original_image(:,:,3), motion_kernel);

motion_kernel_ft = fft2(motion_kernel, size(motional_image, 1), size(motional_image, 2));

motional_image_ft = fft2(motional_image);

epsilon = 0.00001;
image_restored_ft = motional_image_ft ./ (motion_kernel_ft + epsilon);

restored_image = abs(ifft2(image_restored_ft));

restored_image = restored_image(1:size(original_image, 1), 1:size(original_image, 2), 1:size(original_image, 3));



imwrite(uint8(edgeImage), 'image1.png');
imwrite(uint8(sharpenedImage), 'image2.png');
imwrite(uint8(blurredImage), 'image3.png');
imwrite(uint8(motionBlurredImage), 'image4.png');
imwrite(uint8(restored_image), 'image5.png');


% Display results
figure;

% Subplot 1: Display motional_image
subplot(2, 2, 1);
imshow(uint8(motional_image));
title('Motional Image');

% Subplot 2: Display restored_image
subplot(2, 2, 2);
imshow(uint8(restored_image));
title('Restored Image');

% Subplot 3: Display original_image
subplot(2, 2, 3);
imshow(uint8(original_image));
title('Original Image');
