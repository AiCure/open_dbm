---
id: odbm-rest-api
title: OpenDBM REST API
---

import Tabs from '@theme/Tabs'; import TabItem from '@theme/TabItem'; import constants from '@site/core/TabsConstants';

## Summary

Inside the OpenDBM repository, there is a folder named rest_api. This folder means to showcase that you can leverage OpenDBM library in API service or Web application, which this folder will showcase the former. 

> The OpenDBM API designed with OpenAPI 2.0 to standardize API definition for programmatic usage, better developer experience and documentation. It will also protected by standard security protocol. 

<figure>
  <img src="../docs/assets/odbm_api_summary.png" width="500" alt="OpenDBM REST API Summary" />
  <figcaption>ODBM REST API Summary</figcaption>
</figure>

## How to use

To use the Rest API is very straighforward

* Go to the `rest_api` directory
* Install the neccessary dependencies
```commandline
pip install -r requirements.txt
docker pull opendbmteam/dbm-openface
```
* Then you can use Make syntax to run it
```commandline
make dev
```
Wait until the rest api ready to serve requests
```bash
INFO:     Will watch for changes in these directories: ['/Users/smarty_not_dummy__user/open_dbm/rest_api/app']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [80258] using StatReload
INFO:     Started server process [80275]
```
* You can test using the OpenAPI specs like mentioned in [here](ci-cd-pipeline#unit-tests). You can open `http://127.0.0.1:8000/docs` or `http://127.0.0.1:8000/redoc`. 
* Before you start using the APIs, you need to create your credentials for authentication. Alternatively, you can try to use username 'aicure' and the password is 'opendbm'. 

> You can skip below steps if you want to use 'aicure' credential

* To create your own username, first you generate your own password by following these steps:
```bash
cd rest_api/app
python
Python 3.7.13 (default, Mar 28 2022, 07:24:34) 
[Clang 12.0.0 ] :: Anaconda, Inc. on darwin
Type "help", "copyright", "credits" or "license" for more information.
```
Then you can start type your own password using this python command
```python
from services.auth.auth import get_password_hash
print(get_password_hash('test'))
$2b$12$qYnAxjQd..feDyPBYa/mDuRrH.PkcpNHJk3F.l/c0h3l/1NcZup7O     
```
Save the password in the last line and your preferred username in app/services/auth/auth.py
```python
def get_db():
    fake_users_db = {
        "your_new_username": {
            "username": "your_new_username",
            "full_name": "New Full name",
            "email": "new email",
            "hashed_password": "$2b$12$qYnAxjQd..feDyPBYa/mDuRrH.PkcpNHJk3F.l/c0h3l/1NcZup7O     ",
            "disabled": False,
        },
        "aicure": {
            "username": "aicure",
            "full_name": "AiCure OpenDBM",
            "email": "opendbm@aicure.com",
            "hashed_password": "$2b$12$k4R5SPuHkjFKBsQV5gAHl.e/BlxrX2z1H3vxiB9uGtaDZLFXjggCm",
            "disabled": False,
        },
        "alice": {
            "username": "alice",
            "full_name": "Alice Wonderson",
            "email": "alice@aicure.com",
            "hashed_password": "fakehashedsecret2",
            "disabled": True,
        },
    }
    return fake_users_db
```
* After that you can login using either of these icons, or using the curl alternative

<Tabs
  defaultValue="docs"
  values={[
    {label: 'API Docs', value: 'docs'},
    {label: 'cUrl', value: 'curl'},
  ]}>
  <TabItem value="docs">
    <figure>
  <img src="../docs/assets/opendbm_auth_symbol.png" width="700" alt="OpenDBM Auth" />
  <figcaption>ODBM Auth</figcaption>
</figure>
  </TabItem>
  <TabItem value="curl">

```bash
curl 'http://127.0.0.1:8000/odbm/v1/login' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Authorization: Basic Og==' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-raw 'grant_type=password&username=aicure&password=opendbm' \
```

  </TabItem>
</Tabs>

* Start with uploading the files, put the "local" string value in the `platform` parameter, then save the upload file name. 

<Tabs
  defaultValue="docs"
  values={[
    {label: 'API Docs', value: 'docs'},
    {label: 'cUrl', value: 'curl'},
  ]}>
  <TabItem value="docs">
    <figure>
  <img src="../docs/assets/opendbm_upload_file.png" width="700" alt="OpenDBM File Uploading" />
  <figcaption>ODBM File Uploading</figcaption>
</figure>
  </TabItem>
  <TabItem value="curl">

```bash
curl 'http://127.0.0.1:8000/odbm/v1/upload?file_name=facial_speech_verbal_video_test.mp4&file_extension=mp4&platform=local' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhaWN1cmUiLCJleHAiOjE2NjI5MDM4MjB9.oYW3z44NdcBLZswxy4Vt1S2r92wYmus59NWnZYDr2CA' \
  -H 'Content-Type: multipart/form-data; ' \
  -H 'accept: application/json' \
  --data-raw $'Content-Disposition: form-data; name="file"; filename="facial_speech_verbal_video_test.mp4" Content-Type: video/mp4 \
  --compressed
  ```

  </TabItem>
</Tabs>

The API response will be 
```json
{
  "info": "file 'facial_speech_verbal_video_test.mp4' saved at 'files/facial_speech_verbal_video_test.mp4'"
}
```
Save the file location returned somewhere `files/facial_speech_verbal_video_test.mp4`

* Then you can use any API you want, insert the previous upload file url into `file_url` parameter. Then you can specify variables you want to get. For example, if you use the `/video/acoustic` API, you can specify the request body like 
```json
[
    "audio_intensity",
    "pitch_frequency"
]
```

<Tabs
  defaultValue="docs"
  values={[
    {label: 'API Docs', value: 'docs'},
    {label: 'cUrl', value: 'curl'},
  ]}>
  <TabItem value="docs">
    <figure>
  <img src="../docs/assets/opendbm_acoustic.png" width="700" alt="OpenDBM Test Acoustic API" />
  <figcaption>ODBM Test Acoustic API</figcaption>
</figure>
  </TabItem>
  <TabItem value="curl">

```bash
curl 'http://127.0.0.1:8000/odbm/v1/video/acoustic?file_url=files%2Ffacial_speech_verbal_video_test.mp4&platform=local' \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhaWN1cmUiLCJleHAiOjE2NjI5MDkwMzd9.RQgtXhPCcgzctfuNg2GbByR9OMdr1vWTerl1iKPWqfk' \
  -H 'Content-Type: application/json' \
  -H 'accept: application/json' \
  --data-raw $'[\n    "audio_intensity",\n    "pitch_frequency"\n]' \
  --compressed
```

  </TabItem>
</Tabs>


After you execute the API, you will get the zip file, with the csv results compressed inside that file
> You can check more details on rest_api usage in `rest_api/README.md`

## Technology Stack
<figure>
  <img src="../docs/assets/odbm_tech_stack.png" width="500" alt="OpenDBM REST API Technology Stack" />
  <figcaption>ODBM REST API Technology Stack</figcaption>
</figure>

The OpenDBM API will use FastAPI framework. The main reason is because the asynchronous behaviour of FastAPI will works perfectly to complex and high performance methods like data upload, data pre / processing and other possible long operations.

We also use Uvicorn is an ASGI web server implementation for Python. Until recently Python has lacked a minimal low-level server/application interface for async frameworks. The ASGI specification fills this gap, and means we're now able to start building a common set of tooling usable across all async frameworks. Uvicorn currently supports HTTP/1.1 and WebSockets.

## API Documentations
The Rest API documentations can be found when you run the the app. Change the relative path to /docs or /redoc
<figure>
  <img src="../docs/assets/odbm_api_docs.png" width="500" alt="OpenDBM REST API Swagger API Docs" />
  <figcaption>ODBM REST API Swagger API Docs</figcaption>

  <img src="../docs/assets/odbm_redocs.png" width="500" alt="OpenDBM REST API Redocs" />
  <figcaption>ODBM REST API Redocs</figcaption>
</figure>