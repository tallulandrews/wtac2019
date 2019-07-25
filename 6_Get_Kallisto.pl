use strict;
use warnings;
# Currently replaces all estimated FPKMs which are not significantly bigger than 0 with 0. -> not as of (Feb 9 2016), also changed "not detected" genes from NA to 0.

if (@ARGV < 2) {die "Please supply a directory of Kallisto Output and a prefix for output\n";}

my $dir = $ARGV[0];
my $outprefix = $ARGV[1];

my %AllGenes = (); my %AllSamples = ();
my %Gene2Sample2TPM = ();
my %Gene2Sample2Counts=();

my @files = glob("$dir/*.abundances.tsv");	
foreach my $file (@files) {
	my $ID = "ERR";
	if ($file =~ /([^\.\/]+)\./) { # Extract sample ID from file name -> must be customized for each dataset.
		$ID = $1;
	} else {
		die "$file does not match!";
	}
	$AllSamples{$ID}=1;
	open(my $ifh, $file) or die $!;
	<$ifh>; # header
	while (<$ifh>) {
		chomp;
		my @record = split(/\t/);
		my $trans = $record[0];
		my $count = $record[3];
		my $tpm = $record[4];
		my $gene = $trans;
		if (exists($Gene2Sample2TPM{$gene})) {
			$Gene2Sample2TPM{$gene}->{$ID}+=$tpm;
			$Gene2Sample2Counts{$gene}->{$ID}+=$count;
		} else {
			$Gene2Sample2TPM{$gene}->{$ID}=$tpm;
			$Gene2Sample2Counts{$gene}->{$ID}=$count;
		}
	} close ($ifh);
} 

open (my $ofhtpm, ">", "$outprefix.tpm") or die $!;
open (my $ofhcounts, ">", "$outprefix.counts") or die $!;
my @IDs = sort(keys(%AllSamples));
print $ofhtpm "Gene\t".join("\t",@IDs)."\n";
print $ofhcounts "Gene\t".join("\t",@IDs)."\n";

foreach my $gene (keys(%Gene2Sample2TPM)) {
	print $ofhtpm "$gene";
	print $ofhcounts "$gene";
	foreach my $ID (@IDs) {
                 my $tpm = "NA";
                 if (exists($Gene2Sample2TPM{$gene}->{$ID})) {
                         $tpm = $Gene2Sample2TPM{$gene}->{$ID};
                 } else {
                         $tpm = "0";
                 }
                 my $count = "NA";
                 if (exists($Gene2Sample2Counts{$gene}->{$ID})) {
                         $count = $Gene2Sample2Counts{$gene}->{$ID};
                 } else {
                         $count = "0";
                 }
                 print $ofhcounts "\t".$count;
                 print $ofhtpm "\t".$tpm;
         }
         print $ofhcounts "\n";
         print $ofhtpm "\n";
}
close($ofhcounts);
close($ofhtpm);
