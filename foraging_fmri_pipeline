################ foraging project pipeline for fMRI data pre-processing and analyses ################
################ by Xin Sui, last edited November 2019 ################



# Data cleaning
- Delete subjects? -- irrelevant for the test analysis (on only one subject)
- Horos gives multiple structural scans; want to use the last T1w_combEcho and last T2w (not T2w_clinical) and remove the extra T1w and T2w files (otherwise BIDS will identify them as different runs, and fmriprep will carry this through)
- To check which subjects have all scans:
```
for d in */ ; do ls -d $d/T1w_* ; done

for d in */ ; do ls -d $d/PosDisp_* ; done
```

## Initial organization of the BIDS dataset directory
- Move files to drive/folder where pre-processing will happen
- Make sure subject data files are in a subfolder called sourcedata (project_name/sourcedata/subjectID/sessionIdentifier/DICOMfiles)

## BIDS Conversion using bidskit
- see Github/jmtyszka/bidskit/docs/QuickStart.md (https://github.com/jmtyszka/bidskit/blob/master/docs/QuickStart.md)

### First Pass Conversion
```
% cd /Volumes/mobbsBrains/xin/anxiety_fmri
% bidskit (use argument `--no-sessions` if necessary)
```

### Editing the Translator Dictionary (code/Protocol_Translator.json)
- First field is BIDS directory (match to data type: 'anat', 'func', etc)
- Second field is filename suffix (copy the file name)
- Third field is 'IntendedFor'(for fmap, link with the associated BOLD series)
- NOTE: names must confirm to esoteric BIDS naming conventions. See [BIDS Specification](https://bids.neuroimaging.io/bids_spec.pdf) or ask someone for a template .json**

### Second Pass Conversion
```
% bidskit (with same arguments)
```

### BIDS QC
- To run quality control on every subject and at the group level:
```
docker run -it --rm -v [input path]:/data:ro -v [output path]:/out poldracklab/mriqc:latest /data /out participant
```
- Individual participants can be run by appending the argument `--participant_label` and the subject number
- use `docker stats` at any time to monitor CPU and RAM usage**


## fMRIPrep
- Run:
```
time fmriprep-docker /Users/mobbslab/Documents/xin/foraging_fmri_for20for23 /Users/mobbslab/Documents/xin/foraging_fmri_for20for23/derivatives participant --nthreads 2 --fs-license-file /Users/mobbslab/Documents/license.txt --fs-no-reconall ; afplay /System/Library/Sounds/Blow.aiff -v 100 |& tee -a foraging_for20for23_local2threads_CMDoutput.txt
```
i.e.
```
time ##to timestamp the process##
fmriprep-docker 
/Users/mobbslab/Documents/xin/foraging_fmri_for20for23 ##first argument: bids_dir, i.e. the root folder of a BIDS valid dataset (sub-XXXXX folders should be found at the top level in this folder)##
/Users/mobbslab/Documents/xin/foraging_fmri_for20for23/derivatives ##second argument: output_dir. i.e. the output path for the outcomes of preprocessing and visual reports##
participant ##third argument: analysis_level, i.e. the processing stage to be run, only “participant” in the case of FMRIPREP (see BIDS-Apps specification)##
--nthreads 2 ##flag to limit the maximum number of threads across ALL processes##
--fs-license-file /Users/mobbslab/Documents/license.txt ##flag to indicate the path to freesurfer license file##
--fs-no-reconall ##flag to turn off fressurfer surface reconstruction (takes too long)##
; afplay /System/Library/Sounds/Blow.aiff -v 100 ##plays notification tone when completed
|& tee -a foraging_for15_d2_CMDoutput.txt ##saves the command line outputs into a .txt file in /Users/mobbslab/
```

- to display and save docker stats on CPU and RAM/memory usage run:
```
docker stats |& tee -a foraging_for20for23_local2threads_dockerstats.txt
```
-------------------------------------------------------------------------






## Smoothing
- First choose a fwhm kernel size (sigma = mm / 2.35482004503)
- E.g. for a 8mm FWHM, sigma = 3.397
- Command for a single subject is:\
```
fslmaths inputFile -kernel gauss 3.397 -fmean outputFile
```


## Masking
```
fslmaths inputFile -mul maskPath outputFile
```

- A batch script for smoothing and masking can be found with this guide (you will need to edit the paths, subject list, and sigma)

## Design files
- To run final stats, we need to set up the design files externally
- FSL takes a 3 column (onset, duration, value) format

## First level (runs within subject)

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

