# Docker building instructions

This image can be build with just `docker`, but it is highly recommend to use 
`docker-compose` as this greatly simplifies and improves the process.  

## Quick start

To start with the container hosted by the repo maintainer, run  

`docker run -it --rm --name openface algebr/openface:latest`

This will drop you into a shell with binaries such as FaceLandmarkImg. For example,
try this code (in the container):

```bash
curl -o tesla.jpg https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Nicola_Tesla_LCCN2014684845.jpg/559px-Nicola_Tesla_LCCN2014684845.jpg 
FaceLandmarkImg -f tesla.jpg
```

Then, copy the output to the host system (from host terminal):

```bash
docker cp openface:/root/processed /tmp/
cd /tmp/processed
```

Tip: On Ubuntu and other *nixes with X running, you can open a file directly 
like this:
```bash
xdg-open /tmp/processed/tesla.jpg
``` 

## Building

In repo root, run `docker-compose build` to automatically build and tag. 
There are two variables which can be used to modify the tag, `$DOCKERUSER` and
`$DOCKERTAG`. DC will automatically tag image as 
`${DOCKERUSER}/openface:${DOCKERTAG}`

## OpenFace service (in progress)

To run OpenFace like a service, you can start the container with bind mounts 
in order to pass data into and out of the container easily. 
`$DATA_MOUNT` by default is set to `/tmp/openface`. This can be overridden by 
modifying `.env` file, setting it in your shell environment, or passing in 
before `docker-compose` at runtime. Note: output will be `root` owner. 

```bash
export DATA_MOUNT=/tmp/openface
mkdir -p $DATA_MOUNT/tesla # this is just to ensure this is writable by user
docker-compose up -d openface && sync # sync is to wait till service starts
curl -o $DATA_MOUNT/tesla.jpg \
    https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Nicola_Tesla_LCCN2014684845.jpg/559px-Nicola_Tesla_LCCN2014684845.jpg
docker exec -it openface FaceLandmarkImg -f $DATA_MOUNT/tesla.jpg -out_dir $DATA_MOUNT/tesla
docker exec -it openface chown -R $UID:$UID $DATA_MOUNT # chown to current user
docker-compose down # stop service if you wish
```
