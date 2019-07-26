function write_sound(output_signal, Fs, input_file)
    % Write sound to new file
    
    % Create output folder if it doesn't exist
    if ~exist('output_dir', 'dir')
       mkdir('output_dir');
    end
    
    iter = 0;
    file_exists = true;
    while file_exists == true
      if exist(strcat('./output_dir/output_file_',input_file,'_',num2str(iter),'.wav'))
        iter = iter + 1;
      else 
        audiowrite(strcat('./output_dir/output_file_',input_file,'_',num2str(iter),'.wav'),output_signal,Fs);
        file_exists = false;
      end
    end
end
