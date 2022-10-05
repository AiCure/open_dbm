from pydantic import BaseModel

class FileProperties(BaseModel):
    file_name: str = None
    file_extension: str = None
    platform: str = ''

