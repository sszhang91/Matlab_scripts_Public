function [lc_x, lc_y, lc_perp_x, lc_perp_y] = sp_lc_center_theta_to_xy(lc_center, lc_theta, lc_length)
% Function that converts the center and angle of a linecut to the x and y
% limits

for j = 1:length(lc_theta)
    lc_x{j} = [lc_center(j, 1) - lc_length*cosd(lc_theta(j)), lc_center(j, 1) + lc_length*cosd(lc_theta(j))];
    lc_y{j} = [lc_center(j, 2) - lc_length*sind(lc_theta(j)), lc_center(j, 2) + lc_length*sind(lc_theta(j))];
    
    lc_perp_x{j} = [lc_center(j, 1) - lc_length*cosd(lc_theta(j) + 90), lc_center(j, 1) + lc_length*cosd(lc_theta(j) + 90)];
    lc_perp_y{j} = [lc_center(j, 2) - lc_length*sind(lc_theta(j) + 90), lc_center(j, 2) + lc_length*sind(lc_theta(j) + 90)];
end

end