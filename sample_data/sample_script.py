
### LIBRARIES ------
import pandas as pd
import numpy as np
import os, glob

from siuba import _ as D
import siuba.dply.verbs
import siuba.dply.vector

#from opendbm import FacialActivity  #needed with docker?
#from opendbm import VerbalAcoustics as va #needed with docker? 
from opendbm import Speech as sp
from opendbm import Movement as mv


### FINDING DATASETS ----


# find mp4 files -- assume in sample_data folder
str_ext = '*_actor.mp4'
list_mp4 = glob.glob(str_ext)
path_file = list_mp4[0]


### VERBAL ACOUSTICS -----

#fit the model
model = va()
model.fit(path_file)

# get audio intensity
var_intensity = model.get_audio_intensity()
df_va_intensity = var_intensity.to_dataframe()

# get attributes from audio intesity 
var_1 = var_intensity.mean()

