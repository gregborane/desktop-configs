#!/bin/bash

CONDA_BASE=$(conda info --base)
source "$CONDA_BASE/etc/profile.d/conda.sh"

conda activate base
conda install conda-forge::xtb -y
conda install conda-forge::crest -y
conda install conda-forge::morfeus-ml -y
