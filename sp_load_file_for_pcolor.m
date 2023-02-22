function [A] = sp_load_file_for_pcolor(folder, filename,figname)


filepath = strcat(folder, "\", filename, ".txt");
%disp(filepath);


% Open the file
A=readmatrix(filepath);
A=flip(A,1); %because saving from gwyddion makes it go upside down
%we just want the matrix value coordinates, not the x,y coordinates
figure();
aa=pcolor(A);
set(aa,'EdgeColor','none');      %remove the lines for the pcolor plot
set(gca,'xticklabel',[],'yticklabel',[]);
pbaspect([7.5 9.3 1])
title(figname); %title plot

% extract just frequency, S2, S3, S4
% NF_spectra(:,1)=A(:,4);
% NF_spectra(:,2)=A(:,9);
% NF_spectra(:,3)=A(:,11);
% NF_spectra(:,4)=A(:,13);