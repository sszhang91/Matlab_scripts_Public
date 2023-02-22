function im_data_level = sp_polybg_level_add(x,y,im_data,order,exclude)

if nargin == 4
    exclude = zeros(size(im_data));
end

if length(order) == 1
    order = [order, order];
end

[xData, yData, zData, exc] = prepareSurfaceData(x, y, im_data, exclude);

ft = fittype(['poly', num2str(order(1)), num2str(order(2))]);

% Fit model to data.
[fitresult, ~] = fit( [xData, yData], zData, ft, 'Normalize', 'on', 'Exclude', exc);

[x,y] = meshgrid(x,y);
fitresult_matrix = feval(fitresult,x,y);

im_data_level = im_data - fitresult_matrix;