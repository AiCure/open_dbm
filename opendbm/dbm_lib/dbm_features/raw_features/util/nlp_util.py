"""
file_name: nlp_util
project_name: DBM
created: 2020-10-11
"""

import json
import logging
import os
import re
import subprocess

import nltk
import numpy as np
import pandas as pd
from lexicalrichness import LexicalRichness
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

# Speech to text using Deepspeech 0.9.1
def deepspeech(AUDIO_FILE, deep_path):
    """
    Extracting text from audio using Deep Speech neural network trained model
    Returns:
        Text: text which is extracted from audio
    """
    api = "deepspeech"
    arg_speech0 = "--model"
    arg_speech_path0 = os.path.join(deep_path, "deepspeech-0.9.1-models.pbmm")
    arg_speech1 = "--scorer"
    arg_speech_path1 = os.path.join(deep_path, "deepspeech-0.9.1-models.scorer")
    arg_audio = "--audio"

    out = subprocess.Popen(
        [
            api,
            arg_speech0,
            arg_speech_path0,
            arg_speech1,
            arg_speech_path1,
            arg_audio,
            AUDIO_FILE,
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    logger.info("Deepspeech output...... {}".format(out))
    try:
        stdout, stderr = out.communicate()
    except:
        return "error", "error"
    # print(stderr)
    return stdout, stderr


def deep_speech_output_clean(result):
    """
    Parsing deep speech output(text)
    Return:
        Text from speech
    """
    text = ""
    if len(result) > 0:
        res_split = str(result[0]).split("\\n")

        if len(res_split) > 0:
            for i in range(len(res_split)):
                if "Inference took" in res_split[i]:
                    text = res_split[i + 1]
                    return text
    return text


def process_deepspeech(audio_file, deep_path):
    """
    Transcribing audio to extract text from speech
    """
    deep_output = deepspeech(audio_file, deep_path)
    deep_text = deep_speech_output_clean(deep_output)

    return deep_text


def nltk_download():

    try:
        nltk.data.find("tokenizers/punkt")

    except LookupError:
        logger.info("punkt is not available")
        nltk.download("punkt")

    try:
        nltk.data.find("averaged_perceptron_tagger")

    except LookupError:
        logger.info("averaged_perceptron_tagger is not available")
        nltk.download("averaged_perceptron_tagger")


def empty_speech(r_config, master_url, error_txt):
    """
    Preparing empty speech matrix with error
    Args:
        r_config: raw config file object
        error_txt: Error message during transcription

    Returns:
            Empty dataframe for speech features with error
    """

    col = [
        r_config.nlp_numSentences,
        r_config.nlp_singPronPerAns,
        r_config.nlp_singPronPerSen,
        r_config.nlp_pastTensePerAns,
        r_config.nlp_pastTensePerSen,
        r_config.nlp_pronounsPerAns,
        r_config.nlp_pronounsPerSen,
        r_config.nlp_verbsPerAns,
        r_config.nlp_verbsPerSen,
        r_config.nlp_adjectivesPerAns,
        r_config.nlp_adjectivesPerSen,
        r_config.nlp_nounsPerAns,
        r_config.nlp_nounsPerSen,
        r_config.nlp_sentiment_mean,
        r_config.nlp_mattr,
        r_config.nlp_wordsPerMin,
        r_config.nlp_totalTime,
        r_config.err_reason,
    ]

    df_speech = pd.DataFrame([[np.nan] * len(col) + [error_txt]], columns=col)
    df_speech["dbm_master_url"] = master_url

    return df_speech


def divide_var(speech_var1, spech_var2):
    """
    divide variables
    """
    speech_var = np.nan
    if spech_var2 != 0:
        speech_var = speech_var1 / spech_var2
    return speech_var


def process_speech(transcribe_df, r_config):
    """
    Preparing speech features
    Args:
        transcribe_df: Transcribed dataframe
        r_config: raw config file object
    Returns:
        Dataframe for speech features
    """
    transcribe_df = transcribe_df.replace(np.nan, "", regex=True)
    err_transcribe = transcribe_df[r_config.err_reason].iloc[0]
    transcribe = transcribe_df[r_config.nlp_transcribe].iloc[0]
    total_time = transcribe_df[r_config.nlp_totalTime].iloc[0]
    master_url = transcribe_df["dbm_master_url"].iloc[0]

    # clean transcribe
    transcribe = transcribe.replace(",", "")
    transcribe = " ".join(re.findall(r"[\w']+|[.!?]", transcribe))

    if err_transcribe != "Pass":
        df_speech = empty_speech(r_config, master_url, "error")

        return df_speech

    speech_dict = {}
    nltk_download()

    sentences = nltk.tokenize.sent_tokenize(transcribe)
    words_all = nltk.tokenize.word_tokenize(transcribe)
    num_sentences = len(sentences)

    speech_dict[r_config.nlp_numSentences] = num_sentences

    # nlp_singPron
    i_s = transcribe.count("I")
    me_s = transcribe.count("me")
    my_s = transcribe.count("my")
    sing_count = i_s + me_s + my_s

    speech_dict[r_config.nlp_singPronPerAns] = (
        sing_count if len(words_all) > 0 else np.nan
    )
    speech_dict[r_config.nlp_singPronPerSen] = divide_var(
        speech_dict[r_config.nlp_singPronPerAns], num_sentences
    )

    tagged = nltk.pos_tag(transcribe.split())
    tagged_df = pd.DataFrame(tagged, columns=["word", "pos_tag"])

    # Past tense per answer
    all_POSs = tagged_df["pos_tag"].tolist()
    speech_dict[r_config.nlp_pastTensePerAns] = (
        all_POSs.count("VBD") if len(words_all) > 0 else np.nan
    )
    speech_dict[r_config.nlp_pastTensePerSen] = divide_var(
        speech_dict[r_config.nlp_pastTensePerAns], num_sentences
    )

    # Pronoun per answer
    pronounsPerAns = all_POSs.count("PRP") + all_POSs.count("PRP$")
    speech_dict[r_config.nlp_pronounsPerAns] = (
        pronounsPerAns if len(words_all) > 0 else np.nan
    )
    speech_dict[r_config.nlp_pronounsPerSen] = divide_var(
        speech_dict[r_config.nlp_pronounsPerAns], num_sentences
    )

    # Verb per answer
    verbPerAns = (
        all_POSs.count("VB")
        + all_POSs.count("VBD")
        + all_POSs.count("VBG")
        + all_POSs.count("VBN")
        + all_POSs.count("VBP")
        + all_POSs.count("VBZ")
    )
    speech_dict[r_config.nlp_verbsPerAns] = verbPerAns if len(words_all) > 0 else np.nan
    speech_dict[r_config.nlp_verbsPerSen] = divide_var(
        speech_dict[r_config.nlp_verbsPerAns], num_sentences
    )

    # Adjective per answer
    adjectivesAns = all_POSs.count("JJ") + all_POSs.count("JJR") + all_POSs.count("JJS")
    speech_dict[r_config.nlp_adjectivesPerAns] = (
        adjectivesAns if len(words_all) > 0 else np.nan
    )
    speech_dict[r_config.nlp_adjectivesPerSen] = divide_var(
        speech_dict[r_config.nlp_adjectivesPerAns], num_sentences
    )

    # Noun per answer
    nounsAns = all_POSs.count("NN") + all_POSs.count("NNP") + all_POSs.count("NNS")
    speech_dict[r_config.nlp_nounsPerAns] = nounsAns if len(words_all) > 0 else np.nan
    speech_dict[r_config.nlp_nounsPerSen] = divide_var(
        speech_dict[r_config.nlp_nounsPerAns], num_sentences
    )

    # Sentiment analysis
    vader = SentimentIntensityAnalyzer()
    sentence_valences = []

    for s in sentences:
        sentiment_dict = vader.polarity_scores(s)
        sentence_valences.append(sentiment_dict["compound"])

    speech_dict[r_config.nlp_sentiment_mean] = (
        np.mean(sentence_valences) if len(sentence_valences) > 0 else np.nan
    )
    non_punc = list(value for value in words_all if value not in [".", "!", "?"])

    non_punc_as_str = " ".join(str(non_punc))
    lex = LexicalRichness(non_punc_as_str)
    speech_dict[r_config.nlp_mattr] = (
        lex.mattr(window_size=lex.words) if lex.words > 0 else np.nan
    )

    # Number of words per minute
    speech_dict[r_config.nlp_wordsPerMin] = divide_var(len(non_punc), total_time) * 60
    speech_dict[r_config.nlp_totalTime] = total_time
    speech_dict["dbm_master_url"] = master_url

    df_speech = pd.DataFrame([speech_dict])
    return df_speech
