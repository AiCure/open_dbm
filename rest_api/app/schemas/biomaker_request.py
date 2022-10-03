from pydantic import BaseModel

class BiomakerRequest(BaseModel):
    file_url: str
    platform: str
    variables: list = []
