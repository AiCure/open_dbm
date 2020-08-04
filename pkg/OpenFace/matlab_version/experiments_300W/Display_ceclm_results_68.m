clear

% First grab the numbers
Extract_table_results_68;

%% Visualize all the baselines on all 300W
scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

[error_x, error_y] = cummErrorCurve(cat(1, ceclm_error_comm, ceclm_error_ibug));
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM ', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cat(1, clnf_error_comm, clnf_error_ibug));
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cat(1, error_3ddfa_comm, error_3ddfa_ibug));
plot(error_x, error_y, 'DisplayName', '3DDFA', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cat(1, drmf_error_comm, drmf_error_ibug));
plot(error_x, error_y, 'DisplayName', 'DRMF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cat(1, cfss_error_comm, cfss_error_ibug));
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cat(1, tcdcn_error_comm, tcdcn_error_ibug));
plot(error_x, error_y, 'DisplayName', 'TCDCN', 'LineWidth',line_width);

set(gca,'xtick',[0:0.01:0.1])
xlim([0.01,0.07]);
xlabel('IOD normalised MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
% title('Fitting in the wild without outline','FontSize',60,'FontName','Helvetica');

leg = legend('show', 'Location', 'SouthEast');
set(leg,'FontSize',50)

% Make sure CE-CLM curve is on top
[error_x, error_y] = cummErrorCurve(cat(1, ceclm_error_comm, ceclm_error_ibug));
plot(error_x, error_y, 'r', 'LineWidth',line_width);

print -dpdf results/ceclm-300W-68.pdf
print -dpng results/ceclm-300W-68.png
%% Visualize all the baselines on difficult subset of 300W
scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

[error_x, error_y] = cummErrorCurve(ceclm_error_ibug);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM ', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(clnf_error_ibug);
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(error_3ddfa_ibug);
plot(error_x, error_y, 'DisplayName', '3DDFA', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(drmf_error_ibug);
plot(error_x, error_y, 'DisplayName', 'DRMF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfss_error_ibug);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(tcdcn_error_ibug);
plot(error_x, error_y, 'DisplayName', 'TCDCN', 'LineWidth',line_width);

set(gca,'xtick',[0:0.01:0.1])
xlim([0.02,0.09]);
xlabel('IOD normalised MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
% title('Fitting in the wild without outline','FontSize',60,'FontName','Helvetica');

leg = legend('show', 'Location', 'SouthEast');
set(leg,'FontSize',50)

% Make sure CE-CLM curve is on top
[error_x, error_y] = cummErrorCurve(ceclm_error_ibug);
plot(error_x, error_y, 'r', 'LineWidth',line_width);

print -dpdf results/ceclm-300W-ibug-68.pdf
print -dpng results/ceclm-300W-ibug-68.png

%% Visualize all the baselines on difficult subset of 300W
scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

line_width = 6;
hold on;

[error_x, error_y] = cummErrorCurve(ceclm_error_comm);
plot(error_x, error_y, 'r', 'DisplayName', 'CE-CLM ', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(clnf_error_comm);
plot(error_x, error_y, 'DisplayName', 'CLNF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(error_3ddfa_comm);
plot(error_x, error_y, 'DisplayName', '3DDFA', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(drmf_error_comm);
plot(error_x, error_y, 'DisplayName', 'DRMF', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfss_error_comm);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(tcdcn_error_comm);
plot(error_x, error_y, 'DisplayName', 'TCDCN', 'LineWidth',line_width);

set(gca,'xtick',[0:0.01:0.1])
xlim([0.01,0.07]);
xlabel('IOD normalised MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
% title('Fitting in the wild without outline','FontSize',60,'FontName','Helvetica');

leg = legend('show', 'Location', 'SouthEast');
set(leg,'FontSize',50)

% Make sure CE-CLM curve is on top
[error_x, error_y] = cummErrorCurve(ceclm_error_comm);
plot(error_x, error_y, 'r', 'LineWidth',line_width);

print -dpdf results/ceclm-300W-comm-68.pdf
print -dpng results/ceclm-300W-comm-68.png
