function [y, Fs] = preprocess(y, Fs)
    % Apply relevant preprocessing to the input signal, such as conversion
    % from stereo to mono, and resampling to 16 000
    % Parameters
    % ----------
    %     y (double array) - input audio signal
    %     Fs (int) - sampling rate
    %
    % Return
    % ------
    %     y (float array) - preprocessed input audio signal
    %     Fs (int) - new sampling rate

    % Convert stereo to mono if necessary
    if size(y,2) > 1
       y = sum(y, 2);
    end

    % Downsampling to 16000 Hz if necessary
    if Fs > 16e3 
      [P,Q] = rat(16e3/Fs);
      y = resample(y,P,Q);
      Fs = 16e3;
    end
end
