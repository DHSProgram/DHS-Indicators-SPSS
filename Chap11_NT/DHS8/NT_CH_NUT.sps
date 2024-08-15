* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_CH_NUT.sps
Purpose: 			Code to compute anthropometry and anemia indicators in children
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: May 16 2020 by Ivana Bjelic
Note:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
nt_ch_sev_stunt		"Severely stunted child under 5 years"
nt_ch_stunt			"Stunted child under 5 years"
nt_ch_mean_haz		"Mean z-score for height-for-age for children under 5 years"
nt_ch_sev_wast		"Severely wasted child under 5 years"
nt_ch_wast			"Wasted child under 5 years"
nt_ch_ovwt_ht		"Overweight for heigt child under 5 years"
nt_ch_mean_whz		"Mean z-score for weight-for-height for children under 5 years"
nt_ch_sev_underwt            	"Severely underweight child under 5 years"
nt_ch_underwt		"Underweight child under 5 years"
nt_ch_ovwt_age		"Overweight for age child under 5 years"
nt_ch_mean_waz		"Mean weight-for-age for children under 5 years"
*	
nt_ch_any_anem		"Any anemia - child 6-59 months"
nt_ch_mild_anem		"Mild anemia - child 6-59 months"
nt_ch_mod_anem		"Moderate anemia - child 6-59 months"
nt_ch_sev_anem		"Severe anemia - child 6-59 months"
----------------------------------------------------------------------------.

compute wt=hv005/1000000.

*** Anthropometry indicators ***

*Severely stunted.
do if hc70<=9996 and hv103=1.
+compute nt_ch_sev_stunt= 0.
+if hc70<-300 nt_ch_sev_stunt=1.
end if.
variable labels nt_ch_sev_stunt "Severely stunted child under 5 years".
value labels nt_ch_sev_stunt 1 "Yes" 0 "No".

*Stunted.
do if hc70<=9996 and hv103=1.
+compute nt_ch_stunt= 0.
+if hc70<-200 nt_ch_stunt=1.
end if.
variable labels nt_ch_stunt "Stunted child under 5 years".
value labels nt_ch_stunt 1 "Yes" 0 "No".

*Mean haz.
weight by wt.
if hc70<996 and hv103=1 haz = hc70/100.
aggregate outfile = * mode =addvariables overwrite = yes
/break
/nt_ch_mean_haz=mean(haz).
variable labels nt_ch_mean_haz "Mean z-score for height-for-age for children under 5 years".
weight off.

*Severely wasted.
do if hc72<9996 and hv103=1.
+compute nt_ch_sev_wast= 0.
+if hc72<-300 nt_ch_sev_wast=1.
end if.
variable labels nt_ch_sev_wast "Severely wasted child under 5 years".
value labels nt_ch_sev_wast 1 "Yes" 0 "No".

*Wasted.
do if hc72<9996 and hv103=1.
+compute nt_ch_wast= 0.
+if hc72<-200 nt_ch_wast=1.
end if.
variable labels nt_ch_wast "Wasted child under 5 years".
value labels nt_ch_wast 1 "Yes" 0 "No".

*Overweight for height.
do if hc72<9996 and hv103=1.
+compute nt_ch_ovwt_ht=0.
+if hc72>200 & hc72<9996 nt_ch_ovwt_ht=1.
end if.
variable labels nt_ch_ovwt_ht "Overweight for height child under 5 years".
value labels nt_ch_ovwt_ht 1 "Yes" 0 "No".

*Mean whz.
weight by wt.
if hc72<996 and hv103=1 whz=hc72/100.
aggregate outfile = * mode =addvariables overwrite = yes
/break
/nt_ch_mean_whz=mean(whz).
variable labels nt_ch_mean_whz "Mean z-score for weight-for-height for children under 5 years".
weight off.

*Severely underweight.
do if hc71<9996 and hv103=1.
+compute nt_ch_sev_underwt=0.
+if hc71<-300 nt_ch_sev_underwt=1.
end if.
variable labels nt_ch_sev_underwt	"Severely underweight child under 5 years".
value labels nt_ch_sev_underwt 1 "Yes" 0 "No".

*Underweight.
do if hc71<9996 and hv103=1.
+compute nt_ch_underwt= 0.
+if hc71<-200 nt_ch_underwt=1.
end if.
variable labels nt_ch_underwt "Underweight child under 5 years".
value labels nt_ch_underwt 1 "Yes" 0 "No".

*Overweight for age.
do if hc71<9996 and hv103=1.
+compute nt_ch_ovwt_age= 0.
+if hc71>200 nt_ch_ovwt_age=1.
end if.
variable labels nt_ch_ovwt_age "Overweight for age child under 5 years".
value labels nt_ch_ovwt_age 1 "Yes" 0 "No".

*Mean waz.
weight by wt.
if hc71<996 and hv103=1 waz=hc71/100.
aggregate outfile = * mode =addvariables overwrite = yes
/break
/nt_ch_mean_waz=mean(waz).
variable labels nt_ch_mean_waz "Mean weight-for-age for children under 5 years".
weight off.

*** Anemia indicators ***

*Any anemia.
do if ((hv103=1 & hc1>5 & hc1<60) and hc56<997).
+compute nt_ch_any_anem=0.
+if hc56<110 nt_ch_any_anem=1.
end if.
variable labels nt_ch_any_anem "Any anemia - child 6-59 months".
value labels nt_ch_any_anem 1 "Yes" 0 "No".

*Mild anemia.
do if ((hv103=1 & hc1>5 & hc1<60) and hc56<997).
+compute nt_ch_mild_anem=0.
+if hc56>99 & hc56<110 nt_ch_mild_anem=1.
end if.
variable labels nt_ch_mild_anem "Mild anemia - child 6-59 months".
value labels nt_ch_mild_anem 1 "Yes" 0 "No".

*Moderate anemia.
do if ((hv103=1 & hc1>5 & hc1<60) and hc56<997).
+compute nt_ch_mod_anem=0.
+if hc56>69 & hc56<100 nt_ch_mod_anem=1.
end if.
variable labels nt_ch_mod_anem "Moderate anemia - child 6-59 months".
value labels nt_ch_mod_anem 1 "Yes" 0 "No".

*Severe anemia.
do if ((hv103=1 & hc1>5 & hc1<60) and hc56<997).
+compute nt_ch_sev_anem=0.
+if hc56<70 nt_ch_sev_anem=1.
end if.
variable labels nt_ch_sev_anem "Severe anemia - child 6-59 months".
value labels nt_ch_sev_anem 1 "Yes" 0 "No".
