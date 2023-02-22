function [im_data, x, y,dim_out] = sp_load_file_for_script_n7img(folder, filename, suffix,setnum)

    
if exist('setnum','var')
    set=num2str(setnum);
    filepath = strcat(folder, "\", filename, " ", suffix, "_",set, ".gsf");
    %filepath = strcat(folder, "\", filename, suffix, "_",set, ".gsf");
else
    filepath = strcat(folder, "\", filename, " ", suffix, ".gsf");
    %filepath = strcat(folder, "\", filename, suffix, ".gsf");
end

disp(filepath)
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
    throwaway=fgetl(file_ID);
    flag=contains(throwaway,[" =", "=","= "]);
    line=line+1;
    
    if contains(throwaway,["XRes =", "XRes="])
        idx=strfind(throwaway,'=');
        xres=str2num(throwaway(idx+1:end));
    elseif contains(throwaway,["YRes =", "YRes="])
        idx=strfind(throwaway,'=');
        yres=str2num(throwaway(idx+1:end));
    elseif contains(throwaway,["XReal =", "XReal="])
        idx=strfind(throwaway,'=');
        xext=str2num(throwaway(idx+1:end));
    elseif contains(throwaway,["YReal =", "YReal="])
        idx=strfind(throwaway,'=');
        yext=str2num(throwaway(idx+1:end));
    elseif contains(throwaway,["@","€","¥","Þ","ƒ","~","«","?",">","÷","µ","ñ","å","™","Ú","ô","•",";",")","©"])
        %disp(throwaway);
        flag=-1;
%         if contains(suffix,"edge")
%             disp(line);
%         end
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
header_end = bytesprev;

% Skip any missing bits
if(sum(ismember(throwaway, char([13])))==0)
    header_end_real = ceil(header_end/4)*4; %because of CRLF issues... 
    if mod(header_end,4)==0
        header_end_real=header_end_real+4;
    end
else
    header_end_real = ceil(header_end/8)*8 ;%this works for CRLF i guess
end

% Now skip the correct number of bytes
bytesToSkip = int32(header_end_real);
fseek(file_ID, bytesToSkip, 'bof');

% % Now, additionally, skip past (sliceNumber - 1) slices
% % so that we end up at the beginning byte of the slice that we want.
% bytesToSkip = bytesToSkip + int32(x_size * y_size *
% stHeader.BytesPerVoxel * (sliceNumber - 1));
% fseek(fileHandle, bytesToSkip, 'bof');

im_data = fread(file_ID,[xres,yres],'float32','l');
im_data = im_data';

dim_out=[xext, yext];

fclose('all');