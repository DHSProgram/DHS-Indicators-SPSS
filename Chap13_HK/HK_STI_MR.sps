* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_STI_MR.sps
Purpose: 			Code for STI indicators
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Nov 29, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. No age selection is made here.
			
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
hk_sti			"Had an STI in the past 12 months"
hk_computet_disch		"Had an abnormal (or bad-smelling) computeital discharge in the past 12 months"
hk_computet_sore		"Had a computeital sore or ulcer in the past 12 months"
hk_sti_symp		"Had an STI or STI symptoms in the past 12 months"
hk_sti_trt_doc		"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor"
hk_sti_trt_pharm	 "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy"
hk_sti_trt_other	 "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source"
hk_sti_notrt		"Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"
----------------------------------------------------------------------------.

* indicators from MR file.

**************************
*STI in the past 12 months.
do if mv525<>0 and mv525<>99 and not sysmis(mv525). 
+compute hk_sti=0.
+if  mv763a=1 hk_sti=1.
end if.
variable labels hk_sti "Had an STI in the past 12 months".
value labels  hk_sti 0"No" 1"Yes".

*Discharge in the past 12 months.
do if mv525<>0 and mv525<>99 and not sysmis(mv525). 
+compute hk_computet_disch=0.
+if  mv763c=1 hk_computet_disch=1.
end if.
variable labels hk_computet_disch "Had an abnormal (or bad-smelling) computeital discharge in the past 12 months".
value labels  hk_computet_disch 0"No" 1"Yes".

*compute genital sore in past 12 months.
do if mv525<>0 and mv525<>99 and not sysmis(mv525). 
+compute hk_gent_sore=0.
+if  mv763b=1 hk_gent_sore=1.
end if.
variable labels hk_gent_sore "Had a computeital sore or ulcer in the past 12 months".
value labels  hk_gent_sore 0"No" 1"Yes".

*STI or STI symptoms in the past 12 months.
do if mv525<>0 and mv525<>99 and not sysmis(mv525). 
+compute hk_sti_symp=0.
+if (mv763a=1 | mv763b=1 | mv763c=1) hk_sti_symp=1.
end if.
variable labels hk_sti_symp "Had an STI or STI symptoms in the past 12 months".
value labels  hk_sti_symp 0"No" 1"Yes".

*Sought care from clinic/hospital/private doctor for STI.
if mv763a=1 | mv763b=1 | mv763c=1 hk_sti_trt_doc = 0.
do repeat x=mv770a mv770b mv770c mv770d mv770e mv770f mv770g mv770h mv770i mv770j mv770k mv770l mv770n mv770o mv770p mv770q mv770r mv770s.
+if x=1 hk_sti_trt_doc=1.
end repeat.
variable labels hk_sti_trt_doc "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor".
value labels  hk_sti_trt_doc 0"No" 1"Yes".

*Sought care from pharmacy for STI.
if mv763a=1 | mv763b=1 | mv763c=1  hk_sti_trt_pharm = 0.
if mv770m=1 | mv770t=1 hk_sti_trt_pharm=1.
variable labels hk_sti_trt_pharm "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy".
value labels  hk_sti_trt_pharm 0"No" 1"Yes".

*Sought care from any other source for STI.
if mv763a=1 | mv763b=1 | mv763c=1 hk_sti_trt_other = 0.
if mv770u=1 | mv770v=1 | mv770w=1 | mv770x=1 hk_sti_trt_other =1.
variable labels hk_sti_trt_other "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source".
value labels  hk_sti_trt_other 0"No" 1"Yes".

*Did not seek care for STI.
if mv763a=1 | mv763b=1 | mv763c=1 hk_sti_notrt = 0.
if mv770=0 hk_sti_notrt=1.
variable labels hk_sti_notrt "Had an STI or STI symptoms in the past 12 months and sought no advice or treatment".
value labels  hk_sti_notrt 0"No" 1"Yes".
