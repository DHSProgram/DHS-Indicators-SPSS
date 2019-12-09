* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_STI_IR.sps
Purpose: 			Code for STI indicators
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Nov 28, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. 
*					For women the indicators are computed for age 15-49 in line 30. 
*					This can be commented out if the indicators are required for all women.
			
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
hk_sti			"Had an STI in the past 12 months"
hk_computet_disch		"Had an abnormal (or bad-smelling) computeital discharge in the past 12 months"
hk_computet_sore		"Had a computeital sore or ulcer in the past 12 months"
hk_sti_symp		"Had an STI or STI symptoms in the past 12 months"
hk_sti_trt_doc		"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor"
hk_sti_trt_pharm	                  "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy"
hk_sti_trt_other	                  "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source"
hk_sti_notrt		                  "Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"
----------------------------------------------------------------------------.

* indicators from IR file.

* limiting to women age 15-49.
select if v012<=49.

**************************

*STI in the past 12 months.
do if v525<>0 and v525<>99 and not sysmis(v525). 
+compute hk_sti=0.
+if v763a=1 hk_sti=1.
end if.
variable labels hk_sti "Had an STI in the past 12 months".
value labels  hk_sti 0"No" 1"Yes".

*Discharge in the past 12 months.
do if v525<>0 and v525<>99 and not sysmis(v525). 
+compute hk_computet_disch=0.
+if v763c=1 hk_computet_disch=1.
end if.
variable labels hk_computet_disch "Had an abnormal (or bad-smelling) computeital discharge in the past 12 months".
value labels  hk_computet_disch 0"No" 1"Yes".

*genital sore in past 12 months.
do if v525<>0 and v525<>99 and not sysmis(v525). 
+compute hk_gent_sore=0.
+if v763b=1 hk_gent_sore=1.
end if.
variable labels hk_gent_sore "Had a genital sore or ulcer in the past 12 months".
value labels  hk_gent_sore 0"No" 1"Yes".

*STI or STI symptoms in the past 12 months.
do if v525<>0 and v525<>99 and not sysmis(v525). 
+compute hk_sti_symp=0.
+if (v763a=1 | v763b=1 | v763c=1) hk_sti_symp=1.
end if.
variable labels hk_sti_symp "Had an STI or STI symptoms in the past 12 months".
value labels  hk_sti_symp 0"No" 1"Yes".

*Sought care from clinic/hospital/private doctor for STI.
if v763a=1 | v763b=1 | v763c=1 hk_sti_trt_doc = 0.
do repeat x=v770a v770b v770c v770d v770e v770f v770g v770h v770i v770j v770k v770l v770n v770o v770p v770q v770r v770s.
+if x=1 hk_sti_trt_doc=1.
end repeat.
variable labels hk_sti_trt_doc "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor".
value labels  hk_sti_trt_doc 0"No" 1"Yes".

*Sought care from pharmacy for STI.
if v763a=1 | v763b=1 | v763c=1 hk_sti_trt_pharm = 0.
if v770m=1 | v770t=1 hk_sti_trt_pharm=1.
variable labels hk_sti_trt_pharm "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy".
value labels  hk_sti_trt_pharm 0"No" 1"Yes".

*Sought care from any other source for STI.
if v763a=1 | v763b=1 | v763c=1 hk_sti_trt_other = 0.
if v770u=1 | v770v=1 | v770w=1 | v770x=1 hk_sti_trt_other =1.
variable labels hk_sti_trt_other "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source".
value labels  hk_sti_trt_other 0"No" 1"Yes".

*Did not seek care for STI.
if v763a=1 | v763b=1 | v763c=1 hk_sti_notrt = 0.
if v770=0 hk_sti_notrt=1.
variable labels hk_sti_notrt "Had an STI or STI symptoms in the past 12 months and sought no advice or treatment".
value labels  hk_sti_notrt 0"No" 1"Yes".
