function [im_data, x, y] = sp_load_file_for_script_ac_gwy(folder, filename)
% Function for loading ascii data saved by Gwyddion

sep = ':';      % Sometimes this has to be changed to '='

filepath = strcat(folder, '\', filename, '.asc');
fid = fopen(filepath, 'r');

% Skip the first three lines
line1 = fgetl(fid);
line2 = fgetl(fid);
line3 = fgetl(fid);

% Find xRes
line4 = fgetl(fid);
xres = str2double(line4(strfind(line4,sep)+1:end));

% Find yRes
line5 = fgetl(fid);
yres = str2double(line5(strfind(line5,sep)+1:end));

% Find xExt
line6 = fgetl(fid);
xext = str2double(line6(strfind(line6,sep)+1:end));

% Find yExt
line7 = fgetl(fid);
yext = str2double(line7(strfind(line7,sep)+1:end));

% Define x and y arrays
dx=xext/xres;
dy=yext/yres;

x = linspace(dx/2, xext-dx/2, xres);
y = linspace(dy/2, yext-dy/2, yres);

% Read the rest of the header even though it's not useful
line8 = fgetl(fid); line9 = fgetl(fid); line10 = fgetl(fid);
line11 = fgetl(fid); line12 = fgetl(fid);
line13 = fgetl(fid); line14 = fgetl(fid);       %  OPTIONAL?

fclose(fid);

data = importdata(filepath, '\n', 15);
data = data.data;

% data = zeros(length(y), length(x));
% cur_y = 1;
% while ~feof(fid)
%     line = fgetl(fid);
%     line_list = split(line);
%     data(cur_y, :) = str2double(line_list)';
%     cur_y = cur_y + 1;
% end
% 
% data = zeros(length(y)*length(x), 1);
% cur_y = 1;
% while ~feof(fid)
%     data(cur_y, :) = str2double(fgetl(fid))';
%     cur_y = cur_y + 1;
% end




% im_data = data;

im_data = reshape(data, [length(y), length(x)]);

end



