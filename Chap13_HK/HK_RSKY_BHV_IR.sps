* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_RSKY_BHV_IR.sps
Purpose: 			Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: November 29, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. 
*					For women the indicators are computed for age 15-49 in line 29. 
*					This can be commented out if the indicators are required for all women or can be changed to select for age 15-24.	
					
*					For the indicator hk_cond_notprtnr, please see the DHS guide to statistics for changes over time.
*					The current code will only match recent surveys. 					
*****************************************************************************************************

*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_2plus	"Have two or more sexual partners in the past 12 months"
hk_sex_notprtnr	"Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"
hk_cond_2plus	"Have two or more sexual partners in the past 12 months and used a condom at last sex"
hk_cond_notprtnr	"Used a condom at last sex with a partner that is not their spouce and does not live with them in the past 12 months"
hk_sexprtnr_mean 	"Mean number of sexual partners"
----------------------------------------------------------------------------.

* indicators from IR file.

* limiting to women age 15-49.
select if v012<=49.

**********************************
*Two or more sexual partners.
compute hk_sex_2plus=0.
if (range(v527,100,251) | range(v527,300,311)) & range(v766b,2,99) hk_sex_2plus=1.
variable labels hk_sex_2plus "Have two or more sexual partners in the past 12 months".
value labels  hk_sex_2plus 0"No" 1"Yes".

*Had sex with a person that was not their partner.
*last partner.
compute risk1=0.
if (range(v527,100,251) | range(v527,300,311)) & (range(v767a,2,6) | any(v767a,8,96)) risk1= 1.
*next-to-last-partner.
compute risk2=0.
if (range(v527,100,251) | range(v527,300,311)) & (range(v767b,2,6) | any(v767b,8,96)) risk2= 1.
*third-to-last-partner.
compute risk3=0.
if (range(v527,100,251) | range(v527,300,311)) & (range(v767c,2,6) | any(v767c,8,96)) risk3= 1.
*combining all partners.
compute hk_sex_notprtnr=(risk1>0|risk2>0|risk3>0).
variable labels hk_sex_notprtnr "Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months".
value labels  hk_sex_notprtnr 0"No" 1"Yes".

*Have two or more sexual partners and used condom at last sex.
do if v766b>=2.
+compute hk_cond_2plus=0.
+if ((range(v527,100,251) | range(v527,300,311)) & range(v766b,2,99) & v761=1) hk_cond_2plus=1.
end if.
variable labels hk_cond_2plus "Have two or more sexual partners in the past 12 months and used a condom at last sex".
value labels  hk_cond_2plus 0"No" 1"Yes".

*Had sex with a person that was not their partner and used condom.
if hk_sex_notprtnr=1 hk_cond_notprtnr=0.
*see risk1, risk2, and risk3 variables above.
if risk1=1 & v761=1 hk_cond_notprtnr=1.
if risk1<>1 & risk2=1 & v761b=1 hk_cond_notprtnr=1.
if risk1<>1 & risk2<>1 & risk3=1 & v761c=1 hk_cond_notprtnr=1.
variable labels hk_cond_notprtnr "Used a condom at last sex with a partner that is not their spouce and does not live with them in the past 12 months".
value labels  hk_cond_notprtnr 0"No" 1"Yes".

*Mean number of sexual partners.
compute fweight=v005.
weight by fweight.
compute filter = range(v836,1,95).
filter by filter.
aggregate outfile = * mode=addvariables overwrite=yes
/hk_sexprtnr_mean=mean(v836).
variable labels hk_sexprtnr_mean "Mean number of sexual partners".
weight off.
filter off.
