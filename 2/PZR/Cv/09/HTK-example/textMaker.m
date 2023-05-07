clc; clear all; close all;

classes = {'NULA'; 'JEDNA'; 'DVA'; 'TRI'; 'CTYRI'; 'PET'; 'SEST'; 'sedm'; 'osm'; 'devet'};

folder = "DataTest/";
data_folder_list = dir(folder);
data_folder_list(ismember( {data_folder_list.name}, {'.', '..'})) = [];
for i = 1:numel(data_folder_list)
    
    file_list = dir(fullfile(data_folder_list(i).folder,data_folder_list(i).name));
    
    for j = 1:numel(file_list)
        
        current_folder = file_list(j).folder;
        file_name = file_list(j).name;
        
        if length(file_name) > 4 && strcmp(file_name(end-3:end),'.wav')
            class = file_name(2);
            class_idx = str2num(class) + 1; 
            
            out_file_name = fullfile(current_folder, strcat(file_name(1:end-4),'.txt'));
            out = fopen(out_file_name, 'w');
            
            fprintf(out,"%s\n", upper(classes{class_idx}));
            
            fclose(out);
        end
        
    end
    
end
fclose('all');