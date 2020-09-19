#!/usr/bin/perl
use strict;
use utf8;
use Encode;
use Encode qw/encode decode from_to/;
#############################################
# 
# 此程式是在處裡網路訂單
# 整理出 "訂單價錢" "訂單種類" "總製造需求"
# 
# usage : perl order_process.pl $ARGV[0] 
# 
# $ARGV[0] >>> 輸入訂單
# 
# 
# 

if (!$ARGV[0])
{
	print "\n\n";
	print "!!!!!!!No list detect!!!!\n";
	print "Uasge:\n";
	print "\tperl order_process.pl \$ARGV[0] \n\n";
	print "\$ARGV[0] >>> input\n";
	die "error";
}


my @tmp;
my $name;
my $id;
my %name;
my @data;
my %data;
my %price;
my %goods;
my %order_goods;
my %order_goods_content_id;
my $j;
my $header;
my @header;
my $tmp;
my $tmp1;
my $tmp2;
my ($line1,$line2,$line3,$line4,$line5,$line6,$line7,$line8);

#######################
# 
# 讀取產品總表(goods_list.csv)
# 
open (IN,"goods_list.csv")||die "cannot find reference file";

while (<IN>)
{
	if(/^#>/)
	{
		@tmp=split ",", $_;
		$goods{"header"}="$tmp[6],$tmp[7],$tmp[8],$tmp[9],$tmp[10],$tmp[11],$tmp[12]";
	}
	else
	{
		@tmp=split ",", $_;
		$id=$tmp[1];
		$name{$id}=$tmp[0];
		
		$price{$id}=$tmp[5];
		
		$data{$id}=$_;
		$goods{$id}="$tmp[6],$tmp[7],$tmp[8],$tmp[9],$tmp[10],$tmp[11],$tmp[12]";
		$order_goods{$id}=$tmp[3];
		$order_goods_content_id{$id}=$tmp[4];
	}
}

close IN;


########################
# 
# 讀取產品配方表(recipe.csv)
# 
my %recipe;

open (IN,"recipe.csv")||die "cannot find reference file";

while (<IN>)
{
	if(/^>/)
	{
		@tmp=split ",", $_;
		
		$recipe{"header"}="$tmp[2],$tmp[3],$tmp[4],$tmp[5],$tmp[6],$tmp[7],$tmp[8],$tmp[9],$tmp[10],$tmp[11],$tmp[12],$tmp[13],$tmp[14]"
	}
	else
	{
		@tmp=split ",", $_;
		$id=$tmp[0];
		$name{$id}=$tmp[1];
		
		$data{$id}=$_;
		$recipe{$id}="$tmp[2],$tmp[3],$tmp[4],$tmp[5],$tmp[6],$tmp[7],$tmp[8],$tmp[9],$tmp[10],$tmp[11],$tmp[12],$tmp[13],$tmp[14]"
		
	}
}

close IN;



########################
# 
# 讀取survecake 表單
# 
open (IN,"$ARGV[0]")||die "Cannot find survecake file";

my $header=<IN>;
my ($source,$source_phone,$arrive,$arrive_phone,$email,$address,$arrive_time);
my (%source,%source_phone,%arrive,%arrive_phone,%email,%address,%arrive_time,%order_products,%order_total_count);

my ($arrive_goods,@arrive_goods,$arrive_goods_tmp,@arrive_goods_tmp);
my @arrive_goods_id=qw/208889 208890 208891 208892 208893 208894 208895 208896 208897 208898 208899/;
my %order_goods_id;

my ($note,@date_tmp,@date,$date,@time,$time,%time,$order,@inside);
my $inside1;
my $inside2;
my %note;
my %order;
my %order_info;
my $price;
my $i;
my %user_order_count;
my %total;

my ($order_goods,$count,$price1,$content,$line,$utf8);

while (<IN>)
{
	
	chomp;
	$tmp=$_;
	Encode::_utf8_on($tmp);
	$tmp = encode("big5", $tmp);
	$tmp=~s/\?//g;
	$tmp=~s/\"//g;
	@tmp=split ",", $tmp;
	
	$source=$tmp[0];
	$source_phone=$tmp[1];
	$arrive=$tmp[2];
	$arrive_phone=$tmp[3];
	$email=$tmp[4];
	$address=$tmp[5];
	$arrive_time=$tmp[6];
	$arrive_goods="$tmp[7],$tmp[8],$tmp[9],$tmp[10],$tmp[11],$tmp[12],$tmp[13],$tmp[14],$tmp[15],$tmp[16],$tmp[17]";
	@arrive_goods=split ",",$arrive_goods;
	$note=$tmp[18];
	$price=0;
	$count=1;
	
	$source_phone=~s/"//g;
	$source_phone=~s/ //g;
	$arrive_phone=~s/"//g;
	$arrive_phone=~s/ //g;
	$address=~s/"//g;
	$address=~s/ //g;
	#############################
	# 
	# 產生訂貨編號
	# 
	$id=$tmp[19];
	@date_tmp=split " ",$id;
	@date=split "-",$date_tmp[0];
	if ($date[1] <10)
	{
		$date[1]="$date[1]";
	}
	if ($date[2] <10)
	{
		$date[2]="$date[2]";
	}
	$date="$date[0]$date[1]$date[2]";
	
	
	@time=split ":",$date_tmp[1];
	if ( $date_tmp[3] eq "PM" )
	{
		$time[0]=$time[0]+12;
	}
	$time="$time[0]$time[1]$time[2]";
	$id="D$date$time";
	$time{$id}="$date[0]/$date[1]/$date[2]";
	#print "$id\n";
	$id =~ s/"//g;
	
	
	$source{$id}=$source;
	$source_phone{$id}=$source_phone;
	$arrive{$id}=$arrive;
	$arrive_phone{$id}=$arrive_phone;
	$email{$id}=$email;
	$address{$id}=$address;
	$arrive_time{$id}=$arrive_time;
	$note{$id}=$tmp[18];
	
	
	# if ($id eq "D20190924171153")
	# {
		# $tmp=$_;
		# Encode::_utf8_on($tmp);
		# $tmp = encode("big5", $tmp);
		# $tmp=~s/\?//g;
		# @tmp=split ",", $tmp;
		# print "$tmp\n\n";
		
		# $line1 = $address;
		# print "$line1\n\n";
		
		# print "$tmp[3]\n\n";
	# }
	
	for($i=0;$i<@arrive_goods_id;$i++)
	{
		if ($arrive_goods[$i] > 0 )
		{
			# 訂單中的所有貨物總價
			$price{$id}=$price{$id}+($price{$arrive_goods_id[$i]}*$arrive_goods[$i]); ## goods id X counts
			
			# 訂單中的所有貨物
			$order_products{$id}="$order_products{$id} $arrive_goods_id[$i]x$arrive_goods[$i]";
			
			# 訂單中的所有貨物總數(總盒數)
			$order_total_count{$id}=$order_total_count{$id}+$arrive_goods[$i];
			
			$total{$arrive_goods_id[$i]}=$total{$arrive_goods_id[$i]}+$arrive_goods[$i];
			
			$total{"total"}=$total{"total"}+$arrive_goods[$i];
		}
	}
}


close IN;

use POSIX qw/strftime/;
my $time = strftime('%Y-%m-%d-%H-%M-%S',localtime);
$tmp="產生本批次網路訂單中所有\"銷貨單\" \n 存放於 order_list/ 資料夾";
$tmp = encode("big5", $tmp);
print  "$tmp\n\n";


#############################
# 
# Output 銷貨單
# 
my @id = sort keys %note;
my $products_id;
my $products_count;
my $k;
my @tmp2;
my @tmp3;
my $tmp;
my $tmp2;
my $utf8;


system '
	if [ ! -d "order_list" ] ;then
		mkdir order_list
	fi
';


for ($k=0;$k<@id;$k++)
{

	$id=$id[$k];
	
	$line="$id\銷貨單";
	$line = encode("big5", $line);
	open (OUT,">./order_list/$line.csv")||die "$!";
	open (OUT_html,">./order_list/$line.html")||die "$!";
	
	
	use POSIX qw/strftime/;
	my $time = strftime('%Y-%m-%d %H:%M:%S',localtime);
	print OUT ",";
	print OUT $time;
	print OUT "\n";
	@tmp=split",",$_;
	$line=",,,銷貨單";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	$line="銷貨單$id";
	$line = encode("big5", $line);
	print OUT_html "<!DOCTYPE html>\n";
	print OUT_html "<html>\n";
	print OUT_html "<head>\n";
	print OUT_html "<style>\n";
	print OUT_html "table {\n";
	print OUT_html "  font-family: arial, sans-serif;\n";
	print OUT_html "  border-collapse: collapse;\n";
	print OUT_html "  width: 100%;\n";
	print OUT_html "}\n\n";
	print OUT_html "td, th {\n";
	print OUT_html "  border: 1px solid #dddddd;\n";
	print OUT_html "  text-align: left;\n";
	print OUT_html "  padding: 2px;\n";
	print OUT_html "}\n\n";
	print OUT_html "tr:nth-child(even) {\n";
	print OUT_html "  background-color: #dddddd;\n";
	print OUT_html "}\n\n";
	print OUT_html "</style  style=\"width:100%\">\n";
	print OUT_html "<title>$line</title>\n";
	print OUT_html "</head>\n";
	print OUT_html "<body>\n";
	print OUT_html "<p>".$time."</p>\n";
	
	$line="銷 貨 單";
	$line = encode("big5", $line);
	print OUT_html "<h1 align=\"center\" >$line</h1>\n\n";
	
	
	
	$line=",訂購單號：$id,,,,出貨日期：";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	$line1="訂購單號：";
	$line2="出貨日期：";
	$line1 = encode("big5", $line1);
	$line2 = encode("big5", $line2);
	print OUT_html "<table  style=\"width:100%\">\n";
	print OUT_html "  <tr>\n";
	print OUT_html "    <th>$line1$id</th>\n";
	print OUT_html "	<th>$line2</th>\n";
	print OUT_html "  </tr>\n";
	print OUT_html "  <tr>\n";
	
	
	$tmp1="$source{$id}";
	$tmp1=encode("utf8", decode("big5", $tmp1));
	Encode::_utf8_on($tmp1);
	$tmp2="$source_phone{$id}";
	$tmp2=encode("utf8", decode("big5", $tmp2));
	Encode::_utf8_on($tmp2);
	$line=",訂購人姓名：$tmp1,,,,聯絡電話：$tmp2";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	$line1="訂購人姓名：$tmp1";
	$line2="聯絡電話：$tmp2";
	$line1 = encode("big5", $line1);
	$line2 = encode("big5", $line2);
	print OUT_html "  <tr>\n";
	print OUT_html "	<th>$line1</th>\n";
	print OUT_html "    <th>$line2</th>\n";
	print OUT_html "  </tr>\n";
	
	$tmp1="$arrive{$id}";
	$tmp1=encode("utf8", decode("big5", $tmp1));
	Encode::_utf8_on($tmp1);
	$tmp2="$arrive_phone{$id}";
	$tmp2=encode("utf8", decode("big5", $tmp2));
	Encode::_utf8_on($tmp2);
	$line=",收件人姓名：$tmp1,,,,聯絡電話：$tmp2";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	
	$line1="收件人姓名：$tmp1";
	$line2="聯絡電話：$tmp2";
	$line1 = encode("big5", $line1);
	$line2 = encode("big5", $line2);
	print OUT_html "  <tr>\n";
	print OUT_html "	<th>$line1</th>\n";
	print OUT_html "    <th>$line2</th>\n";
	print OUT_html "  </tr>\n";	
	
	
	
	$line=",統一編號：,,,,頁次：,";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	$line1="統一編號：";
	$line1 = encode("big5", $line1);
	print OUT_html "  <tr>\n";
	print OUT_html "    <th>$line1</th>\n";
	print OUT_html "    <th></th>\n";
	print OUT_html "  </tr>\n";
	
	
	$line=",銷貨人員：,,,,列印日期：,";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	$line1="銷貨人員：";
	$line1 = encode("big5", $line1);
	print OUT_html "  <tr>\n";
	print OUT_html "    <th>$line1</th>\n";
	print OUT_html "    <th></th>\n";
	print OUT_html "  </tr>\n";	
	
	
	$tmp="$address{$id}";
	$tmp=encode("utf8", decode("big5", $tmp));
	Encode::_utf8_on($tmp);
	$line=",送貨地址：$tmp";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	$line1="送貨地址：$tmp";
	$line1 = encode("big5", $line1);
	print OUT_html "  <tr>\n";
	print OUT_html "    <th>$line1</th>\n";
	print OUT_html "    <th></th>\n";
	print OUT_html "  </tr>\n";	
	
	
	$line=",訂單型態：";
	$line = encode("big5", $line);
	print OUT "$line\n\n";
	$line1="訂單型態：";
	$line1 = encode("big5", $line1);
	print OUT_html "  <tr>\n";
	print OUT_html "    <th>$line1</th>\n";
	print OUT_html "    <th></th>\n";
	print OUT_html "  </tr>\n";	
	
	
	$line=",項次,名稱,商品明細,每單位數量,總數量,單價,小計,備註";
	$line = encode("big5", $line);
	print OUT "$line\n";
	
	$line1="項次";
	$line1= encode("big5", $line1);
	$line2="名稱";
	$line2 = encode("big5", $line2);
	$line3="商品明細";
	$line3= encode("big5", $line3);
	$line4="每單位數量";
	$line4= encode("big5", $line4);
	$line5="總數量";
	$line5= encode("big5", $line5);
	$line6="單價";
	$line6= encode("big5", $line6);
	$line7="小計";
	$line7= encode("big5", $line7);
	$line8="備註";
	$line8= encode("big5", $line8);
	print OUT_html "<table  style=\"width:100%\">\n";
	print OUT_html "  <thead>\n";
	print OUT_html "    <tr>\n";
	print OUT_html "	  <th align=\"center\" >$line1</th>\n";
	print OUT_html "	  <th align=\"center\" >$line2</th>\n";
	print OUT_html "	  <th align=\"center\" >$line3</th>\n";
	print OUT_html "	  <th align=\"center\" >$line4</th>\n";
	print OUT_html "  	  <th align=\"center\" >$line5</th>\n";
	print OUT_html "	  <th align=\"center\" >$line6</th>\n";
	print OUT_html "	  <th align=\"center\" >$line7</th>\n";
	print OUT_html "	  <th align=\"center\" >$line8</th>\n";
	print OUT_html "    </tr>\n";
	print OUT_html "  </thead>\n";
	
		
	@arrive_goods_id=split " ",$order_products{$id};
	$count=1;
	
	for($i=0; $i<@arrive_goods_id;$i++)
		{
		@tmp2=split "x",$arrive_goods_id[$i];
		$products_id=$tmp2[0];
		$products_count=$tmp2[1];
		$price1=$price{$products_id}*$products_count;
		
		
		$name="$name{$products_id}";
		$name=encode("utf8", decode("big5", $name));
		Encode::_utf8_on($name);
		## 流水號	產品名(產品編號)		數量	單價	小計
		$order_goods="$count,$name($products_id),,,$products_count,$price{$products_id},$price1";
		$order_goods = encode("big5", $order_goods);
		print OUT ",$order_goods\n";
		
		$line1="$count";
		$line1= encode("big5", $line1);
		$line2="$name($products_id)";
		$line2 = encode("big5", $line2);
		$line3="";
		$line3= encode("big5", $line3);
		$line4="$products_count";
		$line4= encode("big5", $line4);
		$line5="";
		$line5= encode("big5", $line5);
		$line6="$price{$products_id}";
		$line6= encode("big5", $line6);
		$line7="$price1";
		$line7= encode("big5", $line7);
		$line8="";
		$line8= encode("big5", $line8);
		print OUT_html "  <tr>\n";
		print OUT_html "	<td align=\"center\" >$line1</th>\n";
		print OUT_html "	<td align=\"center\" >$line2</th>\n";
		print OUT_html "	<td align=\"center\" >$line3</th>\n";
		print OUT_html "	<td align=\"center\" >$line4</th>\n";
		print OUT_html "	<td align=\"center\" >$line5</th>\n";
		print OUT_html "	<td align=\"center\" >$line6</th>\n";
		print OUT_html "	<td align=\"center\" >$line7</th>\n";
		print OUT_html "	<td align=\"center\" >$line8</th>\n";
		print OUT_html "  </tr>\n";
		
		##################
		# 
		# 產品名細項列出
		# 	產品編號, 產品細項, 數量*盒數
		$header=$goods{"header"};
		@header=split ",",$header;
		
		$arrive_goods_tmp=$order{$products_id};
		
		
		@arrive_goods_tmp=split" ",$order_goods_content_id{$products_id};
		$count++;
		
		for($j=0;$j<@arrive_goods_tmp;$j++)
		{
			
			@inside=split "x", $arrive_goods_tmp[$j];
			
			$inside1=$inside[1]*$products_count;
			$name=$name{$inside[0]};
			$name=encode("utf8", decode("big5", $name));
			Encode::_utf8_on($name);
			$line=",,$products_id,$name,$inside[1],$inside1,";
			$line = encode("big5", $line);
			print OUT "$line\n";
			
			
			$line1="";
			$line1= encode("big5", $line1);
			$line2="$products_id";
			$line2 = encode("big5", $line2);
			$line3="$name";
			$line3= encode("big5", $line3);
			$line4="$inside[1]";
			$line4= encode("big5", $line4);
			$line5="$inside1";
			$line5= encode("big5", $line5);
			$line6="";
			$line6= encode("big5", $line6);
			$line7="";
			$line7= encode("big5", $line7);
			$line8="";
			$line8= encode("big5", $line8);
			print OUT_html "  <tr>\n";
			print OUT_html "	<td align='center' >$line1</th>\n";
			print OUT_html "	<td align=\'center\' >$line2</th>\n";
			print OUT_html "	<td align=\'center\'>$line3</th>\n";
			print OUT_html "	<td align=\'center\' >$line4</th>\n";
			print OUT_html "	<td align=\'center\' >$line5</th>\n";
			print OUT_html "	<td align=\'center\' >$line6</th>\n";
			print OUT_html "	<td align=\'center\' >$line7</th>\n";
			print OUT_html "	<td align=\'center\' >$line8</th>\n";
			print OUT_html "  </tr>\n";		
		}
	}
	print OUT_html "</table>\n";
	
	
	$line1="合計";
	$line1= encode("big5", $line1);
	$line2="銷售稅";
	$line2 = encode("big5", $line2);
	$line3="總計";
	$line3= encode("big5", $line3);
	$line4="$products_count";
	print OUT_html "<table  style=\"width:100%\">\n";	
	print OUT_html "  <tr>\n";	
	print OUT_html "    <th>$line1</th>\n";	
	print OUT_html "    <th>$price{$id}</th>\n";	
	print OUT_html "    <th>$line2</th>\n";	
	print OUT_html "    <th>-</th>\n";	
	print OUT_html "    <th>$line3</th>\n";	
	print OUT_html "    <th>$price{$id}</th>\n";	
	print OUT_html "  </tr>\n";	
	print OUT_html "</table>\n\n";	
	
	$tmp="$note{$id}";
	$tmp=encode("utf8", decode("big5", $tmp));
	Encode::_utf8_on($tmp);
	$tmp = encode("big5", $tmp);
	$line1="備註:";
	$line1= encode("big5", $line1);
	$line2="感謝您的惠顧";
	$line2 = encode("big5", $line2);
	$line3="百歐新創食品科技有限公司";
	$line3= encode("big5", $line3);
	$line4="0800-668-611";
	$line4= encode("big5", $line4);
	$line5="biofraiche\@gmail.com";
	$line5= encode("big5", $line5);
	print OUT_html "<p>$line1$tmp</p>\n";	
	print OUT_html "<p align=\"center\"></p>\n";	
	print OUT_html "<p align=\"center\">$line2</p>\n";	
	print OUT_html "<p align=\"center\">$line3</p>\n";	
	print OUT_html "<p align=\"center\">$line4</p>\n";	
	print OUT_html "<p align=\"center\">$line5</p>\n";	
	
	
	$line1="客戶簽收";
	$line1= encode("big5", $line1);
	$line2="倉庫";
	$line2 = encode("big5", $line2);
	$line3="出納";
	$line3= encode("big5", $line3);
	$line4="審核";
	$line4= encode("big5", $line4);
	$line5="填表";
	$line5= encode("big5", $line5);
	print OUT_html "<table  style=\"width:100%\">\n";	
	print OUT_html "  <tr>\n";	
	print OUT_html "    <th>$line1</th>\n";	
	print OUT_html "    <th>$line2</th>\n";	
	print OUT_html "    <th>$line3</th>\n";	
	print OUT_html "    <th>$line4</th>\n";	
	print OUT_html "    <th>$line5</th>\n";	
	print OUT_html "  </tr>\n";	
	print OUT_html "    <th height=\"100\"></th>\n";
	print OUT_html "    <th height=\"100\"></th>\n";
	print OUT_html "    <th height=\"100\"></th>\n";
	print OUT_html "    <th height=\"100\"></th>\n";
	print OUT_html "    <th height=\"100\"></th>\n";
	print OUT_html "  </tr>\n";	
	print OUT_html "</table>\n";	
	print OUT_html "</body>\n";	
	print OUT_html "</html>\n";	
	
	
	print OUT "\n\n";
	$line=",合計, $price{$id},,銷售稅 - ,,總計 $price{$id}";
	$line = encode("big5", $line);
	print OUT "$line\n";
	$line=",備註:";
	$line = encode("big5", $line);
	print OUT "$line$tmp\n\n";
	$line=",,感謝您的惠顧,,,,";
	$line = encode("big5", $line);
	print OUT "$line\n";
	$line=",,百歐新創食品科技有限公司";
	$line = encode("big5", $line);
	print OUT "$line\n";
	$line=",,0800-668-611";
	$line = encode("big5", $line);
	print OUT "$line\n";
	$line=",,biofraiche\@gmail.com,";
	$line = encode("big5", $line);
	print OUT "$line\n";
	$line=",客戶簽收,,倉庫,,出納,,審核,,填表";
	$line = encode("big5", $line);
	print OUT "$line\n\n\n";
	
	close OUT;
	close OUT_html;
}

############################
# 
# Output 總表 & 製造表
# 
system '
	if [ ! -d "Gernal_table" ] ;then
		mkdir Gernal_table
	fi
	if [ ! -d "Working_table" ] ;then
		mkdir Working_table
	fi
';
use POSIX qw/strftime/;
my $time = strftime('%Y-%m-%d-%H-%M-%S',localtime);

$line="總表整理";
$line = encode("big5", $line);

$tmp="產生本批次網路訂單\"總表整理\" : 總表整理_$time.csv\n 存放於 Gernal_table/ 資料夾";
$tmp = encode("big5", $tmp);
print  "$tmp\n\n";

open(OUT_gernal,">./Gernal_table/$line\_$time.csv")||die "$!";

#####################
# 
# 總表
# 
$tmp="訂購人姓名,訂單日期,訂購方式,訂單編號,訂購人電話,收件人姓名,連絡電話,寄送地址,取貨方式,到貨時間,產品編號,總數量,商品總價小計,物流費用,應收款,收款情形,備註";
Encode::_utf8_on($tmp);
$tmp = encode("big5", $tmp);
print OUT_gernal "$tmp\n";

for ($k=0;$k<@id;$k++)
{
	$id=$id[$k];
	
	#####################
	# 
	# 總表
	# 
	print OUT_gernal "$source{$id},";			#0 訂購人姓名,
	print OUT_gernal "$time{$id},";				#1 訂單日期,
	
	$tmp="網路";
	Encode::_utf8_on($tmp);
	$tmp = encode("big5", $tmp);
	print OUT_gernal "$tmp,";					#2 訂購方式,
	print OUT_gernal "$id,";					#3 訂單編號,
	print OUT_gernal ":$source_phone{$id},";	#4 訂購人電話,
	print OUT_gernal "$arrive{$id},";			#5 收件人姓名,
	print OUT_gernal ":$arrive_phone{$id} ,";	#6 連絡電話,
	print OUT_gernal "$address{$id},";			#7 寄送地址,
	print OUT_gernal ",";						#8 取貨方式,
	print OUT_gernal ",";						#9 到貨時間,
	print OUT_gernal "$order_products{$id},";	#10 產品編號,
	print OUT_gernal "$order_total_count{$id},";#11 總數量,
	print OUT_gernal "$price{$id},";			#12 商品總價小計,
	print OUT_gernal ",";						#13 物流費用,
	print OUT_gernal ",";						#14 應收款,
	print OUT_gernal ",";						#15 收款情形,
	print OUT_gernal "$note{$id}\n";			#16 備註
}
close OUT_gernal;

#print "test1\n";

$line="製造需求";
$line = encode("big5", $line);

$tmp="產生此批網路訂單 \"製造需求\" : 製造需求_$time.csv\n 存放於 Working_table/ 資料夾";
$tmp = encode("big5", $tmp);
print  "$tmp\n";

open(OUT_working,">./Working_table/$line\_$time.csv")||die "$!";
$tmp="產品編號,產品名,盒數,獨享杯清爽,獨享杯微甜,家庭號清爽,家庭號微甜,芸香四物精華釀,優格飲香柚,優格飲黑莓";
Encode::_utf8_on($tmp);
$tmp = encode("big5", $tmp);
print OUT_working "$tmp\n";

my %A1;
my %A2;
my %A3;
my %A4;
my %B1;
my %C1;
my %C2;
my @name;
my @material;
my @material_tmp;
my $product;
my $material;
my %material_head;
my %material;
my $material_total;
my %material_total;
my $material_fold;
my %material_fold;
my ($m1,$m2,$m3,$m4,$m5);

foreach $id(sort keys %total)
{
	
	if( $id eq "")
	{}
	else
	{
		@tmp=split " ",$order_goods_content_id{$id}; # 產品細項
		for($i=0;$i<@tmp;$i++)
		{
			@tmp2=split "x",$tmp[$i];
			$products_id=$tmp2[0];
			$products_count=$tmp2[1]*$total{$id};
			
			
			if($products_id eq "A1")
			{
				$A1{$id}=$A1{$id}+$products_count;
				$A1{"total"}=$A1{"total"}+$products_count;
			}
			elsif($products_id eq "A2")
			{
				$A2{$id}=$A2{$id}+$products_count;
				$A2{"total"}=$A2{"total"}+$products_count;
			}
			elsif($products_id eq "A3")
			{
				$A3{$id}=$A3{$id}+$products_count;
				$A3{"total"}=$A3{"total"}+$products_count;
			}
			elsif($products_id eq "A4")
			{
				$A4{$id}=$A4{$id}+$products_count;
				$A4{"total"}=$A4{"total"}+$products_count;
			}
			elsif($products_id eq "B1")
			{
				$B1{$id}=$B1{$id}+$products_count;
				$B1{"total"}=$B1{"total"}+$products_count;
			}
			elsif($products_id eq "C1")
			{
				$C1{$id}=$C1{$id}+$products_count;
				$C1{"total"}=$C1{"total"}+$products_count;
			}
			elsif($products_id eq "C2")
			{
				$C2{$id}=$C2{$id}+$products_count;
				$C2{"total"}=$C2{"total"}+$products_count;
			}
			$products_count=0;
		}
	}
	print OUT_working "$id,";				#產品編號,
	
	$name="$name{$id}";
	$name=encode("utf8", decode("big5", $name));
	$tmp="$name";
	Encode::_utf8_on($tmp);
	$tmp = encode("big5", $tmp);
	print OUT_working "$tmp,";				#產品名,
	
	print OUT_working "$total{$id},";		#盒數,
	print OUT_working "$A1{$id},";			#獨享杯清爽,
	print OUT_working "$A2{$id},";			#獨享杯微甜,
	print OUT_working "$A3{$id},";			#家庭號清爽,
	print OUT_working "$A4{$id},";			#家庭號微甜,
	print OUT_working "$B1{$id},";			#芸香四物精華釀,
	print OUT_working "$C1{$id},";			#優格飲香柚,
	print OUT_working "$C2{$id}\n";			#優格飲黑莓
	
	#print OUT_working "\n";
	
	
}
#print "test2\n";

#"product_name,味全豆漿(g),義美豆漿(g),水(g),香柚果漿(g),黑莓果漿(g),四物濃縮液(g),砂糖(g),麥芽糖(g),黃金糖漿(g),海藻糖(g),total(g),每單位(g),每批生產單位";
@name=qw/清爽_獨享杯+家庭號 微甜_獨享杯+家庭號 四物 優格飲香柚 優格飲黑莓/;
@material=qw/A1,A3 A2,A4 B1 C1 C2/;

print OUT_working "\n\n";

$id="total";
##################
#"A1,A3" 

$product="A1";
$material_total{$product}=150*$A1{$id}+900*$A3{$id};
@material_tmp=split ",",$recipe{$product};
$material_fold{$product} = $material_total{$product}/$material_tmp[10];
$material_head{$product} = "味全豆漿(g),義美豆漿(g),黃金糖漿(g),海藻糖(g)";

$m1=$material_tmp[0]*$material_fold{$product};
$m2=$material_tmp[1]*$material_fold{$product};
$m3=$material_tmp[8]*$material_fold{$product};
$m4=$material_tmp[9]*$material_fold{$product};
$material{$product} = "$m1,$m2,$m3,$m4";

$name="清爽_獨享杯+家庭號";
	
$tmp="產品,總需求量(g),$material_head{$product}";
$tmp = encode("big5", $tmp);
print OUT_working "$tmp\n";
	
$line="$name,$material_total{$product},$material{$product}";
$line = encode("big5", $line);
print OUT_working "$line\n\n";

##########
#"A2,A4"
$product="A2";
$material_total{$product}=150*$A2{$id}+900*$A4{$id};
@material_tmp=split ",",$recipe{$product};
$material_fold{$product} = $material_total{$product}/$material_tmp[10];
$material_head{$product} = "味全豆漿(g),義美豆漿(g),黃金糖漿(g),海藻糖(g)";
$m1=$material_tmp[0]*$material_fold{$product};
$m2=$material_tmp[1]*$material_fold{$product};
$m3=$material_tmp[8]*$material_fold{$product};
$m4=$material_tmp[9]*$material_fold{$product};
$material{$product} = "$m1,$m2,$m3,$m4";

$name="微甜_獨享杯+家庭號";
	
$tmp="產品,總需求量(g),$material_head{$product}";
$tmp = encode("big5", $tmp);
print OUT_working "$tmp\n";
	
$line="$name,$material_total{$product},$material{$product}";
$line = encode("big5", $line);
print OUT_working "$line\n\n";

##########
#"B1"
$product="B1";
$material_total{$product}=190*$B1{$id};
@material_tmp=split ",",$recipe{$product};
$material_fold{$product} = $material_total{$product}/$material_tmp[10];
$material_head{$product} = "四物濃縮液(g),砂糖(g),麥芽糖(g)";

$m1=$material_tmp[5]*$material_fold{$product};
$m2=$material_tmp[6]*$material_fold{$product};
$m3=$material_tmp[7]*$material_fold{$product};

$material{$product} = "$m1,$m2,$m3";

$name="芸香四物精華釀";
	
$tmp="產品,總需求量(g),$material_head{$product}";
$tmp = encode("big5", $tmp);
print OUT_working "$tmp\n";
	
$line="$name,$material_total{$product},$material{$product}";
$line = encode("big5", $line);
print OUT_working "$line\n\n";

################
#"C1"
$product="C1";
$material_total{$product}=150*$C1{$id};
@material_tmp=split ",",$recipe{$product};
$material_fold{$product} = $material_total{$product}/$material_tmp[10];
$material_head{$product} = "味全豆漿(g),水(g),香柚果漿(g),黃金糖漿(g)";
	
$m1=$material_tmp[0]*$material_fold{$product};
$m2=$material_tmp[2]*$material_fold{$product};
$m3=$material_tmp[3]*$material_fold{$product};
$m4=$material_tmp[8]*$material_fold{$product};
$material{$product} = "$m1,$m2,$m3,$m4";

$name="優格飲香柚";
	
$tmp="產品,總需求量(g),$material_head{$product}";
$tmp = encode("big5", $tmp);
print OUT_working "$tmp\n";
	
$line="$name,$material_total{$product},$material{$product}";
$line = encode("big5", $line);
print OUT_working "$line\n\n";

###########
#"C2"
$product="C2";
$material_total{$product}=150*$C2{$id};
@material_tmp=split ",",$recipe{$product};
$material_fold{$product} = $material_total{$product}/$material_tmp[10];
$material_head{$product} = "味全豆漿(g),水(g),黑莓果漿(g),黃金糖漿(g)";
$m1=$material_tmp[0]*$material_fold{$product};
$m2=$material_tmp[2]*$material_fold{$product};
$m3=$material_tmp[4]*$material_fold{$product};
$m4=$material_tmp[8]*$material_fold{$product};
$material{$product} = "$m1,$m2,$m3,$m4";


$name="優格飲黑莓";
	
$tmp="產品,總需求量(g),$material_head{$product}";
$tmp = encode("big5", $tmp);
print OUT_working "$tmp\n";
	
$line="$name,$material_total{$product},$material{$product}";
$line = encode("big5", $line);
print OUT_working "$line\n\n";


close OUT_working;









