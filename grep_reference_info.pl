#!/usr/bin/perl
use strict;
use utf8;
use Encode;
use Encode qw/encode decode from_to/;
############################################################
# 
# This perl is grep infomation of microoranism from latex report
# 
# 
# Usage :
# perl grep_reference_info.pl $ARGV[0] > $ARGV[1]
# 
# $ARGV[0] >>> input
# $ARGV[1] >>> output
# 
# perl grep_reference_info.pl test.tex > out
#

if (!$ARGV[0] )
{
	print "Usage error\n\n";
	print "Uasge :\n";
	print "perl grep_reference_info.pl \$ARGV[0] > \$ARGV[1]\n";
	print "\$ARGV[0] >>> input\n";
	print "\$ARGV[1] >>> output\n\n";
	die;
}

my $buton_table_start=0;
my $buton_result_start=0;
my $line;
my $tmp1;
my $feature;




open (IN,"$ARGV[0]")||die "$!";

while(<IN>)
{
    chomp;
    
	$tmp1=encode("big5", decode("utf8", $_));
	#print "$_";
	$line = encode("big5", $_);
	$feature ='原樣本編號';
	if($line=~/人類/)
	{
		print "$_\n";
	}
	#print "$line\n"
	#
}







close IN;







