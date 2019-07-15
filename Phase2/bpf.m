function bpf(channels, frequency_range, passband_type, lowpass_type, signal, sample_rate, plot_time_domain, use_abs)
  % channels - # channels specified
  % frequency_range - two values 
  % passband_type - string for type of passband filter
  % lowpass_type - string for type of lowpass filter
  % signal - array containing sound signal
  % sample rate - integer indicating sample rate
  % plot_time_domain -  boolean if false, plots are in frequency domain. 
  %                     If true or empty plots are in the time domain
  % use_abs - boolean that toggles the rectification technique
  %
  % CURRENT LIMITATION: sampling rate controls the range of plottable x values
  %                     anything over that limit will overlap

  % Initialize constants and variables
  num_samples = length(signal);
  channel_width = (frequency_range(2)-frequency_range(1))/channels;
  
  % Create subplots for signal and filtered channels
  figure(1)
  subplot(channels + 1,1,1);
  % Plot the original signal
  if plot_time_domain == true,
    plot(signal);
  else
    Y = fft(signal);
    P2 = abs(Y);
    P1 = P2(1:floor(num_samples/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = sample_rate*(0:floor(num_samples/2))/num_samples;
    plot(f,P1); 
  end
  title("Raw Audio")
  
  % Filter over the channels
  for i=1:channels,
    
    % Define the filter properties for the specific channels
    fc = (i*channel_width) - (channel_width/2) + frequency_range(1);
    fl = fc - (channel_width/2); % Lower cutoff
    fh = fc + (channel_width/2) - 1; % High cutoff
    passband = [fl fh];
    
    % Create passband filters
    if strcmp(passband_type,"bessel"),
      [b,a] = besself(1, passband*2*pi, 'bandpass');
      [b,a] = impinvar(b,a, sample_rate);
    elseif strcmp(passband_type,"butter"),
      [b,a] = butter(3, passband/frequency_range(2));
    elseif strcmp(passband_type,"cheby1"),
      [b,a] = cheby1(1, 3, passband/frequency_range(2));
    elseif strcmp(passband_type,"fir1"),   
      b = fir1(10, passband/frequency_range(2));
      a = 1;
    elseif strcmp(passband_type,"kaiser"),
        win = kaiser(51, 8);
        % Calculate the coefficients using the FIR1 function.
        b  = fir1(50, passband/(sample_rate/2+1), 'bandpass', win, 'scale');
        Hk = dfilt.dffir(b);
    end
    
    % Apply bandpass filter
    if strcmp(passband_type,"kaiser"),
        filtered = filter(Hk,signal);
    else
        filtered = filter(b,a,signal);
    end
  
    % Rectify 
    if use_abs == true,
        rectified = abs(filtered);
    else
        rectified = filtered.*filtered;
    end
    
    % Create lowpass filter for envelope
    if strcmp(lowpass_type, "bessel"),
        [e,f] = besself(1, 400*2*pi); % analog besself 
        [e,f] = impinvar(e,f,sample_rate);
    elseif strcmp(lowpass_type, "butter"),
        [e,f] = butter(1, 400/(sample_rate/2)); %digital butter filter 
        
        % Produces same result as digital butter filter
        %h  = fdesign.lowpass('N,F3dB', 1, 400, 16000);
        %Hd1 = design(h, 'butter');
        
        %[e,f] = butter(1,400*2*pi,'s'); %analog butter filter
        %[e,f] = impinvar(e,f,sample_rate);
    elseif strcmp(lowpass_type, "cheby1"),
        [e,f] = cheby1(1, 3, 400/(sample_rate/2));
    elseif strcmp(lowpass_type,"fir1"),   
        e = fir1(11, 400/(sample_rate/2),'low');
        f = 1;
    elseif strcmp(lowpass_type, "kaiser"),
        win = kaiser(21, 8);
        % Calculate the coefficients using the FIR1 function.
        b  = fir1(20, 400/(sample_rate/2), 'low', win, 'scale');
        Hk = dfilt.dffir(b);
    end 
    
    % Apply lowpass filter
    if use_abs == true,
        if strcmp(lowpass_type,"kaiser"),
            enveloped = filter(Hk,rectified);
        elseif strcmp(lowpass_type,"default"),
            [enveloped,ylower] = envelope(rectified);
        else
            enveloped = filter(e,f, rectified);
        end
    else
        if strcmp(lowpass_type,"kaiser"),
            enveloped = filter(Hk,sqrt(2*rectified));
        elseif strcmp(lowpass_type,"default"),
            [enveloped,ylower] = envelope(rectified);
        else
            % Lower peaks
            enveloped = filter(e,f, sqrt(2*rectified));
            
            % Higher peaks
            % enveloped = filter(Hk, (2*rectified)); 
            % enveloped = sqrt(enveloped); 
        end
    end
    
    % Plot filtered signals
    figure(1)
    subplot(channels+1,1,i+1)
    if plot_time_domain == true,
      plot(filtered);
    else
      % DFT the filtered signal to freq domain
      Y = fft(filtered);
      P2 = abs(Y);
      P1 = P2(1:floor(num_samples/2)+1);
      P1(2:end-1) = 2*P1(2:end-1);
      f = sample_rate*(0:floor(num_samples/2))/num_samples;
      plot(f, P1);
    end
    
    % Plot envelope
    if i==1 | i==channels,
      figure(i+100)
      plot(abs(filtered));
      hold on
      plot(enveloped);
      hold off
    end
    
    figure(1)
    title(sprintf("Channel %d",i))
    
  end
end

