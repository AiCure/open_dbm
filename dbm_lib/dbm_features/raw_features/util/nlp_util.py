"""
file_name: nlp_util
project_name: DBM
created: 2020-10-11
"""

import subprocess
import json
import numpy as np
import pandas as pd
import os
import logging

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger()

#Speech to text using Deepspeech 0.9.1
def deepspeech(AUDIO_FILE,deep_path):
    """
        Extracting text from audio using Deep Speech neural network trained model
        Returns:
            Text: text which is extracted from audio
    """
    api = 'deepspeech'
    arg_speech0 = '--model'
    arg_speech_path0 = os.path.join(deep_path, 'deepspeech-0.9.1-models.pbmm')
    arg_speech1 = '--scorer'
    arg_speech_path1 = os.path.join(deep_path, 'deepspeech-0.9.1-models.scorer')
    arg_audio = "--audio"
    
    out = subprocess.Popen([api, arg_speech0, arg_speech_path0, arg_speech1, arg_speech_path1, arg_audio, AUDIO_FILE],
                           stdout=subprocess.PIPE, 
                           stderr=subprocess.STDOUT)
    logger.info('Deepspeech output...... {}'.format(out))
    try:
        stdout,stderr = out.communicate()
    except:
        return "error", "error"
    print(stderr)
    return stdout,stderr

def deep_speech_output_clean(result):
    """
        Parsing deep speech output(text)
        Return: 
            Text from speech
    """
    text = ""
    if len(result)>0:
        res_split = str(result[0]).split('\\n')
        
        if len(res_split)>0:
            for i in range(len(res_split)):
                if 'Inference took' in res_split[i]:
                    text = res_split[i + 1]
                    return text
    return text

def process_deepspeech(audio_file,deep_path):
    """
    Transcribing audio to extract text from speech
    """
    deep_output = deepspeech(audio_file,deep_path)
    deep_text= deep_speech_output_clean(deep_output)
    
    return deep_text
