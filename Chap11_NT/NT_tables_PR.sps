* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_tables_PR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: May 18 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_nut_ch:	Contains the tables for nutritional status indicators for children
	2.	Tables_anemia_ch:	Contains the tables for anemia indicators for children
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

* indicators from PR file.

compute wt=hv005/1000000.

weight by wt.

**************************************************************************************************
* background variables

*Age in months.
recode hc1 (0 thru 5=1) (6 thru 8=2) (9 thru 11=3) (12 thru 17=4) (18 thru 23=5) (24 thru 35=6) (36 thru 47=7) (48 thru 59=8) into agemonths.
variable labels agemonths "Age in months".
value labels agemonths
1  " <6"
2  " 6-8"
3 " 9-11"
4  " 12-17"
5  " 18-23"
6  " 24-35"
7  " 36-47"
8 " 48-59".

* Note: other variables such as size at birth (from KR file) and mother's BMI (from IR) are found in other files and need to be merged with PR file
* These tables are only for variables available in the PR file

**************************************************************************************************
* Anthropometric indicators for children under age 5
**************************************************************************************************
*Severely stunted.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_sev_stunt [c] [rowpct.validn '' f5.1] + nt_ch_sev_stunt [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Severely stunted".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_sev_stunt
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
*Stunted.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_stunt [c] [rowpct.validn '' f5.1] + nt_ch_stunt [s][validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Stunted".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_stunt
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mean haz.
descriptives variables = nt_ch_mean_haz 
/statistics = mean.

* this is a scalar and only produced for the total. 

****************************************************
*Severely wasted.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_sev_wast [c] [rowpct.validn '' f5.1] + nt_ch_sev_wast [s][validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Severely wasted".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_sev_wast
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Wasted.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_wast [c] [rowpct.validn '' f5.1] + nt_ch_wast [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Wasted".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_wast
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Overweight for height.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_ovwt_ht [c] [rowpct.validn '' f5.1] + nt_ch_ovwt_ht [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Overweight for height".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_ovwt_ht
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mean whz.
descriptives variables = nt_ch_mean_whz
/statistics = mean.

* this is a scalar and only produced for the total. 

****************************************************
*Severely underweight.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_sev_underwt [c] [rowpct.validn '' f5.1] + nt_ch_sev_underwt [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Severely underweight".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_sev_underwt
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Wasted.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_underwt [c] [rowpct.validn '' f5.1] + nt_ch_underwt [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Wasted".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_underwt
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Overweight for height.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_ovwt_age [c] [rowpct.validn '' f5.1] + nt_ch_ovwt_age [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Overweight for height".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_ovwt_age
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mean whz.
descriptives variables = nt_ch_mean_waz
/statistics = mean.

* this is a scalar and only produced for the total. 

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_nut_ch.xlsx"
     operation=createfile.

output close * .

**************************************************************************************************
* Anemia in children 6-59 months
**************************************************************************************************
.
compute filter=hc1>5.
filter by filter.

*Any anemia.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_any_anem [c] [rowpct.validn '' f5.1] + nt_ch_any_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Any anemia".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_any_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Mild anemia.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_mild_anem [c] [rowpct.validn '' f5.1] + nt_ch_mild_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mild anemia".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_mild_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Moderate anemia.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_mod_anem [c] [rowpct.validn '' f5.1] + nt_ch_mod_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Moderate anemia".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_mod_anem
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Severe anemia.
ctables
  /table  agemonths [c] +
            hc27 [c] +
            hv025 [c] +
            hv024 [c] +
            hv270 [c]
              by
         nt_ch_sev_anem [c] [rowpct.validn '' f5.1] + nt_ch_sev_anem [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Severe anemia".		

*crosstabs 
    /tables = agemonths hc27 hv025 hv024 hv270 by nt_ch_sev_anem
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_anemia_ch.xlsx"
     operation=createfile.

output close * .
****************************************************

new file.
