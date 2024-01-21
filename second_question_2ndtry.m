% Read image
originalImage = imread('peppers.png');

% Display original image
figure;
imshow(originalImage);
title('Original');

% B.3. Blurring (Averaging) without fspecial
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
title('Blurring (Averaging) without fspecial');

% B.4. Motion Blurring (Horizontal) without fspecial
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
title('Motion Blurring (Horizontal) without fspecial');
