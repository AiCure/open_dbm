# DBM Open Source Lib

---------------------------------------------
Installation - Dev Mode
---------------------------------------------

- Clone repo from github

        git clone https://github.com/AiCure/open_dbm.git
        
- Prepare a python 3 virtualenv

        pip install virtualenv (optional, only needed if it's not installed)
        virtualenv <your_env_name>
        source <your_env_name>/bin/activate
        
- Install package

        pip install -r requirements.txt
        sudo apt-get -y install ffmpeg
        
- Install Openface 2.0.6 (follow below installation steps)

        cd pkg/OpenFace
        bash download_models.sh
        bash install.sh
        
---------------------------------------------       
Documentation
---------------------------------------------
   
Please add documentation link here
   
---------------------------------------------       
Example usage
---------------------------------------------

- Process video/audio file

        python process_file.py --input_path abc.mp4 --output_raw_path data/output --output_derived_path output/derived --dbm_group acoustic facial movement
        
    
- Process multiple files in a directory

        python process_dir.py --input_path abc/ --output_raw_path data/output --output_derived_path output/derived --dbm_group acoustic facial movement

```
where,

    input_path: Required – Path of the file being processed. This can be either an .mp4 file or a .wav file.
    output_raw_path: Required – Path where the raw variable data will be stored.
    output_derived_path: Optional - Path to store derived variable. If not specified, derived variables won't be calculated.
    dbm_group: Optional – 
    Type of variables to calculate. If not specified, all variables will be calculated. The following inputs are acceptable:
    
        - facial, in which case only facial variables are calculated
        - acoustic, in which case only acoustic variables are calculated
        - movement, in which case only movement variables are calculated
    
    If the input_path was a .wav file, then only acoustic variables can be calculated. If otherwise, a warning message will be printed.
    
```