#!/bin/bash

#PBS -l ngpus=1
#PBS -l ncpus=12
#PBS -N peptide_UMAP_job
#PBS -l mem=60GB
#PBS -l jobfs=10GB
#PBS -q gpuvolta
#PBS -P eu59
#PBS -l walltime=20:00:00
#PBS -l storage=scratch/dk92+gdata/rm11+gdata/dk92+scratch/rm11
#PBS -l wd
#PBS -M tony.xu@anu.edu.au
#PBS -m abe

module use /g/data/dk92/apps/Modules/modulefiles
module load rapids/23.06

echo "Number of CPUS is: " $NCPUS

python3 -u /g/data/rm11/rebekah_analysis/becky_umap.py \
    --source_file /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised.csv \
    --export_name /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised_embeds0.csv \
    --use_channels "0,3,6,15" \
    --remove_channels "5" \
    --n_neighbours 30 \
    --min_dist 0.5 \
    --distance_metric "correlation" 
python3 -u /g/data/rm11/rebekah_analysis/becky_umap.py \
    --source_file /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised.csv \
    --export_name /g/data/rm11/rebekah_analysis/peptide_myeloids_harmonised_embeds0.csv \
    --use_channels "0,3,6,15" \
    --remove_channels "5" \
    --n_neighbours 30 \
    --min_dist 0.5 \
    --distance_metric "euclidean" \

python3 -u /g/data/rm11/rebekah_analysis/becky_umap.py \
    --source_file /g/data/rm11/rebekah_analysis/all_restims_tcells.csv \
    --export_name /g/data/rm11/rebekah_analysis/all_restims_tcells_harmonised.csv \
    --use_channels "1,3,6,19" \
    --n_neighbours 30 \
    --min_dist 0.5 \
    --distance_metric "correlation" 
python3 -u /g/data/rm11/rebekah_analysis/becky_umap.py \
    --source_file /g/data/rm11/rebekah_analysis/all_restims_tcells.csv \
    --export_name /g/data/rm11/rebekah_analysis/all_restims_tcells_harmonised.csv \
    --use_channels "1,3,6,19" \
    --n_neighbours 30 \
    --min_dist 0.5 \
    --distance_metric "euclidean" \
