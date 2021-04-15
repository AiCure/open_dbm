
clear

scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

load('results/ceclm_errors.mat');
[error_x, error_y] = cummErrorCurve(ceclm_error_66_cat_1);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM', 'LineWidth',line_width);

load('results/cfss_errors.mat');
[error_x, error_y] = cummErrorCurve(cfss_error_66_cat_1);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);

load('results/clnf_errors.mat');
[error_x, error_y] = cummErrorCurve(clnf_error_66_cat_1);
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

load('results/cfan_errors.mat');
[error_x, error_y] = cummErrorCurve(cfan_error_66_cat_1);
plot(error_x, error_y, 'DisplayName', 'CFAN', 'LineWidth',line_width);

load('results/iccr_errors.mat');
[error_x, error_y] = cummErrorCurve(iccr_error_66_cat_1);
plot(error_x, error_y, 'DisplayName', 'iCCR', 'LineWidth',line_width);

% Make it look nice and print to a pdf
set(gca,'xtick',[0.01:0.01:0.08])
xlim([0.01,0.08]);
xlabel('IOD normalized MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
ax=legend('show', 'Location', 'SouthEast');
ax.FontSize = 50;

% Make sure CE-CLM is drawn on top
[error_x, error_y] = cummErrorCurve(ceclm_error_66_cat_1);
plot(error_x, error_y, 'r', 'LineWidth',line_width);

print -dpdf results/300VWres_66_cat1.pdf

%%
clear

scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

load('results/ceclm_errors.mat');
[error_x, error_y] = cummErrorCurve(ceclm_error_66_cat_2);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM', 'LineWidth',line_width);

load('results/cfss_errors.mat');
[error_x, error_y] = cummErrorCurve(cfss_error_66_cat_2);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);

load('results/clnf_errors.mat');
[error_x, error_y] = cummErrorCurve(clnf_error_66_cat_2);
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

load('results/cfan_errors.mat');
[error_x, error_y] = cummErrorCurve(cfan_error_66_cat_2);
plot(error_x, error_y, 'DisplayName', 'CFAN', 'LineWidth',line_width);

load('results/iccr_errors.mat');
[error_x, error_y] = cummErrorCurve(iccr_error_66_cat_2);
plot(error_x, error_y, 'DisplayName', 'iCCR', 'LineWidth',line_width);

% Make it look nice and print to a pdf
set(gca,'xtick',[0.01:0.01:0.08])
xlim([0.01,0.08]);
xlabel('IOD normalized MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
ax=legend('show', 'Location', 'SouthEast');
ax.FontSize = 50;

% Make sure CE-CLM is drawn on top
[error_x, error_y] = cummErrorCurve(ceclm_error_66_cat_2);
plot(error_x, error_y, 'r', 'LineWidth',line_width);

print -dpdf results/300VWres_66_cat2.pdf

%%
clear

scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

load('results/ceclm_errors.mat');
[error_x, error_y] = cummErrorCurve(ceclm_error_66_cat_3);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM', 'LineWidth',line_width);

load('results/cfss_errors.mat');
[error_x, error_y] = cummErrorCurve(cfss_error_66_cat_3);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);

load('results/clnf_errors.mat');
[error_x, error_y] = cummErrorCurve(clnf_error_66_cat_3);
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

load('results/cfan_errors.mat');
[error_x, error_y] = cummErrorCurve(cfan_error_66_cat_3);
plot(error_x, error_y, 'DisplayName', 'CFAN', 'LineWidth',line_width);

load('results/iccr_errors.mat');
[error_x, error_y] = cummErrorCurve(iccr_error_66_cat_3);
plot(error_x, error_y, 'DisplayName', 'iCCR', 'LineWidth',line_width);

% Make it look nice and print to a pdf
set(gca,'xtick',[0.01:0.01:0.08])
xlim([0.01,0.08]);
xlabel('IOD normalized MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
ax=legend('show', 'Location', 'SouthEast');
ax.FontSize = 50;

% Make sure CE-CLM is drawn on top
[error_x, error_y] = cummErrorCurve(ceclm_error_66_cat_3);
plot(error_x, error_y, 'r', 'LineWidth',line_width);

print -dpdf results/300VWres_66_cat3.pdf
