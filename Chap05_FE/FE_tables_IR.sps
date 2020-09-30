* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FE_tables_IR.sps
Purpose: 			produce tables for fertility indicators
Author:				Ivana Bjelic
Date last modified: September 30 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	FE_tables:		Contains the tables for most fertility indicators created in the FE_FERT sps file.

*
Notes: 
*****************************************************************************************************

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.
*
subgroups dv_age residence region marital work livingchild education wealth.

*generate weight variable.
compute wt = v005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".

* indicators from IR file.

**************************************************************************************************
* Indicators for fertility: excel file Tables_FERT will be produced
**************************************************************************************************
* Currently pregnant by background variables.
ctables
  /table  v013 [c] +           /* age
            residence [c] +   /* residence
            region [c] +        /* region
            education [c] +   /* education
            wealth [c]          /* wealth
              by
         fe_preg [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently pregnant by background variables".		

*crosstabs 
    /tables = v013 residence region education wealth by fe_preg
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Complete fertility - mean number of children ever born among women age 40-49.
descriptives variables = fe_ceb_comp /statistics = mean.

* mean number of children ever born among women age 40-49, by subgroup.
sort cases by region.
split file by region.
descriptives variables = fe_ceb_comp_region /statistics = mean.
split file off.

sort cases by residence.
split file by residence.
descriptives variables = fe_ceb_comp_residence /statistics = mean.
split file off.

sort cases by education.
split file by education.
descriptives variables = fe_ceb_comp_education /statistics = mean.
split file off.

sort cases by wealth.
split file by wealth.
descriptives variables = fe_ceb_comp_wealth /statistics = mean.
split file off.
		
**************************************************************************************************
* Number of children ever born.

* number of children ever born.
frequencies variables = fe_ceb_num.

* by age.
crosstabs v013 by fe_ceb_num
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Number of children ever born among currently married women.

* number of children ever born.
compute filter = (v502=1).
filter by filter.
frequencies variables = fe_ceb_num.

* by age.
crosstabs v013 by fe_ceb_num
    /format = avalue tables
    /cells = row 
    /count asis.

filter off.

**************************************************************************************************
* Mean number of children ever born.
descriptives variables = fe_ceb_mean /statistics = mean.

* mean number of children ever born, by age group.
descriptives variables = fe_ceb_mean1 fe_ceb_mean2 fe_ceb_mean3 fe_ceb_mean4 fe_ceb_mean5 fe_ceb_mean6 fe_ceb_mean7 /statistics = mean.

		
**************************************************************************************************
* Mean number of living children.

* mean number of living children.
descriptives variables = fe_live_mean /statistics = mean.

* mean number of of living children, by age group.
descriptives variables = fe_live_mean1 fe_live_mean2 fe_live_mean3 fe_live_mean4 fe_live_mean5 fe_live_mean6 fe_live_mean7 /statistics = mean.

**************************************************************************************************
* Menopause.

* Experienced menopause.
frequencies variables fe_meno.

* by age.
crosstabs fe_meno_age by fe_meno
    /format = avalue tables
    /cells = row 
    /count asis.		
		
**************************************************************************************************	
* Age at first birth by background variables.

* percent had first birth by specific ages, by age group.
*15.
crosstabs v013 by fe_afb_15
    /format = avalue tables
    /cells = row 
    /count asis.	

compute filter = (v013>=2).
filter by filter.
frequencies variables fe_afb_15.
filter off.

compute filter = (v013>=3).
filter by filter.
frequencies variables fe_afb_15.
filter off.

*18.
crosstabs v013 by fe_afb_18
    /format = avalue tables
    /cells = row 
    /count asis.	

compute filter = (v013>=2).
filter by filter.
frequencies variables fe_afb_18.
filter off.

compute filter = (v013>=3).
filter by filter.
frequencies variables fe_afb_18.
filter off.

*20.
crosstabs v013 by fe_afb_20
    /format = avalue tables
    /cells = row 
    /count asis.	

compute filter = (v013>=2).
filter by filter.
frequencies variables fe_afb_20.
filter off.

compute filter = (v013>=3).
filter by filter.
frequencies variables fe_afb_20.
filter off.

*22.
compute filter = (v013>=3).
filter by filter.
crosstabs v013 by fe_afb_22
    /format = avalue tables
    /cells = row 
    /count asis.	

frequencies variables fe_afb_22.

*25.
crosstabs v013 by fe_afb_25
    /format = avalue tables
    /cells = row 
    /count asis.	

frequencies variables fe_afb_25.
filter off.


**************************************************************************************************
* Never given birth by background variables.

* never given birth.
crosstabs v013 by fe_birth_never
    /format = avalue tables
    /cells = row 
    /count asis.

*among 20-49 yr olds.
compute filter = (v013>=2).
filter by filter.
frequencies variables fe_birth_never.
filter off.

*among 25-49 yr olds.
compute filter = (v013>=3).
filter by filter.
frequencies variables fe_birth_never.
filter off.

**************************************************************************************************
* Median age at first birth by background variables.

*median age at first birth by age group.
descriptives variables mafb_1519_all1 mafb_2024_all1 mafb_2529_all1 mafb_3034_all1 mafb_3539_all1 mafb_4044_all1 mafb_4549_all1 mafb_2049_all1 mafb_2549_all1 /statistics = mean.

*median age at first marriage among 25-49 yr olds, by subgroup.
*subgroup residence region education wealth.
sort cases by region.
split file by region.
descriptives variables = mafb_2549_region /statistics = mean.
split file off.

sort cases by residence.
split file by residence.
descriptives variables = mafb_2549_residence /statistics = mean.
split file off.

sort cases by education.
split file by education.
descriptives variables = mafb_2549_education /statistics = mean.
split file off.

sort cases by wealth.
split file by wealth.
descriptives variables = mafb_2549_wealth /statistics = mean.
split file off.
		
**************************************************************************************************
* Teens (age 15-19) had a live birth by background variables.
compute filter = v012<=19.
filter by filter.
ctables
  /table  v012 [c] +          /* age
            v025 [c] +          /* residence
            v024 [c] +          /* region
            v106 [c] +          /* education
            v190 [c]             /* wealth
              by
         fe_teen_birth [c] [rowpct.validn '' f5.1] + fe_teen_birth [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Teens (age 15-19) had a live birth by background variables".		

*crosstabs 
    /tables = v012 residence region education wealth by fe_teen_birth
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Teens (age 15-19) currently pregnant by background variables.
ctables
  /table  v012 [c] +          /* age
            v025 [c] +          /* residence
            v024 [c] +          /* region
            v106 [c] +          /* education
            v190 [c]             /* wealth
              by
         fe_teen_preg [c] [rowpct.validn '' f5.1] + fe_teen_preg [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Teens (age 15-19) currently pregnant by background variables".		

*crosstabs 
    /tables = v012 residence region education wealth by fe_teen_preg
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Teens (age 15-19) begun childbearing by background variables.
ctables
  /table  v012 [c] +          /* age
            v025 [c] +          /* residence
            v024 [c] +          /* region
            v106 [c] +          /* education
            v190 [c]             /* wealth
              by
         fe_teen_beg [c] [rowpct.validn '' f5.1] + fe_teen_beg [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Teens (age 15-19) begun childbearing by background variables".		

*crosstabs 
    /tables = v012 residence region education wealth by fe_teen_beg
    /format = avalue tables
    /cells = row 
    /count asis.

filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_FE_Fert.xls"
     operation=createfile.

output close * .

new file.
