clear
     
curr_dir = cd('.');

% Replace this with your downloaded 300-W train data
if(exist([getenv('USERPROFILE') '/Dropbox/AAM/test data/'], 'file'))
    database_root = [getenv('USERPROFILE') '/Dropbox/AAM/test data/'];    
elseif(exist('D:/Dropbox/Dropbox/AAM/test data/', 'file'))
    database_root = 'D:/Dropbox/Dropbox/AAM/test data/';
elseif(exist('F:/Dropbox/AAM/test data/', 'file'))
    database_root = 'F:/Dropbox/AAM/test data/';
elseif(exist('D:\Datasets\300W/', 'file'))
    database_root = 'D:\Datasets\300W/';
elseif(exist('/media/tadas/5E08AE0D08ADE3ED/Dropbox/AAM/test data/', 'file'))
    database_root = '/media/tadas/5E08AE0D08ADE3ED/Dropbox/AAM/test data/';
else
    fprintf('Dataset not found')
    return;
end

%% Run using CE-CLM model
out_ceclm = [curr_dir '/300W_experiments/out_ceclm/'];
[err_ceclm, err_no_out_ceclm] = Run_OF_on_images(out_ceclm, database_root, 'use_afw', 'use_lfpw', 'use_ibug', 'use_helen', 'verbose', 'model', 'model/main_ceclm_general.txt', 'multi_view', 1);

%% Run using CLNF in the wild model
out_clnf = [curr_dir '/300W_experiments/out_clnf/'];
[err_clnf, err_no_out_clnf] =Run_OF_on_images(out_clnf, database_root, 'use_afw', 'use_lfpw', 'use_ibug', 'use_helen', 'verbose', 'model', 'model/main_clnf_wild.txt', 'multi_view', 1);

%% Run using SVR model
out_svr = [curr_dir '/300W_experiments/out_svr/'];
[err_svr, err_no_out_svr] = Run_OF_on_images(out_svr, database_root, 'use_afw', 'use_lfpw', 'use_ibug', 'use_helen', 'verbose', 'model', 'model/main_clm_wild.txt', 'multi_view', 1);                

%%
save('results/landmark_detections.mat');

f = fopen('results/landmark_detections.txt', 'w');
fprintf(f, 'Type, mean, median\n');
fprintf(f, 'err ce-clm: %f, %f\n', mean(err_ceclm), median(err_ceclm));
fprintf(f, 'err clnf: %f, %f\n', mean(err_clnf), median(err_clnf));
fprintf(f, 'err svr: %f, %f\n', mean(err_svr), median(err_svr));

fclose(f);

%% Draw the corresponding error graphs comparing OpenFace methods with others

% set up the canvas
scrsz = get(0,'ScreenSize');
figure1 = figure('Position',[20 50 3*scrsz(3)/4 0.9*scrsz(4)]);

set(figure1,'Units','Inches');
pos = get(figure1,'Position');
set(figure1,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
line_width = 6;
hold on;

% Create axes
axes1 = axes('Parent',figure1,'FontSize',40,'FontName','Helvetica');

% load ce-clm errors
load('300W_experiments/out_ceclm/res.mat');

ceclm_error_cpp = compute_error( labels,  shapes);
[error_x, error_y] = cummErrorCurve(ceclm_error_cpp);
plot(error_x, error_y, 'r','DisplayName', 'OpenFace (CE-CLM)', 'LineWidth',line_width);
hold on;

% load clnf errors
load('300W_experiments/out_clnf/res.mat');
clnf_error_cpp = compute_error( labels,  shapes);
[error_x, error_y] = cummErrorCurve(clnf_error_cpp);
plot(error_x, error_y,  'DisplayName', 'OpenFace (CLNF)', 'LineWidth',line_width);
hold on;

% load svr errors
load('300W_experiments/out_svr/res.mat');
svr_error_cpp = compute_error( labels,  shapes);
[error_x, error_y] = cummErrorCurve(svr_error_cpp);
plot(error_x, error_y, 'b-.','DisplayName', 'OpenFace (CLM+)', 'LineWidth',line_width);

set(gca,'xtick',[0.02:0.01:0.1])
xlim([0.02,0.08]);
xlabel('IOD normalised MAE','FontName','Helvetica');
ylabel('Proportion of images','FontName','Helvetica');
grid on
leg = legend('show', 'Location', 'SouthEast');
set(leg,'FontSize',50)

print -dpdf results/300W_res.pdf
