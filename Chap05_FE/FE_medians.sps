* Encoding: UTF-8.
* Encoding: .
* Encoding: .
*****************************************************************************************************/
*******************************************************************************
Program: 				FE_medians.sps
Purpose: 				Creates the indicators for median duration of amenorrhea,
						postpartum abstinence, and pp insusceptibility Fertility 
						Chapter	using the KR file (the cases are births)
Data outputs:			coded variables, table output on screen, and in excel tables
Author: 				Tom Pullum and Courtney Allen, translated to SPSS by Ivana Bjelic
Date last modified:		August 26 2020 by Ivana Bjelic

*******************************************************************************

* Notes -----------------------------------------------------------------------
	- Children from multiple births are dropped, except for the first one; drop if b0>1

 * 	- "months_since_birth" is b19 (is age in months if the child is alive)

 * 	- In surveys that do not include b19, months_since_birth is v008-b3

 * 	- group2 is a grouping into 2-month intervals

 * 	- DHS_phase is the version of DHS.  Could be taken from the 3rd character of
	  v000 but is based on whether b19 is present;
	  just use DHS_phase=6 if it is not and DHSphase=7 if it is present.  
 * 	  Only relevant for the midpoints of group2.

 * 	- Midpoints:
		For DHS6, the midpoints are supposed to be .75, 2.5, 4.5, 6.5, etc.
 * 		For DHS7, the midpoints are supposed to be 1, 3, 5, 7, etc.

 * 	- It is possible that b19 is present but the DHS6 coding is used for the 
	  midpoints (such as in ET 2016 survey).
 * ------------------------------------------------------------------------------.


get file =  datapath + "\"+ krdata + ".sav"/keep caseid v000 to v046 BIDX to b20 v405 v406 v106 v190.

*********************************************************************
*create var to generate filename.
string scid (a2).
compute scid = lower ( char.substr(krdata,1,2) ).

string spv (a2).
compute spv = lower ( char.substr(krdata,5,2) ).

 * 	local lcid=scid
	local lpv=spv

*Identify the correct children and construct the two relevant age distributions.
	* v405: Currently amenorrheic
	* v406: Currently abstaining.


*NOTE ---------------------------------------------------------------------
It is essential to identify the phase. This is equivalent to finding 
whether b19 is in the data. If it is not, and b3-v008 is used instead of
b19 to get the child's current age in months, then an adjustment of .5 
has to be made
The variable "DHS_phase" is set at 6 (for <=6) or 7 (for >=7)
--------------------------------------------------------------------------.
*Set DHS_phase at 6 for <=6 or at 7 for >=7.

compute DHS_phase=7.
*capture confirm numeric variable b19, exact.
begin program.
import spss, spssaux
varList = "b19"
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
  /b19_included=mean(b19).

recode b19_included (lo thru hi = 1)(else = 0).
if b19_included=0 DHS_phase=6.

*For DHS-6 and earlier.
if DHS_phase<=6 months_since_birth=v008-b3.

*For DHS-7 and later.
if DHS_phase>=7 months_since_birth=b19.

*SPECIAL LINE MAY BE NEEDED FOR UNIQUE SURVEYS, LIKE ET71.
if scid="ET" & spv="71" DHS_phase=6.

* group2 is the code for the two-month age groups: 0-1, 2-3, etc.
* Needed for overall value.
if months_since_birth<=35 group2=1+trunc(months_since_birth/2).
select if not sysmis(group2).

*midpoint2 (before smoothing) is not needed, but if it were, this is what it would be.
*compute midpoint2=2*group2-1.
	
value labels group2 	1 "0-1"    2 "2-3"    3 "4-5"    4 "6-7"    5 "8-9" 6 "10-11"  7 "12-13"  8 "14-15"  9 "16-17" 10 "18-19"  	
	                  11 "20-21" 12 "22-23" 13 "24-25" 14 "26-27" 15 "28-29" 16 "30-31" 17 "32-33" 18 "34-35" 100 "Total" 200 "Median" 300 "Mean".


* create unweighted and weighted denominators.
compute unwtdn=1.
compute wtdn=v005/1000000.

compute iweight=v005/1000000.
weight by iweight.
crosstabs  bidx by b0.
weight off.

* NOTE FOR FOLLOWING CODE--------------------------------------------------
Table 5.6 refers children born in the past 36 months but does not duplicate 
children from multiple births
I want to keep singletons and the LAST birth of a set of multiple births, 
but I cannot tell whether a birth is the most recent or LAST birth of a 
set of multiple births unless I develop another code for the number of 
births in a multiple birth. 
*----------------------------------------------------------------------------------------------------

* Break to calculate a code for the number of births in a multiple birth.
compute n_tuple=1.
aggregate outfile = * mode = addvariables overwrite = yes
/break v001 v002 v003 months_since_birth
/n_tuple=sum(n_tuple).

frequencies n_tuple.

sort cases by v001 v002 v003 bidx b0.

* Now we can select on singletons or the last birth in n-tuple.
select if b0=0 or b0=n_tuple.

* NOTE ------------------------------------------------------------------------
following code does not match with m6=96 for amenorrheic; must use v405=1 to 
get a match. DOES match with m8=96 for abstaining, but use v406=1 for consistency
-----------------------------------------------------------------------------------.

compute amen = 0.
compute abst = 0.
compute insusc = 0.

*****************************************************************
* IMPORTANT: construction of amen, abst, and insusc
*****************************************************************.
if bidx=1 & v405=1 amen=1.
if bidx=1 & v406=1 abst=1.
if amen>0 or abst>0 insusc=1.

compute pct_amen_wtd = 100*amen*wtdn.
compute pct_abst_wtd = 100*abst*wtdn.
compute pct_insusc_wtd = 100*insusc*wtdn.

compute All1=1.
variable labels All1 "All".
save outfile = "temp1_recodes.sav".

********************************************************************************

* NOTE --------------------------------------------------------------------
This table should reflect DHS standard table 5.7
-------------------------------------------------------------------------------.

* Construct the table with collapse (a second time to get total, and a third time to get a mean) and save to excel; not the only way to do it!

get file = "temp1_recodes.sav".

aggregate outifile = "temp2_recodes.sav"
/break group2
/pct_amen_wtd=sum(pct_amen_wtd)
/pct_abst_wtd=sum(pct_abst_wtd)
/pct_insusc_wtd=sum(pct_insusc_wtd)
/wtdn=sum(wtdn)
/unwtdn=sum(unwtdn)
/DHS_phase=mean(DHS_phase).

get file =  "temp2_recodes.sav".

*calculate percentages for each outcome by group.
compute pct_amen=pct_amen_wtd/wtdn.
compute pct_abst=pct_abst_wtd/wtdn.
compute pct_insusc=pct_insusc_wtd/wtdn.

save outfile = "temp2_recodes.sav".

*calculate total percentages.
get file = "temp1_recodes.sav".

aggregate outifile =  "temp3_recodes.sav"
/break 
/pct_amen_wtd=sum(pct_amen_wtd)
/pct_abst_wtd=sum(pct_abst_wtd)
/pct_insusc_wtd=sum(pct_insusc_wtd)
/wtdn=sum(wtdn)
/unwtdn=sum(unwtdn)
/DHS_phase=mean(DHS_phase).

get file =  "temp3_recodes.sav".

compute pct_amen=pct_amen_wtd/wtdn.
compute pct_abst=pct_abst_wtd/wtdn.
compute pct_insusc=pct_insusc_wtd/wtdn.

compute group2=100.
add files
/file = *
/file =  "temp2_recodes.sav".

save outfile = "temp3_recodes.sav".

*create means.
*NOTE -----------------------------------------------------------------
For means calculate the sum of each weighted percentage, times by the 
appropropriate width (either 0.75, 1.5, 1.75, or 2) and divide by 100, 
for the so-called "Mean"
--------------------------------------------------------------------------.

get file = "temp2_recodes.sav".

*create widths according to DHS6 or DHS7 (see Guide to DHS Statistics for more explanation).
*For DHS-6 and earlier.
do if DHS_phase<=6.
+ compute width = 2.
+ if group2=1 width = 0.75.
+ if group2=2 width = 1.50.
+ if group2=3 width = 1.75. 
+ compute width1 = 0.75.
end if.

*For DHS-6 and earlier.
do if DHS_phase>=7.
+ compute width = 2.
+ compute width1 = 1.
end if.
		
* multiply the proportion of each outcome by the width.
compute pct_amen=(pct_amen/100)*width.
compute pct_abst=(pct_abst/100)*width.
compute pct_insusc=(pct_insusc/100)*width.

*sum to create the means.
aggregate outfile = "temp4_recodes.sav"
/break
/pct_amen=sum(pct_amen)
/pct_abst=sum(pct_abst)
/pct_insusc=sum(pct_insusc)
/wtdn=sum(wtdn)
/unwtdn=sum(unwtdn)
/DHS_phase=mean(DHS_phase)
/width1 = mean (width1).

get file = "temp4_recodes.sav".

compute pct_amen=pct_amen + width1.
compute pct_abst=pct_abst + width1.
compute pct_insusc=pct_insusc + width1.

compute group2=300.
add files
/file = *
/file =  "temp3_recodes.sav".

* Note that pct_amen, pct_abst and pct_insusc are weighted but the suffix _wtd has been dropped.
save outfile =  workingpath + "FE_5pt6.sav"/keep group2 pct_amen pct_abst pct_insusc unwtdn wtdn.
get file = workingpath + "FE_5pt6.sav".

formats unwtdn(f9.0).
formats wtdn(f9.0).

value labels group2 	1 "0-1"    2 "2-3"    3 "4-5"    4 "6-7"    5 "8-9" 6 "10-11"  7 "12-13"  8 "14-15"  9 "16-17" 10 "18-19"  	
	                  11 "20-21" 12 "22-23" 13 "24-25" 14 "26-27" 15 "28-29" 16 "30-31" 17 "32-33" 18 "34-35" 100 "Total" 200 "Median" 300 "Mean".

save translate outfile=workingpath + "\Tables_FE_5pt6.xlsx"
  /type=xls
  /version=12
  /fieldnames value=labels
  /cells=labels
  /replace.

*NOTE --------------------------------------------------------------------
The overall median appears in both tables 5.6 and 5.7; is calculated with 
the other numbers for 5.7
--------------------------------------------------------------------------------.
 

*********************************************************************


*NOTE --------------------------------------------------------------------
The following procedure reproduces the smoothing with a moving average described
in the Guide to DHS Statistics. 
*	
It constructs group2_smoothed, median2_smoothed, and wt_smoothed.
*
Runs on the smoothed data should use group2_smoothed in place of group2 
(and median2_smoothed in place of median2) and should use wt_smoothed in place
of wt_original (usually v005).
*
It is not necessary to repeat this smoothing for different outcomes
v005 is an integer but wt_smoothed (which also includes a factor of 1000000) 
may not be an integer
*
It will still be possible to produce the original distribution using group2 
(or median2) and wt.
 *  ----------------------------------------------------------------------------.

get file = "temp1_recodes.sav".

aggregate outfile = * mode=addvariables overwrite = yes
/sgroup2_max=max(group2).

compute sgroup2_min=1.

compute wt=v005.

save outfile = "temp.sav".

compute triplet=1.

add files /file = * /file = "temp.sav".
if sysmis(triplet) triplet=2.
add files /file = * /file = "temp.sav".
if sysmis(triplet) triplet=3.

compute group2_smoothed=$sysmis.
if triplet=1 group2_smoothed=group2.
if triplet=2 group2_smoothed=group2+1.
if triplet=3 group2_smoothed=group2-1.

if group2_smoothed<sgroup2_min or group2_smoothed>sgroup2_max group2_smoothed=$sysmis.
if (group2_smoothed=sgroup2_min & triplet>1) or (group2_smoothed=sgroup2_max & triplet>1) group2_smoothed=$sysmis.

* DHS7+ midpoints.
if DHS_phase>=7 midpoint2_smoothed=2*group2_smoothed-1.

* DHS6 and earlier midpoints (and exceptions during DHS7).
do if DHS_phase<=6.
+ compute midpoint2_smoothed=2*group2_smoothed-1.5.
+ if group2_smoothed=1 midpoint2_smoothed=0.75.
end if.

compute wt_smoothed=0.
if group2_smoothed>sgroup2_min  & group2_smoothed<sgroup2_max wt_smoothed=wt/3.
if group2_smoothed=sgroup2_min or group2_smoothed=sgroup2_max wt_smoothed=wt.

* Table with smoothed age or duration distribution, with the median for each row.
compute iweight=wt_smoothed/1000000.
weight by iweight.
frequencies midpoint2_smoothed.

*
* If desired, numbers similiar to those in table 5.6 but with the smoothed distribution.
crosstabs midpoint2_smoothed by amen /cells=row.
crosstabs midpoint2_smoothed by abst /cells=row.
crosstabs midpoint2_smoothed by insusc /cells=row.

value labels group2_smoothed  1 "0-1"    2 "2-3"    3 "4-5"    4 "6-7"    5 "8-9" 6 "10-11"  7 "12-13"  8 "14-15"  9 "16-17" 10 "18-19"  	
	                  11 "20-21" 12 "22-23" 13 "24-25" 14 "26-27" 15 "28-29" 16 "30-31" 17 "32-33" 18 "34-35" 100 "Total" 200 "Median" 300 "Mean".

crosstabs group2_smoothed by amen /cells=row.
crosstabs group2_smoothed by abst /cells=row.
crosstabs group2_smoothed by insusc /cells=row.

compute mo_age=1.
if v013>=4 mo_age=2.
value labels mo_age 1 "15-29" 2 "30-49".

* These lines specify the variables used in "calc_median".
compute x=midpoint2_smoothed.
compute y=$sysmis.
compute wt_temp=wt_smoothed.

compute pct_amen=100*amen.
compute pct_abst=100*abst.
compute pct_insusc=100*insusc.

save outfile = "temp_smoothed.sav".
*

*********************************************************************.

define calc_median (backvar = !tokens(1)).

*NOTE --------------------------------------------------------------------
This version of calc_median is for a current status variable which declines 
with duration, such as EBF or amenorrhea.
*	
For a current status variable it is possible that the decline is not monotonic,
so we must find the first value of x for which the percentage having the outcome
y is LESS THAN than 50%.
*
x is the measure of duration
y is the outcome, coded 0 and 100 (100, not 1!)
wt_temp is the weight variable
*
sL and sU are the values that straddle the median:
sL is the highest value of x for which the % is <50
sU is the  lowest value of x for which the % is >50
------------------------------------------------------------------------.

get file = "temp_smoothed.sav".

* weight the data by the weight.
compute iweight=wt_temp/1000000.
weight by iweight.

aggregate
  /outfile= !quote ( !concat("temp_", !backvar,".sav") )
  /break= !backvar group2_smoothed
  /midpoint2_smoothed= mean(midpoint2_smoothed)
  /pct_amen=mean(pct_amen)
  /pct_abst=mean(pct_abst)
  /pct_insusc=mean(pct_insusc).

get file =  !quote ( !concat("temp_", !backvar,".sav") ).

* calculation of median - interpolate between groups where percentage drops below 50 percent.
sort cases by !backvar.
split file by !backvar.
*amen.
do if (pct_amen <= 50 and lag(pct_amen) > 50).
+compute sL_y= lag(pct_amen).
+compute sU_y= pct_amen.
+compute sL_x=lag(midpoint2_smoothed).
+compute sU_x=midpoint2_smoothed.
+compute amen_median=sL_x+(sU_x-sL_x)*(50-sL_y)/(sU_y-sL_y).
end if.

* replace median with O and label "NA" if no median can be calculated for group.
if sU_y>50 amen_median = 0.
value labels amen_median 0 "NA".

*abst.
do if (pct_abst <= 50 and lag(pct_abst) > 50).
+compute sL_y= lag(pct_abst).
+compute sU_y= pct_abst.
+compute sL_x=lag(midpoint2_smoothed).
+compute sU_x=midpoint2_smoothed.
+compute abst_median=sL_x+(sU_x-sL_x)*(50-sL_y)/(sU_y-sL_y).
end if.

* replace median with O and label "NA" if no median can be calculated for group.
if sU_y>50 abst_median = 0.
value labels abst_median 0 "NA".

*insusc.
do if (pct_insusc <= 50 and lag(pct_insusc) > 50).
+compute sL_y= lag(pct_insusc).
+compute sU_y= pct_insusc.
+compute sL_x=lag(midpoint2_smoothed).
+compute sU_x=midpoint2_smoothed.
+compute insusc_median=sL_x+(sU_x-sL_x)*(50-sL_y)/(sU_y-sL_y).
end if.

* replace median with O and label "NA" if no median can be calculated for group.
if sU_y>50 insusc_median = 0.
value labels insusc_median 0 "NA".

split file off.

aggregate 
 /outfile = !quote ( !concat("tmpres_", !backvar,".sav") )
 /break = !backvar
 /amen_median= mean(amen_median)
 /abst_median= mean(abst_median)
 /insusc_median= mean(insusc_median).

get file = !quote ( !concat("tmpres_", !backvar,".sav") ).

!if (!backvar<>All1) !then
add files
  /file='FE_5pt7.sav'
  /file= !quote ( !concat("tmpres_", !backvar,".sav") ).
!ifend.

save outfile = 'FE_5pt7.sav'.
erase file = !quote ( !concat("temp_", !backvar,".sav") ).
erase file =!quote ( !concat("tmpres_", !backvar,".sav") ).

!enddefine.

*NOTE ---------------------------------------------------------------------
The following groups of lines are a  way to get the medians for subgroups of
covariates.	Labels are not included
It is not necessary to repeat the smoothing for different covariates
--------------------------------------------------------------------------.
calc_median backvar = All1.
calc_median backvar = mo_age.
calc_median backvar = v024.
calc_median backvar = v025.
calc_median backvar = v106.
calc_median backvar = v190.

*******************************************************

*NOTE ---------------------------------------------------------------------
This table should reflect DHS standard table 5.7
For this table, use the two-month grouping (group2), as on page 1.46 of the 
Guide to DHS Statistics (https://dhsprogram.com/Data/Guide-to-DHS-Statistics/index.cfm), 
with a 3-interval moving total for the numerators and denominators separately
Here it is implemented with a revised case-level weight
-----------------------------------------------------------------------------------

* Note: this table does not include labels.
ctables /table All1 [c] + mo_age [c] + v024 [c] + v025 [c] + v106 [c] + v190 [c] by amen_median [s][mean,'',f5.1] + abst_median [s][mean,'',f5.1] + insusc_median [s][mean,'',f5.1].

* Alternatively, save the FE_5pt7.sav fie in excel format in case cstables command is not supported.
*save translate outfile=workingpath + "\Tables_FE_5pt7.xlsx"
  /type=xls
  /version=12
  /fieldnames value=labels
  /cells=labels
  /replace.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx documentfile="Tables_FE_5pt7.xlsx"
     operation=createfile.

output close * .

new file.

*get rid of extra files.
erase file = "temp_smoothed.sav".
erase file = "temp1_recodes.sav".
erase file = "temp2_recodes.sav".
erase file = "temp3_recodes.sav".
erase file = "temp4_recodes.sav".
