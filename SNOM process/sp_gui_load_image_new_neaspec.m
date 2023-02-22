function [x, y, im_data,xres,yres,xext,yext] = sp_gui_load_image_new_neaspec(folder,prefix,dimensions)

    
% % load names of files in directory
% files = dir(...
%     [folder '/' folder '*.ascii']);

% give error if no files are found
if ~exist(folder,'dir')
    error('No files with specified base name in specified directory.')
end

% folder
idx = strfind(folder,'/20');
filebasename = folder(idx+1:end);

filepath = [folder '/' filebasename ' ' prefix{1} '.gsf'];

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

% lines 4 and 5 give x and y offsets, which we will not use.
line4 = fgets(file_ID);line5 = fgets(file_ID);

% find x extent in image
line6 = fgets(file_ID);
xeidx=strfind(line6, '=');
xext=str2num(line6(xeidx+1:end));

% find y extent in image
line7 = fgets(file_ID);
yeidx=strfind(line7, '=');
yext=str2num(line7(xeidx+1:end));

% set x/y axis
dx=xext/xres;
dy=yext/yres;

x = dx:dx:xext;
y = dy:dy:yext;

im_data=zeros(size(x,2),size(y,2));

fclose('all');

if size(prefix,2) == 2
    for i=1:2
        filepath = [folder '/' filebasename ' ' prefix{i} '.gsf'];
        
        % Open the file
        file_ID = fopen(filepath,'r','l');
        
        % Skip past header of stHeader.HeaderSize bytes.
        bytesToSkip = int32(144);
        fseek(file_ID, bytesToSkip, 'bof');
        
        % % Now, additionally, skip past (sliceNumber - 1) slices
        % % so that we end up at the beginning byte of the slice that we want.
        % bytesToSkip = bytesToSkip + int32(x_size * y_size *
        % stHeader.BytesPerVoxel * (sliceNumber - 1));
        % fseek(fileHandle, bytesToSkip, 'bof');
        
        im_data_p=im_data;
        
        im_data = fread(file_ID,[xres,yres],'float32','l');
     
        fclose('all');
    end
    
    im_data=im_data+im_data_p;
    
else
    
    filepath = [folder '/' filebasename ' ' prefix{1} '.gsf'];
    
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
    
    % lines 4 and 5 give x and y offsets, which we will not use.
    line4 = fgets(file_ID);line5 = fgets(file_ID);
    
    % find x extent in image
    line6 = fgets(file_ID);
    xeidx=strfind(line6, '=');
    xext=str2num(line6(xeidx+1:end));
    
    % find y extent in image
    line7 = fgets(file_ID);
    yeidx=strfind(line7, '=');
    yext=str2num(line7(xeidx+1:end));
    
    % set x/y axis
    dx=xext/xres;
    dy=yext/yres;
    
    x = dx:dx:xext;
    y = dy:dy:yext;
    
    % Skip past header of stHeader.HeaderSize bytes.
    bytesToSkip = int32(144);
    fseek(file_ID, bytesToSkip, 'bof');
    
    % % Now, additionally, skip past (sliceNumber - 1) slices
    % % so that we end up at the beginning byte of the slice that we want.
    % bytesToSkip = bytesToSkip + int32(x_size * y_size *
    % stHeader.BytesPerVoxel * (sliceNumber - 1));
    % fseek(fileHandle, bytesToSkip, 'bof');
    
    im_data = fread(file_ID,[xres,yres],'float32','l');
    
end

% im_data = importdata(filepath);

s = [xres,yres];
ref = imref2d(s);
ref.XWorldLimits = [0 xext];
ref.YWorldLimits = [0 yext];

dx = ref.PixelExtentInWorldX;
dy = ref.PixelExtentInWorldY;

x = dx/2:dx:(s(2)-1/2)*dx;
%             x = 0:dimensions(1)/size(data_scratch,2):dimensions(1);
%             x = x(1:end-1);

y = dy/2:dx:(s(1)-1/2)*dy;
%             y = 0:dimensions(2)/size(data_scratch,1):dimensions(2);
%             y = y(1:end-1);
fclose('all');
end