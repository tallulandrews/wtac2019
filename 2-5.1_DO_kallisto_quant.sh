#!/bin/bash

INDEXFILE=$1
INPUTDIR=$2
OUTPUTDIR=$3
mkdir -p $OUTPUTDIR
INPUTFILES=($INPUTDIR/*.fq.gz)
NUMFILES=${#INPUTFILES[@]}
MAXJOBS=$(($NUMFILES/2))
bsub -J"mappingwithstararrayjob[1-$MAXJOBS]%50" -R"select[mem>5000] rusage[mem=5000]" -M5000 -q normal -o Kallisto_output.%J.%I /lustre/scratch117/cellgen/team218/TA/course/WTAC2019/2-5.1_kallisto_quant.sh 1 $INPUTDIR $OUTPUTDIR $INDEXFILE

