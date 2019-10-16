* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CM_CHILD.sps
Purpose: 			Produce child mortality indicators 
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Tom Pullum and modified by Shireen Assaf for the code share project
Date last modified: September 30 2019 by Ivana Bjelic
Note:				The program will produce a file "`CNPH'_mortality_rates_with_ci.sav" which can be used to export the results, 
				where `CNPH' is the two letter country code followed by the 2 character survey phase, ex: UG7A . 
*****************************************************************************************************/

****************************************************************************************
PROGRAM TO PRODUCE UNDER 5 MORTALITY RATES FOR SPECIFIC WINDOWS OF TIME, WITH COVARIATES
****************************************************************************************
*
The 5 standard rates (also actually conditional probabilities) are as follows:
*
Neonatal mortality:     the probability of dying in the first month of life;
Postneonatal mortality: the difference between infant and neonatal mortality (similar to the
                            probability of dying during months 1 through 11, but different);
Infant mortality:        the probability of dying in the first year of life;
Child mortality:        probability of dying between the first and fifth birthday;
Under-five mortality:   the probability of dying before the fifth birthday.
*
Refer to these as q_nnmr, q_pnnmr, q_imr, q_cmr, and q_u5mr, respectively.  
*
When these are multiplied by 1000, they are referred to as NNMR, PNNMR, IMR, CMR, and U5MR, respectively
*
The set of 5 is obtained from the set of 8 as follows:
*
q_nnmr=q1
q_pnnmr=q_imr-qnnmr
q_imr=1-(1-q1)*(1-q2)*(1-q3)*(1-q4)
q_cmr=1-(1-q5)*(1-q6)*(1-q7)*(1-q8)
q_u5mr=1-(1-q1)*(1-q2)*(1-q3)*(1-q4)*(1-q5)*(1-q6)*(1-q7)*(1-q8)=1-(1-q_imr)*(1-q_cmr)
*
GO TO THE REPEATED LINES OF ASTERISKS FOR THE BEGINNING OF THE EXECUTABLE STATEMENTS

*/

* Must reshape if the input file is IR rather than BR:.
get file =  datapath + "\"+ irdata + ".sav".

** To check if survey has m18$7 to m18$20. If variable doesnt exist, empty variable is created. This part of the code is necessery for reshaping IR file.
begin program.
import spss, spssaux
varList = "m18$7 m18$8 m18$9 m18$10 m18$11 m18$12 m18$13 m18$14 m18$15 m18$16 m18$17 m18$18 m18$19 m18$20"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

varstocases
 /make bidx from bidx$01 to bidx$20
 /make bord from bord$01 to bord$20
 /make b3 from b3$01 to b3$20
 /make b4 from b4$01 to b4$20
 /make b5 from b5$01 to b5$20
 /make b7 from b7$01 to b7$20
 /make b11 from b11$01 to b11$20
 /make m18 from m18$1 m18$2 m18$3 m18$4 m18$5 m18$6 m18$7 m18$8 m18$9 m18$10 m18$11 m18$12 m18$13 m18$14 m18$15 m18$16 m18$17 m18$18 m18$19 m18$20 
 /index i(bidx).

rename variables  (v008=doi).
rename variables (b3=dob).
rename variables (b7=age_at_death).

* define recodes.
* Routine to recode or construct covariates.
* Be sure that the components are included in the the original save and reshape commands
* Example: combine codes 2 and 3 of v106, Education.
* compute v106r=v106.
* if v106=3 v106r=2.

compute child_sex=b4.
variable labels child_sex "Sex of child".
value labels child_sex 1 "Male" 2"Female".

* mother's age at birth (years): <20, 20-29, 30-39, 40-49.
compute months_age=dob-v011.
if months_age<20*12 mo_age_at_birth=1.
if months_age>=20*12 & months_age<30*12 mo_age_at_birth=2.
if months_age>=30*12 & months_age<40*12 mo_age_at_birth=3.
if months_age>=40*12 & months_age<50*12 mo_age_at_birth=4.
execute.
delete variables months_age.
variable labels mo_age_at_birth "Mothers age at birth".
value labels mo_age_at_birth 1 "<20" 2 "20-29" 3 "30-39" 4 "40-49".

* birth order: 1, 2-3, 4-6, 7+.
compute birth_order=1.
if bord>1  birth_order=2.
if bord>3 birth_order=3.
if bord>6  birth_order=4.
if sysmis(bord) birth_order=$sysmis.
* crosstabs bord by birth_order.
variable labels birth_order "Birth order".
value labels birth_order 1 "1" 2 "2-3" 3 "4-6" 4 "7+".

* preceding birth interval (years): <2, 2, 3, 4+.
compute prev_bint=1.
if b11>23 prev_bint=2.
if b11>35 prev_bint=3.
if b11>47 prev_bint=4.
if sysmis(b11) prev_bint=$sysmis.
* crosstabs b11 by prev_bint.
variable labels prev_bint "Birth order".
value labels prev_bint 1 "<2" 2 "2" 3 "3" 4 "4+".

* birth size: small/very small, average or larger.
compute birth_size=1.
if m18<=3 birth_size=2.
if m18>5 birth_size=$sysmis.
* crosstabs m18 by birth_size.
variable labels birth_size "Birth size".
value labels birth_size 1 "small/very small" 2 "average or larger".

save outfile = datapath + "\tempBR.sav"keep dob, child_sex, b5, age_at_death, v005, doi, v101, v102, v106, v190, v024, v025, mo_age_at_birth, birth_order, prev_bint, birth_size.
file handle BRfiltemp /name=datapath + "\tempBR.sav".

* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- .
* Macro to open dataset and initialize key variables 
* prior to use for calculating deaths ("deathdata") or exposure ("exposuredata").

define initdata (backvar = !tokens(1) / period = !default(5) !tokens(1)  / nper = !default(2) !tokens(1)).
get file=BRfiltemp.

* Create total variable if needed.
!if (!backvar=total) !then
compute total = 1.
variable labels total 'Total'.
value labels total 1 'Total'.
!ifend. 

* Initialization of periods.
compute maxper=!nper.
* Maximum length of period that works properly with this is 5 years, minimum is 1 year.  
* For 10 year rates, create two 5 year counts of numerators and denominators and then sum them together.
compute period=!period * 12.

* Set up variable for periods.
compute colper = 0.
formats colper (f1.0).
* Adjust the labels below to match the period length and number of periods.
variable labels colper "Years preceding the survey".
!if (!period = 2) !then
value labels colper
     0 "0-1"
     1 "2-3"
     2 "4-5"
     3 "6-7"
     4 "8-9"
     5 "10-11"
     6 "12-13"
     7 "14-15"
     8 "16-17"
     9 "18-19".
!ifend
!if (!period = 5) !then
value labels colper
     0 "0-4"
     1 "5-9"
     2 "10-14"
     3 "15-19"
     4 "20-24".
!ifend

* Set up variable for age groups.
compute agegrp = 0.
formats agegrp (f1.0).
variable labels agegrp  "Age in months".
value labels agegrp
     0 "0"
     1 "1-2"
     2 "3-5"
     3 "6-11"
     4 "12-23"
     5 "24-35"
     6 "36-47"
     7 "48-59".

* Define lower limits of age categories for calculating probabilities.
* i.e. 0, 1, 3, 6, 12, 24, 36, 48.
compute agegr$00 = 0.
compute agegr$01 = 1.
compute agegr$02 = 3.
compute agegr$03 = 6.
compute agegr$04 =12.
compute agegr$05 =24.
compute agegr$06 =36.
compute agegr$07 =48.
compute agegr$08 =60.
formats agegr$00 agegr$02 agegr$03 agegr$04 agegr$05 agegr$06 agegr$07 agegr$08 (f2.0).

* Set upper limit for date of analysis period.
compute upplim = doi - 1.

* Calculate period of birth.
compute perborn = trunc((doi-1 - dob)/period).

* Select only children born before the end of the period of analysis.
select if (dob <= upplim).

compute ageatdth = age_at_death.

* Set months = number of months child lived.
compute months = 0.
if (B5 = 0) months = ageatdth.
if (B5 = 1) months = (doi - dob).

* Run all transformations so far.
execute.

!enddefine.

* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- .
* Macro to aggregate the deaths in each period.

define deathdata (backvar = !tokens(1))

* Include only dead children.
select if(B5 = 0).

* Assign deaths to age groups. Note that for compatability with WFS and DHS
* surveys, once deaths are assigned to an age group, only the information
* on the age group of death is used NOT the actual age at death.
compute j = 0.

if (agegr$00 <= ageatdth & ageatdth < agegr$01) j = 1.  /* Age at death = 0 months. */
if (agegr$01 <= ageatdth & ageatdth < agegr$02) j = 2.  /* Age at death = 1-2 months. */
if (agegr$02 <= ageatdth & ageatdth < agegr$03) j = 3.  /* Age at death = 4-5 months. */
if (agegr$03 <= ageatdth & ageatdth < agegr$04) j = 4.  /* Age at death = 6-11 months. */
if (agegr$04 <= ageatdth & ageatdth < agegr$05) j = 5.  /* Age at death = 12-23 months. */
if (agegr$05 <= ageatdth & ageatdth < agegr$06) j = 6.  /* Age at death = 24-35 months. */
If (agegr$06 <= ageatdth & ageatdth < agegr$07) j = 7.  /* Age at death = 36-47 months. */
If (agegr$07 <= ageatdth & ageatdth < agegr$08) j = 8.  /* Age at death = 48-59 months. */

compute agegrp = j - 1.

* Select children who died under age 5.
select If (j <> 0).

* Determine period of birth and death.
compute perborn = trunc((doi-1 - dob)/period).

* Calculate lower bound for the date of the period in which the child was born (limlow).
compute limlow = doi  - (perborn+1) * period.

* Calculate earliest date death could occur in age group j.

if (j = 1) agei = dob + agegr$00.  /* ie month of birth. */
if (j = 2) agei = dob + agegr$01.  /* ie month of birth + 1 month. */
if (j = 3) agei = dob + agegr$02.  /* ie month of birth + 3 months. */
if (j = 4) agei = dob + agegr$03.  /* ie month of birth + 6 months. */
if (j = 5) agei = dob + agegr$04.  /* ie month of birth + 12 months. */
if (j = 6) agei = dob + agegr$05.  /* ie month of birth + 24 months. */
if (j = 7) agei = dob + agegr$06.  /* ie month of birth + 36 months. */
if (j = 8) agei = dob + agegr$07.  /* ie month of birth + 48 months. */

* Calculate date of start of next age group.
* (i.e. upper bound on date of death in age group j).

if (j = 1) nxtage = dob + agegr$01.  /* ie month of birth + 1 month. */
if (j = 2) nxtage = dob + agegr$02.  /* ie month of birth + 3 months. */
if (j = 3) nxtage = dob + agegr$03.  /* ie month of birth + 6 months. */
if (j = 4) nxtage = dob + agegr$04.  /* ie month of birth + 12 months. */
if (j = 5) nxtage = dob + agegr$05.  /* ie month of birth + 24 months. */
if (j = 6) nxtage = dob + agegr$06.  /* ie month of birth + 36 months. */
if (j = 7) nxtage = dob + agegr$07.  /* ie month of birth + 48 months. */
if (j = 8) nxtage = dob + agegr$08.  /* ie month of birth + 60 months. */

* Determine period of death.
compute colper = trunc((doi-1 - agei)/period).

* Calculate lower bound for the date of the period in which the child died (limlow).
compute limlow = doi - (colper+1) * period.

* Calculate upper bound for the date of the period in which the child died (limupp).
compute limupp = limlow + period.
compute n = 1.

* number of periods in which death could occur.
compute iter  = 0.

* Death occurs in same period of birth.
if (nxtage <= limupp)  iter = 1.

* Death could occur in period of birth or in the next period.
if (colper > 0 & agei < limupp & limupp <= nxtage) iter = 2.
if (colper = 0 & agei < limupp & limupp <= nxtage) iter = 1.

if (iter <> 0) n = n / iter.

* Weight the data. Multiplied by 1000 to effectively
* allow more decimal places in the tabulation. Deaths that could have
* occured in either of two time periods are assigned 1/2 to each period (n).
compute rweight = n * v005/1000000.
weight by rweight.

* Tabulate deaths that occured to children born in the last 5 periods by age at death and period.
temporary.
select if (iter <> 0 & 0 <= colper & colper < maxper).
aggregate outfile = 'tmp1.sav'
  /break = agegrp colper !backvar
  /deaths = n(agegrp).

* Retabulate deaths that could have occurred in the next period, in that period.
if (iter = 2) colper = colper - 1.
temporary.
select if (iter = 2 & 0 <= colper & colper < maxper).
aggregate outfile = 'tmp2.sav'
  /break = agegrp colper !backvar
  /deaths = n(agegrp).

* Combine the two system files of death into one file.
add files 
  /file='tmp1.sav'
  /file='tmp2.sav'.

aggregate outfile = 'deaths.sav'
  /break = agegrp colper !backvar
  /deaths = sum(deaths).

new file.

erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.

!enddefine.

* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- .
* Macro for tabulating exposure.

define tabexp (backvar = !tokens(1) / exp = !tokens(1) / agegr = !tokens(1) )

compute agegrp = !exp.
* Set agei to CMC for start of age group and next age to CMC for start of next age group.
compute agei   = nxtage.
compute nxtage = dob + !agegr.

* Select children exposed for at least part of the age group, ie children who enter the age group.
select if (agei <= dob + months).

* Calculate lower bound for the date of the period in which the child was born.
compute limlow = doi - ((perborn+1) * period).

* Calculate upper bound for the date of the period in which the child was born.
compute limupp = limlow + period.

* Determine number of periods in which exposure occurred in the age group (iter).
compute iter = 0.
do if (limupp <= agei).
+ compute perborn = perborn - 1.
+ compute iter = 1.
+ compute n = 1.
+ compute limlow = limlow + period.
+ compute limupp = limlow + period.
end if.

* All exposure occurs in period of birth.
do if (nxtage < limupp).
+ compute iter = 1.
+ compute n = 1.
end if.

* Exposure occurs in period of birth and in the next period.
do if (agei < limupp & limupp <= nxtage).
+ compute iter = 2.
+ compute n = 0.5.
+ if (perborn = 0) iter = 1.
end if.

* Colper defines columns for tabulation = time periods.
compute colper = perborn.

* Weight data.
* Multiplied by 1000 used to allow more decimal places in the tabulation.
* Exposure that occurs over two time periods is assigned 1/2 to each period (n).
compute rweight = n * v005/1000000.
weight by rweight.

* Select periods for tabulation.
temporary.
select if (0 <= colper & colper < maxper).
aggregate outfile = !concat('exposd',!exp,'1.sav')
  /break = agegrp colper !backvar
  /exposure = n(agegrp).

compute colper = colper - 1.
temporary.
select if (0 <= colper & colper < maxper & iter = 2).
aggregate outfile = !concat('exposd',!exp,'2.sav')
  /break = agegrp colper !backvar
  /exposure = n(agegrp).

!enddefine.

* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- .
* Macro for calculating children at risk of exposure in each age group.

define exposuredata (backvar = !tokens(1))

compute nxtage = dob.
tabexp backvar = !backvar exp = 0 agegr = agegr$01.  /* Tabulate exposure in the first age group (0 months) by period. */
tabexp backvar = !backvar exp = 1 agegr = agegr$02.  /* Tabulate exposure in the second age group (1-2 months) by period. */
tabexp backvar = !backvar exp = 2 agegr = agegr$03.  /* Tabulate exposure in the third age group (3-5 months) by period. */
tabexp backvar = !backvar exp = 3 agegr = agegr$04.  /* Tabulate exposure in the fourth age group (6-11 months) by period. */
tabexp backvar = !backvar exp = 4 agegr = agegr$05.  /* Tabulate exposure in the fifth age group (12-23 months) by period. */
tabexp backvar = !backvar exp = 5 agegr = agegr$06.  /* Tabulate exposure in the sixth age group (24-35 months) by period. */
tabexp backvar = !backvar exp = 6 agegr = agegr$07.  /* Tabulate exposure in the seventh age group (36-47 months) by period. */
tabexp backvar = !backvar exp = 7 agegr = agegr$08.  /* Tabulate exposure in the eighth age group (48-59 months) by period. */

* Combine all the exposure files and save as a single file.
add files
  /file='exposd01.sav'
  /file='exposd11.sav'
  /file='exposd21.sav'
  /file='exposd31.sav'.
add files
  /file=*
  /file='exposd41.sav'
  /file='exposd51.sav'
  /file='exposd61.sav'
  /file='exposd71.sav'.
add files
  /file=*
  /file='exposd02.sav'
  /file='exposd12.sav'
  /file='exposd22.sav'
  /file='exposd32.sav'.
add files
  /file=*
  /file='exposd42.sav'
  /file='exposd52.sav'
  /file='exposd62.sav'
  /file='exposd72.sav'.

* Tabulate exposure.
aggregate outfile = 'exposure.sav'
  /break = agegrp colper !backvar
  /exposure = sum(exposure).

new file.

erase file='exposd01.sav'.
erase file='exposd11.sav'.
erase file='exposd21.sav'.
erase file='exposd31.sav'.
erase file='exposd41.sav'.
erase file='exposd51.sav'.
erase file='exposd61.sav'.
erase file='exposd71.sav'.
erase file='exposd02.sav'.
erase file='exposd12.sav'.
erase file='exposd22.sav'.
erase file='exposd32.sav'.
erase file='exposd42.sav'.
erase file='exposd52.sav'.
erase file='exposd62.sav'.
erase file='exposd72.sav'.

!enddefine.

* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- .
* Macro for calculating final mortality rates for the background var and tabulating.

define tabcalc (backvar = !tokens(1) / grpper = !default(2) !tokens(1))
* Calculation of probabilities and rates.

* Combine the deaths and exposure system files.
match files
  /file='deaths.sav'
  /file='exposure.sav'
  /by agegrp colper !backvar.

recode deaths (sysmis = 0).

* Combine two or more periods to produce rates for longer periods (e.g. 10 year rates).
!if (!grpper > 1) !then
compute colper = trunc( colper / !grpper ).
value labels colper 0 'combined rates'.
aggregate outfile = 'grouped.sav'
  /break = agegrp colper !backvar
  /deaths = sum(deaths)
  /exposure = sum(exposure).
get file='grouped.sav'.
!ifend

compute probs = 1000*deaths/exposure.

variable labels
  deaths 'Deaths'
  exposure 'Exposure'
  probs 'Probability'.

sort cases by !backvar colper agegrp.

* Calculate cumulative probability of surviving to the end of each age group (nP0).
if (agegrp = 0) probsurv = (1000-probs).
if (agegrp > 0) probsurv = (lag(probsurv) * (1000-probs))/1000.
* For agegroup 4 (12-23) upwards, calculate probability of surviving from age 12 months
* to the end of each age group (nP12) to get the child mortality rate.
* Therefore, reset cumulative probability for age group 12-23 months to start cumulating from that age group on.
if (agegrp = 4) probsrv2 = (1000-probs).
if (agegrp > 4) probsrv2 = (lag(probsrv2) * (1000-probs))/1000.

* nn = (Neonatal) probability of surviving 1st month.
if (agegrp = 0) nn = 1000 - probsurv.
if (agegrp > 0) nn = lag(nn).
* imr = probability of surviving 1st year.
if (agegrp = 3) imr = 1000-probsurv.
if (agegrp > 3) imr = lag(imr).
* pnn = probability of surviving from 1st month to 1st year - calculated as difference between imr and nn.
if (agegrp = 3) pnn = imr - nn.
if (agegrp > 3) pnn = lag(pnn).
* cmr = probability of surviving from 1st year to 5th birthday.
if (agegrp = 7) cmr = 1000 - probsrv2.
* u5mr = probability of surviving from birth to first birthday.
if (agegrp = 7) u5mr = 1000 - probsurv.

execute.

variable labels
  nn 'Neonatal mortality rate'
 /pnn 'Post neonatal mortality rate'
 /imr 'Infant mortality rate'
 /cmr 'Child mortality rate'
 /u5mr 'Under five mortality rate'.
 
temporary.
select if (agegrp = 7).		

!enddefine.


* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- .
* Main program for calculating mortality
* Calls the following macros:
*   "initdata" - for Initialization of data.
*   "deathdata" - for calculation of deaths.
*   "initdata" - for Initialization of data (to reopen and reinitialize for the exposure calculations.
*   "exposuredata" - for calculation of exposure.
*   "tabcalc" -  for calculation of probabilities and rates, and final tables.

define runmort (backvar = !tokens(1) / period = !default(5) !tokens(1)  / nper = !default(2) !tokens(1) / grpper = !default(2) !tokens(1) / first = !tokens(1)).
initdata backvar=!backvar period=!period nper=!nper  .
deathdata backvar=!backvar  .
initdata backvar=!backvar period=!period nper=!nper  .
exposuredata backvar=!backvar  .
tabcalc backvar=!backvar grpper=!grpper  .

!if (!first<>Y) !then
add files
  /file=datapath + "\mortality_rates.sav"
  /file=*.
execute.
!ifend
save outfile=datapath + "\mortality_rates.sav".
new file.
erase file = 'deaths.sav'.
erase file = 'exposure.sav'.
!if (!grpper > 1) !then
erase file = 'grouped.sav'.
!ifend
!enddefine.

* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- .

* National mortality estimates.
* Total - five 5-year rates - no need to group periods.
runmort backvar=total period=5 nper=5 grpper=1 first=Y.
* All background variables - use defaults - two five year rates, if you want to produce grouped 10-yeas rate.
runmort backvar=V025  grpper=2.
runmort backvar=V024  grpper=2.
runmort backvar=V106  grpper=2.
runmort backvar=V190  grpper=2.
runmort backvar=child_sex  grpper=2.
runmort backvar=child_sex grpper=2.
runmort backvar=mo_age_at_birth grpper=2.
runmort backvar=birth_order grpper=2.
runmort backvar=prev_bint grpper=2.
runmort backvar=birth_size grpper=2.
* For 10 year rates, create two 5 year counts of numerators and denominators and then sum them together.
* For 10 year rates, create two 5 year counts of numerators and denominators and then sum them together. 


new file.

