clear;

% Make sure we have the dependencies for convolution
od = cd('../../face_validation');
setup;
cd(od);

imgs = dir('D:\Datasets\300_W\AFW/*.jpg');
for i=2:numel(imgs)
    img = imread(['D:\Datasets\300_W\AFW/', imgs(i).name]);
    [bboxes, lmarks, confidences] = detect_face_mtcnn(img, 60);
    hold off
    imshow(img);
    hold on;
    for d=1:size(bboxes,1)
        rectangle('Position', [bboxes(d,1), bboxes(d,2), bboxes(d,3)-bboxes(d,1), bboxes(d,4) - bboxes(d,2)]);
        plot(lmarks(d,1:5), lmarks(d,6:10), '.r');
    end
    drawnow expose
end