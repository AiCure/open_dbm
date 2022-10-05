# OpenDBM REST API

This project only purpose is to expose OpenDBM library functionalities to REST API.

## Installation

```bash
pip install
```

For other OS installation other than linux, follow the openDBM installation method in the documentation

## Makefile

```bash
make dev # run uvicorn with restart
```

## Usage

1. Before using the openDBM api, you have to create credentials, and save it to app/config/db.py. Add your username and generate your hash password using method get_password_hash in app/services/auth/auth.py. Then you can save into db.py
We already create user if you want to straight away testing. User: aicure Password: opendbm
You can set the token expiration configuration in TOKEN_EXPIRE variable
2. You can try to execute the API using swagger docs in http(s)://hostname/docs
3. You can upload the raw file using /upload api, insert your file name and extension, and put value "local" into the platform parameter. You will get the response of the file path that you will use in other openDBM APIs
4. In other openDBM APIs, for query string, put "local" to platform parameter, put the file path into file_url parameter.
Lastly put the openDBM variables as JSON as your payload. See app/services/biomaker/biomaker.py or audio.py for the list of variables you can get
