% bandpass_filter_and_amplify.m
% Parameters
Fs = 44100; % Sampling frequency in Hz
Fpass = [350 3000]; % Pass band frequencies to target speech frequencies
desired_dB = -20; % Desired dB level for the output

% Load your own audio file
[noisySignal, Fs] = audioread('jackhammer.wav');

% Design a Butterworth band-pass filter
[b_band, a_band] = butter(4, Fpass / (Fs / 2), 'bandpass');

% Apply the band-pass filter
filteredSignal_band = filtfilt(b_band, a_band, noisySignal);

% Ensure filteredSignal_band is a column vector
if size(filteredSignal_band, 2) > 1
    filteredSignal_band = filteredSignal_band(:, 1);
end

% Compute RMS value for the filtered signal
rms_filtered_band = rms(filteredSignal_band);

% Convert desired dB level to linear scale
desired_linear = 10^(desired_dB / 20);

% Check if rms_filtered_band is a scalar
if ~isscalar(rms_filtered_band)
    error('rms_filtered_band should be a scalar.');
end

% Compute gain factor to match desired dB level
gain_band = desired_linear / (rms_filtered_band + eps); % Adding eps to avoid division by zero

% Apply gain to filtered signal
amplifiedSignal_band = filteredSignal_band * gain_band;

% Compute the frequency spectrum of the original and filtered signals
N = length(noisySignal);
f = (0:N-1)*(Fs/N);
Y_noisy = abs(fft(noisySignal));
Y_filtered_band = abs(fft(filteredSignal_band));
Y_amplified = abs(fft(amplifiedSignal_band));

% Save and play the amplified signal
audiowrite('amplified_bandpass.wav', amplifiedSignal_band, Fs);

% Plot the results
figure;
subplot(3,1,1);
plot((1:length(noisySignal))/Fs, noisySignal);
title('Original Noisy Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot((1:length(filteredSignal_band))/Fs, filteredSignal_band);
title('Band-Pass Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(f(1:floor(N/2)), Y_noisy(1:floor(N/2)), 'b');
hold on;
plot(f(1:floor(N/2)), Y_filtered_band(1:floor(N/2)), 'r');
plot(f(1:floor(N/2)), Y_amplified(1:floor(N/2)), 'g');
title('Frequency Spectrum');
legend('Original Noisy', 'Band-Pass Filtered', 'Amplified Filtered');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Play the amplified signal
disp('Playing the amplified band-pass filtered signal...');
sound(amplifiedSignal_band, Fs);
pause(length(amplifiedSignal_band)/Fs + 1);
