[y, Fs] = audioread("oboe-bassoon.wav");
disp(Fs)
disp(size(y))
if size(y,2) > 1
   y = sum(y, 2);
end
if Fs > 16e3 
  [P,Q] = rat(16e3/Fs);
  y = resample(y,P,Q);
  Fs = 16e3
  resampled = true;
end

xx = [0:1/16000:2000/16000];
data = sin(2*pi*890*xx) + sin(2*pi*2400*xx) + sin(2*pi*5600*xx);
%bpf(5, "butter", data, 16000);

%data = sin(2*pi*900*xx);
%bpf(5, "cheby1", y.', Fs);
bpf(5, "butter", y, Fs);

##[b,a]=besself(5,10000)
##figure
##freqz(b,a)
##plot(fft(freqz(b,a)))