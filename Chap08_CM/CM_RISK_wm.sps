* Encoding: UTF-8.
*****************************************************************************************************
Program: 			CM_RISK_wm.sps
Purpose: 			Code to compute high risk birth in women
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:			Shireen Assaf and Thomas Pullum, and translated to SPSS by Ivana Bjelic
Date last modified:                           September 23 2019 by Ivana Bjelic
Note:				
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
cm_riskw_none		"Currently married women not in any high-risk category"
cm_riskw_unavoid		"Currently married women with unavoidable risk- first order birth between age 18 and 34"
cm_riskw_any_avoid		"Currently married women in any avoidable high-risk category"
*	
cm_riskw_u18		"Currently married women less than 18 years"
cm_riskw_o34		"Currently married women over 34 years"
cm_riskw_interval		"Currently married women with <24mos since preceding birth"
cm_riskw_order		"Currently married women with a birth order 4 or higher"
cm_riskw_any_single		"Currently married women in any single high-risk category"
*
cm_riskw_mult1		"Currently married women with multiple risks - under age 18 and short interval"
cm_riskw_mult2		"Currently married women with multiple risks - over age 34 and short interval"
cm_riskw_mult3		"Currently married women with multiple risks - over age 34 and high order"
cm_riskw_mult4		"Currently married women with multiple risks - over age 34 and short interval and high order"
cm_riskw_mult5		"Currently married women with multiple risks - short interval and high order"
cm_riskw_any_mult		"Currently married women in any multiple risk category"
*
cm_riskw_u18_avoid		"Currently married women with individual avoidable risk - less than 18 years"
cm_riskw_o34_avoid		"Currently married women with individual avoidable risk - over 34 years"
cm_riskw_interval_avoid	                  "Currently married women with individual avoidable risk - <24mos since preceding birth"
cm_riskw_order_avoid	                  "Currently married women with individual avoidable risk - birth order 4 or higher"
----------------------------------------------------------------------------*.

*** Indicators are computed for currently married women ***.
select if v502=1.

* woman's age.
compute age_of_mother=(v008-v011).

*** Single risk categories, initial definition ***

* Four basic criteria.
compute young=0.
compute old=0.
compute soon=0.
compute many=0.
compute firstbirth=0.

* Women are assigned risk categories according to the status they would have at the birth of a child if they were to conceive at the time of the survey.
* Sterilzed women (v312=6) have no risk.
if age_of_mother<((17*12)+3) & (v312<>6)     young=1.
if age_of_mother>((34*12)+2) & (v312<>6)     old=1.
if (v222<15) & (v312<>6)                              soon=1.
if (v201>2) & (v312<>6)                                many=1.	
if (v201=0) & (v312<>6)                                firstbirth=1.

*Currently married women with unavoidable risk- first birth order and mother age 18 and 34.
compute cm_riskw_unavoid=0.
if firstbirth=1 & young=0 & old=0 & soon=0 & many=0 cm_riskw_unavoid=1.
variable labels cm_riskw_unavoid "Currently married women with unavoidable risk - first order birth between age 18 and 34".

*Birth risks - under 18.
compute cm_riskw_u18=0 .
if young=1 & old=0 & soon=0 & many=0 cm_riskw_u18=1.
variable labels cm_riskw_u18 "Currently married women less than 18 years".

*Birth risks - over 34.
compute cm_riskw_o34=0.
if young=0 & old=1 & soon=0 & many=0  cm_riskw_o34=1.
variable labels cm_riskw_o34 "Currently married women over 34 years".

*Birth risk - interval <24months.
compute cm_riskw_interval=0.
if young=0 & old=0 & soon=1 & many=0 cm_riskw_interval=1.
variable labels cm_riskw_interval "Currently married women with <24mos since preceding birth".

*Birth risk - birth order of 4 or more.
compute cm_riskw_order=0.
if young=0 & old=0 & soon=0 & many=1 cm_riskw_order=1.
variable labels cm_riskw_order "Currently married women with a birth order 4 or higher".

*Any single high-risk category.
compute cm_riskw_any_single=0.
if cm_riskw_u18+cm_riskw_o34+cm_riskw_interval+cm_riskw_order>0 cm_riskw_any_single=1.
variable labels cm_riskw_any_single "Currently married women in any single high-risk category".


*** Construct the five multiple-risk categories ***

*Birth risk - too young and short interval.
compute cm_riskw_mult1=0.
if young=1 & old=0 & soon=1 & many=0 cm_riskw_mult1=1.
if young=1 & old=0 & soon=0 & many=1 cm_riskw_mult1=1.
if young=1 & old=0 & soon=1 & many=1 cm_riskw_mult1=1.
variable labels cm_riskw_mult1 "Currently married women with multiple risks - under age 18 and short interval".

*Birth risk - older and short interval.
compute cm_riskw_mult2=0.
if young=0 & old=1 & soon=1 & many=0 cm_riskw_mult2=1.
variable labels cm_riskw_mult2 "Currently married women with multiple risks - over age 34 and short interval".

*Birth risk - older and high birth order.
compute cm_riskw_mult3=0.
if young=0 & old=1 & soon=0 & many=1 cm_riskw_mult3=1.
variable labels cm_riskw_mult3 "Currently married women with multiple risks - over age 34 and high order".

*Birth risk - older and short interval and high birth order.
compute cm_riskw_mult4=0.
if young=0 & old=1 & soon=1 & many=1 cm_riskw_mult4=1.
variable labels cm_riskw_mult4 "Currently married women with multiple risks - over age 34 and short interval and high order".

*Birth risk - short interval and high birth order.
compute cm_riskw_mult5=0.
if young=0 & old=0 & soon=1 & many=1 cm_riskw_mult5=1.
variable labels cm_riskw_mult5 "Currently married women with multiple risks - short interval and high order".

*Any multiple risk.
compute cm_riskw_any_mult=0.
if cm_riskw_mult1+cm_riskw_mult2+cm_riskw_mult3+cm_riskw_mult4+cm_riskw_mult5 >0 cm_riskw_any_mult=1.
variable labels cm_riskw_any_mult "Currently married women in any multiple risk category".

*Any avoidable risk.
compute cm_riskw_any_avoid=0.
if cm_riskw_any_single+cm_riskw_any_mult>0 cm_riskw_any_avoid=1.
variable labels cm_riskw_any_avoid "Currently married women in any avoidable high-risk category".

*No risk.
compute cm_riskw_none=0.
if cm_riskw_unavoid=0 & cm_riskw_any_avoid=0 & firstbirth=0 cm_riskw_none=1.
variable labels cm_riskw_none "Currently married women not in any high-risk category".

*** Individual avoidable high risk category ***

*Avoidable birth risk - under 18.
compute  cm_riskw_u18_avoid=young.
variable labels cm_riskw_u18_avoid "Currently married women with individual avoidable risk - mothers less than 18 years".

*Avoidable birth risks - over 34.
compute cm_riskw_o34_avoid=old.
variable labels cm_riskw_o34_avoid "Currently married women with individual avoidable risk - mothers over 34 years".

*Avoidable birth risk - interval <24months.
compute cm_riskw_interval_avoid=soon.
variable labels cm_riskw_interval_avoid "Currently married women with individual avoidable risk - born <24mos since preceding birth".

*Avoidable birth risk - birth order of 4 or more.
compute cm_riskw_order_avoid=many.
variable labels cm_riskw_order_avoid "Currently married women with individual avoidable risk - birth order 4 or higher".
