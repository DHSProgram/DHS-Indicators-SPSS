* Encoding: windows-1252.
******************************************************************************************************
Program: 			RH_DEL.sps
Purpose: 			Code Delivery Care indicators
Data inputs: 		BR data files
Data outputs:		coded variables
Author:				Ivana Bjelic 
Date last modified: June 30 2019 by Ivana Bjelic			
*****************************************************************************************************/

*-----------------------------------------------------------------------------//
Variables created in this file:
rh_del_place		"Live births by place of delivery"
rh_del_pltype		"Live births by type of place"
rh_del_pv			"Person providing assistance during birth"
rh_del_pvskill		"Skilled provider providing assistance during birth"
rh_del_ces			"Live births delivered by cesarean"
rh_del_cestime		"Timing of decision to have Cesarean"
rh_del_stay			"Duration of stay following recent birth"

*----------------------------------------------------------------------------*/


** To check if survey has m17a. If variable doesnt exist, empty variable is created.
begin program.
import spss, spssaux
varList = "m17a"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.
execute.

aggregate
  /outfile = * mode=addvariables
  /break=
  /m17a_included=mean(m17a).

recode m17a_included (lo thru hi = 1)(else = 0).

*Place of delivery.
do if (age < period).
+ recode m15 (20 thru 39 = 1) (10 thru 19 = 2) (40 thru 98 = 3) (99=9) into rh_del_place.
end if.
variable labels rh_del_place "Live births by place of delivery".
value labels rh_del_place
 1 "Health facility"
 2 "Home"
 3 "Other"
 9 "Missing".

*Place of delivery - by place type.
do if (age < period).
+ recode m15 (20 thru 29 = 1) (30 thru 39 = 2) (10 thru 19 = 3)(40 thru 98 = 4)(99=9)into rh_del_pltype.
end if.
variable labels rh_del_pltype "Live births by type of health facility".
value labels  rh_del_pltype
 1 "Health facility - public"
 2 "Health facility - private"
 3 "Home"
 4 "Other"
 9 "Missing".

*Assistance during delivery.
do if (age < period).
+ if sysmis(m3a)=0 rh_del_pv = 0.
+ if m3n = 1 rh_del_pv = 7.	
+ if m3i = 1 | m3j = 1 | m3k = 1 | m3l = 1 | m3m = 1 rh_del_pv = 6.
+ if m3h = 1 rh_del_pv = 5. 	
+ if m3g = 1 rh_del_pv = 4.	
+ if m3c = 1 | m3d = 1 | m3e = 1 | m3f = 1 rh_del_pv = 3. 	
+ if m3b = 1 rh_del_pv = 2. 	
+ if m3a = 1 rh_del_pv = 1. 
+ if m3a = 8 or m3a = 9 rh_del_pv = 9.
end if.	
variable labels rh_del_pv "Person providing assistance during delivery".
value labels  rh_del_pv	
 1 "Doctor" 					
 2 "Nurse/midwife"			
 3 "Country specific health professional" 
 4 "Traditional birth attendant"	
 5 "Other health worker"		
 6 "Relative/other"			
 7 "No one"
 9 "Don't know/missing".

*Skilled provider during delivery.
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
do if (age < period).
+ recode rh_del_pv (1,2=1) (3 thru 6 = 2 ) (7 = 3) into rh_del_pvskill.
end if.
variable labels rh_del_pvskill "Skilled assistance during delivery".
value labels rh_del_pvskill 
  1  "Skilled provider"
  2  "Unskilled provider"
  3  "No one".

*Caesarean delivery.
do if (age < period).
+ compute rh_del_ces = 0.
+ if m17=1 rh_del_ces = 1.
end if.
value labels rh_del_ces 0 "No" 1 "Yes".
variable labels rh_del_ces "Live births delivered by Caesarean".
	
*Timing of decision for caesarean.
** some surveys did not ask this question, confirm m17a exists.
do if (age < period).
+ if m17a_included = 1 rh_del_cestime = m17a.   
+ recode rh_del_cestime (sysmis=0)(else = copy).
end if.
variable labels rh_del_cestime "Timing of decision to have Caesarean".
value labels  rh_del_cestime 0 "Vaginal Birth" 1 "Before labor started" 2 "After labor started".
* for tabulation purposes.
recode rh_del_cestime (0=0) (1,2 = 1) (else = copy) into rh_del_cestimeR.
variable labels rh_del_cestimeR "Timing of decision to have Caesarean".
value labels  rh_del_cestimeR 0 "Vaginal Birth" 1 "Caesarean section".
	
*Timing of decision for caesarean.
do if (age < period and rh_del_place = 1 and bidx = 1).
+ recode m61 (0 thru 105 = 1) (106 thru 111 = 2) (112 thru 123 = 3)(124 thru 171, 201, 202 = 4) (172 thru 199, 203 thru 399= 5) (998 = 9) (else=9) into rh_del_stay.
end if.
variable labels rh_del_stay "Duration of stay following recent birth".
value labels rh_del_stay 
 1  "<6 hours"
 2  "6-11 hours"
 3 "12-23 hours"
 4 "1-2 days"
 5  "3+ days"
 9 "Don't know/Missing".
	
