% Recording parameters
 fs = 44100; % Sampling frequency (Hz)
bitDepth = 16; % Bit depth
% 
% % Record first segment
% recObj1 = audiorecorder(fs, bitDepth, 1);
% disp('Start speaking for the first segment.');
% recordblocking(recObj1, 10); % Record for 10 seconds
% disp('End of recording.');
% input1 = getaudiodata(recObj1);
% audiowrite('input1.wav', input1, fs); % Save as 'input1.wav'
% 
% % Record second segment
% recObj2 = audiorecorder(fs, bitDepth, 1);
% disp('Start speaking for the second segment.');
% recordblocking(recObj2, 10); % Record for 10 seconds
% disp('End of recording.');
% input2 = getaudiodata(recObj2);
% audiowrite('input2.wav', input2, fs); % Save as 'input2.wav'

%===============================================================

input1 = audioread("C:\Users\study\Downloads\input1.wav")
input2 = audioread("input2.wav")
% Filter parameters
cutoffFrequency = 4000; % Adjust as needed
filterOrder = 100; % Adjust as needed

% Design LPF
lpf = designfilt('lowpassfir', 'FilterOrder', filterOrder, 'CutoffFrequency', cutoffFrequency, 'SampleRate', fs);

% Apply LPF to both signals
filteredSignal1 = filter(lpf, input1);
filteredSignal2 = filter(lpf, input2);

% Listen to filtered signals
sound(filteredSignal1, fs);
%sound(filteredSignal2, fs);



% Compute FFT
fftSize = 2^nextpow2(length(input1)); % Use power of 2 for efficiency
freq = linspace(-fs/2, fs/2, fftSize);
fftInput1 = fftshift(fft(input1, fftSize));
fftInput2 = fftshift(fft(input2, fftSize));
fftFiltered1 = fftshift(fft(filteredSignal1, fftSize));
fftFiltered2 = fftshift(fft(filteredSignal2, fftSize));

% Plot magnitude spectrum
figure;
subplot(2,2,1), plot(freq, abs(fftInput1)), title('Original Signal 1 Spectrum');
subplot(2,2,2), plot(freq, abs(fftInput2)), title('Original Signal 2 Spectrum');
subplot(2,2,3), plot(freq, abs(fftFiltered1)), title('Filtered Signal 1 Spectrum');
subplot(2,2,4), plot(freq, abs(fftFiltered2)), title('Filtered Signal 2 Spectrum');

%===============================
% Define downsampling factor
downsampleFactor = 10;

% Downsample the filtered signals
downsampledFilteredSignal1 = filteredSignal1(1:downsampleFactor:end);
downsampledFilteredSignal2 = filteredSignal2(1:downsampleFactor:end);

% Modulation parameters
fc1 = 8000; % Carrier frequency for signal 1
fc2 = 12000; % Carrier frequency for signal 2

% Modulate downsampled signals
modulatedSignal1 = downsampledFilteredSignal1 .* cos(2*pi*fc1*(1:length(downsampledFilteredSignal1))/fs);
modulatedSignal2 = downsampledFilteredSignal2 .* cos(2*pi*fc2*(1:length(downsampledFilteredSignal2))/fs);

% Combine signals
transmittedSignal = modulatedSignal1 + modulatedSignal2;

% Plot transmitted signal spectrum
fftTransmitted = fftshift(fft(transmittedSignal, fftSize));
figure;
plot(freq, abs(fftTransmitted));
title('Transmitted Signal Spectrum');


%=======================================================]==
% Demodulate signals
demodulatedSignal1 = transmittedSignal .* cos(2*pi*fc1*(1:length(transmittedSignal))/fs);
demodulatedSignal2 = transmittedSignal .* cos(2*pi*fc2*(1:length(transmittedSignal))/fs);

% Filter demodulated signals
filteredDemodulated1 = filter(lpf, demodulatedSignal1);
filteredDemodulated2 = filter(lpf, demodulatedSignal2);

% Save output audio files
audiowrite('output15.wav', filteredDemodulated1, fs);
audiowrite('output25.wav', filteredDemodulated2, fs);

% Plot magnitude spectrum of demodulated signals
fftDemodulated1 = fftshift(fft(filteredDemodulated1, fftSize));
fftDemodulated2 = fftshift(fft(filteredDemodulated2, fftSize));
figure;
subplot(2,1,1), plot(freq, abs(fftDemodulated1)), title('Demodulated Signal 1 Spectrum');
subplot(2,1,2), plot(freq, abs(fftDemodulated2)), title('Demodulated Signal 2 Spectrum');

