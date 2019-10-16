* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CM_PMR.sps
Purpose: 			Code to compute perinatal mortality 
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Trevor Croft
Date last modified: October 09, 2019 by Ivana Bjelic
Notes:				Any background variable you would like to disaggregate the perinatal mortality by needs to be added to line 19
				A file "CM_PMRdata.sav" will be produced that can be used to export the results. 
*****************************************************************************************************/

*----------------------------------------------------------------------------
*Variables created in this file:
cm_peri		"Perinatal mortality rate"
----------------------------------------------------------------------------.

* open IR dataset.
get file =  datapath + "\"+ irdata + ".sav".

compute pregs = 0.

vector ix (80).
vector cmc (80). 
vector event (80 A1). 
vector type(80).
vector cmcpreg(80). 
vector pregs(80). 

loop i = 1 to 80.
  compute ix(i) = i.
  compute cmc(i) = v017 + 80 - i.
  compute event(i) = char.substr(vcal$1, i, 1).
  compute type(i) = $sysmis.
  if char.substr(vcal$1,i,1) = "B" type(i) = 1.
  if char.substr(vcal$1,i,1) = "T" type(i) = 3.
  if char.substr(vcal$1,i,7) = "TPPPPPP"  type(i) = 2.
  if (char.substr(vcal$1,i,1) = "B" | char.substr(vcal$1,i,1) = "T") pregs = pregs+1.
end loop.


* Drop cases with no pregnancies.
select if pregs <> 0.

* Decide what variables you want to keep first before the reshape, modify this list as you need to add extra variables.
save outfile = datapath + "\temp.sav"
 /keep caseid v001 v002 v003 v005 v008 v011 v013 v017 v018 v019 v021 v022 v023 v024 v025 v106 v190 v231 v242 ix1 to ix80 cmc1 to cmc80 event1 to event80 type1 to type80.

get file =  datapath + "\temp.sav".

* The reshape is really really really slow if you don't select variables and cases first, and will most likely fail otherwise.
varstocases
 /make ix from ix1 to ix80
 /make cmc from cmc1 to cmc80
 /make event from event1 to event80
 /make type from type1 to type80
 /index i(ix).

variable labels type "Type of pregnancy".
value labels type 1 "Birth" 2 "Stillbirth" 3 "Miscarriage/abortion".
variable labels cmc "Century month code of event".
variable labels event "Calendar event code".

* Set length of calendar to use.
compute callen = v018 + 59.
* If calendar is aligned right (as in original dataset), use the following:.
compute beg = v018.
compute end = callen.
* If calendar is aligned left (as it is in some datasets), use the following:.
*compute beg = 1.
*compute end = 60.

* Include only the five year period.
select if (ix >= beg & ix <= end).

* check the pregnancy types.
compute iw=v005/1000000.
weight by iw.
frequencies variables = type.
weight off.

* Note that this will not match the 5086 pregnancies of 7+ months as that includes twins.
* This file excludes twins, but i believe that is what you really need.

* keep only births and stillbirths.
select if (type = 1 | type = 2).

* sort by case identifiers and century month code of pregnancy.
sort cases by v001 v002 v003 cmc.
* save this file.
save outfile = datapath + "\CM_PMRdata.sav".


* merge in birth history variables.

* Open birth history.
get file =  datapath + "\"+ brdata + ".sav" 
/keep v001 v002 v003 bidx b0 to b15.

* Sort according to ID and CMC of birth.
compute cmc = b3.
sort cases by v001 v002 v003 cmc.
save outfile =  datapath + "\births.sav".

*Reopen the pregnancies files and merge in the twins.

get file = datapath + "\CM_PMRdata.sav".
match files 
/file = *
/file = datapath + "\births.sav"
/by v001 v002 v003 cmc.

do if (v001 = lag(v001) and v002 = lag(v002) and v003 = lag(v003) and cmc=lag(cmc)).
+ compute v005=lag(v005).
+ compute type = lag(type).
+ compute v011 = lag(v011).
+ compute v024 = lag(v024).
+ compute v025 = lag(v025).
+ compute v106 = lag(v106).
+ compute v190 = lag(v190).
end if.

* check the pregnancy types.
compute iw=v005/1000000.
weight by iw.
frequencies variables = type.
weight off.

compute stillbirths = (type=2).
compute earlyneonatal = 0.
if (type=1 & b6>=100 & b6<= 106) earlyneonatal = 1.

* Perinatal mortality.
compute cm_peri = 1000*(type=2 | (type=1 & b6>=100 & b6<= 106)).
recode cm_peri (sysmis = 0)(else = copy).

* code background variables.

* mother's age at birth (years): <20, 20-29, 30-39, 40-49.
compute months_age=cmc-v011.
if months_age<20*12 mo_age_at_birth=1.
if months_age>=20*12 & months_age<30*12 mo_age_at_birth=2.
if months_age>=30*12 & months_age<40*12 mo_age_at_birth=3.
if months_age>=40*12 & months_age<50*12 mo_age_at_birth=4.
variable labels mo_age_at_birth "Mothers age at birth".
value labels mo_age_at_birth 1 "<20" 2 "20-29" 3 "30-39" 4 "40-49".

* save data to use for tables.
save outfile = datapath + "\CM_PMRdata.sav".

erase file =  datapath + "\births.sav".
erase file =  datapath + "\temp.sav" .

* compute iw=v005/1000000.
* weight by iw.
* frequencies variables stillbirths earlyneonatal cm_peri.
* frequencies variables cm_peri/statistics=sum.
new file.


