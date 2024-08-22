% MATLAB Script to Extract a Specific Segment of an Audio Sample (from second 1 to 5)

% Parameters
inputFileName = 'harvard.wav';  % Name of the input audio file
outputFileName = 'harvard15.wav';  % Name of the output audio file
startTime = 1;  % Start time in seconds
endTime = 5;    % End time in seconds

% Read the input audio file
[audioData, fs] = audioread(inputFileName);

% Calculate the number of samples to extract
startSample = startTime * fs;
endSample = endTime * fs;

% Ensure that the specified range is within the length of the audio data
if startSample < 1 || endSample > length(audioData)
    error('The specified time range exceeds the length of the audio file.');
end

% Extract the audio segment from startTime to endTime
audioSegment = audioData(startSample:endSample);

% Write the extracted audio segment to a new file
audiowrite(outputFileName, audioSegment, fs);

% Display information
disp('Extracted audio segment has been saved to:');
disp(outputFileName);
