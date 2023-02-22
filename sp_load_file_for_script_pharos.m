function [NF_spectra] = sp_load_file_for_script_pharos(folder, filename)


filepath = strcat(folder, "\", filename, ".txt");
%disp(filepath);


% Open the file
A=readmatrix(filepath);

% extract just frequency, S2, S3, S4
NF_spectra(:,1)=A(:,4);
NF_spectra(:,2)=A(:,9);
NF_spectra(:,3)=A(:,11);
NF_spectra(:,4)=A(:,13);