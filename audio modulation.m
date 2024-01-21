% %Audio recording parameters 
% fs=44100; %sampling frequency ,it is commonly used with audio
% bit_depth=16; %most common with audio
% record_length =10; %record length in seconds
% channel =2; %choosing number of channels (stereo mode)
% recorder=audiorecorder(fs,bit_depth,channel);
% disp('Start speaking..')
% %Record audio
% recordblocking(recorder,record_length);
% disp('End of Recording.');
% audio_data=getaudiodata(recorder,'uint8');%recorded audio data
% audiowrite('input1.wav',audio_data,fs);%audio file


%**********************Reading the original audio********************
[amp, Fs] = audioread("input1.wav"); %get the file 
om=audioplayer(amp,fs);   %make orignal audio object
N=length(amp);   %get the amplitude length
Original_Audio_Freq=fft(amp,N);   %frequency shift the filter
%*********************Plotting the original audio***********************
%Single sided with k
figure();       %opens a figure
k=0:N-1;        %calculating k
subplot(1,3,1); %divide it into half and choose the first half
plot(k,abs(Original_Audio_Freq));%draw the orignal audio
pause(3);       %wait 3 seconds
%Single sided with frequencyf
F_1=(0:N-1)*fs/N;     %calculate the frequency to plot it
subplot(1,3,2);       %divide it into half and choose the first half
plot(F_1,abs(Original_Audio_Freq)/N);  %draw the orignal audio
%Double sided with frequency 
F_2=(-N/2:N/2-1)*fs/N;         %center the frequency to plot it
subplot(1,3,3);                %divide it into half and choose
plot(F_2,abs(fftshift(amp))/N);%draw the orignal audio


%**********************Limit the maximum frequency********************
Limited_Freq_Audio=filter(filter1,amp);        %Limit the frequency the audio

%**********************Getting the filtered audio********************
filtered_audio=filter(filter1,Limited_Freq_Audio);        %filter the audio
fm=audioplayer(filtered_audio,fs);   %make filter audio object
Filered_Audio_Freq=fft(filtered_audio,N);


% %*********************Plotting the Filtered audio***********************
% %Single sided with k
figure();
subplot(1,3,1); %second half
plot(k,abs(Filered_Audio_Freq));%draw the filter audio
%Single sided with frequency
subplot(1,3,2);     %second half
plot(F_1,abs(Filered_Audio_Freq)/N);  %draw the filter audio
pause(3);           %wait 3 seconds
%Double sided with frequency
subplot(1,3,3);             %second half
plot(F_2,abs(fftshift(filtered_audio))/N);%draw the filter audio
 
audiowrite("outputali.wav",filtered_audio,fs); %save the filtered file



% play(om);   %play orignal audio                  
% pause(10);  %it plays it for 10 seconds
% stop(om);   %stop orignal audio
% play(fm);   %play orignal audio
% pause(10);  %it plays it for 10 seconds
% stop(fm);   %stop orignal audio