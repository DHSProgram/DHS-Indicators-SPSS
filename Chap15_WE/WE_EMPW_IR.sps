* Encoding: windows-1252.
*****************************************************************************************************
Program: 			WE_EMPW_IR.sps
Purpose: 			Code to compute decision making and justification of violence among in men and women
Data inputs: 		IR or MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Oct 19, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women
					For women the indicator is computed for age 15-49 in line 45. This can be commented out if the indicators are required for all women
					The indicators we_decide_all and we_decide_none have different variable labels for men compared to women. 
*****************************************************************************************************

*----------------------------------------------------------------------------
Variables created in this file:
we_decide_health			"Decides on own health care"
we_decide_hhpurch			"Decides on large household purchases"
we_decide_visits			"Decides on visits to family or relatives"
we_decide_health_self	                    	"Decides on own health care either alone or jointly with partner"
we_decide_hhpurch_self    		"Decides on large household purchases either alone or jointly with partner"
we_decide_visits_self                                         "Decides on visits to family or relatives either alone or jointly with partner"
we_decide_all			"Decides on all three: health, purchases, and visits  either alone or jointly with partner" (for women)
				"Decides on both health and purchases either alone or jointly with partner" (for men)
we_decide_none			"Does not decide on any of the three decisions either alone or jointly with partner" (for women)
				"Does not decide on health or purchases either alone or jointly with partner" (for men)
*	
we_dvjustify_burn			"Agree that husband is justified in hitting or beating his wife if she burns food"
we_dvjustify_argue			"Agree that husband is justified in hitting or beating his wife if she argues with him"
we_dvjustify_goout			"Agree that husband is justified in hitting or beating his wife if she goes out without telling him"
we_dvjustify_neglect	                    	"Agree that husband is justified in hitting or beating his wife if she neglects the children"
we_dvjustify_refusesex		                  "Agree that husband is justified in hitting or beating his wife if she refuses to have sexual intercourse with him"
we_dvjustify_onereas            		"Agree that husband is justified in hitting or beating his wife for at least one of the reasons"
*	
we_justify_refusesex    			"Believe a woman is justified to refuse sex with her husband if she knows he's having sex with other women"
we_justify_cond                		"Believe a women is justified in asking that her husband to use a condom if she knows that he has an STI"
we_havesay_refusesex    		"Can say no to their husband if they do not want to have sexual intercourse"
we_havesay_condom			"Can ask their husband to use a condom"
*
we_num_decide			"Number of decisions made either alone or jointly with husband among women currently in a union"
we_num_justifydv			"Number of reasons for which wife beating is justified among women currently in a union"
----------------------------------------------------------------------------*.

* indicators from IR file.
* limiting to women age 15-49.
select if (v012<=49).

*** Deciion making ***

*Decides on own health.
if v502=1 we_decide_health= v743a.
apply dictionary from *
 /source variables = V743A 
 /target variables = we_decide_health.
variable labels we_decide_health "Decides on own health care".

*Decides on household purchases.
if v502=1 we_decide_hhpurch= v743b.
apply dictionary from *
 /source variables = V743B 
 /target variables = we_decide_hhpurch.
variable labels we_decide_hhpurch "Decides on large household purchases".

*Decides on visits.
if v502=1 we_decide_visits= v743d.
apply dictionary from *
 /source variables = V743D 
 /target variables = we_decide_visits.
variable labels we_decide_visits "Decides on visits to family or relatives".

*Decides on own health either alone or jointly.
if v502=1 we_decide_health_self= any(v743a,1,2).
variable labels we_decide_health_self "Decides on own health care either alone or jointly with partner".
value labels we_decide_health_self 0 "No" 1 "Yes".

*Decides on household purchases either alone or jointly.
if v502=1 we_decide_hhpurch_self= any(v743b,1,2).
variable labels we_decide_hhpurch_self "Decides on large household purchases either alone or jointly with partner".
value labels we_decide_hhpurch_self 0 "No" 1 "Yes".

*Decides on visits either alone or jointly.
if v502=1 we_decide_visits_self= any(v743d,1,2).
variable labels we_decide_visits_self "Decides on visits to family or relatives either alone or jointly with partner".
value labels we_decide_visits_self 0 "No" 1 "Yes".

*Decides both health and purchases either alone or jointly.
if v502=1 we_decide_all= any(v743a,1,2) & any(v743b,1,2) & any(v743d,1,2).
variable labels we_decide_all "Decides on both health and purchases either alone or jointly with partner".
value labels we_decide_all 0 "No" 1 "Yes".

*Does not decide on health or purchases.
if v502=1 we_decide_none= 0.
if (v743a<>1 & v743a<>2) & (v743b<>1 & v743b<>2) & (v743d<>1 & v743d<>2)& v502=1 we_decide_none=1.
variable labels we_decide_none "Does not decide on health or purchases either alone or jointly with partner".
value labels we_decide_none 0 "No" 1 "Yes".

*** Justification of violence ***

*Jusity violence - burned food.
compute we_dvjustify_burn= v744e=1.
variable labels we_dvjustify_burn "Agree that husband is justified in hitting or beating his wife if she burns food".
value labels we_dvjustify_burn 0 "No" 1 "Yes".

*Jusity violence - argues.
compute we_dvjustify_argue= v744c=1.
variable labels we_dvjustify_argue "Agree that husband is justified in hitting or beating his wife if she argues with him".
value labels we_dvjustify_argue 0 "No" 1 "Yes".

*Jusity violence - goes out without saying.
compute we_dvjustify_goout= v744a=1.
variable labels we_dvjustify_goout "Agree that husband is justified in hitting or beating his wife if she goes out without telling him".
value labels we_dvjustify_goout 0 "No" 1 "Yes".

*Jusity violence - neglects children .
compute we_dvjustify_neglect= v744b=1.
variable labels we_dvjustify_neglect "Agree that husband is justified in hitting or beating his wife if she neglects the children".
value labels we_dvjustify_neglect 0 "No" 1 "Yes".

*Jusity violence - no sex.
compute we_dvjustify_refusesex= v744d=1.
variable labels we_dvjustify_refusesex "Agree that husband is justified in hitting or beating his wife if she refuses to have sexual intercourse with him".
value labels we_dvjustify_refusesex 0 "No" 1 "Yes".

*Jusity violence - at least one reason.
compute we_dvjustify_onereas=0 .
if v744a=1 | v744b=1 | v744c=1 | v744d=1 | v744e=1 we_dvjustify_onereas=1.
variable labels we_dvjustify_onereas "Agree that husband is justified in hitting or beating his wife for at least one of the reasons".
value labels we_dvjustify_onereas 0 "No" 1 "Yes".
	
*Jusity to reuse sex - he's having sex with another woman.
compute we_justify_refusesex= v633b=1.
variable labels we_justify_refusesex "Believe a woman is justified to refuse sex with her husband if she knows he's having sex with other women".
value labels we_justify_refusesex 0 "No" 1 "Yes".

*Jusity to ask to use condom - he has STI.
compute we_justify_cond= v822=1.
variable labels we_justify_cond "Believe a women is justified in asking that her husband to use a condom if she knows that he has an STI".
value labels we_justify_cond 0 "No" 1 "Yes".

*Can refuse sex with husband.
if v502=1 we_havesay_refusesex= v850a=1.
variable labels we_havesay_refusesex "Can say no to their husband if they do not want to have sexual intercourse".
value labels we_havesay_refusesex 0 "No" 1 "Yes".

*Can ask husband to use condom.
if v502=1 we_havesay_condom= v850b=1.
variable labels we_havesay_condom "Can ask their husband to use a condom".
value labels we_havesay_condom 0 "No" 1 "Yes".

*Number of decisions wife makes alone or jointly.
compute v743a2=0.
if v743a <3 v743a2=1.
compute v743b2=0.
if v743b <3 v743b2=1.
compute v743d2=0.
if v743d <3 v743d2=1.
compute decisions= v743a2+v743b2+v743d2.
do if v502=1.
+recode decisions (0=0) (1,2=1) (3=2)  into we_num_decide.
end if.
variable labels we_num_decide "Number of decisions made either alone or jointly with husband among women currently in a union".
value labels we_num_decide 0 "0" 1 "1-2" 2 "3".

*Number of reasons wife beating is justified.
do repeat x = v744a v744b v744c v744d v744e/y=v744a2 v744b2 v744c2 v744d2 v744e2.
+compute y=0.
+if x=1 y=1.
end repeat.
compute reasons= v744a2 + v744b2 + v744c2 + v744d2 + v744e2.
do if v502=1.
+ recode reasons (0=0) (1,2=1) (3,4=2) (5=3)  into we_num_justifydv.
end if.
variable labels we_num_justifydv "Number of reasons for which wife beating is justified among women currently in a union".
value labels we_num_justifydv 0 "0" 1 "1-2" 2 "3-4" 3 "5".
