#!/bin/env python3
import os
from os.path import join

import pandas as pd

def build_freesurfer_feature_matrix(features_folder):
    """
        A function that loads the stats files comming out of FreeSurfer and
        builds a single DataFrame out of them.
    """
    features_csv_files = [join(features_folder, f) for f in os.listdir(features_folder) if 'stats' in f]
    for csv in features_csv_files:
        try:
            # Check if ['BrainSegVolNotVent', 'eTIV'] already exist (automatically duplicated by fs)
            if any(df_features.columns.str.contains('BrainSegVolNotVent|eTIV')):
                temp = pd.read_csv(csv, index_col=0).drop(columns=['BrainSegVolNotVent', 'eTIV'], errors='ignore')
            else:
                temp = pd.read_csv(csv, index_col=0)

            # Correct duplicate columns comming from aseg stats file adding
            # second part of the index name as the suffix. 
            # Example: Measure:volume add the suffix *_volume
            if 'aseg' in csv:
                df_features = df_features.join(temp, rsuffix=temp.index.name.split(':')[-1])
            else:
                df_features = df_features.join(temp)
        except NameError:
            df_features = pd.read_csv(csv, index_col=0)
    return df_features

folder = os.getcwd()
print('Folder:', folder)

features = build_freesurfer_feature_matrix(folder)
features.to_csv('dataset_features.csv')
