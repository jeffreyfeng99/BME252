function write_sound(output_signal, Fs, input_file)
    % Write audio signals to a new file
    % Parameters
    % ----------
    %     output_signal (double array) - output audio signal
    %     Fs (int) - sampling rate
    %     input_file (string) - name of the input file
    
    % Create output folder if it doesn't exist
    if ~exist('output_dir', 'dir')
       mkdir('output_dir');
    end
    
    % When writing the audio signal, the naming format is
    % "output_/input_file/_/iter/.wav". iter helps to keep count of the 
    % number of times the input file has been used. 
    iter = 0;
    file_exists = true;
    while file_exists == true
      if exist(strcat('./output_dir/output_',input_file,'_',num2str(iter),'.wav'))
        iter = iter + 1;
      else 
        audiowrite(strcat('./output_dir/output_',input_file,'_',num2str(iter),'.wav'),output_signal,Fs);
        file_exists = false;
      end
    end
end
