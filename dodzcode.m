% Read the 'peppers.png' image
peppersImage = imread('peppers.png');

% Convert the image to double for calculations
peppersImageDouble = double(peppersImage);

% Convert the image to grayscale
grayImage = rgb2gray(peppersImage);

% Sobel kernels for edge detection
sobelKernelX = [-1 0 1; -2 0 2; -1 0 1];
sobelKernelY = [-1 -2 -1; 0 0 0; 1 2 1];

% Apply convolution with Sobel kernels for edge detection
gradientX = conv2(double(grayImage), sobelKernelX, 'same');
gradientY = conv2(double(grayImage), sobelKernelY, 'same');
edgeImage = sqrt(gradientX.^2 + gradientY.^2);
edgeImage = edgeImage / max(edgeImage(:));

% Display the original and edge-detected images
figure;
subplot(2,3,1), imshow(peppersImage), title('Original RGB Image');
subplot(2,3,2), imshow(edgeImage), title('image1 (Sobel Operator)');
imwrite(uint8(edgeImage * 255), 'C:\Users\lenovo\Desktop\EECE26\2nd Year\1st Term\Signals\matlab\image1.png');

% Operation 2: Image Sharpening (Laplacian Kernel)
laplacianKernel = [0 -1 0; -1 5 -1; 0 -1 0]/256;
sharpened_R = conv2(peppersImageDouble(:,:,1), laplacianKernel, 'same');
sharpened_G = conv2(peppersImageDouble(:,:,2), laplacianKernel, 'same');
sharpened_B = conv2(peppersImageDouble(:,:,3), laplacianKernel, 'same');
sharpenedImage = peppersImageDouble + cat(3, sharpened_R, sharpened_G, sharpened_B);
sharpenedImage = max(0, min(sharpenedImage, 255));
imwrite(uint8(sharpenedImage), 'C:\Users\lenovo\Desktop\EECE26\2nd Year\1st Term\Signals\matlab\image2.png');

% Operation 3: Blurring (Averaging)
boxBlurKernel = ones(5) / 25;  % 5x5 Box blur kernel
blurred_R = conv2(peppersImageDouble(:,:,1), boxBlurKernel, 'same');
blurred_G = conv2(peppersImageDouble(:,:,2), boxBlurKernel, 'same');
blurred_B = conv2(peppersImageDouble(:,:,3), boxBlurKernel, 'same');
blurredImage = cat(3, blurred_R, blurred_G, blurred_B);
imwrite(uint8(blurredImage), 'C:\Users\lenovo\Desktop\EECE26\2nd Year\1st Term\Signals\matlab\image3.png');

% Operation 4: Motion Blurring
kernelSize = 15;  % Motion blur kernel size
motionBlurKernel = ones(1, kernelSize) / kernelSize;
motionBlurred_R = conv2(peppersImageDouble(:,:,1), motionBlurKernel, 'same');
motionBlurred_G = conv2(peppersImageDouble(:,:,2), motionBlurKernel, 'same');
motionBlurred_B = conv2(peppersImageDouble(:,:,3), motionBlurKernel, 'same');
motionBlurredImage = cat(3, motionBlurred_R, motionBlurred_G, motionBlurred_B);
motionBlurredImage = max(0, min(motionBlurredImage, 255));
imwrite(uint8(motionBlurredImage), 'C:\Users\lenovo\Desktop\EECE26\2nd Year\1st Term\Signals\matlab\image4.png');

% Convert back to uint8 for display
sharpenedImage = uint8(sharpenedImage);
blurredImage = uint8(blurredImage);
motionBlurredImage = uint8(motionBlurredImage);

% Display the processed images
subplot(2,3,3), imshow(sharpenedImage), title('Image 2');
subplot(2,3,4), imshow(blurredImage), title('image 3');
subplot(2,3,5), imshow(motionBlurredImage), title('image 4');

% Convert the motion-blurred image to double for calculations
motionBlurredImageDouble = double(motionBlurredImage);

% Fourier transform of the motion-blurred image
fftMotionBlurred = fft2(motionBlurredImageDouble);

% Fourier transform of the motion blur kernel
fftMotionBlurKernel = fft2(motionBlurKernel, size(motionBlurredImage, 1), size(motionBlurredImage, 2));

% Inverse filtering in the frequency domain
fftRestoredImage = fftMotionBlurred ./ fftMotionBlurKernel;

% Inverse Fourier transform to get the restored image
restoredImage = ifft2(fftRestoredImage);

% Ensure the restored image is real and within valid intensity range
restoredImage = real(restoredImage);
restoredImage = max(0, min(restoredImage, 255));

% Convert the restored image to uint8 for saving
restoredImage = uint8(restoredImage);


% Display the motion-blurred and restored images
figure;
subplot(1, 2, 1), imshow(motionBlurredImage), title('Motion-Blurred Image');
subplot(1, 2, 2), imshow(restoredImage), title('Restored Image');

% Optional: Adjust figure properties for better visualization
set(gcf, 'Position', get(0,'Screensize'));
imwrite(uint8(restoredImage), 'C:\Users\lenovo\Desktop\EECE26\2nd Year\1st Term\Signals\matlab\image5.png');