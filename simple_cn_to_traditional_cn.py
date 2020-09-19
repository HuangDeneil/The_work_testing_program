import pandas as pd
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



#############   Function 部分
# 繁轉中 設定
cc = OpenCC('s2twp')     # Simplified Chinese to Taiwan Traditional Chinese
def sc2tc(s_chinese_line):
	t_chinese_line = cc.convert(s_chinese_line)
	return t_chinese_line

bacteria = []
fungi = []
virus = []
parasite = []
TB = []
mycoplasma = []
reference = []

bacteria_boton = False
fungi_boton = False
virus_boton = False
TB_boton = False
mycoplasma_boton = False


bacteria_data = False


ref_count = 1
PMID=""
reference=""
reference_text=""
reference_dict={}


# 設定檔案路徑
open_path = sys.argv[1]

with open (open_path ,mode = "r", encoding = "utf-8") as file:
    for i in file:
        tradition_cn = sc2tc(i).rstrip()           ## rstrip() >>>  perl chomp;
        #print(tradition_cn )
        #pattern = '樣本型別：'
        if r'樣本型別：' in tradition_cn:
            regex = re.compile(r'樣本型別：(.+)?\&')
            match = regex.search(tradition_cn)
            #m = re.match(r'www\.(.+)\.com', 'www.xxx.com')
            sample_type = match.group(1)
            #print(sample_type)
        
        if r'檢出細菌列表' in tradition_cn:
            bacteria_boton = True
            data_start=False
        if r'檢出真菌列表' in tradition_cn:        
            fungi_boton = True 
            data_start=False
        if r'檢出病毒列表' in tradition_cn:
            virus_boton = True 
            data_start=False
        if r'檢出寄生蟲列表' in tradition_cn:
            parasite_boton = True 
            data_start=False
        if r'檢出結核分枝桿菌複合群列表' in tradition_cn:
            TB_boton = True
            data_start=False
        if r'檢出支原體/衣原體/立克次體列表' in tradition_cn:
            mycoplasma_boton = True
            data_start=False
        
        if re.findall('bottomrule', tradition_cn):
            bacteria_boton = False  
            fungi_boton = False
            virus_boton = False
            parasite_boton = False
            TB_boton = False
            mycoplasma_boton = False
        

        if bacteria_boton == True:
            #print(tradition_cn)
            
            if r'\midrule' in tradition_cn:
                data_start = True
            if data_start == True:
                tradition_cn = tradition_cn.replace('\\midrule',',')
                tradition_cn = tradition_cn.replace('%','')
                tradition_cn = tradition_cn.replace('\\emph',',')
                tradition_cn = tradition_cn.replace('{','')
                tradition_cn = tradition_cn.replace('}','')
                tradition_cn = tradition_cn.replace('\\','')
                tradition_cn = tradition_cn.replace('\t','')
                tradition_cn = tradition_cn.replace(',','')
                
                
                
                print(tradition_cn)
                ref = re.compile(r'$G^-$ &')
                #match = ref.search(tradition_cn)
                #PMID  = match.group(1)
                #reference = match.group(3)
            #
# $G^-$ & 羅爾斯頓菌屬 & ,Ralstonia & 2655610 & 解甘露醇羅爾斯頓菌 & ,Ralstonia mannitolilytica & 2332242 \\
#  &  &  &  & 皮氏羅爾斯頓菌 & ,Ralstonia pickettii & 997 \\
        
        
        ########################################
        ########################################
        #### grep microorganism Description ####
        ########################################
        ########################################
        if r'{\bf' in tradition_cn:
            
            tradition_cn = tradition_cn.replace('{','')
            tradition_cn = tradition_cn.replace('(','')
            tradition_cn = tradition_cn.replace('\\bf ',',')
            tradition_cn = tradition_cn.replace('\\bf',',')
            tradition_cn = tradition_cn.replace('\\emph',',')
            tradition_cn = tradition_cn.replace('}','')
            tradition_cn = tradition_cn.replace(')','')
            sep1 = tradition_cn.replace(': ',",")
            sep2 = sep1.split(',')
            chinses_name = sep2[1]
            microorganism_name = sep2[2]
            description = sep2[3]
            discription_dic={
                microorganism_name : description
            }
            
            #for i in discription_dic.keys():
            #    print (i)
            
        #
       
        if r'\noindent\zihao' in tradition_cn:
            
            ref = re.compile(r'PMID: (\d+)?\.( )?(.+)')
            match = ref.search(tradition_cn)
            PMID  = match.group(1)
            reference = match.group(3)
            reference_text=reference+",PMID:"+PMID
            reference_dict = {
                ref_count : reference_text
            }
            ref_count += 1


