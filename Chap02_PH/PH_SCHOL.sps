* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_SCHOL.sps
Purpose: 			Code to compute school attendance indicators
Data inputs: 		BR and PR dataset
Data outputs:		coded variables
Author:				Trevor Croft, translated to SPSS by Ivana Bjelic
Date last modified: August 11, 2020 by Ivana Bjelic
                    December 1, 2021 by Trevor Croft
Note:				To produce the net attendance ratios you need to provide country specific information on the year and month of the school calendar and the age range for school attendance. See lines 65-75
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
ph_sch_nar_prim			"Primary school net attendance ratio (NAR)"
ph_sch_nar_sec			"Secondary school net attendance ratio (NAR)"
ph_sch_gar_prim			"Primary school gross attendance ratio (GAR)"
ph_sch_gar_sec			"Secondary school gross attendance ratio (GAR)"
ph_sch_nar_prim_*_gpi	                                    "Gender parity index for NAR primary"
ph_sch_nar_sec_*_gpi	                                    "Gender parity index for NAR secondary"
ph_sch_gar_prim_*_gpi	                                    "Gender parity index for GAR primary"
ph_sch_gar_sec_*_gpi	                                    "Gender parity index for GAR secondary"	
*----------------------------------------------------------------------------.

* For net attendance rates (NAR) and gross attendance rates (GAR) we need to know the age of children at the start of the school year.
* For this we need to get date of birth from birth history and attach to children's records in the PR file.
* open the birth history data to extract date of birth variables needed.
* keep only the variables we need.
get file =  datapath + "\"+ brdata + ".sav"/keep v001 v002 v003 b3 b16.

* drop if the child in the birth history was not in the household or not alive.
select if b16<>0 and not sysmis(b16).
* rename key variables for matching.
rename variables (b16 = hvidx).
rename variables (v001 = hv001).
rename variables (v002 = hv002).
* sort on key variables.
sort cases by hv001 hv002 hvidx.

* if there are some duplicates of line number in household questionnaire, we need to drop the duplicates.
compute dup = 0.
if hv001=lag(hv001) and hv002=lag(hv002) and hvidx=lag(hvidx) dup=1.

select if dup=0.
execute.
delete variables dup.
* re-sort to make sure still sorted.
sort cases by hv001 hv002 hvidx.

* save a temporary file for merging.
save outfile = datapath + "\tempBR.sav".

* use the PR file for household members for the NAR and GAR indicators.
get file =  datapath + "\"+ prdata + ".sav".

* merge in the date of birth from the women's birth history for the household member.
match files
/file=*
/table=datapath + "\tempBR.sav"
/by hv001 hv002 hvidx.

* there are a few mismatches of line numbers (typically a small number of cases) coming rom the BR file, so let's drop those.
*drop if _merge=2.

* restrict to de facto household members age 5-24, and drop all others.
select if hv103=1 and range(hv105,5,24).

* now we calculate the child's age at the start of the school year.
* but first we have to specify the month and year of the start of the school year referred to in the survey.
* example, for Zimbabwe 2015 survey this was January 2015.
compute school_start_yr = 2015.
compute school_start_mo = 1.
* also need the age ranges for primary and secondary.
* example, for Zimbabwe 2015, the age range is 6-12 for primary school and 13-18 for secondary school.
compute age_prim_min = 6.
compute age_prim_max = 12.
compute age_sec_min = 13.
compute age_sec_max = 18.

* produce century month code of start of school year for each state and phase.
compute cmcSch = (school_start_yr - 1900)*12 + school_start_mo.
if (hv008 >= cmcSch+12) cmcSch = cmcSch+12.
* calculate the age at the start of the school year, using the date of birth from the birth history if we have it.
if not sysmis(b3) school_age = trunc((cmcSch - b3) / 12).
* Impute an age at the beginning of the school year when CMC of birth is unknown.
* the random imputation below means that we won't get a perfect match with the report, but it will be close.
if sysmis(b3) xtemp = hv008 - (hv105 * 12).
if sysmis(b3) cmctemp = xtemp - trunc(rv.uniform(0,1)*12).
if sysmis(b3) school_age = trunc((cmcSch - cmctemp) / 12).

* Generate variables for whether the child is in the age group for primary or seconary school.
compute prim_age = range(school_age,age_prim_min,age_prim_max).
compute sec_age  = range(school_age,age_sec_min ,age_sec_max ).

* create the school attendance variables, not restricted by age.
compute prim = (hv122 = 1).
compute sec  = (hv122 = 2).

* set sample weight.
compute wt = hv005/1000000.
weight by wt.

* For NAR we can use this as just regular variables and can tabulate as follows, but can't do this for GAR as the numerator is not a subset of the denominator.
* NAR is just the proportion attending primary/secondary school of children in the correct age range, for de facto children.
if prim_age = 1 nar_prim = prim.
if sec_age  = 1 nar_sec  = sec.
variable labels nar_prim "Primary school net attendance ratio (NAR)".
variable labels nar_sec	"Secondary school net attendance ratio (NAR)".

* tabulate primary school attendance.
crosstabs hv104 hv025 by nar_prim
    /format = avalue tables
    /cells = row 
    /count asis.

* tabulate secondary school attendance.
crosstabs hv104 hv025 by nar_sec
    /format = avalue tables
    /cells = row 
    /count asis.

* Program for calculating NAR or GAR.
* NAR just uses a mean of one variable.
* GAR uses a ratio of two variables.

* Program to produce NAR or GAR for background characteristics (including total) for both sex, combined and separately.
  * parameters
  * type of rate - nar or gar
  * type of schooling - prim or sec
  * background variable for disaggregation.

define calc_nar (sch = !tokens(1) / backvar = !tokens(1))

* generates variables of the following format.
* ph_sch_`rate'_`sch'_`backvar'_`sex'.
* e.g. ph_sch_nar_prim_total_0.
* or   ph_sch_nar_sec_hv025_2.
* sex: 0 = both sexes combined, 1=male, 2=female.

* male.
if HV104=1 !concat('nar_',!sch,"_1") = !concat('nar_',!sch).
if HV104=1 !concat(!sch,"_1") = !concat(!sch).
if HV104=1 !concat(!sch,"_age_1") = !concat(!sch,"_age").
*female.
if HV104=2 !concat('nar_',!sch,"_2") = !concat('nar_',!sch).
if HV104=2 !concat(!sch,"_2") = !concat(!sch).
if HV104=2 !concat(!sch,"_age_2") = !concat(!sch,"_age").

* mean - used for NAR.
aggregate outfile = * mode = addvariables overwrite = yes
/break !backvar
/!concat ('ph_sch_nar_',!sch,'_',!backvar,"_0")=mean(!concat('nar_',!sch))
/!concat ('ph_sch_nar_',!sch,'_',!backvar,"_1")=mean(!concat('nar_',!sch,"_1"))
/!concat ('ph_sch_nar_',!sch,'_',!backvar,"_2")=mean(!concat('nar_',!sch,"_2")).

variable labels !concat ("ph_sch_nar_",!sch,"_",!backvar,"_0") !concat("NAR for ",!sch, " education for background characteristic ", !backvar, " for ", total). 
variable labels !concat ("ph_sch_nar_",!sch,"_",!backvar,"_1") !concat("NAR for ",!sch, " education for background characteristic ", !backvar, " for ", males). 
variable labels !concat ("ph_sch_nar_",!sch,"_",!backvar,"_2") !concat("NAR for ",!sch, " education for background characteristic ", !backvar, " for ", females). 

*gender parity index for a rate for a characteristic - female (2) rate divided by male (1) rate.
compute !concat("ph_sch_nar_",!sch,"_",!backvar,"_gpi") = !concat ('ph_sch_nar_',!sch,'_',!backvar,"_2") / !concat ('ph_sch_nar_',!sch,'_',!backvar,"_1").
variable labels !concat("ph_sch_nar_",!sch,"_",!backvar,"_gpi") !concat("gender parity index for NAR for ",!sch," education for background characteristic ",!backvar).

!enddefine.

define calc_gar (sch = !tokens(1) / backvar = !tokens(1))

* generates variables of the following format.
* ph_sch_`rate'_`sch'_`backvar'_`sex'.
* e.g. ph_sch_gar_prim_total_0.
* or   ph_sch_gar_sec_hv025_2.
* sex: 0 = both sexes combined, 1=male, 2=female.

* male.
if HV104=1 !concat(!sch,"_age_1") = !concat(!sch,"_age").
if HV104=1 !concat(!sch,"_1") = !concat(!sch).
*female.
if HV104=2 !concat(!sch,"_2") = !concat(!sch).
if HV104=2 !concat(!sch,"_age_2") = !concat(!sch,"_age").

*ratio - used for GAR.
aggregate outfile=* mode=addvariables overwrite = yes
/break !backvar
/!concat ("ph_sch_gar_",!sch,"_",!backvar,"_0_num")=sum(!sch)
/!concat ("ph_sch_gar_",!sch,"_",!backvar,"_1_num")=sum(!concat(!sch,"_1"))
/!concat ("ph_sch_gar_",!sch,"_",!backvar,"_2_num")=sum(!concat(!sch,"_2"))
/!concat ("ph_sch_gar_",!sch,"_",!backvar,"_0_den")=sum(!concat(!sch,"_age"))
/!concat ("ph_sch_gar_",!sch,"_",!backvar,"_1_den")=sum(!concat(!sch,"_age_1"))
/!concat ("ph_sch_gar_",!sch,"_",!backvar,"_2_den")=sum(!concat(!sch,"_age_2")).

compute !concat("ph_sch_gar_",!sch,"_",!backvar,"_0")=!concat("ph_sch_gar_",!sch,"_",!backvar,"_0_num")/!concat("ph_sch_gar_",!sch,"_",!backvar,"_0_den").
compute !concat("ph_sch_gar_",!sch,"_",!backvar,"_1")=!concat("ph_sch_gar_",!sch,"_",!backvar,"_1_num")/!concat("ph_sch_gar_",!sch,"_",!backvar,"_1_den").
compute !concat("ph_sch_gar_",!sch,"_",!backvar,"_2")=!concat("ph_sch_gar_",!sch,"_",!backvar,"_2_num")/!concat("ph_sch_gar_",!sch,"_",!backvar,"_2_den").

variable labels !concat ("ph_sch_gar_",!sch,"_",!backvar,"_0") !concat(!rate, " for ",!sch, "education for background characteristic ", !backvar, " for ", total). 
variable labels !concat ("ph_sch_gar_",!sch,"_",!backvar,"_1") !concat(!rate, " for ",!sch, "education for background characteristic ", !backvar, " for ", males). 
variable labels !concat ("ph_sch_gar_",!sch,"_",!backvar,"_2") !concat(!rate, " for ",!sch, "education for background characteristic ", !backvar, " for ", females). 

*gender parity index for a rate for a characteristic - female (2) rate divided by male (1) rate.
compute !concat("ph_sch_gar_",!sch,"_",!backvar,"_gpi") = !concat ('ph_sch_gar_',!sch,'_',!backvar,"_2") / !concat ('ph_sch_gar_',!sch,'_',!backvar,"_1").
variable labels !concat("ph_sch_gar_",!sch,"_",!backvar,"_gpi") !concat("gender parity index for GAR for ",!sch," education for background characteristic ",!backvar).

!enddefine.

compute total = 0.
variable labels total "Total".
value labels total 0 "Total".

* Caculate indicators and save them in the dataset.
calc_nar sch=prim backvar=total .  /* NAR primary   - total population */
calc_nar sch=prim backvar=hv025 .  /* NAR primary   - urban/rural */
calc_nar sch=prim backvar=hv024 .  /* NAR primary   - region */
calc_nar sch=prim backvar=hv270 .  /* NAR primary   - wealth index */

calc_nar sch=sec backvar=total .  /* NAR secondary   - total population */
calc_nar sch=sec backvar=hv025 .  /* NAR secondary   - urban/rural */
calc_nar sch=sec backvar=hv024 .  /* NAR secondary   - region */
calc_nar sch=sec backvar=hv270 .  /* NAR secondary   - wealth index */

calc_gar sch=prim backvar=total .  /* GAR primary   - total population */
calc_gar sch=prim backvar=hv025 .  /* GAR primary   - urban/rural */
calc_gar sch=prim backvar=hv024 .  /* GAR primary   - region */
calc_gar sch=prim backvar=hv270 .  /* GAR primary   - wealth index */

calc_gar sch=sec backvar=total .  /* GAR secondary   - total population */
calc_gar sch=sec backvar=hv025 .  /* GAR secondary   - urban/rural */
calc_gar sch=sec backvar=hv024 .  /* GAR secondary   - region */
calc_gar sch=sec backvar=hv270 .  /* GAR secondary   - wealth index */


*****************************************************************************************************
*****************************************************************************************************

output close *.

*Tabulating indicators by background variables and exporting estimates to excel table Tables_edu.
*the tabulations will provide the estimates for the indicators for the total, males, and females and by hv025, hv024, and hv270.

*Primary school net attendance ratio (NAR) and gender parity index.
spssinc select variables macroname="!PrimaryNARVars"  
  /properties pattern="ph_sch_nar_prim*"/options separator=", ".

frequencies variables !PrimaryNARVars.

*Secondary school net attendance ratio (NAR) and gender parity index.
spssinc select variables macroname="!SecondaryNARVars"  
  /properties pattern="ph_sch_nar_sec*"/options separator=", ".

frequencies variables !SecondaryNARVars.

*Primary school gross attendance ratio (GAR) and gender parity index.
spssinc select variables macroname="!PrimaryGARVars"  
  /properties pattern="ph_sch_gar_prim*"/options separator=", ".

frequencies variables !PrimaryGARVars.
 	
*Secondary school gross attendance ratio (GAR) and gender parity index.
spssinc select variables macroname="!SecondaryGARVars"  
  /properties pattern="ph_sch_gar_sec*"/options separator=", ".

frequencies variables !SecondaryGARVars.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_schol.xls"
     operation=createfile.

output close * .

new file.

erase file =  datapath + "\tempBR.sav".


