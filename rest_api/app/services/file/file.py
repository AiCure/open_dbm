import os
import shutil
from fastapi import UploadFile
import boto3

from schemas.file_properties import FileProperties
from services.file.i_file import FileService

AWS_ACCESS_KEY = os.getenv('AWS_ACCESS_KEY', 'DUMMY_KEY')
AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY', 'DUMMY_SECRET')
S3_BUCKET_NAME = 'odbm-test'

def get_file_service(platform:str) -> FileService:
    if platform.lower() == 's3':
        return S3FileService()
    else:
        return MemoryFileService()


client = boto3.client(
    's3',
    aws_access_key_id=AWS_ACCESS_KEY,
    aws_secret_access_key=AWS_SECRET_KEY
)

s3 = boto3.resource(
    's3',
    aws_access_key_id=AWS_ACCESS_KEY,
    aws_secret_access_key=AWS_SECRET_KEY
)

class S3FileService(FileService):
    def upload(self, file_properties: FileProperties, file: UploadFile):
        print(AWS_ACCESS_KEY)
        print(AWS_SECRET_KEY)
        s3 = boto3.resource("s3")
        bucket = s3.Bucket(S3_BUCKET_NAME)
        bucket.upload_fileobj(file.file, file.filename, ExtraArgs={"ACL": "public-read"})
        uploaded_file_url = f"https://{S3_BUCKET_NAME}.s3.amazonaws.com/{file.filename}"
        return {"returnUrl": uploaded_file_url}

    def download(file_properties: FileProperties):
        pass

class MemoryFileService(FileService):
    def upload(self, file_properties: FileProperties, file: UploadFile):
        file_location = f"files/{file.filename}"
        with open(file_location, "wb+") as file_object:
            shutil.copyfileobj(file.file, file_object)    
        return {"info": f"file '{file.filename}' saved at '{file_location}'"}

    def download(file_properties: FileProperties):
        pass