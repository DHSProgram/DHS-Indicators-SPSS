* Encoding: windows-1252.
*****************************************************************************************************
Program: 			WE_EMPW_MR.sps
Purpose: 			Code to compute decision making and justification of violence among in men and women
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Oct 19, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women
					The indicators we_decide_all and we_decide_none have different variable labels for men compared to women. 
*****************************************************************************************************

*----------------------------------------------------------------------------
Variables created in this file:
we_decide_health			"Decides on own health care"
we_decide_hhpurch			"Decides on large household purchases"
we_decide_visits			"Decides on visits to family or relatives"
we_decide_health_self	 "Decides on own health care either alone or jointly with partner"
we_decide_hhpurch_self    		"Decides on large household purchases either alone or jointly with partner"
we_decide_visits_self     "Decides on visits to family or relatives either alone or jointly with partner"
we_decide_all			"Decides on all three: health, purchases, and visits  either alone or jointly with partner" (for women)
				"Decides on both health and purchases either alone or jointly with partner" (for men)
we_decide_none			"Does not decide on any of the three decisions either alone or jointly with partner" (for women)
				"Does not decide on health or purchases either alone or jointly with partner" (for men)
*	
we_dvjustify_burn			"Agree that husband is justified in hitting or beating his wife if she burns food"
we_dvjustify_argue			"Agree that husband is justified in hitting or beating his wife if she argues with him"
we_dvjustify_goout			"Agree that husband is justified in hitting or beating his wife if she goes out without telling him"
we_dvjustify_neglect	  "Agree that husband is justified in hitting or beating his wife if she neglects the children"
we_dvjustify_refusesex		 "Agree that husband is justified in hitting or beating his wife if she refuses to have sexual intercourse with him"
we_dvjustify_onereas  "Agree that husband is justified in hitting or beating his wife for at least one of the reasons"
*	
we_justify_refusesex  "Believe a woman is justified to refuse sex with her husband if she knows he's having sex with other women"
we_justify_cond    "Believe a women is justified in asking that her husband to use a condom if she knows that he has an STI"
we_havesay_refusesex  "Can say no to their husband if they do not want to have sexual intercourse"
we_havesay_condom			"Can ask their husband to use a condom"
*
we_num_decide			"Number of decisions made either alone or jointly with husband among women currently in a union"
we_num_justifydv			"Number of reasons for which wife beating is justified among women currently in a union"
----------------------------------------------------------------------------*.

* indicators from MR file.

*** Decision making ***

*Decides on own health.
if mv502=1 we_decide_health= mv743a.
apply dictionary from *
 /source variables = MV743A 
 /target variables = we_decide_health.
variable labels we_decide_health "Decides on own health care".

*Decides on household purchases.
if mv502=1 we_decide_hhpurch= mv743b.
apply dictionary from *
 /source variables = MV743B 
 /target variables = we_decide_hhpurch.
variable labels we_decide_hhpurch "Decides on large household purchases".

*Decides on visits.
if mv502=1 we_decide_visits= mv743d.
apply dictionary from *
 /source variables = MV743D 
 /target variables = we_decide_visits.
variable labels we_decide_visits "Decides on visits to family or relatives".

*Decides on own health either alone or jointly.
if mv502=1 we_decide_health_self= any(mv743a,1,2).
variable labels we_decide_health_self "Decides on own health care either alone or jointly with partner".
value labels we_decide_health_self 0 "No" 1 "Yes".

*Decides on household purchases either alone or jointly.
if mv502=1 we_decide_hhpurch_self= any(mv743b,1,2).
variable labels we_decide_hhpurch_self "Decides on large household purchases either alone or jointly with partner".
value labels we_decide_hhpurch_self 0 "No" 1 "Yes".

*Decides on visits either alone or jointly.
if mv502=1 we_decide_visits_self= any(mv743d,1,2).
variable labels we_decide_visits_self "Decides on visits to family or relatives either alone or jointly with partner".
value labels we_decide_visits_self 0 "No" 1 "Yes".

*Decides on both health and household purchases either alone or jointly.
if mv502=1 we_decide_all= any(mv743a,1,2) & any(mv743b,1,2).
variable labels we_decide_all "Decides on both health and purchases either alone or jointly with partner".
value labels we_decide_all 0 "No" 1 "Yes".

*Does not decide on health or household purchases.
if mv502=1 we_decide_none= 0.
if (mv743a<>1 & mv743a<>2) & (mv743b<>1 & mv743b<>2) & mv502=1 we_decide_none=1.
variable labels we_decide_none "Does not decide on health or purchases either alone or jointly with partner".
value labels we_decide_none 0 "No" 1 "Yes".

*** Justification of violence ***

*Jusity violence - burned food.
compute we_dvjustify_burn= mv744e=1.
variable labels we_dvjustify_burn "Agree that husband is justified in hitting or beating his wife if she burns food".
value labels we_dvjustify_burn 0 "No" 1 "Yes".

*Jusity violence - argues.
compute we_dvjustify_argue= mv744c=1.
variable labels we_dvjustify_argue "Agree that husband is justified in hitting or beating his wife if she argues with him".
value labels we_dvjustify_argue 0 "No" 1 "Yes".

*Jusity violence - goes out without saying.
compute we_dvjustify_goout= mv744a=1.
variable labels we_dvjustify_goout "Agree that husband is justified in hitting or beating his wife if she goes out without telling him".
value labels we_dvjustify_goout 0 "No" 1 "Yes".

*Jusity violence - neglects children.
compute we_dvjustify_neglect= mv744b=1.
variable labels we_dvjustify_neglect "Agree that husband is justified in hitting or beating his wife if she neglects the children".
value labels we_dvjustify_neglect 0 "No" 1 "Yes".

*Jusity violence - no sex.
compute we_dvjustify_refusesex= mv744d=1.
variable labels we_dvjustify_refusesex "Agree that husband is justified in hitting or beating his wife if she refuses to have sexual intercourse with him".
value labels we_dvjustify_refusesex 0 "No" 1 "Yes".

*Jusity violence - at least one reason.
compute we_dvjustify_onereas=0.
if mv744a=1 | mv744b=1 | mv744c=1 | mv744d=1 | mv744e=1 we_dvjustify_onereas=1.
variable labels we_dvjustify_onereas "Agree that husband is justified in hitting or beating his wife for at least one of the reasons".
value labels we_dvjustify_onereas 0 "No" 1 "Yes".

*Jusity to reuse sex - he's having sex with another woman.
compute we_justify_refusesex= mv633b=1.
variable labels we_justify_refusesex "Believe a woman is justified to refuse sex with her husband if she knows he's having sex with other women".
value labels we_justify_refusesex 0 "No" 1 "Yes".

*Jusity to ask to use condom - he has STI.
compute we_justify_cond= mv822=1.
variable labels we_justify_cond "Believe a women is justified in asking that her husband to use a condom if she knows that he has an STI".
value labels we_justify_cond 0 "No" 1 "Yes".

