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

my $microorganism_name;
my $chinses_name;
my $genus;
my $species_name;
my $gram_stain;
my $top_type;
my $sample_type;
my $halos_id;
my $description;
my $reference;


my ($i,@tmp,@tmp1,@tmp2,$tmp2);

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
    }
    $keyword{$tmp[1]}=$keyword;
    
    
}

close IN;


foreach (sort keys %keyword)
{
    #print "";
	
	print "$_\t$keyword{$_}\n"
}

