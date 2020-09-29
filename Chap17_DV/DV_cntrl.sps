* Encoding: UTF-8.
*****************************************************************************************************
Program: 			DV_cntrl.sps
Purpose: 			Code marital control  indicators from the IR file
Data inputs: 		IR data files
Data outputs:		coded variables
Author:				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified: September 16 2020
*****************************************************************************************************.

*______________________________________________________________________________
Variables created in this file:

*MARITAL CONTROL
	dv_prtnr_jeals		"Current or most recent partner ever was jealous if spoke to other men"
	dv_prtnr_accus		"Current or most recent partner ever accused her of being unfaithful"
	dv_prtnr_friends                	"Current or most recent partner ever prevented her from meeting female friends"
	dv_prtnr_fam		"Current or most recent partner ever tried to limit her contact with her family"
	dv_prtnr_where		"Current or most recent partner ever insisted on knowing where she is at all times"
	dv_prtnr_money		"Current or most recent partner ever did not trust her with money"
	dv_prtnr_cntrl_3                 	"Current or most recent partner displays 3 or more control behaviors"
	dv_prtnr_cntrl_0                 	"Current or most recent partner displays no control behaviors"
	
*______________________________________________________________________________


********************************************************************************	
**Marital control by current or most recent partner
********************************************************************************	

*partner jealous if spoke to other men.
if v044=1 & v502>0 dv_prtnr_jeals = 0.
if d101a=1 dv_prtnr_jeals = 1.
variable labels dv_prtnr_jeals "Current or most recent partner ever was jealous if spoke to other men".
value labels dv_prtnr_jeals 1 "yes" 0 "no".
	
*accused her of being unfaithful.
if v044=1 & v502>0 dv_prtnr_accus = 0.
if d101b=1 dv_prtnr_accus = 1.
variable labels dv_prtnr_accus "Current or most recent partner ever accused her of being unfaithful".
value labels dv_prtnr_accus 1 "yes" 0 "no".

*prevented her from meeting female friends.
if v044=1 & v502>0 dv_prtnr_friends = 0. 
if d101c=1 dv_prtnr_friends = 1.
variable labels dv_prtnr_friends "Current or most recent partner ever prevented her from meeting female friends".
value labels dv_prtnr_friends 1 "yes" 0 "no".

*tried to limit her contact with her family.
if v044=1 & v502>0 dv_prtnr_fam = 0.
if d101d=1 dv_prtnr_fam = 1.
variable labels dv_prtnr_fam "Current or most recent partner ever tried to limit her contact with her family".
value labels dv_prtnr_fam 1 "yes" 0 "no".

*insisted on knowing where she is at all times.
if v044=1 & v502>0 dv_prtnr_where = 0.
if d101e=1 dv_prtnr_where = 1.
variable labels dv_prtnr_where "Current or most recent partner ever insisted on knowing where she is at all times".
value labels dv_prtnr_where 1 "yes" 0 "no".

*did not trust her with money.
 if v044=1 & v502>0 dv_prtnr_money = 0.
if d101f=1 dv_prtnr_money = 1.
variable labels dv_prtnr_money "Current or most recent partner ever did not trust her with money".
value labels dv_prtnr_money 1 "yes" 0 "no".

*partner displays marital control behaviors.
do if v044=1 & v502>0.
+compute dv_prtnr_cntrl_temp = sum(dv_prtnr_jeals, dv_prtnr_accus, dv_prtnr_friends, dv_prtnr_fam, dv_prtnr_where, dv_prtnr_money).
+recode dv_prtnr_cntrl_temp (1,2=1) (3,4=2) (5,6=3) into dv_prtnr_cntrl_cat.
end if.
variable labels dv_prtnr_cntrl_cat "Current or most recent partner displays control behaviors".
value labels dv_prtnr_cntrl_cat 1 "1-2" 2 "3-4" 3 "5-6".

*partner displays 3 or more of marital control behaviors.
do if v044=1 & v502>0.
+compute dv_prtnr_cntrl_0 = sum(dv_prtnr_jeals, dv_prtnr_accus, dv_prtnr_friends, dv_prtnr_fam, dv_prtnr_where, dv_prtnr_money). 
+recode dv_prtnr_cntrl_0 (3 thru 6=1) (0 thru 2=0) into dv_prtnr_cntrl_3.
end if.
variable labels dv_prtnr_cntrl_3 "Current or most recent partner displays 3 or more control behaviors".
value labels dv_prtnr_cntrl_3 1 "yes" 0 "no".

*partner displays none of these marital control behaviors.
do if v044=1 & v502>0.
+compute dv_prtnr_cntrl_0 = sum(dv_prtnr_jeals, dv_prtnr_accus, dv_prtnr_friends, dv_prtnr_fam, dv_prtnr_where, dv_prtnr_money) . 
+recode dv_prtnr_cntrl_0 (1 thru 6=1) (else=0).
end if.
variable labels dv_prtnr_cntrl_0 "Current or most recent partner displays no control behaviors".
value labels dv_prtnr_cntrl_0 0 "no behaviors" 1 "1 or more behaviors".

	

