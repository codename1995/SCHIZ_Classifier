# Effective schizophrenia recognition using discriminative eye movement features and model-metric based features

This repository contains an eye movement dataset and a classifier. 

[TOC]

## To do list
* [x] Original dataset
* [x] Processed dataset
* [x] Code for pre-processing
* [ ] Classifier
* [ ] Step-by-step tutorial


## Cite
Please cite with the following Bibtex code:
```

@article{SCHIZ_Classifier,
title = "Effective schizophrenia recognition using discriminative eye movement features and model-metric based features",
journal = "Pattern Recognition Letters",
volume = "138",
pages = "608 - 616",
year = "2020",
issn = "0167-8655",
doi = "https://doi.org/10.1016/j.patrec.2020.09.017",
url = "http://www.sciencedirect.com/science/article/pii/S0167865520303536",
author = "Lijin Huang and Weijie Wei and Zhi Liu and Tianhong Zhang and Jijun Wang and Lihua Xu and Weiyu Chen and Olivier {Le Meur}",
}
```


## Dataset
### Original dataset
[Here](https://drive.google.com/file/d/1e71a7MW1uvniP0uG-GiOaR75a872xDGw/view?usp=sharing) is the original version of the dataset. Each folder contains three reports which come from the EYE-LINK software. 
### [Recommended] Processed dataset 
To make the dataset easy to use, we extracted the important information, *e.g.* fixation position and fixation duration, into MAT files.

The processed dataset is available at ``./ProcessedDataset`` and generated by ``preprocessDataset.m``.

For each fixation, we extract some basic items:
* CURRENT_FIX_X
* CURRENT_FIX_Y
* CURRENT_FIX_DURATION (in millisecond)
* TRIAL_FIXATION_TOTAL
* PupilSize (in unit)
* X_Resolution
* Y_Resolution

and some processed feature:
* BlinkRound (0-error, 1-no blink, 2-blink before this fix, 3-blink after this fix, 4-blink before and after this fix)

For each saccade, we extract some basic items:
* CURRENT_SAC_ANGLE
* CURRENT_SAC_AVG_VELOCITY
* CURRENT_SAC_PEAK_VELOCITY
* CURRENT_SAC_DURATION
* CURRENT_SAC_START_X
* CURRENT_SAC_START_X_RESOLUTION
* CURRENT_SAC_START_Y
* CURRENT_SAC_START_Y_RESOLUTION
* CURRENT_SAC_END_X
* CURRENT_SAC_END_X_RESOLUTION
* CURRENT_SAC_END_Y
* CURRENT_SAC_END_Y_RESOLUTION
* CURRENT_SAC_CONTAINS_BLINK
* CURRENT_SAC_AMPLITUDE

The specific meaning of above basic items can be found in [EyeLink Data Viewer User’s Manual](http://sr-research.jp/support/files/dvmanual.pdf). More features can be extracted by modifing these files:
* ``./saveReportToMat/getSaccadeData.m``
* ``./saveReportToMat/saveSaccadesToStruct.m``
* ``./saveReportToMat/getFixationData.m``
* ``./saveReportToMat/saveFixationsToStruct.m``

## Classifier
### Features extraction
We extract the features from the preprocessed dataset.

## Acknowledgement
The code is heavily inspired by the following project:
1. OSIE dataset : https://www-users.cs.umn.edu/~qzhao/predicting.html

Thanks for their contributions.

## Contact 
If you have any questions, please contact me (codename1995@shu.edu.cn) or my supervisor Prof. Zhi Liu (liuzhi@staff.shu.edu.cn).

## License 
This code is distributed under MIT LICENSE.
