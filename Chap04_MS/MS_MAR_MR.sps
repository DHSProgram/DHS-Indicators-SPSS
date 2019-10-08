* Encoding: windows-1252.
*******************************************************************************
Program: 			MS_MAR_MR.sps
Purpose: 			Code to create marital indicators
Data inputs: 		MR survey list
Data outputs:		coded variables and scalars
Author:				Thomas Pullum and Courtney Allen, translated to SPSS by Ivana Bjelic
Date last modified: October 08, 2019 by Ivana Bjelic
Note:				
*********************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
ms_mar_stat	"Current marital status"
ms_mar_union	"Currently in union"
ms_mar_never	"Never in union"
ms_afm_15		"First marriage by age 15"
ms_afm_18		"First marriage by age 18"
ms_afm_20		"First marriage by age 20"
ms_afm_22		"First marriage by age 22"
ms_afm_25		"First marriage by age 25"
ms_mafm_20	"Median age at first marriage among age 20-49" 
ms_mafm_25	"Median age at first marriage among age 25-49" 
*
ONLY IN MR FILES:
ms_wives_num	"Number of wives"
*
------------------------------------------------------------------------------*.

* NOTES
		sp50 is the integer-valued median produced by summarize, detail;
		what we need is an interpolated or fractional value of the median.
*
		In the program, "age" is reset as age at first cohabitation.
*		
		sL and sU are the cumulative values of the distribution that straddle
		the integer-valued median.

*	
		Medians can be found for subgroups by adding to the variable list below in 
		the same manner (following example in lines 143-167). Subgroup
		names must be added to the codes after line 167 
********************************************************************************


*Define program to calculate median age.
*********************************************************************************

define calc_median_age (backvar = !tokens(1)/beg_age = !tokens(1)/end_age = !tokens(1))

* filter by age group.
compute filter_$ =  (agevar>=!beg_age & agevar<=!end_age).
filter by filter_$.

* weight the data by the weight.
weight by weightvar.

aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=!backvar 
  /sp50=median(age).
	
compute dummyL=$sysmis.
if agevar>=!beg_age & agevar<=!end_age dummyL=0.
if age<sp50 & agevar>= !beg_age & agevar<=!end_age dummyL = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=!backvar 
  /sL=mean(dummyL).
	
compute dummyU=$sysmis.
if agevar>= !beg_age & agevar<= !end_age dummyU=0.
if age<=sp50 & agevar>= !beg_age & agevar<= !end_age dummyU = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=!backvar 
  /sU=mean(dummyU).

*create variable for median.
compute !concat(mafm_,!beg_age,!end_age,_,!backvar) =sp50+(0.5-sL)/(sU-sL).

*label subgroup categories.
variable labels !concat(mafm_,!beg_age,!end_age,_,!backvar) !quote(!concat("Median age at first marriage among ", !beg_age, " to " , !end_age,". yr olds ", !backvar)).

*replace median with O and label "NA" if no median can be calculated for age group.
if !concat(mafm_,!beg_age,!end_age,_,!backvar)>!beg_age !concat(mafm_,!beg_age,!end_age,_,!backvar)=0.
value labels  !concat(mafm_,!beg_age,!end_age,_,!backvar) 0 "NA".

filter off.

weight off.

!enddefine.


*********************************************************************************

* indicators from MR file.

*Median age at first marriage.
*make subgroups here*.
compute all1 = 1.
compute region = mv024.
compute wealth = mv190.
compute education = mv149.
compute residence = mv025.
apply dictionary from *
 /source variables = mv024
 /target variables = region.
.
apply dictionary from *
 /source variables = mv190 
 /target variables = wealth.
.
apply dictionary from *
 /source variables = mv149 
 /target variables = education.
.
apply dictionary from *
 /source variables = mv025
 /target variables = residence.
.
	
*setup variables for median age at first marriage calculated from v511, for men age 20 to 49.
compute afm=mv511.
if mv511=0 afm=99.
compute age=afm.
recode age (97, 98, 99 = 99)(else=copy).
missing values age (99).
compute agevar = mv012.
compute weightvar = mv005.

* create median age at first marriage for each 5 yr age group - Men typically have higher age groups.
calc_median_age backvar = all1 beg_age=15 end_age=19.
calc_median_age backvar = all1 beg_age=20 end_age=24.
calc_median_age backvar = all1 beg_age=25 end_age=29.
calc_median_age backvar = all1 beg_age=30 end_age=34.
calc_median_age backvar = all1 beg_age=35 end_age=39.
calc_median_age backvar = all1 beg_age=40 end_age=44.
calc_median_age backvar = all1 beg_age=45 end_age=49.
calc_median_age backvar = all1 beg_age=50 end_age=54.
calc_median_age backvar = all1 beg_age=55 end_age=59.

* for age groups 20-49, 20-59, 25-49 and 25-59 create median age at first marriage for background characteristics.
calc_median_age backvar = all1 beg_age=20 end_age=49.
calc_median_age backvar = all1 beg_age=20 end_age=59.
calc_median_age backvar = all1 beg_age=25 end_age=49.
calc_median_age backvar = all1 beg_age=25 end_age=59.

calc_median_age backvar = region beg_age=20 end_age=49.
calc_median_age backvar = region beg_age=20 end_age=59.
calc_median_age backvar = region beg_age=25 end_age=49.
calc_median_age backvar = region beg_age=25 end_age=59.

calc_median_age backvar = wealth beg_age=20 end_age=49.
calc_median_age backvar = wealth beg_age=20 end_age=59.
calc_median_age backvar = wealth beg_age=25 end_age=49.
calc_median_age backvar = wealth beg_age=25 end_age=59.

calc_median_age backvar = education beg_age=20 end_age=49.
calc_median_age backvar = education beg_age=20 end_age=59.
calc_median_age backvar = education beg_age=25 end_age=49.
calc_median_age backvar = education beg_age=25 end_age=59.

calc_median_age backvar = residence beg_age=20 end_age=49.
calc_median_age backvar = residence beg_age=20 end_age=59.
calc_median_age backvar = residence beg_age=25 end_age=49.
calc_median_age backvar = residence beg_age=25 end_age=59.
	
*Marital status.
recode mv501 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (else=copy) into ms_mar_stat.
variable labels  ms_mar_stat "Current marital status".
value labels ms_mar_stat 0 "Never married" 1 "Married" 2 "Living together" 3 "Widowed" 4 "Divorced" 5 "Separated" 9 "Missing".

recode mv501 (0, 3 thru 5 =0) (1,2=1) (else=copy) into ms_mar_union.
variable labels  ms_mar_union "Currently in union".
value labels ms_mar_union 0 "Not in union" 1 "In union" 9 "Missing".

compute ms_mar_never = 0.
if mv501=0 ms_mar_never = 1.
variable labels  ms_mar_never "Never in union".
value labels ms_mar_never 0 "No" 1 "Yes".

*Number of wives.
recode mv505 (1=1) (2 thru 97=2) (98=98) (99=99) into ms_wives_num.
variable labels  ms_wives_num "Number of wives".
value labels ms_wives_num 1 "1" 2 "2+" 98 "Don't know" 99 "Missing".

*Married by specific ages.
recode mv511 (sysmis=0) (0 thru 14 = 1) (15 thru 49 = 0) into ms_afm_15.
variable labels  ms_afm_15 "First marriage by age 15".
value labels ms_afm_15 1 "yes" 0 "no".

do if mv012>=18.
+recode mv511 (sysmis=0) (0 thru 17 = 1) (18 thru 49 = 0) into ms_afm_18.
end if.
variable labels  ms_afm_18 "First marriage by age 18".
value labels ms_afm_18 1 "yes" 0 "no".

do if mv012>=20.
+recode mv511 (sysmis=0) (0 thru 19 = 1) (20 thru 49 = 0) into ms_afm_20.
end if.
variable labels  ms_afm_20 "First marriage by age 20".
value labels ms_afm_20 1 "yes" 0 "no".

do if mv012>=22.
+recode mv511 (sysmis=0) (0 thru 21 = 1) (22 thru 49 = 0) into ms_afm_22.
end if.
variable labels  ms_afm_22 "First marriage by age 22".
value labels ms_afm_22 1 "yes" 0 "no".

do if mv012>=25.
recode mv511 (sysmis=0) (0 thru 24 = 1) (25 thru 49 = 0) into ms_afm_25.
end if.
variable labels  ms_afm_25 "First marriage by age 25".
value labels ms_afm_25 1 "yes" 0 "no".

