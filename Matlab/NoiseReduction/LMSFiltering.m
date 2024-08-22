% adaptive_filtering_tuned.m

% Parameters
Fs = 44100; % Sampling frequency in Hz
mu = 0.01;  % Smaller LMS step size for stability
filterOrder = 64; % Higher order for better adaptation

[noisySignal, Fs] = audioread('harvardn.wav');
% noisySignal should be a column vector
if size(noisySignal, 2) > 1
    noisySignal = noisySignal(:, 1);
end


[referenceSignal, Fs] = audioread('noise_only.wav');
% Create a reference noise signal (for demonstration purposes)
referenceNoise = referenceSignal; % Use the noisy signal itself as a rough reference

% Initialize adaptive filter coefficients
adaptiveFilter = zeros(filterOrder, 1);

% Initialize the output signal
filteredSignal = zeros(size(noisySignal));

% LMS Adaptive Filtering
for n = filterOrder:length(noisySignal)
    % Extract a portion of the noisy signal
    x = referenceNoise(n:-1:n-filterOrder+1);
    
    % Calculate the filter output
    y = adaptiveFilter' * x;
    
    % Calculate the error between desired signal and filter output
    e = noisySignal(n) - y;
    
    % Update the filter coefficients
    adaptiveFilter = adaptiveFilter + mu * e * x;
    
    % Store the filtered signal
    filteredSignal(n) = e; % Output the error signal instead of the filter output
end

% Compute the FFT of the original and filtered signals for visualization
N = length(noisySignal);
f = (0:N-1)*(Fs/N); % Frequency range

Y_noisy = abs(fft(noisySignal));
Y_filtered = abs(fft(filteredSignal));

% Plot the results
figure;
subplot(3,1,1);
plot((1:length(noisySignal))/Fs, noisySignal);
title('Original Noisy Signal');

subplot(3,1,2);
plot((1:length(filteredSignal))/Fs, filteredSignal);
title('Filtered Signal (Adaptive LMS)');

subplot(3,1,3);
plot(f(1:floor(N/2)), Y_noisy(1:floor(N/2)), 'b');
hold on;
plot(f(1:floor(N/2)), Y_filtered(1:floor(N/2)), 'r');
title('Frequency Spectrum');
legend('Original Noisy', 'Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

% Save and play the filtered signal
audiowrite('filtered_adaptive_lms_tuned.wav', filteredSignal, Fs);
disp('Playing the adaptive filtered signal...');
sound(filteredSignal, Fs);
pause(length(filteredSignal)/Fs + 1);
