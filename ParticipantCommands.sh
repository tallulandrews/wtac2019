FASTQC=/nfs/users/nfs_t/ta6/RNASeqPipeline/software/FastQC/fastqc
KALLISTO=/nfs/users/nfs_t/ta6/RNASeqPipeline/software/kallisto_linux-v0.42.4/kallisto
TRIMMER=/lustre/scratch117/cellgen/team218/TA/course/WTACSingleCell/Software/TrimGalore-0.6.0/trim_galore



# CRAM 2 FastQ
$SAMTOOLS view -b -h 30276_1#15.cram -o 30276_1#15.bam
$SAMTOOLS view -b -F 256 30276_1#15.bam -o 30276_1#15_no2nd.bam
$SAMTOOLS sort -n 30276_1#15_no2nd.bam -o 30276_1#15_no2nd_sorted.bam
$BEDTOOLS bamtofastq -i 30276_1#15_no2nd_sorted.bam -fq 30276_1#15_1.fastq -fq2 30276_1#15_2.fastq
gzip 30276_1#15_1.fastq
gzip 30276_1#15_2.fastq

$FASTQC 30276_1#15_1.fastq.gz
$FASTQC 30276_1#15_2.fastq.gz


$TRIMMER -o ./ 30276_1#15_1.fastq.gz
$TRIMMER -o ./ 30276_1#15_2.fastq.gz

$KALLISTO quant --bias --plaintext --threads=1 -i RefData/human.idx -o ./ 30276_1#15_1_trimmed.fq.gz 30276_1#15_2_trimmed.fq.gz
$KALLISTO quant --bias --plaintext --threads=1 -i RefData/mouse.idx -o ./ 30276_1#15_1_trimmed.fq.gz 30276_1#15_2_trimmed.fq.gz
