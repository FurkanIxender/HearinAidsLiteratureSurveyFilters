% spectrogram_visualization.m
% Parameters
Fs = 44100; % Sampling frequency in Hz

% Load your own audio file
[signal, Fs] = audioread('harvardn.wav'); % Change filename if needed

% Ensure the signal is a column vector
if size(signal, 2) > 1
    signal = signal(:, 1);
end

% Define parameters for the spectrogram
window = hamming(1024); % Window size for the spectrogram
overlap = 512; % Overlap between windows
nfft = 2048; % Number of FFT points

% Create a spectrogram of the signal
figure;
spectrogram(signal, window, overlap, nfft, Fs, 'yaxis');
title('Spectrogram of Audio Signal');
colorbar;

% Optional: Play the audio signal
disp('Playing the audio signal...');
sound(signal, Fs);
pause(length(signal)/Fs + 1);
