files = dir('./input_dir');

for i = 1:length(files),
    if files(i).isdir == false
        name = files(i).name;
        folder = files(i).folder;
        [y, Fs] = audioread(strcat(folder,'\',name));
        disp(name)
        disp(Fs)    
    end
end
   