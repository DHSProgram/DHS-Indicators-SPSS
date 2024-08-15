* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_MN_NUT.sps
Purpose: 			Code to compute anthropometry and anemia indicators in men
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: May 16 2020 by Ivana Bjelic
Note:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
nt_mn_any_anem		"Any anemia - men"
*
nt_mn_bmi_mean		"Mean BMI  - men 15-49"
nt_mn_bmi_mean_all         	"Mean BMI  - all men"
nt_mn_norm		"Normal BMI - men"
nt_mn_thin			"Thin BMI - men"
nt_mn_mthin		"Mildly thin BMI  - men"
nt_mn_modsevthin            	"Moderately and severely thin BMI - men"
nt_mn_ovobese		"Overweight or obese BMI  - men"
nt_mn_ovwt			"Overweight BMI  - men"
nt_mn_obese		"Obese BMI  - men"

*----------------------------------------------------------------------------.

compute wt=mv005/1000000.

*** Anemia indicators ***

*Any anemia.
do if hv103<>0 and hv042=1 and hb55=0.
+compute nt_mn_any_anem=0.
+if hb56<130  nt_mn_any_anem=1. 
end if.
variable labels nt_mn_any_anem "Any anemia - men".
value labels nt_mn_any_anem 1 "Yes" 0 "No".

*** Anthropometry indicators ***

*Mean BMI - men 15-49.
weight by wt.
compute bmi=hb40/100.
compute filter=(range(bmi,12,60) & mv013<8).
filter by filter.
aggregate outfile=* mode=addvariables overwrite=yes
/break
/nt_mn_bmi_mean=mean(bmi).
variable labels nt_mn_bmi_mean "Mean BMI  - men 15-49".
filter off.
*Mean BMI - all men.
compute filter=range(bmi,12,60).
aggregate outfile=* mode=addvariables overwrite=yes
/break
/nt_mn_bmi_mean_all=mean(bmi).
variable labels nt_mn_bmi_mean_all "Mean BMI  - all men".
weight off.
filter off.

*Normal weight.
do if range(hb40,1200,6000).
+compute nt_mn_norm=0.
+if range(hb40,1850,2499) nt_mn_norm=1.
end if.
variable labels nt_mn_norm "Normal BMI - men".
value labels nt_mn_norm 1 "Yes" 0 "No".

*Thin.
do if range(hb40,1200,6000).
+compute nt_mn_thin=0.
+if range(hb40,1200,1849) nt_mn_thin=1.
end if.
variable labels nt_mn_thin "Thin BMI - men".
value labels nt_mn_thin 1 "Yes" 0 "No".

*Mildly thin.
do if range(hb40,1200,6000).
+compute nt_mn_mthin=0.
+if range(hb40,1700,1849) nt_mn_mthin=1.
end if.
variable labels nt_mn_mthin "Mildly thin BMI  - men".
value labels nt_mn_mthin 1 "Yes" 0 "No".

*Moderately and severely thin.
do if range(hb40,1200,6000).
+compute nt_mn_modsevthin=0.
+if range(hb40,1200,1699) nt_mn_modsevthin=1.
end if.
variable labels nt_mn_modsevthin "Moderately and severely thin BMI - men".
value labels nt_mn_modsevthin 1 "Yes" 0 "No".

*Overweight or obese.
do if range(hb40,1200,6000).
+compute nt_mn_ovobese=0.
+if range(hb40,2500,6000) nt_mn_ovobese=1.
end if.
variable labels nt_mn_ovobese "Overweight or obese BMI  - men".
value labels nt_mn_ovobese 1 "Yes" 0 "No".

*Overweight.
do if range(hb40,1200,6000).
+compute nt_mn_ovwt=0.
+if range(hb40,2500,2999) nt_mn_ovwt=1.
end if.
variable labels nt_mn_ovwt "Overweight BMI  - men".
value labels nt_mn_ovwt 1 "Yes" 0 "No".

*Obese.
do if range(hb40,1200,6000).
+compute nt_mn_obese=0.
+if range(hb40,3000,6000) nt_mn_obese=1.
end if.
variable labels nt_mn_obese "Obese BMI  - men".
value labels nt_mn_obese 1 "Yes" 0 "No".

