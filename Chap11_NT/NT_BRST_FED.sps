* Encoding: windows-1252.
****************************************************************************************************
Program: 			NT_BRST_FED.sps
Purpose: 			Code to compute breastfeeding indicators
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: May 16 2020 by Ivana Bjelic
Note:				
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*nt_bf_ever			"Ever breastfed - last-born in the past 2 years".
*nt_bf_start_1hr		"Started breastfeeding within one hour of birth - last-born in the past 2 years".
*nt_bf_start_1day            	"Started breastfeeding within one day of birth - last-born in the past 2 years".
*nt_bf_prelac		"Received a prelacteal feed - last-born in the past 2 years ever breast fed".

*nt_bottle			"Drank from a bottle with a nipple yesterday - under 2 years".

*nt_med_any_bf		"Median duration in months of breastfeeding for any breastfeeding - born last 3yrs".
*nt_med_ebf		"Median duration in months of breastfeeding for exclusive breastfeed - born last 3yrs".
*nt_med_predo_bf		"Median duration in months of breastfeeding for predominant breastfeeding - born last 3yrs".
*nt_mean_any_bf		"Mean duration in months of breastfeeding for any breastfeeding - born last 3yrs".
*nt_mean_any_bf		"Mean duration in months of breastfeeding for any breastfeeding - born last 3yrs".
*nt_mean_any_bf		"Mean duration in months of breastfeeding for any breastfeeding - born last 3yrs".

*----------------------------------------------------------------------------.

*** Initial breastfeeding ***

*Ever breastfed.
do if (midx=1 & age<24).
+compute nt_bf_ever=0.
+if  (m4<>94 & m4<>99) nt_bf_ever=1.
end if.
variable labels nt_bf_ever "Ever breastfed - last-born in the past 2 years".
value labels nt_bf_ever 1 "Yes" 0 "No".

*Start breastfeeding within 1 hr.
do if (midx=1 & age<24).
+compute nt_bf_start_1hr=0.
+if  (m4<>94 & m4<>99) & (range(m34,0,100)) nt_bf_start_1hr=1.
end if.
variable labels nt_bf_start_1hr "Started breastfeeding within one hour of birth - last-born in the past 2 years".
value labels nt_bf_start_1hr 1 "Yes" 0 "No".

*Start breastfeeding within 1 day.
do if (midx=1 & age<24).
+compute nt_bf_start_1day=0.
+if (m4<>94 & m4<>99) & (range(m34,0,123)) nt_bf_start_1day=1.
end if.
variable labels nt_bf_start_1day "Started breastfeeding within one day of birth - last-born in the past 2 years".
value labels nt_bf_start_1day  1 "Yes" 0 "No".

*Given prelacteal feed.
do if (midx=1 & age<24 & m4<>94 & m4<>99).
+compute nt_bf_prelac=0.
+if (m4<>94 & m4<>99) & m55=1 nt_bf_prelac=1. 
end if.
variable labels nt_bf_prelac "Received a prelacteal feed - last-born in the past 2 years ever breast fed".
value labels nt_bf_prelac 1 "Yes" 0 "No".

*using bottle with nipple.
do if (b5=1 & age<24).
+compute nt_bottle=0.
+if m38=1 nt_bottle=1.
end if.
variable labels nt_bottle "Drank from a bottle with a nipple yesterday - under 2 years".
value labels nt_bottle 1 "Yes" 0 "No".


*** Medians and Means for breastfeeding durations *** 

/* Tom to provide code for this part * - To be completed.
*nt_med_any_bf		"Median duration in months of breastfeeding for any breastfeeding - born last 3yrs".
*nt_med_ebf		"Median duration in months of breastfeeding for exclusive breastfeed - born last 3yrs".
*nt_med_predo_bf		"Median duration in months of breastfeeding for predominant breastfeeding - born last 3yrs".
*nt_mean_any_bf		"Mean duration in months of breastfeeding for any breastfeeding - born last 3yrs".
*nt_mean_any_bf		"Mean duration in months of breastfeeding for any breastfeeding - born last 3yrs".
*nt_mean_any_bf		"Mean duration in months of breastfeeding for any breastfeeding - born last 3yrs".

*/.

****************************************************************.

