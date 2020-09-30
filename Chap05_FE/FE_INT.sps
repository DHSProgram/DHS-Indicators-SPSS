* Encoding: UTF-8.
*******************************************************************************
Program: 			FE_INT.sps
Purpose: 			Code fertility indicators from birth history reflecting birth intervals 
Data inputs: 		BR data files
Data outputs:		coded variables
Author:				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified: September 30, 2020 by Ivana Bjelic
*******************************************************************************

*______________________________________________________________________________
Variables created in this file:

*BIRTH INTERVALS
fe_int		"Birth interval of recent non-first births"
fe_age_int		"Age groups for birth interval table"
fe_bord		"Birth order"
fe_int_med		"Median number of mos since preceding birth"
fe_pre_sex		"Sex of preceding birth"
fe_pre_surv		"Survival of preceding birth"
med_mo_subgroup         "Median months since previous birth"


*OTHER INSTRUCTIONS
Change subgroups on line 30-53 and lines 137-145 if other subgroups are needed for mean and medians
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

**BIRTH INTERVALS.

*Group mother's age groups for birth interval table.
recode v013 (1 = 1) (2,3 = 2) (4, 5 = 3) (6, 7 = 4) into fe_age_int.
variable labels fe_age_int "Age groups for birth intervals table".
value labels fe_age_int 1 "15-19" 2 "20-29" 3"30-39" 4 "40-49".

*Create birth interval, excluding first births and their multiples.
if b0 < 2 fe_bord = bord.
if b0 > 1 fe_bord = bord - b0 + 1.
recode fe_bord (1 =1) (2,3 = 2) (4 thru 6 = 4) (7 thru hi = 7) into fe_bord_cat.
variable labels fe_bord_cat "Birth order categories".
value labels fe_bord_cat 1 "1" 2 "2-3" 4 "4-6" 7  "7+".
	
* Birth interval, number of months since preceding birth.
recode b11 (lo thru 17= 1) (18 thru 23 = 2)  (24 thru 35 = 3) (36 thru 47 = 4) (48 thru 59 = 5) (60 thru hi = 6) into fe_int.
variable labels fe_int "Months since preceding birth".
value labels fe_int 1 "less than 17 months" 2 "18-23 months" 3 "24-35 months" 4 "36-47 months" 5 "48-59 months" 6 "60+ months".
		
*Sex of preceding birth, created for subcategory in final tables.
sort cases by caseid bord.
if caseid=lag(caseid) fe_pre_sex = lag(b4).
variable labels fe_pre_sex "Sex of preceding birth".
value labels fe_pre_sex 1 "male" 2 "female".

*Survival of preceding birth, created for subcategory in final tables.
if caseid=lag(caseid) fe_pre_surv = lag(b5).
variable labels fe_pre_surv "Survival of preceding birth".
value labels fe_pre_surv 0 "not alive" 1 "alive".

*now drop of children over 59 months, no longer needed for tabulations.
select if (b19<=59).	
*********************************************************************************.

define calc_median_mo (backvar = !tokens(1))

* weight the data by the weight.
weight by weightvar.

aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=!backvar 
  /sp50=median(time).
	
compute dummyL= $sysmis.
if sysmis(time)=0 dummyL = 0.
if time<sp50 and sysmis(time)=0 dummyL = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=!backvar 
  /sL=mean(dummyL).
	
compute dummyU = $sysmis.
if sysmis(time)=0 dummyU = 0.
if time<=sp50 and sysmis(time)=0 dummyU = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=!backvar 
  /sU=mean(dummyU).

*create variable for median.
compute !concat(med_mo_,!backvar) =sp50+(0.5-sL)/(sU-sL).

*label subgroup categories.
variable labels !concat(med_mo_,!backvar) !quote(!concat("Median months since previous birth ", !backvar)).

*replace median with O and label "NA" if no median can be calculated for age group.
* if !concat(med_mo_,!backvar)>!beg_age !concat(med_mo_,!beg_age,!end_age,_,!backvar)=0.
* value labels  !concat(med_mo_,!backvar) 0 "NA".

weight off.

!enddefine.
	
*setup variables for median number of months since previous birth calculated from b11.
compute fe_month_prev=b11.
compute time=fe_month_prev.
compute weightvar = v005.
	
*-->EDIT subgroups here if other subgroups are needed. 
calc_median_mo backvar = fe_age_int.
calc_median_mo backvar = fe_pre_sex.
calc_median_mo backvar = fe_pre_surv.
calc_median_mo backvar = fe_bord_cat.
calc_median_mo backvar = region.
calc_median_mo backvar = education.
calc_median_mo backvar = wealth.
calc_median_mo backvar = residence.
calc_median_mo backvar = all1.

	

	


