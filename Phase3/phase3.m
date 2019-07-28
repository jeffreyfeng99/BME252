% File selection
input_file = files(26).name;
[y, Fs] = audioread(strcat('input_dir/',input_file));
[y, Fs] = preprocess(y, Fs);

% Pass sound through filter and generate envelopes
% bpf(channels, overlap, band, bandpass, bandpass_order,
%     lowpass, lowpass_order, lowpass_cutoff, data, samplingrate, 
%     plot_time, use_abs, show_plots)

% [envelopes, fc] = bpf(80, 0.2, [100 8000], "cheby1", 3, ...
%                      "cheby1", 5, 400, y, Fs, ... 
%                      false, false, false);
[envelopes, fc] = bpf_test(75, 0, [100 8000], "cheby1", 3, ...
                      "butter", 10, 400, y, Fs, ... 
                      false, false, false, 1);
                  
% Synthesize output
output_signal = amp_modulate(Fs, envelopes, fc);

% Write sound to new file
write_sound(output_signal, Fs, input_file);

%Play sound
play_original = false;
if play_original == true
    sound(y,Fs);
else
    sound(output_signal, Fs)
end

