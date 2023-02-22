function [im_data, x, y] = sp_load_file_for_script_old(folder, filebasename, suffix)

filepath = strcat(folder, "\", filebasename, " ", suffix, " raw.gsf");
%disp(filepath)


% Open the file
file_ID = fopen(filepath,'r','l');

% C = textscan(file, '%c' ,'HeaderLines',9);

line1 = fgets(file_ID);

% find xRes
line2 = fgets(file_ID);
xidx=strfind(line2, '=');
xres=str2num(line2(xidx+1:end));

% find yRes
line3 = fgets(file_ID);
yidx=strfind(line3, '=');
yres=str2num(line3(yidx+1:end));

% lines 4, 5, 6, 7 and 8 give Neaspec info and x and y offsets, which we will not use.
line4 = fgets(file_ID); line5 = fgets(file_ID);
line6 = fgets(file_ID); line7 = fgets(file_ID);
line8 = fgets(file_ID);line9 = fgets(file_ID);
line10 = fgets(file_ID); 

% find x extent in image
line11 = fgets(file_ID);
xeidx=strfind(line11, '=');
xext=str2num(line11(xeidx+1:end));

% find y extent in image
line12 = fgets(file_ID);
yeidx=strfind(line12, '=');
yext=str2num(line12(xeidx+1:end));

% set x/y axis
dx=xext/xres;
dy=yext/yres;

x = (dx:dx:xext)';
y = (dy:dy:yext)';

im_data=zeros(size(x,2),size(y,2));

% Read the rest of the header even though it's not useful
line13 = fgets(file_ID); line14 = fgets(file_ID);
line15 = fgets(file_ID); line16 = fgets(file_ID);

% Now use ftell to find the exact position of the end of the header
header_end = ftell(file_ID);

% Skip any missing bits
header_end = ceil(header_end/8)*8;

% Now skip the correct number of bytes
bytesToSkip = int32(header_end);
fseek(file_ID, bytesToSkip, 'bof');

% % Now, additionally, skip past (sliceNumber - 1) slices
% % so that we end up at the beginning byte of the slice that we want.
% bytesToSkip = bytesToSkip + int32(x_size * y_size *
% stHeader.BytesPerVoxel * (sliceNumber - 1));
% fseek(fileHandle, bytesToSkip, 'bof');

im_data = fread(file_ID,[xres,yres],'float32','l');
im_data = im_data';

fclose('all');