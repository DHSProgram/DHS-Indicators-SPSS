* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: May 18 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_nut_wm:	Contains the tables for nutritional status indicators for women
	2.	Tables_anemia_wm:	Contains the tables for anemia indicators for women
                  3. 	Tables_micronut_wm:	Contains the tables for micronutrient intake in women    
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file.

compute wt=v005/1000000.
weight by wt.

**************************************************************************************************
* background variables.

*Age.
recode v013 (1=1) (2,3=2) (4,5=3) (6,7=4) into agecat.
variable labels agecat "Age".
value labels agecat
1  "15-19"
2  "20-29"
3 "30-39"
4 "40-49".

*Number of children ever born.
recode v201 (0=0) (1=1) (2,3=2) (4,5=3) (6 thru hi =4) into ceb.
variable labels ceb "Number of children ever born".
value labels ceb
0 " 0 "
1 " 1 "
2 " 2-3"
3 " 4-5"
4" 6+".

*IUD use.
recode v312 (2=1) (else=0) into iud.
variable labels iud "Using IUD".
value labels iud
1 "Yes"
0 "No".

*Maternity status.
compute mstat=3.
if v213=1 mstat=1.
if v404=1 & v213<>1 mstat=2.
variable labels mstat "Maternity status".
value labels mstat 1"Pregnant" 2"Breastfeeding" 3"Neither".

**************************************************************************************************
* Nutritional status of women
**************************************************************************************************
*Height below 145cm.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_ht [c] [rowpct.validn '' f5.1] + nt_wm_ht [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Height below 145cm".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_ht
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mean bmi.
descriptives variables = nt_wm_bmi_mean
/statistics = mean.

* this is a scalar and only produced for the total. 

****************************************************
*Normal BMI.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_norm [c] [rowpct.validn '' f5.1] + nt_wm_norm [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Normal BMI".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_norm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Thin BMI.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_thin [c] [rowpct.validn '' f5.1] + nt_wm_thin [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Thin BMI".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_thin
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mildly thin BMI.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_mthin [c] [rowpct.validn '' f5.1] + nt_wm_mthin [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mildly thin BMI".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_mthin
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Moderately and severely thin BMI.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_modsevthin [c] [rowpct.validn '' f5.1] + nt_wm_modsevthin [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Moderately and severely thin BMI".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_modsevthin
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Overweight or obese BMI.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_ovobese [c] [rowpct.validn '' f5.1] + nt_wm_ovobese [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Overweight or obese BMI".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_ovobese
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Overweight BMI.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_ovwt [c] [rowpct.validn '' f5.1] + nt_wm_ovwt [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Overweight BMI".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_ovwt
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Obese BMI.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_obese [c] [rowpct.validn '' f5.1] + nt_wm_obese [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Obese BMI".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_obese
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_nut_wm.xlsx"
     operation=createfile.

output close * .

**************************************************************************************************
* Anemia in women
**************************************************************************************************
*Any anemia.
ctables
  /table  agecat [c] +
            ceb [c] +
            mstat [c] +
            iud [c] +
            v463a [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_any_anem [c] [rowpct.validn '' f5.1] + nt_wm_any_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Any anemia".		

*crosstabs 
    /tables = agecat ceb mstat iud v463a v025 v024 v106 v190 by nt_wm_any_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mild anemia.
ctables
  /table  agecat [c] +
            ceb [c] +
            mstat [c] +
            iud [c] +
            v463a [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_mild_anem [c] [rowpct.validn '' f5.1] + nt_wm_mild_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mild anemia".		

*crosstabs 
    /tables = agecat ceb mstat iud v463a v025 v024 v106 v190 by nt_wm_mild_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Moderate anemia.
ctables
  /table  agecat [c] +
            ceb [c] +
            mstat [c] +
            iud [c] +
            v463a [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_mod_anem [c] [rowpct.validn '' f5.1] + nt_wm_mod_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Moderate anemia".		

*crosstabs 
    /tables = agecat ceb mstat iud v463a v025 v024 v106 v190 by nt_wm_mod_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Severe anemia.
ctables
  /table  agecat [c] +
            ceb [c] +
            mstat [c] +
            iud [c] +
            v463a [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_sev_anem [c] [rowpct.validn '' f5.1] + nt_wm_sev_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Severe anemia".		

*crosstabs 
    /tables = agecat ceb mstat iud v463a v025 v024 v106 v190 by nt_wm_sev_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_anemia_wm.xlsx"
     operation=createfile.

output close * .

**************************************************************************************************
* Micronutrient intake among women
**************************************************************************************************
*Number of days women took iron tablets or syrup during pregnancy.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_micro_iron [c] [rowpct.validn '' f5.1] + nt_wm_micro_iron [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Number of days women took iron tablets or syrup during pregnancy".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_micro_iron
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Took deworming medication during pregnancy.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_micro_dwm [c] [rowpct.validn '' f5.1] + nt_wm_micro_dwm [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Took deworming medication during pregnancy".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_micro_dwm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Live in a household with iodized salt.
ctables
  /table  agecat [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_wm_micro_iod [c] [rowpct.validn '' f5.1] + nt_wm_micro_iod [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Live in a household with iodized salt".		

*crosstabs 
    /tables = agecat v025 v024 v106 v190 by nt_wm_micro_iod
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_micronut_wm.xlsx"
     operation=createfile.

output close * .

****************************************************************************
****************************************************************************

new file.
