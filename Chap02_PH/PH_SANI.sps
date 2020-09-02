* Encoding: UTF-8.
*********************************************************************
program: 			PH_SANI.sps
Purpose: 			creates variable for binary improved sanitation according to JSTOR standard 
Data inputs: 		hr or pr file
Data outputs:		none
Author of do file:	03/15/2018	Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified: 08/26/2020 Ivana Bjelic - for codeshare project
**********************************************************************.

*
Note:			These indicators can also be computed using the HR or PR file
			If you want to produce estimates for households, use the HR file
			If you want to produce estimates for the de jure population, 
			use the PR file and select for dejure household memebers using
			hv102=1. Please see the Guide to DHS Statistics.  
*****************************************************************************************************/

*------------------------------------------------------------------------------
This sps file can be run on any loop of countries indicating the dataset name 
with variable called filename. Code should be same for pr or hr files.

*VARIABLES CREATED:
*
	ph_sani_type	"Type of sanitation facility"
	ph_sani_improve	"Access to improved sanitation"
	ph_sani_basic	"Basic or limited sanitation facility"
	ph_sani_location	"Location of sanitation facility"
					
*	
NOTE: 
STANDARD CATEGORIES FOR WATER SOURCE BY IMPROVED/UNIMPROVED
		1-improved
			11	 flush - to piped sewer system
			12	 flush - to septic tank
			13	 flush - to pit latrine
			14	 flush - to somewhere else
			15               flush - don't know where
			16	 flush - unspecified
			20               pit latrine - improved but shared
			21	 pit latrine - ventilated improved pit (vip)
			22	 pit latrine - with slab
			41	 composting ph_sani_type
			51	 other improved
		2-unimproved 
			23	 pit latrine - without slab / open pit
			42	 bucket ph_sani_type
			43	 hanging ph_sani_type/latrine
			96	 other
		3-open defecation
			31	 no facility/bush/field/river/sea/lake.



* generate type of sanitation facility  
*--------------------------------------------------------------------------
NOTE: this cycles through ALL country specific coding and ends around line 1677
*--------------------------------------------------------------------------.

do if file1 = "af" and file2 = "70".
+recode hv205
    (43 = 23)
    (44 = 51)
    (else=copy) 
    into ph_sani_type.

else if file1 = "am" and file2 = "42".
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 23)
    (else=copy)
    into ph_sani_type.

else if file1 = "am" and file2 = "54".
+recode hv205 
    (41 = 42)
    (else=copy) 
    into ph_sani_type.

else if file1 = "am" and file2 = "61".
+recode hv205 
    (44 = 15)
    (else=copy)
     into ph_sani_type.

else if file1 = "ao" and file2 = "71".
+recode hv205 
    (13 = 14)
    (14 = 11)
    (15 = 12)
    (16 = 14)
    (17 = 11)
    (18 = 12)
    (19 = 14)
    (22 = 21)
    (24 = 21)
    (25 = 21)
    (26 = 23)
    (27 = 21)
    (28 = 21)
    (29 = 23)
    (42 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bd" and file2 = "31".
+recode hv205
    (11 = 12)
    (21 = 22)
    (22 = 23)
    (24 = 43)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bd" and file2 = "3a".
+recode hv205 
    (11 = 12)
    (21 = 22)
    (22 = 23)
    (24 = 43)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bd" and file2 = "41".
+recode hv205 
    (11 = 12)
    (21 = 22)
    (22 = 23)
    (24 = 43)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bd" and file2 = "4j".
+recode hv205 
    (11 = 12)
    (21 = 22)
    (22 = 23)
    (24 = 43)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bf" and file2 = "21".
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 23)
    (22 = 21)
    (41 = 96)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bf" and file2 = "31".  
+recode hv205
    (11 = 15)
    (12 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bf" and file2 = "43".  
+recode hv205 
    (11 = 15)
    (21 = 23) 
    (22 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bj" and file2 = "31".  
+recode hv205 
    (21 = 22)
    (22 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bj" and file2 = "41".
+recode hv205 
    (11 = 15)
    (22 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bj" and file2 = "51".
+recode hv205 
    (15 = 14)
    (21 = 23)
    (22 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bo" and file2 = "31".  
+recode hv205 
    (11 = 15)
    (13 = 12)
    (21 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bo" and file2 = "3b".
+recode hv205 
    (11 = 15)
    (12 = 15)
    (13 = 15)
    (21 = 23)
    (22 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bo" and file2 = "41".
+recode hv205 
    (11 = 15)
    (21 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "br" and file2 = "21".
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 23)
    (41 = 96)
    (else=copy) 
    into ph_sani_type.

else if file1 = "br" and file2 = "31".
+recode hv205 
    (12 = 14)
    (13 = 14)
    (21 = 22)
    (22 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "bu" and file2 = "6a". 
+recode hv205 
    (23 = 22)
    (24 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "cd" and file2 = "51".
+recode hv205 
    (11 = 15)
    (21 = 23)
    (23 = 21)
    (else=copy)
    into ph_sani_type.

else if file1 = "cf" and file2 = "31".
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "cg" and file2 = "51".
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy)
     into ph_sani_type.

else if file1 = "cg" and file2 = "5a".
+recode hv205 
    (11 = 15)
    (22 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "ci" and file2 = "35".
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 23)
    (22 = 23)
    (23 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "ci" and file2 = "3a".
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy)
     into ph_sani_type.

else if file1 = "ci" and file2 = "51".  
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "cm" and file2 = "22".  
+recode hv205 
    (11 = 15)
    (21 = 42)
    (22 = 23)
    (32 = 31)
    (33 = 31)
    (41 = 96)
    (else=copy) 
    into ph_sani_type.

else if file1 = "cm" and file2 = "31".  
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "cm" and file2 = "44".  
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "co" and file2 = "22".  
+recode hv205 
    (11 = 15)
    (21 = 23)
    (41 = 96)
    (else=copy) 
    into ph_sani_type.

else if file1 = "co" and file2 = "31".  
+recode hv205 
    (12 = 13)
    (13 = 14)
    (21 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "co" and file2 = "41".  
+recode hv205 
	(12 = 13)
	(13 = 14)
	(21 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "co" and file2 = "53".  
+recode hv205 
    (13 = 14)
    (21 = 23)
    (22 = 31)
    (else=copy) 
    into ph_sani_type.

else if file1 = "co" and file2 = "61".  
+recode hv205 
    (13 = 14)
    (21 = 23)
    (22 = 31)
    (else=copy) 
    into ph_sani_type.

else if file1 = "co" and file2 = "72".  
+recode hv205 
    (13 = 14)
    (21 = 23)
    (22 = 31)
    (else=copy) 
    into ph_sani_type.

else if file1 = "dr" and file2 = "21".  
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 23)
    (22 = 23)
    (41 = 96)
    (else=copy)
     into ph_sani_type.

else if file1 = "dr" and file2 = "32".  
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 22)
    (22 = 23)
    (23 = 22)
    (24 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "dr" and file2 = "41".  
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy) 
    into ph_sani_type.

else if file1 = "dr" and file2 = "4b".  
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 22)
    (22 = 23)
    (23 = 22)
    (24 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "dr" and file2 = "52".  
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 22)
    (22 = 23)
    (23 = 22)
    (24 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "dr" and file2 = "5a".  
+recode hv205 
    (11 = 15)
    (12 = 15)
    (21 = 22)
    (22 = 23)
    (23 = 22)
    (24 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "eg" and file2 = "21". 
+recode hv205 
    (13 = 15)
    (14 = 15)
    (21 = 23)
    (22 = 23)
    (41 = 96)
    (else=copy) 
    into ph_sani_type.

else if file1 = "eg" and file2 = "33".  
+recode hv205 
    (12 = 15)
    (13 = 15)
    (21 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "eg" and file2 = "42".  
+recode hv205 
    (12 = 15)
    (13 = 15)
    (21 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "eg" and file2 = "4a".  
+recode hv205 
    (12 = 15)
    (13 = 15)
    (21 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "eg" and file2 = "51".  
+recode hv205 
    (12 = 15)
    (13 = 15) 
    (21 = 23) 
    (32 = 42)
    (else=copy) 
    into ph_sani_type.

else if file1 = "eg" and file2 = "5a".  
+recode hv205 
    (12 = 15)
    (13 = 15)
    (else=copy) 
    into ph_sani_type.

else if file1 = "eg" and file2 = "61".  
+recode hv205 
    (16 = 12)
    (17 = 11)
    (18 = 11)
    (else=copy) 
    into ph_sani_type.

else if file1 = "et" and file2 = "41".
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "et" and file2 = "51".
+recode hv205 
    (24 = 41) 
    (25 = 42) 
    (26 = 43) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ga" and file2 = "41".
+recode hv205 
    (22 = 23)
    (else=copy) 
    into ph_sani_type.

else if file1 = "gh" and file2 = "31".
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gh" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (23 = 42) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gh" and file2 = "4b".
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (32 = 42) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gn" and file2 = "41". 
+recode hv205
    (11 = 15) 
    (21 = 23) 
    (31 = 23) 
    (41 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gn" and file2 = "52".
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (23 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gu" and file2 = "34".
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gu" and file2 = "41".
+recode hv205 
    (12 = 11) 
    (13 = 12) 
    (21 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gu" and file2 = "71".
+recode hv205 
    (13 = 14) 
    (14 = 15) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "gy" and file2 = "51".
+recode hv205 
    (61 = 43) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "hn" and file2 = "52".
+recode hv205 
    (13 = 15) 
    (21 = 51) 
    (22 = 41) 
    (24 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "hn" and file2 = "62". 
+recode hv205 
    (13 = 15) 
    (21 = 51) 
    (22 = 41) 
    (24 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ht" and file2 = "31".
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 23) 
    (23 = 21) 
    (24 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ht" and file2 = "42". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ht" and file2 = "52".  
+recode hv205 
    (51 = 42) 
    (61 = 43) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ht" and file2 = "61".  
+recode hv205 
    (44 = 43) 
    (45 = 51) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ia" and file2 = "23". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (13 = 15) 
    (21 = 23) 
    (22 = 23) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ia" and file2 = "42".
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (13 = 15) 
    (21 = 23) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ia" and file2 = "52".
+recode hv205 
    (44 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ia" and file2 = "74".
+recode hv205 
    (44 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "id" and file2 = "42".
+recode hv205 
    (11 = 12) 
    (12 = 14) 
    (21 = 15) 
    (41 = 23) 
    (51 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "id" and file2 = "51".
+recode hv205 
    (11 = 12) 
    (12 = 14) 
    (13 = 15) 
    (21 = 23) 
    (32 = 31) 
    (33 = 31) 
    (34 = 31) 
    (35 = 31) 
    (36 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "id" and file2 = "63".
+recode hv205 
    (11 = 12) 
    (12 = 14) 
    (13 = 15) 
    (21 = 23) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "id" and file2 = "71". 
+recode hv205 
    (16 = 14) 
    (17 = 15) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "jo" and file2 = "31".  
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "jo" and file2 = "42". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "jo" and file2 = "51". 
+recode hv205 
    (12 = 13) 
    (13 = 14) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "jo" and file2 = "61". 
+recode hv205 
    (12 = 13) 
    (13 = 14) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ke" and file2 = "33". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ke" and file2 = "3a". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ke" and file2 = "42". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "kh" and file2 = "42". 
+recode hv205 
    (11 = 12) 
    (12 = 14) 
    (21 = 22) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "kk" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "kk" and file2 = "42". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "km" and file2 = "32". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ky" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ls" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ma" and file2 = "21". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ma" and file2 = "43". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (13 = 15) 
    (21 = 23) 
    (22 = 23) 
    (32 = 42) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mb" and file2 = "53". 
+recode hv205 
    (31 = 41) 
    (41 = 42) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "md" and file2 = "21". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (23 = 22) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "md" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "md" and file2 = "42". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "md" and file2 = "51". 
+recode hv205 
    (24 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "md" and file2 = "61". 
+recode hv205 
    (23 = 22) 
    (24 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "md" and file2 = "6a". 
+recode hv205 
    (23 = 22) 
    (24 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ml" and file2 = "32". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ml" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ml" and file2 = "53". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mw" and file2 = "22". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mw" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mw" and file2 = "4e". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mw" and file2 = "61". 
+recode hv205 
    (11 = 15) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mz" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mz" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 31) 
    (30 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "mz" and file2 = "62". 
+recode hv205 
    (16 = 15)
    (else=copy) 
    into ph_sani_type.

else if file1 = "mz" and file2 = "71". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "nc" and file2 = "31". 
+recode hv205 
    (15 = 14) 
    (21 = 23) 
    (22 = 21) 
    (24 = 43) 
    (30 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "nc" and file2 = "41". 
+recode hv205 
    (15 = 14) 
    (21 = 23) 
    (22 = 21) 
    (30 = 31) 
    (32 = 43) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ng" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (23 = 42) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ng" and file2 = "4b". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ni" and file2 = "22". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (13 = 15) 
    (21 = 23) 
    (22 = 21) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ni" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ni" and file2 = "51". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "nm" and file2 = "21". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (23 = 42) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "nm" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 22) 
    (21 = 23) 
    (22 = 21) 
    (23 = 42) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "np" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (31 = 42) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "np" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "21". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (23 = 22) 
    (24 = 22) 
    (25 = 23) 
    (26 = 23) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (13 = 15) 
    (14 = 15) 
    (21 = 23) 
    (22 = 23) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (13 = 15) 
    (14 = 15) 
    (21 = 23) 
    (22 = 23) 
    (30 = 31) 
    (41 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "51". 
+recode hv205 
    (11 = 31) 
    (12 = 15) 
    (22 = 12) 
    (24 = 31) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "5i". 
+recode hv205 
    (11 = 31) 
    (12 = 15) 
    (22 = 12) 
    (24 = 31) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "61". 
+recode hv205 
    (11 = 15)
    (12 = 15) 
    (22 = 12) 
    (24 = 31) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "6a". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (22 = 12) 
    (24 = 31) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pe" and file2 = "6i". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (22 = 12) 
    (24 = 31) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ph" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 23) 
    (24 = 43) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ph" and file2 = "3b". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 13) 
    (22 = 23) 
    (30 = 31) 
    (31 = 43) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ph" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 13) 
    (22 = 23) 
    (31 = 43) 
    (32 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ph" and file2 = "61". 
+recode hv205 
    (51 = 15) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ph" and file2 = "71". 
+recode hv205 
    (71 = 15) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pk" and file2 = "21". 
+recode hv205 
    (13 = 15) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "pk" and file2 = "52". 
+recode hv205 
    (13 = 14) 
    (14 = 15) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "rw" and file2 = "21". 
+recode hv205 
    (13 = 15) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "rw" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "rw" and file2 = "53". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "rw" and file2 = "5a". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sl" and file2 = "51". 
+recode hv205 
    (71 = 31)
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "21". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "32". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "4a". 
+recode hv205 
    (11 = 15) 
    (12 = 14) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "61". 
+recode hv205 
    (24 = 22) 
    (26 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "6d". 
+recode hv205 
    (24 = 22) 
    (26 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "6r". 
+recode hv205 
    (24 = 22) 
    (26 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "70". 
+recode hv205 
    (24 = 22) 
    (26 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "7h". 
+recode hv205 
    (24 = 22) 
    (26 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "7i". 
+recode hv205 
    (24 = 22) 
    (26 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sn" and file2 = "g0". 
+recode hv205 
    (24 = 22) 
    (26 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "sz" and file2 = "51". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "td" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "td" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "td" and file2 = "71". 
+recode hv205 
    (11 = 12) 
    (12 = 13) 
    (13 = 14) 
    (14 = 15) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tg" and file2 = "31". 
+recode hv205 
    (21 = 22) 
    (22 = 23) 
    (23 = 12) 
    (24 = 22) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tr" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 13) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tr" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 13) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tr" and file2 = "4a". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 13) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tr" and file2 = "51". 
+recode hv205 
    (11 = 11) 
    (21 = 21) 
    (22 = 22) 
    (31 = 31) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "21". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "3a". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "4a". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "4i". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "51". 
+recode hv205 
    (24 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "6a". 
+recode hv205 
    (24 = 22) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "7b". 
+recode hv205 
    (24 = 22) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "tz" and file2 = "7i". 
+recode hv205 
    (24 = 22) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ug" and file2 = "33". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ug" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ug" and file2 = "52". 
+recode hv205 
    (11 = 15) 
    (22 = 23) 
    (23 = 22) 
    (24 = 23) 
    (25 = 22) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ug" and file2 = "5a". 
+recode hv205 
    (11 = 15) 
    (22 = 23) 
    (23 = 22) 
    (24 = 23) 
    (25 = 22) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ug" and file2 = "61". 
+recode hv205 
    (11 = 15) 
    (22 = 23) 
    (23 = 22) 
    (24 = 23) 
    (25 = 22) 
    (44 = 51) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ug" and file2 = "72". 
+recode hv205 
    (24 = 22) 
    (25 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "uz" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "vn" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "vn" and file2 = "41". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "vn" and file2 = "52". 
+recode hv205 
    (11 = 15) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ye" and file2 = "21". 
+recode hv205 
    (13 = 11) 
    (14 = 15) 
    (24 = 14) 
    (25 = 23) 
    (26 = 15) 
    (31 = 42) 
    (32 = 31) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "ye" and file2 = "61". 
+recode hv205 
    (24 = 23) 
    (25 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "za" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 42) 
    (22 = 23) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "za" and file2 = "71". 
+recode hv205 
    (23 = 21)
    (44 = 51)
    (else=copy) 
    into ph_sani_type.

else if file1 = "zm" and file2 = "21". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (41 = 96) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "zm" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "zm" and file2 = "42". 
+recode hv205 
    (11 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "zw" and file2 = "31". 
+recode hv205 
    (11 = 15) 
    (12 = 15) 
    (21 = 23) 
    (22 = 21) 
    (else=copy) 
    into ph_sani_type.

else if file1 = "zw" and file2 = "42". 
+recode hv205 
    (11 = 15)
    (21 = 23)
    (22 = 21)
    (else=copy)
    into ph_sani_type.

else if file1 = "zw" and file2 = "52". 
+recode hv205 
    (91 = 41)
    (92 = 42)
    (else=copy) 
    into ph_sani_type.

else.
*for all other countries.
+compute ph_sani_type = hv205.

end if.

*crosstabs ph_sani_type by hv205.

********************************************************************************

*label type of sanitation.

variable labels ph_sani_type "Type of sanitation".
value labels ph_sani_type			
        11	 "flush - to piped sewer system"
        12	 "flush - to septic tank"		
        13	 "flush - to pit latrine"		
        14	 "flush - to somewhere else"	
        15	 "flush - don't know where/unspecified"			
        21	 "pit latrine - ventilated improved pit (vip)"	
        22	 "pit latrine - with slab"		
        23	 "pit latrine - without slab / open pit"	
        31	 "no facility/bush/field/river/sea/lake"	
        41	 "composting ph_sani_type"			
        42	 "bucket ph_sani_type"				
        43	 "hanging ph_sani_type/latrine"		
        51	 "other improved"				
        96	 "other"					
.
	
*create improved sanitation indicator.
recode ph_sani_type (11 thru 13,15, 21, 22, 41, 51 = 1)(14, 23, 42, 43, 96 = 2) (31 = 3) (99=sysmis) into ph_sani_improve.
variable labels ph_sani_improve "Improved sanitation".
value labels ph_sani_improve
 1 "improved sanitation"
 2 "unimproved sanitation"
 3 "open defecation"
.

* shared ph_sani_type is not improved. Note: this is used in the old definition and no longer required. 
* if hv225=1 ph_sani_typeimprove = 2. 

* create basic or limited sanitation services indicator.
compute ph_sani_basic = $sysmis.
if ph_sani_improve=1 & hv225=0 ph_sani_basic = 1.
if ph_sani_improve=1 & hv225<>0 ph_sani_basic = 2.
if ph_sani_improve=2 ph_sani_basic = 3.
if ph_sani_improve=3 ph_sani_basic = 4.
variable labels ph_sani_basic "Basic or limited sanitation".
value labels ph_sani_basic	
    1 "basic sanitation"	
    2 "limited sanitation"
    3 "unimproved sanitation"
    4 "open defecation".

*create sanitation facility location indicator (this variable may sometimes be country specific - e.g. sh109a in some Ghana survyes).
compute ph_sani_location = hv238a.
apply dictionary from *
 /source variables = hv238a
 /target variables = ph_sani_location
.

variable labels ph_sani_location "Location of sanitation facility".
