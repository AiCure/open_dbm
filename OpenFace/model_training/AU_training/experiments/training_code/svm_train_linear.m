function [model] = svm_train_linear(train_labels, train_samples, hyper)
    comm = sprintf('-s 1 -B 1 -e %.10f -c %.10f -q', hyper.e, hyper.c);
    model = train(train_labels, train_samples, comm);
    
    if(isfield(hyper, 'eval_ids'))
        model.eval_ids = hyper.eval_ids;
    end
end