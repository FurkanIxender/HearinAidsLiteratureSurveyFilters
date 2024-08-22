% Parameters
Fs = 44100; % Sampling frequency in Hz
Fc = 300;  % Cutoff frequency in Hz
order = 4; % Filter order

% Load your own audio file
[noisySignal, Fs] = audioread('harvardn.wav');

% Design a Butterworth high-pass filter
[b, a] = butter(order, Fc / (Fs / 2), 'high');

% Apply filter to noisy signal
filteredSignal = filtfilt(b, a, noisySignal);

% Compute the FFT of the original and filtered signals
N = length(noisySignal);
f = (0:N-1)*(Fs/N); % Frequency range

Y_noisy = abs(fft(noisySignal));
Y_filtered = abs(fft(filteredSignal));

% Plot the results
figure;
subplot(3,1,1);
plot((1:length(noisySignal))/Fs, noisySignal);
title('Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot((1:length(filteredSignal))/Fs, filteredSignal);
title('Filtered Signal with High-Pass Filter');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the frequency spectrum
subplot(3,1,3);
plot(f(1:floor(N/2)), Y_noisy(1:floor(N/2)), 'b');
hold on;
plot(f(1:floor(N/2)), Y_filtered(1:floor(N/2)), 'r');
title('Frequency Spectrum');
legend('Original Noisy', 'High-Pass Filtered');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Save the filtered signal
audiowrite('filtered_highpass.wav', filteredSignal, Fs);

% Play the original and filtered signals
disp('Playing the original noisy signal...');
sound(noisySignal, Fs);
pause(length(noisySignal)/Fs + 1); % Pause to allow the playback to finish

disp('Playing the filtered signal...');
sound(filteredSignal, Fs);
