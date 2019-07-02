% channels -- # channels specified
% type -- string for type of filter
% CURRENT LIMITATION: sampling rate controls the range of plottable x values
% anything over that limit will overlap :( 
function bpf(channels, type, signal, sample_rate)
  length = length(signal);

  x = zeros(1, channels);
  % or do linspace
  % x = linspace(0, n, n)
  
  width = 7900/channels;
  
  figure
  subplot(6,1,1);
  Y = fft(signal);
  disp(size(Y))
  P2 = abs(Y); % /43250
  P1 = P2(1:length/2+1);
  P1(2:end-1) = 2*P1(2:end-1);
  f = sample_rate*(0:(length/2))/length;
  plot(f,P1) 
  %plot(signal);
  title("Raw Audio")
  %plot(abs(fft(signal)))
  
  for i=1:channels,
    fc = (i*width) - (width/2) + 100
    fl = fc - (width/2) % Lower cutoff
    fh = fc + (width/2) % High cutoff
    passband = [fl fh]
    
    % create passband filters
    if type=="bessel",
      % bessel set up
      [b,a] = besself(1, fc);
      %[h,w] = freqz(b, a);
    end
       
    if type=="butter",
      % butter set up
      [b,a] = butter(4, passband/8001);
      %[h,w] = freqz(b,a);
      pause(1)
    end
    
    if type=="cheby1",
      % cheby first order set up
      [b,a] = cheby1(1, 3, passband/8000);
      %[h,w] = freqz(b,a);
    end
    
    if type=="fir1  ",   %Check string size first, and then character equality
      b = fir1(10, passband/8000);
    end
    
    if type!="fir1  ",
    filtered = filtfilt(b, a, signal);
    else
    filtered = filtfilt(b,1,signal);
    end
  
    % Rectify
    filtered = abs(filtered);
    rectified = 2*filtered.*filtered;
    [c,d] = butter(1, 0.001);
    enveloped = filter(c, d, rectified);
    enveloped = sqrt(2*enveloped);  
    
    disp(i+1)
    %subplot(6,1,i+1)
    % DFT the filtered signal to freq domain
    Y = fft(filtered);
    P2 = abs(Y);
    P1 = P2(1:length/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = sample_rate*(0:(length/2))/length;

    %plot(f, P1);
    if i==1,
      figure
      plot(filtered);
      hold on
      plot(enveloped);
    end
    
    %ylim([0 2000]);
    #title(sprintf("Channel %d",i))
    %plot(abs(fft(filtered)))
    
    
  end
 
  disp(x)

end



