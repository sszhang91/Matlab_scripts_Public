function [r,c] = sp_linecut(x,y,im_data,cut_x,cut_y,width,plotornot)
if nargin == 6
    plotornot = 0;
end

assert(width>0, 'Width must be greater than zero');

% x, y, cut_x, cut_y, and width have dimensions of physical length, not
% pixels

% calculate length of cut
l = sqrt(diff(cut_x)^2 + diff(cut_y)^2);

% set resolution
sz_x = size(x);
if sz_x(1) == 1 || sz_x(2) == 1
    dl = min(abs(x(1) - x(2)),abs(y(1) - y(2)));
else
    dl = min(abs(x(1, 2) - x(1, 1)),abs(y(1, 1) - y(2, 1)));
end


% set number of points in cut so that spatial resolution is the same of
% that of image
n = ceil(l/dl) + 1;
% n = 2*n;

if width > 0
    
    % find slope of line perpendicular to cut path
    if cut_x(1) == cut_x(2)
        
        m = 0;
        
    elseif cut_y(1) == cut_y(2)
        
        m = Inf;
        
    else
        
        p = polyfit(cut_x,cut_y,1);
        m = tand(atand(p(1)) + 90);
        
    end
    
    % make lines centered at cut path endpoints with length "width"
    [x1,y1] = sp_makecutpath(cut_x(1),cut_y(1),m,width/2,width/2);
    [x2,y2] = sp_makecutpath(cut_x(2),cut_y(2),m,width/2,width/2);

    % increase spatial resolution along width to match that of image
    n_pts = ceil(width/dl) + 1;
    if x1(1) == x1(2)
        
        x1 = x1(1)*ones(1,n_pts);
        y1 = linspace(y1(1),y1(2),n_pts);
        x2 = x2(1)*ones(1,n_pts);
        y2 = linspace(y2(1),y2(2),n_pts);
        
    elseif y1(1) == y1(2)
        
        y1 = y1(1)*ones(1,n_pts);
        x1 = linspace(x1(1),x1(2),n_pts);
        y2 = y2(1)*ones(1,n_pts);
        x2 = linspace(x2(1),x2(2),n_pts);
        
    else
        
        p1 = polyfit(x1,y1,1);
        p2 = polyfit(x2,y2,1);
        
        x1 = linspace(x1(1),x1(2),n_pts);
        x2 = linspace(x2(1),x2(2),n_pts);
        
        y1 = polyval(p1,x1);
        y2 = polyval(p2,x2);
        
    end
    
    % make sure averaging width does not extend beyond image boundary
    if find(x1 > max(max(x)),1)
        
        x1 = x1((x1 < max(max(x))));
        x2 = x2((x1 < max(max(x))));
        y1 = y1((x1 < max(max(x))));
        y2 = y2((x1 < max(max(x))));
        
    elseif find(x1 < min(min(x)),1)
        
        x1 = x1((x1 > min(min(x))));
        x2 = x2((x1 > min(min(x))));
        y1 = y1((x1 > min(min(x))));
        y2 = y2((x1 > min(min(x))));
        
    elseif find(x2 > max(max(x)),1)
        
        x1 = x1((x2 < max(max(x))));
        x2 = x2((x2 < max(max(x))));
        y1 = y1((x2 < max(max(x))));
        y2 = y2((x2 < max(max(x))));
        
    elseif find(x2 < min(min(x)),1)
        
        x1 = x1((x2 > min(min(x))));
        x2 = x2((x2 > min(min(x))));
        y1 = y1((x2 > min(min(x))));
        y2 = y2((x2 > min(min(x))));
        
    elseif find(y1 > max(max(y)),1)
        
        x1 = x1((y1 < max(max(y))));
        x2 = x2((y1 < max(max(y))));
        y1 = y1((y1 < max(max(y))));
        y2 = y2((y1 < max(max(y))));
        
    elseif find(y1 < min(min(y)),1)
        
        x1 = x1((y1 > min(min(y))));
        x2 = x2((y1 > min(min(y))));
        y1 = y1((y1 > min(min(y))));
        y2 = y2((y1 > min(min(y))));
        
    elseif find(y2 > max(max(y)),1)
        
        x1 = x1((y2 < max(max(y))));
        x2 = x2((y2 < max(max(y))));
        y1 = y1((y2 < max(max(y))));
        y2 = y2((y2 < max(max(y))));
        
    elseif find(y2 < min(min(y)),1)
        
        x1 = x1((y2 > min(min(y))));
        x2 = x2((y2 > min(min(y))));
        y1 = y1((y2 > min(min(y))));
        y2 = y2((y2 > min(min(y))));
        
    end
    
    % average over line profiles across width
    c = 0;
    
    for j = 1:length(x1)
        
        c = c + improfile(x,y,im_data,[x1(j),x2(j)],[y1(j),y2(j)],...
            n,'bicubic');
        
        if ~find(isnan(c))
            
            fprintf('j = %i\n',j)
            
        end
        
    end

    c = c/length(x1);
    
else
    
    c = improfile(x,y,im_data,cut_x,cut_y,n,'bicubic');

end

% calculate cut path length
r = linspace(0,sqrt(diff(cut_x)^2 + diff(cut_y)^2),length(c));
r = r';

% plot
if plotornot
    
    RI = imref2d(size(im_data));
    RI.XWorldLimits = [min(min(x)) max(max(x))];
    RI.YWorldLimits = [min(min(y)) max(max(y))];

    figure
    imshow(im_data,RI)
    set(gca,'fontsize',16)
    axis tight
    axis equal
    colormap parula
    colorbar
    hold on
    plot(cut_x,cut_y,'g','linewidth',1.5)
    plot(x1,y1,'g')
    plot(x2,y2,'g')
    for j = 1:length(x1)
        plot([x1(j) x2(j)],[y1(j) y2(j)],'w','linewidth',1.5)
    end
    hold off
    
end

