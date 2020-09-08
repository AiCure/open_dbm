% First writing out PNet
load('../PNet_mlab.mat');

cnn = struct;
cnn.layers = cell(1,8);
cnn.layers{1} = struct;
cnn.layers{1}.type = 'conv';
cnn.layers{1}.weights = {PNet_mlab.weights_conv1, PNet_mlab.biases_conv1};

cnn.layers{2} = struct;
cnn.layers{2}.type = 'prelu';
cnn.layers{2}.weights = {PNet_mlab.prelu_weights_1};

cnn.layers{3} = struct;
cnn.layers{3}.type = 'max_pooling';
cnn.layers{3}.weights = {};
cnn.layers{3}.stride_x = 2;
cnn.layers{3}.stride_y = 2;
cnn.layers{3}.kernel_size_x = 2;
cnn.layers{3}.kernel_size_y = 2;

cnn.layers{4} = struct;
cnn.layers{4}.type = 'conv';
cnn.layers{4}.weights = {PNet_mlab.weights_conv2, PNet_mlab.biases_conv2};

cnn.layers{5} = struct;
cnn.layers{5}.type = 'prelu';
cnn.layers{5}.weights = {PNet_mlab.prelu_weights_2};

cnn.layers{6} = struct;
cnn.layers{6}.type = 'conv';
cnn.layers{6}.weights = {PNet_mlab.weights_conv3, PNet_mlab.biases_conv3};

cnn.layers{7} = struct;
cnn.layers{7}.type = 'prelu';
cnn.layers{7}.weights = {PNet_mlab.prelu_weights_3};

cnn.layers{8} = struct;
cnn.layers{8}.type = 'fc';
cnn.layers{8}.weights = {PNet_mlab.w, PNet_mlab.b};

Write_CNN_to_binary('PNet.dat', cnn);

%% Next writing out the RNet
clear
load('../RNet_mlab.mat');
    
cnn = struct;
cnn.layers = cell(1,11);
cnn.layers{1} = struct;
cnn.layers{1}.type = 'conv';
cnn.layers{1}.weights = {RNet_mlab.weights_conv1, RNet_mlab.biases_conv1};

cnn.layers{2} = struct;
cnn.layers{2}.type = 'prelu';
cnn.layers{2}.weights = {RNet_mlab.prelu_weights_1};

cnn.layers{3} = struct;
cnn.layers{3}.type = 'max_pooling';
cnn.layers{3}.weights = {};
cnn.layers{3}.stride_x = 2;
cnn.layers{3}.stride_y = 2;
cnn.layers{3}.kernel_size_x = 3;
cnn.layers{3}.kernel_size_y = 3;

cnn.layers{4} = struct;
cnn.layers{4}.type = 'conv';
cnn.layers{4}.weights = {RNet_mlab.weights_conv2, RNet_mlab.biases_conv2};

cnn.layers{5} = struct;
cnn.layers{5}.type = 'prelu';
cnn.layers{5}.weights = {RNet_mlab.prelu_weights_2};

cnn.layers{6} = struct;
cnn.layers{6}.type = 'max_pooling';
cnn.layers{6}.weights = {};
cnn.layers{6}.stride_x = 2;
cnn.layers{6}.stride_y = 2;
cnn.layers{6}.kernel_size_x = 3;
cnn.layers{6}.kernel_size_y = 3;

cnn.layers{7} = struct;
cnn.layers{7}.type = 'conv';
cnn.layers{7}.weights = {RNet_mlab.weights_conv3, RNet_mlab.biases_conv3};

cnn.layers{8} = struct;
cnn.layers{8}.type = 'prelu';
cnn.layers{8}.weights = {RNet_mlab.prelu_weights_3};

cnn.layers{9} = struct;
cnn.layers{9}.type = 'fc';
cnn.layers{9}.weights = {RNet_mlab.w_fc1, RNet_mlab.b_fc1};

cnn.layers{10} = struct;
cnn.layers{10}.type = 'prelu';
cnn.layers{10}.weights = {RNet_mlab.prelu_fc1};
    
cnn.layers{11} = struct;
cnn.layers{11}.type = 'fc';
cnn.layers{11}.weights = {RNet_mlab.w_fc2, RNet_mlab.b_fc2};

Write_CNN_to_binary('RNet.dat', cnn);

%% Next writing out the ONet
clear
load('../ONet_mlab.mat');
    
cnn = struct;
cnn.layers = cell(1,14);
cnn.layers{1} = struct;
cnn.layers{1}.type = 'conv';
cnn.layers{1}.weights = {ONet_mlab.weights_conv1, ONet_mlab.biases_conv1};

cnn.layers{2} = struct;
cnn.layers{2}.type = 'prelu';
cnn.layers{2}.weights = {ONet_mlab.prelu_weights_1};

cnn.layers{3} = struct;
cnn.layers{3}.type = 'max_pooling';
cnn.layers{3}.weights = {};
cnn.layers{3}.stride_x = 2;
cnn.layers{3}.stride_y = 2;
cnn.layers{3}.kernel_size_x = 3;
cnn.layers{3}.kernel_size_y = 3;

cnn.layers{4} = struct;
cnn.layers{4}.type = 'conv';
cnn.layers{4}.weights = {ONet_mlab.weights_conv2, ONet_mlab.biases_conv2};

cnn.layers{5} = struct;
cnn.layers{5}.type = 'prelu';
cnn.layers{5}.weights = {ONet_mlab.prelu_weights_2};

cnn.layers{6} = struct;
cnn.layers{6}.type = 'max_pooling';
cnn.layers{6}.weights = {};
cnn.layers{6}.stride_x = 2;
cnn.layers{6}.stride_y = 2;
cnn.layers{6}.kernel_size_x = 3;
cnn.layers{6}.kernel_size_y = 3;

cnn.layers{7} = struct;
cnn.layers{7}.type = 'conv';
cnn.layers{7}.weights = {ONet_mlab.weights_conv3, ONet_mlab.biases_conv3};

cnn.layers{8} = struct;
cnn.layers{8}.type = 'prelu';
cnn.layers{8}.weights = {ONet_mlab.prelu_weights_3};

cnn.layers{9} = struct;
cnn.layers{9}.type = 'max_pooling';
cnn.layers{9}.weights = {};
cnn.layers{9}.stride_x = 2;
cnn.layers{9}.stride_y = 2;
cnn.layers{9}.kernel_size_x = 2;
cnn.layers{9}.kernel_size_y = 2;

cnn.layers{10} = struct;
cnn.layers{10}.type = 'conv';
cnn.layers{10}.weights = {ONet_mlab.weights_conv4, ONet_mlab.biases_conv4};

cnn.layers{11} = struct;
cnn.layers{11}.type = 'prelu';
cnn.layers{11}.weights = {ONet_mlab.prelu_weights_4};

cnn.layers{12} = struct;
cnn.layers{12}.type = 'fc';
cnn.layers{12}.weights = {ONet_mlab.w_fc1, ONet_mlab.b_fc1};

cnn.layers{13} = struct;
cnn.layers{13}.type = 'prelu';
cnn.layers{13}.weights = {ONet_mlab.prelu_fc1};
    
cnn.layers{14} = struct;
cnn.layers{14}.type = 'fc';
cnn.layers{14}.weights = {ONet_mlab.w_fc2, ONet_mlab.b_fc2};

Write_CNN_to_binary('ONet.dat', cnn);

f = fopen('MTCNN_detector.txt', 'w');
fprintf(f, 'PNet PNet.dat\r\n');
fprintf(f, 'RNet RNet.dat\r\n');
fprintf(f, 'ONet ONet.dat\r\n');
fclose(f);