#!/bin/bash
#
# use RCLONE to transfer files to LTS
#
# FILES: README.txt, *.fastq.gz
#
#SBATCH --job-name=push_to_lts-hackathon-2023-hendrickson
#SBATCH --output=%x.%J.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --partition=long
#SBATCH --time=6-06:00:00
##SBATCH --partition=medium
##SBATCH --time=2-02:00:00
##SBATCH --mem-per-cpu=500M # failed on PacBio raw subreads.bam
#SBATCH --mem-per-cpu=2G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=curtish@uab.edu

export DIR="."
export UPDIR=$(echo $DIR | perl -pe 's/[^\/]+/../g')

export RCLONE_SRC="."
export BUCKET="hendrickson-uab-hackathon-2023"
export RCLONE_DEST="lts:/${BUCKET}/"
#export RCLONE_INCLUDE=" --filter-from <(awk -e 'BEGIN{FS=\"/\"}(\$7!=\"\"){print \"+ \"\$7}END{print \"- *\"}' ../$UPDIR/$SRC_FILE_LIST) "
export RCLONE_INCLUDE=" --include '*.pdf' --include '*.txt' --include '*.zip' --include '*.JPG'"
# copy only things that haven't changed, ie where the globus transfer has already finished.
#export RCLONE_FLAGS="--min-age 1d " 
#export RCLONE_FLAGS="--min-age 2h " 
echo "RCLONE_SRC=$RCLONE_SRC"
echo RCLONE_DEST=$RCLONE_DEST
echo RCLONE_INCLUDE=$RCLONE_INCLUDE

if [ -z "$(which rclone 2>/dev/null)" ]; then 
    echo module load rclone ...
    module load rclone
fi

#
# copy up 
#
# use "copy" it will avoid re-coyping files that haven't changed, and will delete nothing
# if we use "sync", it will delete things from the bucket we have deleted from the FS (bad)
#
# CPU: normally, rclone defaults to max 4 CPU. If running as a SLURM job, override that with 
# number of job CPUs on node
RCLONE_CPU=" --transfers=${SLURM_CPUS_ON_NODE:-4} --multi-thread-streams ${SLURM_CPUS_ON_NODE:-4}"

# v1
echo  rclone $* copy --progress $RCLONE_CPU $RCLONE_SRC/i2b2/exports/v1 $RCLONE_DEST/i2b2/exports/v1 $RCLONE_INCLUDE --include='*.csv' $RCLONE_FLAGS
eval "rclone $* copy --progress $RCLONE_CPU $RCLONE_SRC/i2b2/exports/v1 $RCLONE_DEST/i2b2/exports/v1 $RCLONE_INCLUDE --include='*.csv' $RCLONE_FLAGS"
# v2 
echo  rclone $* copy --progress $RCLONE_CPU $RCLONE_SRC/i2b2/exports/v2_full $RCLONE_DEST/i2b2/exports/v2_full $RCLONE_INCLUDE --include='*.csv' $RCLONE_FLAGS
eval "rclone $* copy --progress $RCLONE_CPU $RCLONE_SRC/i2b2/exports/v2_full $RCLONE_DEST/i2b2/exports/v2_full $RCLONE_INCLUDE --include='*.csv' $RCLONE_FLAGS"
# v3 - big - no csv, just zip
echo  rclone $* copy --progress $RCLONE_CPU $RCLONE_SRC/i2b2/exports/v3 $RCLONE_DEST/i2b2/exports/v3 $RCLONE_INCLUDE $RCLONE_FLAGS
eval "rclone $* copy --progress $RCLONE_CPU $RCLONE_SRC/i2b2/exports/v3 $RCLONE_DEST/i2b2/exports/v3 $RCLONE_INCLUDE $RCLONE_FLAGS"

#
# get final md5 list
#

#echo rclone md5sum $RCLONE_DEST \> s3.${BUCKET}.md5.txt
#rclone md5sum $RCLONE_DEST > s3.${BUCKET}.md5.txt


