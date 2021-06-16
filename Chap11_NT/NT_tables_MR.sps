* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_tables_MR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: May 18 2020 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Tables_nut_mn:	Contains the tables for nutritional status indicators for men
	2.	Tables_anemia_mn:	Contains the tables for anemia indicators for men

*Notes: For men the indicators are outputed for age 15-49 in line 29. 
*This can be commented out if the indicators are required for all men.	
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

* limiting to men age 15-49.
select if not(mv012<15 | mv012>49).

compute wt=mv005/1000000.
weight by wt.

* indicators from MR file.
**************************************************************************************************
* background variables.

* Note: droping men over age 49. If you want to produce tables for all men then comment out this line. 
select if mv013<=7.

*Age. 
recode mv013 (1=1) (2,3=2) (4,5=3) (6,7=4) into agecat.
variable labels agecat.
value labels agecat
1 "15-19"
2 "20-29"
3 "30-39"
4 "40-49".

*Smokes cigarettes.
compute smoke=0.
if range(mv464a,1,888) or range(mv464b,1,888) or range(mv464c,1,888) or range(mv484a,1,888) or range(mv484b,1,888) or range(mv484c,1,888) smoke=1.
variable labels smoke "Smoking cigarettes".
value labels smoke 1 "Yes" 0 "No".

**************************************************************************************************
* Nutritional status of men
**************************************************************************************************
*Mean bmi - men 15-49.

descriptives variables = nt_mn_bmi_mean/statistics=mean.

*Mean bmi - men 15-54.
descriptives variables = nt_mn_bmi_mean_all/statistics=mean.

* this is a scalar and only produced for the total. 

****************************************************
*Normal BMI.
ctables
  /table  agecat [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_norm [c] [rowpct.validn '' f5.1] + nt_mn_norm [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Normal BMI".		

*crosstabs 
    /tables = agecat mv025 mv024 mv106 mv190 by nt_mn_norm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Thin BMI.
ctables
  /table  agecat [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_thin [c] [rowpct.validn '' f5.1] + nt_mn_thin [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Thin BMI".		

*crosstabs 
    /tables = agecat mv025 mv024 mv106 mv190 by nt_mn_thin
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mildly thin BMI.
ctables
  /table  agecat [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_mthin [c] [rowpct.validn '' f5.1] + nt_mn_mthin [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mildly thin BMI".		

*crosstabs 
    /tables = agecat mv025 mv024 mv106 mv190 by nt_mn_mthin
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Moderately and severely thin BMI.
ctables
  /table  agecat [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_modsevthin [c] [rowpct.validn '' f5.1] + nt_mn_modsevthin [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Moderately and severely thin BMI".		

*crosstabs 
    /tables = agecat mv025 mv024 mv106 mv190 by nt_mn_modsevthin
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Overweight or obese BMI.
ctables
  /table  agecat [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_ovobese [c] [rowpct.validn '' f5.1] + nt_mn_ovobese [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Overweight or obese BMI".		

*crosstabs 
    /tables = agecat mv025 mv024 mv106 mv190 by nt_mn_ovobese
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Overweight BMI.
ctables
  /table  agecat [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_ovwt [c] [rowpct.validn '' f5.1] + nt_mn_ovwt [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Overweight BMI".		

*crosstabs 
    /tables = agecat mv025 mv024 mv106 mv190 by nt_mn_ovwt
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Obese BMI.
ctables
  /table  agecat [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_obese [c] [rowpct.validn '' f5.1] + nt_mn_obese [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Obese BMI".		

*crosstabs 
    /tables = agecat mv025 mv024 mv106 mv190 by nt_mn_obese
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_nut_mn.xlsx"
     operation=createfile.

output close * .

**************************************************************************************************
* Anemia in men
**************************************************************************************************
*Any anemia.
ctables
  /table  agecat [c] +
            smoke [c] +
            mv025 [c] +
            mv024 [c] +
            mv106 [c] +
            mv190 [c]
              by
         nt_mn_any_anem [c] [rowpct.validn '' f5.1] + nt_mn_any_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Any anemia".		

*crosstabs 
    /tables = agecat smoke mv025 mv024 mv106 mv190 by nt_mn_any_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_anemia_mn.xlsx"
     operation=createfile.

output close * .

new file.
