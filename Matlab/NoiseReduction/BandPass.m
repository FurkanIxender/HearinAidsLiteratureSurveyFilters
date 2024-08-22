% Parameters
Fs = 44100; % Sampling frequency in Hz (modify as needed)
Fpass = [300 3000]; % Pass band frequencies in Hz
order_band = 4; % Filter order

% Load your own audio file
[noisySignal, Fs] = audioread('harvardn.wav'); 

% Design a Chebyshev Type I band-pass filter
[b_band, a_band] = cheby1(order_band, 0.5, Fpass / (Fs / 2), 'bandpass');

% Apply the band-pass filter to the noisy signal
filteredSignal_band = filtfilt(b_band, a_band, noisySignal);

% Compute the FFT of the original and filtered signals
N = length(noisySignal); % Number of samples
f = (0:N-1)*(Fs/N); % Frequency vector
Y_noisy = abs(fft(noisySignal));
Y_filtered_band = abs(fft(filteredSignal_band));

% Normalize the FFT results for plotting
Y_noisy = Y_noisy / max(Y_noisy);
Y_filtered_band = Y_filtered_band / max(Y_filtered_band);

% Plot the results
figure;

% Plot the original noisy signal
subplot(3,1,1);
plot((1:length(noisySignal))/Fs, noisySignal);
title('Original Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the band-pass filtered signal
subplot(3,1,2);
plot((1:length(filteredSignal_band))/Fs, filteredSignal_band);
title('Band-Pass Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the frequency spectrum
subplot(3,1,3);
% Only plot the positive frequencies
plot(f(1:floor(N/2)), Y_noisy(1:floor(N/2)), 'b');
hold on;
plot(f(1:floor(N/2)), Y_filtered_band(1:floor(N/2)), 'r');
title('Frequency Spectrum');
legend('Original Noisy', 'Band-Pass Filtered');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');

disp('Playing the original noisy signal...');
sound(noisySignal, Fs);
pause(length(noisySignal)/Fs + 1); % Pause to allow the playback to finish

% Save and play the band-pass filtered signal
audiowrite('filtered_bandpass.wav', filteredSignal_band, Fs);
disp('Playing the band-pass filtered signal...');
sound(filteredSignal_band, Fs);
pause(length(filteredSignal_band)/Fs + 1);
