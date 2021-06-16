* Encoding: windows-1252.
*****************************************************************************************************
Program: 			MS_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: Sept 25 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Tables_Mar_wm:		Contains the tables for knowledge indicators for women
	2. 	Tables_Sex_wm:		Contains the tables for ever use of family planning for women

*Notes: For women the indicators are outputed for age 15-49 in line 25. 
*This can be commented out if the indicators are required for all women.	 
*****************************************************************************************************.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs.

* limiting to women age 15-49.
select if not(v012<15 | v012>49).

compute wt=v005/1000000.
weight by wt.

* indicators from IR file.
**************************************************************************************************
* Indicators for marriage: excel file Tables_Mar_wm will be produced
**************************************************************************************************
*Marital status.
frequencies variables = ms_mar_stat ms_mar_union.

*/
****************************************************
*Marital status by background variables.

*age and marital status.
ctables
  /table  v013 [c] by
         ms_mar_stat [c] [rowpct.validn '' f5.1]+ ms_mar_stat [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=ms_mar_stat v013 total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital status by background variables: age".

*crosstabs 
    /tables = v013 by ms_mar_stat
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently in union by background variables.

ctables
  /table  v013 [c] by
         ms_mar_union [c] [rowpct.validn '' f5.1]+ ms_mar_union [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=ms_mar_union v013 total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently in union by background variables: age".

*crosstabs 
    /tables = v013 by ms_mar_union
    /format = avalue tables
    /cells = row 
    /count asis.
*/

****************************************************
*Number of women's co-wives by background variables.
ctables
  /table  v013 [c] + v025 [c] + v024 [c] + v106 [c] + v190 [c] by
         ms_cowives_num [c] [rowpct.validn '' f5.1]+ ms_cowives_num [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Number of women's co-wives by background variables".

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by ms_cowives_num
    /format = avalue tables
    /cells = row 
    /count asis.
*/

****************************************************
*Women with one ore more co-wives by background variables.
ctables
  /table  v013 [c] + v025 [c] + v024 [c] + v106 [c] + v190 [c] by
         ms_cowives_any [c] [rowpct.validn '' f5.1]+ ms_cowives_num [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Women with one ore more co-wives by background variables".

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by ms_cowives_any
    /format = avalue tables
    /cells = row 
    /count asis.
*/


**************************************************************************************************
*Age at first marriage by background variables.

compute v013_2049=(v013>=2).
compute v013_2549=(v013>=3).
recode  v013_2049 v013_2549 (0=sysmis)(else=copy).
variable labels v013_2049 "Age".
variable labels v013_2549 "Age".
value labels v013_2049 1 "20-49".
value labels v013_2549 1 "25-49".

*percent married by specific ages, by age group.
ctables
  /table  v013 [c] +  v013_2049 [c] + v013_2549 [c] by
         ms_afm_15 [c] [rowpct.validn '' f5.1]+ ms_afm_15 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by ms_afm_15
    /format = avalue tables
    /cells = row 
    /count asis.
*/

compute filter = v013>=2.
filter by filter.

ctables
  /table  v013 [c] +  v013_2049 [c] + v013_2549 [c] by
          ms_afm_18 [c] [rowpct.validn '' f5.1]+  ms_afm_18 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by  ms_afm_18
    /format = avalue tables
    /cells = row 
    /count asis.
*/

ctables
  /table  v013 [c] +  v013_2049 [c] + v013_2549 [c] by
          ms_afm_20 [c] [rowpct.validn '' f5.1]+  ms_afm_20 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by  ms_afm_20
    /format = avalue tables
    /cells = row 
    /count asis.
*/

filter off.


compute filter = v013>=3.
filter by filter.

ctables
  /table  v013 [c] +  v013_2549 [c] by
          ms_afm_22 [c] [rowpct.validn '' f5.1]+  ms_afm_22 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = v013 v013_2549 by  ms_afm_22
    /format = avalue tables
    /cells = row 
    /count asis.
*/

ctables
  /table  v013 [c] + v013_2549 [c] by
          ms_afm_25 [c] [rowpct.validn '' f5.1]+  ms_afm_25 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by  ms_afm_25
    /format = avalue tables
    /cells = row 
    /count asis.
*/

filter off.

**************************************************************************************************
*Never in union by background variables.

*never in union by age group.
ctables
  /table  v013 [c] +  v013_2049 [c] + v013_2549 [c] by
          ms_mar_never [c] [rowpct.validn '' f5.1]+  ms_mar_never [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Never in union by background variables".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by  ms_afm_20
    /format = avalue tables
    /cells = row 
    /count asis.
*/


**************************************************************************************************
*Median age at first marraige by background variables.

*median age at first marriage by age group.
descriptives variables =
    mafm_1519_all1
    mafm_2024_all1
    mafm_2529_all1
    mafm_3034_all1
    mafm_3539_all1
    mafm_4044_all1
    mafm_4549_all1
    mafm_2049_all1
    mafm_2549_all1
 /statistics = mean.

*median ages by subgroups, CHANGE AGE RANGE HERE IF NEEDED (change var from mafm_2549_ to mafm_20-49_ for median age among those age 20-49 yrs old).
sort cases by residence.
split file by residence.
descriptives variables = mafm_2549_residence /statistics = mean.
split file off.

sort cases by region.
split file by region.
descriptives variables = mafm_2549_region /statistics = mean.
split file off.

sort cases by education.
split file by education.
descriptives variables = mafm_2549_education /statistics = mean.
split file off.

sort cases by wealth.
split file by wealth.
descriptives variables = mafm_2549_wealth /statistics = mean.
split file off.

****************************************************.
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Mar_wm.xls"
     operation=createfile.

output close * .
	
**************************************************************************************************
* Indicators for sex: excel file Tables_Sex_wm will be produced
**************************************************************************************************

**************************************************************************************************
*Age at first sex by background variables

*percent had sex by specific ages, by age group.
ctables
  /table  v013 [c] +  v013_2049 [c] + v013_2549 [c] by
         ms_afs_15 [c] [rowpct.validn '' f5.1]+ ms_afs_15 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 15, by age".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by ms_afs_15
    /format = avalue tables
    /cells = row 
    /count asis.
*/

compute filter = v013>=2.
filter by filter.
ctables
  /table  v013 [c] + v013_2049 [c] + v013_2549 [c] by
         ms_afs_18 [c] [rowpct.validn '' f5.1]+ ms_afs_18 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 18, by age".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by ms_afs_18
    /format = avalue tables
    /cells = row 
    /count asis.
*/

ctables
  /table  v013 [c] + v013_2049 [c] + v013_2549 [c] by
         ms_afs_20 [c] [rowpct.validn '' f5.1]+ ms_afs_20 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 20, by age".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by ms_afs_20
    /format = avalue tables
    /cells = row 
    /count asis.
*/

filter off.


compute filter = v013>=3.
filter by filter.
ctables
  /table  v013 [c] +  v013_2549 [c] by
         ms_afs_22 [c] [rowpct.validn '' f5.1]+ ms_afs_22 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 22, by age".

*crosstabs 
    /tables = v013 v013_2549 by ms_afs_22
    /format = avalue tables
    /cells = row 
    /count asis.
*/

ctables
  /table  v013 [c] + v013_2549 [c] by
         ms_afs_25 [c] [rowpct.validn '' f5.1]+ ms_afs_25 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 25, by age".

*crosstabs 
    /tables = v013 v013_2549 by ms_afs_25
    /format = avalue tables
    /cells = row 
    /count asis.
*/

filter off.


**************************************************************************************************
*Never had sex by background variables.
ctables
  /table  v013 [c] +  v013_2049 [c] + v013_2549 [c] by
          ms_sex_never [c] [rowpct.validn '' f5.1]+  ms_sex_never [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Never had sex by background variables".

*crosstabs 
    /tables = v013 v013_2049 v013_2549 by ms_sex_never
    /format = avalue tables
    /cells = row 
    /count asis.
*/

**************************************************************************************************
*Median age at first sex by background variables.

*median age at first sex by age group.
descriptives variables =
    mafs_1519_all1 
    mafs_2024_all1
    mafs_2529_all1
    mafs_3034_all1
    mafs_3539_all1
    mafs_4044_all1
    mafs_4549_all1
    mafs_2049_all1
    mafs_2549_all1
 /statistics = mean.

*median age by subgroup CHANGE AGE RANGE HERE IF NEEDED (change var from mafm_2549_ to mafm_20-49_ for median age among those age 20-49 yrs old).
sort cases by residence.
split file by residence.
descriptives variables = mafs_2549_residence /statistics = mean.
split file off.

sort cases by region.
split file by region.
descriptives variables = mafs_2549_region /statistics = mean.
split file off.

sort cases by education.
split file by education.
descriptives variables = mafs_2549_education /statistics = mean.
split file off.

sort cases by wealth.
split file by wealth.
descriptives variables = mafs_2549_wealth /statistics = mean.
split file off.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Sex_wm.xls"
     operation=createfile.

output close * .

new file.

