function [wns,LS] = sp_load_file_for_script_pharos_line(folder, filename,n_x,n_wn)

%n_x=105;
%n_wn=1250;

filepath = strcat(folder, "\", filename, ".txt");
%disp(filepath);


% Open the file
A=readmatrix(filepath);
wns=A(1:n_wn*2,4);
spectra=A(:,9); % for S2
LS=reshape(spectra,[n_wn*2 n_x]);




%NF_spectra(:,1)=A(:,5); %the wavenumber
%NF_spectra(:,2)=A(:,9); %S2

%the wavenumber vector is the first 2*n_wn 