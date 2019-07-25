INDIR=/lustre/scratch117/cellgen/team218/TA/course/WTAC2019/FastQ
OUTDIR=/lustre/scratch117/cellgen/team218/TA/course/WTAC2019/Trimmed
MEM=1000

INFILES=($INDIR/*.fastq.gz)

SCRIPT=/lustre/scratch117/cellgen/team218/TA/course/WTAC2019/Trimming.sh

for FILE in "${INFILES[@]}"
do
	bsub -R"select[mem>$MEM] rusage[mem=$MEM]" -M $MEM -o trim.%J.out -e trim.%J.err $SCRIPT $FILE $OUTDIR
done
