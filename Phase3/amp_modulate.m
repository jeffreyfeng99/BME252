function output_signal = amp_modulate(Fs, envelopes, fc)
    % Apply amplitude modulation between a given set of rectified signals
    % and cosine signals of specific frequencies
    % Parameters
    % ----------
    %   Fs (int) - sampling rate
    %   envelopes (double array) - n x channels array of the rectified
    %                             signals, where n is the number of sampled
    %                             points in each envelope
    %   fc (double array) - 1 x channels array containing the center
    %                       frequencies of the bandpass filters used in
    %                       each of the respective channels
    %
    % Returns
    % -------
    %   output_signal (double array) - n x 1 array containing the
    %                                  synthesized output signal.
    %                                  Normalized sum of all the amplitude
    %                                  modulated signals
    
    
    % Create an empty output signal array to contain each amplitude 
    % modulated signal, as well as the time axis used for cosine signal
    output_signal = zeros(size(envelopes));
    t = 0:1/Fs:(size(envelopes(:, 1))-1)/Fs;
    
    % For each channel, create cosine signal of given center frequncy
    % Amplitude modulation with corresponding rectified signal and cosine signal
    for i = 1:length(fc),
        cosine_signal = cos(2*fc(i)*pi*t);
        output_signal(:, i) = envelopes(:, i)'.*cosine_signal;
    end
    
    % Sum the modulated signals to a single n x 1 signal
    output_signal = sum(output_signal, 2);
    
    % Normalize output by the maximum of the absolute value of the signal
    max_val = max(abs(output_signal));
    output_signal = output_signal/max_val;
end