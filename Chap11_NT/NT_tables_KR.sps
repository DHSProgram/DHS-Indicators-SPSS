* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_tables_KR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: May 18 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1.	Tables_IYCF:	Contains the tables for IYCF indicators in children
	2. 	Tables_micronut_ch:	Contains the tables for micronutrient intake in children
*****************************************************************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

****************************************************************************

* indicators from KR file.

compute wt=v005/1000000.

weight by wt.

**************************************************************************************************
* background variables.

*Age in months.
recode age (0 thru 5=1) (6 thru 8=2) (9 thru 11=3) (12 thru 17=4) (18 thru 23=5) (24 thru 35=6) (36 thru 47=7) (48 thru 59=8) into agemonths.
variable labels agemonths "Age in months".
value labels agemonths
1  " <6"
2  " 6-8"
3  " 9-11"
4  " 12-17"
5  " 18-23"
6  " 24-35"
7  " 36-47"
8  " 48-59".

*Age categories for children 0-23.
recode age (0,1=1) (2,3=2) (4,5=3) (6 thru 8=4) (9 thru 11=5) (12 thru 17=6) (18 thru 23=7) into agecats.
variable labels agecats "Age in months".
value labels agecats
1  " 0-1"
2  " 2-3"
3  " 4-5"
4  " 6-8"
5  "  9-11"
6  " 12-17"
7  " 18-23".

*Place of delivery.

recode m15 (20 thru 39 = 1) (10 thru 19 = 2) (40 thru 99 = 3) into del_place.
variable labels del_place "Place of delivery".
value labels del_place
1 "Health facility"
2 "Home"
3 "Other/Missing".

*Assistance during delivery.
**Note: Assistance during delivery are country specific indicators. Check final report to know if these are coded correctly. 
do if m3a <> 9.
+if not sysmis(m3a) del_pv = 0.
+if m3n = 1 del_pv = 4. 	
+if m3d = 1 or m3e = 1 or m3f = 1 or m3h = 1 or m3i = 1 or m3j = 1 or m3k = 1 or m3l = 1 or m3m = 1 or m3a = 8 del_pv = 3.	
+if m3g = 1 del_pv = 2.	
+if m3a = 1 or m3b = 1 or m3c = 1 del_pv = 1.	
end if.	
variable labels del_pv "Assistance during delivery".
value labels del_pv 1 "Health personnel" 2 "Traditional birth attendant" 3 "Other" 4 "No one".

*Mother's age.
recode v013 (1=1) (2 thru 3=2) (4 thru 5=3) (6 thru 7=4) into agem.
variable lables agem "Mother's age".
value labels agem
1 "15-19"
2 "20-29"
3 "30-39"
4 "40-49".
	
*Breastfeeding status.
do if not sysmis(m4).
+compute brstfed=0.
+if m4=95 brstfed=1.
end if.
*Assume that living twin of last birth who is living with mother is breastfeeding if the last birth is still breastfeeding.
if caseid = lag(caseid) & b3 = lag(b3) & lag(brstfed) = 1 & b0 > 0 & b5=1 & lag(b9)=0 & b9=0 brstfed = 1.
variable labels brstfed "Currently breastfeeding".
value labels brstfed 1 "Yes" 0 "No".
*recode m4 (95=1) (93, 94=2) into brstfed.
*value labels brstfed 1 "Breastfeeding" 0 "Not breastfeeding"

*Wasting status.
if hw72<9996 waste=$sysmis.
if hw72<-300 waste=1.
if hw72>=-300 & hw72<-200 waste=2.
if hw72>=-200 & hw72<9996 waste=3.
variable labels waste "Wasting status".
value labels waste 1 "Severe acute malnutrition" 2 "Moderate acute malnutrition" 3 "Not wasted".

**************************************************************************************************
* Initial breastfeeding 
**************************************************************************************************
*Ever breastfed.
ctables
  /table  b4 [c] +
            del_pv [c] +
            del_place [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_bf_ever [c] [rowpct.validn '' f5.1] + nt_bf_ever [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever breastfed".		

*crosstabs 
    /tables = b4 del_pv del_place v025 v024 v106 v190 by nt_bf_ever
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Breastfed within 1hr.
ctables
  /table  b4 [c] +
            del_pv [c] +
            del_place [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_bf_start_1hr [c] [rowpct.validn '' f5.1] + nt_bf_start_1hr [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Breastfed within 1hr".		

*crosstabs 
    /tables = b4 del_pv del_place v025 v024 v106 v190 by nt_bf_start_1hr
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Breastfed within 1 day.
ctables
  /table  b4 [c] +
            del_pv [c] +
            del_place [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_bf_start_1day [c] [rowpct.validn '' f5.1] +  nt_bf_start_1day [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Breastfed within 1 day".		

*crosstabs 
    /tables = b4 del_pv del_place v025 v024 v106 v190 by nt_bf_start_1day
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Received a prelacteal feed among breastfed children.
ctables
  /table  b4 [c] +
            del_pv [c] +
            del_place [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_bf_prelac [c] [rowpct.validn '' f5.1] +  nt_bf_prelac [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Received a prelacteal feed among breastfed children".		

*crosstabs 
    /tables = b4 del_pv del_place v025 v024 v106 v190 by nt_bf_prelac
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Bottle feeding.
* For breastfeeding status table. 
*Age categories.
compute filter = age<24.
filter by filter.
crosstabs 
    /tables = agecats by nt_bottle
    /format = avalue tables
    /cells = row 
    /count asis.
filter off.

*Age 0-3.
compute filter = age<4.
filter by filter.
frequencies variables = nt_bottle.
filter off.

*Age 0-5.
compute filter = age<6.
filter by filter.
frequencies variables = nt_bottle.
filter off.

*Age 6-9.
compute filter = age>5 & age <10.
filter by filter.
frequencies variables = nt_bottle.
filter off.

*Age 12-15.
compute filter = age>11 & age <16.
filter by filter.
frequencies variables = nt_bottle.
filter off.

*Age 12-23.
compute filter = age>11 & age <24.
filter by filter.
frequencies variables = nt_bottle.
filter off.

*Age 20-23.
compute filter = age>19 & age <24.
filter by filter.
frequencies variables = nt_bottle.
filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_brst_fed.xlsx"
     operation=createfile.

output close * .

* Total for IYCF tables.
frequencies variables = nt_bottle
/statistics=mean.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_IYCF.xlsx"
     operation=createfile.

output close * .

**************************************************************************************************
* Micronutrient intake
**************************************************************************************************
*Given Vitamin and Mineral Powder among children 6-23 months.
ctables
  /table  agemonths [c] +
            b4 [c] +
            brstfed [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_micro_mp [c] [rowpct.validn '' f5.1] + nt_ch_micro_mp [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given Vitamin and Mineral Powder among children 6-23 months".		

*crosstabs 
    /tables = agemonths b4 brstfed agem v025 v024 v106 v190 by nt_ch_micro_mp
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Given iron supplements among children 6-59 months.
ctables
  /table  agemonths [c] +
            b4 [c] +
            brstfed [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_micro_iron [c] [rowpct.validn '' f5.1] + nt_ch_micro_iron [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given iron supplements among children 6-59 months".		

*crosstabs 
    /tables = agemonths b4 brstfed agem v025 v024 v106 v190 by nt_ch_micro_iron
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Given Vit. A supplements among children 6-59 months.
ctables
  /table  agemonths [c] +
            b4 [c] +
            brstfed [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_micro_vas [c] [rowpct.validn '' f5.1] + nt_ch_micro_vas [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given Vit. A supplements among children 6-59 months".		

*crosstabs 
    /tables = agemonths b4 brstfed agem v025 v024 v106 v190 by nt_ch_micro_vas
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Given deworming medication among children 6-59 months.
ctables
  /table  agemonths [c] +
            b4 [c] +
            brstfed [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_micro_dwm [c] [rowpct.validn '' f5.1] + nt_ch_micro_dwm [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given deworming medication among children 6-59 months".		

*crosstabs 
    /tables = agemonths b4 brstfed agem v025 v024 v106 v190 by nt_ch_micro_dwm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Children age 6-59 living in household with iodized salt.
ctables
  /table  agemonths [c] +
            b4 [c] +
            brstfed [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_micro_iod [c] [rowpct.validn '' f5.1] + nt_ch_micro_iod [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Children age 6-59 living in household with iodized salt".		

*crosstabs 
    /tables = agemonths b4 brstfed agem v025 v024 v106 v190 by nt_ch_micro_iod
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Given therapeutic food among children 6-35 months.
ctables
  /table  agemonths [c] +
            b4 [c] +
            brstfed [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_food_ther [c] [rowpct.validn '' f5.1] + nt_ch_food_ther [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given therapeutic food among children 6-35 months".		

*crosstabs 
    /tables = agemonths b4 brstfed agem v025 v024 v106 v190 by nt_ch_food_ther
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Given supplemental food among children 6-35 months.
ctables
  /table  agemonths [c] +
            b4 [c] +
            brstfed [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_food_supp [c] [rowpct.validn '' f5.1] + nt_ch_food_supp [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given supplemental food among children 6-35 months".		

*crosstabs 
    /tables = agemonths b4 brstfed agem v025 v024 v106 v190 by nt_ch_food_supp
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_micronut_ch.xlsx"
     operation=createfile.

output close * .

****************************************************

*new file.
