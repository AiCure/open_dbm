
######################################
# Global Settings
######################################
sourcedirec$ = "./"; directory of sounds to be analyzed
minPi = 60; minimal Pitch [Hz]
maxPi = 350; maximal Pitch [Hz]
ts = 0.015; analysis time step [s]
tremthresh = 0.15; minimal autocorr.-coefficient to assume "tremor"
minTr = 1.5;  minimal tremor frequency [Hz]
maxTr = 15; maximal tremor frequency [Hz]



######################################
# Sound (.wav) in, results (.txt) out
######################################

# record/load and select the sound to be analyzed!!!

info$ = Info
name$ = extractWord$(info$, "Object name: ")

slength = Get total duration
call ftrem
call atrem

echo 
...{"FTrF": 'ftrf:2#', "ATrF":'atrf:2',"FTrI":'ftri:3',"ATrI":'atri:3',"FTrP":'ftrp:3',"ATrP":'atrp:3'}



######################################
# Frequency Tremor Analysis
######################################
procedure ftrem
   To Pitch (cc)... ts minPi 15 yes 0.03 0.3 0.01 0.35 0.14 maxPi

#Edit
#pause

# because PRAAT only runs "Subtract linear fit" if the last frame is "voiceless" (!?):
# numberOfFrames+1 (1)
   numberOfFrames = Get number of frames
   x1 = Get time from frame number... 1
   am_F0 = Get mean... 0 0 Hertz

   Create Matrix... ftrem_0 0 slength numberOfFrames+1 ts x1 1 1 1 1 1 0
   for i from 1 to numberOfFrames
      select Pitch 'name$'
      f0 = Get value in frame... i Hertz
      select Matrix ftrem_0
# write zeros to matrix where frames are voiceless
      if f0 = undefined
         Set value... 1 i 0
      else
         Set value... 1 i f0
      endif
   endfor

# remove the linear F0 trend (F0 declination)
   To Pitch
   Subtract linear fit... Hertz
   Rename... ftrem_0_lin

# undo (1)
   Create Matrix... ftrem 0 slength numberOfFrames ts x1 1 1 1 1 1 0
   for i from 1 to numberOfFrames
      select Pitch ftrem_0_lin
      f0 = Get value in frame... i Hertz
      select Matrix ftrem
# write zeros to matrix where frames are voiceless
      if f0 = undefined
         Set value... 1 i 0
      else
         Set value... 1 i f0
      endif
   endfor

   To Pitch

# normalize F0-contour by mean F0
   select Matrix ftrem
   Formula... (self-am_F0)/am_F0

# since zeros in the Matrix (unvoiced frames) become normalized to -1 but 
# unvoiced frames should be zero (if anything)
# write zeros to matrix where frames are voiceless
   for i from 1 to numberOfFrames
      select Pitch ftrem
      f0 = Get value in frame... i Hertz
      if f0 = undefined
         select Matrix ftrem
         Set value... 1 i 0
      endif
   endfor

# to calculate autocorrelation (cc-method):
   select Matrix ftrem
   To Sound (slice)... 1
# calculate Frequency of Frequency Tremor [Hz]
   To Pitch (cc)... slength minTr 15 yes 0.01 tremthresh 0.01 0.35 0.14 maxTr
   Rename... ftrem_norm

   ftrf = Get mean... 0 0 Hertz

# calculate Intensity Index of Frequency Tremor [%]
   select Sound ftrem
   plus Pitch ftrem_norm
   To PointProcess (peaks)... yes no
   Rename... Maxima
   numberofMaxPoints = Get number of points
   ftri_max = 0
   noFMax = 0
   for iPoint from 1 to numberofMaxPoints
      select PointProcess Maxima
      ti = Get time from index... iPoint
      select Sound ftrem
      ftri_Point = Get value at time... Average ti Sinc70
      if ftri_Point = undefined
         ftri_Point = 0
         noFMax += 1
      endif
      ftri_max += abs(ftri_Point)
   endfor

select Sound ftrem
plus PointProcess Maxima
#Edit
#pause
   
# ftri_max:= (mean) procentual deviation of F0-maxima from mean F0 at ftrf
   numberofMaxima = numberofMaxPoints - noFMax
   ftri_max = 100 * ftri_max/numberofMaxima

   select Sound ftrem
   plus Pitch ftrem_norm
   To PointProcess (peaks)... no yes
   Rename... Minima
   numberofMinPoints = Get number of points
   ftri_min = 0
   noFMin = 0
   for iPoint from 1 to numberofMinPoints
      select PointProcess Minima
      ti = Get time from index... iPoint
      select Sound ftrem
      ftri_Point = Get value at time... Average ti Sinc70
      if ftri_Point = undefined
         ftri_Point = 0
         noFMin += 1
      endif
      ftri_min += abs(ftri_Point)
   endfor

select Sound ftrem
plus PointProcess Minima
#Edit
#pause


# ftri_min:= (mean) procentual deviation of F0-minima from mean F0 at ftrf
   numberofMinima = numberofMinPoints - noFMin
   ftri_min = 100 * ftri_min/numberofMinima

   ftri = (ftri_max + ftri_min) / 2
   
   ftrp = ftri * ftrf/(ftrf+1)

# uncomment to inspect frequnecy tremor objects:
# pause

   select Pitch ftrem
# uncomment if only frequency tremor is to be analyzed:
#   plus Pitch 'name$'
   plus Matrix ftrem_0
   plus Pitch ftrem_0
   plus Pitch ftrem_0_lin
   plus Matrix ftrem
   plus Sound ftrem
   plus Pitch ftrem_norm
   plus PointProcess Maxima
   plus PointProcess Minima
   Remove

endproc


######################################
# Amplitude Tremor Analysis
######################################
procedure atrem
   select Sound 'name$'
# uncomment if only amplitude tremor is to be analyzed:
#   To Pitch (cc)... ts minPi 15 yes 0.03 0.3 0.01 0.35 0.14 maxPi
#   select Sound 'name$'
   plus Pitch 'name$'
   To PointProcess (cc)
   select Sound 'name$'
   plus PointProcess 'name$'_'name$'

# amplitudes are integrals of intensity over periods -- not intensity maxima
   To AmplitudeTier (period)... 0 0 0.0001 0.02 1.7

#Edit
#pause

# from here on out: prepare to autocorrelate AmplitudeTier-data
# sample AmplitudeTier at (constant) rate ts
   numbOfAmpPoints = Get number of points
   first_ampP = Get time from index... 1
   last_ampP = Get time from index... numbOfAmpPoints

# to be able to -- automatically -- read Amp. values...
   Down to TableOfReal

   select Pitch 'name$'
   frameNo1 = Get frame number from time... first_ampP
   hiframe1 = ceiling(frameNo1)
   t_hiframe1 = Get time from frame number... hiframe1

   frameNoN = Get frame number from time... last_ampP
   loframeN = floor(frameNoN)

# number of Amp. points if (re-)sampled at ts
   numbOfPoints_neu = loframeN - hiframe1 + 1

# to enable autocorrelation of the Amp.-contour: ->Matrix->Sound

   Create Matrix... atrem_nlc 0 slength numbOfPoints_neu+1 ts t_hiframe1 1 1 1 1 1 2
# get the mean of the amplitude contour in time windows of constant duration
   for point_neu from 1 to numbOfPoints_neu
      t = (point_neu-1) * ts + t_hiframe1
      tl = t - ts/2
      tu = t + ts/2

      select AmplitudeTier 'name$'_'name$'_'name$'
      loil = Get low index from time... tl
      hiil = Get high index from time... tl
      loiu = Get low index from time... tu
      hiiu = Get high index from time... tu

      select TableOfReal 'name$'_'name$'_'name$'
      if loil = 0
         lotl = 0; time before the first amp. point
         druck_lol = Get value... hiil 2; amplitude value before the first amp. point
      else
         lotl = Get value... loil 1; time value of Amp.Point before tl in the PointProcess [s]
         druck_lol = Get value... loil 2; amplitude value before tl in the PointProcess [Pa, ranged from 0 to 1]
      endif

      hitl = Get value... hiil 1
      druck_hil = Get value... hiil 2; amplitude value after tl in the PointProcess

      lotu = Get value... loiu 1
      druck_lou = Get value... loiu 2; amplitude value before tu in the PointProcess

      if hiiu = numbOfAmpPoints + 1
         hitu = slength; time after the last amp. point
         druck_hiu = Get value... hiil 2; amplitude value after the last amp. point
      else
         hitu = Get value... hiiu 1; time value after tu in the PointProcess
         druck_hiu = Get value... hiiu 2; amplitude value after tu in the PointProcess
      endif

      nPinter = loiu - loil; = hiiu - hiil; number of amp.-points between tl and tu
      if nPinter > 0
         itinter = 0
         tinter = 0
         druck_tin = 0
         deltat = 0
         for iinter from 1 to nPinter
            hilft = itinter
            itinter = Get value... loil+iinter 1
            idruck_tin = Get value... loil+iinter 2

            ideltat = itinter - hilft
            druck_tin += idruck_tin * ideltat 
            tinter += itinter
            deltat += ideltat
         endfor

         tin = tinter/nPinter
         druck_tin = druck_tin/deltat
      endif

      druck_tl = ((hitl-tl)*druck_lol + (tl-lotl)*druck_hil) / (hitl-lotl)
      druck_tu = ((hitu-tu)*druck_lou + (tu-lotu)*druck_hiu) / (hitu-lotu)

      if nPinter = 0; loil = loiu; hiil = hiiu
         druck_mean = (druck_tl + druck_tu) / 2
      else
         druck_mean = ((tin-tl)*(druck_tl + druck_tin)/2 + (tu-tin)*(druck_tin + druck_tu)/2) / (tu-tl)
      endif

      select Matrix atrem_nlc
      Set value... 1 point_neu druck_mean
   endfor

   To Pitch
   am_Int = Get mean... 0 0 Hertz

# because PRAAT classifies frequencies in Pitch objects <=0 as "voiceless" and 
# therefore parts with extreme INTENSITIES would be considered as "voiceless"
# (irrelevant) after "Subtract linear fit" (1)
# "1" is added to the original Pa-values (ranged from 0 to 1)
   select Matrix atrem_nlc
   Formula... self+1

# because PRAAT only runs "Subtract linear fit" if the last frame is "voiceless"...?(2)
   Set value... 1 numbOfPoints_neu+1 0

# remove the linear amp.-trend (amplitude declination)
#Formula... self*1000; better for viewing
   To Pitch
   Rename... hilf_lincorr
   Subtract linear fit... Hertz
   Rename... atrem

# undo (1)...
   To Matrix
   Formula... self-1

# normalize Amp. contour by mean Amp.
   Formula... (self-am_Int)/am_Int

# remove last frame, undo (2)
   Create Matrix... atrem_besser 0 slength numbOfPoints_neu ts t_hiframe1 1 1 1 1 1 0
   for point_neu from 1 to numbOfPoints_neu
      select Matrix atrem
      spring = Get value in cell... 1 point_neu
      select Matrix atrem_besser
      Set value... 1 point_neu spring
   endfor

# to calculate autocorrelation (cc-method)
   To Sound (slice)... 1
# calculate Frequency of Ampitude Tremor [Hz]
   To Pitch (cc)... slength minTr 15 yes 0.01 tremthresh 0.01 0.35 0.14 maxTr
   Rename... atrem_norm

   atrf = Get mean... 0 0 Hertz

# calculate Intensity Index of Amplitude Tremor [%]
   select Sound atrem_besser
   plus Pitch atrem_norm
   To PointProcess (peaks)... yes no
   Rename... Maxima
   numberofMaxPoints = Get number of points
   atri_max = 0
   noAMax = 0
   for iPoint from 1 to numberofMaxPoints
      select PointProcess Maxima
      ti = Get time from index... iPoint
      select Sound atrem_besser
      atri_Point = Get value at time... 0 ti Sinc70
      if atri_Point = undefined
         atri_Point = 0
         noAMax += 1
      endif
      atri_max += abs(atri_Point)
   endfor

select Sound atrem_besser
plus PointProcess Maxima
#Edit
#pause

# atri_max:= (mean) procentual deviation of Amp. maxima from mean Amp.[Pa] at atrf
   numberofMaxima = numberofMaxPoints - noAMax
   atri_max = 100 * atri_max / numberofMaxima

   select Sound atrem_besser
   plus Pitch atrem_norm
   To PointProcess (peaks)... no yes
   Rename... Minima
   numberofMinPoints = Get number of points
   atri_min = 0
   noAMin = 0
   for iPoint from 1 to numberofMinPoints
      select PointProcess Minima
      ti = Get time from index... iPoint
      select Sound atrem_besser
      atri_Point = Get value at time... 0 ti Sinc70
      if atri_Point = undefined
         atri_Point = 0
         noAMin += 1
      endif
      atri_min += abs(atri_Point)
   endfor

select Sound atrem_besser
plus PointProcess Minima
#Edit
#pause

# atri_min:= (mean) procentual deviation of Amp. minima from mean Amp.[Pa] at atrf
   numberofMinima = numberofMinPoints - noAMin
   atri_min = 100 * atri_min / numberofMinima

   atri = (atri_max + atri_min) / 2

   atrp = atri * atrf/(atrf+1)

# uncomment to inspect amplitude tremor objects:
# pause

   select Pitch 'name$'
   plus PointProcess 'name$'_'name$'
   plus AmplitudeTier 'name$'_'name$'_'name$'
   plus TableOfReal 'name$'_'name$'_'name$'
   plus Matrix atrem_nlc
   plus Pitch atrem_nlc
   plus Pitch hilf_lincorr
   plus Pitch atrem
   plus Matrix atrem
   plus Matrix atrem_besser
   plus Sound atrem_besser
   plus Pitch atrem_norm
   plus PointProcess Maxima
   plus PointProcess Minima
   Remove
endproc