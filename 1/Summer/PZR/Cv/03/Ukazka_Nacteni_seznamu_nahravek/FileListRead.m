%nacteni fileListu
fileID = fopen('FileList.txt','r'); %otevreni seznamu
textdata = textscan(fileID,'%s');  %nacten
fclose(fileID); % zavreni seznamu
fileNames = string(textdata{:}); %pole souboru i s cestami
numFiles = size (fileNames, 1); %pocet souboru
