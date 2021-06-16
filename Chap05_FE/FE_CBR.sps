* Encoding: UTF-8.
******************************************************************************************************
Program: 			FE_CBR.sps
Purpose: 			Code to calculate Crude Birth Rate
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Courtney Allen for the code share project and translated to SPSS by Ivana Bjelic
Date last modified: August 25, 2020 by Ivana Bjelic
Note:				This do file must be run after the TFR.sps because the datasets that store the ASFRs is needed. 
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
CBR 	                   "Crude Birth Rate"
CBR_urban	                   "Crude Birth Rate - Urban"
CBR_rural	                   "Crude Birth Rate - Rural"

*----------------------------------------------------------------------------.

*create weight.
compute wt = hv005/1000000.

weight by wt.

*recode age into 5 yr age groups.
recode hv105
  (0 thru 14 = 0)
  (15 thru 19 = 1)
  (20 thru 24 = 2)
  (25 thru 29 = 3)
  (30 thru 34 = 4)
  (35 thru 39 = 5)
  (40 thru 44 = 6)
  (45 thru 49 = 7) 
  (50 thru 999 = 9) into age5.

variable labels age5 "Age group".
value labels age5
  0 '0-14'
  1 '15-19'
  2 '20-24'
  3 '25-29'
  4 '30-34'
  5 '35-39'
  6 '40-44'
  7 '45-49'
  9 '50+'.
  .

*de facto population counts.
*count of entire de facto population by residence type.
select if hv103 = 1.

compute total = 1.

*count of entire de facto population - total, urban and rural.
compute pop = 1.
*count of de facto women.
if (hv104 = 2 and age5>=1 and age5<=7) nwm = 1.

aggregate outfile = * mode = addvariables overwrite = yes
  /break=total
  /hh_pop = n(pop).

aggregate outfile = * mode = addvariables overwrite = yes
  /break=hv025
  /hh_pop_res = n(pop).

*count of de facto women by age group and residence.
select if  (hv104 = 2 and age5>=1 and age5<=7) .
aggregate outfile = 'tempCBRTot.sav'
  /break total age5 
  /hh_pop=mean(hh_pop)
  /women_pop = n(nwm).

aggregate outfile = 'tempCBRRes.sav'
  /break hv025 age5
  /hh_pop=mean(hh_pop_res)
  /women_pop = n(nwm).


get file ='tempCBRTot.sav'.
add files /file = *
/file = 'tempCBRRes.sav'.

* match information to the exposure and births dataset created when running the TFR.sps.
rename variables hv025=v025.
sort cases by total age5 v025.
save outfile = 'tempCBRTot.sav'.

get file =  'exposure_and_births_res.sav'/keep total age5 v025 asfr.
select if (not sysmis(total) or not sysmis(v025)).
select if (age5>0).
sort cases by total age5 v025.
match files 
/file = *
/table =  'tempCBRTot.sav'
/by total age5 v025.

*create variables.
compute cbrT = asfr * women_pop/hh_pop.

* Total.
compute filter = (total=1).
filter by filter.
aggregate outfile = * mode = addvariables overwrite = yes
/break = total
/CBR= sum (cbrT).

* Urban.
filter off.
compute filter = (v025=1).
filter by filter.
aggregate outfile = * mode = addvariables overwrite = yes
/break = v025
/CBR_urban = sum (cbrT).

* Rural.
filter off.
compute filter = (v025=2).
filter by filter.
aggregate outfile = * mode = addvariables overwrite = yes
/break = v025
/CBR_rural = sum (cbrT).

filter off.

variable labels CBR "CBR".
variable labels CBR_urban "CBR (Urban)".
variable labels CBR_rural "CBR (Rural)".

formats CBR CBR_urban CBR_rural (f7.1).

descriptives variables = CBR CBR_urban CBR_rural /statistics = mean.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_FE_CBR.xlsx"
     operation=createfile.

output close * .

new file.

* optional--erase the working files.
erase file = 'exposure_and_births_res.sav'.
erase file = 'tempCBRTot.sav'.
erase file = 'tempCBRRes.sav'.

