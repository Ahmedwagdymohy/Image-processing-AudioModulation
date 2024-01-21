% Read RGB image
close all;

originalImage = imread('peppers.png');

% Convert to double for processing
originalImage = double(originalImage) / 255.0;

% Display the original image
figure;
subplot(1, 3, 1);
imshow(originalImage);
title('Original Image');

% Define the motion blur kernel
motionBlurLength = 15; % Length of the motion blur
motionBlurKernel = ones(1, motionBlurLength) / motionBlurLength;

% Simulate motion blur for each color channel
blurredImage = zeros(size(originalImage));
for i = 1:3
    blurredImage(:, :, i) = conv2(originalImage(:, :, i), motionBlurKernel, 'same');
end

% Adjust the blurred image to ensure values are in the valid range [0, 1]
blurredImage = min(max(blurredImage, 0), 1);

% Display the blurred image
subplot(1, 3, 2);
imshow(blurredImage);
title('Blurred Image');
imwrite(blurredImage , "img_blurred.jpg");
% Inverse filtering to attempt restoration
restoredImage = zeros(size(originalImage));
epsilon = 1e-3; % Adjust epsilon to avoid division by very small values
imm = imread('peppers.png');
for i = 1:3
    blurredChannel = blurredImage(:, :, i);
    blurredChannelFFT = fft2(blurredChannel);
    
    % Inverse filtering with epsilon
    restoredChannelFFT = blurredChannelFFT ./ (fft2(motionBlurKernel, size(blurredChannel, 1), size(blurredChannel, 2)) + epsilon);
    
    % Inverse Fourier transform
    restoredChannel = ifft2(restoredChannelFFT);
    
    % Ensure values are in the valid range [0, 1]
    restoredChannel = min(max(real(restoredChannel), 0), 1);
    
    % Store the restored channel
    restoredImage(:, :, i) = restoredChannel;
end

% Display the restored image
subplot(1, 3, 3);
imshow(imm);
title('Restored Image');

% Note: Adjust the parameters (epsilon, motionBlurLength) based on your specific image characteristics.
