clc; clear all; close all;

folder = "DataTest/";
folder_list = dir(folder);
folder_list(ismember( {folder_list.name}, {'.', '..'})) = [];
out = fopen("test.mlf", 'w');
for f = 1:numel(folder_list)
    wav_folder = sprintf("%s\\%s",folder_list(f).folder,folder_list(f).name);
    wav_list = dir(sprintf('%s\\*.wav', wav_folder));
    lab_list = dir(sprintf('%s\\*.lab', wav_folder));
    for i = 1 : size(wav_list,1)
        lab_path = sprintf("%s\\%s",lab_list(i).folder,lab_list(i).name);
        in_file = fopen(lab_path, 'r');
        in_string = fscanf(in_file, '%s');
        fclose(in_file);
        fprintf(out, '"%s"\n%s\n%s\n%s\n.\n', lab_path, in_string(1:3), in_string(4:end-3), in_string(end-2:end));
    end
end
fclose('all');