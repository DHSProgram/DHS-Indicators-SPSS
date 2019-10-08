* Encoding: windows-1252.
*******************************************************************************
Program: 			MS_SEX_IR.sps
Purpose: 			Code to create sexual activity indicators
Data inputs: 		IR survey list
Data outputs:		coded variables and scalars
Author:				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified: September 29, 2019 by Ivana Bjelic
Note:				
*********************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
mms_afs_15	"First sexual intercourse by age 15"
ms_afs_18		"First sexual intercourse by age 18"
ms_afs_20		"First sexual intercourse by age 20"
ms_afs_22		"First sexual intercourse by age 22"
ms_afs_25		"First sexual intercourse by age 25"
ms_mafs_25	"Median age at first sexual intercourse among age 25-49" 
ms_sex_never	"Never had intercourse"
*
----------------------------------------------------------------------------*

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
		the same manner (following example in lines 138-151). Subgroup
		names must be added to the codes after line 151 
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
compute !concat(mafs_,!beg_age,!end_age,_,!backvar) =sp50+(0.5-sL)/(sU-sL).

*label subgroup categories.
variable labels !concat(mafs_,!beg_age,!end_age,_,!backvar) !quote(!concat("Median age at first sex among ", !beg_age, " to " , !end_age,". yr olds ", !backvar)).

*replace median with O and label "NA" if no median can be calculated for age group.
if !concat(mafs_,!beg_age,!end_age,_,!backvar)>!beg_age !concat(mafs_,!beg_age,!end_age,_,!backvar)=0.
value labels !concat(mafs_,!beg_age,!end_age,_,!backvar) 0 "NA".

filter off.

weight off.

!enddefine.

*********************************************************************************.

* Indicators from IR file.

*Median age at first sex.
*make subgroups here*.
compute all1 = 1.
compute region = v024.
compute wealth = v190.
compute education = v149.
compute residence = v025.
apply dictionary from *
 /source variables = v024
 /target variables = region.
.
apply dictionary from *
 /source variables = v190 
 /target variables = wealth.
.
apply dictionary from *
 /source variables = v149 
 /target variables = education.
.
apply dictionary from *
 /source variables = v025
 /target variables = residence.
.
	
*setup variables for median age at first sex calculated from v531, for women age 20 to 49.
compute afs=v531.
if v531=0 afs=99.
compute age=afs.
recode age (97, 98, 99 = 99)(else=copy).
missing values age (99).
compute agevar = v012.
compute weightvar = v005.

* create median age at first sex for each 5 yr age group - Men typically have higher age groups.
calc_median_age backvar = all1 beg_age=15 end_age=19.
calc_median_age backvar = all1 beg_age=20 end_age=24.
calc_median_age backvar = all1 beg_age=25 end_age=29.
calc_median_age backvar = all1 beg_age=30 end_age=34.
calc_median_age backvar = all1 beg_age=35 end_age=39.
calc_median_age backvar = all1 beg_age=40 end_age=44.
calc_median_age backvar = all1 beg_age=45 end_age=49.
calc_median_age backvar = all1 beg_age=15 end_age=24.

* for age groups 20-49 and 25-49 create median age at first sex for background characteristics.
calc_median_age backvar = all1 beg_age=20 end_age=49.
calc_median_age backvar = all1 beg_age=25 end_age=49.

calc_median_age backvar = region beg_age=20 end_age=49.
calc_median_age backvar = region beg_age=25 end_age=49.

calc_median_age backvar = wealth beg_age=20 end_age=49.
calc_median_age backvar = wealth beg_age=25 end_age=49.

calc_median_age backvar = education beg_age=20 end_age=49.
calc_median_age backvar = education beg_age=25 end_age=49.

calc_median_age backvar = residence beg_age=20 end_age=49.
calc_median_age backvar = residence beg_age=25 end_age=49.
				
*Never had sex.
compute ms_sex_never = 0.
if v531=0 ms_sex_never = 1.
variable labels  ms_sex_never "Never had sex".
value labels ms_sex_never 1 "yes" 0 "no".

*Had sex by specific ages.
recode v531 (0,97,98,99,sysmis=0) (1 thru 14=1) (15 thru 49=0) into ms_afs_15.
variable labels  ms_afs_15 "First sex by age 15".
value labels ms_afs_15 1 "yes" 0 "no".

do if v012>=18.
+recode v531 (0,97,98,99,sysmis=0) (1 thru 17=1) (18 thru 49=0) into ms_afs_18.
end if.
variable labels  ms_afs_18 "First sex by age 18".
value labels ms_afs_18 1 "yes" 0 "no".

do if v012>=20.
recode v531 (0,97,98,99,sysmis=0) (1 thru 19=1) (20 thru 49=0) into ms_afs_20.
end if.
variable labels  ms_afs_20 "First sex by age 20".
value labels ms_afs_20 1 "yes" 0 "no".

do if v012>=22.
recode v531 (0,97,98,99,sysmis=0) (1 thru 21=1) (22 thru 49=0) into ms_afs_22.
end if.
variable labels  ms_afs_22 "First sex by age 22".
value labels ms_afs_22 1 "yes" 0 "no".

do if v012>=25.
recode v531 (0,97,98,99,sysmis=0) (1 thru 24=1) (25 thru 49=0) into ms_afs_25.
end if.
variable labels  ms_afs_25 "First sex by age 25".
value labels ms_afs_25 1 "yes" 0 "no".
