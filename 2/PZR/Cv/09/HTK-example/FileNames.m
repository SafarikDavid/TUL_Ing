clc; clear all; close all;

folder = "DataTest/";
folder_list = dir(folder);
folder_list(ismember( {folder_list.name}, {'.', '..'})) = [];
out = fopen("FileList.txt", 'w');
for f = 1:numel(folder_list)
    wav_folder = sprintf("%s\\%s",folder_list(f).folder,folder_list(f).name);
    wav_list = dir(sprintf('%s\\*.wav', wav_folder));
    for i = 1 : size(wav_list,1)
        wav_path = sprintf("%s\\%s",wav_list(i).folder,wav_list(i).name);
        fprintf(out, "%s\n", wav_path);
    end
end
fclose('all');