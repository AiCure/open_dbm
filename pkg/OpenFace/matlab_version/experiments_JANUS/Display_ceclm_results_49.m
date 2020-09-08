clear

Extract_table_results_49
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

[error_x, error_y] = cummErrorCurve(ceclm_error);
plot(error_x, error_y, 'r','DisplayName', 'OpenFace 2.0', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(clnf_error);
plot(error_x, error_y, 'DisplayName', 'OpenFace', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfss_error);
plot(error_x, error_y, 'DisplayName', 'CFSS', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(sdm_error);
plot(error_x, error_y, 'DisplayName', 'SDM', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(pocr_error);
plot(error_x, error_y,'DisplayName', 'PO-CR', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(cfan_error);
plot(error_x, error_y,'DisplayName', 'CFAN', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(tcdcn_error);
plot(error_x, error_y,'DisplayName', 'TCDCN', 'LineWidth',line_width);

[error_x, error_y] = cummErrorCurve(error_3ddfa);
plot(error_x, error_y,'DisplayName', '3DDFA', 'LineWidth',line_width);

set(gca,'xtick',[0:0.02:0.10])
xlim([0.02,0.10]);
xlabel('Size normalised MSE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
% title('Fitting in the wild without outline','FontSize',60,'FontName','Helvetica');

leg = legend('show', 'Location', 'SouthEast');
set(leg,'FontSize',40)

print -dpdf results/Janus-no-outline.pdf
print -dpng results/Janus-no-outline.png