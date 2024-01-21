% 1. Read the image
originalImage = imread('peppers.png');
originalImage = double(originalImage) / 255.0; % Convert to double for processing

% 2. Create a PSF (Point Spread Function)
psf_size = 15;
psf = fspecial('motion', psf_size, 45); % Adjust angle as needed

% 3. Create a simulated blur in the image
blurredImage = conv2(originalImage, psf, 'same', 'circular');

% 4. Deblur the image using Wiener Filter

% Compute the size of the image
[m, n, ~] = size(originalImage);

% Create the PSF matrix
psf_matrix = zeros(m, n);
psf_matrix(1:size(psf, 1), 1:size(psf, 2)) = psf;

% Compute the Fourier Transform of the PSF
psf_fft = fft2(psf_matrix);

% Compute the Fourier Transform of the blurred image
blurredImage_fft = fft2(blurredImage);

% Define the estimated noise power spectrum (flat for simplicity)
noise_power_spectrum = abs(fft2(randn(m, n))).^2 / (m * n);

% Compute the Wiener filter
wiener_filter = conj(psf_fft) ./ (abs(psf_fft).^2 + noise_power_spectrum / max(noise_power_spectrum(:)));

% Apply the Wiener filter in the frequency domain
deblurredImage_fft = blurredImage_fft .* wiener_filter;

% Compute the inverse Fourier Transform to obtain the deblurred image
deblurredImage = real(ifft2(deblurredImage_fft));

% Ensure values are in the valid range [0, 1]
deblurredImage = min(max(deblurredImage, 0), 1);

% Display the results
figure;
subplot(1, 3, 1); imshow(originalImage); title('Original Image');
subplot(1, 3, 2); imshow(blurredImage); title(' Blur');
subplot(1, 3, 3); imshow(deblurredImage); title(' Deblurred');
