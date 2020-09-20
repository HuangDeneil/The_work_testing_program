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


###########################
######               ######
######  The bottons  ######
######               ######
###########################
bacteria_botton = False
fungi_botton = False
virus_botton = False
parasite_botton = False
TB_botton = False
mycoplasma_botton = False
data_start = False

sample_type = ""
halos_id = ""

info = []
microorganism_name = ""
genus = ""
gram_stain = ""
top_type = ""
chinses_name = ""
description = ""

basic_info_dict = {}
discription_dic = {}
reference_dict = {}

ref_count = 1
PMID = ""
reference = ""
reference_text = ""
reference_list = ""
reference1 = ""
reference2 = ""
reference3 = ""
reference4 = ""
reference5 = ""

# 設定檔案路徑
open_path = sys.argv[1]

with open (open_path ,mode = "r", encoding = "utf-8") as file:
    for i in file:
        tradition_cn = sc2tc(i).rstrip()           ## rstrip() >>>  perl chomp;
        #print(tradition_cn )
        #pattern = '樣本型別：'
        if r'樣本型別：' in tradition_cn:
            if r'樣本編號：' in tradition_cn:
                regex = re.compile(r'樣本編號：(.+)? \& 樣本型別：(.+)? \&')
                match = regex.search(tradition_cn)
                sample_type = match.group(2)
                halos_id = match.group(1)
                #print(halos_id,sample_type)
        
        if r'檢出細菌列表' in tradition_cn:
            bacteria_botton = True
            data_start=False
        if r'檢出真菌列表' in tradition_cn:        
            fungi_botton = True 
            data_start=False
        if r'檢出病毒列表' in tradition_cn:
            virus_botton = True 
            data_start=False
        if r'檢出寄生蟲列表' in tradition_cn:
            parasite_botton = True 
            data_start=False
        if r'檢出結核分枝桿菌複合群列表' in tradition_cn:
            TB_botton = True
            data_start=False
        if r'檢出支原體/衣原體/立克次體列表' in tradition_cn:
            mycoplasma_botton = True
            data_start=False
        
        if re.findall('bottomrule', tradition_cn):
            bacteria_botton = False  
            fungi_botton = False
            virus_botton = False
            parasite_botton = False
            TB_botton = False
            mycoplasma_botton = False
            info = []
        
        ##########################################
        ##########                      ##########
        ########## grep bacteria table  ##########
        ##########                      ##########
        ##########################################
        if bacteria_botton == True:
            #print(tradition_cn)
            
            if r'中文名' in tradition_cn:
                data_start = True
            if data_start == True:
                #print(tradition_cn)
                tradition_cn = tradition_cn.replace('\\midrule',',')
                tradition_cn = tradition_cn.replace('%','')
                tradition_cn = tradition_cn.replace('\\emph',',')
                tradition_cn = tradition_cn.replace('{','')
                tradition_cn = tradition_cn.replace('}','')
                tradition_cn = tradition_cn.replace('\\','')
                tradition_cn = tradition_cn.replace('\t','')
                tradition_cn = tradition_cn.replace(',','')
                tradition_cn = tradition_cn.replace('$','')
                tradition_cn = tradition_cn.replace('^','')
                tradition_cn = tradition_cn.replace(' & ',',')
                tradition_cn = tradition_cn.replace('&',',')
                
                if tradition_cn == "":
                    test="doing nothing"
                elif r'中文名' in tradition_cn:
                    test="doing nothing"
                else:
                    info = tradition_cn.split(",")
                    if r'未發現' in info[0] :
                        test="doing nothing"
                    elif info[2] == "":
                        microorganism_name = info[5]
                        chinses_name = info[4]
                        top_type="bacteria"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #movie_1['star'] = "Tom Hank"
                            #print(basic_info_dict[microorganism_name])
                    else:
                        genus = info[2]
                        gram_stain = info[0]
                        microorganism_name = info[5]
                        chinses_name = info[4]
                        top_type="bacteria"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])
                
        ##########################################
        ##########                      ##########
        ##########   grep fungi table   ##########
        ##########                      ##########
        ##########################################
        if fungi_botton == True :
            if r'中文名' in tradition_cn:
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
                tradition_cn = tradition_cn.replace('$','')
                tradition_cn = tradition_cn.replace('^','')
                tradition_cn = tradition_cn.replace(' & ',',')
                tradition_cn = tradition_cn.replace('&',',')
                if tradition_cn == "":
                    test="doing nothing"
                elif r'中文名' in tradition_cn:
                    test="doing nothing"
                else:
                    info = tradition_cn.split(",")
                    #print(info)
                    if r'未發現' in info[0] :
                        test="doing nothing"
                    elif info[1] == "":
                        gram_stain = ""
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="fungi"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])
                    else:
                        gram_stain = ""
                        genus = info[1]
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="fungi"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])

                
        ##########################################
        ##########                      ##########
        ##########   grep virus table   ##########
        ##########                      ##########
        ##########################################
        if virus_botton == True :
            if r'中文名' in tradition_cn:
                data_start = True
            if data_start == True:
                #print(tradition_cn)
                tradition_cn = tradition_cn.replace('\\midrule',',')
                tradition_cn = tradition_cn.replace('%','')
                tradition_cn = tradition_cn.replace('\\emph',',')
                tradition_cn = tradition_cn.replace('{','')
                tradition_cn = tradition_cn.replace('}','')
                tradition_cn = tradition_cn.replace('\\','')
                tradition_cn = tradition_cn.replace('\t','')
                tradition_cn = tradition_cn.replace(',','')
                tradition_cn = tradition_cn.replace('$','')
                tradition_cn = tradition_cn.replace('^','')
                tradition_cn = tradition_cn.replace(' & ',',')
                tradition_cn = tradition_cn.replace('&',',')
                #print(tradition_cn)
                if tradition_cn == "":
                    test="doing nothing"
                elif r'中文名' in tradition_cn:
                    test="doing nothing"
                else:
                    info = tradition_cn.split(",")
                    #print(info)
#['dsDNA', 'α乳頭瘤病毒7型', 'Alphapapillomavirus 7', '1516', '人乳頭瘤病毒18型', 'Human papillomavirus type 18', '1456 ']
                    if r'未發現' in info[0] :
                        test="doing nothing"
                    elif info[1] == "":
                        gram_stain = ""
                        species = info[2]
                        microorganism_name = info[5]
                        chinses_name = info[4]
                        top_type="virus"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,species,gram_stain,chinses_name,top_type)
                            print(basic_info_dict[microorganism_name])
                    else:
                        gram_stain = ""
                        genus = ""
                        species = info[2]
                        microorganism_name = info[5]
                        chinses_name = info[4]
                        top_type="virus"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,species,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])  
                    #print(info)

        #############################################
        ##########                         ##########
        ##########   grep parasite table   ##########
        ##########                         ##########
        #############################################
        if parasite_botton == True :
            if r'中文名' in tradition_cn:
                data_start = True
            if data_start == True:
                #print(tradition_cn)
                tradition_cn = tradition_cn.replace('\\midrule',',')
                tradition_cn = tradition_cn.replace('%','')
                tradition_cn = tradition_cn.replace('\\emph',',')
                tradition_cn = tradition_cn.replace('{','')
                tradition_cn = tradition_cn.replace('}','')
                tradition_cn = tradition_cn.replace('\\','')
                tradition_cn = tradition_cn.replace('\t','')
                tradition_cn = tradition_cn.replace(',','')
                tradition_cn = tradition_cn.replace('$','')
                tradition_cn = tradition_cn.replace('^','')
                tradition_cn = tradition_cn.replace(' & ',',')
                tradition_cn = tradition_cn.replace('&',',')
                #print(tradition_cn)
                if tradition_cn == "":
                    test="doing nothing"
                elif r'中文名' in tradition_cn:
                    test="doing nothing"
                else:
                    info = tradition_cn.split(",")
                    
                    if r'未發現' in info[0] :
                        test="doing nothing"
                    elif info[1] == "":
                        gram_stain = ""
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="parasite"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])
                    else:
                        gram_stain = ""
                        genus = info[1]
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="parasite"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])                    
        
        
        #######################################
        ##########                   ##########
        ##########   grep TB table   ##########
        ##########                   ##########
        #######################################
        if TB_botton == True :
            if r'中文名' in tradition_cn:
                data_start = True
            if data_start == True:
                #print(tradition_cn)
                tradition_cn = tradition_cn.replace('\\midrule',',')
                tradition_cn = tradition_cn.replace('%','')
                tradition_cn = tradition_cn.replace('\\emph',',')
                tradition_cn = tradition_cn.replace('{','')
                tradition_cn = tradition_cn.replace('}','')
                tradition_cn = tradition_cn.replace('\\','')
                tradition_cn = tradition_cn.replace('\t','')
                tradition_cn = tradition_cn.replace(',','')
                tradition_cn = tradition_cn.replace('$','')
                tradition_cn = tradition_cn.replace('^','')
                tradition_cn = tradition_cn.replace(' & ',',')
                tradition_cn = tradition_cn.replace('&',',')
                #print(tradition_cn)
                if tradition_cn == "":
                    test="doing nothing"
                elif r'中文名' in tradition_cn:
                    test="doing nothing"
                else:
                    info = tradition_cn.split(",")
                    
                    if r'未發現' in info[0] :
                        test="doing nothing"
                    elif info[1] == "":
                        gram_stain = ""
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="TB"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])
                    else:
                        gram_stain = ""
                        genus = info[1]
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="TB"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])                    
        
        
        
        ###################################################################
        ##########                                                ##########
        ##########   grep Mycoplasma/Chlamydia/Rickettsia table   ##########
        ##########                                                ##########
        ####################################################################
        if TB_botton == True :
            if r'中文名' in tradition_cn:
                data_start = True
            if data_start == True:
                #print(tradition_cn)
                tradition_cn = tradition_cn.replace('\\midrule',',')
                tradition_cn = tradition_cn.replace('%','')
                tradition_cn = tradition_cn.replace('\\emph',',')
                tradition_cn = tradition_cn.replace('{','')
                tradition_cn = tradition_cn.replace('}','')
                tradition_cn = tradition_cn.replace('\\','')
                tradition_cn = tradition_cn.replace('\t','')
                tradition_cn = tradition_cn.replace(',','')
                tradition_cn = tradition_cn.replace('$','')
                tradition_cn = tradition_cn.replace('^','')
                tradition_cn = tradition_cn.replace(' & ',',')
                tradition_cn = tradition_cn.replace('&',',')
                #print(tradition_cn)
                if tradition_cn == "":
                    test="doing nothing"
                elif r'中文名' in tradition_cn:
                    test="doing nothing"
                else:
                    info = tradition_cn.split(",")
                    
                    if r'未發現' in info[0] :
                        test="doing nothing"
                    elif info[1] == "":
                        gram_stain = ""
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="Mycoplasma/Chlamydia/Rickettsia"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])
                    else:
                        gram_stain = ""
                        genus = info[1]
                        microorganism_name = info[4]
                        chinses_name = info[3]
                        top_type="Mycoplasma/Chlamydia/Rickettsia"
                        if microorganism_name == "-":
                            microorganism_name = "unknown"
                        elif microorganism_name == "":
                            microorganism_name = "unknown"
                        else:
                            basic_info_dict[microorganism_name]=(microorganism_name,genus,microorganism_name,gram_stain,chinses_name,top_type)
                            #print(basic_info_dict[microorganism_name])   

        ########################################
        ####                                ####
        #### grep microorganism Description ####
        ####                                ####
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
            discription_dic[microorganism_name]=(description)
            #print(microorganism_name,discription_dic[microorganism_name])
            
            
        #
       
        if r'\noindent\zihao' in tradition_cn:
            
            ref = re.compile(r'PMID: (\d+)?\.( )?(.+)')
            match = ref.search(tradition_cn)
            PMID  = match.group(1)
            reference = match.group(3)
            reference_text=reference+",PMID:"+PMID
            reference_dict[ref_count] = (reference_text)
            #print(reference_dict[ref_count])
            ref_count += 1
print ()
#print("microorganism_name\tgenus\tgram_stain\tchinses_name\ttop_type\tdescription")
for i in basic_info_dict.keys():
    data_tuple=(basic_info_dict[i])
    #print(str(type(test)))
    microorganism_name = data_tuple[0]
    genus = data_tuple[1]
    gram_stain = data_tuple[2]
    chinses_name = data_tuple[3]
    top_type = data_tuple[4]
    try:
        description = discription_dic[microorganism_name]
    except KeyError:
        description = ""
    #$^[3]$。
    #$^{\circ}$
    description = description.replace('{','')
    description = description.replace('}','')
    description = description.replace('^','')
    description = description.replace('$\circ$','度')
    description_reserve = description
    description = description.replace('[','')
    description = description.replace(']','')
    description_list = description.split('$')
    description = description_reserve.replace('$','')
    
    if len(description_list) < 3:
        reference_list = ""
    elif len(description_list) == 3:
        reference1 = (description_list[1]+"."+reference_dict[int(description_list[1])])
        reference_list = (reference1)
    elif len(description_list) == 5:
        reference1 = (description_list[1]+"."+reference_dict[int(description_list[1])])
        reference2 = (description_list[3]+"."+reference_dict[int(description_list[3])])
        reference_list = (reference1+","+reference2)
    elif len(description_list) == 7:
        reference1 = (description_list[1]+"."+reference_dict[int(description_list[1])])
        reference2 = (description_list[3]+"."+reference_dict[int(description_list[3])])
        reference3 = (description_list[5]+"."+reference_dict[int(description_list[5])])
        reference_list = (reference1+","+reference2+","+reference3)
    elif len(description_list) == 9:
        reference1 = (description_list[1]+"."+reference_dict[int(description_list[1])])
        reference2 = (description_list[3]+"."+reference_dict[int(description_list[3])])
        reference3 = (description_list[5]+"."+reference_dict[int(description_list[5])])
        reference4 = (description_list[7]+"."+reference_dict[int(description_list[7])])
        reference_list = (reference1+","+reference2+","+reference3+","+reference4)
    elif len(description_list) == 11:
        reference1 = (description_list[1]+"."+reference_dict[int(description_list[1])])
        reference2 = (description_list[3]+"."+reference_dict[int(description_list[3])])
        reference3 = (description_list[5]+"."+reference_dict[int(description_list[5])])
        reference4 = (description_list[7]+"."+reference_dict[int(description_list[7])])
        reference5 = (description_list[9]+"."+reference_dict[int(description_list[11])])
        reference_list = (reference1+","+reference2+","+reference3+","+reference4+","+reference5)
    
    print(microorganism_name+"\t"+genus+"\t"+gram_stain+"\t"+chinses_name+"\t"+top_type+"\t"+halos_id+"\t"+sample_type+"\t"+description+"\t\""+reference_list+"\"\t")


#print ("\n")
'''
for i in reference_dict.keys():
    print(str(i)+"."+reference_dict[i])
'''


