% Load custom audio file
[noisySignal, Fs] = audioread('harvardn.wav');

% Low-pass filter parameters
Fc_low = 3000; % Cutoff frequency in Hz
order_low = 4; % Filter order

% Design a Butterworth low-pass filter
[b_low, a_low] = butter(order_low, Fc_low / (Fs / 2), 'low');

% Apply the low-pass filter to the noisy signal
filteredSignal_low = filtfilt(b_low, a_low, noisySignal);

% Compute the FFT of the original and filtered signals
N = length(noisySignal);
f = (0:N-1)*(Fs/N); % Frequency vector
Y_noisy = abs(fft(noisySignal));
Y_filtered_low = abs(fft(filteredSignal_low));

% Plot the results
figure;
subplot(3,1,1);
plot((1:length(noisySignal))/Fs, noisySignal);
title('Original Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot((1:length(filteredSignal_low))/Fs, filteredSignal_low);
title('Low-Pass Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the frequency spectrum
subplot(3,1,3);
plot(f(1:floor(N/2)), Y_noisy(1:floor(N/2)), 'b');
hold on;
plot(f(1:floor(N/2)), Y_filtered_low(1:floor(N/2)), 'r');
title('Frequency Spectrum');
legend('Original Noisy', 'Low-Pass Filtered');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Save and play the low-pass filtered signal
audiowrite('filtered_lowpass.wav', filteredSignal_low, Fs);
disp('Playing the low-pass filtered signal...');
sound(filteredSignal_low, Fs);
pause(length(filteredSignal_low)/Fs + 1);
