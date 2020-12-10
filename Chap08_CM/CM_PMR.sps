* Encoding: UTF-8.
*****************************************************************************************************
Program: 			CM_PMR.sps
Purpose: 			Code to compute perinatal mortality 
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Trevor Croft
Date last modified: December 09 2020 by Ivana Bjelic
Notes:				Any background variable you would like to disaggregate the perinatal mortality by needs to be added to line 19
				A file "CM_PMRdata.sav" will be produced that can be used to export the results. 
*****************************************************************************************************/

*----------------------------------------------------------------------------
*Variables created in this file:
cm_peri		"Perinatal mortality rate"
----------------------------------------------------------------------------.

* open IR dataset.
* drop or add variables from this list as needed.
get file =  datapath + "\"+ irdata + ".sav"/keep=caseid v001 v002 v003 v005 v008 v011 v013 v017 v018 v021 v022 v023 v024 v025 v106 v190 v231 v242 b3$01 to b3$20 vcal$1.

* drop any case without a birth or termination in the calendar, just to speed up the code.
select if char.index (vcal$1,"B")>0 or char.index (vcal$1,"T")>0.

* find the last pregnancy reported before the calendar - needed for calculation of pregnancy interval.
compute befcal = 0.
do repeat x=b3$01 to b3$20.
+if (befcal=0 and x<v017) befcal=x.
end repeat.

if not sysmis(v231) and v231 > befcal and v231 < v017 befcal = v231.
if not sysmis(v242) and v242 > befcal and v242 < v017 befcal = v242.
* drop variables no longer needed before reshape.
execute.
delete variables b3$01 to b3$20 v231 v242.

* loop through all positions in the calendar and turn them into variables.
vector ix (80).
vector cmc (80). 
vector type(80).
vector cmcpreg(80). 

loop i = 1 to 80.
  compute ix(i) = i.
  compute cmc(i) = v017 + 80 - i.
  compute type(i) = $sysmis.
  if char.substr(vcal$1,i,1) = "B" type(i) = 1.
  if char.substr(vcal$1,i,1) = "T" type(i) = 3.
  if char.substr(vcal$1,i,7) = "TPPPPPP"  type(i) = 2.
end loop.

save outfile = datapath + "\temp.sav".

get file =  datapath + "\temp.sav".

* The reshape is really really really slow if you don't select variables and cases first, and will most likely fail otherwise.
varstocases
 /make ix from ix1 to ix80
 /make cmc from cmc1 to cmc80
 /make type from type1 to type80
 /index q(ix).

variable labels type "Type of pregnancy".
value labels type 1 "Birth" 2 "Stillbirth" 3 "Miscarriage/abortion".
variable labels cmc "Century month code of event".

* Set length of calendar to use.
compute callen = v018 + 59.
* If calendar is aligned right (as in original dataset), use the following:.
compute beg = v018.
compute end = callen.
* If calendar is aligned left (as it is in some datasets), use the following:.
*compute beg = 1.
*compute end = 60.

* Include only the five year period, and keep only births and stillbirths.
select if ix >= beg & ix <= end & (type = 1 or type = 2).

* calculate the pregnancy interval.
* find the first position before the pregnancy (when it is not a "P").
compute j = 0.
loop k = 1 to char.lenght( char.substr(vcal$1,ix+1,80-ix)).
  do if any(type,1,2,3) and char.index(char.substr(vcal$1,ix+k,1),"P")=0.
     compute j=k.
     break.
  end if.
end loop.
if j > 0 j = ix + j.

* find last pregnancy before the current one - births first, then terminated pregnancies.
if j > 0 lb = char.index(char.substr(vcal$1,j,80-j+1),"B").
if j > 0 lp = char.index(char.substr(vcal$1,j,80-j+1),"T").
* if the last birth was after the last terminated pregnancy, then use the birth.
if j > 0 & (lp = 0 or (lb > 0 and lb < lp)) lp = lb.
* correct the offset of lp.
if j > 0 & lp > 0 lp = lp + j - 1.

* calculate the pregnancy interval if there was a birth or pregnancy in the calendar before the current one (only if type is 1,2,3).
if any(type,1,2,3) and not sysmis(lp) and lp <> 0 pregint = lp - j.
* calculate the pregnancy interval if there was a birth or pregnancy before the calendar (but not in the calendar) and before the current pregnancy (only if type is 1,2,3).
compute k = 0.
* adjust to exclude the length of the pregnancy - not currently used in DHS.
*if j > 0  k = j - ix.
if any(type,1,2,3) & (lp = 0 or sysmis(lp)) & befcal <> 0 pregint = cmc - k - befcal.
variable labels pregint "Pregnancy interval".
* end of calculation of the pregnancy interval.

* sort by case identifiers and century month code of pregnancy.
sort cases by v001 v002 v003 cmc.
* save this file.
save outfile = "CM_PMRdata.sav".

* merge in birth history variables.

* Open birth history.
get file =  datapath + "\"+ brdata + ".sav" 
/keep v001 v002 v003 bidx b0 to b15.

* Sort according to ID and CMC of birth.
compute cmc = b3.
sort cases by v001 v002 v003 cmc.
save outfile =  datapath + "\births.sav".

*Merge in the pregnancy file, as preparation step for adding twins.
match files
/file = *
/table = "CM_PMRdata.sav"
/in = inPMR
/by v001 v002 v003 cmc.

select if inPMR=1.

save outfile =  datapath + "\births.sav".

*Reopen the pregnancies files and merge in the twins.
get file = "CM_PMRdata.sav".
sort cases by v001 v002 v003 cmc.
match files 
/file = *
/file = datapath + "\births.sav"
/in = inbirth
/by v001 v002 v003 cmc.

* drop a few mismatches between calendar and birth history to match table.
select if not (type=1 & sysmis(bidx)).

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
 * compute iw=v005/1000000.
 * weight by iw.
 * frequencies variables = type.
 * weight off.

compute stillbirths = (type=2).
compute earlyneonatal = 0.
if (type=1 & b6>=100 & b6<= 106) earlyneonatal = 1.

* Perinatal mortality.
compute cm_peri = 1000*(type=2 | (type=1 & b6>=100 & b6<= 106)).
recode cm_peri (sysmis = 0)(else = copy).

* code background variables.

* mother's age at birth (years): <20, 20-29, 30-39, 40-49.
compute months_age=cmc-v011.
recode months_age (0 thru 239 = 1)(240 thru 359 = 2)(360 thru 479 = 3)(480 thru 600 = 4) into mo_age_at_birth.
variable labels mo_age_at_birth "Mothers age at birth".
execute.
value labels mo_age_at_birth 1 "<20" 2 "20-29" 3 "30-39" 4 "40-49".
execute.
 * compute iw=v005/1000000.
 * weight by iw.
 * frequencies variables mo_age_at_birth.

* recode pregnancy interval into groups.
recode pregint (sysmis= 1) (0 thru 14 = 2) (15 thru 26 = 3) (27 thru 38 = 4) (39 thru 9999 = 5) into preg_interval.
variable labels preg_interval "Previous pregnancy interval in months".
value labels preg_interval 1 "First pregnancy" 2 "< 15" 3 "15-26" 4 "27-38" 5 "39 or more".
 * compute iw=v005/1000000.
 * weight by iw.
 * frequencies variables preg_interval.

* save data to use for tables.
save outfile = "CM_PMRdata.sav".

erase file =  datapath + "\births.sav".
erase file =  datapath + "\temp.sav" .

* Tabulate perinatal mortality.
* compute iw=v005/1000000.
* weight by iw.
* frequencies variables stillbirths earlyneonatal cm_peri.
* frequencies variables cm_peri/statistics=sum.
new file.


