---
id: basic-usage
title: Basic Usage
---



#### Prerequisites read
* [Dependencies Installation](dependencies-installation)
* [OpenFace Installation](openface-docker-installation)
* Make sure to install the distribution package first.




```commandline
pip install opendbm
```

In this section, we are gonna show the basic instruction on how to get biomarker variable from OpenDBM API

```python
from opendbm import Movement

# code below is how to access to other dbm groups
# from opendbm import FacialActivity, VerbalAcoustics, Speech
```


```python
path = "movement_video_test.mp4"
```


```python
#initiate the model
model = Movement()
```


```python
#Feed input data to the model
model.fit(path)
```


After we processed the data with our model, now we can get all biomarker variables related to the Movement category


```python
#Get facial tremor
tremor = model.get_facial_tremor()
tremor.to_dataframe().T
```




<div>

<table border="1" class="dataframe" style={{width:'50%',}}>
  <thead>
    <tr style={{textAlign:'right',}}>
      <th></th>
      <th>0</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>fac_features_mean_5</th>
      <td>8.594771</td>
    </tr>
    <tr>
      <th>fac_tremor_median_5</th>
      <td>3.87593</td>
    </tr>
    <tr>
      <th>fac_disp_median_5</th>
      <td>0.728575</td>
    </tr>
    <tr>
      <th>fac_corr_5</th>
      <td>0.254649</td>
    </tr>
    <tr>
      <th>fac_features_mean_12</th>
      <td>3.719481</td>
    </tr>
    <tr>
      <th>fac_tremor_median_12</th>
      <td>2.806784</td>
    </tr>
    <tr>
      <th>fac_disp_median_12</th>
      <td>0.723145</td>
    </tr>
    <tr>
      <th>fac_corr_12</th>
      <td>0.456196</td>
    </tr>
    <tr>
      <th>fac_features_mean_8</th>
      <td>6.721486</td>
    </tr>
    <tr>
      <th>fac_tremor_median_8</th>
      <td>3.586131</td>
    </tr>
    <tr>
      <th>fac_disp_median_8</th>
      <td>0.825251</td>
    </tr>
    <tr>
      <th>fac_corr_8</th>
      <td>0.391167</td>
    </tr>
    <tr>
      <th>fac_features_mean_48</th>
      <td>2.860846</td>
    </tr>
    <tr>
      <th>fac_tremor_median_48</th>
      <td>2.174091</td>
    </tr>
    <tr>
      <th>fac_disp_median_48</th>
      <td>0.86145</td>
    </tr>
    <tr>
      <th>fac_corr_48</th>
      <td>0.646405</td>
    </tr>
    <tr>
      <th>fac_features_mean_54</th>
      <td>3.678142</td>
    </tr>
    <tr>
      <th>fac_tremor_median_54</th>
      <td>2.669815</td>
    </tr>
    <tr>
      <th>fac_disp_median_54</th>
      <td>0.886973</td>
    </tr>
    <tr>
      <th>fac_corr_54</th>
      <td>0.578275</td>
    </tr>
    <tr>
      <th>fac_features_mean_28</th>
      <td>0.0</td>
    </tr>
    <tr>
      <th>fac_tremor_median_28</th>
      <td>0.0</td>
    </tr>
    <tr>
      <th>fac_disp_median_28</th>
      <td>0.677184</td>
    </tr>
    <tr>
      <th>fac_corr_28</th>
      <td>1.0</td>
    </tr>
    <tr>
      <th>fac_features_mean_51</th>
      <td>0.765473</td>
    </tr>
    <tr>
      <th>fac_tremor_median_51</th>
      <td>0.54762</td>
    </tr>
    <tr>
      <th>fac_disp_median_51</th>
      <td>0.750383</td>
    </tr>
    <tr>
      <th>fac_corr_51</th>
      <td>0.897752</td>
    </tr>
    <tr>
      <th>fac_features_mean_66</th>
      <td>1.971278</td>
    </tr>
    <tr>
      <th>fac_tremor_median_66</th>
      <td>1.49907</td>
    </tr>
    <tr>
      <th>fac_disp_median_66</th>
      <td>0.938139</td>
    </tr>
    <tr>
      <th>fac_corr_66</th>
      <td>0.776121</td>
    </tr>
    <tr>
      <th>fac_features_mean_57</th>
      <td>2.70601</td>
    </tr>
    <tr>
      <th>fac_tremor_median_57</th>
      <td>2.019033</td>
    </tr>
    <tr>
      <th>fac_disp_median_57</th>
      <td>0.988482</td>
    </tr>
    <tr>
      <th>fac_corr_57</th>
      <td>0.713824</td>
    </tr>
    <tr>
      <th>error_reason</th>
      <td></td>
    </tr>
  </tbody>
</table>
</div>




```python
##Get Eye Blink
eye_blink = model.get_eye_blink()
eye_blink.to_dataframe()
```




<div>

<table border="1" class="dataframe" style={{width:'50%',}}>
  <thead>
    <tr style={{textAlign:'right',}}>
      <th></th>
      <th>mov_blink_ear</th>
      <th>vid_dur</th>
      <th>fps</th>
      <th>mov_blinkframes</th>
      <th>mov_blinkdur</th>
      <th>dbm_master_url</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.124566</td>
      <td>33.877313</td>
      <td>29</td>
      <td>19</td>
      <td>0.655172</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.125343</td>
      <td>33.877313</td>
      <td>29</td>
      <td>49</td>
      <td>1.034483</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.108713</td>
      <td>33.877313</td>
      <td>29</td>
      <td>120</td>
      <td>2.448276</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.097553</td>
      <td>33.877313</td>
      <td>29</td>
      <td>169</td>
      <td>1.689655</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.111874</td>
      <td>33.877313</td>
      <td>29</td>
      <td>241</td>
      <td>2.482759</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0.077082</td>
      <td>33.877313</td>
      <td>29</td>
      <td>328</td>
      <td>3.000000</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>6</th>
      <td>0.124804</td>
      <td>33.877313</td>
      <td>29</td>
      <td>387</td>
      <td>2.034483</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>7</th>
      <td>0.082149</td>
      <td>33.877313</td>
      <td>29</td>
      <td>506</td>
      <td>4.103448</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>8</th>
      <td>0.083041</td>
      <td>33.877313</td>
      <td>29</td>
      <td>550</td>
      <td>1.517241</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>9</th>
      <td>0.148836</td>
      <td>33.877313</td>
      <td>29</td>
      <td>687</td>
      <td>4.724138</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>10</th>
      <td>0.099926</td>
      <td>33.877313</td>
      <td>29</td>
      <td>734</td>
      <td>1.620690</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>11</th>
      <td>0.083078</td>
      <td>33.877313</td>
      <td>29</td>
      <td>809</td>
      <td>2.586207</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>12</th>
      <td>0.124501</td>
      <td>33.877313</td>
      <td>29</td>
      <td>847</td>
      <td>1.310345</td>
      <td>movement_video_test.mp4</td>
    </tr>
    <tr>
      <th>13</th>
      <td>0.149668</td>
      <td>33.877313</td>
      <td>29</td>
      <td>931</td>
      <td>2.896552</td>
      <td>movement_video_test.mp4</td>
    </tr>
  </tbody>
</table>
</div>
