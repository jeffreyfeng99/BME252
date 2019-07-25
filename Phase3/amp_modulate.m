function output_signal = amp_modulate(Fs, envelopes, fc)

    % Create output signal and time time axis
    output_signal = zeros(size(envelopes));
    t = [0:1/Fs:(size(envelopes(:, 1))-1)/Fs];
    
    % Create cosine signal of given center frequncy
    % Amplitude modulation with envelopeselope and cosine
    for i = 1:length(fc),
        cosine_signal = cos(2*fc(i)*pi*t);
        output_signal(:, i) = envelopes(:, i)'.*cosine_signal;
        max_val = max(abs(output_signal(:, i)));
        output_signal(:, i) = output_signal(:, i)/max_val;
    end
    
    % Sum the modulated signals
    output_signal = sum(output_signal, 2);
end