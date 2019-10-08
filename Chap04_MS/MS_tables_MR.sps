* Encoding: windows-1252.
*****************************************************************************************************
Program: 			MS_tables_MR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: Sept 29 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_Mar_mn:		Contains the tables for knowledge indicators for men
	2. 	Tables_Sex_mn:		Contains the tables for current use of family planning for women + timing of sterlization

*
Notes: 
*****************************************************************************************************.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs.

* indicators from MR file.

compute wt=mv005/1000000.
weight by wt.


**************************************************************************************************
* Indicators for marriage: excel file Tables_Mar_mn will be produced
**************************************************************************************************.
*Marital status among men age 15-49.
compute filter = mv013<8.
filter by filter.
frequencies variables = ms_mar_stat ms_mar_union.

****************************************************
*Marital status by background variables among men age 15-49

*age (15-49).
ctables
  /table  mv013 [c] by
         ms_mar_stat [c] [rowpct.validn '' f5.1]+ ms_mar_stat [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=ms_mar_stat mv013 total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital status by background variables: age".

*crosstabs 
    /tables = mv013 by ms_mar_stat
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently in union by background variables among men age 15-49.
ctables
  /table  mv013 [c] by
         ms_mar_union [c] [rowpct.validn '' f5.1]+ ms_mar_union [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=ms_mar_union mv013 total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently in union by background variables: age".

*crosstabs 
    /tables = mv013 by ms_mar_union
    /format = avalue tables
    /cells = row 
    /count asis.
*/

****************************************************.
*Number of men's wives by background variables among men age 15-49.
ctables
  /table  mv013 [c] + mv025 [c] + mv024 [c] + mv106 [c] + mv190 [c] by
         ms_wives_num [c] [rowpct.validn '' f5.1] + ms_wives_num [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Number of men's wives by background variables among men age 15-49".

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by ms_wives_num
    /format = avalue tables
    /cells = row 
    /count asis.
*/

**************************************************************************************************
*Age at first marriage by background variables.
filter off.

*percent married by specific ages by age group.
compute mv013_2049=(mv013>=2 and mv013<8).
compute mv013_2549=(mv013>=3 and mv013<8).
compute mv013_2059=(mv013>=2).
compute mv013_2559=(mv013>=3).
recode  mv013_2049 mv013_2549 mv013_2059 mv013_2559 (0=sysmis)(else=copy).
variable labels mv013_2049 "Age".
variable labels mv013_2549 "Age".
variable labels mv013_2059 "Age".
variable labels mv013_2559 "Age".
value labels mv013_2049 1 "20-49".
value labels mv013_2549 1 "25-49".
value labels mv013_2059 1 "age 20-max age".
value labels mv013_2559 1 "age 25-max age".

*percent married by specific ages, by age group.
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_afm_15 [c] [rowpct.validn '' f5.1]+ ms_afm_15 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559  by ms_afm_15
    /format = avalue tables
    /cells = row 
    /count asis.
*/

compute filter = mv013>=2.
filter by filter.
*percent married by age 18 .
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_afm_18 [c] [rowpct.validn '' f5.1]+ ms_afm_18 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559  by ms_afm_18
    /format = avalue tables
    /cells = row 
    /count asis.
*/

*percent married by age 20.
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_afm_20 [c] [rowpct.validn '' f5.1]+ ms_afm_20 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559  by ms_afm_20
    /format = avalue tables
    /cells = row 
    /count asis.
*/

filter off.
compute filter = mv013>=3.
filter by filter.

*percent married by age 22.
ctables
  /table  mv013 [c] +  mv013_2549 [c] + mv013_2559 [c] by
         ms_afm_22 [c] [rowpct.validn '' f5.1]+ ms_afm_22 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = mv013 mv013_2549 mv013_2559  by ms_afm_22
    /format = avalue tables
    /cells = row 
    /count asis.
*/


*percent married by age 25.
ctables
  /table  mv013 [c] + mv013_2549 [c] + mv013_2559 [c] by
         ms_afm_25 [c] [rowpct.validn '' f5.1]+ ms_afm_25 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent married by specific ages, by age group".

*crosstabs 
    /tables = mv013 mv013_2549 mv013_2559  by ms_afm_25
    /format = avalue tables
    /cells = row 
    /count asis.
*/.

filter off.


**************************************************************************************************
*Never in union by background variables.
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_mar_never [c] [rowpct.validn '' f5.1] + ms_mar_never [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Never in union by background variables".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559 by ms_mar_never
    /format = avalue tables
    /cells = row 
    /count asis.
*/

**************************************************************************************************
*Median age at first marriage by background variables.
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
    mafm_2059_all1
    mafm_2559_all1
 /statistics = mean.

*median age at first marriage among 25-49 yr olds, by subgroup.

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
  /xls  documentfile="Tables_Mar_mn.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for sex: excel file Tables_Sex_mn will be produced
**************************************************************************************************

**************************************************************************************************
*Age at first sex by background variables.

*percent had sex by specific ages, by age group.

*percent who had sex by age 15.
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_afs_15 [c] [rowpct.validn '' f5.1]+ ms_afs_15 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 15, by age group".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559  by ms_afs_15
    /format = avalue tables
    /cells = row 
    /count asis.
*/

compute filter = mv013>=2.
filter by filter.
*percent who had sex by age 18.
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_afs_18 [c] [rowpct.validn '' f5.1]+ ms_afs_18 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 18, by age group".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559  by ms_afs_18
    /format = avalue tables
    /cells = row 
    /count asis.
*/

*percent who had sex by age 20.
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_afs_20 [c] [rowpct.validn '' f5.1]+ ms_afs_20 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 20, by age group".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559  by ms_afs_20
    /format = avalue tables
    /cells = row 
    /count asis.
*/

filter off.

compute filter = mv013>=3.
filter by filter.
*percent who had sex by age 22.
ctables
  /table  mv013 [c] +  mv013_2549 [c] + mv013_2559 [c] by
         ms_afs_22 [c] [rowpct.validn '' f5.1]+ ms_afs_22 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 22, by age group".

*crosstabs 
    /tables = mv013 mv013_2549 mv013_2559  by ms_afs_22
    /format = avalue tables
    /cells = row 
    /count asis.
*/
*percent who had sex by age 25.
ctables
  /table  mv013 [c] +  mv013_2549 [c] + mv013_2559 [c] by
         ms_afs_25 [c] [rowpct.validn '' f5.1]+ ms_afs_25 [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent who had sex by age 25, by age group".

*crosstabs 
    /tables = mv013 mv013_2549 mv013_2559  by ms_afs_25
    /format = avalue tables
    /cells = row 
    /count asis.
*/

filter off.

**************************************************************************************************
*Never had sex by background variables.
ctables
  /table  mv013 [c] +  mv013_2049 [c] + mv013_2549 [c] + mv013_2059 [c] + mv013_2559 [c] by
         ms_sex_never [c] [rowpct.validn '' f5.1]+ ms_sex_never [s] [validn, 'Number', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Never had sex by background variables".

*crosstabs 
    /tables = mv013 mv013_2049 mv013_2549 mv013_2059 mv013_2559  by ms_sex_never
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
    mafs_2059_all1
    mafs_2559_all1
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
  /xls  documentfile="Tables_Sex_mn.xls"
     operation=createfile.

output close * .

new file.	
	
	

