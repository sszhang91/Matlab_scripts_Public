%% Load data
basefolder = 'C:\Users\Sai\Documents\SpiderOak Hive\Work\Experimental Data\Dorri twisted bilayer photocurrent\session 20190813 cryoSNOM\2019.08.13 - Dorri and Sai -TBLG';
scan_nums = [88:97, 3:7, 11, 12];
freqs = [1330, 1590, 1550, 1600, 1610.5, 1619, 1631.5, 1640, 1581, 1561, 1550, 1529.5, 1509.5, 1490.5, 1353.5, 1522, 1408];

% Sort by frequency and index accordingly
freqs_sorted = sort(freqs);
for j = 1:length(freqs)
    [~, min_idx] = min(abs(freqs-freqs_sorted(j)));
    scan_nums_sorted(j) = scan_nums(min_idx);
end
scan_nums = scan_nums_sorted;
freqs = freqs_sorted;

% scan_nums = 6;
% freqs = 1490.5;

for j = 1:length(freqs)
    [P2X, x{j}, y{j}] = sp_load_file_for_script_ac_gwy(basefolder, sprintf('SC_%03d-PhotoCurrent X2-bwd', scan_nums(j)));
    [P2Y, ~, ~] = sp_load_file_for_script_ac_gwy(basefolder, sprintf('SC_%03d-PhotoCurrent Y2-bwd', scan_nums(j)));
    [P2_i, P2_o, ~] = autophase_XY(P2X, P2Y);
    
    P2_in{j} = rot90(P2_i); P2_in_grad{j} = gradient(P2_in{j});
    P2_out{j} = rot90(P2_o); P2_out_grad{j} = gradient(P2_out{j});
    
    fprintf('.');
end
fprintf('\n');

load_colormaps;
colors = distinguishable_colors(20);

% Plot limits for frequencies other than 1330cm1
y_crop_min = 1; y_crop_max = length(y{2});
x_crop_min = 20; x_crop_max = 120;

% Plot aspect for frequencies other than 1330cm1
dx = x{j}(x_crop_max) - x{j}(x_crop_min);
dy = y{j}(y_crop_max) - y{j}(y_crop_min);
pbaspect_fig = [1 dy/dx 1];

%% Plot everything
figure_maximized;
for j = 1:length(freqs)
    subplot(3, 6, j);
    if j == 1
        pcolor(x{j}, y{j}, P2_in{j});
        pbaspect([1 1 1]);
        
        min_PC = min(min(P2_in{j}));
        max_PC = max(max(P2_in{j}));
    else
        pcolor(x{j}(x_crop_min:x_crop_max), y{j}(y_crop_min:y_crop_max), P2_in{j}(y_crop_min:y_crop_max, x_crop_min:x_crop_max));        
        pbaspect(pbaspect_fig);
        
        min_PC = min(min(P2_in{j}(:, x_crop_min:x_crop_max)));
        max_PC = max(max(P2_in{j}(:, x_crop_min:x_crop_max)));
    end
    
    clim_max = max([abs(min_PC), abs(max_PC)]);
    %     caxis([-clim_max, clim_max]);
    
    if j == 1
        line([0.7, 1.2]*1E-6, [0.3, 0.3]*1E-6, [100, 100], 'LineWidth', 3, 'Color', [0, 0, 0]);
    elseif j == length(freqs)
        line([1.2, 2.2]*1E-6, [0.3, 0.3]*1E-6, [100, 100], 'LineWidth', 3, 'Color', [0, 0, 0]);
    end
    
    shading interp; axis off;
    title(freqs(j));
    colormap(bwr);
    colorbar;
end
fig_font_size(15);
% saveas(gcf, 'FigS_MIRCat_full_freq_dep.png');


%% Plot everything - gradient
x_crop_min = 20; x_crop_max = 120;

figure_maximized;
for j = 1:length(freqs)
    subplot(3, 6, j);
    if j == 1
        pcolor(x{j}, y{j}, gradient(P2_in{j}));
        pbaspect([1 1 1]);
    else
        pcolor(x{j}(x_crop_min:x_crop_max), y{j}, P2_in_grad{j}(:, x_crop_min:x_crop_max));
        pbaspect(pbaspect_fig);
    end
    shading interp; axis off;
    title(sprintf('%gcm-1', freqs(j)));
    colormap(cgwy);
    colorbar;
    
    if j == 1
        line([0.7, 1.2]*1E-6, [0.3, 0.3]*1E-6, [100, 100], 'LineWidth', 3, 'Color', [1, 1, 1]);
    elseif j == length(freqs)
        line([1.2, 2.2]*1E-6, [0.3, 0.3]*1E-6, [100, 100], 'LineWidth', 3, 'Color', [1, 1, 1]);
    end
end
c = colorbar; ylabel(c, 'dI_{PC}/dx');
fig_font_size(15);
% saveas(gcf, 'FigS_MIRCat_full_freq_dep_gradient.png');


%% Take lincuts for both photocurrent and gradient
% Frequencies to be plotted
% freqs_w_lc = [1,    7,      8,    11,   17  ];
% freqs =    [1330, 1529.5, 1550, 1581, 1640]

freqs_w_lc = [1,    4, 7,      8,    11,   17  ];

% Define linecut position and angle
lc_center(1, :) =  [0.664, 0.883];     lc_theta(1) = 9;
lc_center(2, :) =  [1.331, 1.752];     lc_theta(2) = -3;
lc_center(3, :) =  [1.231, 1.402];     lc_theta(3) = 2;
% lc_center(4, :) =  [1.231, 1.602];     lc_theta(4) = 5;
% lc_center(4, :) =  [1.190, 2.450];     lc_theta(4) = -8;
lc_center(4, :) =  [1.752, 1.752];     lc_theta(4) = -2;
lc_center(5, :) =  [1.231, 1.602];     lc_theta(5) = 2;
lc_center(6, :) =  [1.281, 1.402];     lc_theta(6) = 4;
lc_center(7, :) =  [1.331, 1.752];     lc_theta(7) = -3;
lc_center(8, :) =  [1.452, 1.732];     lc_theta(8) = -3;
lc_center(9, :) =  [1.452, 1.732];     lc_theta(9) = -3;
lc_center(10, :) = [1.452, 1.732];     lc_theta(10) = -3;
lc_center(11, :) = [1.412, 1.752];     lc_theta(11) = -3;
lc_center(12, :) = [1.252, 1.852];     lc_theta(12) = 10;
lc_center(13, :) = [1.552, 1.612];     lc_theta(13) = 3;
lc_center(14, :) = [1.452, 1.612];     lc_theta(14) = 2;
lc_center(15, :) = [1.452, 1.612];     lc_theta(15) = -3;
lc_center(16, :) = [1.452, 1.612];     lc_theta(16) = -3;
lc_center(17, :) = [1.412, 1.692];     lc_theta(17) = 3;

lc_center = lc_center * 1E-6;
lc_length = 0.4E-6;
[lc_x, lc_y, lc_perp_x, lc_perp_y] = sp_lc_center_theta_to_xy(lc_center, lc_theta, lc_length);

% Check the linecut position and angle
figure;
for j = 1:length(freqs)
    subplot(3, 6, j); hold on;
    
    if freqs(j) == 1
        pcolor(x{j}, y{j}, P2_in{j});
        pbaspect([1 1 1]);
    else
        pcolor(x{j}(x_crop_min:x_crop_max), y{j}, P2_in_grad{j}(:, x_crop_min:x_crop_max));
        dx = x{j}(x_crop_max) - x{j}(x_crop_min);
        dy = y{j}(end) - y{j}(1);
        pbaspect([1 dy/dx 1]);
    end
    shading interp; axis off;
    colormap(cgwy);
    line(lc_x{j}, lc_y{j}, 'LineWidth', 3);
    line(lc_perp_x{j}, lc_perp_y{j}, 'LineWidth', 1, 'LineStyle', '--');
    title(freqs(j));
end

%%
% Take linecuts
[r_lc, lc] = sp_linecuts(x, y, P2_in, lc_x, lc_y, 1E-7, 3);
[r_lc_grad, lc_grad] = sp_linecuts(x, y, P2_in_grad, lc_x, lc_y, 1E-7, 3, 'spline');
for j = 1:length(r_lc)
    r_lc{j} = r_lc{j} - lc_length;
    lc_grad{j} = lc_grad{j} / (max(lc_grad{j}) - min(lc_grad{j}));
    fprintf('.');
end
fprintf('\n');

% Find peaks in gradient of photocurrent
for j = 1:length(freqs)
    peak_locs{j} = islocalmax(lc_grad{j}, 'MaxNumExtrema', 2);
    spacing(j) = abs(diff(r_lc{j}(peak_locs{j})));
end


% Plot photocurrent
lc_plot_offs = zeros(size(freqs));
lc_plot_offs(1) = -0;
lc_plot_offs(7) = -0.4;
lc_plot_offs(8) = 0.1;
lc_plot_offs(11) = 0.6;
lc_plot_offs(17) = 1.17;

figure; hold on;
for j = 1:length(freqs_w_lc)
    span = max(lc{freqs_w_lc(j)}) - min(lc{freqs_w_lc(j)});
    lc_norm{freqs_w_lc(j)} = (lc{freqs_w_lc(j)})./span;
    
    plot(fliplr(r_lc{freqs_w_lc(j)}*1E9), lc_norm{freqs_w_lc(j)} + lc_plot_offs(freqs_w_lc(j)), '.', 'MarkerSize', 20, 'DisplayName', string(freqs(freqs_w_lc(j))), 'Color', colors(j + 3, :));
end
box on; xlim([-400, 400]); %ylim([-1.9, 1.5]); pbaspect([1 1 1]);
xlabel('Position / nm'); ylabel('I_{PC} / a.u.');
set(findall(gcf,'-property','FontSize'),'FontSize', 18);
legend show;

%% Plot gradient of photocurrent line profiles
lc_grad_offs = zeros(size(freqs));
lc_grad_offs(1) = 0;
lc_grad_offs(4) = 1.05;
lc_grad_offs(7) = 1.45;
lc_grad_offs(8) = 1.8;
lc_grad_offs(11) = 2.2;
lc_grad_offs(17) = 2.55;

figure; hold on;
for j = 1:length(freqs_w_lc)
    pks_x = r_lc_grad{freqs_w_lc(j)}(peak_locs{freqs_w_lc(j)}); x_offs = (pks_x(1) + pks_x(2)) * 1E9 / 2;
    plot(r_lc_grad{freqs_w_lc(j)} * 1E9 - x_offs, lc_grad{freqs_w_lc(j)} + lc_grad_offs(freqs_w_lc(j)), '-', 'LineWidth', 3, 'DisplayName', sprintf('%g cm^{-1}', freqs(freqs_w_lc(j))), 'Color', colors(j + 3, :));
    plot(r_lc_grad{freqs_w_lc(j)}(peak_locs{freqs_w_lc(j)}) * 1E9 - x_offs, lc_grad{freqs_w_lc(j)}(peak_locs{freqs_w_lc(j)}) + lc_grad_offs(freqs_w_lc(j)), '.', 'MarkerSize', 30, 'Color', colors(j + 3, :), 'HandleVisibility','off');
end
box on;
xlabel('Position / nm'); ylabel('d I_{PC}/dx / a.u.');
% legend show;
xticks([-300, 0, 300]);
xlim([-300, 300]); ylim([-0.5, 3.2]);
fig_font_size(20);


%% Plot the calculated curves from EigenProbe model (NEW v7 CURVES) and Point Dipole from Andrey Rikhter
basefolder = 'C:\Users\Sai\Documents\SpiderOak Hive\Work\Calculations\Shaowen TBG photocurrent E-field profiles';
freqs_fname = [1330, 1490, 1530, 1550, 1580, 1640];
plot_offs = 1.25;

% LRM
figure; hold on;
for j = 1:length(freqs_fname)
%     filename = sprintf('E_field_images_v7_BN_43.0nm_tip_rad_40_l_cool_100_harm_2_cond_factor_1_freq_%d_dPC_dx_profile.txt',  freqs_fname(j));
    filename = sprintf('E_field_images_v7_top_BN_7.0nm_total_BN_43.0nm_tip_rad_40_l_cool_100_harm_2_cond_factor_1_freq_%d_dPC_dx_profile.txt',  freqs_fname(j));
    tmp = importdata(strcat(basefolder, '\', filename));
    r_lc_grad_calc = tmp(:, 1); lc_grad_calc = tmp(:, 2) / max(tmp(:, 2));
    lc_grad_calc = lc_grad_calc / max(lc_grad_calc);
    
    % Find peaks
    peaks_calc = islocalmax(lc_grad_calc, 'MaxNumExtrema', 2);
    
    plot(r_lc_grad_calc, lc_grad_calc + plot_offs * (j - 1), 'Color', [colors(j + 3, :) 0.8], 'LineWidth', 3, 'DisplayName', sprintf('%g cm^{-1}', freqs_fname(j)));
    plot(r_lc_grad_calc(peaks_calc), lc_grad_calc(peaks_calc) + plot_offs * (j - 1), '.', 'Color', colors(j + 3, :), 'MarkerSize', 30, 'HandleVisibility', 'off');
end

% Point dipole
basefolder = 'C:\Users\Sai\Documents\SpiderOak Hive\Work\Calculations\Shaowen TBG photocurrent E-field profiles Andrey Rikhter';
for j = 1:length(freqs_fname)
    filename = sprintf('E_field_images_v8_AR_nmax_40_d_50nm_r_max_2000nm_ztip_125nm_freq_%d_dPC_dx_profile.txt',  freqs_fname(j));
%     disp(strcat(basefolder, '\', filename));
    tmp = importdata(strcat(basefolder, '\', filename));
    r_lc_grad_calc = tmp(:, 1); lc_grad_calc = tmp(:, 2) / max(tmp(:, 2));
    
    % Find peaks
    peaks_calc = islocalmax(lc_grad_calc, 'MaxNumExtrema', 2);
    
    plot(r_lc_grad_calc / 2, lc_grad_calc / max(lc_grad_calc) + plot_offs * (j - 1), '-.', 'Color', [colors(j + 3, :) 1], 'LineWidth', 2, 'DisplayName', sprintf('%g cm^{-1}', freqs_fname(j)));
%     plot(r_lc_grad_calc(peaks_calc), lc_grad_calc(peaks_calc) + plot_offs * j, '.', 'Color', colors(j + 3, :), 'MarkerSize', 30, 'HandleVisibility', 'off');
end

box on;
xlim([-300, 300]); ylim([-0.7, 7.5]);
xticks([-300, 0, 300]);
xlabel('Position / nm'); ylabel('d I_{PC}/dx / a.u.');
fig_font_size(20);
% legend show;


%% Fig 4 line profiles - NEW v7 CURVES
basefolder = 'C:\Users\Sai\Documents\SpiderOak Hive\Work\Calculations\Shaowen TBG photocurrent E-field profiles';
freqs_fname = [1490, 1530, 1640];
% freqs_fname = [1500, 1510, 1530, 1550, 1590, 1640];

figure; hold on;
for j = 1:length(freqs_fname)
%     filename = sprintf('E_field_images_v7_top_BN_7.0nm_total_BN_43.0nm_tip_rad_75_l_cool_100_harm_2_cond_factor_1_freq_%d_Er_hybrid.txt',  freqs_fname(j));
    filename = sprintf('E_field_images_v7_top_BN_7.0nm_total_BN_43.0nm_tip_rad_40_l_cool_100_harm_2_cond_factor_1_freq_%d_Er_hybrid.txt',  freqs_fname(j));
    disp(filename);
    tmp = importdata(strcat(basefolder, '\', filename));
    r_lc_Er = tmp(:, 1); lc_Er = tmp(:, 2) / max(tmp(:, 2));
    
    mid_idx = length(r_lc_Er) / 2;
    plot(r_lc_Er(1:mid_idx), lc_Er(1:mid_idx), '--', 'Color', colors(j + 6, :), 'LineWidth', 3, 'DisplayName', sprintf('%g cm^{-1}', freqs_fname(j)), 'HandleVisibility', 'off');
    plot(r_lc_Er(mid_idx:end), lc_Er(mid_idx:end), '-', 'Color', colors(j + 6, :), 'LineWidth', 3, 'DisplayName', sprintf('%g cm^{-1}', freqs_fname(j)));
end

xmax = 175;
box on;
xlim([-xmax, xmax]);
xticks([-xmax, 0, xmax]);
xlabel('Position / nm'); ylabel('E_{r} / a.u.');
fig_font_size(20);
% legend show;


figure; hold on;
for j = 1:length(freqs_fname)
%     filename = sprintf('E_field_images_v7_top_BN_7.0nm_total_BN_43.0nm_tip_rad_75_l_cool_100_harm_2_cond_factor_1_freq_%d_T.txt',  freqs_fname(j));
    filename = sprintf('E_field_images_v7_top_BN_7.0nm_total_BN_43.0nm_tip_rad_40_l_cool_100_harm_2_cond_factor_1_freq_%d_T.txt',  freqs_fname(j));
    tmp = importdata(strcat(basefolder, '\', filename));
    r_lc_Er = tmp(:, 1); lc_Er = tmp(:, 2) / max(tmp(:, 2));
    
    plot(r_lc_Er, lc_Er, '-', 'Color', colors(j + 6, :), 'LineWidth', 3, 'DisplayName', sprintf('%g cm^{-1}', freqs_fname(j)));
end

xmax = 250;
box on;
xlim([-xmax, xmax]); ylim([0.2, 1.05]);
xticks([-xmax, 0, xmax]);
xlabel('Position / nm'); ylabel('T / a.u.');
fig_font_size(20);
legend('location', 'south');



%% Fig 4 - hBN hyperlensing
% freqs_hyperlensing = [1330, 1490, 1530, 1740];
freqs_hyperlensing = [1330, 1510];
for j = 1:length(freqs_hyperlensing)
    hBN_hyperlensing_fields(freqs_hyperlensing(j));
    fprintf('.');
end
fprintf('\n');

%% FigS - scale factor
% Calculate the scale factor
wstart = 1300; wstop = 1650; wstep = 0.005;
freqs_interp = wstart:wstep:wstop;
h = hBN(wstart, wstep, wstop);
et = h.eps{1, 1}; ez = h.eps{3, 3};
scale = abs(real(et)) .^ (1/2);

% Plot the spacings that are valid
valid_spacing = ones(1, length(freqs)) * true;
valid_spacing([2, length(freqs) - 1, length(freqs) - 3, length(freqs) - 4]) = false;

figure; hold on;
% yyaxis left;
plot(freqs(valid_spacing == 1), spacing(valid_spacing == 1) * 1E9, '.', 'MarkerSize', 25);
ylabel('Peak spacing / nm');

% for j = 1:length(freqs_w_lc)
%     plot(freqs(freqs_w_lc(j)), spacing(freqs_w_lc(j)) * 1E9, '.', 'MarkerSize', 40, 'Color', colors(j + 3, :));
% end

% plot(freqs_interp, scale * 110, '-', 'LineWidth', 1);
% ylim([0, 400]);

% yyaxis right;
% plot(freqs_interp, scale, 'LineWidth', 2);
% xlabel('Frequency / cm^{-1}'); ylabel('$\sqrt{|Re(\epsilon_t)|}$', 'Interpreter', 'latex');
% xlim([1300, 1650]); pbaspect([1.25 1 1]);
% fig_font_size(18);
% ylim([50 / 110, 300 / 110]);
box on;




%% OLD POINT DIPOLE CURVES
% Plot the calculated curves from EigenProbe model
basefolder = 'C:\Users\Sai\Documents\SpiderOak Hive\Work\Calculations\Shaowen TBG photocurrent E-field profiles';
freqs_fname = [1330, 1530, 1550, 1580, 1640];

figure; hold on;
for j = 1:length(freqs_w_lc)
%     filename = sprintf('E_field_images_v5_BN_Caldwell_fixed_43nm_no_defect_freq_dep_N_400_Lx_100_Ly_100_Nq_3000_freq_%d_dPC_dx_profile.txt', freqs_fname(j));
%     filename = sprintf('E_field_images_v5_BN_Caldwell_low_damping_43nm_no_defect_freq_dep_N_400_Lx_100_Ly_100_Nq_3000_ztip_10_freq_%d_dPC_dx_profile.txt',  freqs_fname(j));
    filename = sprintf('E_field_images_v5_BN_Caldwell_blue_shift_43nm_no_defect_freq_dep_N_400_Lx_100_Ly_100_Nq_3000_ztip_10_freq_%d_dPC_dx_profile.txt',  freqs_fname(j));
    tmp = importdata(strcat(basefolder, '\', filename));
    r_lc_grad_calc = tmp(:, 1); lc_grad_calc = tmp(:, 2);
    
    % Find peaks
    peaks_calc = islocalmax(lc_grad_calc, 'MaxNumExtrema', 2);
    
    plot(r_lc_grad_calc, lc_grad_calc + 0.1 * j, 'Color', colors(j + 3, :), 'LineWidth', 3, 'DisplayName', sprintf('%g cm^{-1}', freqs_fname(j)));
    plot(r_lc_grad_calc(peaks_calc), lc_grad_calc(peaks_calc) + 0.1 * j, '.', 'Color', colors(j + 3, :), 'MarkerSize', 30, 'HandleVisibility', 'off');
end
box on;
xlim([-300, 300]);
xticks([-300, 0, 300]);
xlabel('Position / nm'); ylabel('d I_{PC}/dx / a.u.');
fig_font_size(20);
% legend show;

% OLD - NEWER POINT DIPOLE CURVES
load('C:\Users\Sai\Documents\SpiderOak Hive\Work\Papers\9 MLG-MLG photocurrent\point_dipole_dIdx_andrey.mat') % Emailed to me by Andrey Rikhter on 11/5/2020

for freq = freqs_fname
    eval(sprintf('dIdx_%d = dIdx_%d - min(dIdx_%d);', freq, freq, freq));
    eval(sprintf('dIdx_%d = dIdx_%d / max(dIdx_%d);', freq, freq, freq));
end

% figure; hold on;
for i = 1:length(freqs_fname)
    eval(sprintf("plot(xtip, dIdx_%d + 0.75 * i, '-.', 'Color', [colors(i + 3, :) 0.75], 'LineWidth', 2);", freqs_fname(i)));
end


%% OLD Fig 4 - hBN epsilon
freqs = 1000:0.5:2000;
hBN_eps = hBN(1000, 0.5, 2000);
hBN_eps = hBN_eps.eps_abc;
epsilon_t = hBN_eps{1, 1}; epsilon_z = hBN_eps{3, 3};

figure; hold on;
plot(freqs, real(epsilon_t), 'LineWidth', 3);
plot(freqs, real(epsilon_z), 'LineWidth', 3);
% plot(freqs, zeros(size(freqs)), 'k--', 'LineWidth', 0.5);
xlim([1100, 1800]); box on;
pbaspect([1.75 1 1]);
xlabel('Frequency / cm^{-1}'); ylabel('Re(\epsilon)');
fig_font_size(14);

