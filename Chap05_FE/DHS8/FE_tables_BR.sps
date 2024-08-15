* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FE_tables_BR.sps
Purpose: 			produce tables for fertility indicators
Author:				Ivana Bjelic
Date last modified: September 29 2020 by Ivana Bjelic

*This do file will produce the following table in excel:
	FE_tables:		Contains the tables for most fertility indicators created in the FE_INT sps file.

*Notes: 
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

* indicators from BR file.

**************************************************************************************************
* Birth intervals, distribution of non-first births in last 5 years by background variables.
ctables
  /table  fe_age_int [c] +           /* mother's age
            fe_pre_sex [c] +          /* sex of preceding birth
            fe_pre_surv [c] +          /* survival of preceding birth
            fe_bord_cat [c] +         /* birth order
            residence [c] +            /* residence
            region [c] +                 /* region
            education [c] +            /* mother's education
            v190 [c]                       /* wealth
              by
         fe_int [c] [rowpct.validn '' f5.1] + fe_int [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Birth intervals, distribution of non-first births in last 5 years by background variables".		

*crosstabs 
    /tables = fe_age_int fe_pre_sex fe_pre_surv fe_bord_cat residence region education wealth by fe_int
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Median number of months since preceding birth by background variables.
* median months since previous birth of non-first births in last 5 yrs, by subgroup.

sort cases by fe_age_int.
split file by fe_age_int.
descriptives variables = med_mo_fe_age_int /statistics = mean.
split file off.

sort cases by fe_pre_sex.
split file by fe_pre_sex.
descriptives variables = med_mo_fe_pre_sex /statistics = mean.
split file off.

sort cases by fe_pre_surv.
split file by fe_pre_surv.
descriptives variables = med_mo_fe_pre_surv /statistics = mean.
split file off.

sort cases by fe_bord_cat.
split file by fe_bord_cat.
descriptives variables = med_mo_fe_bord_cat /statistics = mean.
split file off.

sort cases by region.
split file by region.
descriptives variables = med_mo_region /statistics = mean.
split file off.

sort cases by residence.
split file by residence.
descriptives variables = med_mo_residence /statistics = mean.
split file off.

sort cases by education.
split file by education.
descriptives variables = med_mo_education /statistics = mean.
split file off.

sort cases by wealth.
split file by wealth.
descriptives variables = med_mo_wealth /statistics = mean.
split file off.


****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_FE_Fert.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .


new file.