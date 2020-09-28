#!/usr/bin/perl
use strict;
use utf8;
use Encode;
use Encode qw/encode decode from_to/;
############################################################
# 
# This perl is grep keyword form microorganism info
# 
# 
# Usage :
# perl grep_keyword.pl $ARGV[0] $ARGV[1] > $ARGV[2]
# 	$ARGV[0] >>>  keywords (keywords.csv)
#	$ARGV[1] >>>  input (data_all.txt)
#   $ARGV[2] >>>  output
# 
# perl grep_keyword.pl keywords.csv data_all.txt > result.txt
#

if (!$ARGV[0]||!$ARGV[1])
{
	print "Usage error!!!!\n";
	print "perl grep_keyword.pl \$ARGV[0] \$ARGV[1] > \$ARGV[2]\n";
	print "\$ARGV[0] >>>  keywords (keywords.csv)\n";
	print "\$ARGV[1] >>>  input (data_all.txt)\n";
	print "\$ARGV[2] >>>  output\n";
	die;
}



my $microorganism_name;
my $chinses_name;
my $genus;
my $species_name;
my $gram_stain;
my $top_type;
my $sample_type;
my $halos_id;
my $description;
my $reference1;
my $reference2;
my $reference3;
my $reference4;
my $reference5;

my @description;
my $description_len;

my ($i,@tmp,@tmp1,@tmp2,$tmp2,$count);
my $keyword_tmp;
my $keyword_tmp_cn;
my $keyword;
my %keyword;
my $keyword_buttom;

open (IN,"$ARGV[0]")||die "$!";

while (<IN>)
{
    chomp;
    #$_ = encode("big5", $_);
	@tmp = split",",$_;
    $keyword = $tmp[0];
	#$keyword = encode("utf8", decode("big5", $tmp[0]));
    $keyword_buttom="off";
    
    if( $keyword eq ""){}
    elsif ( exists $keyword{$tmp[1]} )
    {
        @tmp1 = split "\t", $keyword{$tmp[1]};
		
		for( $i=0; $i < @tmp2; $i++ )
		{
			if ($keyword eq $tmp2[$i] )
			{
				$keyword_buttom = "on";
			}
		}
        
		if ($keyword_buttom eq "off" )
		{
			$keyword = "$keyword\t$keyword{$tmp[1]}";
		}
        #print "$tmp[1]\t$keyword\n";
		#print "$tmp[1]\t";
    }
    $keyword{$tmp[1]}=$keyword;
    
    
}

close IN;


foreach (sort keys %keyword)
	{
		chomp($_);
		#print "$_";
		
		#print "$_\t$keyword{$_}\n"
	}
my $BGI;
my $taiwan;

print "DB_id\tmicroorganism_name\tchinses_name\tgenus\tspecies_name\tgram_stain\ttop_type\tsource\tkeyword\tsample_type\thalos_id\ttaxid\tspecies id\tdescription\treference1\treference2\treference3\treference4\treference5\tdate\tdata_source\tdata_status\n";

open (IN,"$ARGV[1]")||die "$!";

my $header = <IN>;

while (<IN>)
{
    chomp;
	@tmp = split"\t",$_;
	$microorganism_name = $tmp[0];
	$chinses_name = $tmp[1];
	$genus = $tmp[2];
	$species_name = $tmp[3];
	$gram_stain = $tmp[4];
	$top_type = $tmp[5];
	$sample_type = $tmp[6];
	$halos_id = $tmp[7];
	$description = $tmp[8];
	$reference1 = $tmp[9];
	$reference2 = $tmp[10];
	$reference3 = $tmp[11];
	$reference4 = $tmp[12];
	$reference5 = $tmp[13];
	
	
	$keyword = "";
	foreach $keyword_tmp (sort keys %keyword)
	{
		@tmp1 = split"\t",$keyword{$keyword_tmp};
		$keyword_buttom = "off";
		for($i=0;$i<@tmp1;$i++)
		{
			$keyword_tmp_cn = $tmp1[$i];
			if ($description=~/$keyword_tmp_cn/)
			{
				$keyword_buttom = "on";
			}
		}
		if ($keyword_buttom eq "on")
		{
			$keyword = "$keyword, $keyword_tmp";
		}
	}
	$description=~s/\"//g;
	$description=~s/\[/\t/g;
	$description=~s/\]/\t/g;
	@description = split "\t",$description;
	
	$count = 1;
	$description_len = @description;
	if ($description_len <= 1) {$description = "\"$description[0]$description[2]\""}
	#1 reference
	elsif ($description_len <= 3){$description = "\"$description[0]\[1\]$description[2]\""}
	#2 reference
	elsif ($description_len <= 5){$description = "\"$description[0]\[1\]$description[2]\[2\]$description[4]\"";}
	#3 reference
	elsif ($description_len <= 7){$description = "\"$description[0]\[1\]$description[2]\[2\]$description[4]\[3\]$description[6]\"";}
	#4 reference
	elsif ($description_len <= 9){$description = "\"$description[0]\[1\]$description[2]\[2\]$description[4]\[3\]$description[6]\[4\]$description[9]\"";}
	#5 reference
	elsif ($description_len <= 11){$description = "\"$description[0]\[1\]$description[2]\[2\]$description[4]\[3\]$description[6]\[4\]$description[9]\[5\]$description[11]\"";}
	
	#print "$description\n";
	$reference1=~s/\"//g;
	$reference2=~s/\"//g;
	$reference3=~s/\"//g;
	$reference4=~s/\"//g;
	$reference5=~s/\"//g;
	if($reference1 =~ /(\d\d?)\. (.+)?/){$reference1="1. $2"}
	if($reference2 =~ /(\d\d?)\. (.+)?/){$reference2="2. $2"}
	if($reference3 =~ /(\d\d?)\. (.+)?/){$reference3="3. $2"}
	if($reference4 =~ /(\d\d?)\. (.+)?/){$reference4="4. $2"}
	if($reference5 =~ /(\d\d?)\. (.+)?/){$reference5="5. $2"}
	#print "$microorganism_name\t$reference1\n";
	
	
	#$keyword = "$keyword,$keyword_tmp";
	#print "$keyword";
		
	
	
	$keyword=~s/, //;
	print "\t$microorganism_name\t$chinses_name\t$genus\t$species_name\t$gram_stain\t$top_type\tHalos\t$keyword\t$sample_type\t$halos_id\t\t\t$description\t$reference1\t$reference2\t$reference3\t$reference4\t$reference5\n";
	#print "$description\n";
	#
	
}

close IN;

