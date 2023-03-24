clc; clear all; close all;

folder = "Data/";
folder_list = dir(folder);
folder_list(ismember( {folder_list.name}, {'.', '..'})) = [];
for f = 1:numel(folder_list)
    wav_folder = sprintf("%s\\%s",folder_list(f).folder,folder_list(f).name);
    wav_list = dir(sprintf('%s\\*.wav', wav_folder));
    person = convertStringsToChars(wav_folder);
    person = person(end-4:end);
    person = convertCharsToStrings(person);
    txt_name = strcat("FileList_", person, ".txt");
    out = fopen(txt_name, 'w');
    for i = 1 : size(wav_list,1)
        wav_path = sprintf("%s\\%s",wav_list(i).folder,wav_list(i).name);
        if (i >= size(wav_list,1))
            fprintf(out, "%s", wav_path);
        else
            fprintf(out, "%s\n", wav_path);
        end
    end
    fclose('all');
end
fclose('all');