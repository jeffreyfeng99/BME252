function output_signal = amp_modulate(Fs, env, fc);
    output_signal = zeros(size(env));
    t = [0:1/Fs:(size(env(:, 1))-1)/Fs];
    
    for i = 1:length(fc),
    cosine_signal = cos(fc(i)*pi*t);
    output_signal(:, i) = env(:, i)'.*cosine_signal;
    end
    
    output_signal = sum(output_signal, 2);
    
    max_val = max(abs(output_signal));
    output_signal = output_signal/max_val;
end