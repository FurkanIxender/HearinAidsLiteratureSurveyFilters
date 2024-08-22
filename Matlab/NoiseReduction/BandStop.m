% Parameters
Fs = 44100; % Sampling frequency in Hz (modify as needed)
Fstop = [1500 10000]; % Stop band frequencies in Hz
order = 4; % Filter order

% Load your own audio file
[noisySignal, Fs] = audioread('harvardn.wav');

% Design an elliptic band-stop filter
[b, a] = ellip(order, 0.5, 40, Fstop / (Fs / 2), 'stop');

% Apply filter to noisy signal
filteredSignal = filtfilt(b, a, noisySignal);

% Compute the Fourier Transform for the frequency spectrum plot
N = length(noisySignal);
Y_noisy = abs(fft(noisySignal));
Y_filtered_band = abs(fft(filteredSignal));
f = (0:N-1)*(Fs/N); % Frequency axis

% Plot results
figure;

% Plot Noisy Signal
subplot(3,1,1);
plot(noisySignal);
title('Noisy Signal');
xlabel('Sample Number');
ylabel('Amplitude');

% Plot Filtered Signal
subplot(3,1,2);
plot(filteredSignal);
title('Filtered Signal with Band-Stop Filter');
xlabel('Sample Number');
ylabel('Amplitude');

% Plot Frequency Spectrum
subplot(3,1,3);
plot(f(1:floor(N/2)), Y_noisy(1:floor(N/2)), 'b');
hold on;
plot(f(1:floor(N/2)), Y_filtered_band(1:floor(N/2)), 'r');
title('Frequency Spectrum');
legend('Original Noisy', 'Band-Stop Filtered');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 Fs/2]); % Limit x-axis to Nyquist frequency

% Save the filtered signal
audiowrite('filtered_bandstop.wav', filteredSignal, Fs);

% Play the original and filtered signals
disp('Playing the original noisy signal...');
sound(noisySignal, Fs);
pause(length(noisySignal)/Fs + 1); % Pause to allow the playback to finish

disp('Playing the filtered signal...');
sound(filteredSignal, Fs);
