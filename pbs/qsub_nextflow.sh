#PBS -q normal
#PBS -l ncpus=48
#PBS -l walltime=48:00:00
#PBS -l mem=192GB
#PBS -S /bin/sh
#PBS -N falcon
#PBS -V

cd /scratch/wz54/sb4293/falcon
source activate pb-assembly
./nextflow run main.nf --resume
