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

For cortical features:
```bash
for hemi in lh rh; do \
    for meas in area volume thickness thicknessstd meancurv gauscurv foldind curvind; do \
        eval "aparcstats2table --subjectsfile subjects.txt --skip --delimiter comma --hemi ${hemi} --tablefile ${hemi}_${meas}_aparc_stats.csv"; \
    done \
done
``` 

For subcortical features:
```bash
for meas in volume mean; do  # Iterate over volume and mean intensity  \
    eval "asegstats2table --subjectsfile subjects.txt --skip --delimiter comma --meas ${meas} --tablefile ${meas}_aseg_stats.csv"; \
done
``` 
