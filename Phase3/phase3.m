% File selection
input_file = 'piano.wav';
[y, Fs] = audioread(strcat('input_dir/',input_file));

% Convert stereo to mono if necessary
if size(y,2) > 1
   y = sum(y, 2);
end

% Downsampling if necessary
if Fs > 16e3 
  [P,Q] = rat(16e3/Fs);
  y = resample(y,P,Q);
  Fs = 16e3;
  resampled = true;
end

% Pass sound through filter
% Sine wave for testing
t = [0:1/16000:500/16000];
data = sin(2*pi*890*t) + sin(2*pi*2400*t) + sin(2*pi*5600*t);
% Generate Envelopes
% bpf(channels, overlap, band, bandpass, lowpass, data, samplingrate, plot_time, use_abs, show_plots)
[envelopes, fc] = bpf(50, false, [100 8000], "butter", "kaiser", y, Fs, false, false, false);

% Synthesize output
output_signal = amp_modulate(Fs, envelopes, fc);
% Write sound to new file
if ~exist('output_dir', 'dir')
   mkdir('output_dir');
end
iter = 0;
file_exists = true;
while file_exists == true
  if exist(strcat('./output_dir/output_file_',input_file,'_',num2str(iter),'.wav'))
    iter = iter + 1;
  else 
    audiowrite(strcat('./output_dir/output_file_',input_file,'_',num2str(iter),'.wav'),output_signal,Fs);
    file_exists = false;
  end
end

%Play sound
sound(output_signal, Fs)
%sound(y,Fs)

