* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_tables2.sps
Purpose: 			produce tables for indicators with the denominator of the youngest child under age 2 years living with the mother
Author:				Ivana Bjelic
Date last modified: May 18 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:

*These tables will append to the same excel files produced in NT_tables.sps
*
	1. 	Tables_brst_fed:	Contains the tables for breastfeeding indicators
	2.	Tables_IYCF:	Contains the tables for IYCF indicators in children
	3. 	Tables_micronut_ch:	Contains the tables for micronutrient intake in children

*****************************************************************************************************/
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* Indicators from KR file restricted to youngest child under 2 years living with the mother

compute wt=v005/1000000.
weight by wt.

**************************************************************************************************
* background variables.

*Age categories.
recode age (0,1=1) (2,3=2) (4,5=3) (6 thru 8=4) (9 thru 11=5) (12 thru 17=6) (18 thru 23=7) into agecats.
variable labels agecats "Age categories".
value labels agecats
1 " 0-1"
2 " 2-3"
3 " 4-5"
4 " 6-8"
5 " 9-11"
6 " 12-17"
7 " 18-23".

*Age category 6-23.
recode age (6 thru 23=1) (else=0) into agecats623.
variable labels agecats623 "Age category 6-23".
value labels agecats623 1 " 6-23" 0 "Ourside range".

**************************************************************************************************
* Breastfeeding status 
**************************************************************************************************
*Breastfeeding status.

*Age categories.
crosstabs 
    /tables = agecats by nt_bf_status
    /format = avalue tables
    /cells = row 
    /count asis.

*Age 0-3.
compute filter = age<4.
filter by filter.
frequencies variables =  nt_bf_status.
filter off.

*Age 0-5.
compute filter = age<6.
filter by filter.
frequencies variables =  nt_bf_status.
filter off.

*Age 6-9.
compute filter = (age>5 & age<10).
filter by filter.
frequencies variables =  nt_bf_status.
filter off.

*Age 12-15.
compute filter = (age>11 & age<16).
filter by filter.
frequencies variables =  nt_bf_status.
filter off.

*Age 12-23.
compute filter = (age>11 & age<24).
filter by filter.
frequencies variables =  nt_bf_status.
filter off.

*Age 20-23.
compute filter = (age>19 & age<24).
filter by filter.
frequencies variables =  nt_bf_status.
filter off.

**************************************************************************************************
*Currently breastfeeding.
*Age categories.
crosstabs 
    /tables = agecats by nt_bf_curr
    /format = avalue tables
    /cells = row 
    /count asis.

*Age 0-3.
compute filter = age<4.
filter by filter.
frequencies variables =  nt_bf_curr.
filter off.

*Age 0-5.
compute filter = age<6.
filter by filter.
frequencies variables =  nt_bf_curr.
filter off.

*Age 6-9.
compute filter = (age>5 & age<10).
filter by filter.
frequencies variables =  nt_bf_curr.
filter off.

*Age 12-15.
compute filter = (age>11 & age<16).
filter by filter.
frequencies variables =  nt_bf_curr.
filter off.

*Age 12-23.
compute filter = (age>11 & age<24).
filter by filter.
frequencies variables =  nt_bf_curr.
filter off.

*Age 20-23.
compute filter = (age>19 & age<24).
filter by filter.
frequencies variables =  nt_bf_curr.
filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_brst_fed.xlsx"
     operation=createfile.

output close * .

**************************************************************************************************
* IYCF indicators
**************************************************************************************************
*Exclusive breastfeeding.

*Age under 6.
compute filter=age<6.
filter by filter.
frequencies variables =  nt_ebf.
filter off.

*Age 5-6.
compute filter=age>=4 & age<6.
filter by filter.
frequencies variables =  nt_ebf.
filter off.

**************************************************************************************************
*Continued breastfeeding.

* Continued breastfeeding at 1 year for children 12-15 months.
frequencies variables =  nt_bf_cont_1yr.

* Continued breastfeeding at 2 years for children 20-23 months.
frequencies variables = nt_bf_cont_2yr.

*Introduction of solid, semi-solid, or soft foods.
frequencies variables = nt_food_bf.

*Age appropriate breastfeeding.
frequencies variables = nt_ageapp_bf.

*Predominantly breastfeeding.
frequencies variables = nt_predo_bf.

**************************************************************************************************
* Foods and liquids consumed
**************************************************************************************************

*** Among breastfeeding children ***

compute filter=nt_bf_curr=1.
filter by filter.

*Infant formula.
crosstabs 
    /tables = agecats agecats623 by nt_formula
    /format = avalue tables
    /cells = row 
    /count asis.

*Other milk.
crosstabs 
    /tables = agecats agecats623 by nt_milk
    /format = avalue tables
    /cells = row 
    /count asis.

*Other liquids.
crosstabs 
    /tables = agecats agecats623 by nt_liquids
    /format = avalue tables
    /cells = row 
    /count asis.

*Fortified baby foods.
crosstabs 
    /tables = agecats agecats623 by nt_bbyfood
    /format = avalue tables
    /cells = row 
    /count asis.

*Grains.
crosstabs 
    /tables = agecats agecats623 by nt_grains
    /format = avalue tables
    /cells = row 
    /count asis. 

*Fruits and vegetables rich in Vit. A.
crosstabs 
    /tables = agecats agecats623 by nt_vita
    /format = avalue tables
    /cells = row 
    /count asis. 

*Other fruits and vegetables.
crosstabs 
    /tables = agecats agecats623 by nt_frtveg
    /format = avalue tables
    /cells = row 
    /count asis. 

*Roots and tubers.
crosstabs 
    /tables = agecats agecats623 by nt_root
    /format = avalue tables
    /cells = row 
    /count asis. 

*Nuts and legumes.
crosstabs 
    /tables = agecats agecats623 by nt_nuts
    /format = avalue tables
    /cells = row 
    /count asis. 

*Meat, fish, poultry.
crosstabs 
    /tables = agecats agecats623 by nt_meatfish
    /format = avalue tables
    /cells = row 
    /count asis. 

*Eggs.
crosstabs 
    /tables = agecats agecats623 by nt_eggs
    /format = avalue tables
    /cells = row 
    /count asis. 

*Dairy.
crosstabs 
    /tables = agecats agecats623 by nt_dairy
    /format = avalue tables
    /cells = row 
    /count asis. 

*Any solid or semi-solid food.
crosstabs 
    /tables = agecats agecats623 by nt_solids
    /format = avalue tables
    /cells = row 
    /count asis. 

filter off.

*** Among non-breastfeeding children ***

compute filter=nt_bf_curr=0.
filter by filter.

*Infant formula.
crosstabs 
    /tables = agecats agecats623 by nt_formula
    /format = avalue tables
    /cells = row 
    /count asis.

*Other milk.
crosstabs 
    /tables = agecats agecats623 by nt_milk
    /format = avalue tables
    /cells = row 
    /count asis.

*Other liquids.
crosstabs 
    /tables = agecats agecats623 by nt_liquids
    /format = avalue tables
    /cells = row 
    /count asis.

*Fortified baby foods.
crosstabs 
    /tables = agecats agecats623 by nt_bbyfood
    /format = avalue tables
    /cells = row 
    /count asis.

*Grains.
crosstabs 
    /tables = agecats agecats623 by nt_grains
    /format = avalue tables
    /cells = row 
    /count asis. 

*Fruits and vegetables rich in Vit. A.
crosstabs 
    /tables = agecats agecats623 by nt_vita
    /format = avalue tables
    /cells = row 
    /count asis. 

*Other fruits and vegetables.
crosstabs 
    /tables = agecats agecats623 by nt_frtveg
    /format = avalue tables
    /cells = row 
    /count asis. 

*Roots and tubers.
crosstabs 
    /tables = agecats agecats623 by nt_root
    /format = avalue tables
    /cells = row 
    /count asis. 

*Nuts and legumes.
crosstabs 
    /tables = agecats agecats623 by nt_nuts
    /format = avalue tables
    /cells = row 
    /count asis. 

*Meat, fish, poultry.
crosstabs 
    /tables = agecats agecats623 by nt_meatfish
    /format = avalue tables
    /cells = row 
    /count asis. 

*Eggs.
crosstabs 
    /tables = agecats agecats623 by nt_eggs
    /format = avalue tables
    /cells = row 
    /count asis. 

*Dairy.
crosstabs 
    /tables = agecats agecats623 by nt_dairy
    /format = avalue tables
    /cells = row 
    /count asis. 

*Any solid or semi-solid food.
crosstabs 
    /tables = agecats agecats623 by nt_solids
    /format = avalue tables
    /cells = row 
    /count asis. 

filter off.

**************************************************************************************************
* Minimum acceptable diet
**************************************************************************************************

*** Among breastfeeding children ***

compute filter=(nt_bf_curr=1 and age>=6 and age<=23).
filter by filter.

*Minimum dietary diversity.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mdd [c] [rowpct.validn '' f5.1] + nt_mdd [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum dietary diversity among breastfeeding children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mdd
    /format = avalue tables
    /cells = row 
    /count asis.

****
*Minimum meal frequency.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mmf [c] [rowpct.validn '' f5.1] + nt_mmf [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum meal frequency among breastfeeding children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mmf
    /format = avalue tables
    /cells = row 
    /count asis.

****
*Minimum acceptable diet.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mad [c] [rowpct.validn '' f5.1] + nt_mad [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum acceptable diet among breastfeeding children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mad
    /format = avalue tables
    /cells = row 
    /count asis.

********************
*** Among non-breastfeeding children ***

filter off.
compute filter=(nt_bf_curr=0 and age>=6 and age<=23).
filter by filter.

*Given milk or milk products.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_fed_milk [c] [rowpct.validn '' f5.1] + nt_fed_milk [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Milk or milk products among non-breastfeeding children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_fed_milk
    /format = avalue tables
    /cells = row 
    /count asis.

****

*Minimum dietary diversity.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mdd [c] [rowpct.validn '' f5.1] + nt_mdd [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum dietary diversity among non-breastfeeding children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mdd
    /format = avalue tables
    /cells = row 
    /count asis.

****
*Minimum meal frequency.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mmf [c] [rowpct.validn '' f5.1] + nt_mmf [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum meal frequency among non-breastfeeding children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mmf
    /format = avalue tables
    /cells = row 
    /count asis.

****
*Minimum acceptable diet.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mad [c] [rowpct.validn '' f5.1] + nt_mad [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum acceptable diet among non-breastfeeding children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mad
    /format = avalue tables
    /cells = row 
    /count asis.

********************

*** Among all children ***

filter off.
compute filter=age>=6 and age<=23.
filter by filter.

*Given milk or milk products.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_fed_milk [c] [rowpct.validn '' f5.1] + nt_fed_milk [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Milk or milk products among all children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_fed_milk
    /format = avalue tables
    /cells = row 
    /count asis.

****

*Minimum dietary diversity.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mdd [c] [rowpct.validn '' f5.1] + nt_mdd [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum dietary diversity among all children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mdd
    /format = avalue tables
    /cells = row 
    /count asis.

****
*Minimum meal frequency.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mmf [c] [rowpct.validn '' f5.1] + nt_mmf [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum meal frequency among all children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mmf
    /format = avalue tables
    /cells = row 
    /count asis.

****
*Minimum acceptable diet.
ctables
  /table  agecats [c] +
            b4 [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_mad [c] [rowpct.validn '' f5.1] + nt_mad [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Minimum acceptable diet among all children".		

*crosstabs 
    /tables = b4 v025 v024 v106 v190 by nt_mad
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_IYCF.xlsx"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .

**************************************************************************************************
* Micronutrient intake
**************************************************************************************************
*Given foods rich in Vit A. among youngest children 6-23 months living with the mother.
ctables
  /table  agecats [c] +
            b4 [c] +
            nt_bf_curr [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_micro_vaf [c] [rowpct.validn '' f5.1] + nt_ch_micro_vaf [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given foods rich in Vit A. among youngest children 6-23 months living with the mother".		

*crosstabs 
    /tables = agecats b4 nt_bf_curr agem v025 v024 v106 v190 by nt_ch_micro_vaf
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Given foods rich in iron among youngest children 6-23 months living with the mother.
ctables
  /table  agecats [c] +
            b4 [c] +
            nt_bf_curr [c] +
            agem [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c]
              by
         nt_ch_micro_irf [c] [rowpct.validn '' f5.1] + nt_ch_micro_irf [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given foods rich in iron among youngest children 6-23 months living with the mother".		

*crosstabs 
    /tables = agecats b4 nt_bf_curr agem v025 v024 v106 v190 by nt_ch_micro_irf
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

new file.



