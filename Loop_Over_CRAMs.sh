#INDIR=/lustre/scratch118/infgen/pathdev/maa/RNA_Trans/SCNRA
INDIR=/lustre/scratch117/cellgen/team218/TA/course/FileTransfer/
OUTDIR=/lustre/scratch117/cellgen/team218/TA/course/WTAC2019/FastQ
MEM=10000

INFILES=($INDIR/*.cram)

SCRIPT=/lustre/scratch117/cellgen/team218/TA/course/WTAC2019/0_CRAM_to_FastQ.sh

for FILE in "${INFILES[@]}"
do
	PREFIX=`basename ${FILE%.cram}`
	bsub -R"select[mem>$MEM] rusage[mem=$MEM]" -M $MEM -o fastqs.%J.out -e fastqs.%J.err $SCRIPT $FILE $OUTDIR $PREFIX
done
