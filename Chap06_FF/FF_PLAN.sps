* Encoding: windows-1252.
* Encoding: .
*****************************************************************************************************
Program: 			FF_Want.sps
Purpose: 			Code to compute fertility planning status in women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Thomas Pullum, modified by Shireen Assaf for the code share project and translated to SPSS by Ivana Bjelic
Date last modified: September 09 2019 by Ivana Bjelic
Note:				To construct the fertility planning status indicator, we need to include births in the
					five years before the survey as well as current pregnancy. This requires appending the
					data of births and pregnancies
					After appending these data, the indicator is generated in line 130	
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
ff_plan_status		"Fertility planning status at birth of child"
----------------------------------------------------------------------------*.

************************************************************.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

* check whether b19 is in the file. If variable doesnt exist, empty variable is created.
begin program.
import spss, spssaux
varList = "b19$01"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=
  /suseb19=mean(b19$01).
recode suseb19 (lo thru hi = 1)(else = 0).

define reduce_IR_file().

do if suseb19=0.
+do repeat y = b19$02 to b19$06.
+  compute y = $sysmis.
+end repeat.
end if.

* v213      V213       currently pregnant.
* v225      V225       current pregnancy wanted.

save outfile = datapath + "\temp.sav"
 /keep suseb19 caseid v005 v008 v011 v012 bidx$01 to bidx$06 bord$01 to bord$06 b0$01 to b0$06 b3$01 to b3$06 b19$01 to b19$06 m10$1 to m10$6 v201 v213 v214 v225.

!enddefine.

************************************************************.

define reshape_births().

get file =  datapath + "\temp.sav".

* construct a file of births in the past five years.
varstocases
 /make bidx from bidx$01 to bidx$06
 /make bord from bord$01 to bord$06
 /make b0 from b0$01 to b0$06
 /make b3 from b3$01 to b3$06
 /make b19 from b19$01 to b19$06
 /make m10 from m10$1 to m10$6
 /index i(bidx).

select if sysmis(bord)=0.

* adjustment to birth order for multiple births; see Guide to DHS Statistics.
if b0>1 bord=bord-b0+1.

do if suseb19=0.
+ compute interval=v008-b3.
else.
+ compute interval=b19.
end if.

select if (interval<60).
execute.
delete variables interval.

compute age_at_birth=-2 + trunc((b3-v011)/60).
if age_at_birth<1 age_at_birth=1.
variable labels age_at_birth "Age at birth".
value labels age_at_birth 1 "<20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49".

frequencies variables age_at_birth/statistics = mean.

save outfile = datapath + "\temp_births.sav".

!enddefine.

************************************************************.

define append_current_preg().

* construct a file of pregnancies.
get file = datapath + "\temp.sav"/keep caseid v005 v008 v011 v012 v201 v213 v214 v225.
select if v213=1.
rename variables v225 = m10.
compute bidx=0.

* if the woman is currently pregnant, set the birth order of the pregnancy.
compute bord=v201+1.

compute preg_duration=v214.
if v214>9  preg_duration=9.

compute cmc_preg_delivery=v008+(9-preg_duration).
compute age_at_birth=-2 + trunc((cmc_preg_delivery-v011)/60).
variable labels age_at_birth "Age at birth".
value labels age_at_birth 1 "<20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" 6 "40-44" 7 "45-49".

* It can happen that a woman age 49 is pregnant and will give birth at age 50. Push any such cases into 45-49.
if age_at_birth>7 age_at_birth=7.

save outfile =  datapath + "\temp_pregs.sav".

get file = datapath + "\temp_pregs.sav".

add files
 /file = *
 /file = datapath + "\temp_births.sav".
execute.

compute birth_order=bord.
if bord>4 birth_order=4.

*Define our variable of interest after appending the births and pregnancies.
missing values m10 ( ).
compute ff_plan_status=m10.
apply dictionary from *
 /source variables = m10
 /target variables = ff_plan_status.
variable labels ff_plan_status "Fertility planning status at birth of child".
add value labels ff_plan_status 9 "Missing".

save outfile =  datapath + "\temp_births_plus_pregs.sav".

!enddefine.


************************************************************

define calculate_table()

get file =  datapath + "\temp_births_plus_pregs.sav".

compute wt=v005/1000000.

weight by wt.

ctables
  /table birth_order [c] + age_at_birth [c] by
         ff_plan_status [c] [rowpct.validn '' f5.1] + ff_plan_status [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Fertility planning status at birth of child".		

*crosstabs 
    /tables = birth_order age_at_birth by ff_plan_status 
    /format = avalue tables
    /cells = row
    /count asis
    /missing=include.

*output to excel.
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_FFplan.xlsx"
     operation=createfile.

output close *.

!enddefine.

************************************************************
************************************************************
************************************************************
************************************************************
* EXECUTION BEGINS HERE.

reduce_IR_file.
reshape_births.
append_current_preg.
calculate_table.

new file.

erase file =  datapath + "\temp.sav".
erase file =  datapath + "\temp_births.sav".
erase file =  datapath + "\temp_pregs.sav".
erase file =  datapath + "\temp_births_plus_pregs.sav".
