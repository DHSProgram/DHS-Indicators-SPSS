* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FE_ASFR_10_14.sps
Purpose: 			Code to compute fertility rates
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:			Thomas Pullum and modified by Courtney Allen for the code share project and translated to SPSS by Ivana Bjelic
Date last modified: April 21 2021 by Ivana Bjelic
Note:				
			This sps file will produce a table of ASFRs for age group 10-14 by background variables as shown in final report, and 3 and 5 years time periods (Tables_FE_ASFR_10-14.xlsx). 
*****************************************************************************************************/


*GO TO THE MULTIPLE LINES OF ASTERISKS FOR THE BEGINNING OF THE EXECUTABLE STATEMENTS

*______________________________NOTES___________________________________________

*VARIABLES CREATED IN THIS PROGRAM:
	fe_asfr10_14	"age specific fertility rates for 10-14 yr olds"
                  fe_ASFR_10                  "rates for single year 10"
                  fe_ASFR_11                  "rates for single year 11"
                  fe_ASFR_12                  "rates for single year 12"
                  fe_ASFR_13                  "rates for single year 13"
                  fe_ASFR_14                  "rates for single year 14"

	
*OUTPUT FILES:
	FE_ASFR_10-14.sav         : asfrs

*	Note: the main output files must be renamed or they will be over-written the
	next time the program is run


*CRUCIAL VARIABLES USED (IN DHS NAMES)
	The input file has one record for each woman, including all women 15-49,
	regardless of whether they have had any children.

*	caseid	 "Case Identification"
	v001            "Cluster number"
	v005            "Sample weight"
	v008            "Date of interview (CMC)"
	v011            "Date of birth (CMC)"
	b3_*            "Date of birth (CMC)"
	v201            "Total children ever born".


*ABOUT THIS PROGRAM
	This is a version of the 10-14 fertility rates program that runs on a single
	survey and only gives the Lexis method described in Methodological Report 23.

*	This version will calculate rates for single years of age 10-14 and the pooled 
	rates for intervals of 10-14, 12-14.
	
*	This version will produce rates, births, and exposure, for SINGLE YEARS years
	10 through 14 for the past five years.
	
*	The full fertility rates program is reduced and ONLY produces asfrs, no TFR or GFR

*	It can use alternative re-weighting approaches to the censoring effect
	
*	This version can be used on ever-married surveys.

*	These rates can also be interpreted as the probability that a girl will have
	a birth at each single year of age.

*	There are modifications to the general fertility rates program involving the 
	start age in months (120 instead of 180) and the age width in months (12 
	instead of 60).


*COUNTRY SPECIFIC NOTES:

 * 	- In PE6I (Peru) it is necessary to use a subhousehold code that is column 12
	of hhid and column 9 of caseid. 
	
 * 	- In IA (India) it is necessary to include region in the id codes.

*______________________________________________________________________________*/

define setup().

* PREPARE THE MAIN FILE FOR REPEATED RUNS.

rename variables v008 = doi.
rename variables v011 = dob.
rename variables v201 = ceb.
formats ceb (f5.3).

* curageint is important, in part because the calculation is different if this is the woman's age at interview.

**************************************************************
Under 15: 5 single years of age, 10 through 14 (5 intervals) 
as part of this modification, agestart is changed from 180 months to 120
and the width of the interval is changed from 60 months to 12 
and the number of age intervals is changed from 7 to 5
**************************************************************.

compute nageints=5.

* The starting age is 10 years (120 months) and the intervals are one year:.

compute curageint=trunc((doi-dob)/12)-9.

save outfile = "fertilitydata.sav".

!enddefine.

******************************************************************************.

define make_ucmc_lcmc().

* convert lw and uw to cmc's.

* note that lw and uw will be <=0 for "years before survey".
do if lw<=0.

* coding that WILL NOT include the month of interview in the most recent interval;
* this matches with DHS results.

+compute lcmc=doi+12*lw-12.
+compute ucmc=doi+12*uw-1.
end if.

do if lw>0.
* lw and uw will be >0 for "calendar years".
+compute lcmc=12*(lw-1900)+1.
+compute ucmc=12*(uw-1900)+12.
end if.
	
compute ucmc=min(ucmc,doi).

* calculate the reference date.
compute iweight=v005/1000000.
weight by iweight.
aggregate outfile = * mode = addvariables overwrite = yes
/break
/mean_start_month=mean(lcmc)
/mean_end_month=mean(ucmc)
/mean_doi=mean(doi).

* Convert back to continuous time, which requires an adjustment of half a month (i.e. -1/24).
* This adjustment is not often made but should be.
compute refdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12.
compute mean_doi=1900-(1/24)+mean_doi/12.

!enddefine.

******************************************************************************.

define make_exposure(backvar = !tokens(1)).

* CALCULATE EXPOSURE TO AGE INTERVALS WITHIN THE WINDOW, IN MONTHS

* IMPORTANT: THIS VERSION WILL ASSUME INTERVALS OF WIDTH ONE YEAR.

* THIS VERSION USES AWFACTT BY INFLATING THE EXPOSURE BY AWFACTT/100 FOR TOTAL OR AWFACTU/100 FOR V025.

get file = "fertilitydata.sav".

make_ucmc_lcmc.

*specify starting age in months (12*S).
*compute agestart1=180.
compute agestart1=120.

* if the width of the age interval is 5 years (60 months).
*compute agestart2=agestart1+60.
*compute agestart3=agestart2+60.
*compute agestart4=agestart4+60.
*compute agestart5=agestart5+60.

* if the width of the age interval is 1 year (12 months).
compute agestart2=agestart1+12.
compute agestart3=agestart2+12.
compute agestart4=agestart3+12.
compute agestart5=agestart4+12.

* NOTE THE ASSUMPTION OF ONE-YEAR AGE INTERVALS.

* if the width of the age interval is 5 years (60 months).
* compute mexp1=min(doi,ucmc,dob+agestart1+59)-max(lcmc,dob+agestart1)+1.
* compute mexp2=min(doi,ucmc,dob+agestart2+59)-max(lcmc,dob+agestart2)+1.
* compute mexp3=min(doi,ucmc,dob+agestart3+59)-max(lcmc,dob+agestart3)+1.
* compute mexp4=min(doi,ucmc,dob+agestart4+59)-max(lcmc,dob+agestart4)+1.
* compute mexp5=min(doi,ucmc,dob+agestart5+59)-max(lcmc,dob+agestart5)+1.

* if the width of the age interval is 1 year (12 months).
compute mexp1=min(doi,ucmc,dob+agestart1+11)-max(lcmc,dob+agestart1)+1.
compute mexp2=min(doi,ucmc,dob+agestart2+11)-max(lcmc,dob+agestart2)+1.
compute mexp3=min(doi,ucmc,dob+agestart3+11)-max(lcmc,dob+agestart3)+1.
compute mexp4=min(doi,ucmc,dob+agestart4+11)-max(lcmc,dob+agestart4)+1.
compute mexp5=min(doi,ucmc,dob+agestart5+11)-max(lcmc,dob+agestart5)+1.

if mexp1<0 mexp1=0.
if mexp2<0 mexp2=0.
if mexp3<0 mexp3=0.
if mexp4<0 mexp4=0.
if mexp5<0 mexp5=0.

**************************************************************
must make an adjustment if doi is the last month in an interval
in that case, half a month must be deducted, under the assumption 
that the interview was in the middle of the month
find the current age interval and subtract half a month of exposure
**************************************************************.

if ucmc>=doi & curageint=1 mexp1=mexp1-0.5. 
if ucmc>=doi & curageint=2 mexp2=mexp2-0.5. 
if ucmc>=doi & curageint=3 mexp3=mexp3-0.5. 
if ucmc>=doi & curageint=4 mexp4=mexp4-0.5. 
if ucmc>=doi & curageint=5 mexp5=mexp5-0.5. 

* MULTIPY EXPOSURE BY AWFACTT/100 FOR TOTAL.
!if (!backvar=total) !then
+ compute mexp1=mexp1*(awfactt/100).
+ compute mexp2=mexp2*(awfactt/100).
+ compute mexp3=mexp3*(awfactt/100).
+ compute mexp4=mexp4*(awfactt/100).
+ compute mexp5=mexp5*(awfactt/100).
!ifend
* MULTIPY EXPOSURE BY AWFACTU/100 FOR V025.
!if (!backvar=V025) !then
+ compute mexp1=mexp1*(awfactu/100).
+ compute mexp2=mexp2*(awfactu/100).
+ compute mexp3=mexp3*(awfactu/100).
+ compute mexp4=mexp4*(awfactu/100).
+ compute mexp5=mexp5*(awfactu/100).
!ifend

sort cases by caseid.
save outfile = "exposure.sav".

!enddefine.

******************************************************************************

define make_births().

* MAKE FILE OF ALL BIRTHS.

get file = "fertilitydata.sav".

make_ucmc_lcmc.

sort cases by caseid.

save outfile = "tmpfert.sav"/keep caseid B3$01 to B3$20 dob lcmc ucmc.
get file = "tmpfert.sav".
weight off.

varstocases
  /make b3 from b3$01 to b3$20
  /keep=caseid dob lcmc ucmc
  /null=drop.

select if not sysmis(b3).

rename variables (b3=cmcbirth).
sort cases by caseid.
save outfile = "births.sav".

* drop births that lie outside the window.
select if not (cmcbirth<lcmc or cmcbirth>ucmc).

*calculate births in age intervals within the window.

*specify starting age in months (12*S).
*compute agestart1=180.
compute agestart1=120.

compute births1=0.
compute births2=0.
compute births3=0.
compute births4=0.
compute births5=0.

* the following lines are used if the age interval is 5 years.
*if cmcbirth<=dob+agestart1+59 & cmcbirth>=dob+agestart1 births1=births1+1.
*compute agestart2=agestart1+60.
*if cmcbirth<=dob+agestart2+59 & cmcbirth>=dob+agestart2 births2=births2+1.
*compute agestart3=agestart2+60.
*if cmcbirth<=dob+agestart3+59 & cmcbirth>=dob+agestart3 births3=births3+1.
*compute agestart4=agestart3+60.
*if cmcbirth<=dob+agestart4+59 & cmcbirth>=dob+agestart4 births4=births4+1.
*compute agestart5=agestart4+60.
*if cmcbirth<=dob+agestart5+59 & cmcbirth>=dob+agestart5 births5=births5+1.

* the following lines are used if the age interval is 1 year.
if cmcbirth<=dob+agestart1+11 & cmcbirth>=dob+agestart1 births1=births1+1.
compute agestart2=agestart1+12.
if cmcbirth<=dob+agestart2+11 & cmcbirth>=dob+agestart2 births2=births2+1.
compute agestart3=agestart2+12.
if cmcbirth<=dob+agestart3+11 & cmcbirth>=dob+agestart3 births3=births3+1.
compute agestart4=agestart3+12.
if cmcbirth<=dob+agestart4+11 & cmcbirth>=dob+agestart4 births4=births4+1.
compute agestart5=agestart4+12.
if cmcbirth<=dob+agestart5+11 & cmcbirth>=dob+agestart5 births5=births5+1.

aggregate outfile="tmpbirths.sav"
/break = caseid
/births1=sum(births1)
/births2=sum(births2)
/births3=sum(births3)
/births4=sum(births4)
/births5=sum(births5).

get file = "tmpbirths.sav".
save outfile = "births.sav".

erase file = "tmpfert.sav".
erase file = "tmpbirths.sav".

!enddefine.

******************************************************************************.

define make_exposure_and_births (backvar = !tokens(1)).

make_exposure backvar = !backvar.
make_births.

get file = "exposure.sav".
match files file=*
/file="births.sav"
/by caseid.

*/
section to calculate weighted numerators and denominators
to calculate rates in the conventional way
*/

compute weight=v005/1000000.

compute births_wtd1=births1*weight.
compute yexp_wtd1=mexp1*weight/12.
compute births_wtd2=births2*weight.
compute yexp_wtd2=mexp2*weight/12.
compute births_wtd3=births3*weight.
compute yexp_wtd3=mexp3*weight/12.
compute births_wtd4=births4*weight.
compute yexp_wtd4=mexp4*weight/12.
compute births_wtd5=births5*weight.
compute yexp_wtd5=mexp5*weight/12.

if mexp1=0 births1=$sysmis.
if mexp2=0 births2=$sysmis.
if mexp3=0 births3=$sysmis.
if mexp4=0 births4=$sysmis.
if mexp5=0 births5=$sysmis.

if sysmis(births1) & mexp1>0 births1=0.
if sysmis(births2) & mexp2>0 births2=0.
if sysmis(births3) & mexp3>0 births3=0.
if sysmis(births4) & mexp4>0 births4=0.
if sysmis(births5) & mexp5>0 births5=0.
execute.

* Calculate the number of births and years of exposure (weighted).
aggregate outfile = * mode = addvariables overwrite = yes
/break !backvar
/sbirths1 = sum(births_wtd1)
/sbirths2 = sum(births_wtd2)
/sbirths3 = sum(births_wtd3)
/sbirths4 = sum(births_wtd4)
/sbirths5 = sum(births_wtd5).

* Distinguish exposure according to source.
* Calculate exposure from the IR file; this will always be the 
*  denominator for the single-year rates.
aggregate outfile = * mode = addvariables overwrite = yes
/break !backvar
/syrsexp1 = sum(yexp_wtd1)
/syrsexp2 = sum(yexp_wtd2)
/syrsexp3 = sum(yexp_wtd3)
/syrsexp4 = sum(yexp_wtd4)
/syrsexp5 = sum(yexp_wtd5).

sort cases by caseid.

string sint(a4).
variable labels sint "Interval".
if lw=-2 sint="3yrs".
if lw=-4 sint="5yrs".

save outfile = "exposure_and_births.sav".

!enddefine.

******************************************************************************.

define calc_rates (backvar = !tokens(1)).

**************************************************************
This version calculates just the single-year rates for ages 
10, 11, 12, 13, 14.
*
It loops through all the values of the 
categorical variable called "covariate"; for "All", there is only
one value, 1.
*
The selection of categories is done with "subpop" within svy
For calculating standard errors, this is preferable to the 
alternatives, such as "if...." .
*
The most crucial lines are enclosed in short lines of asterisks.
***************************************************************.

get file = "exposure_and_births.sav".

string womanid (a20).
compute womanid=caseid.
execute.

* Age-specific rates.

* This file has one record with births and exposure for each age interval for each woman.

* The rates for single years 10 through 14 are named fe_ASFR_10, fe_ASFR_11, fe_ASFR_12, fe_ASFR_13 and fe_ASFR_14.

* fe_ASFR_10to14 is the rate for ages 10-14.

do if lw=-2.

*SEGMENT FOR RE-WEIGHTING FOR THE PAST THREE YEARS.
* Use the Lexis Diagram.
+compute sbirths3=sbirths3*6/1.
+compute sbirths4=sbirths4*6/3.
+compute sbirths5=sbirths5*6/5.
+compute sbirths345=sbirths3+sbirths4+sbirths5.

+compute syrsexp3=syrsexp3*6/1.
+compute syrsexp4=syrsexp4*6/3.
+compute syrsexp5=syrsexp5*6/5.
+compute syrsexp345=(syrsexp3+syrsexp4+syrsexp5) * 5/3.

+compute  fe_ASFR_10=0.
+if syrsexp1>0  fe_ASFR_10=1000*sbirths1/syrsexp1.
+compute  fe_ASFR_11=0.
+if syrsexp2>0  fe_ASFR_11=1000*sbirths2/syrsexp2.
+compute fe_ASFR_12=0.
+if syrsexp3>0  fe_ASFR_12=1000*sbirths3/syrsexp3.
+compute fe_ASFR_13=0.
+if syrsexp4>0  fe_ASFR_13=1000*sbirths4/syrsexp4.
+compute fe_ASFR_14=0.
+if syrsexp5>0  fe_ASFR_14=1000*sbirths5/syrsexp5.

+compute fe_ASFR_10to14=1000*sbirths345/syrsexp345.

end if.	

do if lw=-4.
*SEGMENT FOR RE-WEIGHTING FOR THE PAST FIVE YEARS.
* Use the Lexis Diagram.
+compute sbirths1=sbirths1*10/1.
+compute sbirths2=sbirths2*10/3.
+compute sbirths3=sbirths3*10/5.
+compute sbirths4=sbirths4*10/7.
+compute sbirths5=sbirths5*10/9.
+compute sbirths12345=sbirths1+sbirths2+sbirths3+sbirths4+sbirths5.

+compute syrsexp1=syrsexp1*10/1.
+compute syrsexp2=syrsexp2*10/3.
+compute syrsexp3=syrsexp3*10/5.
+compute syrsexp4=syrsexp4*10/7.
+compute syrsexp5=syrsexp5*10/9.
+compute syrsexp12345=syrsexp1+syrsexp2+syrsexp3+syrsexp4+syrsexp5.

+compute  fe_ASFR_10=0.
+if syrsexp1>0  fe_ASFR_10=1000*sbirths1/syrsexp1.
+compute  fe_ASFR_11=0.
+if syrsexp2>0  fe_ASFR_11=1000*sbirths2/syrsexp2.
+compute fe_ASFR_12=0.
+if syrsexp3>0  fe_ASFR_12=1000*sbirths3/syrsexp3.
+compute fe_ASFR_13=0.
+if syrsexp4>0  fe_ASFR_13=1000*sbirths4/syrsexp4.
+compute fe_ASFR_14=0.
+if syrsexp5>0  fe_ASFR_14=1000*sbirths5/syrsexp5.

+compute fe_ASFR_10to14= 1000*sbirths12345/syrsexp12345.
end if.

aggregate outfile = "partial_results.sav"
  /break = !backvar 
  /lw=mean(lw)
  /fe_ASFR_10 = mean(fe_ASFR_10)
  /fe_ASFR_11 = mean(fe_ASFR_11)
  /fe_ASFR_12 = mean(fe_ASFR_12)
  /fe_ASFR_13 = mean(fe_ASFR_13)
  /fe_ASFR_14 = mean(fe_ASFR_14)
  /fe_ASFR_10to14 = mean(fe_ASFR_10to14)
.

get file = "partial_results.sav".

!enddefine.

**********************************************************

define run_asfr10_14 (backvar = !tokens(1)/ first = !tokens(1)).
make_exposure_and_births backvar=!backvar.
calc_rates backvar=!backvar.

!if (!first<>Y) !then
add files
  /file="FE_ASFR_10-14.sav"
  /file=*.
execute.
!ifend
save outfile= "FE_ASFR_10-14.sav".
new file.
erase file = 'births.sav'.
erase file = 'exposure.sav'.
erase file = 'exposure_and_births.sav'.
!enddefine.


************************************************************
************************************************************
************************************************************
************************************************************
* EXECUTION BEGINS HERE.

*check if numeric variables awfactt awfactu is in the file.
begin program.
import spss, spssaux
varList = "AWFACTT AWFACTU"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.
execute.
aggregate
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /awfactt_included=mean(awfactt)
  /awfactu_included=mean(awfactu).

recode awfactt_included (lo thru hi = 1)(else = 0).
if awfactt_included=0 awfactt=100.
recode awfactu_included (lo thru hi = 1)(else = 0).
if awfactu_included=0 awfactu=100.

if sysmis(awfactt) awfactt=100.
if sysmis(awfactu) awfactt=100.

aggregate
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /sv008_mean=mean(v008).

compute total = 1.
variable labels total 'All'.
value labels total 1 'All'.
variable labels V025 'Type of Place'.

select if v012>=15 & v012<=19.

save outfile = "IRtemp.sav"/keep caseid v001 v002 v003 v005 v008 v011 v012 v021 to v025 total v201 b3$01 to b3$20 awfactt awfactu sv008_mean.

**************************************************************
SPECIFY THE WINDOW(S) OF TIME AND COVARIATE(S), IF ANY. TYPICALLY THIS ROUTINE
 WILL CHANGE FOR EACH RUN BUT ALL OTHER ROUTINES WILL STAY THE SAME.

*There are two ways to specify the window of time.
*		Method 1: as calendar year intervals, e.g. with
			scalar lw=1992
			scalar uw=1996
			for a window from January 1992 through December 1996, inclusive.

*		Method 2: as an interval before the date of interview, e.g. with
			scalar lw=-4
			scalar uw=0  

*IMPORTANT!!! The only women who will contribute to these rates 
are women age 15-19 at the time of the survey
**************************************************************/

get file = "IRtemp.sav".
compute lw=-2.                   
compute uw=0.      
setup.      
run_asfr10_14  backvar = total first=Y.
run_asfr10_14  backvar = V025.

get file = "IRtemp.sav".
compute lw=-4.            
compute uw=0.      
setup.                   
run_asfr10_14  backvar = total.
run_asfr10_14  backvar = V025.

get file = "FE_ASFR_10-14.sav".
string sint(a4).
variable labels sint "Interval".
if lw=-2 sint="3yrs".
if lw=-4 sint="5yrs".

formats fe_ASFR_10 fe_ASFR_11 fe_ASFR_12 fe_ASFR_13 fe_ASFR_14 fe_ASFR_10to14 (f3.0).
string backvar(a20).
variable labels backvar "Residence".
compute backvar=rtrim(valuelabel(total)).
if sysmis(total) backvar=rtrim(valuelabel(V025)).

save outfile = "FE_ASFR_10-14.sav" /keep sint backvar fe_ASFR_10 fe_ASFR_11 fe_ASFR_12 fe_ASFR_13 fe_ASFR_14 fe_ASFR_10to14.

* Export to excel.
get file ="FE_ASFR_10-14.sav".
save translate outfile="Tables_FE_ASFR_10-14.xlsx"
 /type=xls
 /version=12
 /fieldnames values=labels
 /cells=labels
 /replace.

new file.

erase file = "partial_results.sav".
erase file = "IRtemp.sav".
erase file = "fertilitydata.sav".

