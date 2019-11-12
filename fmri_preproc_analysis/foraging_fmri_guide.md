- ####### foraging project pipeline for fMRI data pre-processing and analysis #######
- ####### by Xin Sui, last edited November 2019 #######


# Data Cleaning
- Copy data from Horos
- Delete subjects with incomplete data
- Delete files for fear localizer task
- Rearrange folders in case of make-up sessions
- Re: T1w & T2w - Horos gives multiple structural scans; use the last T1w_combEcho and last T2w (NOT T2w_clinical) and remove the extra T1w and T2w files (otherwise BIDS will identify them as different runs, and fmriprep will carry this through)
- To check which subjects have all scans:
```
for d in */ ; do ls -d $d/T1w_* ; done

for d in */ ; do ls -d $d/PosDisp_* ; done
```


# BIDS Conversion

## Initial Organization of the BIDS Dataset Directory
- Move files to the drive/folder where pre-processing will happen
- Make sure subject data files are in a subfolder called "sourcedata" 
- Directory hierachy: project_name/sourcedata/subjectID/sessionIdentifier/DICOMfiles

## BIDS Conversion using bidskit
- see Github/jmtyszka/bidskit/docs/QuickStart.md (https://github.com/jmtyszka/bidskit/blob/master/docs/QuickStart.md)

### First Pass Conversion
```
% cd /Users/mobbslab/Documents/xin/foraging_fmri_??????
% bidskit (use argument `--no-sessions` if necessary)
```

### Edit the Translator Dictionary (code/Protocol_Translator.json)
- First field is BIDS directory (match to data type: 'anat', 'func', etc)
- Second field is filename suffix (copy the file name)
- Third field is 'IntendedFor'(for fmap, link with the associated BOLD series)
- NOTE: names must confirm to esoteric BIDS naming conventions. See [BIDS Specification](https://bids.neuroimaging.io/bids_spec.pdf) or ask someone for a 
- I created a template Protocol_Translator.json which is included in this github repository

### Second Pass Conversion
```
% bidskit (with same arguments under the same directory as the first pass)
```

## BIDS Quality Control
- To run quality control on every subject and at the group level:
```
docker run -it --rm -v [input path]:/data:ro -v [output path]:/out poldracklab/mriqc:latest /data /out participant
```
- Individual participants can be run by appending the argument `--participant_label` and the subject number
- use `docker stats` at any time to monitor CPU and RAM usage


# Preprocessing using fMRIPrep
- Run:
```
time fmriprep-docker /Users/mobbslab/Documents/xin/foraging_fmri_?????? /Users/mobbslab/Documents/xin/foraging_fmri_??????/derivatives participant --nthreads 4 --fs-license-file /Users/mobbslab/Documents/license.txt --fs-no-reconall ; afplay /System/Library/Sounds/Blow.aiff -v 100 |& tee -a foraging_??????_local2threads_CMDoutput.txt
```
- Breakdown of the command:
```
time  #to timestamp the process#

fmriprep-docker  #main function#

/Users/mobbslab/Documents/xin/foraging_fmri_??????  #first argument: bids_dir, i.e. the root folder of a BIDS valid dataset (sub-XXXXX folders should be found at the top level in this folder)#

/Users/mobbslab/Documents/xin/foraging_fmri_??????/derivatives  #second argument: output_dir. i.e. the output path for the outcomes of preprocessing and visual reports#

participant  #third argument: analysis_level, i.e. the processing stage to be run, only “participant” in the case of FMRIPREP (see BIDS-Apps specification)#

--nthreads 4  #flag to limit the maximum number of threads across ALL processes. based on testing results 4 appears to be the optimal on mobbsimaging computer#

--fs-license-file /Users/mobbslab/Documents/license.txt  #flag to indicate the path to freesurfer license file#

--fs-no-reconall  #flag to turn off fressurfer surface reconstruction (takes too long)#

; afplay /System/Library/Sounds/Blow.aiff -v 100  #plays notification tone when completed#

|& tee -a foraging_??????_CMDoutput.txt  #saves the command line outputs into a .txt file in /Users/mobbslab/#
```

- To monitor and save docker stats on CPU and RAM usage, run:
```
docker stats |& tee -a foraging_??????_dockerstats.txt
```


# Single-Voxel Analysis Using SPM

## 1st Level i.e. Within Subject
- I created a template batch file which is included in this github repository


## Second level (means of subject)
- FEAT will complain that registration hasn't been completed. To fix this, we first need to create dummy folders
- run one subject through a normal FEAT analysis (first level)
- in the "reg" subdirectory that it produces:
- replace all the *.mat files with a copy of $FSLDIR/etc/flirtsch/ident.mat (do not delete these files or change their name)
- delete all the *warp* files
- run updatefeatreg in the feat directory

## Third level (group)
- To get all the cope directories, use:
```
find "$(cd ..; pwd)" -type d -name "cope1.feat"> groupList.txt
```
- Can replace "cope1.feat" with whichever analysis we want to run

