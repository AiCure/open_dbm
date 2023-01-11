
### LIBRARIES ------
import pandas as pd
import numpy as np
import os, glob

from siuba import _ as D
import siuba.dply.verbs
import siuba.dply.vector

from opendbm import FacialActivity  #needed with docker?
from opendbm import Movement as mv #needed with docker? 
from opendbm import VerbalAcoustics as va 
from opendbm import Speech as sp


### FINDING DATASETS ----


# find mp4 files -- assume in sample_data folder
str_ext = '*_actor.mp4'
list_mp4 = glob.glob(str_ext)
path_file = list_mp4[0]


### VERBAL ACOUSTICS -----

#fit the model
model_va = va()
model_va.fit(path_file)
#model_va = va().fit(pathfile) # one-line alternative
var_intensity = model_va.get_audio_intensity()

# get audio intensity
df_va_intensity = var_intensity.to_dataframe()
print(df_va_intensity)

# get attributes from audio intesity 
va_inten_mean = var_intensity.mean()

### Movement 
model_mv = mv()
model_mv.fit(path_file) # Requires Docker

#get head movement
var_headmv = model_mv.get_head_movement() 

#convert head movement to dataframe
df_headmv = var_headmv.to_dataframe()
#note can check to see headmovement in jupyter:variables
# this can be helpful for QC to see if head movement was captured.
# wheh face is not detected no movement is captured and return is array of nan
