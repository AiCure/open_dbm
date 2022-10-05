from sqlalchemy.orm import Session
from config.db import get_db

user_db = get_db()

class DBSessionContext(object):
    def __init__(self, db: Session):
        self.db = db


class AppService(DBSessionContext):
    pass


class AppCRUD(DBSessionContext):
    pass

class OpenDBMSessionContext(object):
    def __init__(self):
        self.db = user_db
