* Encoding: windows-1252.
****************************************************************************************************
Program: 			ML_NETS_HH.sps
Purpose: 			Code indicators for household ITN ownership
Data inputs: 		HR dataset
Data outputs:		coded variables
Author:				Cameron Taylor and translated to SPSS by Ivana Bjelic
Date last modified: August 30 2019 by Ivana Bjelic
*****************************************************************************************************.

*---------------------------------------------------------------------------
Variables created in this file:
ml_mosquitonet		"Households with at least one mosquito net"
ml_itnhh			"Households with at least one ITN"
ml_avgmosnethh		"Average number of mosquito nets per household"
ml_avgitnhh			"Average number of ITNs per household"
ml_mosnethhaccess	                  "Households with >1 mosquito net per 2 household members"
ml_hhaccess		"Households with >1 ITN per 2 household members"
----------------------------------------------------------------------------*/.

*Household mosquito net ownership.
compute ml_mosquitonet=0.
if hv227=1 ml_mosquitonet=1.
variable labels ml_mosquitonet "Household owns at least one mosquito net".
value labels ml_mosquitonet 0 "No" 1 "Yes".

*Household ITN ownership.
compute ml_itnhh=0.
if any(1,hml10$1,hml10$2,hml10$3,hml10$4,hml10$5,hml10$6,hml10$7) ml_itnhh=1.
variable labels ml_itnhh "Household owns at least one ITN".
value labels ml_itnhh 0 "No" 1 "Yes".

*Number of mosquito nets per household.
compute ml_numnets=hml1.
recode ml_numnets (1 thru hi = copy) (else = 0).
variable labels ml_numnets "Number of mosquito nets per household".

*Number of ITNs per household.
do repeat x = itnhh$01 to itnhh$07 / y = hml10$1 to hml10$7.
compute x = (y=1).
recode x (sysmis = 0)(else = copy).
end repeat.
compute ml_numitnhh=itnhh$01 + itnhh$02 + itnhh$03 + itnhh$04 + itnhh$05 + itnhh$06 + itnhh$07.
variable labels ml_numitnhh "Number of ITNs per household".

compute iw=hv005/1000000.
weight by iw.
*Average number of mosquito nets per household.
*Average number of ITNs per household.
aggregate outfile = * mode = addvariables overwrite = yes
/ml_numnets_sum = sum(ml_numnets)
/ml_avgmosnethh = mean(ml_numnets)
/ml_avgitnhh = mean(ml_numitnhh).
variable labels ml_avgmosnethh "Average number of mosquito nets per household".
variable labels ml_avgitnhh "Average number of ITNs per household".
weight off.

*Households with > 1 mosquito net per 2 members.
*Potential users divided by defacto household members is greater or equal to one.
* Potential ITN users in Household.
compute ml_mosnetpotuse = ml_numnets*2.
variable labels ml_mosnetpotuse "Potential mosquito net users in household".
do if (hv013<>0).
+compute ml_mosnethhaccess = ((ml_mosnetpotuse/hv013)>=1).
*this indicator is based on households with at least one person who stayed in the house last night
*hv013 is the number of persons who stayed in the household last night. 
+else.
+compute ml_mosnethhaccess=$sysmis.
end if.
variable labels ml_mosnethhaccess "Households with >1 mosquito net per 2 household members".
value labels ml_mosnethhaccess 0 "No" 1 "Yes".

*Households with > 1 ITN per 2 members.
*Potential users divided by defacto household members is greater or equal to one.
*Potential ITN users in Household.
compute ml_potuse = ml_numitnhh*2.
variable labels ml_potuse "Potential ITN users in household".
do if hv013<>0.
+compute ml_hhaccess = ((ml_potuse/hv013)>=1).
+else.
+compute ml_hhaccess=$sysmis.
end if.
variable labels ml_hhaccess "Households with >1 ITN per 2 household members".
value labels ml_hhaccess 0 "No" 1 "Yes".

execute.
delete variables itnhh$01 to itnhh$07.
execute.
