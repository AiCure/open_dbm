import os
from ast import For
from zipfile import ZipFile

from schemas.biomaker_request import BiomakerRequest

from opendbm import FacialActivity, Movement, Speech, VerbalAcoustics


class BiomakerService:
    def process(self, group: str, biomaker_request: BiomakerRequest):
        if group == "facial":
            return self.process_facial(group, biomaker_request)
        elif group == "acoustic":
            return self.process_acoustic(group, biomaker_request)
        elif group == "movement":
            return self.process_movement(group, biomaker_request)
        elif group == "speech":
            return self.process_speech(group, biomaker_request)
        pass

    def process_facial(self, group, biomaker_request: BiomakerRequest):
        m = FacialActivity()
        curWorkingDir = os.getcwd()
        methodName = "process_facial"
        testfile = f"{curWorkingDir}/{biomaker_request.file_url}"
        if os.path.isfile(testfile):
            print("File exist")
        else:
            print("File not exist")
        m.fit(testfile)
        zip_filename = f"{curWorkingDir}/files/${methodName}"
        zipObj = ZipFile(zip_filename, "w")
        for var in biomaker_request.variables:
            if var == "landmark":
                lmk = m.get_landmark()
                lmk.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "asymmetry":
                asym = m.get_asymmetry()
                asym.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "expressivity":
                expr = m.get_expressivity()
                expr.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "action_unit":
                au = m.get_action_unit()
                au.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
        zipObj.close()
        return zip_filename, methodName

    def process_acoustic(self, group, biomaker_request: BiomakerRequest):
        m = VerbalAcoustics()
        curWorkingDir = os.getcwd()
        methodName = "process_acoustic"
        testfile = f"{curWorkingDir}/{biomaker_request.file_url}"
        m.fit(testfile)
        zip_filename = f"{curWorkingDir}/files/${methodName}"
        zipObj = ZipFile(zip_filename, "w")
        for var in biomaker_request.variables:
            if var == "audio_intensity":
                au = m.get_audio_intensity()
                au.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "pitch_frequency":
                vp = m.get_pitch_frequency()
                vp.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "formant_frequency":
                ff = m.get_formant_frequency()
                ff.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "harmonic_noise":
                hn = m.get_harmonic_noise()
                hn.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
        zipObj.close()
        return zip_filename, methodName

    def process_movement(self, group, biomaker_request: BiomakerRequest):
        m = Movement()
        curWorkingDir = os.getcwd()
        methodName = "process_movement"
        testfile = f"{curWorkingDir}/{biomaker_request.file_url}"
        m.fit(testfile)
        zip_filename = f"{curWorkingDir}/files/${methodName}"
        zipObj = ZipFile(zip_filename, "w")

        for var in biomaker_request.variables:
            if var == "head_movement":
                lmk = m.get_head_movement()
                lmk.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "eye_blink":
                asym = m.get_eye_blink()
                asym.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "facial_tremor":
                au = m.get_facial_tremor()
                au.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "vocal_tremor":
                au = m.get_vocal_tremor()
                au.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")

        return zip_filename, methodName

    def process_speech(self, group, biomaker_request: BiomakerRequest):
        m = Speech()
        curWorkingDir = os.getcwd()
        methodName = "process_speech"
        testfile = f"{curWorkingDir}/{biomaker_request.file_url}"
        m.fit(testfile)
        zip_filename = f"{curWorkingDir}/files/${methodName}"
        zipObj = ZipFile(zip_filename, "w")
        for var in biomaker_request.variables:
            if var == "speech_features":
                sf = m.get_speech_features()
                sf.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
            if var == "transcribe":
                tr = m.get_transcribe()
                tr.to_dataframe().to_csv(var + ".csv", index=False)
                zipObj.write(var + ".csv")
        zipObj.close()
        return zip_filename, methodName
