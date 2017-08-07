#!/bin/bash

# create numpy pandas environment and set interactive login node.

export PATH=/share/apps/anaconda2/bin:$PATH
conda create --name py2-numpy-pandas numpy pandas
source activate py2-numpy-pandas

qrsh -l h_vmem=8G
