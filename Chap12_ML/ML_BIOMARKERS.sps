* Encoding: windows-1252.
*****************************************************************************************************
Program: 			ML_BIOMARKERS.sps
Purpose: 			Code anemia and malaria testing prevalence in children under 5
Data inputs: 		PR survey list
Data outputs:		coded variables
Author:				Cameron Taylor and Shireen Assaf, translated to SPSS by Ivana Bjelic
Date last modified: August 28 2019 by Ivana Bjelic
*****************************************************************************************************

*----------------------------------------------------------------------------
Variables created in this file:
ml_test_anemia	Tested for anemia in children 6-59 months
ml_test_micmal 	Tested for Parasitemia (via microscopy) in children 6-59 months
ml_test_rdtmal	Tested for Parasitemia (via RDT) in children 6-59 months
*
ml_anemia		Anemia in children 6-59 months
ml_micmalpos 	Parasitemia (via microscopy) in children 6-59 months
ml_rdtmalpos	Parasitemia (via RDT) in children 6-59 months
----------------------------------------------------------------------------*

*** Testing ***

*Tested for Anemia.
do if hv103=1 & hc1>=6 & hc1<=59 & hv042=1.
+compute ml_test_anemia=0.
+if hc55=0 ml_test_anemia=1.
end if.
variable labels ml_test_anemia "Tested for anemia in children 6-59 months".
value labels ml_test_anemia 0 "No" 1 "Yes".

*Tested for Parasitemia via microscopy.
do if hv103=1 & hc1>=6 & hc1<=59 & hv042=1.
+compute ml_test_micmal=0.
if hml32=0 | hml32=1 | hml32=6 ml_test_micmal=1.
end if.
variable labels ml_test_micmal "Tested for Parasitemia (via microscopy) in children 6-59 months".
value labels ml_test_micmal 0 "No" 1 "Yes".

*Tested for Parasitemia via RDT.
do if hv103=1 & hc1>=6 & hc1<=59 & hv042=1.
+compute ml_test_rdtmal=0.
+if hml35=0 | hml35=1 ml_test_rdtmal=1.
end if.
variable labels ml_test_rdtmal "Tested for Parasitemia (via RDT) in children 6-59 months".
value labels ml_test_rdtmal 0 "No" 1 "Yes".

*** Prevalence ***

*Anemia in children 6-59 months.
do if hv103=1 & hc1>=6 & hc1<=59 & hc55=0 & hv042=1.
+compute ml_anemia=0.
+if hc56<80 ml_anemia=1.
end if.
variable labels  ml_anemia "Anemia in children 6-59 months".
value labels ml_anemia 0 "No" 1 "Yes".

*Parasitemia (via microscopy) in children 6-59 months.
do if hv103=1 & hc1>=6 & hc1<=59 & hv042=1 & (hml32=0 | hml32=1 | hml32=6).
+compute ml_micmalpos=0.
+if hml32=1 & hv103=1 & hc1>=6 & hc1<=59 & hv042=1 ml_micmalpos=1.
end if.
variable labels  ml_micmalpos "Parasitemia (via microscopy) in children 6-59 months".
value labels ml_micmalpos 0 "No" 1 "Yes".
	
*Parasitemia (vis RDT) in children 6-59 months.
do if hv103=1 & hc1>=6 & hc1<=59 & hv042=1 & (hml35=0 | hml35=1).
+compute ml_rdtmalpos=0.
+if hml35=1 & hv103=1 & hc1>=6 & hc1<=59 & hv042=1  ml_rdtmalpos=1.
end if.
variable labels ml_rdtmalpos "Parasitemia (via RDT) in children 6-59 months".
value labels ml_rdtmalpos 0 "No" 1 "Yes".
