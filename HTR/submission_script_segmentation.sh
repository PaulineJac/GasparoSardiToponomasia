#!/bin/env bash
#SBATCH --partition=public-gpu
#SBATCH --time=20:00:00
#SBATCH --gpus=1
#SBATCH --output=kraken-%j.out
#SBATCH --mem=0

module load fosscuda/2020b Python/3.8.6
source ~/Sandozenv/bin/activate

work_directory="/home/users/j/jacsont/Sardi_Toponomasia/Model_seg_4/"
mkdir -p ${work_directory}
cd ${work_directory}

OUTPUT_NAME="output_name"
XML_FOLDER="/home/users/j/jacsont/Sardi_Toponomasia/Groundtruth/"

echo "KETOS training"
srun ketos segtrain -o $OUTPUT_NAME -f alto -d cuda "${XML_FOLDER}/*.xml"

