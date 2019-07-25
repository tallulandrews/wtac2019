#!/usr/bin/bash
# Set-up environment
conda activate seq_pipeline #cutadapt
export PATH=/nfs/users/nfs_t/ta6/RNASeqPipeline/software/:$PATH

#FILE=FastQ/26404_1#10_1.fq.gz
FILE=$1
echo $FILE
OUTDIR=/lustre/scratch117/cellgen/team218/TA/course/WTAC2019/Trimmed

TRIMMER=/lustre/scratch117/cellgen/team218/TA/course/WTACSingleCell/Software/TrimGalore-0.6.0/trim_galore

$TRIMMER -o $OUTDIR $FILE

#TRIMMED= ${FILE/FastQ/Trimmed}
#TRIMMED= ${TRIMMED/.fastq/_trimmed.fastq}

#$TRIMMER -o $OUTDIR --polyA $TRIMMED

