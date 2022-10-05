from config.database import get_db
from fastapi import APIRouter, Depends, File, UploadFile
from fastapi.responses import FileResponse
from fastapi.security import OAuth2PasswordRequestForm
from schemas.biomaker_request import BiomakerRequest
from schemas.file_properties import FileProperties
from schemas.token import Token
from services.auth.auth import get_current_active_user, login
from services.biomaker.biomaker import BiomakerService
from services.file.file import get_file_service
from services.file.i_file import FileService
from utils.service_result import handle_result

db = get_db()
api_version = "v1"

auth_router = APIRouter(
    prefix="/odbm/" + api_version,
    tags=["Open DBM Authentication"],
    responses={404: {"description": "Not found"}},
)

router = APIRouter(
    prefix="/odbm/" + api_version,
    tags=["Open DBM APIs"],
    dependencies=[Depends(get_current_active_user)],
    responses={404: {"description": "Not found"}},
)


@auth_router.post("/login", response_model=Token)
async def auth_login(form_data: OAuth2PasswordRequestForm = Depends()):
    result = login(form_data)
    return result


@router.post("/upload")
async def upload(
    file_properties: FileProperties = Depends(), file: UploadFile = File(...)
):
    file_service: FileService = get_file_service(file_properties.platform)
    result = file_service.upload(file_properties, file)
    return result


@router.post("/video/facial")
async def video_facial(biomaker_request: BiomakerRequest = Depends()):
    result, file_name = BiomakerService().process("facial", biomaker_request)
    return FileResponse(path=result, filename=f"{file_name}.zip")


@router.post("/video/acoustic")
async def video_acoustic(biomaker_request: BiomakerRequest = Depends()):
    result, file_name = BiomakerService().process("acoustic", biomaker_request)
    return FileResponse(path=result, filename=f"{file_name}.zip")


@router.post("/video/movement")
async def video_movement(biomaker_request: BiomakerRequest = Depends()):
    result, file_name = BiomakerService().process("movement", biomaker_request)
    return FileResponse(path=result, filename=f"{file_name}.zip")


@router.post("/video/speech")
async def video_speech(biomaker_request: BiomakerRequest = Depends()):
    result, file_name = BiomakerService().process("speech", biomaker_request)
    return FileResponse(path=result, filename=f"{file_name}.zip")


@router.post("/audio/acoustic")
async def audio_acoustic(biomaker_request: BiomakerRequest = Depends()):
    result, file_name = BiomakerService().process("acoustic", biomaker_request)
    return FileResponse(path=result, filename=f"{file_name}.zip")


@router.post("/audio/speech")
async def audio_speech(biomaker_request: BiomakerRequest = Depends()):
    result, file_name = BiomakerService().process("speech", biomaker_request)
    return FileResponse(path=result, filename=f"{file_name}.zip")
