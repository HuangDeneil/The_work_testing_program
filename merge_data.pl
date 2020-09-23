#!/usr/bin/perl
use strict;
use utf8;
use Encode;
use Encode qw/encode decode from_to/;
############################################################
# 
# This perl is merge microorganism info
# 
# 
# Usage :
# perl merge_data.pl $ARGV[0] > $ARGV[1]
# 	$ARGV[0] >>>  input
#	$ARGV[1] >>>  output
# 
# perl merge_data.pl merge.txt > data.txt
#


my (@tmp,@tmp1,$tmp1,@tmp2,@tmp3,$i);
my $feature;

my %data;

my $microorganism_name;
my $genus;
my $species_name;
my $gram_stain;
my $chinses_name;
my $top_type;
my $sample_type;
my $sample_type_exist;
my $sample_type_buttom;
my $halos_id;
my %halos_id;
my $halos_id_exist;
my $halos_id_buttom;
my $description;
my $reference;
my @reference;

                      

#my @file = `ls *.txt`;
#print "$file[1]";


open (IN,"$ARGV[0]")||die "$!";

while(<IN>)
{
    chomp;
	@tmp = split "\t",$_;
	$microorganism_name = $tmp[0];
	$genus = $tmp[1];
	$species_name = $tmp[2];
	$gram_stain = $tmp[3];
	$chinses_name = $tmp[4];
	#$chinses_name = encode("big5", $chinses_name);
	
	$top_type = $tmp[5];
	$halos_id = $tmp[6];
	$sample_type = $tmp[7];
	
	$description = $tmp[8];
	#$description = encode("big5", $description);
	
	$reference = $tmp[9];

	$reference=~s/,space,/\t/g;
	$sample_type_buttom = "off";
	$halos_id_buttom = "off";
	#print "$reference\n";
	if ( exists $data{$microorganism_name} )
	{
		@tmp1 = split "\t", $data{$microorganism_name};
		$halos_id_exist = $tmp1[7];
		$sample_type_exist = $tmp1[6];
		#print "$halos_id_exist\n";
		$halos_id_exist=~s/"//g;
		$sample_type_exist=~s/"//g;
		@tmp2 = split",",$sample_type_exist;
		@tmp3 = split",",$halos_id_exist;
		#$sample_type_buttom = "off";
		#$halos_id_buttom = "off";
		
		for($i=0;$i<@tmp2;$i++)
		{
			if ($sample_type eq $tmp2[$i] )
			{
				$sample_type_buttom = "on";
			}
		}
		
		if ($sample_type_buttom eq "off" )
		{
			$sample_type = "$sample_type,$sample_type_exist";
		}
		
		for($i=0;$i<@tmp3;$i++)
		{
			if ($halos_id eq $tmp3[$i] )
			{
				$halos_id_buttom = "on";
			}
		}
		
		if ($halos_id_buttom eq "off" )
		{
			$halos_id = "$halos_id,$halos_id_exist";
		}
	}
#organism_name,chinese_name	genus,species_name,gram_stain,top_type,source,key_word,sample_type,Halos_id,taxid,species_taxid,Description	reference1	reference2	reference3	reference4	reference5	date	data_source	data_status

	$data{$microorganism_name}="$microorganism_name\t$chinses_name\t$genus\t$species_name\t$gram_stain\t$top_type\t\"$sample_type\"\t\"$halos_id\"\t\"$description\"\t$reference";
	
	#print "$microorganism_name\t$genus\t$species_name\t$gram_stain\t$chinses_name\t$top_type\t$halos_id\t$description\t$reference\n"
	#
}
print "microorganism_name\tchinses_name\tgenus\tspecies_name\tgram_stain\ttop_type\tsample_type\thalos_id\tdescription\treference\n";
close IN;
foreach (sort keys %data)
{
	#print "$_\n";
	print "$data{$_}\n";
}





