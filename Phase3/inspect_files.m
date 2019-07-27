% Standalone script used to inspect the properties of the sound files.
% Using this to ensure that the sampling rate of each sound file is greater
% than 16000 Hz.

% Create an array of the input files 
% Note that 'dir' also selects directories
files = dir('./input_dir');

% Iterate through the array, and use audioread on each of the sound files
% to obtain the sampling rate
for i = 1:length(files) 
    if files(i).isdir == false % If the array is not a directory 
        [y, Fs] = audioread(strcat(files(i).folder,'\',files(i).name));
        if Fs < 16e3
            disp(files(i).name)
            disp(Fs)
        end
    end
end
disp("Done!")
   