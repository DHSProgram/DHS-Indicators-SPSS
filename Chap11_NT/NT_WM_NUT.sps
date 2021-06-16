* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_WM_NUT.sps
Purpose: 			Code to compute anthropometry and anemia indicators in women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: May 16 2020 by Ivana Bjelic
Note:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
nt_wm_any_anem		"Any anemia - women"
nt_wm_mild_anem		"Mild anemia - women"
nt_wm_mod_anem		"Moderate anemia - women"
nt_wm_sev_anem		"Severe anemia - women"
*
nt_wm_ht			"Height under 145cm - women"	
*
nt_wm_bmi_mean		"Mean BMI  - women"
nt_wm_norm		"Normal BMI - women"
nt_wm_thin			"Thin BMI - women"
nt_wm_mthin		"Mildly thin BMI  - women"
nt_wm_modsevthin            	"Moderately and severely thin BMI - women"
nt_wm_ovobese		"Overweight or obese BMI  - women"
nt_wm_ovwt			"Overweight BMI  - women"
nt_wm_obese		"Obese BMI  - women"
*
nt_wm_micro_iron	                  "Number of days women took iron supplements during last pregnancy"
nt_wm_micro_dwm		"Women who took deworming medication during last pregnancy"
nt_wm_micro_iod		"Women living in hh with iodized salt"

*----------------------------------------------------------------------------.

compute wt=v005/1000000.

*** Anemia indicators ***

*Any anemia.
if v042=1 & v455=0 nt_wm_any_anem=0.
if (v456<120 & v213=0) or (v456<110 & v213=1) nt_wm_any_anem=1.
variable labels nt_wm_any_anem "Any anemia - women".
value labels nt_wm_any_anem 1 "Yes" 0 "No".

*Mild anemia.
if v042=1 & v455=0 nt_wm_mild_anem=0.
if (range(v456,100,119) & v213=0) or (range(v456,100,109) & v213=1) nt_wm_mild_anem=1.
variable labels nt_wm_mild_anem "Mild anemia - women".
value labels nt_wm_mild_anem 1 "Yes" 0 "No".

*Moderate anemia.
if v042=1 & v455=0 nt_wm_mod_anem=0.
if v457=2 nt_wm_mod_anem=1.
variable labels nt_wm_mod_anem "Moderate anemia - women".
value labels nt_wm_mod_anem 1 "Yes" 0 "No".

*Severe anemia.
if v042=1 & v455=0 nt_wm_sev_anem=0.
if v457=1 nt_wm_sev_anem=1.
variable labels nt_wm_sev_anem "Severe anemia - women".
value labels nt_wm_sev_anem 1 "Yes" 0 "No".

*** Anthropometry indicators ***

* age of most recent child.
* to check if survey has b19, which should be used instead to compute age. 
begin program.
import spss, spssaux
varList = "b19$01"
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
  /b19$01_included=mean(b19$01).
recode b19$01_included (lo thru hi = 1)(else = 0).

* if b19 is present and not empty.
do if b19$01_included = 1.
    compute age = b19$01.
else.
** if b19 is not present, compute age.
    compute age = v008 - b3$01.
end if.

*Height less than 145cm.
if range(v438,1300,2200) nt_wm_ht= v438<1450.
variable labels nt_wm_ht "Height under 145cm - women".
value labels nt_wm_ht 1 "Yes" 0 "No".

*Mean BMI.
compute bmi=v445/100.
weight by wt.
compute filter=(range(bmi,12,60) & (v213<>1 & (v208=0 or age>=2))).
filter by filter.
aggregate outfile=* mode=addvariables overwrite=yes
/break
/nt_wm_bmi_mean=mean(bmi).
variable labels nt_wm_bmi_mean "Mean BMI  - women".
filter off.
weight off.

*Normal weight.
do if range(v445,1200,6000).
+compute nt_wm_norm=0.
+if range(v445,1850,2499) nt_wm_norm=1.
end if.
if (v213=1 or age<2) nt_wm_norm=$sysmis.
variable labels nt_wm_norm "Normal BMI - women".
value labels nt_wm_norm 1 "Yes" 0 "No".

*Thin.
do if range(v445,1200,6000).
+compute nt_wm_thin=0.
+if range(v445,1200,1849) nt_wm_thin=1.
end if.
if (v213=1 or age<2) nt_wm_thin=$sysmis.
variable labels nt_wm_thin "Thin BMI - women".
value labels nt_wm_thin 1 "Yes" 0 "No".

*Mildly thin.
do if range(v445,1200,6000).
+compute nt_wm_mthin=0.
+if range(v445,1700,1849) nt_wm_mthin=1.
end if.
if (v213=1 or age<2) nt_wm_mthin=$sysmis.
variable labels nt_wm_mthin "Mildly thin BMI  - women".
value labels nt_wm_mthin 1 "Yes" 0 "No".

*Moderately and severely thin.
do if range(v445,1200,6000).
+compute nt_wm_modsevthin=0.
+if range(v445,1200,1699) nt_wm_modsevthin=1.
end if.
if (v213=1 or age<2) nt_wm_modsevthin=$sysmis.
variable labels nt_wm_modsevthin "Moderately and severely thin BMI - women".
value labels nt_wm_modsevthin 1 "Yes" 0 "No".

*Overweight or obese.
do if range(v445,1200,6000).
+compute nt_wm_ovobese=0.
+if  range(v445,2500,6000) nt_wm_ovobese=1.
end if.
if (v213=1 or age<2) nt_wm_ovobese=$sysmis.
variable labels nt_wm_ovobese "Overweight or obese BMI  - women".
value labels nt_wm_ovobese 1 "Yes" 0 "No".

*Overweight.
do if range(v445,1200,6000).
+compute nt_wm_ovwt=0.
+if range(v445,2500,2999) nt_wm_ovwt=1.
end if.
if (v213=1 or age<2) nt_wm_ovwt=$sysmis.
variable labels nt_wm_ovwt "Overweight BMI  - women".
value labels nt_wm_ovwt 1 "Yes" 0 "No".

*Obese.
do if range(v445,1200,6000).
+compute nt_wm_obese=0.
+if range(v445,3000,6000) nt_wm_obese=1.
end if.
if (v213=1 or age<2) nt_wm_obese=$sysmis.
variable labels nt_wm_obese "Obese BMI  - women".
value labels nt_wm_obese 1 "Yes" 0 "No".

*Took iron supplements during last pregnancy.
do if (v208<>0).
+if m45$1=0 nt_wm_micro_iron=0.
+if range(m46$1,0,59) nt_wm_micro_iron=1.
+if range(m46$1,60,89) nt_wm_micro_iron=2.
+if range(m46$1,90,300) nt_wm_micro_iron=3.
+if m45$1=8 or m45$1=9 or m46$1=998 or m46$1=999 nt_wm_micro_iron=4.
end if.
variable labels nt_wm_micro_iron "Number of days women took iron supplements during last pregnancy".
value labels nt_wm_micro_iron 0"None" 1"<60" 2"60-89" 3"90+" 4"Don't know/missing".

*Took deworming medication during last pregnancy.
do if (v208<>0).
+compute nt_wm_micro_dwm=0.
+if m60$1=1 nt_wm_micro_dwm=1.
end if.
variable labels nt_wm_micro_dwm "Women who took deworming medication during last pregnancy".
value labels nt_wm_micro_dwm 1 "Yes" 0 "No".

*Woman living in household with idodized salt.
do if (v208<>0 and hv234a<=1).
+compute nt_wm_micro_iod=0.
+if  hv234a=1 nt_wm_micro_iod=1.
end if.
variable labels nt_wm_micro_iod "Women living in hh with iodized salt".
value labels nt_wm_micro_iod 1 "Yes" 0 "No".
