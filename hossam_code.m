% Read the image and store it in the variable "image"
original_img = imread('C:\Users\study\Downloads\peppers.png');

%Separating RGB Components
RedComponent = original_img(:, :, 1);
GreenComponent = original_img(:, :, 2);
BlueComponent = original_img(:, :, 3);
Black_Matrix= zeros(size(BlueComponent));         % the three components has the same size
Red_img= cat(3, RedComponent, Black_Matrix, Black_Matrix);
Green_img= cat(3, Black_Matrix, GreenComponent, Black_Matrix);
Blue_img=cat(3, Black_Matrix, Black_Matrix,BlueComponent);
figure;
subplot(2,3,2);
imshow (original_img);
title('original image');
subplot(2,3,4);
imshow (Red_img);
title('Red image');
subplot(2,3,5);
imshow (Green_img);
title('Green image');
subplot(2,3,6);
imshow (Blue_img);
title('Blue image');

% saving results
imwrite(uint8(Red_img), 'C:\Users\study\Downloads\peppers.png');
imwrite(uint8(Green_img), 'C:\Users\study\Downloads\peppers.png');
imwrite(uint8(Blue_img), 'C:\Users\study\Downloads\peppers.png');


% Define kernels for convolution
edgeDetectingKernel = [1 1 1; 1 -8 1; 1 1 1]/256; % Laplacian kernel for edge detection
sharpeningKernel = [0 -1 0; -1 5 -1; 0 -1 0]/256; % Sharpening kernel
blurringKernel = fspecial('average', [20, 20])/256; % Averaging kernel for blurring

% working on Red component alone
Red_img_detected = conv2(RedComponent, edgeDetectingKernel, 'same');
Red_img_sharpened = conv2(RedComponent,sharpeningKernel, 'same');
Red_img_blurred = conv2(RedComponent, blurringKernel, 'same');

% working on blue component alone 
Blue_img_detected = conv2(BlueComponent, edgeDetectingKernel, 'same');
Blue_img_sharpened = conv2(BlueComponent, sharpeningKernel, 'same');
Blue_img_blurred = conv2(BlueComponent, blurringKernel, 'same');

% working on green component alone 
Green_img_detected = conv2(GreenComponent, edgeDetectingKernel, 'same');
Green_img_sharpened = conv2(GreenComponent, sharpeningKernel, 'same');
Green_img_blurred = conv2(GreenComponent, blurringKernel, 'same');

% Concatenating results to get the RGB image 
edgesDetected = cat(3,Red_img_detected,Green_img_detected,Blue_img_detected);
imageSharpened = cat(3,Red_img_sharpened,Green_img_sharpened,Blue_img_sharpened);
imageBlurred = cat(3,Red_img_blurred,Green_img_blurred,Blue_img_blurred);

% Display the results
figure;
subplot(2,3,2), imshow (original_img),title('original image')
subplot(2,3,4), imshow(edgesDetected), title('Edges Detected');
subplot(2,3,5), imshow(imageSharpened), title('Image Sharpened');
subplot(2,3,6), imshow(imageBlurred), title('Image Blurred');

% saving results
imwrite(uint8(imageSharpened *255), 'F:\EECE\second year\projects\signals project\sharpened.png');
imwrite(uint8(edgesDetected *255), 'F:\EECE\second year\projects\signals project\edgedetected.png');
imwrite(uint8(imageBlurred *255), 'F:\EECE\second year\projects\signals project\blurred.png');


% Convert the image to double for calculations
peppersImageDouble = double(original_img);

% Motion Blurring
motion_blur_kernelSize = 7;  % the less the better (must be odd) 
motion_Blur_Kernel = ones(1, motion_blur_kernelSize) / motion_blur_kernelSize;
motionBlurred_Red = conv2(peppersImageDouble(:,:,1), motion_Blur_Kernel, 'same');
motionBlurred_Green = conv2(peppersImageDouble(:,:,2), motion_Blur_Kernel, 'same');
motionBlurred_Blue = conv2(peppersImageDouble(:,:,3), motion_Blur_Kernel, 'same');
motion_Blurred_Image = cat(3, motionBlurred_Red, motionBlurred_Green, motionBlurred_Blue);
motion_Blurred_Image = max(0, min(motion_Blurred_Image, 255));

% return to unit8 to display
motion_Blurred_Image = uint8(motion_Blurred_Image);

% Display the processed images
figure; imshow(motion_Blurred_Image), title('test');

% Convert the motion-blurred image to double for calculations
motion_Blurred_Image_Double = double(motion_Blurred_Image);

% convert to freqeuncy domain
Motion_Blurred_Frequnecy_Domain = fft2(motion_Blurred_Image_Double);
Motion_Blur_Kernel_Frequency_Domain = fft2(motion_Blur_Kernel, size(motion_Blurred_Image, 1), size(motion_Blurred_Image, 2));

% Inverse filtering in the frequency domain
Restored_Image_Freq_Domain = Motion_Blurred_Frequnecy_Domain ./ Motion_Blur_Kernel_Frequency_Domain;

% Inverse Fourier transform to get the restored image
restored_Image = ifft2(Restored_Image_Freq_Domain);

% Ensure the restored image is real and within valid intensity range
restored_Image = real(restored_Image);
restored_Image = max(0, min(restored_Image, 255));

% Convert the restored image to uint8 for saving
restored_Image = uint8(restored_Image);


% Display the motion-blurred and restored images
figure;
subplot(1, 2, 1), imshow(motion_Blurred_Image), title('Motion-Blurred Image');
subplot(1, 2, 2), imshow(restored_Image), title('Restored Image');

imwrite(uint8(motion_Blurred_Image), 'F:\EECE\second year\projects\signals project\motion blurred.png');
imwrite(uint8(restored_Image), 'F:\EECE\second year\projects\signals project\restored.png');