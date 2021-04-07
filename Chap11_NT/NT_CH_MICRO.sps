* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_CH_MICRO.sps
Purpose: 			Code to compute micronutrient indicators in children
Data inputs: 		KR file
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: May 16 2020 by Ivana Bjelic
Note:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
nt_ch_micro_mp		"Children age 6-23 mos given multiple micronutrient powder"
nt_ch_micro_iron             	"Children age 6-59 mos given iron supplements"
nt_ch_micro_vas		"Children age 6-59 mos given Vit. A supplements"
nt_ch_micro_dwm		"Children age 6-59 mos given deworming medication"
nt_ch_micro_iod		"Children age 6-59 mos live in hh with iodized salt"
nt_ch_food_ther		"Children age 6-35 mos given therapeutic food"
nt_ch_food_supp		"Children age 6-35 mos given supplemental food"

*----------------------------------------------------------------------------.

*Received multiple micronutrient powder.
do if (age>=6 and age <=23) and b5<>0.
+compute nt_ch_micro_mp=0.
+if h80a=1 nt_ch_micro_mp=1.
end if.
variable labels  nt_ch_micro_mp "Children age 6-23 mos given multiple micronutrient powder".
value labels nt_ch_micro_mp 1 "Yes" 0 "No".

*Received iron supplements.
do if (age>=6 and age <=23) and b5<>0.
+compute nt_ch_micro_iron=0.
+if h42=1 nt_ch_micro_iron=1.
end if.
variable labels  nt_ch_micro_iron "Children age 6-59 mos given iron supplements".
value labels nt_ch_micro_iron 1 "Yes" 0 "No".

*Received Vit. A supplements.
recode h33m (97,98,99=sysmis)(else=copy) into h33m2.
recode h33d (97,98,99=15)(else=copy) into h33d2.
recode h33y (9997,9998,9999=sysmis)(else=copy) into h33y2.
do if (age>=6 and age<=59) and b5<>0.
+compute nt_ch_micro_vas=0.
+if (h34=1 or (trunc((yrmoda(v007,v006,v016) - yrmoda(h33y2,h33m2,h33d2))/30.4375) < 6)) nt_ch_micro_vas=1.
end if.
variable labels  nt_ch_micro_vas "Children age 6-59 mos given Vit. A supplements".
value labels nt_ch_micro_vas 1 "Yes" 0 "No".

*Received deworming medication.
do if (age>=6 and age<=59) and b5<>0.
+compute nt_ch_micro_dwm=0.
+if h43=1 nt_ch_micro_dwm=1.
end if.
variable labels  nt_ch_micro_dwm "Children age 6-59 mos given deworming medication".
value labels  nt_ch_micro_dwm 1 "Yes" 0 "No".

*Child living in household with idodized salt.
do if (age>=6 and age<=59) and b5<>0 and hv234a<=1.
+compute nt_ch_micro_iod=0.
+if hv234a=1 nt_ch_micro_iod=1.
end if.
variable labels  nt_ch_micro_iod "Children age 6-59 mos live in hh with iodized salt".
value labels  nt_ch_micro_iod 1 "Yes" 0 "No".

*Received therapeutic food.
do if (age>=6 and age<=35) and b5<>0.
+compute nt_ch_food_ther=0.
+if  h80b=1 nt_ch_food_ther=1.
end if.
variable labels  nt_ch_food_ther "Children age 6-35 mos given therapeutic food".
value labels  nt_ch_food_ther 1 "Yes" 0 "No".

*Received supplemental food.
do if (age>=6 and age<=35) and b5<>0.
+compute nt_ch_food_supp=0.
+if  h80c=1 nt_ch_food_supp=1.
end if.
variable labels  nt_ch_food_supp "Children age 6-35 mos given supplemental food".
value labels  nt_ch_food_supp 1 "Yes" 0 "No".
