* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CH_ARI_FV.sps
Purpose: 			Code ARI and fever variables
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: September 01 by Ivana Bjelic
Notes:				
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
ch_ari			"ARI symptoms in the 2 weeks before the survey"
ch_ari_care			"Advice or treatment sought for ARI symptoms"
ch_ari_care_day		"Advice or treatment sought for ARI symptoms on the same or next day"
*
ch_ari_govh			"ARI treatment sought from government hospital among children with ARI"
ch_ari_govh_trt		"ARI treatment sought from government hospital among children with ARI that sought treatment"
ch_ari_govcent 		"ARI treatment sought from government health center among children with ARI"
ch_ari_govcent_trt             	"ARI treatment sought from government health center among children with ARI that sought treatment"
ch_ari_pclinc 		"ARI treatment sought from private hospital/clinic among children with ARI"
ch_ari_pclinc_trt             	"ARI treatment sought from private hospital/clinic  among children with ARI that sought treatment"
ch_ari_pdoc			"ARI treatment sought from private doctor among children with ARI"
ch_ari_pdoc_trt		"ARI treatment sought from private doctor among children with ARI that sought treatment"
ch_ari_pharm		"ARI treatment sought from pharmacy among children with ARI"
ch_ari_pharm_trt            	"ARI treatment sought from pharmacy among children with ARI that sought treatment"
*
ch_fever			"Fever symptoms in the 2 weeks before the survey"
ch_fev_care			"Advice or treatment sought for fever symptoms"
ch_fev_care_day		"Advice or treatment sought for ARI symptoms on the same or next day"
ch_fev_antib	                    	"Antibiotics taken for fever symptoms"
----------------------------------------------------------------------------.

** ARI indicators ***

*ARI symptoms.
* ari defintion differs by survey according to whether h31c is included or not.
begin program.
import spss, spssaux
varList = "h31c"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /h31c_included=mean(h31c).
recode h31c_included (lo thru hi = 1)(else = 0).

***************************

* if h31c is present and not empty.
do if  h31c_included = 1 and b5 <> 0.
    compute ch_ari=0.
    if h31b=1 & (h31c=1 | h31c=3) ch_ari=1 .
else if h31c_included <> 1 and b5 <> 0.
    compute ch_ari=0.
    if h31b=1 & (h31=2) ch_ari=1.
end if.
	
* survey specific changes.
do if (krdata = "IAKR23FL"|krdata ="PHKR31FL") and b5<>0.
    compute ch_ari=0.
    if h31b=1 & (h31=2|h31=1) ch_ari=1.
end if.

variable labels ch_ari "ARI symptoms in the 2 weeks before the survey".
value labels ch_ari 0 "No" 1 "Yes".
	
*ARI care-seeking.
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** The code below only excludes traditional practitioner (usually h32t). The variable for traditional healer may be different for different surveys (you can check this by: des h32*). 
*** Some surveys also exclude pharmacies, shop, or other sources.
do if b5<>0 and ch_ari=1.
+compute ch_ari_care=0.
+do repeat x= h32a h32b h32c h32d h32e h32f h32g h32h h32i h32j h32k h32l h32m h32n h32o h32p h32q h32r h32s h32u h32v h32w h32x.
+  if x=1 ch_ari_care=1.
+end repeat.
* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove.
* the 'k in the list on line 82 or do the following.
*+if h32k=1 ch_ari_care=0.
end if.
variable labels ch_ari_care "Advice or treatment sought for ARI symptoms".
value labels ch_ari_care 0 "No" 1 "Yes".

*ARI care-seeking same or next day.
*for surveys that do not have the variable h46b.
begin program.
import spss, spssaux
varList = "h46b"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /h46b_included=mean(h46b).
recode h46b_included (lo thru hi = 1)(else = 0).

do if b5<>0 and ch_ari=1 and h46b_included=1.
+compute ch_ari_care_day=0.
+if h46b<2 ch_ari_care_day=1.
end if.
variable labels ch_ari_care_day "Advice or treatment sought for ARI symptoms on the same or next day".
value labels ch_ari_care_day 0 "No" 1 "Yes".

*** ARI treatment by source *** 
* Two population bases: 1. among children with ARI symptoms, 2. among children with ARI symptoms that sought treatment
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. h32a-z indicates the source.

*ARI treamtment in government hospital.
do if b5<>0 and ch_ari=1.
+compute ch_ari_govh=0.
+if h32a=1 ch_ari_govh=1.
end if.
variable labels ch_ari_govh "ARI treatment sought from government hospital among children with ARI".
value labels ch_ari_govh 0 "No" 1 "Yes".

do if b5<>0 and ch_ari_care=1.
+compute ch_ari_govh_trt=0.
+if h32a=1 ch_ari_govh_trt=1.
end if.
variable labels ch_ari_govh_trt "ARI treatment sought from government hospital among children with ARI that sought treatment".
value labels ch_ari_govh_trt 0 "No" 1 "Yes".

*ARI treamtment in government health center.
do if b5<>0 and ch_ari=1.
+compute ch_ari_govcent=0.
+if h32b=1 ch_ari_govcent=1.
end if.
variable labels ch_ari_govcent "ARI treatment sought from government health center among children with ARI".
value labels ch_ari_govcent 0 "No" 1 "Yes".

do if b5<>0 and ch_ari_care=1.
+compute ch_ari_govcent_trt=0.
+if h32b=1 ch_ari_govcent_trt=1.
end if.
variable labels ch_ari_govcent_trt "ARI treatment sought from government health center among children with ARI that sought treatment".
value labels ch_ari_govcent_trt 0 "No" 1 "Yes".

*ARI treatment from a private hospital/clinic.
do if b5<>0 and ch_ari=1.
+compute ch_ari_pclinc=0.
+if h32j=1 ch_ari_pclinc=1.
end if.
variable labels ch_ari_pclinc "ARI treatment sought from private hospital/clinic among children with ARI".
value labels ch_ari_pclinc 0 "No" 1 "Yes".

do if b5<>0 and ch_ari_care=1.
+compute ch_ari_pclinc_trt=0.
+if h32j=1 ch_ari_pclinc_trt=1.
end if.
variable labels ch_ari_pclinc_trt "ARI treatment sought from private hospital/clinic  among children with ARI that sought treatment".
value labels ch_ari_pclinc_trt 0 "No" 1 "Yes".

*ARI treatment from a private doctor.
do if b5<>0 and ch_ari=1.
+compute ch_ari_pdoc=0.
+if h32l=1 ch_ari_pdoc=1.
end if.
variable labels ch_ari_pdoc "ARI treatment sought from private doctor among children with ARI".
value labels ch_ari_pdoc 0 "No" 1 "Yes".

do if b5<>0 and ch_ari_care=1.
+compute ch_ari_pdoc_trt=0.
+if h32l=1 ch_ari_pdoc_trt=1.
end if.
variable labels ch_ari_pdoc_trt "ARI treatment sought from private doctor among children with ARI that sought treatment".
value labels ch_ari_pdoc_trt 0 "No" 1 "Yes".

*ARI treatment from a pharmacy.
do if b5<>0 and ch_ari=1.
+compute ch_ari_pharm=0.
+if h32k=1 ch_ari_pharm=1.
end if.
variable labels ch_ari_pharm "ARI treatment sought from a pharmacy among children with ARI".
value labels ch_ari_pharm 0 "No" 1 "Yes".

do if b5<>0 and ch_ari_care=1.
+compute ch_ari_pharm_trt=0.
+if h32k=1 ch_ari_pharm_trt=1.
end if.
variable labels ch_ari_pharm_trt "ARI treatment sought from a pharmacy among children with ARI that sought treatment".
value labels ch_ari_pharm_trt 0 "No" 1 "Yes".


*** Fever indicators ***

*Fever.
do if b5<>0.
+compute ch_fever=0.
+if h22=1 ch_fever=1.
end if.
variable labels ch_fever "Fever symptoms in the 2 weeks before the survey".
value labels ch_fever 0 "No" 1 "Yes".
	
*Fever care-seeking
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** The code below only excludes traditional practitioner (usually h32t). The variable for traditional healer may be different for different surveys (you can check this by: des h32*). 
*** Some surveys also exclude pharmacies, shop, or other sources.
do if b5<>0 and ch_fever=1.
+compute ch_fev_care=0.
+do repeat x=h32a h32b h32c h32d h32e h32f h32g h32h h32i h32j h32k h32l h32m h32n h32o h32p h32q h32r h32s h32u h32v h32w h32x.
+  if x=1 ch_fev_care=1.
+end repeat.
* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove .
* the 'k in the list on line 203 or do the following.
*+if h32k=1 ch_fev_care=0.
end if.
variable labels ch_fev_care "Advice or treatment sought for fever symptoms".
value labels ch_fev_care 0 "No" 1 "Yes".

*Fever care-seeking same or next day.
do if b5<>0 and ch_fever=1.
+compute ch_fev_care_day=0.
+if ch_fev_care=1 & h46b<2 ch_fev_care_day=1.
end if.
variable labels ch_fev_care_day "Advice or treatment sought for fever symptoms on the same or next day".
value labels ch_fev_care_day 0 "No" 1 "Yes".

*Fiven antibiotics for fever.
do if b5<>0 and ch_fever=1.
+compute ch_fev_antib=0.
+if  (h37i=1 | h37j=1) ch_fev_antib=1.
+if (ml13i=1 | ml13j =1) ch_fev_antib=1.
end if.
variable labels ch_fev_antib "Antibiotics taken for fever symptoms".
value labels ch_fev_antib 0 "No" 1 "Yes".
