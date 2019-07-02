function read_write_plot_sounds(input_filename)

% Read file and find sampling rate
[y,Fs] = audioread(input_filename);

% Convert stereo to mono if necessary
if size(y,2) > 1
   y = sum(y, 2);
end
    
% Play sound at original sampling rate
sound(y, Fs);

% Write sound to new file
if ~exist('output_dir', 'dir')
   mkdir('output_dir');
end
iter = 0;
file_exists = true;
while file_exists == true
  if exist(strcat('./output_dir/output_file_',num2str(iter),'.wav'))
    iter = iter + 1;
  else 
    audiowrite(strcat('./output_dir/output_file_',num2str(iter),'.wav'),y,Fs);
    file_exists = false;
  end
 end
   
% Plot waveform as a function of original sampling rate
plot(y)

% Resample to 16kHz
% resampled is a Boolean that flags if the original sampling rate is over 16kHz
resampled = false;
if Fs > 16e3 
  [P,Q] = rat(16e3/Fs);
  y = resample(y,P,Q);
  resampled = true;
end

% Create cosine

% s_rate should be 16kHz if resampled
% Else, the same as original sampling rate
if resampled
  s_rate = 16e3;
else 
  s_rate = Fs;
end

% Create cosine wave with the equal time 
% and same number of points as the original input at 1 kHz
t = [0:1/s_rate:size(y,1)/s_rate];
cosine_signal = cos(2e3*pi*t);
figure
% Plot two periods in a new figure
plot(t(1:s_rate/500+1),cosine_signal(1:s_rate/500+1));
%Play sound of respective sample rate
sound(cosine_signal, s_rate);




end