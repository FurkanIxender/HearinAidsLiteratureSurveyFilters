% MATLAB Script to Add Noise to an Audio Sample and Save the Noise as a Separate File

% Parameters
inputFileName = 'harvard.wav';  % Name of the input audio file
outputAudioFileName = 'harvardn.wav';  % Name of the output audio file with noise
outputNoiseFileName = 'noise_only.wav';  % Name of the output file for the noise only
noiseLevel = 0.1;  % Noise level (scale of the noise to add)

% Read the input audio file
[audioData, fs] = audioread(inputFileName);

% Check if audio is stereo or mono
if size(audioData, 2) == 2
    % Convert stereo to mono by averaging the two channels
    audioData = mean(audioData, 2);
end

% Generate white noise
% White noise has the same length as the audio data
noise = noiseLevel * randn(size(audioData));

% Save the noise to a separate file
audiowrite(outputNoiseFileName, noise, fs);

% Add the noise to the audio signal
audioWithNoise = audioData + noise;

% Ensure the output signal is within the range [-1, 1]
audioWithNoise = max(min(audioWithNoise, 1), -1);

% Write the noisy audio to a new file
audiowrite(outputAudioFileName, audioWithNoise, fs);

% Display information
disp('Noisy audio has been saved to:');
disp(outputAudioFileName);
disp('Noise-only audio has been saved to:');
disp(outputNoiseFileName);
