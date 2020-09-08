function [ out_prob, out_correction ] = RNet( im_data, RNet_mlab )
%PNET Summary of this function goes here
%   Detailed explanation goes here

    % The convolutional and pooling layers
    out = convolution(im_data, RNet_mlab.weights_conv1, RNet_mlab.biases_conv1);
    out = PReLU(out, RNet_mlab.prelu_weights_1);
    out = max_pooling2(out, 3, 2);
    out = convolution(out, RNet_mlab.weights_conv2, RNet_mlab.biases_conv2);
    out = PReLU(out, RNet_mlab.prelu_weights_2);
    out = max_pooling2(out, 3, 2);
    out = convolution(out, RNet_mlab.weights_conv3, RNet_mlab.biases_conv3);
    out = PReLU(out, RNet_mlab.prelu_weights_3);
    
    % The fully connected layers

    out_fc_1 = zeros(size(out,1)*size(out,2) * size(out,3), size(out,4));
    out_fc_1(:) = out(:);
    out_fc_1 = out_fc_1' * RNet_mlab.w_fc1 + RNet_mlab.b_fc1';
    out_fc_1 = PReLU(out_fc_1, RNet_mlab.prelu_fc1);

    out_fc2 = out_fc_1 * RNet_mlab.w_fc2 + RNet_mlab.b_fc2';
    out_fc2 = out_fc2';
    
    % Probability of each proposal
    out_prob = 1./(1+exp(out_fc2(1,:)-out_fc2(2,:)));
    
    % The correction of each detection
    out_correction = out_fc2(3:end,:);
end

