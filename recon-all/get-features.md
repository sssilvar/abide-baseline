## Generating table of features from FreeSurfer Output

There exists two commands inside freesurfer suite to do this task: `aparcstarts2table` 
which extracts cortical features such as: thickness, curvature, area. 
And `asegstats2table` which extract subcortical volumes.

Both commands extract info from left and right hemispheres separately. As well as the feature types. So, 
we need to create two nested for loops: one iterating over the hemispheres (lh, rh) and the other over 
the features/meassures (area, thickness, etc.).

**It is important** to declare the `SUBJECTS_DIR` variable with the path of the process dataset
by executing:
```bash
export SUBJECTS_DIR=/path-to-freesurfer-processed-dataset/
```
Also you can `cd` into the directory and then execute:
```bash
export SUBJECTS_DIR=$(pwd)
``` 

For cortical features:
```bash
export SUBJECTS_DIR=$(pwd)
for hemi in lh rh; do \
    for meas in area volume thickness thicknessstd meancurv gauscurv foldind curvind; do \
        eval "aparcstats2table --subjectsfile subjects.txt --skip --delimiter comma --hemi ${hemi} --meas ${meas} --tablefile ${hemi}_${meas}_aparc_stats.csv"; \
    done \
done
``` 

For subcortical features:
```bash
export SUBJECTS_DIR=$(pwd)
for meas in volume mean; do  # Iterate over volume and mean intensity  \
    eval "asegstats2table --subjectsfile subjects.txt --skip --delimiter comma --meas ${meas} --tablefile ${meas}_aseg_stats.csv"; \
done
``` 

If you don't know how to create the `subjects.txt` file, the simplest way is to go to the directory of your processed subjects and execute:
```
ls > subjects.txt
```

## Combine the features in a single dataset using
```bash
curl -L "https://bit.ly/fs_join" | python -
```

## Check for subjects that presented errors during the pipeline
Some subjects might have not passed the quality check or did not converge during the process of segmentation from FreeSurfer.
To identify them, we have to check the log file `recon-all.log` which is found inside each processed subject folder `scripts`.

The process would be then to find all the files named `recon-all.log`. Then, extract the last lines of these files using `tail`,
and filtering them by the string `"with ERRORS"`. This will extract a message that looks like this:
```
recon-all -s 50335 finished without error at Fri Sep 18 19:49:50 CEST 2020
```
Where `50335` is the ID of the subject processed. This is why we need to extract only yhe third element using space as a separator.
This is achieved using `awk`. The `BEGIN` section adds a header to then use it as a CSV file. At the end the commands would look like:

```bash
cd $SUBJECTS_DIR  # Or cd to directory where the processed subjects are.
find . -name "recon-all.log" -exec tail {} \; | grep "with ERRORS" | awk 'BEGIN{print "sid"}{print $3}' > subjects_with_errors.csv
```

### How to clean the feature files if I want to re-compute them?
Simply go to the processed folder and execute:
```bash
rm *stats*.csv
```
