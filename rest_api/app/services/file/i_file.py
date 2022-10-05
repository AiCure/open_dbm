from fastapi import UploadFile
from abc import ABCMeta, abstractmethod
from schemas.file_properties import FileProperties


class FileService:
    __metaclass__ = ABCMeta

    @abstractmethod
    def upload(file_properties: FileProperties, file: UploadFile): raise NotImplementedError

    @abstractmethod
    def download(file_properties: FileProperties): raise NotImplementedError