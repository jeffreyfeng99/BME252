% channels -- # channels specified
% type -- string for type of filter
% CURRENT LIMITATION: sampling rate controls the range of plottable x values
% anything over that limit will overlap :( 
function bpf(channels, type, signal, sample_rate, varargin)
  
  % Initialize constants and variables
  num_samples = length(signal);
  x = zeros(1, channels); % THIS IS UNUSED
  total_width = 7900/channels;
  
  plot_time_domain = true;
  if ~isempty(varargin),
    plot_time_domain = varargin{1};
  end
  
  % Create subplots for signal and filtered channels
  figure(1)
  subplot(channels + 1,1,1);
  
  % Plot the original signal

  if plot_time_domain == true,
    plot(signal);
  else
    Y = fft(signal);
    P2 = abs(Y); % /43250 for scaling
    P1 = P2(1:num_samples/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = sample_rate*(0:(num_samples/2))/num_samples;
    plot(f,P1) 
  end
  title("Raw Audio")
  
  % Filter over the channels
  for i=1:channels,
    
    % Define the filter properties for the specific channels
    fc = (i*total_width) - (total_width/2) + 100
    fl = fc - (total_width/2) % Lower cutoff
    fh = fc + (total_width/2) % High cutoff
    passband = [fl fh]
    
    % Create passband filters
    if type=="bessel",
      % bessel set up
      [b,a] = besself(1, fc);
    elseif type=="butter",
      % butter set up
      [b,a] = butter(7, passband/8001);
    elseif type=="cheby1",
      % cheby first order set up
      [b,a] = cheby1(1, 3, passband/8001);
    elseif type=="fir1  ",   %Check string size first, and then character equality
      b = fir1(10, passband/8000);
    elseif type=="kaiser",
        win = kaiser(51, 8);

        % Calculate the coefficients using the FIR1 function.
        b  = fir1(50, passband/(sample_rate/2+1), 'bandpass', win, 'scale');
        Hk = dfilt.dffir(b);
    end
    
    % Apply filters
    if ~strcmp(type,"kaiser"),
        filtered = filter(b,a,signal);
    else
        filtered = filter(Hk,signal);
    end
  
    % Rectify
    
    Hd2 = dsp.LowpassFilter('SampleRate',sample_rate, 'FilterOrder', 10, 'PassbandFrequency', 400, 'FilterType', 'IIR', 'DesignForMinimumOrder',false);
    rectified = filtered.*filtered;
    %rectified = decimate(rectified,5,'fir')
   %rectified = abs(filtered)
    [e,f] = butter(2, 400/(sample_rate/2)); %digital butter filter 
    %[e,f] = butter(1,400*2*pi,'s'); %analog butter filter 
    %[e,f] = besself(1, 400); % analog besself 
    
    % Manual transfer function
      % num = [0, 2000]
      % den = [1, 2000]
      % Hs = tf(num,den)
     
    % View bode plots 
      % LPF = tf(e,f);
      % figure(12)
      % freqz(e,f);
      % figure(13)
      % bode(Hs);
      
    win = kaiser(21, 8);

    % Calculate the coefficients using the FIR1 function.
    b  = fir1(20, 400/(sample_rate), 'low', win, 'scale');
    Hk = dfilt.dffir(b);
    
    h  = fdesign.lowpass('N,F3dB', 1, 400, 16000);
    Hd1 = design(h, 'butter');
%     enveloped = filter(Hk, (2*rectified)); % higher peaks
%     enveloped = sqrt(enveloped);  
    enveloped = filter(Hd1, sqrt(2*rectified)); % lower peaks
   [enveloped,ylower] = envelope(rectified)
    
    disp(i+1)
    figure(1)
    subplot(channels+1,1,i+1)
    if plot_time_domain == true,
      plot(filtered);
    else
      % DFT the filtered signal to freq domain
      Y = fft(filtered);
      P2 = abs(Y);
      P1 = P2(1:num_samples/2+1);
      P1(2:end-1) = 2*P1(2:end-1);
      f = sample_rate*(0:(num_samples/2))/num_samples;
      plot(f, P1);
    end
    
    if i==1,
      figure(3)
      plot(abs(filtered));
      hold on
      plot(enveloped);
      hold off
    end
    
    figure(1)
    title(sprintf("Channel %d",i))
    
  end
end

