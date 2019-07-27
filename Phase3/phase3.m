% File selection
input_file = 'bigblue.wav';
[y, Fs] = audioread(strcat('input_dir/',input_file));
[y, Fs] = preprocess(y, Fs);

% Pass sound through filter and generate envelopes
% Sine wave for testing
t = [0:1/16000:500/16000];
data = sin(2*pi*890*t) + sin(2*pi*2400*t) + sin(2*pi*5600*t);
% bpf(channels, overlap, band, bandpass, bandpass_order,
%     lowpass, lowpass_order, lowpass_cutoff, data, samplingrate, 
%     plot_time, use_abs, show_plots)

% [envelopes, fc] = bpf(24, -0.1, [100 8000], "butter", 3, ...
%                      "bessel", 5, 400, y, Fs, ... 
%                      false, false, false);
[envelopes, fc] = bpf_test(24, 0, [100 8000], "butter", 3, ...
                      "bessel", 5, 400, y, Fs, ... 
                      false, false, false, 1);
                  
% Synthesize output
output_signal = amp_modulate(Fs, envelopes, fc);

% Write sound to new file
write_sound(output_signal, Fs, input_file);

%Play sound
sound(output_signal, Fs)
%sound(y,Fs)

