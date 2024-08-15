* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_RSKY_BHV_MR.sps
Purpose: 			Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: November 29, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. No age selection is made here.
					
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

*only among men	
hk_paid_sex_ever	"Ever paid for sex among men 15-49"
hk_paid_sex_12mo	"Paid for sex in the past 12 months among men 15-49"
hk_paid_sex_cond	"Used a condom at last paid sexual intercourse in the past 12 months among men 15-49"
----------------------------------------------------------------------------.

* indicators from MR file.

***********************************

*Two or more sexual partners.
compute hk_sex_2plus=0.
if (range(mv527,100,251) | range(mv527,300,311)) & range(mv766b,2,99) hk_sex_2plus=1.
variable labels hk_sex_2plus "Have two or more sexual partners in the past 12 months".
value labels  hk_sex_2plus 0"No" 1"Yes".

*Had sex with a person that was not their partner.
*last partner.
compute risk1=0.
if (range(mv527,100,251) | range(mv527,300,311)) & (range(mv767a,2,6) | any(mv767a,8,96)) risk1=1.
*next-to-last-partner.
compute risk2=0.
if (range(mv527,100,251) | range(mv527,300,311)) & (range(mv767b,2,6) | any(mv767b,8,96)) risk2=1.
*third-to-last-partner.
compute risk3=0.
if  (range(mv527,100,251) | range(mv527,300,311)) & (range(mv767c,2,6) | any(mv767c,8,96)) risk3=1.
*combining all partners.
compute hk_sex_notprtnr=(risk1>0|risk2>0|risk3>0).
variable labels hk_sex_notprtnr "Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months".
value labels  hk_sex_notprtnr 0"No" 1"Yes".

*Have two or more sexual partners and used condom at last sex.
do if mv766b>=2.
+compute hk_cond_2plus=0.
+if (range(mv527,100,251) | range(mv527,300,311)) & range(mv766b,2,99) & mv761=1 hk_cond_2plus=1.
end if.
variable labels hk_cond_2plus "Have two or more sexual partners in the past 12 months and used a condom at last sex".
value labels  hk_cond_2plus 0"No" 1"Yes".

*Had sex with a person that was not their partner and used condom.
if hk_sex_notprtnr=1 hk_cond_notprtnr=0.
*see risk1, risk2, and risk3 variables above.
if risk1=1 & mv761=1 hk_cond_notprtnr=1.
if risk1<>1 & risk2=1 & mv761b=1 hk_cond_notprtnr=1.
if risk1<>1 & risk2<>1 & risk3=1 & mv761c=1 hk_cond_notprtnr=1.
variable labels hk_cond_notprtnr "Used a condom at last sex with a partner that is not their spouse and does not live with them in the past 12 months".
value labels  hk_cond_notprtnr 0"No" 1"Yes".

*Mean number of sexual partners.
compute fweight=mv005.
weight by fweight.
compute filter = range(mv836,1,95).
filter by filter.
aggregate outfile = * mode=addvariables overwrite=yes
/hk_sexprtnr_mean=mean(mv836).
variable labels hk_sexprtnr_mean "Mean number of sexual partners".
weight off.
filter off.

*Ever paid for sex.
compute hk_paid_sex_ever=0.
if  mv791=1 hk_paid_sex_ever=1.
variable labels hk_paid_sex_ever "Ever paid for sex among men 15-49".
value labels  hk_paid_sex_ever 0"No" 1"Yes".

*Paid for sex in the last 12 months.
compute hk_paid_sex_12mo=0.
if mv793=1 hk_paid_sex_12mo=1.
variable labels hk_paid_sex_12mo "Paid for sex in the past 12 months among men 15-49".
value labels  hk_paid_sex_12mo 0"No" 1"Yes".

*Used a condom at last paid sex in the last 12 months.
if mv793=1 hk_paid_sex_cond= 0.
if mv793a=1 hk_paid_sex_cond= 1.
variable labels hk_paid_sex_cond "Used a condom at last paid sexual intercourse in the past 12 months among men 15-49".
value labels  hk_paid_sex_cond 0"No" 1"Yes".
