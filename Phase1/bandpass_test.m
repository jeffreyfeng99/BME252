[y,Fs] = audioread('go_ahead.wav');

%w = linspace(0,10,100);
 
%[b, a] = butter (1, 0.5)
%freqs(b,a,w);


##y2 = fft(y');
##figure
##plot(abs(y2))

xx = [0:100];
f=30; %% sampling frequency
data = sin(188*xx); % 2*pi*30 = 188  %here data is the signal that will be passed through the filter bank
% suppose we want to supress anything below x hz and above y hz, with sampling frequency z hz, then
% normalized freqs for band pass is = fnorm = [x y]/(z/2)
%  fnorm should be between (0,1)
fnorm1 = [1 3]/15; % for bandpass, here 1 and 3 are the lower and upper cutoff respectively
% [b,a] = butter(n,Wn) % n = order of the filter, wn is the normalized
% cutoff freq
[b1,a1] = butter(10,fnorm1); % here the order of the filter is 10
data_1 = filtfilt(b1,a1,data); % band pass filter
fnorm2 = [3 5]/15; % for bandpass
[b2,a2] = butter(10,fnorm2);
data_2 = filtfilt(b2,a2,data); % band pass filter
fnorm3 = [5 7]/15; % for bandpass
[b3,a3] = butter(10,fnorm3);
data_3 = filtfilt(b3,a3,data); % band pass filter
fnorm4 = [7 9]/15; % for bandpass
[b4,a4] = butter(10,fnorm4);
data_4 = filtfilt(b4,a4,data); % band pass filter
fnorm5 = [9 11]/15; % for bandpass
[b5,a5] = butter(10,fnorm5);
data_5 = filtfilt(b5,a5,data); % band pass filter
fnorm6 = [11 14]/15; % for bandpass
[b6,a6] = butter(10,fnorm6);
data_6 = filtfilt(b6,a6,data); % band pass filter
figure
 subplot(3,1,1), plot(data), title('actual')
 subplot(3,1,2), plot(data_1), title('centered at 2hz')
 subplot(3,1,3), plot(data_2), title('centered at 4hz')
 
figure
 subplot(4,1,1), plot(data_3), title('centered at 6hz')
 subplot(4,1,2), plot(data_4), title('centered at 8hz')
 subplot(4,1,3), plot(data_5), title('centered at 10hz')
 subplot(4,1,4), plot(data_5), title('remaining frequencies')
 