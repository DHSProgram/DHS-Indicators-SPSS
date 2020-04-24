* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HV_tables_MR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: April 1, 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1.	Tables_prev_wm:	Contains the tables for HIV prevalence for women
	2.	Tables_prev_mn:	Contains the tables for HIV prevalence for men
	3.	Tables_prev_tot:	Contains the tables for HIV prevalence for total
	4.	Tables_circum:	Contains the tables for HIV prevalence by male circumcision
	5.	Tables_prev_cpl:	Contains the tables for HIV prevalence for couples
*
Notes: 	Not all surveys have testing that distinguish between HIV-1 and HIV-2. These tables are commented out in lines 102-162. Uncomment if you need them. 
		
*****************************************************************************************************.
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.


****************************************************************************
****************************************************************************

* indicators from MR file.

* These tables actually use the IRMRARmerge.sav file and not the MR file

* use HIV weight.
compute wt=hiv05/1000000.

weight by wt.

**************************************************************************************************
* HIV prevalence
**************************************************************************************************
*HIV positive.
*by age for women.

compute filter = (sex=2).
filter by filter.
ctables
  /table  v013 [c]  
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "HIV positive by age for women".		

*crosstabs 
    /tables = v013 by hv_hiv_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_wm.xls"
     operation=createfile.

output close * .

*by age for men.
filter off.
compute filter = (sex=1).
filter by filter.
ctables
  /table  v013 [c]  
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "HIV positive by age for men".	

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_mn.xls"
     operation=createfile.

output close * .	

*crosstabs 
    /tables = v013 by hv_hiv_pos
    /format = avalue tables
    /cells = row 
    /count asis.

*by age - Total.
filter off.
ctables
  /table  v013 [c]  
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "HIV positive by age - Total".		

*crosstabs 
    /tables = v013 by hv_hiv_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_tot.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* For surveys with testing to distinguish between HIV-1 and HIV-2.
* Tabulation is for HIV-1, HIV-2, and HIV-1 or HIV-2 indicators.

*age for women.
*by age for women.

 * compute filter = (sex=2).
 * filter by filter.
 * ctables
  /table  v013 [c]  
              by
         hv_hiv1_pos [c] [rowpct.validn '' f5.1] + hv_hiv2_pos [c] [rowpct.validn '' f5.1]  + hv_hiv1or2_pos  [c] [rowpct.validn '' f5.1] +  hv_hiv1_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tabulation is for HIV-1, HIV-2, and HIV-1 or HIV-2 indicators by age for women".		

*crosstabs 
    /tables = v013 by hv_hiv1_pos hv_hiv2_pos hv_hiv1or2_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
*output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_wm.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

*output close * .

*by age for men.
 * filter off.
 * compute filter = (sex=1).
 * filter by filter.
 * ctables
  /table  v013 [c]  
              by
         hv_hiv1_pos [c] [rowpct.validn '' f5.1] + hv_hiv2_pos [c] [rowpct.validn '' f5.1]  + hv_hiv1or2_pos  [c] [rowpct.validn '' f5.1] +  hv_hiv1_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tabulation is for HIV-1, HIV-2, and HIV-1 or HIV-2 indicators by age for men".		

*crosstabs 
    /tables = v013 by hv_hiv1_pos hv_hiv2_pos hv_hiv1or2_pos
    /format = avalue tables
    /cells = row 
    /count asis.

*output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_mn.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

*output close * .

*by age - Total.
 * filter off.
 * ctables
  /table  v013 [c]  
              by
        hv_hiv1_pos [c] [rowpct.validn '' f5.1] + hv_hiv2_pos [c] [rowpct.validn '' f5.1]  + hv_hiv1or2_pos  [c] [rowpct.validn '' f5.1] +  hv_hiv1_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tabulation is for HIV-1, HIV-2, and HIV-1 or HIV-2 indicators by age - Total".		

*crosstabs 
    /tables = v013 by hv_hiv1_pos hv_hiv2_pos hv_hiv1or2_pos
    /format = avalue tables
    /cells = row 
    /count asis.

*output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_tot.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

*output close * .

**************************************************************************************************
* HIV prevalence - by background variables
**************************************************************************************************
*** Tables for HIV positive among women 15-49 by background variables.
*ethnicity.
*religion.
*employment.
*residence.
*region.
*education.
*wealth.
*marital status.
*type of union - polygamy.
*times slept away from home .
*time away for more than 1 month.
*currently pregnant.
*ANC place for last birth in the past 3 years.
*Age at first sexual intercourse.
*number of lifetime partners.
*multiple sexual partners in the past 12 months.
*Non-marital, non-cohabiting partner in the past 12 months.
*Condom use at last sexual intercourse in past 12 months.
*STI in the past 12 months.
*Had prior HIV test and whether they received results.

compute filter = (sex=2).
filter by filter.
ctables
  /table  v131 [c] +
            v130 [c] +    
            empl [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] + 
            v501 [c] + 
            poly_w [c] +
            timeaway [c] +
            timeaway12m [c] +
            preg [c] +
            ancplace [c] +
            agesex [c] +
            numprtnr [c] +
            multisex [c] +
            prtnrcohab [c] +
            condomuse [c] +
            sti12m [c] +
            test_prior [c]            
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tables for HIV positive among women 15-49 by background variables".	
	

*crosstabs 
    /tables =  v131 v130 empl v025 v024 v106 v190 v501 poly_w timeaway timeaway12m preg ancplac agesex numprtnr multisex prtnrcohab condomuse sti12m test_prior by hv_hiv_pos_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_wm.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .

**************************************************************************************************
*** Tables for HIV positive among men 15-49 by background variables.
*ethnicity.
*religion.
*employment.
*residence.
*region.
*education.
*wealth.
*marital status.
*type of union - polygamy.
*times slept away from home .
*time away for more than 1 month.
*currently pregnant.
*ANC place for last birth in the past 3 years.
*Age at first sexual intercourse.
*number of lifetime partners.
*multiple sexual partners in the past 12 months.
*Non-marital, non-cohabiting partner in the past 12 months.
*Condom use at last sexual intercourse in past 12 months.
*STI in the past 12 months.
*Had prior HIV test and whether they received results.

filter off.
compute filter = (sex=1).
filter by filter.
ctables
  /table  v131 [c] +
            v130 [c] +
            empl [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] +
            v501 [c] +
            poly_m [c] + 
            timeaway [c] + 
            timeaway12m [c] +
            agesex [c] +
            numprtnr [c] +
            multisex [c] +
            prtnrcohab [c] + 
            condomuse [c] +
            paidsex [c] +
            sti12m [c] +
            test_prior [c] 
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tables for HIV positive among men 15-49 by background variables".		

*crosstabs 
    /tables = v131 v130 empl v025 v024 v106 v190 v501 poly_w timeaway timeaway12m preg ancplac agesex numprtnr multisex prtnrcohab condomuse sti12m test_prior by hv_hiv_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_mn.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .

**************************************************************************************************.
*** Tables for HIV positive among men and women (15-49) for Total by background variables
*ethnicity.
*religion.
*employment.
*residence.
*region.
*education.
*wealth.
*marital status.
*type of union - polygamy.
*times slept away from home .
*time away for more than 1 month.
*currently pregnant.
*ANC place for last birth in the past 3 years.
*Age at first sexual intercourse.
*number of lifetime partners.
*multiple sexual partners in the past 12 months.
*Non-marital, non-cohabiting partner in the past 12 months.
*Condom use at last sexual intercourse in past 12 months.
*STI in the past 12 months.
*Had prior HIV test and whether they received results.

filter off.
ctables
  /table  v131 [c] + 
            v130 [c] + 
            empl [c] +
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] +
            v501 [c] +
            poly_t [c] +
            timeaway [c] +
            timeaway12m [c] +
            agesex [c] +
            numprtnr [c] +
            multisex [c] +
            prtnrcohab [c] +
            condomuse [c] +
            sti12m [c] +
            test_prior [c] 
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tables for HIV positive among men and women (15-49) for Total by background variables".		

*crosstabs 
    /tables =  v131 v130 empl v025 v024 v106 v190 v501 poly_w timeaway timeaway12m preg ancplac agesex numprtnr multisex prtnrcohab condomuse sti12m test_prior by hv_hiv1_pos hv_hiv2_pos hv_hiv1or2_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_tot.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .

**************************************************************************************************
*** Tables for HIV positive among young women (15-24) by background variables.

compute filter = (sex=2 & v013<3).
filter by filter.
ctables
  /table  age_yng [c] +
            v501 [c] +    
            preg [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] + 
            multisex [c] +
            prtnrcohab [c] +
            condomuse [c]
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tables for HIV positive among young women (15-24) by background variables".		

*crosstabs 
    /tables = age_yng v501 preg  v025 v024 v106 v190 multisex prtnrcohab  condomuse by hv_hiv_pos_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_wm.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .


**************************************************************************************************
*** Tables for HIV positive among young men (15-24) by background variables.
filter off.
compute filter = (sex=1 & v013<3).
filter by filter.
ctables
  /table  age_yng [c] +
            v501 [c] +    
            preg [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] + 
            multisex [c] +
            prtnrcohab [c] +
            condomuse [c]
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tables for HIV positive among young men (15-24) by background variables".		

*crosstabs 
    /tables = age_yng v501 preg  v025 v024 v106 v190 multisex prtnrcohab  condomuse by hv_hiv_pos_pos
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_mn.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .


**************************************************************************************************
*** Tables for HIV positive among young men and women (15-24) for Total by background variables.
filter off.
compute filter = (v013<3).
filter by filter.
ctables
  /table  age_yng [c] +
            v501 [c] +    
            preg [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] + 
            multisex [c] +
            prtnrcohab [c] +
            condomuse [c]
              by
         hv_hiv_pos [c] [rowpct.validn '' f5.1] + hv_hiv_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tables for HIV positive among young men (15-24) by background variables".		

*crosstabs 
    /tables = age_yng v501 preg  v025 v024 v106 v190 multisex prtnrcohab  condomuse by hv_hiv_pos_pos
    /format = avalue tables
    /cells = row 
    /count asis.

filter off.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_tot.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow.

output close * .

**************************************************************************************************
* Prior HIV testing by current HIV status
**************************************************************************************************
* among HIV positive women.
compute filter = (sex=2).
filter by filter.
frequencies variables = hv_pos_ever_test hv_pos_12m_test hv_pos_more12m_test hv_pos_ever_noresult hv_pos_nottested.

* among HIV negative women.
frequencies variables = hv_neg_ever_test hv_neg_12m_test hv_neg_more12m_test hv_neg_ever_noresult hv_neg_nottested.
	
filter off.

**********************
* among HIV positive men.
compute filter = (sex=1).
filter by filter.
frequencies variables = hv_pos_ever_test hv_pos_12m_test hv_pos_more12m_test hv_pos_ever_noresult hv_pos_nottested.

* among HIV negative men.
frequencies variables = hv_neg_ever_test hv_neg_12m_test hv_neg_more12m_test hv_neg_ever_noresult hv_neg_nottested.

filter off.

**********************
* among HIV positive total.
frequencies variables = hv_pos_ever_test hv_pos_12m_test hv_pos_more12m_test hv_pos_ever_noresult hv_pos_nottested.

* among HIV negative total.
frequencies variables = hv_neg_ever_test hv_neg_12m_test hv_neg_more12m_test hv_neg_ever_noresult hv_neg_nottested.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prior_tests.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* HIV prevalence by male circumcision
**************************************************************************************************
* Circumcised by health professional.
compute filter = (sex=1).
filter by filter.

ctables
  /table  v013 [c] +
            v131 [c] +    
            v130 [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] 
              by
         hv_hiv_circum_skilled [c] [rowpct.validn '' f5.1] + hv_hiv_circum_skilled [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Circumcised by health professional".		

*crosstabs 
    /tables = v013 v131 v130 v025 v024 v106 v190 by hv_hiv_circum_skilled
    /format = avalue tables
    /cells = row 
    /count asis.

***********
* Circumcised by traditional/other.
ctables
  /table  v013 [c] +
            v131 [c] +    
            v130 [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] 
              by
         hv_hiv_circum_trad [c] [rowpct.validn '' f5.1] + hv_hiv_circum_trad [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Circumcised by traditional/other".		

*crosstabs 
    /tables = v013 v131 v130 v025 v024 v106 v190 by hv_hiv_circum_trad
    /format = avalue tables
    /cells = row 
    /count asis.

***********
* All circumcised.
ctables
  /table  v013 [c] +
            v131 [c] +    
            v130 [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] 
              by
         hv_hiv_circum_pos [c] [rowpct.validn '' f5.1] + hv_hiv_circum_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "All circumcised".		

*crosstabs 
    /tables = v013 v131 v130 v025 v024 v106 v190 by hv_hiv_circum_pos
    /format = avalue tables
    /cells = row 
    /count asis.

***********		
* Uncircumcised.
ctables
  /table  v013 [c] +
            v131 [c] +    
            v130 [c] +    
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] 
              by
         hv_hiv_uncircum_pos [c] [rowpct.validn '' f5.1] + hv_hiv_uncircum_pos [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Uncircumcised".		

*crosstabs 
    /tables = v013 v131 v130 v025 v024 v106 v190 by hv_hiv_uncircum_pos
    /format = avalue tables
    /cells = row 
    /count asis.

***********		
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_circum.xls"
     operation=createfile.

output close * .

new file.