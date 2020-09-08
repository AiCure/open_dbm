% load('ocv.mat')
% Move into Matlab space
% bboxes = bboxes + 1;
clear
% Replace this with the location of in 300 faces in the wild data
if(exist([getenv('USERPROFILE') '/Dropbox/AAM/test data/'], 'file'))
    root_test_data = [getenv('USERPROFILE') '/Dropbox/AAM/test data/'];    
else
    root_test_data = 'D:/Dropbox/Dropbox/AAM/test data/';
end

[images, detections, labels] = Collect_wild_imgs(root_test_data, true, true, true, true);

%% some visualisations

% Find the width and height mappings
widths_gt = (max(labels(:,:,1)') - min(labels(:,:,1)'))';
heights_gt = (max(labels(:,:,2)') - min(labels(:,:,2)'))';

widths_det = detections(:,3) - detections(:,1);
heights_det = detections(:,4) - detections(:,2);

s_width = sqrt(std(widths_det ./ widths_gt));
s_height = sqrt(std(heights_det ./ heights_gt));

tx_gt =  min(labels(:,:,1)')';
ty_gt =  min(labels(:,:,2)')';

tx_det = detections(:,1);
ty_det = detections(:,2);

s_tx = std((tx_gt - tx_det) ./ widths_det);
s_ty = std((ty_gt - ty_det) ./ heights_det);