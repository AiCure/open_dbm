%% 
clear;
Extract_table_results_68_cross_data;

%%

scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

[error_x, error_y] = cummErrorCurve(ceclm_error_frontal);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(clnf_error_frontal);
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfan_error_frontal);
plot(error_x, error_y, 'DisplayName', 'CFAN', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(error_3ddfa_frontal);
plot(error_x, error_y, 'DisplayName', '3DDFA', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfss_error_frontal);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);


[error_x, error_y] = cummErrorCurve(tcdcn_error_frontal);
plot(error_x, error_y, 'DisplayName', 'TCDCN', 'LineWidth',line_width);


set(gca,'xtick',[0:0.01:0.07])
xlim([0.01,0.07]);
xlabel('Size normalised MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
% title('Fitting on Menpo frontal images','FontSize',60,'FontName','Helvetica');


leg = legend('show', 'Location', 'SouthEast');
set(leg,'FontSize',50)

[error_x, error_y] = cummErrorCurve(ceclm_error_frontal);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM', 'LineWidth',line_width);

print -dpdf results/menpo-frontal_68.pdf
print -dpng results/menpo-frontal_68.png
%%

scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

[error_x, error_y] = cummErrorCurve(ceclm_error_profile);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(clnf_error_profile);
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfan_error_profile);
plot(error_x, error_y, 'DisplayName', 'CFAN', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(error_3ddfa_profile);
plot(error_x, error_y, 'DisplayName', '3DDFA', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfss_error_profile);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);


[error_x, error_y] = cummErrorCurve(tcdcn_error_profile);
plot(error_x, error_y, 'DisplayName', 'TCDCN', 'LineWidth',line_width);


set(gca,'xtick',[0.01:0.02:0.11])
xlim([0.03,0.11]);
xlabel('Size normalised MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
% title('Fitting on Menpo frontal images','FontSize',60,'FontName','Helvetica');

leg = legend('show', 'Location', 'SouthEast');
set(leg,'FontSize',50)

[error_x, error_y] = cummErrorCurve(ceclm_error_profile);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM', 'LineWidth',line_width);

print -dpdf results/menpo-profile_68.pdf
print -dpng results/menpo-profile_68.png