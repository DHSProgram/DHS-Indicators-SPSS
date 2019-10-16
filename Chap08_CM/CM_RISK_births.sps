* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CM_RISK_birth.sps
Purpose: 			Code to compute high risk births
Data inputs: 		BR survey list
Data outputs:		coded variables
Author:				Thomas Pullum and modified by Shireen Assaf for the code share project
Date last modified: September 30 2019 by Ivana Bjelic
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
cm_riskb_none		"Births not in any high risk category"
cm_riskb_unavoid		"Births with unavoidable risk- first order birth between age 18 and 34"
cm_riskb_any_avoid		"Births in any avoidable high-risk category"
*	
cm_riskb_u18		"Births to mothers less than 18 years"
cm_riskb_o34		"Births to mothers over 34 years"
cm_riskb_interval		"Births born <24mos since preceding birth"
cm_riskb_order		"Births with a birth order 4 or higher"
cm_riskb_any_single		"Birth with any single high-risk category"
*
cm_riskb_mult1		"Births with multiple risks - under age 18 and short interval"
cm_riskb_mult2		"Births with multiple risks - over age 34 and short interval"
cm_riskb_mult3		"Births with multiple risks - over age 34 and high order"
cm_riskb_mult4		"Births with multiple risks - over age 34 and short interval and high order"
cm_riskb_mult5		"Births with multiple risks - short interval and high order"
cm_riskb_any_mult		"Births with any multiple risk category"
*
cm_riskb_u18_avoid		"Births with individual avoidable risk - mothers less than 18 years"
cm_riskb_o34_avoid		"Births with individual avoidable risk - mothers over 34 years"
cm_riskb_interval_avoid	                  "Births with individual avoidable risk - born <24mos since preceding birth"
cm_riskb_order_avoid            	"Births with individual avoidable risk - birth order 4 or higher"
----------------------------------------------------------------------------.

*** Percentage of births among birth in the last 5 years ***.

* mother's age.
compute age_of_mother=trunc((b3-v011)/12).

* Adjustment for multiple births to give the same order as that of the first in multiples;
* b0 is sequence in the multiple birth if part of a multiple birth; b0=0 if not a multiple birth;
* only shift the second (or later) birth within a multiple birth.
compute bord_adj=bord.
if b0>1 bord_adj=bord-b0+1.

*** Single risk categories, initial definition ***

* Four basic criteria.
compute young=0.
compute old=0.
compute soon=0.
compute many=0.

if age_of_mother<18 young=1.
if age_of_mother>34 old=1.
if b11<24 soon=1.
if bord_adj>3 many=1.

*Births with unavoidable risk- first birth order and mother age 18 and 34.
compute cm_riskb_unavoid=0.
if bord_adj=1 & young=0 & old=0 cm_riskb_unavoid=1.
variable labels cm_riskb_unavoid "Births with unavoidable risk- first order birth between age 18 and 34".

*Birth risks - under 18.
compute cm_riskb_u18=0.
if young=1 & old=0 & soon=0 & many=0 cm_riskb_u18=1.
variable labels cm_riskb_u18 "Births to mothers less than 18 years".

*Birth risks - over 34.
compute cm_riskb_o34=0.
if young=0 & old=1 & soon=0 & many=0 cm_riskb_o34=1.
variable labels cm_riskb_o34 "Births to mothers over 34 years".

*Birth risk - interval <24months.
compute cm_riskb_interval=0.
if young=0 & old=0 & soon=1 & many=0 cm_riskb_interval=1.
variable labels cm_riskb_interval "Births born <24mos since preceding birth".

*Birth risk - birth order of 4 or more.
compute cm_riskb_order=0.
if young=0 & old=0 & soon=0 & many=1 cm_riskb_order=1.
variable labels cm_riskb_order "Births with a birth order 4 or higher".

*Any single high-risk category.
compute cm_riskb_any_single=0.
if cm_riskb_u18+cm_riskb_o34+cm_riskb_interval+cm_riskb_order>0 cm_riskb_any_single=1.
variable labels cm_riskb_any_single "Birth with any single high-risk category".

*** Construct the five multiple-risk categories ***

*Birth risk - mother too young and short interval.
compute cm_riskb_mult1=0.
if young=1 & old=0 & soon=1 & many=0 cm_riskb_mult1=1. 
if young=1 & old=0 & soon=0 & many=1 cm_riskb_mult1=1.
if young=1 & old=0 & soon=1 & many=1 cm_riskb_mult1=1.
variable labels cm_riskb_mult1 "Births with multiple risks - under age 18 and short interval".

*Birth risk - mother older and short interval.
compute cm_riskb_mult2=0.
if young=0 & old=1 & soon=1 & many=0 cm_riskb_mult2=1.
variable labels cm_riskb_mult2 "Births with multiple risks - over age 34 and short interval".

*Birth risk - mother older and high birth order.
compute cm_riskb_mult3=0.
if young=0 & old=1 & soon=0 & many=1 cm_riskb_mult3=1.
variable labels cm_riskb_mult3 "Births with multiple risks - over age 34 and high order".

*Birth risk - mother older and short interval and high birth order.
compute cm_riskb_mult4=0.
if young=0 & old=1 & soon=1 & many=1 cm_riskb_mult4=1.
variable labels cm_riskb_mult4 "Births with multiple risks - over age 34 and short interval and high order".

*Birth risk - short interval and high birth order.
compute cm_riskb_mult5=0.
if young=0 & old=0 & soon=1 & many=1 cm_riskb_mult5=1.
variable labels cm_riskb_mult5 "Births with multiple risks - short interval and high order".

*Any multiple risk.
compute cm_riskb_any_mult=0.
if cm_riskb_mult1+cm_riskb_mult2+cm_riskb_mult3+cm_riskb_mult4+cm_riskb_mult5 >0 cm_riskb_any_mult=1.
variable labels cm_riskb_any_mult "Births with any multiple risk category".

*Any avoidable risk.
compute cm_riskb_any_avoid=0.
if cm_riskb_any_single+cm_riskb_any_mult>0 cm_riskb_any_avoid=1.
variable labels cm_riskb_any_avoid "Births in any avoidable high-risk category".

*No risk.
compute cm_riskb_none=0.
if cm_riskb_unavoid=0 & cm_riskb_any_avoid=0 cm_riskb_none=1.
variable labels cm_riskb_none "Births not in any high risk category".

*** Individual avoidable high risk category ***

*Avoidable birth risk - under 18.
compute  cm_riskb_u18_avoid=young.
variable labels cm_riskb_u18_avoid "Births with individual avoidable risk - mothers less than 18 years".

*Avoidable birth risks - over 34.
compute cm_riskb_o34_avoid=old.
variable labels cm_riskb_o34_avoid "Births with individual avoidable risk - mothers over 34 years".

*Avoidable birth risk - interval <24months.
compute cm_riskb_interval_avoid=soon.
variable labels cm_riskb_interval_avoid "Births with individual avoidable risk - born <24mos since preceding birth".

*Avoidable birth risk - birth order of 4 or more.
compute cm_riskb_order_avoid=many.
variable labels cm_riskb_order_avoid "Births with individual avoidable risk - birth order 4 or higher".

* compute iweight=v005/1000000.
* weight by iweight.
* descriptives variables = cm_riskb_unavoid to cm_riskb_order_avoid
/statistics = mean.
* weight off.

save outfile = datapath + "\cm_risk_births.sav".
get file = datapath + "\cm_risk_births.sav".

******************************************************************************

*** Risk ratios among births in the last 5 years ***.

compute iweight=v005/1000000.
weight by iweight.

* obtain the proportion of no risks for the denominator.
aggregate outfile = datapath + "\temp.sav" 
/break = b5
/cm_riskb_unavoidc =sum(cm_riskb_unavoid)
/cm_riskb_u18c=sum(cm_riskb_u18)
/cm_riskb_o34c=sum(cm_riskb_o34)
/cm_riskb_intervalc=sum(cm_riskb_interval)
/cm_riskb_orderc=sum(cm_riskb_order)
/cm_riskb_any_singlec=sum(cm_riskb_any_single)
/cm_riskb_mult1c=sum(cm_riskb_mult1)
/cm_riskb_mult2c=sum(cm_riskb_mult2)
/cm_riskb_mult3c=sum(cm_riskb_mult3)
/cm_riskb_mult4c=sum(cm_riskb_mult4)
/cm_riskb_mult5c=sum(cm_riskb_mult5)
/cm_riskb_any_multc=sum(cm_riskb_any_mult)
/cm_riskb_any_avoidc=sum(cm_riskb_any_avoid)
/cm_riskb_nonec=sum(cm_riskb_none)
/cm_riskb_u18_avoidc=sum(cm_riskb_u18_avoid)
/cm_riskb_o34_avoidc=sum(cm_riskb_o34_avoid)
/cm_riskb_interval_avoidc=sum(cm_riskb_interval_avoid)
/cm_riskb_order_avoidc=sum(cm_riskb_order_avoid).

get file = datapath + "\temp.sav".
flip variables B5 cm_riskb_unavoidc cm_riskb_u18c cm_riskb_o34c cm_riskb_intervalc cm_riskb_orderc 
    cm_riskb_any_singlec cm_riskb_mult1c cm_riskb_mult2c cm_riskb_mult3c cm_riskb_mult4c 
    cm_riskb_mult5c cm_riskb_any_multc cm_riskb_any_avoidc cm_riskb_nonec cm_riskb_u18_avoidc 
    cm_riskb_o34_avoidc cm_riskb_interval_avoidc cm_riskb_order_avoidc.

save outfile = datapath + "\temp.sav".

compute total=var001+var002.
compute propb5=var001/total.

if case_lbl="cm_riskb_nonec" denom=propb5.

aggregate outfile=* mode=addvariables overwrite=yes
/break=
/denom=mean(denom).

* for each varaible divide the proportion in the risk category (the numerator) by the denomiator above. 
compute rr=propb5/denom.
variable labels rr "Risk ratio".

if (case_lbl="cm_riskb_unavoidc") cat= 1.
if (case_lbl="cm_riskb_u18c") cat= 2.
if (case_lbl="cm_riskb_o34c") cat= 3.
if (case_lbl="cm_riskb_intervalc") cat= 4.
if (case_lbl="cm_riskb_orderc") cat= 5.
if (case_lbl="cm_riskb_any_singlec") cat= 6.
if (case_lbl="cm_riskb_mult1c") cat= 7.
if (case_lbl="cm_riskb_mult2c") cat= 8.
if (case_lbl="cm_riskb_mult3c") cat= 9.
if (case_lbl="cm_riskb_mult4c") cat= 10.
if (case_lbl="cm_riskb_mult5c") cat= 11.
if (case_lbl="cm_riskb_any_multc") cat= 12.
if (case_lbl="cm_riskb_any_avoidc") cat= 13.
if (case_lbl="cm_riskb_nonec") cat= 14.
if (case_lbl="cm_riskb_u18_avoidc") cat= 15.
if (case_lbl="cm_riskb_o34_avoidc") cat= 16.
if (case_lbl="cm_riskb_interval_avoidc") cat= 17.
if (case_lbl="cm_riskb_order_avoidc") cat= 18.
value labels cat
1 "Births with unavoidable risk- first order birth between age 18 and 34"
2 "Births to mothers less than 18 years"
3 "Births to mothers over 34 years"
4 "Births born <24mos since preceding birth"
5 "Births with a birth order 4 or higher"
6 "Birth with any single high-risk category"
7 "Births with multiple risks - under age 18 and short interval"
8 "Births with multiple risks - over age 34 and short interval"
9 "Births with multiple risks - over age 34 and high order"
10 "Births with multiple risks - over age 34 and short interval and high order"
11 "Births with multiple risks - short interval and high order"
12 "Births with any multiple risk category"
13 "Births in any avoidable high-risk category"
14 "Births not in any high risk category"
15 "Births with individual avoidable risk - mothers less than 18 years"
16 "Births with individual avoidable risk - mothers over 34 years"
17 "Births with individual avoidable risk - born <24mos since preceding birth"
18 "Births with individual avoidable risk - birth order 4 or higher".

select if CASE_LBL<>"B5".
save outfile = datapath + "\temp.sav".

