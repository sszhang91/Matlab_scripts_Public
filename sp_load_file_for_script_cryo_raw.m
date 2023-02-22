function [im_data, x, y,dx,dy] = sp_load_file_for_script_cryo_raw(folder, filebasename, suffix, dir,extension)

%file name template is, e.g. TaS2_190K_s3_bwd.gsf
%filebasename is TaS2_190K
%suffix is z, p, s3
%dir is fwd, bwd

%for cryo direct output asc files
%file name is "hBN_ET_50K_1482_002-s4-fwd.asc"
%so we would have filebasename of "hBN_ET_50K_%g_00%d" where %g is freq, %d
%is 002,003, etc.
%s4 is suffix, fwd is dir, asc is extension
%default for this one is asc

%read in the header which is in the first few lines to get the resolution
%and then the header is a constant number so skip to next ones

%filepath=folder;%delete this 
%disp(filepath);

if exist('extension','var')
    filepath = strcat(folder, "\", filebasename, "-", suffix, "-", dir, ".",extension);
else
    
    filepath = strcat(folder, "\", filebasename, "-", suffix, "-", dir, ".asc");
end
disp(filepath)

% Open the file
file_ID = fopen(filepath,'r','l');

%skip everything until the last '=' and then place the cursor back
% well need to modify this bc .gsf uses '=' and .asc as output uses ':'
% just put an "if" depending on extension
flag=1;
line=0;
lineend=fgets(file_ID);
%throwaway=fgetl(file_ID);
while flag > 0
    bytesprev=ftell(file_ID);
    throwaway=fgetl(file_ID);
    flag=strfind(throwaway,':');
    line=line+1;
    
    if (strfind(throwaway, 'x-pixels:'))>0
        idx=strfind(throwaway,':');
        xres=str2num(throwaway(idx+1:end));
    elseif (strfind(throwaway, 'y-pixels:'))>0
        idx=strfind(throwaway,':');
        yres=str2num(throwaway(idx+1:end));
    elseif (strfind(throwaway, 'x-length:'))>0
        idx=strfind(throwaway,':');
        xext=str2num(throwaway(idx+1:end));
    elseif (strfind(throwaway, 'y-length:'))>0
        idx=strfind(throwaway,':');
        yext=str2num(throwaway(idx+1:end));
    end
    
end
%return to the start of the previous line

% set x/y axis
dx=xext/xres;
dy=yext/yres;

x = (dx:dx:xext)';
y = (dy:dy:yext)';
%'line' should be the number of lines to be skipped
rawdata=readmatrix(filepath,'NumHeaderLines',line,'FileType','text');
im_data=reshape(rawdata,xres,yres)';


fclose('all');