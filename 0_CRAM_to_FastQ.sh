#!/bin/bash
# Convert CRAM to BAM

export REF_CACHE=/lustre/scratch117/cellgen/team218/TA/TemporaryFileDir
SAMTOOLS=/nfs/users/nfs_t/ta6/RNASeqPipeline/software/CRAM/samtools-1.3.1/samtools
BEDTOOLS=/nfs/users/nfs_t/ta6/RNASeqPipeline/software/bedtools2/bin/bedtools

FILE=$1
OUTDIR=$2
PREFIX=$3

TMP_CRAM=$PREFIX
BAMFILE=$OUTDIR/$TMP_CRAM\.bam

cp $FILE $OUTDIR/$TMP_CRAM\.cram

$SAMTOOLS view -b -h $OUTDIR/$TMP_CRAM\.cram -o $OUTDIR/$TMP_CRAM\.bam

rm $OUTDIR/$TMP_CRAM\.cram

# Convert BAM file to paired, zipped, read files. Assumes paired-end sequencing

FASTQ1=$PREFIX\_1.fastq
FASTQ2=$PREFIX\_2.fastq

if [ ! -f $OUTDIR/$FASTQ1\.gz ] || [ ! -f $OUTDIR/$FASTQ2\.gz ] ; then

	#write all reads to fastq
	SORTED=Sorted_$PREFIX\.bam
	PRIMARY_ONLY=Primary_$PREFIX\.bam
	$SAMTOOLS view -b -F 256 $BAMFILE -o $PRIMARY_ONLY
	$SAMTOOLS sort -n $PRIMARY_ONLY -o $SORTED
	$BEDTOOLS bamtofastq -i $SORTED -fq $OUTDIR/$FASTQ1 -fq2 $OUTDIR/$FASTQ2 # paired
#	$BEDTOOLS bamtofastq -i $SORTED -fq $OUTDIR/$FASTQ1 # unpaired
	

	gzip $OUTDIR/$FASTQ1
	gzip $OUTDIR/$FASTQ2
	rm $SORTED
	rm $PRIMARY_ONLY
#	rm $BAMFILE
fi
