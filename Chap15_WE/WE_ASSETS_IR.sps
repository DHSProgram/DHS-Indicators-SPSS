* Encoding: windows-1252.
*****************************************************************************************************
Program: 			WE_ASSETS_IR.sps
Purpose: 			Code to compute employment, earnings, and asset ownership in men and women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Oct 19, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. 
*					For women the indicator is computed for age 15-49 in line 33. This can be commented out if the indicators are required for all women.
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
we_empl			"Employment status in the last 12 months among those currently in a union"
we_empl_earn		"Type of earnings among those employed in the past 12 months and currently in a union"
we_earn_wm_decide        	"Who descides on wife's cash earnings for employment in the last 12 months"
we_earn_wm_compare    	"Comparison of cash earnings with husband's cash earnings"
we_earn_mn_decide        	"Who descides on husband's cash earnings for employment in the last 12 months among men currently in a union"
we_earn_hs_decide        	"Who descides on husband's cash earnings for employment in the last 12 months among women currently in a union"
we_own_house		"Ownership of housing"
we_own_land    		"Ownership of land"
we_house_deed		"Title or deed possesion for owned house"
we_land_deed		"Title or deed possesion for owned land"
we_bank			"Use an account in a bank or other financial institution"
we_mobile			"Own a mobile phone"
we_mobile_finance            	"Use mobile phone for financial transactions"
----------------------------------------------------------------------------.

* indicators from IR file.

*** Employment and earnings ***

*Employment in the last 12 months.
do if v502=1.
+recode v731 (0=0) (1 thru 3=1) (8,9=sysmis) into we_empl.
end if.
variable labels we_empl "Employment status in the last 12 months among those currently in a union".
value labels we_empl 0 "No" 1 "Yes".

*Employment by type of earnings.
if any(v731,1,2,3) & v502=1 we_empl_earn=v741.
apply dictionary from *
 /source variables = V741 
 /target variables = we_empl_earn.
variable labels we_empl_earn "Type of earnings among those employed in the past 12 months and currently in a union".

*Control over earnings.
if any(v731,1,2,3) & any(v741,1,2) & v502=1 we_earn_wm_decide=v739.
apply dictionary from *
 /source variables = V739 
 /target variables = we_earn_wm_decide.
variable labels we_earn_wm_decide "Who descides on wife's cash earnings for employment in the last 12 months".

*Comparison of earnings with husband/partner.
if any(v731,1,2,3) & any(v741,1,2) & v502=1 we_earn_wm_compare=v746.
if v743f=7 & not sysmis(v746) & v502=1 we_earn_wm_compare=4 .
apply dictionary from *
 /source variables = V746 
 /target variables = we_earn_wm_compare.
variable labels we_earn_wm_compare "Comparison of cash earnings with husband's cash earnings".

*Who decides on how husband's cash earnings are used.
if v746<>4 & v743f<>7 & v502=1 we_earn_hs_decide=v743f.
if v743f=8 we_earn_hs_decide=9.
add value labels v743f 9"Don't know/Missing".
apply dictionary from *
 /source variables = V743F 
 /target variables = we_earn_hs_decide.
variable labels we_earn_hs_decide	"Who descides on husband's cash earnings for employment in the last 12 months among women currently in a union".

*** Ownership of assets ***

*Own a house.
compute we_own_house = v745a.
apply dictionary from *
 /source variables = V745A 
 /target variables = we_own_house.
variable labels we_own_house "Ownership of housing".

*Own land.
compute we_own_land = v745b.
apply dictionary from *
 /source variables = V745B 
 /target variables = we_own_land.
variable labels we_own_land "Ownership of land".

*Ownership of house deed.
do if any(v745a,1,2,3).
+recode v745c (1=1) (2=2) (0=0) (3,8,9=9) into we_house_deed.
end if.
variable labels we_house_deed "Title or deed possesion for owned house".
value labels we_house_deed
0 "Does not have title/deed"
1 "Respondent's name on title/deed"
2 "Respondent's name is not on title/deed"
9 "Don't know/missing".

*Ownership of land deed.
do if any(v745b,1,2,3).
+recode v745d (1=1) (2=2) (0=0) (3,8,9=9) into we_land_deed.
end if.
variable labels we_land_deed "Title or deed possesion for owned land".
value labels we_land_deed
0 "Does not have title/deed"
1 "Respondent's name on title/deed"
2 "Respondent's name is not on title/deed"
9 "Don't know/missing".

*Own a bank account.
compute we_bank=v170.
if v170=8 | v170=9 we_bank=0.
variable labels we_bank "Use an account in a bank or other financial institution".
value labels we_bank 0 "No" 1 "Yes".

*Own a mobile phone.
compute we_mobile=v169a.
if v169a=8 | v169a=9 we_mobile=0.
variable labels we_mobile "Own a mobile phone".
value labels we_mobile 0 "No" 1 "Yes".

*Use mobile for finances.
do if (v169a<>8 & v169a<>9).
+if v169a=1 we_mobile_finance=v169b.
+if v169b=8 | v169b=9 we_mobile_finance=0.
end if.
variable labels we_mobile_finance "Use mobile phone for financial transactions".
value labels we_mobile_finance 0 "No" 1 "Yes".
