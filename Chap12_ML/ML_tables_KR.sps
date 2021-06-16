* Encoding: windows-1252.
*******************************************************************************************************
Program: 			ML_tables_KR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: August 31 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Tables_FEVER:		Contains tables on fever careseeking for children under 5 (fever, treatment seeking)
	2. 	Tables_Antimal:		Contains tables for antimalarial drugs
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************


*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=v005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".

* Child's age as background variable for tables.
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
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /b19_included=mean(b19).
recode b19_included (lo thru hi = 1)(else = 0).

***************************

* if b19 is present and not empty.
do if  b19_included = 1.
    compute age = b19.
else.
** if b19 is not present, compute age.
    compute age = v008 - b3.
end if.

recode age (0 thru 11=1) (12 thru 23=2) (24 thru 35=3) (36 thru 47=4) (48 thru 60=5) into agecat.
variable labels agecat "Age".
value labels agecat 1 "<12" 2 "12-23" 3 "24-35" 4 "36-47" 5  "48-59".

****************************************************
*** Fever and care seeking for fever ***
****************************************************
*Children under age 5 years with fever in the 2 weeks preceding the survey.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_fever [c] [rowpct.validn '' f5.1] + ml_fever [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Children under age 5 years with fever in the 2 weeks preceding the survey".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_fever
    /format = avalue tables
    /cells = row 
    /count asis.	

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_fev_care [c] [rowpct.validn '' f5.1] + ml_fev_care [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_fev_care
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought the same or next day.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_fev_care_day [c] [rowpct.validn '' f5.1] + ml_fev_care_day [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey, percentage for whom advice or treatment was sought the same or next day".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_fev_care_day
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Children under age 5 years with fever in the 2 weeks preceding the survey who had blood taken from a finger or heel for testing.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_stick [c] [rowpct.validn '' f5.1] + ml_stick [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Children under age 5 years with fever in the 2 weeks preceding the survey who had blood taken from a finger or heel for testing".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_stick
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
*** Source of advice or treatment for fever symptoms ***
* only the following sources are computed, to get other sources that are country specific, please see the note on these indicators in the ML_FEVER.do file.

* among children with fever symtoms.
frequencies variables ml_fev_govh ml_fev_govcent ml_fev_pclinc ml_fev_pdoc ml_fev_pharm.

* among children with fever symtoms whom advice or treatment was sought.
frequencies variables ml_fev_govh_trt ml_fev_govcent_trt ml_fev_pclinc_trt ml_fev_pdoc_trt ml_fev_pharm_trt.	

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_FEVER.xls"
     operation=createfile.

output close * .


****************************************************
*** Antimalarial drugs***
****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took an ACT.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_act [c] [rowpct.validn '' f5.1] + ml_act [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took an ACT".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_act
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took SP/Fansider.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_sp_fan [c] [rowpct.validn '' f5.1] + ml_sp_fan [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took SP/Fansider".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_sp_fan
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Chloroquine.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_chloro [c] [rowpct.validn '' f5.1] + ml_chloro [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Chloroquine".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_chloro
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Amodiaquine.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_amodia [c] [rowpct.validn '' f5.1] + ml_amodia [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Amodiaquine".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_amodia
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Quinine pills.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_quin_pill [c] [rowpct.validn '' f5.1] + ml_quin_pill [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Quinine pills".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_quin_pill
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Quinine injection or IV.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_quin_inj [c] [rowpct.validn '' f5.1] + ml_quin_inj [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Quinine injection or IV".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_quin_inj
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Artesunate rectal.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_artes_rec [c] [rowpct.validn '' f5.1] + ml_artes_rec [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Artesunate rectal".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_artes_rec
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Artesunate injection or intravenous.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_artes_inj [c] [rowpct.validn '' f5.1] + ml_artes_inj [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took Artesunate injection or intravenous".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_artes_inj
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took other antimalarial.
ctables
  /table  agecat [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_antimal_other [c] [rowpct.validn '' f5.1] + ml_antimal_other [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among children under age 5 years with fever in the 2 weeks preceding the survey who took any antimalarial medication, percentage who took other antimalarial".			

*crosstabs 
    /tables = agecat b4 v025 v024 v106 v190 by ml_antimal_other
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Antimal.xls"
     operation=createfile.

output close * .

****************************************************

new file.
