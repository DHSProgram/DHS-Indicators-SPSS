* Encoding: windows-1252.
*****************************************************************************************************
Program: 			FF_WANT_TFR.sps
Purpose: 			Code to compute wanted fertility rates
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Thomas Pullum modified by Shireen Assaf for the code share project and translated to SPSS by Ivana Bjelic
Date last modified: September 29 2019 by Ivana Bjelic
Note:				This do file will produce a table of Wanted TFRs by background variables as shown in final report (Table_WANT_TFR.xls). 
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
	
*ff_want_tfr		"Wanted fertility rates"
----------------------------------------------------------------------------.

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies
   *descriptives to descriptives.


* Specify the file name.
get file =  datapath + "\"+ irdata + ".sav"/keep caseid v001 v002 v003 v005 v008 v011 v021 v024 v025 v101 v106 v190 v133 v201 awfactt awfactu awfactr awfacte awfactw v613 b3$01 to b3$20 b5$01 to b5$20 b6$01 to b6$20 b7$01 to b7$20 v218 b5$01 b5$20.
save outfile = "tempIR.sav".
get file = "tempIR.sav".

*setup.

* This routine is mainly to prepare the main input file for repeated runs.

******************************************.
rename variables v008 = doi.
rename variables v011 = dob.
rename variables v201 = ceb.
formats ceb (f5.3).

compute curageint=trunc((doi-dob)/60)-2.

compute total = 1.
variable labels total 'Total'.
value labels total 1 'Total'.

save outfile = "temp.sav".

*start_month_end_month.

*This routine calculates the end date and start date for the desired window of time.

*Specify the interval as years before the date of interview, e.g. with.

compute lw=-2.
compute uw=0.

*for a window from 0 to 2 years before the interview, inclusive
  (that is, three years)

*lw is the lower end of the window and uw is the upper end.
*(Remember that both are negative or 0.).

compute start_month=doi+12*lw-12.
compute end_month=doi+12*uw-1.

compute end_month=min(end_month,doi).

compute iweight=v005/1000000.
weight by iweight.

* calculate the reference date.
aggregate outfile = * mode=addvariables overwrite=yes
/mean_start_month=mean(start_month)
/mean_end_month=mean(end_month)
/doi_m=mean(doi).

compute mean_doi=1900-(1/24)+(doi_m)/12.

compute refdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12.

weight off.

save outfile ="temp.sav".

* MAKE FILE OF BIRTHS IN AGE INTERVALS WITHIN THE WINDOW.

get file =  "temp.sav".

varstocases
 /make b3 from b3$01 to b3$20
 /make b5 from b5$01 to b5$20
 /make b6 from b6$01 to b6$20
 /make b7 from b7$01 to b7$20
 /index=order(20).

select if not sysmis (b3).
rename variables b3 = cmcbirth.
sort cases by caseid.
save outfile =  "BRfiltemp.sav".

get file = "temp.sav".
sort cases by caseid.
save outfile "temp.sav".
get file =  "BRfiltemp.sav".
match files 
/file = *
/table ="temp.sav"
/by caseid.

* drop births that lie outside the window.
select if not (cmcbirth<start_month | cmcbirth>end_month).

save outfile = "BRfiltemp.sav".
new file.

******************************************************************************

******************************************************************************

define make_exposure (backvar = !tokens(1))
get file = "temp.sav".
* Set upper and lower limits for date of analysis period.
compute upplim = doi - 1.

* Calculate age of woman and her 5-year age group (3 = 15-19, etc).
compute age = upplim - dob.
compute age5 = trunc(age/60).

* Calculate exposure in months in the current age group and previous age group during the analysis period.

* higexp = exposure in current age group during the analysis period in months.
* lowexp = exposure in previous age group during the analysis period in months.
compute higexp = age - (age5 * 60) + 1.
if (higexp > 36) higexp = 36.
compute lowexp = 0.
if (higexp < 36) lowexp = 36 - higexp.

* Note that some surveys are all-woman surveys but awfact is missing.
* In that case, all the awfacts must be defined and set to 100.

aggregate outfile=* overwrite = yes mode = addvariables
/test_awfact=mean(awfactt).

do if test_awfact=0 | sysmis(test_awfact). 
compute awfactt=100.
compute awfactu=100.
compute awfactr=100.
compute awfacte=100.
compute awfactw=100.
end if.

* Create a weight equal to exposure in current age group.
!if (!backvar=total) !then
compute iweight = higexp * (AWFACTT/100) * v005/1000000.
execute.
!ifend
!if (!backvar=V025) !then
compute iweight = higexp * (AWFACTU/100) * v005/1000000.
execute.
!ifend
!if (!backvar=V024) !then
compute iweight = higexp * (AWFACTR/100) * v005/1000000.
execute.
!ifend
!if (!backvar=V106) !then
compute iweight = higexp * (AWFACTE/100) * v005/1000000.
execute.
!ifend
!if (!backvar=V190) !then
compute iweight = higexp * (AWFACTW/100) * v005/1000000.
execute.
!ifend

* Weight by exposure in current age group.
weight by iweight.

* This sets 15-19 = 1, rather than 3 as above.
* Other age groups are similarly affected (i.e., 20-24 becomes 2 instead of 4).
compute age5 = age5 - 2.

* Create a temporary filter; women younger than 15 are excluded.
* Select 5 periods for tabulation.
temporary.
select if (age5 > 0).

* Output high end exposure to aggregate file.
aggregate outfile = 'higexp.sav'
  /break = !backvar age5 
  /exposure = n(higexp).

* Create a weight equal to exposure in previous age-group.
compute iweight = lowexp * (AWFACTT/100) * v005/1000000.

* Weight by exposure in previous age group.
weight by iweight.

* Reduce age group by one (i.e., the value of age5 for women 15-19 drops from 1 to 0;.
* the value of age5 for women 20-24 drops from 2 to 1, and so one for the other age groups.
compute age5 = age5 - 1.

* Create a temporary filter; women younger than 20 are excluded.
temporary.
select if (age5 > 0 & lowexp > 0).

* Output low end exposure to aggregate file.
aggregate outfile = 'lowexp.sav'
  /break = !backvar age5 
  /exposure = n(lowexp).

* Merge exposure.
add files
  /file = 'higexp.sav'
  /file = 'lowexp.sav'
.

* Convert exposure from months to years.
compute exposure = exposure / 12.

aggregate outfile = 'exposure.sav'
  /break = !backvar age5 
  /exposure = sum(exposure).

new file.

* Erase all temporary files used.
erase file='higexp.sav'.
erase file='lowexp.sav'.

!enddefine.

******************************************************************************

define make_births(backvar = !tokens(1)).
get file = "BRfiltemp.sav".

* Set upper and lower limits for date of analysis period.
compute upplim = doi - 1.
compute lowlim = doi - 36.

* Weight Data.
compute iweight=v005/1000000.
weight by iweight.

* Compute mother's age at the time of birth.
compute agembm = (cmcbirth - dob).

* The two in the following equation creates age groups 1-7 instead of 3-9.
compute age5 = trunc(agembm/60) - 2.
formats age5 (f1.0).

* Select only children born in the period of analysis.
select if (lowlim <= cmcbirth & cmcbirth <= upplim and age5 > 0).

* Aggregate births by age group to the file BIRTHS.SAV.
aggregate outfile = 'births.sav'
  /break = !backvar age5
  /births = n(age5).

!enddefine.

define rename_vars().
!do !i = 1 !to 9
 rename variables !concat("B3$0",!i)=!concat("B3$",!i).
 rename variables !concat("B5$0",!i)=!concat("B5$",!i).
 rename variables !concat("B6$0",!i)=!concat("B6$",!i).
 rename variables !concat("B7$0",!i)=!concat("B7$",!i).
!doend.
!enddefine.

define cmcdeath().
!do !i = 1 !to 20
 compute !concat("cmc_of_death",!i)=$sysmis.
 if trunc(!concat("b6$",!i)/100)<3 !concat("cmc_of_death",!i)=!concat("b3$",!i)+!concat("b7$",!i).
 if trunc(!concat("b6$",!i)/100)=3 !concat("cmc_of_death",!i)=!concat("b3$",!i)+!concat("b7$",!i)+6.
!doend.
!enddefine.

define wanted_fertility()

* Note: for "wanted" fertility, the "keep" statement must include b5_*, b6_*, b7_*, and v613 .

* v613            byte    %8.0g      V613       ideal number of children.

* Loop through the birth history
* Assume that v613 has never changed from the beginning of childbearing to the present
* Classify a birth as unwanted if, when the pregnancy occurred, the number of living children was >=v613 

* Need to calculate the number of living children that the woman had at the beginning of every pregnancy.
* Work backwards from bidx=1 

* The coding does not use current pregnancy status in any way
* It is possible that the last child was not wanted, but died, and now the woman has her desired number; survival status of
* the last child is not used
* The coding is only relevant if v613<v201 

* wanted is 1 if birth was wanted at the time of conception, sysmis if not wanted

* nlc_#li is the number of living children at the point of conception of birth li.
* wanted_status_#li is 0 if nlc_#li>=v613

* drop missing cases for the variable ideal number of children.

get file="tempIR.sav".
select if not sysmis(v613).
rename_vars.
cmcdeath.
!let !one = 1
!do !i = 1 !to 19
  compute !concat('nlc',!i)=0.
  !let !iplus1 = !length(!concat(!blanks(!i), !blanks(!one)))
  !do !j = !iplus1 !to 20
     if (!concat("b5$",!j)=0 & !concat("cmc_of_death",!j)>(!concat("b3$",!i)-9)) | !concat("b5$",!j)=1 !concat("nlc",!i)=!concat("nlc",!i)+1.
  !doend
***UPPER LIMIT of 90 USED IN JORDAN 2012 and some other surveys.
* if !concat("nlc",!i)<v613 & v613<=90 !concat("wanted",!i)=1.
***UPPER LIMIT of 98 USED IN MOST SURVEYS.
if !concat("nlc",!i)<v613 & v613<=98 !concat("wanted",!i)=1.
if sysmis(!concat("wanted",!i)) !concat(b3$,!i)=$sysmis. 
!doend
!enddefine.
wanted_fertility.

varstocases
 /make b3 from b3$1 to b3$19
 /make wanted from wanted1 wanted2 wanted3 wanted4 wanted5 wanted6 wanted7 wanted8 wanted9 wanted10 wanted11 wanted12 wanted13 wanted14 wanted15 wanted16 wanted17 wanted18 wanted19
 /index=order(19).
select if not sysmis (b3).
rename variables b3 = cmcbirth.
rename variables v008=doi.
rename variables v011 = dob.
compute total=1.
save outfile="BRtempwanted.sav".

define wanted_fertility_run(backvar = !tokens(1)).
get file="BRtempwanted.sav".

* Set upper and lower limits for date of analysis period.
compute upplim = doi - 1.
compute lowlim = doi - 36.

* Compute mother's age at the time of birth.
compute agembm = (cmcbirth - dob).

* The two in the following equation creates age groups 1-7 instead of 3-9.
compute age5 = trunc(agembm/60) - 2.
formats age5 (f1.0).

* Select only children born in the period of analysis.
select if (lowlim <= cmcbirth & cmcbirth <= upplim and age5 > 0).

* Weight Data.
compute iweight=v005/1000000.
weight by iweight.

* Aggregate births by age group to the file WANTED_BIRTHS.SAV.
aggregate outfile = 'wanted_births.sav'
  /break = !backvar age5
  /wanted = n(wanted).

new file.

!enddefine.

******************************************************************************

define make_exposure_and_births(backvar=!tokens(1)).
make_exposure backvar=!backvar  .
make_births backvar=!backvar.
wanted_fertility_run backvar=!backvar.

* Match births and exposure in each age group.
match files
  /file='births.sav'
  /file='wanted_births.sav'
  /file='exposure.sav'
  /by !backvar age5.

* Sort according to age.
sort cases by !backvar  age5.

* Set the value of births equal to 0 if its current value is system missing.
if (sysmis(births)) births=0.
if (sysmis(wanted)) wanted=0.

* Calculate age-specific fertility rates.
compute asfr = 1000 * births / exposure.
compute wasfr = 1000 * wanted / exposure.

* Accumulate age-specific fertility rates.
if (age5 = 1) sumasfr  = asfr.
if (age5 > 1) sumasfr  = asfr + lag(sumasfr).
if (age5 = 1) wsumasfr  = wasfr.
if (age5 > 1) wsumasfr  = wasfr + lag(wsumasfr).

if (age5 = 1) cum_births  = births.
if (age5 = 1) cum_wanted = wanted.
if (age5 = 1) cum_expos  = exposure.
if (age5 > 1) cum_births  = births + lag(cum_births).
if (age5 > 1) cum_wanted  = wanted + lag(cum_wanted).
if (age5 > 1) cum_expos  = exposure + lag(cum_expos).

* Calculate total fertility rate.
* The total fertility rate (TFR) is calculated by summing the age-specific fertility rates (sumasfr) calculated for each of the 5-year age groups of women,
* from age 15 through to age 49. The TFR denotes the average number of children to which a woman will have given birth by the end of her reproductive
* years (by age 50) if current fertility rates prevailed.
compute tfr  = 5 * sumasfr / 1000.
compute wtfr  = 5 * wsumasfr / 1000.

* The general fertility rate (GFR) is the number of live births to women age 15-49 years during a specified period,
* divided by the average number of women in the same age group during the same period, expressed per 1,000 women.
do if (age5 = 7).
compute gfr = 1000 * cum_births / cum_expos.
end if.

variable labels
 births "Births"
 /exposure "Exposure"
 /asfr "Age specific fertility rate"
 /tfr "Total fertility rate"
 /wtfr "Total wanted fertility rates"
 /gfr "General fertility rate "
.

save  outfile = "exposure_and_births.sav".

!enddefine.

define runfert (backvar = !tokens(1)/ first = !tokens(1)).
make_exposure_and_births backvar=!backvar  .

!if (!first<>Y) !then
add files
  /file="exposure_and_births_res.sav"
  /file=*.
execute.
!ifend
save outfile= "exposure_and_births_res.sav".
new file.
erase file = 'births.sav'.
erase file = 'wanted_births.sav'.
erase file = 'exposure.sav'.
erase file = 'exposure_and_births.sav'.
!enddefine.

******************************************************************************.
runfert backvar=total first=Y.
runfert backvar=V025.
runfert backvar=V024.
runfert backvar=V106.
runfert backvar=V190.

* Produce final output tables.
get file='exposure_and_births_res.sav'.

variable labels total 'All'.
value labels total 1 ' '.
variable labels V025 'Type of Place'.
variable labels V024 'Region'.
variable labels V106 "Education".
variable labels V190 'Wealth quintile'.

compute sel = (age5 = 7).
filter by sel.

********* Produce Table as in Final report *****************************
* Table_Want_TFR would be produced. This will contain the wanted fertility rates by background variables.
* To obtain the total fertilty rates, you can use the code in Chapter 5 or rerun this program without using.
* the wanted fertility codes in line 260.

ctables
   /table  total[c] + V025[c] + V024[c] + V106[c] + V190[c] by
      wtfr[s][maximum '' f5.1]+tfr[s][maximum '' f5.1]
   /categories variables=all empty=exclude missing=exclude
   /titles title=
    "Wanted fertility rates"
.

* compute filter = not sysmis(v025) and age5 = 7.
* filter by filter.
* sort cases by v025.
* split file by V025.
* descriptives variables wtfr tfr/statistics=maximum.
* split file off.
* filter off.

* compute filter = not sysmis(v024) and age5 = 7.
* filter by filter.
* sort cases by v024.
* split file by V024.
* descriptives variables wtfr tfr/statistics=maximum.
* split file off.
* filter off.

* compute filter = not sysmis(V106) and age5 = 7.
* filter by filter.
* sort cases by V106.
* split file by V106.
* descriptives variables wtfr tfr/statistics=maximum.
* split file off.
* filter off.

* compute filter = not sysmis(V190) and age5 = 7.
* filter by filter.
* sort cases by V190.
* split file by V190.
* descriptives variables wtfr tfr/statistics=maximum.
* split file off.
* filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Table_Want_TFR.xlsx"
     operation=createfile.

*output close * .

new file.

**********************************************************************
* optional--erase the working files.
erase file = 'exposure_and_births_res.sav'.
erase file = 'temp.sav'.
erase file = 'BRfiltemp.sav'.
erase file="BRtempwanted.sav".
erase file = 'tempIR.sav'.
