#!/bin/bash

#PBS -l ncpus=2
#PBS -N general_pacmap_submission
#PBS -l mem=160GB
#PBS -l jobfs=20GB
#PBS -q normalsr
#PBS -P rm11
#PBS -l walltime=40:00:00
#PBS -l storage=scratch/rm11
#PBS -l wd
#PBS -M tony.xu@anu.edu.au
#PBS -m abe

module load pangeo/2021.01

echo "Number of CPUS is: " $NCPUS

python3 general_pacmap_script.py \
    --source_file /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised.csv \
    --export_name /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised_embeds0.csv \
    --use_channels "0,3,6,15" 
python3 general_pacmap_script.py \
    --source_file /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised.csv \
    --export_name /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised_embeds1.csv \
    --use_channels "0,3,6,15" \
    --remove_channels "11,14"