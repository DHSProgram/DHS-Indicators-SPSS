* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FE_FERT.sps
Purpose: 			Code currenty fertility indicators
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified: September 29, 2020 by Ivana Bjelic
*****************************************************************************************************/

/*______________________________________________________________________________.
*Variables created in this file:.
*FERTILITY
	fe_preg		"Currently pregnant"
	fe_ceb_num		"Number of children ever born (CEB)"
	fe_ceb_mean	"Mean number of CEB"
	fe_ceb_comp  	"Completed fertility - Mean number of CEB to women age 40-49"
	fe_live_mean	"Mean number of living children"
*MENOPAUSE
	fe_meno		"Menopausal"
*TEEN PREGNANCY AND MOTHERHOOD
	fe_teen_birth	"Teens who have had a live birth"
	fe_teen_preg	"Teens pregnant with first child"
	fe_teen_beg		"Teens who have begun childbearing"
*FIRST BIRTH
	fe_birth_never	"Never had a birth"
	fe_afb_15		"First birth by age 15"
	fe_afb_18		"First birth by age 18"
	fe_afb_20		"First birth by age 20"
	fe_afb_22		"First birth by age 22"
	fe_afb_25		"First birth by age 25"
	fe_mafb_25		"Median age at first birth among age 25-49"
*OTHER INSTRUCTIONS
Change subgroups on line 42-63 and lines 329-343 if other subgroups are needed for mean and medians
______________________________________________________________________________*/

*-->EDIT subgroups here if other subgroups are needed. 
****Subgroups currently include: Residence, region, education, and wealth.

compute all1 = 1.

compute residence = v025.
apply dictionary from *
 /source variables = v025
 /target variables = residence
.

compute region = v024.
apply dictionary from *
 /source variables = v024
 /target variables = region
.

compute wealth = v190.
apply dictionary from *
 /source variables = v190
 /target variables = wealth
.

compute education = v149.
apply dictionary from *
 /source variables = v149
 /target variables = education
.
	
*generate weight variable.
compute wt = v005/1000000.

**FERTILITY VARIABLES.

*Currently Pregnant.
compute fe_preg = v213.
variable labels fe_preg "Currently pregnant".
value labels fe_preg 0 "no" 1 "yes".
		
*Number of children ever born (CEB).
recode v201 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10 thru hi = 10) into fe_ceb_num.
variable labels fe_ceb_num "Number of children ever born".
value labels fe_ceb_num 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10+".

*Mean number of children ever born (CEB).
		  
*Completed fertility, mean number of CEB among women age 40-49.

* weight the data by the weight.
weight by wt.
if v013>=6 fe_ceb_comp=v201.
aggregate outfile = * mode = addvariables overwrite = yes
/break
/fe_ceb_comp=mean(fe_ceb_comp).
variable labels fe_ceb_comp "Mean no. of CEB among women age 40-49".

*Completed fertility, mean number of CEB among women age 40-49 by subgroups.
define calc_mean_ceb (backvar = !tokens(1))

if v013>=6 !concat(fe_ceb_comp_,!backvar)=v201.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=!backvar 
  /!concat(fe_ceb_comp_,!backvar)=mean(!concat(fe_ceb_comp_,!backvar)).

*label subgroup categories.
variable labels !concat(fe_ceb_comp_,!backvar) !quote(!concat("Mean no. of CEB among women age 40-49 ", !backvar)).

!enddefine.

calc_mean_ceb backvar = region.
calc_mean_ceb backvar = residence.
calc_mean_ceb backvar = education.
calc_mean_ceb backvar = wealth.
	
*Mean number of CEB among all women.
aggregate outfile = * mode = addvariables overwrite = yes
/break
/fe_ceb_mean=mean(v201).
variable labels fe_ceb_mean "Mean number of CEB".

*Mean number of CEB among all women, by age group.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=v013 
  /fe_ceb_mean_age=mean(v201).

if (v013=1) fe_ceb_mean1=fe_ceb_mean_age.
if (v013=2) fe_ceb_mean2=fe_ceb_mean_age.
if (v013=3) fe_ceb_mean3=fe_ceb_mean_age.
if (v013=4) fe_ceb_mean4=fe_ceb_mean_age.
if (v013=5) fe_ceb_mean5=fe_ceb_mean_age.
if (v013=6) fe_ceb_mean6=fe_ceb_mean_age.
if (v013=7) fe_ceb_mean7=fe_ceb_mean_age.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break
  /fe_ceb_mean1=mean(fe_ceb_mean1)
  /fe_ceb_mean2=mean(fe_ceb_mean2)
  /fe_ceb_mean3=mean(fe_ceb_mean3)
  /fe_ceb_mean4=mean(fe_ceb_mean4)
  /fe_ceb_mean5=mean(fe_ceb_mean5)
  /fe_ceb_mean6=mean(fe_ceb_mean6)
  /fe_ceb_mean7=mean(fe_ceb_mean7).
 
*label subgroup categories.
variable labels fe_ceb_mean1 "Mean number of CEB, agegroup:15-19".
variable labels fe_ceb_mean2 "Mean number of CEB, agegroup:20-24".
variable labels fe_ceb_mean3 "Mean number of CEB, agegroup:25-29".
variable labels fe_ceb_mean4 "Mean number of CEB, agegroup:30-34".
variable labels fe_ceb_mean5 "Mean number of CEB, agegroup:35-39".
variable labels fe_ceb_mean6 "Mean number of CEB, agegroup:40-44".
variable labels fe_ceb_mean7 "Mean number of CEB, agegroup:45-49".

*Mean number of living children among all women.
aggregate outfile = * mode = addvariables overwrite = yes
/break
/fe_live_mean=mean(v218).
variable labels fe_live_mean "Mean number of living children".

*Mean number of living children among all women, by age group.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=v013 
  /fe_live_mean_age=mean(v218).

if (v013=1) fe_live_mean1=fe_live_mean_age.
if (v013=2) fe_live_mean2=fe_live_mean_age.
if (v013=3) fe_live_mean3=fe_live_mean_age.
if (v013=4) fe_live_mean4=fe_live_mean_age.
if (v013=5) fe_live_mean5=fe_live_mean_age.
if (v013=6) fe_live_mean6=fe_live_mean_age.
if (v013=7) fe_live_mean7=fe_live_mean_age.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break
  /fe_live_mean1=mean(fe_live_mean1)
  /fe_live_mean2=mean(fe_live_mean2)
  /fe_live_mean3=mean(fe_live_mean3)
  /fe_live_mean4=mean(fe_live_mean4)
  /fe_live_mean5=mean(fe_live_mean5)
  /fe_live_mean6=mean(fe_live_mean6)
  /fe_live_mean7=mean(fe_live_mean7).
 
*label subgroup categories.
variable labels fe_live_mean1 "Mean number of living children, agegroup:15-19".
variable labels fe_live_mean2 "Mean number of living children, agegroup:20-24".
variable labels fe_live_mean3 "Mean number of living children, agegroup:25-29".
variable labels fe_live_mean4 "Mean number of living children, agegroup:30-34".
variable labels fe_live_mean5 "Mean number of living children, agegroup:35-39".
variable labels fe_live_mean6 "Mean number of living children, agegroup:40-44".
variable labels fe_live_mean7 "Mean number of living children, agegroup:45-49".

weight off.
		
**TEENAGE PREGNANCY AND MOTHERHOOD.

*Teens (women age 15-19) who have had a live birth.
*do if v013=1.
* + compute fe_teen_birth = v201.
*end if.
do if v013=1.
+recode v201 (0=0) (1 thru hi=1) into fe_teen_birth.
end if.
variable labels fe_teen_birth "Teens who have had a live birth".
value labels fe_teen_birth 0 "No" 1 "Yes".
	
*Teens (women age 15-19) pregnant with first child.
do if v013=1.
+compute fe_teen_preg = 0.
+if v201=0 & v213=1 fe_teen_preg = 1.
end if.
variable labels fe_teen_preg "Teens pregnant with first child".
value labels fe_teen_preg 0 "no" 1 "yes".

*Teens (women age 15-19) who have begun childbearing.
do if v013=1.
+compute fe_teen_beg = 0.
+if (v201>0 | v213=1) fe_teen_beg = 1.
end if.
variable labels fe_teen_beg "Teens who have begun childbearing".
value labels fe_teen_beg 0 "no" 1 "yes".

**MENOPAUSE.
	
*Women age 30-49 experiencing menopause (exclude pregnant or those with postpartum amenorrhea).
do if v013>3.
+compute fe_meno = 0.
+if (v226>5 & v226<997) & v213=0 & v405=0 fe_meno = 1.
end if.
variable labels fe_meno "Experienced menopause".
value labels fe_meno 0 "no" 1 "yes".

*Menopausal age group, 30-49, two-year intervals after 40.
recode v012 (30 thru 34 = 30)(35 thru 39 = 35)(40 thru 41 = 40)(42 thru 43 = 42)(44 thru 45 = 44)(46 thru 47 = 46)(48 thru 49=48) into fe_meno_age.
variable labels fe_meno_age "Age groups for Menopause table".
value labels fe_meno_age 30 "30-34" 35 "35-39" 40 "40-41" 42 "42-43" 44 "44-45" 46 "46-47" 48 "48-49".
	
**FIRST BIRTH.

*First birth by specific ages.
recode v212 (sysmis=0) (0 thru 14 = 1) (15 thru 49 = 0) into fe_afb_15.
variable labels fe_afb_15 "First birth by age 15".
value labels fe_afb_15 0 "no" 1 "yes".

do if v012>=18.
+recode v212 (sysmis=0) (0 thru 17 = 1) (18 thru 49 = 0) into fe_afb_18.
end if.
variable labels fe_afb_18 "First birth by age 18".
value labels fe_afb_18 0 "no" 1 "yes".

do if v012>=20.
+recode v212 (sysmis=0) (0 thru 19 = 1) (20 thru 49 = 0) into fe_afb_20.
end if.
variable labels fe_afb_20 "First birth by age 20".
value labels fe_afb_20 0 "no" 1 "yes".

do if v012>=22.
+recode v212 (sysmis=0) (0 thru 21 = 1) (22 thru 49 = 0) into fe_afb_22.
end if.
variable labels fe_afb_22 "First birth by age 22".
value labels fe_afb_22 0 "no" 1 "yes".

do if v012>=25.
+recode v212 (sysmis=0) (0 thru 24 = 1) (25 thru 49 = 0) into fe_afb_25.
end if.
variable labels fe_afb_25 "First birth by age 25".
value labels fe_afb_25 0 "no" 1 "yes".

*Never had a first birth.
compute fe_birth_never = 0.
if v201=0 fe_birth_never = 1.
variable labels fe_birth_never "Never had a birth".
value labels fe_birth_never 0 "no" 1 "yes".
	

**MEDIAN AGE AT FIRST BIRTH.

*Define program to calculate median age
*********************************************************************************.

define calc_median_age (backvar = !tokens(1) / beg_age = !tokens(1) / end_age = !tokens(1))

* weight the data by the weight.
weight by weightvar.

if (agevar>= !beg_age & agevar<= !end_age) ageM=age.

aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=!backvar 
  /sp50=median(ageM).
	
compute dummyL= $sysmis.
if agevar>= !beg_age & agevar<= !end_age dummyL = 0.
if ageM<sp50 and agevar>= !beg_age & agevar<= !end_age dummyL = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=!backvar 
  /sL=mean(dummyL).
	
compute dummyU = $sysmis.
if agevar>= !beg_age & agevar<= !end_age dummyU = 0.
if ageM<=sp50 and agevar>= !beg_age & agevar<= !end_age dummyU = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=!backvar 
  /sU=mean(dummyU).

*create variable for median.
compute !concat(mafb_,!beg_age,!end_age,"_",!backvar)=sp50+(0.5-sL)/(sU-sL).

*label subgroup categories.
variable labels !concat(mafb_,!beg_age,!end_age,"_",!backvar) !quote(!concat("Median age at first birth among ", !beg_age," to ", !end_age, " yr olds ", !backvar)).

*replace median with O and label "NA" if no median can be calculated for age group.
if  (!concat(mafb_,!beg_age,!end_age,"_",!backvar)>!beg_age)  !concat(mafb_,!beg_age,!end_age,"_",!backvar)=0.
value labels !concat(mafb_,!beg_age,!end_age,"_",!backvar) 0 "NA".

weight off.

!enddefine.

*********************************************************************************
	
*setup variables for median age at first birth calculated from v212.
compute afb=v212.
compute age=afb.
compute agevar = v012.
compute weightvar = v005.

*-->EDIT subgroups here if other subgroups are needed. 
calc_median_age backvar = all1 beg_age = 15 end_age=19.
calc_median_age backvar = all1 beg_age = 20 end_age=24.
calc_median_age backvar = all1 beg_age = 25 end_age=29.
calc_median_age backvar = all1 beg_age = 30 end_age=34.
calc_median_age backvar = all1 beg_age = 35 end_age=39.
calc_median_age backvar = all1 beg_age = 40 end_age=44.
calc_median_age backvar = all1 beg_age = 45 end_age=49.

calc_median_age backvar = all1 beg_age = 20 end_age=49.
calc_median_age backvar = all1 beg_age = 25 end_age=49.

calc_median_age backvar = region beg_age = 25 end_age=49.
calc_median_age backvar = education beg_age = 25 end_age=49.
calc_median_age backvar = wealth beg_age = 25 end_age=49.
calc_median_age backvar = residence beg_age = 25 end_age=49.
