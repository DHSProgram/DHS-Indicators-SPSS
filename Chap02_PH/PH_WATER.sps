* Encoding: UTF-8.
*********************************************************************
Program: 			PH_WATER.do
Purpose: 			creates variable for binary improved water source according to JSTOR standard 
Data inputs: 	                  hr and pr
Data outputs:		none
Author of do file:	04/08/2018	Courtney Allen translated to SPSS by Ivana Bjelic
Date last modified: 08/26/2020	Ivana Bjelic 
Note:			These indicators can also be computed using the HR or PR file
			If you want to produce estimates for households, use the HR file
			If you want to produce estimates for the de jure population, 
			use the PR file and select for dejure household memebers using
			hv102=1. Please see the Guide to DHS Statistics.  
*****************************************************************************************************.

*
This do file can be run on any loop of countries indicating the dataset name 
with variable called filename. Code should be same for pr or hr files.

*
VARIABLES CREATED
	ph_wtr_trt_boil	"Treated water by boiling before drinking"
	ph_wtr_trt_chlor	"Treated water by adding bleach or chlorine before drinking"
	ph_wtr_trt_cloth	"Treated water by straining t" and file2 = "ough cloth before drinking"
	ph_wtr_trt_filt	"Treated water by ceramic, sand, or other filter before drinking"
	ph_wtr_trt_solar	"Treated water by solar disinfection before drinking"
	ph_wtr_trt_stand	"Treated water by letting stand and settle before drinking"
	ph_wtr_trt_other	"Treated water by other means before drinking"
	ph_wtr_trt_none	"Did not treat water before drinking"
	ph_wtr_trt_appr	"Appropriately treated water before drinking"
	ph_wtr_source 	"Source of drinking water"
	ph_wtr_improve 	"Improved drinking water" 
	ph_wtr_time		"Round trip time to obtain drinking water"
	ph_wtr_basic	"Basic water service"
	ph_wtr_avail		"Availability of water among those using piped water or water from tube well or borehole"

*
NOTE: 
STANDARD CATEGORIES FOR WATER SOURCE BY IMPROVED/UNIMPROVED
		0-unimproved 
			30	 well - protection unspecified	
			32	 unprotected well
			40	 spring - protection unspecified
			42	 unprotected spring
			43	 surface water (river/dam/lake/pond/stream/canal/irrigation channel)
			96	 other	
		1-improved
			11	 piped into dwelling
			12	 piped to yard/plot
			13	 public tap/standpipe
			14	 piped to neighbor
			15	 piped outside of yard/lot
			21	 tube well or borehole
			31	 protected well
			41	 protected spring
			51	 rainwater
			61	 tanker truck	
			62	 cart with small tank	
			65	 purchased water	
			71	 bottled water
			72	 purified water, filtration plant
			73	 satchet water

	
*------------------------------------------------------------------------------.
*create water treatment indicators.

*treated water by boiling.
compute ph_wtr_trt_boil = hv237a.
if hv237a>=8 ph_wtr_trt_boil = 0.
variable labels ph_wtr_trt_boil "Treated water by boiling before drinking".
value labels ph_wtr_trt_boil 0"No" 1"Yes".

*treated water by adding bleach or chlorine.
compute ph_wtr_trt_chlor = hv237b.
if hv237b>=8 ph_wtr_trt_chlor = 0.
variable labels ph_wtr_trt_chlor "Treated water by adding bleach or chlorine before drinking".
value labels ph_wtr_trt_chlor 0"No" 1"Yes".

*treated water by straining t" and file2 = "ough cloth.
compute ph_wtr_trt_cloth = hv237c.
if hv237c>=8 ph_wtr_trt_cloth = 0.
variable labels ph_wtr_trt_cloth "Treated water by straining through cloth before drinking".
value labels ph_wtr_trt_cloth 0"No" 1"Yes".

*treated water by ceramic, sand, or other filter.
compute ph_wtr_trt_filt = hv237d.
if hv237d>=8 ph_wtr_trt_filt = 0.
variable labels ph_wtr_trt_filt "Treated water by ceramic, sand, or other filter before drinking".
value labels ph_wtr_trt_filt 0"No" 1"Yes".

*treated water by solar disinfection.
compute ph_wtr_trt_solar = hv237e.
if hv237e>=8 ph_wtr_trt_solar = 0.
variable labels ph_wtr_trt_solar "Treated water by solar disinfection".
value labels ph_wtr_trt_solar 0"No" 1"Yes".

*treated water by letting stand and settle.
compute ph_wtr_trt_stand = hv237f.
if hv237f>=8 ph_wtr_trt_stand = 0.
variable labels ph_wtr_trt_stand "Treated water by letting stand and settle before drinking".
value labels ph_wtr_trt_stand 0"No" 1"Yes".

*treated water by other means.
compute ph_wtr_trt_other = 0.
if hv237g=1 or hv237h=1 or hv237j=1 or hv237k=1 or hv237x=1 ph_wtr_trt_other = 1.
variable labels ph_wtr_trt_other "Treated water by other means before drinking".
value labels ph_wtr_trt_other 0"No" 1"Yes".

*any treatment or none.
compute ph_wtr_trt_none = 0.
if hv237<>0 ph_wtr_trt_none = 1.
variable labels ph_wtr_trt_none "Did not treat water before drinking".
value labels ph_wtr_trt_none 0 "No treatment" 1 "Some treatment".
	
*using appropriate treatment
*--------------------------------------------------------------------------
NOTE: Appropriate water treatment includes: boil, add bleach or chlorine, 
ceramic, sand or other filter, and solar disinfection
--------------------------------------------------------------------------.

compute ph_wtr_trt_appr = hv237a.
if hv237b=1 or hv237d=1 or hv237e=1  ph_wtr_trt_appr = 1.
variable labels ph_wtr_trt_appr "Appropriately treated water before drinking".
value labels ph_wtr_trt_appr 0"No" 1"Yes".
	
*generate water source indicator.
*--------------------------------------------------------------------------
NOTE: this cycles t" and file2 = "ough ALL country specific coding and ends around line 2208
--------------------------------------------------------------------------.

do if file1 = "af" and file2 = "70".
+recode hv201
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "al" and file2 = "71".
+recode hv201
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "am" and file2 = "42".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "am" and file2 = "54".
+recode hv201
    (21 = 32)
    (32 = 41)
    (41 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "am" and file2 = "61".
+recode hv201
    (14 = 11)
    (else = copy) into ph_wtr_source.

else if file1 = "am" and file2 = "72".
+recode hv201
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "ao" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (33 = 21)
    (63 = 62)
    (else = copy) into ph_wtr_source.

else if file1 = "bd" and file2 = "31".
+recode hv201
    (22 = 32)
    (31 = 43)
    (32 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "bd" and file2 = "3a".
+recode hv201
    (22 = 32)
    (31 = 43)
    (32 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "bd" and file2 = "41".
+recode hv201
    (22 = 32)
    (31 = 43)
    (32 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "bd" and file2 = "4j".
+recode hv201
    (22 = 32)
    (23 = 31)
    (24 = 32)
    (41 = 43)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "bf" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "bf" and file2 = "31".
+recode hv201
    (12 = 11)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (51 = 71)
    (61 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "bf" and file2 = "43".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "bf" and file2 = "7a".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "bj" and file2 = "31".
+recode hv201
    (22 = 31)
    (23 = 32)
    (31 = 41)
    (32 = 43)
    (41 = 51)
    (42 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "bj" and file2 = "41".
+recode hv201
    (22 = 31)
    (23 = 32)
    (41 = 40)
    (42 = 43)
    (52 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "bj" and file2 = "51".
+recode hv201
    (52 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "bj" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "bo" and file2 = "31".
+recode hv201
    (12 = 13)
    (13 = 14)
    (21 = 30)
    (32 = 43)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "bo" and file2 = "3b".
+recode hv201
    (13 = 15)
    (21 = 30)
    (31 = 43)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "bo" and file2 = "41".
+recode hv201
    (13 = 15)
    (22 = 32)
    (42 = 43)
    (45 = 14)
    (else = copy) into ph_wtr_source.

else if file1 = "bo" and file2 = "51".
+recode hv201
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "br" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "br" and file2 = "31".
+recode hv201
    (21 = 30)
    (22 = 30)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "bu" and file2 = "70".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "cd" and file2 = "51".
+recode hv201
    (32 = 31)
    (33 = 31)
    (34 = 32)
    (35 = 32)
    (36 = 32)
    (44 = 43)
    (45 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "cf" and file2 = "31".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "cg" and file2 = "51".
+recode hv201
    (13 = 14)
    (21 = 32)
    (22 = 32)
    (32 = 31)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ci" and file2 = "35".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "ci" and file2 = "3a".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "ci" and file2 = "51".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (42 = 40)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "cm" and file2 = "22".
+recode hv201
    (13 = 14)
    (14 = 13)
    (22 = 32)
    (31 = 43)
    (41 = 51)
    (51 = 96)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "cm" and file2 = "31".
+recode hv201
    (13 = 14)
    (14 = 13)
    (22 = 32)
    (31 = 43)
    (41 = 51)
    (51 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "cm" and file2 = "44".
+recode hv201
    (13 = 14)
    (14 = 15)
    (22 = 32)
    (31 = 32)
    (41 = 43)
    (42 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "co" and file2 = "22".
+recode hv201
    (12 = 11)
    (13 = 15)
    (14 = 13)
    (21 = 30)
    (31 = 43)
    (41 = 51)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "co" and file2 = "31".
+recode hv201
    (12 = 11)
    (13 = 15)
    (14 = 13)
    (21 = 30)
    (31 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "co" and file2 = "41".
+recode hv201
    (12 = 11)
    (21 = 30)
    (41 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "co" and file2 = "53".
+recode hv201
    (12 = 11)
    (22 = 32)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "co" and file2 = "61".
+recode hv201
    (12 = 11)
    (22 = 32)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "co" and file2 = "72".
+recode hv201
    (12 = 11)
    (22 = 32)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "dr" and file2 = "21".
+recode hv201
    (21 = 30)
    (31 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "dr" and file2 = "32".
+recode hv201
    (21 = 30)
    (31 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "dr" and file2 = "41".
+recode hv201
    (22 = 32)
    (23 = 32)
    (25 = 31)
    (26 = 31)
    (31 = 40)
    (32 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "dr" and file2 = "4b".
+recode hv201
    (21 = 30)
    (41 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "eg" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 43)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "eg" and file2 = "33".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "eg" and file2 = "42".
+recode hv201
    (21 = 30)
    (22 = 30)
    (23 = 30)
    (31 = 30)
    (32 = 30)
    (33 = 30)
    (41 = 43)
    (72 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "eg" and file2 = "4a".
+recode hv201
    (21 = 30)
    (22 = 30)
    (23 = 30)
    (31 = 30)
    (32 = 30)
    (33 = 30)
    (41 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "eg" and file2 = "51".
+recode hv201
    (21 = 32)
    (22 = 42)
    (31 = 21)
    (32 = 31)
    (33 = 41)
    (41 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "et" and file2 = "41".
+recode hv201
    (13 = 15)
    (21 = 32)
    (22 = 42)
    (23 = 31)
    (24 = 41)
    (31 = 43)
    (32 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "et" and file2 = "51".
+recode hv201
    (13 = 15)
    (21 = 32)
    (22 = 42)
    (31 = 21)
    (32 = 31)
    (33 = 41)
    (41 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "et" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "ga" and file2 = "41".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 31)
    (22 = 31)
    (23 = 32)
    (24 = 32)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (41 = 51)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "ga" and file2 = "61".
+recode hv201
    (32 = 31)
    (33 = 32)
    (34 = 32)
    (else = copy) into ph_wtr_source.

else if file1 = "gh" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (35 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "gh" and file2 = "41".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (35 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "gh" and file2 = "4b".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (81 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "gh" and file2 = "5a".
+recode hv201
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "gh" and file2 = "72".
+recode hv201
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "gh" and file2 = "7b".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "gn" and file2 = "41".
+recode hv201
    (21 = 30)
    (22 = 30)
    (31 = 41)
    (32 = 42)
    (33 = 43)
    (34 = 43)
    (35 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "gn" and file2 = "52".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (34 = 21)
    (44 = 43)
    (45 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "gn" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "gu" and file2 = "34".
+recode hv201
    (11 = 13)
    (12 = 13)
    (13 = 15)
    (22 = 30)
    (32 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "gu" and file2 = "41".
+recode hv201
    (11 = 13)
    (12 = 13)
    (13 = 15)
    (14 = 13)
    (21 = 30)
    (31 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "gu" and file2 = "71".
+recode hv201
    (14 = 15)
    (31 = 13)
    (32 = 30)
    (41 = 43)
    (42 = 43)
    (43 = 41)
    (44 = 42)
    (else = copy) into ph_wtr_source.

else if file1 = "gy" and file2 = "51".
+recode hv201
    (22 = 32)
    (81 = 43)
    (91 = 62)
    (92 = 72)
    (else = copy) into ph_wtr_source.

else if file1 = "hn" and file2 = "52".
+recode hv201
    (13 = 11)
    (14 = 11)
    (21 = 32)
    (31 = 30)
    (32 = 21)
    (41 = 43)
    (62 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "hn" and file2 = "62".
+recode hv201
    (13 = 11)
    (14 = 11)
    (31 = 30)
    (44 = 13)
    (45 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ht" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (35 = 43)
    (41 = 51)
    (51 = 61)
    (52 = 65)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "ht" and file2 = "42".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 30)
    (32 = 30)
    (44 = 43)
    (45 = 43)
    (81 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "ht" and file2 = "52".
+recode hv201
    (63 = 43)
    (64 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "ht" and file2 = "61".
+recode hv201
    (13 = 14)
    (14 = 13)
    (32 = 31)
    (33 = 32)
    (34 = 32)
    (72 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "ht" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "ia" and file2 = "23".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (24 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "ia" and file2 = "42".
+recode hv201
    (11 = 12)
    (12 = 13)
    (22 = 21)
    (23 = 30)
    (24 = 32)
    (25 = 31)
    (26 = 32)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "id" and file2 = "21".
+recode hv201
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (41 = 51)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "id" and file2 = "31".
+recode hv201
    (22 = 31)
    (23 = 32)
    (31 = 41)
    (32 = 42)
    (33 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "id" and file2 = "3a".
+recode hv201
    (22 = 31)
    (23 = 32)
    (31 = 41)
    (32 = 42)
    (33 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "id" and file2 = "42".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "id" and file2 = "51".
+recode hv201
    (33 = 32)
    (34 = 32)
    (35 = 32)
    (36 = 31)
    (37 = 31)
    (38 = 31)
    (44 = 40)
    (45 = 43)
    (46 = 43)
    (47 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "id" and file2 = "63".
+recode hv201
    (33 = 32)
    (34 = 32)
    (35 = 32)
    (36 = 31)
    (37 = 31)
    (38 = 31)
    (44 = 40)
    (45 = 43)
    (46 = 43)
    (47 = 43)
    (81 = 72)
    (else = copy) into ph_wtr_source.

else if file1 = "id" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "jo" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "jo" and file2 = "42".
+recode hv201
    (41 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "ke" and file2 = "33".
+recode hv201
    (12 = 13)
    (22 = 32)
    (31 = 43)
    (32 = 43)
    (41 = 51)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "ke" and file2 = "3a".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 43)
    (32 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "ke" and file2 = "42".
+recode hv201
    (21 = 32)
    (22 = 32)
    (32 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ke" and file2 = "7a".
+recode hv201
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "kh" and file2 = "42".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 32)
    (22 = 32)
    (32 = 31)
    (33 = 21)
    (34 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "kk" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "kk" and file2 = "42".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (24 = 43)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "km" and file2 = "32".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (41 = 51)
    (42 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "ky" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "lb" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "ls" and file2 = "41".
+recode hv201
    (13 = 14)
    (14 = 13)
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (34 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ls" and file2 = "61".
+recode hv201
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ma" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "ma" and file2 = "43".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "mb" and file2 = "53".
+recode hv201
    (63 = 62)
    (81 = 41)
    (82 = 42)
    (else = copy) into ph_wtr_source.

else if file1 = "md" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "md" and file2 = "31".
+recode hv201
    (22 = 30)
    (23 = 32)
    (24 = 21)
    (25 = 30)
    (26 = 32)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "md" and file2 = "42".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "md" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "ml" and file2 = "32".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "ml" and file2 = "41".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ml" and file2 = "7h".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "mm" and file2 = "71".
+recode hv201
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "mv" and file2 = "52".
+recode hv201
    (52 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "mv" and file2 = "71".
+recode hv201
    (14 = 13)
    (52 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "mw" and file2 = "22".
+recode hv201
    (12 = 13)
    (13 = 12)
    (22 = 30)
    (23 = 31)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "mw" and file2 = "41".
+recode hv201
    (21 = 32)
    (32 = 21)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "mw" and file2 = "4e".
+recode hv201
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "mw" and file2 = "7a".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "mw" and file2 = "7i".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "mz" and file2 = "31".
+recode hv201
    (12 = 14)
    (21 = 30)
    (22 = 30)
    (23 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "mz" and file2 = "41".
+recode hv201
    (11 = 12)
    (12 = 14)
    (21 = 12)
    (22 = 14)
    (23 = 32)
    (41 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "mz" and file2 = "62".
+recode hv201
    (33 = 21)
    (else = copy) into ph_wtr_source.

else if file1 = "mz" and file2 = "71".
+recode hv201
    (33 = 21)
    (else = copy) into ph_wtr_source.

else if file1 = "mz" and file2 = "7a".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "nc" and file2 = "31".
+recode hv201
    (21 = 30)
    (22 = 30)
    (31 = 43)
    (32 = 40)
    (41 = 51)
    (61 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "nc" and file2 = "41".
+recode hv201
    (31 = 30)
    (32 = 30)
    (41 = 43)
    (42 = 40)
    (61 = 72)
    (else = copy) into ph_wtr_source.

else if file1 = "ng" and file2 = "41".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (52 = 61)
    (61 = 71)
    (71 = 21)
    (else = copy) into ph_wtr_source.

else if file1 = "ng" and file2 = "4b".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (62 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "ng" and file2 = "61".
+recode hv201
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "ng" and file2 = "6a".
+recode hv201
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "ng" and file2 = "71".
+recode hv201
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "ng" and file2 = "7a".
+recode hv201
    (13 = 14)
    (14 = 13)
    (92 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "ni" and file2 = "22".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "ni" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 31)
    (23 = 32)
    (24 = 32)
    (25 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (41 = 51)
    (51 = 62)
    (else = copy) into ph_wtr_source.

else if file1 = "ni" and file2 = "51".
+recode hv201
    (41 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "ni" and file2 = "61".
+recode hv201
    (63 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "nm" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (35 = 21)
    (41 = 51)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "nm" and file2 = "41".
+recode hv201
    (21 = 32)
    (22 = 42)
    (31 = 21)
    (32 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "np" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (24 = 21)
    (31 = 40)
    (32 = 43)
    (34 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "np" and file2 = "41".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 21)
    (32 = 21)
    (41 = 40)
    (42 = 43)
    (43 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "np" and file2 = "51".
+recode hv201
    (44 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "np" and file2 = "61".
+recode hv201
    (44 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "np" and file2 = "7h".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "21".
+recode hv201
    (12 = 13)
    (13 = 12)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (41 = 51)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "31".
+recode hv201
    (12 = 11)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "41".
+recode hv201
    (21 = 30)
    (22 = 30)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "51".
+recode hv201
    (21 = 30)
    (22 = 30)
    (41 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "5i".
+recode hv201
    (21 = 30)
    (22 = 30)
    (41 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "61".
+recode hv201
    (21 = 30)
    (22 = 30)
    (41 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "6a".
+recode hv201
    (21 = 30)
    (22 = 30)
    (41 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "pe" and file2 = "6i".
+recode hv201
    (21 = 30)
    (22 = 30)
    (41 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "pg" and file2 = "70".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "ph" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 11)
    (22 = 12)
    (23 = 30)
    (24 = 30)
    (31 = 32)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "ph" and file2 = "3b".
+recode hv201
    (21 = 31)
    (22 = 32)
    (31 = 41)
    (32 = 42)
    (33 = 43)
    (34 = 43)
    (35 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "ph" and file2 = "41".
+recode hv201
    (21 = 32)
    (else = copy) into ph_wtr_source.

else if file1 = "ph" and file2 = "52".
+recode hv201
    (33 = 32)
    (72 = 14)
    (73 = 14)
    (else = copy) into ph_wtr_source.

else if file1 = "ph" and file2 = "61".
+recode hv201
    (33 = 32)
    (else = copy) into ph_wtr_source.

else if file1 = "ph" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "pk" and file2 = "21".
+recode hv201
    (12 = 13)
    (13 = 12)
    (23 = 21)
    (24 = 32)
    (32 = 43)
    (41 = 51)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "pk" and file2 = "52".
+recode hv201
    (22 = 21)
    (else = copy) into ph_wtr_source.

else if file1 = "pk" and file2 = "61".
+recode hv201
    (22 = 21)
    (63 = 72)
    (else = copy) into ph_wtr_source.

else if file1 = "pk" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (63 = 72)
    (else = copy) into ph_wtr_source.

else if file1 = "rw" and file2 = "21".
+recode hv201
    (12 = 13)
    (13 = 12)
    (23 = 21)
    (24 = 21)
    (31 = 40)
    (32 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "rw" and file2 = "41".
+recode hv201
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "rw" and file2 = "53".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "rw" and file2 = "5a".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "rw" and file2 = "7a".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "sl" and file2 = "72".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "sn" and file2 = "21".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "sn" and file2 = "32".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "sn" and file2 = "4a".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "sn" and file2 = "51".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "sn" and file2 = "7z".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "td" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 32)
    (22 = 31)
    (23 = 32)
    (24 = 31)
    (31 = 43)
    (32 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "td" and file2 = "41".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 32)
    (22 = 32)
    (32 = 31)
    (44 = 43)
    (52 = 65)
    (53 = 65)
    (54 = 65)
    (55 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "tg" and file2 = "31".
+recode hv201
    (12 = 14)
    (22 = 31)
    (23 = 32)
    (31 = 41)
    (32 = 43)
    (41 = 51)
    (42 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "tg" and file2 = "61".
+recode hv201
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "tg" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "tj" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "tl" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "tr" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (42 = 43)
    (51 = 61)
    (61 = 71)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "tr" and file2 = "41".
+recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 41)
    (32 = 40)
    (33 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (71 = 72)
    (else = copy) into ph_wtr_source.

else if file1 = "tr" and file2 = "4a".
+recode hv201
    (11 = 12)
    (21 = 30)
    (31 = 30)
    (42 = 40)
    (81 = 72)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (35 = 43)
    (41 = 51)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "3a".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "41".
+recode hv201
    (21 = 32)
    (22 = 31)
    (23 = 21)
    (31 = 41)
    (32 = 42)
    (33 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "4a".
+recode hv201
    (21 = 32)
    (32 = 21)
    (44 = 43)
    (45 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "4i".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (24 = 32)
    (32 = 31)
    (33 = 31)
    (34 = 21)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (62 = 65)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "51".
+recode hv201
    (21 = 32)
    (22 = 32)
    (23 = 32)
    (24 = 32)
    (32 = 31)
    (33 = 31)
    (34 = 21)
    (42 = 43)
    (44 = 43)
    (62 = 65)
    (91 = 62)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "63".
+recode hv201
    (22 = 32)
    (23 = 32)
    (24 = 32)
    (25 = 32)
    (33 = 31)
    (34 = 31)
    (35 = 31)
    (36 = 21)
    (45 = 40)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "7b".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "tz" and file2 = "7i".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "33".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 41)
    (41 = 51)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "41".
+recode hv201
    (21 = 32)
    (22 = 32)
    (32 = 31)
    (33 = 21)
    (34 = 21)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (81 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "52".
+recode hv201
    (22 = 21)
    (23 = 21)
    (33 = 31)
    (34 = 31)
    (35 = 32)
    (36 = 32)
    (44 = 43)
    (45 = 43)
    (46 = 43)
    (91 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "5a".
+recode hv201
    (22 = 32)
    (23 = 32)
    (33 = 31)
    (34 = 31)
    (35 = 21)
    (44 = 43)
    (45 = 43)
    (46 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "61".
+recode hv201
    (22 = 21)
    (23 = 21)
    (33 = 31)
    (34 = 31)
    (35 = 32)
    (36 = 32)
    (44 = 43)
    (45 = 43)
    (46 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "6a".
+recode hv201
    (81 = 41)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "72".
+recode hv201
    (22 = 21)
    (44 = 41)
    (63 = 62)
    (else = copy) into ph_wtr_source.

else if file1 = "ug" and file2 = "7b".
+recode hv201
    (13 = 14)
    (14 = 13)
    (63 = 62)
    (72 = 73)
    (else = copy) into ph_wtr_source.

else if file1 = "uz" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "vn" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "vn" and file2 = "41".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (34 = 43)
    (41 = 51)
    (51 = 61)
    (else = copy) into ph_wtr_source.

else if file1 = "vn" and file2 = "52".
+recode hv201
    (11 = 12)
    (12 = 13)
    (31 = 30)
    (32 = 30)
    (41 = 40)
    (42 = 43)
    (44 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "ye" and file2 = "21".
+recode hv201
    (13 = 11)
    (14 = 12)
    (23 = 21)
    (24 = 32)
    (32 = 43)
    (35 = 51)
    (36 = 43)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "ye" and file2 = "61".
+recode hv201
    (14 = 72)
    (15 = 72)
    (32 = 30)
    (43 = 40)
    (44 = 41)
    (45 = 43)
    (72 = 62)
    (else = copy) into ph_wtr_source.

else if file1 = "za" and file2 = "31".
+recode hv201
    (31 = 43)
    (41 = 51)
    (51 = 61)
    (61 = 71)
    (else = copy) into ph_wtr_source.

else if file1 = "za" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "zm" and file2 = "21".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 30)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (51 = 61)
    (71 = 96)
    (else = copy) into ph_wtr_source.

else if file1 = "zm" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 30)
    (22 = 32)
    (23 = 32)
    (24 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "zm" and file2 = "42".
+recode hv201
    (22 = 32)
    (23 = 32)
    (24 = 32)
    (32 = 31)
    (33 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "zm" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "zw" and file2 = "31".
+recode hv201
    (12 = 13)
    (21 = 31)
    (22 = 32)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "zw" and file2 = "42".
+recode hv201
    (21 = 31)
    (22 = 32)
    (23 = 21)
    (31 = 40)
    (32 = 43)
    (33 = 43)
    (41 = 51)
    (else = copy) into ph_wtr_source.

else if file1 = "zw" and file2 = "52".
+recode hv201
    (71 = 62)
    (81 = 43)
    (else = copy) into ph_wtr_source.

else if file1 = "zw" and file2 = "71".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else if file1 = "zw" and file2 = "72".
+recode hv201
    (13 = 14)
    (14 = 13)
    (else = copy) into ph_wtr_source.

else.
*for all other countries.
compute ph_wtr_source = hv201.

end if.

********************************************************************************
special code for Cambodia 
********************************************************************************
Cambodia collects data on water source for both the wet season and dry season.
*	
Below, an indicator is created for the dry season and water source and a wet
season water source. For all following indicators that use water source, only
the water source that corresponds to the season of interview (hv006 = month 
of interview) is used.
*	
e.g. If the interview took place during the dry season, then the dry season 
water source is used for standard indicators in this code.
*
Un-comment lines 2230 -  2283 to activate code for Cambodia specific section
--------------------------------------------------------------------------.

 * do if file1 = "kh" and file2 = "42".
 * +recode sh22b
    (11 = 12)
    (12 = 13)
    (21 = 32)
    (22 = 32)
    (32 = 31)
    (33 = 21)
    (34 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source_wet.
 * +recode hv201
    (11 = 12)
    (12 = 13)
    (21 = 32)
    (22 = 32)
    (32 = 31)
    (33 = 21)
    (34 = 31)
    (41 = 40)
    (42 = 43)
    (else = copy) into ph_wtr_source_dry.

 * else if file1 = "kh" and file2 = "51".
 * +compute ph_wtr_source_wet = hv201w.

 * else if file1 = "kh" and file2 = "51".
 * +compute ph_wtr_source_dry = hv201d.

 * else if file1 = "kh" and file2 = "61".
 * +compute ph_wtr_source_wet = sh104b.

 * else if file1 = "kh" and file2 = "61".
 * +compute ph_wtr_source_dry = sh102.

 * else if file1 = "kh" and file2 = "73".
 * +compute ph_wtr_source_wet = sh104b.

 * else if file1 = "kh" and file2 = "73".
 * +compute ph_wtr_source_dry = sh102.

 * end if.
*
* check if interview took place in dry season or wet season.
 * do if (file1 = "kh" and file2 = "42") or (file1 = "kh" and file2 = "51") or (file1 = "kh" and file2 = "61") or (file1 = "kh" and file2 = "73").
 * +recode hv006 (11 thru 12, 2 thru 4=1) (5 thru 10 = 2) into interview_season.
*dry season interviews.
 * +if interview_season=1  ph_wtr_source = ph_wtr_source_dry.
*rainy season interviews.
 * +if interview_season=2  ph_wtr_source = ph_wtr_source_wet.
 * end if.

 * value labels interview_season 1 "dry season" 2 "rainy season".

*create water source labels.

recode ph_wtr_source (sysmis = 99)(else = copy).

value labels ph_wtr_source 	11               "piped into dwelling"				
			12	 "piped to yard/plot" 			
			13	 "public tap/standpipe" 			
			14	 "piped to neighbor"				
			15	 "piped outside of yard/lot" 		
			21	 "tube well or borehole" 			
			30	 "well - protection unspecified" 	
			31	 "protected well" 					
			32	 "unprotected well"				
			40	 "spring - protection unspecified" 	
			41	 "protected spring" 				
			42	 "unprotected spring"				
			43	 "surface water (river/dam/lake/pond/stream/canal/irrigation channel)"
			51	 "rainwater"						
			61	 "tanker truck"						
			62	 "cart with small tank, cistern, drums/cans"
			65	 "purchased water"					
			71	 "bottled water"					
			72	 "purified water, filtration plant"
			73	 "satchet water"					
			96	 "other".	


recode ph_wtr_source (11 thru 15, 21, 31, 41, 51, 61 thru 73 = 1) (30, 32, 40, 42, 43, 96 = 0) (99=99) into ph_wtr_improve.
variable labels ph_wtr_improve "Improved Water Source".
value labels ph_wtr_improve
    0 "unimproved/surface water"
    1  "improved water"
    99  "missing".

* time to obtain drinking water (round trip).
recode hv204 (0, 996 = 0) ( 1 thru 30 = 1) (31 thru 900 = 2) (998 thru hi = 3) into ph_wtr_time.
variable labels ph_wtr_time "Round trip time to obtain water".
value lables ph_wtr_time 0 "water on premises" 1 "30 minutes or less" 2 "More than 30 minutes" 3 "don't know".
	
* basic or limited water source.
compute ph_wtr_basic = $sysmis.
if ph_wtr_improve=1 & ph_wtr_time<=1 ph_wtr_basic = 1.
if ph_wtr_improve=1 & ph_wtr_time>1 ph_wtr_basic = 2.
if ph_wtr_improve=0 ph_wtr_basic = 3.
variable labels ph_wtr_basic "Basic or limited water services".
value labels ph_wtr_basic 1 "basic water services" 2 "limited water services" 3 "unimproved water source".

*availability of piped water or water from tubewell.
compute ph_wtr_avail = hv201a.
apply dictionary from *
 /source variables = hv201a
 /target variables = ph_wtr_avail
.
variable labels ph_wtr_avail "Availability of water among those using piped water or water from tube well or borehole".




