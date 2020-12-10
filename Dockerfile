FROM python:3.6
FROM ubuntu:18.04

MAINTAINER fnndsc "vijay.yadav@aicure.com"

RUN apt-get update && apt-get install -y python3-pip \
                   && apt-get install -y wget \
                   && apt-get install -y automake --upgrade \
                   && apt-get install -y libtool --upgrade \
                   && apt-get -y install ffmpeg \
                   && apt-get install -y lsb-core \
                   && apt-get install -y libavcodec-dev \
                   && apt-get install -y libavformat-dev \
                   && apt-get install -y libavdevice-dev \
                   && apt-get install -y libboost-all-dev \
                   && apt-get install -y git \
                   && apt-get install -y sox
RUN ln -sfn /usr/bin/pip3 /usr/bin/pip

COPY . /app

RUN echo "Installing OpenFace..."
WORKDIR /app/pkg/OpenFace
RUN bash ./download_models.sh
RUN dpkg --configure -a
RUN su -c ./install.sh
RUN echo "Done OpenFace!"

RUN echo "Cloning DeepSpeech..."
WORKDIR /app/pkg
RUN git clone https://github.com/mozilla/DeepSpeech.git

WORKDIR /app/pkg/DeepSpeech
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.1/deepspeech-0.9.1-models.pbmm
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.1/deepspeech-0.9.1-models.scorer

WORKDIR /app
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN echo "Requirement txt done!"

CMD [ "python", "./process_data.py" ]