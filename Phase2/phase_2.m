% File selection
[y, Fs] = audioread("input_dir/trumpet.wav");

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
% Call function
bpf(12, [100 8000], "kaiser", "fir1", y, Fs, false, false);