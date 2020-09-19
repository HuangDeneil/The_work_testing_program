from opencc import OpenCC
import re
import os
import sys

############################################################
# 
# This Pyhton is greping basic microorganism infomation from latex file
# 
# Uasge :
#    python3 simple_cn_to_traditional_cn.py argv[1] >argv[2]
# argv[1] >>>  input latex
# argv[2] >>>  output csv file
# 
# python3 simple_cn_to_traditional_cn.py test3.tex >test
# 

open_path = sys.argv[1]

if len(sys.argv) < 2:
    #s = twstock.Stock(sys.argv[1])
    print(s.price[-5:])

#print(len(sys.argv))


#############   Function 部分
# 繁轉中 設定
cc = OpenCC('s2twp')     # Simplified Chinese to Taiwan Traditional Chinese
def sc2tc(s_chinese_line):
	t_chinese_line = cc.convert(s_chinese_line)
	return t_chinese_line

# 設定檔案路徑


with open (open_path ,mode = "r", encoding = "utf-8") as file:
    for i in file:
        tradition_cn = sc2tc(i).rstrip()           ## rstrip() >>>  perl chomp;
        print(tradition_cn )
        


