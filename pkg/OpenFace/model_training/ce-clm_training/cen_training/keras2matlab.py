import os
import sys
import time
import pickle
import scipy.io as sio
import keras
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation
from keras.optimizers import SGD, RMSprop, Adagrad, Adadelta, Adam, Adamax
from keras.constraints import maxnorm, nonneg
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




#accuracies is a list of (rmse_i and correlation_i) for i in range of your epochs - we want to pick the model from somwhere in your  

def dump(keras_weight_file,output_filename,rmse,corr):

        #build the model
        model=build_model()
        model.load_weights(keras_weight_file)
        denses=[layer for layer in model.layers if type(layer) is keras.layers.Dense]
        #creating the matlab object
        final=numpy.zeros(len(denses)*2,dtype=numpy.object)
        #getting all the weights and biases in their correspoding place in final object
        for i in range(len(denses)):
                w,b=(denses[i].get_weights())
                final[i*2]=w
                final[i*2+1]=b
        #writing weights,rmse,correlation
        sio.savemat(output_filename, {'rmse':rmse,'correlation_2':corr,'weights':final})


#this is the arch4 - #TODO BY YOU: replace with your architecture - just make sure the loop inside keras2matlab.py is working correctly with your architecture

def build_model():

        model = Sequential()
        model.add(Dense(500, input_dim=122, activation='relu'))
        model.add(Dropout(0.3))
        model.add(Dense(200, activation='relu'))
        model.add(Dropout(0.3))
        model.add(Dense(100, activation='sigmoid'))
        model.add(Dropout(0.3))

        model.add(Dense(1, W_constraint=nonneg(), activation='sigmoid'))


        optimizers=[];
        optimizers.append(SGD(lr=.1, momentum=0.1, decay=0.0))
        optimizers.append(RMSprop(lr=0.001,rho=0.9, epsilon=1e-06))
        optimizers.append(Adagrad(lr=0.01, epsilon=1e-06))
        optimizers.append(Adadelta(lr=1.0, rho=0.95, epsilon=1e-06))
        optimizers.append(Adam(lr=0.0001/2, beta_1=0.9, beta_2=0.999, epsilon=1e-08))
        optimizers.append(Adamax(lr=0.002, beta_1=0.9, beta_2=0.999, epsilon=1e-08))


        model.compile(loss='mean_squared_error', optimizer=optimizers[4])
        return model
