% File selection
input_file = files(14).name; % run inspect_files.m first
[y, Fs] = audioread(strcat('input_dir/',input_file));
[y, Fs] = preprocess(y, Fs);

% Pass sound through filter and generate envelopes
[envelopes, fc] = bpf(75, 0, [100 8000], "cheby1", 4, ...
                      "butter", 10, 400, y, Fs, ... 
                      false, false, false, 1.025);
                  
% Synthesize output
output_signal = amp_modulate(Fs, envelopes, fc);

% Write sound to new file
write_sound(output_signal, Fs, input_file);

% Play sound
play_original = false; % Use this to toggle during testing
if play_original == true
    sound(y,Fs);
else
    sound(output_signal, Fs)
end

