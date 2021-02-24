* Encoding: UTF-8.
*****************************************************************************************************
Program: 			CM_tables1.sps
Purpose: 			produce tables for child mortality and perinatal mortality
Author:			Ivana Bjelic
Date last modified: December 12 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_child_mort:	Contains the child mortality tables (Tables 1-3 in Chapter 8). See Table variable for the table number	
	2. 	Tables_PMR:	Contains the tables perinatal mortality. You need to multiply the rates in the tables by 10 to get the correct rate. 
*****************************************************************************************************/

**************************************************************************************************
* Child mortality tables: excel file Tables_child_mort will be produced
**************************************************************************************************
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies
   *descriptives to descriptives.

*open mortality data file produced by CM_CHILD.sps file. 
get file = "mortality_rates.sav".

compute filter=(total=1 and colper<=2).
filter by filter.
ctables
   /vlabels variables=colper display=none
   /table colper [c] BY (nn + pnn + imr + cmr + u5mr)[s] [mean '' comma5.0]
   /categories variables=colper empty=exclude missing=exclude
   /slabels visible = no   
   /titles title=
    "Early childhood mortality rates"			
    "Neonatal, postneonatal, infant, child, and under-5 mortality rates for five-year periods preceding the survey".

* sort cases by colper.
* split file by colper.
* descriptives variables =  nn pnn imr cmr u5mr /statistics = mean.
* split file off.

filter off.

ctables
   /table V025 [c] + V024 [c] + V106 [c] + V190 [c] + child_sex [c] + mo_age_at_birth [c] + birth_order[c] + prev_bint [c] + birth_size [c] 
   BY (nn + pnn + imr + cmr + u5mr) [s] [mean '' comma5.0]
   /categories variables=all empty=exclude missing=exclude
   /titles
    title=
     "Early childhood mortality rates by socioeconomic characteristics"				
     "Neonatal, postneonatal, infant, child, and under-5 mortality rates for the 10-year period preceding the survey, by background characteristics".	

* sort cases by V025 V024 V106 V190 B4.
* split file by  V025 V024 V106 V190 B4.
* descriptives variables =  nn pnn imr cmr u5mr /statistics = mean.
* split file off.
* sort cases by child_sex mo_age_at_birth birth_order prev_bint birth_size.
* split file by  child_sex mo_age_at_birth birth_order prev_bint birth_size.
* descriptives variables =  nn pnn imr cmr u5mr /statistics = mean.
* split file off.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_child_mort.xls"
     operation=createfile.

output close *.

**************************************************************************************************
* Stillbirths, early neonatal deaths, and perinatal mortality
**************************************************************************************************
* open PMR data file produced by CM_PMR.sav file.
get file = "CM_PMRdata.sav".

compute wt=v005/1000000.
weight by wt.

*Stillbirths, tables are for the number of stillbirths.
ctables
  /table  mo_age_at_birth [c] 
         + preg_interval [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         stillbirths  [s] [sum 'Number of stillbirths' f5.0] + stillbirths [s] [validn 'N' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=yes
  /titles title=
    "Stillbirths, tables are for the number of stillbirths".			

 * sort cases by mo_age_at_birth.
 * split file by mo_age_at_birth.
 * descriptives variables = stillbirths/statistics=sum.
 * split file off.

 * sort cases by preg_interval.
 * split file by preg_interval.
 * descriptives variables = stillbirths/statistics=sum.
 * split file off.

 * sort cases by v025.
 * split file by v025.
 * descriptives variables = stillbirths/statistics=sum.
 * split file off.

 * sort cases by v106.
 * split file by v106.
 * descriptives variables = stillbirths/statistics=sum.
 * split file off.

 * sort cases by v024.
 * split file by v024.
 * descriptives variables = stillbirths/statistics=sum.
 * split file off.

 * sort cases by v190.
 * split file by v190.
 * descriptives variables = stillbirths/statistics=sum.
 * split file off.

 * descriptives variables = stillbirths/statistics=sum.


* Early neonatal deaths, tables are for the number of early neonatal deaths.
ctables
  /table  mo_age_at_birth [c] 
         + preg_interval [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         earlyneonatal  [s] [sum 'Number of early neonatal deaths' f5.0] + earlyneonatal [s] [validn 'N' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=yes
  /titles title=
    "Early neonatal deaths, tables are for the number of early neonatal deaths".	

 * sort cases by mo_age_at_birth.
 * split file by mo_age_at_birth.
 * descriptives variables = earlyneonatal/statistics=sum.
 * split file off.

 * sort cases by preg_interval.
 * split file by preg_interval.
 * descriptives variables = earlyneonatal/statistics=sum.
 * split file off.

 * sort cases by v025.
 * split file by v025.
 * descriptives variables = earlyneonatal/statistics=sum.
 * split file off.

 * sort cases by v106.
 * split file by v106.
 * descriptives variables = earlyneonatal/statistics=sum.
 * split file off.

 * sort cases by v024.
 * split file by v024.
 * descriptives variables = earlyneonatal/statistics=sum.
 * split file off.

 * sort cases by v190.
 * split file by v190.
 * descriptives variables = earlyneonatal/statistics=sum.
 * split file off.

 * descriptives variables = earlyneonatal/statistics=sum.


* Perinatal mortality rate per 1000.
ctables
  /table  mo_age_at_birth [c] 
         + preg_interval [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         cm_peri  [s] [mean 'Perinatal mortality rate' f5.0] + cm_peri  [s] [validn 'N' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=yes
  /titles title=
    "Perinatal mortality".			

 * sort cases by mo_age_at_birth.
 * split file by mo_age_at_birth.
 * descriptives variables = cm_peri/statistics=sum.
 * split file off.

 * sort cases by preg_interval.
 * split file by preg_interval.
 * descriptives variables = cm_peri/statistics=sum.
 * split file off.

 * sort cases by v025.
 * split file by v025.
 * descriptives variables = cm_peri/statistics=sum.
 * split file off.

 * sort cases by v106.
 * split file by v106.
 * descriptives variables = cm_peri/statistics=sum.
 * split file off.

 * sort cases by v024.
 * split file by v024.
 * descriptives variables = cm_peri/statistics=sum.
 * split file off.

 * sort cases by v190.
 * split file by v190.
 * descriptives variables = cm_peri/statistics=sum.
 * split file off.

 * descriptives variables = cm_peri/statistics=sum.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_PMR.xls"
     operation=createfile.

output close *.

new file.


**************************************************************************************************
