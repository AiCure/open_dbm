def get_db():
    fake_users_db = {
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