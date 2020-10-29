* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FG_CIRCUM_IR.sps
Purpose: 			Code to 
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: October 27, 2020 by Shireen Assaf 
*
Note:				Heard of female cirucumcision and opinions on female cirucumcision can be computed for men and women
*				In older surveys there may be altnative variable names related to female circumcision. 
*				Please check Chapter 18 in Guide to DHS Statistics and the section "Changes over Time" to find alternative names.
*				Link:    https:*www.dhsprogram.com/Data/Guide-to-DHS-Statistics/index.htm#t=Knowledge_of_Female_Circumcision.htm%23Percentage_of_women_and8bc-1&rhtocid=_21_0_0
					
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
fg_heard			"Heard of female circumcision"
*	
fg_fcircum_wm		"Circumcised among women age 15-49"
fg_type_wm			"Type of female circumcision among women age 15-49"
fg_age_wm			"Age at circumcision among women age 15-49"
fg_sewn_wm		"Female circumcision type is sewn closed among women age 15-49"	
fg_who_wm			"Person who performed the circumcision among women age 15-49"
*	
fg_relig			"Opinion on whether female circumcision is required by their religion" 
fg_cont			"Opinion on whether female circumcision should continue" 

*----------------------------------------------------------------------------.


* indicators from IR file.

*Heard of female circumcision.
compute fg_heard = g100.
if g101=1 fg_heard =1.
variable labels  fg_heard "Heard of female circumcision".
value labels fg_heard 0"No" 1"Yes".

*Circumcised women.
do if not sysmis(g100).
+compute fg_fcircum_wm = 0.
+ if g102 = 1 fg_fcircum_wm = 1.
end if.
variable labels  fg_fcircum_wm "Circumcised among women age 15-49".
value labels fg_fcircum_wm 0"No" 1"Yes".

*Type of circumcision.
if g102=1 fg_type_wm = 9.
if g104=1 & g105<>1 fg_type_wm = 1.
if g103=1 & g105<>1 fg_type_wm = 2.
if g105=1 fg_type_wm = 3.
variable labels  fg_type_wm "Type of female circumcision among women age 15-49".
value labels fg_type_wm 1"No flesh removed" 2"Flesh removed"  3"Sewn closed" 9"Don't know/missing".

*Age at circumcision.
if g102=1 fg_age_wm = 9.
if range(g106,0,4) or g106=95 fg_age_wm = 1.
if range(g106,5,9) fg_age_wm = 2.
if range(g106,10,14) fg_age_wm = 3.
if range(g106,15,49) fg_age_wm = 4.
if g106=98 fg_age_wm = 9.
variable labels  fg_age_wm "Age at circumcision among women age 15-49".
value labels fg_age_wm 1"<5" 2"5-19" 3"10-14" 4"15+" 9"Don't know/missing".

*Sewn close.
if g102=1 fg_sewn_wm = g105.
variable labels  fg_sewn_wm "Female circumcision type is sewn closed among women age 15-49".
apply dictionary from *
 /source variables=g105
 /target variables=fg_sewn_wm.

*Person performing the circumcision among women age 15-49.
do if g102=1.
+recode g107 (21=1) (22=2) (26=3) (11=4) (12=5) (16=6) (96=7)(98,99=9) into fg_who_wm.
end if.
variable labels fg_who_wm "Person who performed the circumcision among women age 15-49".
value labels fg_who_wm 1 "traditional circumciser" 2 "traditional birth attendant" 3 "other traditional agent" 4 "doctor" 5 "nurse/midwife" 6 "other health professional" 7 "other" 9 "don't know/missing".

*Opinion on whether female circumcision is required by their religion.
if fg_heard=1 fg_relig = g118.
if g118=9 fg_relig =8.
variable labels fg_relig "Opinion on whether female circumcision is required by their religion".
apply dictionary from *
 /source variables=g118
 /target variables=fg_relig.

*Opinion on whether female circumcision should continue.
if fg_heard=1 fg_cont = g119.
if g119=9 fg_cont =8.
variable labels fg_cont "Opinion on whether female circumcision should continue".
apply dictionary from *
 /source variables=g119
 /target variables=fg_cont.
