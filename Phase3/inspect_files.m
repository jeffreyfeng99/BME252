files = dir('./input_dir/*.wav');

for i = 1:length(files),
    name = files(i).name;
    folder = files(i).folder;
    [y, Fs] = audioread(strcat(folder,'\',name));
    disp(name)
    disp(Fs)
end
   