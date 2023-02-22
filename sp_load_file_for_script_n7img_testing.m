function [im_data, x, y,extra] = sp_load_file_for_script_n7img(folder, filebasename, suffix)

filepath = strcat(folder, "\", filebasename, " ", suffix, ".gsf");
%filepath="D:\Github\ET_hBN\DataFiles\220107\Area A rotated\ET_hBN_1390_A_1 O3A.gsf";
%disp(filepath)
fclose('all');

% Open the file
file_ID = fopen(filepath,'r','l');

%skip everything until the last '=' and then place the cursor back
flag=1;
line=0;
lineend=fgets(file_ID);
%throwaway=fgetl(file_ID);
while flag > 0
    bytesprev=ftell(file_ID);
    throwaway=fgetl(file_ID)
    flag=strfind(throwaway,' = ');
    line=line+1;
    
    if (strfind(throwaway, 'XRes ='))>0
        idx=strfind(throwaway,'=');
        xres=str2num(throwaway(idx+1:end));
    elseif (strfind(throwaway, 'YRes ='))>0
        idx=strfind(throwaway,'=');
        yres=str2num(throwaway(idx+1:end));
    elseif (strfind(throwaway, 'XReal ='))>0
        idx=strfind(throwaway,'=');
        xext=str2num(throwaway(idx+1:end));
    elseif (strfind(throwaway, 'YReal ='))>0
        idx=strfind(throwaway,'=');
        yext=str2num(throwaway(idx+1:end));
    end
    
end
%return to the start of the previous line

% set x/y axis
dx=xext/xres;
dy=yext/yres;

x = (dx:dx:xext)';
y = (dy:dy:yext)';
im_data=zeros(xres,yres);
%im_data=zeros(size(x,2),size(y,2));

% Now use ftell to find the exact position of the end of the header
header_end = bytesprev

% Skip any missing bits
if(sum(ismember(throwaway, char([13])))==0)
    sum(ismember(throwaway, char([10])))
    header_end_real = ceil(header_end/4)*4 %because of CRLF issues... 
    if mod(header_end,4)==0
        header_end_real=header_end_real+4;
    end
    
else
    sum(ismember(throwaway, char([10])))
    header_end_real = ceil(header_end/8)*8 %this works for CRLF i guess
end

% Now skip the correct number of bytes
bytesToSkip = int32(header_end_real)
fseek(file_ID, bytesToSkip, 'bof');

% % Now, additionally, skip past (sliceNumber - 1) slices
% % so that we end up at the beginning byte of the slice that we want.
% bytesToSkip = bytesToSkip + int32(x_size * y_size *
% stHeader.BytesPerVoxel * (sliceNumber - 1));
% fseek(fileHandle, bytesToSkip, 'bof');

im_data = fread(file_ID,[xres,yres],'float32','l');
im_data = im_data';

extra=[xres,yres,xext,yext];

fclose('all');