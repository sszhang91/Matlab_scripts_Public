function [r, lc] = sp_linecuts(X, Y, data, lc_x, lc_y, lc_wid, interp_factor, interp_method)
% Wrapper function for sp_linecut that can process multiple images with a
% single call. Also interpolates the data before passing it on to
% sp_linecut.

% Input:
% X, Y - cell arrays of the X and Y coordinates. If a single matrix is
% passed, assume that the same X and Y apply to all of the data.
%
% data - cell array of data
%
% lc_x, lc_y - cell arrays of the x and y limits of the linecuts.
% If matrices are passed, assume that the same linecut limits apply to all
% of the images. Passed directly to sp_linecut.m
%
% lc_wid - width of the linecut. Passed directly to sp_linecut.m
%
% interp_factor - interpolate and scale the data up by the given using the
% interp method

if nargin == 6
    interp_factor = 1;
    interp_method = 'linear';
elseif nargin == 7
    interp_method = 'linear';
end

assert(iscell(data), 'Use sp_linecut for a single image');

for j = 1:length(data)
    if iscell(X)
        x_old = X{j}; y_old = Y{j};
    else
        x_old = X; y_old = Y;
    end

    if interp_factor > 1
        % With scaling
        if numel(x_old) == size(x_old, 1) * size(x_old, 2)
            % 1D X
            [X_, Y_] = meshgrid(interp(x_old, interp_factor), interp(y_old, interp_factor));
        else
            % 2D X and Y
            [X_, Y_] = meshgrid(interp(x_old(1, :), interp_factor), interp(y_old(:, 1), interp_factor));
        end
        
        data_ = interp2(x_old, y_old, data{j}, X_, Y_, interp_method);
    else
        % No scaling
        X_ = x_old; Y_ = y_old;
        data_ = data{j};
    end
    
    if iscell(lc_x)
        [r{j}, lc{j}] = sp_linecut(X_, Y_, data_, lc_x{j}, lc_y{j}, lc_wid);
    else
        [r{j}, lc{j}] = sp_linecut(X_, Y_, data_, lc_x, lc_y, lc_wid);
    end
    
end

end