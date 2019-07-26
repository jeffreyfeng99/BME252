function [y, Fs] = downsample(y, Fs)
    % Convert stereo to mono if necessary
    if size(y,2) > 1
       y = sum(y, 2);
    end

    % Downsampling if necessary
    if Fs > 16e3 
      [P,Q] = rat(16e3/Fs);
      y = resample(y,P,Q);
      Fs = 16e3;
    end
end
