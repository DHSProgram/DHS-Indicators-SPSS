* Encoding: windows-1252.
*****************************************************************************************************
Program: 			WE_ASSETS_MR.sps
Purpose: 			Code to compute employment, earnings, and asset ownership in men and women
Data inputs: 		MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Oct 19, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. 
*					For men the indicator is computed for age 15-49 in line 33. This can be commented out if the indicators are required for all men.
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

* indicators from MR file

* limiting to men age 15-49.
select if (mv012<=49).

*** Employment and earnings ***

*Employment in the last 12 months.
do if mv502=1.
+recode mv731 (0=0) (1 thru 3=1) (8,9=sysmis) into we_empl.
end if.
variable labels we_empl "Employment status in the last 12 months among those currently in a union".
value labels we_empl 0 "No" 1 "Yes".

*Employment by type of earnings.
if any(mv731,1,2,3) & mv502=1 we_empl_earn=mv741.
apply dictionary from *
 /source variables = MV741 
 /target variables = we_empl_earn.
variable labels we_empl_earn "Type of earnings among those employed in the past 12 months and currently in a union".

*Who decides on how husband's cash earnings are used.
do if any(mv731,1,2,3) & any(mv741,1,2) & mv502=1.
+compute we_earn_mn_decide=mv739.
+if mv739=8 we_earn_mn_decide=9.
end if.
add value labels mv739 9"Don't know/Missing".
apply dictionary from *
 /source variables = MV739 
 /target variables = we_earn_mn_decide.
variable labels we_earn_mn_decide "Who descides on husband's cash earnings for employment in the last 12 months among men currently in a union".

*** Ownership of assets ***

*Own a house.
compute we_own_house = mv745a.
apply dictionary from *
 /source variables = MV745A 
 /target variables = we_own_house.
variable labels we_own_house "Ownership of housing".

*Own land.
compute we_own_land = mv745b.
apply dictionary from *
 /source variables = MV745B 
 /target variables = we_own_land.
variable labels we_own_land "Ownership of land".

*Ownership of house deed.
do if any(mv745a,1,2,3).
+recode mv745c (1=1) (2=2) (0=0) (3,8,9=9) into we_house_deed.
end if.
variable labels we_house_deed "Title or deed possesion for owned house".
value labels we_house_deed
0 "Does not have title/deed"
1 "Respondent's name on title/deed"
2 "Respondent's name is not on title/deed"
9 "Don't know/missing".

*Ownership of land deed.
do if any(mv745b,1,2,3).
+recode mv745d (1=1) (2=2) (0=0) (3,8,9=9) into we_land_deed.
end if.
variable labels we_land_deed "Title or deed possesion for owned land".
value labels we_land_deed
0 "Does not have title/deed"
1 "Respondent's name on title/deed"
2 "Respondent's name is not on title/deed"
9 "Don't know/missing".

*Own a bank account.
compute we_bank=mv170.
if mv170=8 | mv170=9 we_bank=0.
variable labels we_bank "Use an account in a bank or other financial institution".
value labels we_bank 0 "No" 1 "Yes".

*Own a mobile phone.
compute we_mobile=mv169a.
if mv169a=8 | mv169a=9 we_mobile=0.
variable labels we_mobile "Own a mobile phone".
value labels we_mobile 0 "No" 1 "Yes".

*Use mobile for finances.
do if (mv169a<>8 & mv169a<>9).
+if mv169a=1 we_mobile_finance=mv169b.
+if mv169b=8 | mv169b=9 we_mobile_finance=0.
end if.
variable labels we_mobile_finance "Use mobile phone for financial transactions".
value labels we_mobile_finance 0 "No" 1 "Yes".

