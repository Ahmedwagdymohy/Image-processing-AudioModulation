    % Task a: Record voice segments
    close all


    % Set the sampling frequency and bit depth
    fs = 44100; % Set the sampling frequency
    bitDepth = 16; % Set the bit depth
    
    % % Record the first voice segment
    % recObj = audiorecorder(fs, bitDepth, 1); % 1 channel for mono recording
    % disp('Start speaking for the first segment.');`
    % recordblocking(recObj, 10); % Record for 10 seconds
    % input1 = getaudiodata(recObj);
    % audiowrite('input1.wav', input1, fs); % Save the audio as 'input1.wav'
    
    % % Record the second voice segment
    % disp('Start speaking for the second segment.');
    % recordblocking(recObj, 10); % Record for 10 seconds
    % input2 = getaudiodata(recObj);
    % audiowrite('input2.wav', input2, fs); % Save the audio as 'input2.wav'
    
   %-----------------------------------------------------------------------
   %----------------------------Reading records--------------------------
    input1 = audioread("input1.wav");
    input2 = audioread("input2.wav");
    N = length(input1);
    freq = fs * (-N/2:N/2-1) / N;
    figure;
    plot(freq, abs(fftshift(fft(input1))));
    title('The magnitude spectrum of the Demudulated Signal 1');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    % Task b: Design and apply LPF filter
    
    % Use filterDesigner to design the LPF filter
     filterDesigner;
  
    lpFilter = filter2;
    
    % Apply the LPF to the signals
    filteredInput1 = filter(lpFilter, input1);
    filteredInput2 = filter(lpFilter, input2);
    
    % Plot the frequency response of the filter
    freqz(lpFilter);
    
    %-----------------------------------------------------------------------
 
    % Task c: Plot magnitude spectrum before and after filtering
    
    % Compute the FFT of the original and filtered signals
    fftInput1 = fftshift(fft(input1));
    fftInput2 = fftshift(fft(input2));
    fftFiltered1 = fftshift(fft(filteredInput1));
    fftFiltered2 = fftshift(fft(filteredInput2));

% Create frequency vectors
freq = linspace(-fs/2, fs/2, length(fftInput1));

% Plot the magnitude spectrum of each signal separately
figure;

% Input 1
subplot(2, 2, 1);
plot(freq, abs(fftInput1), 'b');
title('Magnitude Spectrum of Input 1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Input 1');

% Input 2
subplot(2, 2, 2);
plot(freq, abs(fftInput2), 'r');
title('Magnitude Spectrum of Input 2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Input 2');

% Filtered Input 1
subplot(2, 2, 3);
plot(freq, abs(fftFiltered1), 'b');
title('Magnitude Spectrum of Filtered Input 1');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Filtered Input 1');

% Filtered Input 2
subplot(2, 2, 4);
plot(freq, abs(fftFiltered2), 'r');
title('Magnitude Spectrum of Filtered Input 2');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Filtered Input 2');

%-----------------------------------------------------------------------
ts = 1/fs;

N1 = [1:(length(input1))];
L1 = length(input1);                        
f1 = [-L1/2:L1/2-1]*(fs/L1);           
                            
N2 = [1:(length(input2))];
L2 = length(input2);                        
f2 = [-L2/2:L2/2-1]*(fs/L2);           

Fc1 = 10000;

x1_modulated = filteredInput1 .* cos(2*pi*Fc1*ts*(1:length(filteredInput1)).');


Fc2 = 200000;

x2_modulated = filteredInput2 .* cos(2*pi*Fc2*ts*(1:length(filteredInput2)).');


% figure();
% subplot(3,1,1);
% plot(f1,abs(fftshift(fft(x1_modulated))));
% title('X1 Modulated')
% subplot(3,1,2);
% plot(f2,abs(fftshift(fft(x2_modulated))));
% title('X2 Modulated')

% Combined signal
signal = x1_modulated + x2_modulated;

% Frequency domain plot for the combined signal
L = length(signal);
f_combined = [-L/2:L/2-1]*(fs/L);

figure();
subplot(1, 1, 1);
plot(f_combined, abs(fftshift(fft(signal))));
title('Combined Signal (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

%-----------------------------------------------------------------------
%---------------------------------Demodulating--------------------------
%-----------------------------------------------------------------------

% Demodulate signals
 demodulated1 = signal .* cos(2 * pi * Fc1 * ts * (1:length(filteredInput1)).');
 demodulated2 = signal .* cos(2 * pi * Fc2 * ts * (1:length(filteredInput2)).');

% Plot magnitude spectrum of demodulated signals
L_demod1 = length(demodulated1);
L_demod2 = length(demodulated2);
f_demod1 = [-L_demod1/2:L_demod1/2-1] * (fs/L_demod1);
f_demod2 = [-L_demod2/2:L_demod2/2-1] * (fs/L_demod2);

figure();
subplot(2, 1, 1);
plot(f_demod1, abs(fftshift(fft(demodulated1))));
title('Demodulated Signal 1 (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(f_demod2, abs(fftshift(fft(demodulated2))));
title('Demodulated Signal 2 (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Apply the low-pass filter to demodulated signals
demodulated1 = filter(filter2, demodulated1);
demodulated2 = filter(filter2, demodulated2);

demodulated1 = 2 * demodulated1;
demodulated2 = 2 * demodulated2;

% Save demodulated signals as audio files
audiowrite('output11.wav', demodulated1, fs);
audiowrite('output22.wav', demodulated2, fs);

% Plot magnitude spectrum of demodulated signals

figure();
subplot(2, 1, 1);
plot(f_demod1, abs(fftshift(fft(demodulated1))));
title('Demodulated Signal 1 (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2, 1, 2);
plot(f_demod2, abs(fftshift(fft(demodulated2))));
title('Demodulated Signal 2 (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');




