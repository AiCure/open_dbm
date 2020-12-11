#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 --input_path parameterA --output_path parameterB --dbm_group parameterC"
   echo -e "\t--input_path: path to the input files"
   echo -e "\t--output_path: path to the raw and derived variable output"
   echo -e "\t--dbm_group: list of feature groups"
   echo -e "\t--tr: Toggle for speech transcription(optional)"
   exit 1 # Exit script after printing help
}

while [ $# -gt 0 ]; do
  case "$1" in
    --input_path=*) input_path="${1#*=}" ;;
    --output_path=*) output_path="${1#*=}" ;;
    --dbm_group=*) dbm_group="${1#*=}" ;;
    --tr=*) tr="${1#*=}" ;;
    *) helpFunction ;;
  esac
  shift
done

# Print helpFunction in case parameters are empty
if [ -z "$input_path" ] || [ -z "$output_path" ]
then
   echo "Input or Output path is missing.";
   helpFunction
fi

#Checking input path argument
if [[ -d $input_path ]]; then
    echo "$input_path is a directory"
    input_path="$input_path/."
elif [[ -f $input_path ]]; then
    echo "$input_path is a file"
else
    echo "Error: Input path does not exist"
    exit 1
fi

#Checking output path argument
if [[ -d $output_path ]]; then
    echo "$output_path is available"
else
    mkdir -p "$output_path"
fi

#Checking dbm group input
if [[ $dbm_group == *"facial"* ]]; then
    dbm_new=" facial"
fi
if [[ $dbm_group == *"acoustic"* ]]; then
    dbm_new="$dbm_new acoustic"
fi
if [[ $dbm_group == *"movement"* ]]; then
    dbm_new="$dbm_new movement"
fi
if [[ $dbm_group == *"speech"* ]]; then
    dbm_new="$dbm_new speech"
fi
if [[ $dbm_group == *"speech"* ]] && [[ ${tr} == "on" ]]; then
    dbm_new="$dbm_new --tr ${tr}"
fi

#docker commands to run container
docker create -ti --name dbm_container dbm bash
docker cp $input_path dbm_container:/app/raw_data

docker start dbm_container
if [ -z "$dbm_new" ]
  then
    docker exec -it dbm_container /bin/bash -c "python3 -W ignore process_data.py --input_path /app/raw_data --output_path /app/output"
else
    docker exec -it dbm_container /bin/bash -c "python3 -W ignore process_data.py --input_path /app/raw_data --output_path /app/output --dbm_group$dbm_new"
fi

docker cp dbm_container:/app/output $output_path
docker stop dbm_container
docker rm dbm_container

exit
