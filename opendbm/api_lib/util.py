# import urllib, os
import logging
import os
import platform
import subprocess
import tempfile
import urllib.request as ur

from tqdm import tqdm

from opendbm.dbm_lib.controller import process_feature as pf

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


# urllib = getattr(urllib, 'request', urllib)


class TqdmUpTo(tqdm):
    """Provides `update_to(n)` which uses `tqdm.update(delta_n)`."""

    def update_to(self, b=1, bsize=1, tsize=None):
        """
        b  : int, optional
            Number of blocks transferred so far [default: 1].
        bsize  : int, optional
            Size of each block (in tqdm units) [default: 1].
        tsize  : int, optional
            Total size (in tqdm units). If [default: None] remains unchanged.
        """
        if tsize is not None:
            self.total = tsize
        return self.update(b * bsize - self.n)  # also sets self.n = b * bsize


def download_url(url, local_path):
    """
    Function to download url and drop it to the local path
    """
    with TqdmUpTo(
        unit="B",
        unit_scale=True,
        unit_divisor=1024,
        miniters=1,
        desc=url.split("/")[-1],
    ) as t:  # all optional kwargs
        ur.urlretrieve(url, filename=local_path, reporthook=t.update_to, data=None)
        t.total = t.n


def wsllize(path):
    """
    Add WSL prefix if the platform using windows.
    This function will also convert input path to wsl structure based on given  path.
    Args:
        path: path of the input data

    Returns:
        wsl prefix
    """
    if platform.system() == "Windows":
        wsl_cmd = ["wsl"]
        path = subprocess.check_output(["wsl", "wslpath", repr(path)]).decode("utf-8")
        if path.endswith("\n"):
            path = path[:-1]
        return wsl_cmd, path
    else:
        return [], path


def check_isfile(path):
    if not os.path.isfile(path):
        raise FileNotFoundError("File not found. Make sure specify the correct path")


def check_file(path):
    """
    Check if file is in wav format. if not, convert to wav.
    Args:
        path: Input path

    Returns:
        path: output path of the new wav file
        bool: returns True if file is wav format
    """
    return (
        (pf.audio_to_wav(path, tmp=True), False)
        if not path.endswith(".wav")
        else (path, True)
    )


def check_docker_model_exist(wsl_cmd, model_name):
    """
    check if docker model is present or not.

    Args:
        wsl_cmd: wsl prefix is platform is Windows
        model_name: self-explanatory

    """

    try:
        check_docker_model_exist = subprocess.check_output(
            wsl_cmd + ["docker", "image", "ls"]
        ).decode("utf-8")
        if model_name not in check_docker_model_exist:
            raise FileNotFoundError(
                f"""
                {model_name} model not found. Make sure to
                download the model first. For further instruction about download,
                please see our web documentation.
                """
            )
    except subprocess.CalledProcessError:
        raise EnvironmentError("Make sure to set the Docker to be active")


def docker_command_dec(fn):
    """
    Decorator to execute model in Docker environment.
    Starting the container and exit state is handled here
    Args:
        fn: any fn that need to access docker

    Returns:
        decorated fn
    """
    import os

    def inner(*args, **kwargs):
        wsl_cmd, path = wsllize((args[1]))

        check_docker_model_exist(wsl_cmd, "dbm-openface")

        create_docker = wsl_cmd + [
            "docker",
            "create",
            "-ti",
            "--name",
            "dbm_container",
            "dbm-openface",
            "bash",
        ]

        copy_file_to_docker = wsl_cmd + ["docker", "cp", path, "dbm_container:/app/"]
        start_container = wsl_cmd + ["docker", "start", "dbm_container"]
        terminate_container = wsl_cmd + ["docker", "stop", "dbm_container"]
        remove_container = wsl_cmd + ["docker", "rm", "dbm_container"]

        subprocess.Popen(
            create_docker,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            stdin=subprocess.PIPE,
        ).wait()
        subprocess.Popen(
            copy_file_to_docker,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            stdin=subprocess.PIPE,
        ).wait()
        subprocess.Popen(
            start_container,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            stdin=subprocess.PIPE,
        ).wait()

        try:

            args = args[0], "/app/" + os.path.basename(args[1]), args[2]

            result = fn(*args, **kwargs)

            return result
        except Exception as e:

            logger.info(f"Failed: {e}")

        finally:
            subprocess.Popen(
                terminate_container,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                stdin=subprocess.PIPE,
            ).wait()
            subprocess.Popen(
                remove_container,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                stdin=subprocess.PIPE,
            ).wait()

    return inner
