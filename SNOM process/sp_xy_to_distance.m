function [xi_dist, yi_dist] = sp_xy_to_distance(xi, yi, x, y)

% Function that returns the x and y coordinates of a point in distance
% units (physical length units) when given the points in pixels

% xi - List of x-coordinates in pixels
% yi - List of y-coordinates in pixels
% x - X vector for the image
% y - Y vector for the image

conv_factor_x = (x(end) - x(1))/length(x);
conv_factor_y = (y(end) - y(1))/length(y);

xi_dist = xi * conv_factor_x;
yi_dist = yi * conv_factor_y;

end