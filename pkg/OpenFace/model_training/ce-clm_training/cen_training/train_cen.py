from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.optimizers import SGD, RMSprop, Adagrad, Adadelta, Adam, Adamax 
from keras.constraints import max_norm, non_neg
from keras.callbacks import ModelCheckpoint, Callback
import numpy
import scipy
from scipy import io
from itertools import product
import pickle
import time
import uuid
import os
import h5py
import sys
from keras.models import model_from_json
from keras.models import model_from_yaml
from keras.models import load_model

import keras.backend as K

from datetime import datetime
import argparse

logfile = None
final_results = []

def log(message):
    with open(logfile, 'a') as f:
        f.write("{}\n".format(message))

def log_init(folder, filename):
    if not os.path.exists(folder):
        os.mkdir(folder)
    
    global logfile
    logfile = os.path.join(folder, filename)
    with open(logfile, 'a') as f:
        f.write("----------------------\n")
        f.write("{}\n".format(datetime.now().strftime("%b/%d/%y %H:%M:%S")))

def put_in_format(samples, training_samples_size):
    samples=samples.reshape(samples.shape[0]/training_samples_size, training_samples_size,samples.shape[1])
    return numpy.squeeze(samples);

def read_data(folder, scale, view, lm):
    folder = os.path.join(folder)
    print("--------------------------------------------------------------")
    try:
        #reading from h5
        h5_file = os.path.join(folder, str(lm), 'data' + scale + '_' + view + '.mat')
        print('loading patches from ' + h5_file)
        dataset = h5py.File(h5_file, 'r');
        print("Landmark " + str(lm))
    except:
        print("Landmark " + str(lm) + ' not found!')
        print("--------------------------------------------------------------")
        sys.exit()

    train_data = put_in_format(numpy.array(dataset['samples_train']),81)
    train_labels = put_in_format(numpy.array(dataset['labels_train']).T,81)
    test_data = put_in_format(numpy.array(dataset['samples_test']),81)
    test_labels = put_in_format(numpy.array(dataset['labels_test']).T,81)
    
    train_data_dnn = train_data.reshape([train_data.shape[0]*train_data.shape[1],122])
    train_labels_dnn = train_labels.reshape([train_labels.shape[0]*train_labels.shape[1],1])
    test_data_dnn = test_data.reshape([test_data.shape[0]*test_data.shape[1],122])
    test_labels_dnn = test_labels.reshape([test_labels.shape[0]*test_labels.shape[1],1])

    print(train_data_dnn.shape)
    print(train_labels_dnn.shape)
    print(test_data_dnn.shape)
    print(test_labels_dnn.shape)

    return train_data_dnn.astype('float32'), train_labels_dnn.flatten().astype('float32'), test_data_dnn.astype('float32'), test_labels_dnn.flatten().astype('float32')

def read_data_menpo(folder, scale, view, lm):
    train_file = "menpo_train_data{}_{}_{}.mat".format(scale, view, lm)
    valid_file = "menpo_valid_data{}_{}_{}.mat".format(scale, view, lm)
    print("training file: {}".format(train_file))
    print("validation file: {}".format(valid_file))
    print("--------------------------------------------------------------")
    try:
        #reading from h5
        train = h5py.File(os.path.join(folder, train_file), 'r')
        valid = h5py.File(os.path.join(folder, valid_file), 'r')
        print("Landmark " + str(lm))
    except:
        print("Landmark " + str(lm) + 'not found!')
        print("--------------------------------------------------------------")
        sys.exit()

    train_data = put_in_format(numpy.array(train['samples']),81)
    train_labels = put_in_format(numpy.array(train['labels']).T,81)
    train_data_dnn = train_data.reshape([train_data.shape[0]*train_data.shape[1],122])
    train_labels_dnn = train_labels.reshape([train_labels.shape[0]*train_labels.shape[1],1])
    print(train_data_dnn.shape)
    print(train_labels_dnn.shape)

    if 'samples' in valid:
        valid_data=put_in_format(numpy.array(valid['samples']),81)
        valid_labels=put_in_format(numpy.array(valid['labels']).T,81)
        valid_data_dnn = valid_data.reshape([valid_data.shape[0]*valid_data.shape[1],122])
        valid_labels_dnn = valid_labels.reshape([valid_labels.shape[0]*valid_labels.shape[1],1])
        print(valid_data_dnn.shape)
        print(valid_labels_dnn.shape)
        return train_data_dnn.astype('float32'), train_labels_dnn.flatten().astype('float32'), valid_data_dnn.astype('float32'), valid_labels_dnn.astype('float32')
    else:
        print("No validation data")
        return train_data_dnn.astype('float32'), train_labels_dnn.flatten().astype('float32'), None, None

    train.close()
    valid.close()

def model_half():
    model = Sequential()
    model.add(Dense(300, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(100, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(50, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def model_300():
    model = Sequential()
    model.add(Dense(300, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(200, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(100, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch4():
    model = Sequential()
    model.add(Dense(500, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(200, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(100, activation='sigmoid'))
    model.add(Dropout(0.3))
    
    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))
    
    return model
    
def arch6():
    model = Sequential()
    model.add(Dense(50, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(20, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(10, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch6a():
    model = Sequential()
    model.add(Dense(50, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(200, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(100, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch7():
    model = Sequential()
    model.add(Dense(128, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(64, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(32, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch7a():
    model = Sequential()
    model.add(Dense(100, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(40, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(20, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch7b():
    model = Sequential()
    model.add(Dense(150, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(60, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(30, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch7c():
    model = Sequential()
    model.add(Dense(200, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(80, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(40, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch8():
    model = Sequential()
    model.add(Dense(512, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(32, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def arch9():
    model = Sequential()
    model.add(Dense(500, input_dim=122, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(200, activation='relu'))
    model.add(Dropout(0.3))
    model.add(Dense(10, activation='sigmoid'))
    model.add(Dropout(0.3))

    model.add(Dense(1, kernel_constraint=non_neg(), activation='sigmoid'))

    return model

def find_last(epoch_src, acc_file, dataset):
    filename = os.path.join(epoch_src, acc_file)
    if not os.path.exists(filename):
        print("{} not found!".format(filename))
        sys.exit()

    results = pickle.load(open(filename, 'r'))
    print("starting from epoch {}".format(len(results['corr'])))
    filename = '{}_epoch_{}.h5'.format(dataset, len(results['corr']) - 1)
    print("loading from {}".format(filename))
    return os.path.join(epoch_src, filename), len(results['corr'])

def load_old_model(epoch_src, acc_file, dataset):
    # load pre-trained model to continue training
    filename = None
    start_epoch = 0
    if acc_file is not None:
        filename, start_epoch = find_last(epoch_src, acc_file, dataset)

    return filename, start_epoch

def build_model(model_fn, model_file=None):
    if model_file is not None:
        model = load_model(model_file)
        print(model.get_config())
        return model

    model = model_fn()

    optimizers=[]
    optimizers.append(SGD(lr=.1, momentum=0.1, decay=0.0))
    optimizers.append(RMSprop(lr=0.001,rho=0.9, epsilon=1e-06))
    optimizers.append(Adagrad(lr=0.01, epsilon=1e-06))
    optimizers.append(Adadelta(lr=1.0, rho=0.95, epsilon=1e-06))
    #this is the optimizer that is used - Adam
    #you can change the lr parameter 
    #initial: 2
    lr = 0.0001/2
    log("Learning rate for Adam: {}".format(lr))
    optimizers.append(Adam(lr=lr, beta_1=0.9, beta_2=0.999, epsilon=1e-08))
    optimizers.append(Adamax(lr=0.002, beta_1=0.9, beta_2=0.999, epsilon=1e-08))
    
    model.compile(loss='mean_squared_error', optimizer=optimizers[4])

    return model

corrs = []
class EpochCallback(Callback):
    def __init__(self, valid_data, valid_labels):
        self.valid_data = valid_data
        self.valid_labels = valid_labels

    def on_epoch_end(self, epoch, logs={}):
        prediction = self.model.predict(self.valid_data, batch_size=4096)
        coeff = numpy.corrcoef(prediction.flatten(), self.valid_labels.flatten())[0, 1]

        print("RMSE: {}\tCorr: {}".format(numpy.sqrt(logs['val_loss']), coeff ** 2))

        global corrs
        corrs.append(coeff ** 2)

# TODO: make symbolic
def corr(y_true, y_pred):
    return K.constant((numpy.corrcoef(y_true.flatten(), y_pred.flatten())[0, 1]) ** 2)

def get_best(history, corrs):
    history = history.history
    print("Keys: {}".format(history.keys()))

    best_mse = None
    best_corr = None
    for i, (mse, corr) in enumerate(zip(history['val_loss'], corrs)):
        if best_mse is None or mse < best_mse[1]:
            best_mse = (i, mse)
        if best_corr is None or corr > best_corr[1]:
            best_corr = (i, corr)

    return best_mse, best_corr

MODELS = {
    'model_half': model_half,
    'model_300': model_300,
    'arch4': arch4,
    'arch6': arch6,
    'arch7': arch7,
    'arch8': arch8,
    'arch6a': arch6a,
    'arch7a': arch7a,
    'arch7b': arch7b,
    'arch7c': arch7c,
    'arch9': arch9
}

if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('mat_src', type=str)
    parser.add_argument('model', type=str, choices=MODELS.keys())
    parser.add_argument('scale', type=str, help="scale of image")
    parser.add_argument('view', type=str, help="view of image")
    parser.add_argument('lm', type=int, help="landmark number")
    parser.add_argument('minibatch', type=int, help="size of minibatch")
    parser.add_argument('results_dir', type=str, help="location to save model epochs")
    parser.add_argument('dataset', choices=['general', 'menpo'], help='dataset to train on')
    parser.add_argument('--acc_file', type=str, default=None, help='if this option is set, resume training of model based on last epoch in this file (in results_dir)')
    parser.add_argument('--num_epochs', type=int, default=25, help='number of epochs to train model')
    parser.add_argument('--outfile', type=str, default='accuracies.txt', help='file to save training history to (in results_dir)')

    args = parser.parse_args()

    logfile = "{}_{}_{}.log".format(args.scale, args.view, args.lm)
    log_init('./logs', logfile)

    log("""Loading data from: {}
Model: {}\nScale: {}\t View: {}\tLM: {}\nMinibatch size: {}
Results saved to: {}\nDataset: {}\nFile to resume from: {}
# of epochs: {}
Training history saved to: {}""".format(args.mat_src, args.model, args.scale,
        args.view, args.lm, args.minibatch, args.results_dir, args.dataset,
        args.acc_file, args.num_epochs, args.outfile))
    
    if not os.path.isdir(args.mat_src):
        print("Error, mat source {} does not exist".format(args.mat_src))
        sys.exit()

    model_folder = os.path.join(os.path.abspath(os.path.dirname(__file__)), args.results_dir, args.model)
    if not os.path.isdir(model_folder):
        os.makedirs(model_folder)
    outfolder = os.path.join(model_folder, "{}_{}_{}_{}".format(args.scale, args.view, args.lm, args.minibatch))
    if not os.path.isdir(outfolder):
        os.mkdir(outfolder)

    filename, start_epoch = load_old_model(outfolder, args.acc_file, args.dataset)

    model = build_model(MODELS[args.model], model_file=filename)

    if args.dataset == 'general':
        train_data, train_labels, valid_data, valid_labels = read_data(args.mat_src, args.scale, args.view, args.lm)
    elif args.dataset == 'menpo':
        train_data, train_labels, valid_data, valid_labels = read_data_menpo(args.mat_src, args.scale, args.view, args.lm)

    callbacks = [
            EpochCallback(valid_data, valid_labels),
            ModelCheckpoint(os.path.join(outfolder, args.dataset + "_epoch_{epoch}.h5"), verbose=1)
    ]

    history = model.fit(train_data, train_labels, verbose=1,
            epochs=args.num_epochs+start_epoch, batch_size=args.minibatch,
            validation_data=(valid_data, valid_labels), callbacks=callbacks,
            initial_epoch=start_epoch)
    
    (mse_index, bestMSE), bestCorr = get_best(history, corrs)
    log("Number of epochs run: {}".format(args.num_epochs))
    log("Best RMSE {}.\t Best Corr: {}.".format((mse_index, numpy.sqrt(bestMSE)), bestCorr))

    # append new training stats to old ones, if continuing
    old_data = None
    if args.acc_file is not None:
        with open(os.path.join(outfolder, args.acc_file), 'r') as g:
            old_data = pickle.load(g)

    with open(os.path.join(outfolder, args.outfile), 'w') as f:
        rmses = list(numpy.sqrt(history.history['val_loss']))

        if old_data is not None:
            rmses = old_data['rmse'] + rmses
            corrs = old_data['corr'] + corrs

        results = {'rmse': rmses, 'corr': corrs}
        pickle.dump(results, f)

    log("Successfully trained\n--------------------")
