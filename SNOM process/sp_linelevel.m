function scan_level = sp_linelevel(im_data,width)

if nargin == 1
    width = [1 size(im_data, 2)];
end

% perform line leveling on image scan over horizontal section given by
% width (in pixels)

scan_norm = mean(im_data(:,width(1):width(2)),2);
scan_norm = scan_norm/median(scan_norm);
scan_norm = repmat(scan_norm,1,size(im_data,2));

scan_level = im_data./scan_norm;