function [ test_folds ] = get_test_folds( num_folds, users )
%GET_TEST_FOLDS Summary of this function goes here
%   Detailed explanation goes here

test_folds = cell(num_folds,1);
rng(0);
randomise_users = randperm(27);
spacing = round(linspace(0, 27, num_folds+1));
for i=1:num_folds
    test_folds{i} = users(randomise_users((spacing(i)+1):spacing(i+1)));
end

end

