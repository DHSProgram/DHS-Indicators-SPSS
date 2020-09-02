* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_tables2.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: July 27 2020 by  Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_pop:			Contains the tables for the household population by age, sex, and residence and birth registration
	2.	Tables_livarg_orph:		Contains the table for children's living arrangements and orphanhood

*Notes: 					 						
******************************************************************************************************.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

*open temp file produced by PH_POP.sps for population.
get file = datapath + "\PR_temp.sav".

compute wt=hv005/1000000.

weight by wt.

**************************************************************************************************
* Indicators for household population: excel file Tables_pop will be produced
**************************************************************************************************

* Among urban.
compute filter = hv025=1.
filter by filter.

* population age distribution. 
ctables
  /table  ph_pop_age [c] [colpct.validn '' f5.1] + ph_pop_age [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Population age distribution".	

*crosstabs ph_pop_age by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

* Dependency age groups.
ctables
  /table  ph_pop_depend [c] [colpct.validn '' f5.1] + ph_pop_depend [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Dependency age groups".	

*crosstabs ph_pop_depend by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

* Child and adult population.
ctables
  /table  ph_pop_cld_adlt [c] [colpct.validn '' f5.1] + ph_pop_cld_adlt [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child and adult population".	

*crosstabs ph_pop_cld_adlt by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

* Adolescent population.
ctables
  /table  ph_pop_adols [c] [colpct.validn '' f5.1] + ph_pop_adols [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Adolescent population".	

*crosstabs ph_pop_adols by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

*Among rural.
filter off.
compute filter = hv025=2.
filter by filter.

* population age distribution. 
ctables
  /table  ph_pop_age [c] [colpct.validn '' f5.1] + ph_pop_age [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Population age distribution".	

*crosstabs ph_pop_age by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

* Dependency age groups.
ctables
  /table  ph_pop_depend [c] [colpct.validn '' f5.1] + ph_pop_depend [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Dependency age groups".	

*crosstabs ph_pop_depend by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

* Child and adult population.
ctables
  /table  ph_pop_cld_adlt [c] [colpct.validn '' f5.1] + ph_pop_cld_adlt [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child and adult population".	

*crosstabs ph_pop_cld_adlt by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

* Adolescent population.
ctables
  /table  ph_pop_adols [c] [colpct.validn '' f5.1] + ph_pop_adols [s] [validn '' f5.0] by hv104 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Adolescent population".	

*crosstabs ph_pop_adols by hv104
    /format = avalue tables
    /cells = column 
    /count asis.

filter off.

**************************************************************************************************
* Indicators for birth registration: excel file Tables_pop will be produced
**************************************************************************************************

*create age variable for children under 5.
recode hv105 (0,1=1) (2 thru 4=2) (else=sysmis) into agec.
variable labels agec "Age".
value labels agec 1 " <2" 2 " 2-4".

* Birth certificate.
ctables
  /table agec [c] +
           hv104 [c] +
           hv025 [c] +
           hv024 [c] +
           hv270 [c] by
          ph_birthreg_cert [c] [rowpct.validn '' f5.1] + ph_birthreg_cert [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Adolescent population".	

*crosstabs agec hv104 hv025 hv024 hv270 by ph_birthreg_cert 
    /format = avalue tables
    /cells = row 
    /count asis.


******************************

* Registered birth but no certificate.
ctables
  /table agec [c] +
           hv104 [c] +
           hv025 [c] +
           hv024 [c] +
           hv270 [c] by
          ph_birthreg_nocert [c] [rowpct.validn '' f5.1] + ph_birthreg_nocert [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Registered birth but no certificate".	

*crosstabs agec hv104 hv025 hv024 hv270 by ph_birthreg_nocert 
    /format = avalue tables
    /cells = row 
    /count asis.

******************************

* Registered birth.
ctables
  /table agec [c] +
           hv104 [c] +
           hv025 [c] +
           hv024 [c] +
           hv270 [c] by
          ph_birthreg [c] [rowpct.validn '' f5.1] + ph_birthreg [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Registered birth".	

*crosstabs agec hv104 hv025 hv024 hv270 by ph_birthreg 
    /format = avalue tables
    /cells = row 
    /count asis.


**************************************************************************************************
* Indicators for wealth quintile and education: excel file Tables_pop will be produced
**************************************************************************************************

* Wealth quintile.
ctables
  /table hv025 [c] +
           hv024 [c] 
            by
          ph_wealth_quint [c] [rowpct.validn '' f5.1] + ph_wealth_quint [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Wealth quintile".	

*crosstabs agec hv025 hv024 by ph_wealth_quint 
    /format = avalue tables
    /cells = row 
    /count asis.


* Education - Females.
compute filter = hv104=2.
filter by filter.

ctables
  /table ph_pop_age [c] +
           hv025 [c] +
           hv024 [c] 
            by
          ph_highest_edu [c] [rowpct.validn '' f5.1] + ph_highest_edu [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Education - Females".	

*crosstabs ph_pop_age hv025 hv024 by ph_highest_edu 
    /format = avalue tables
    /cells = row 
    /count asis.

* Median years of education - Females.
descriptives variables = ph_median_eduyrs_wm / statistics = mean.


* Education - Males.
filter off.
compute filter = hv104=1.
filter by filter.

ctables
  /table ph_pop_age [c] +
           hv025 [c] +
           hv024 [c] 
            by
          ph_highest_edu [c] [rowpct.validn '' f5.1] + ph_highest_edu [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Education - Males".	

*crosstabs ph_pop_age hv025 hv024 by ph_highest_edu 
    /format = avalue tables
    /cells = row 
    /count asis.

* Median years of education - Males.
descriptives variables = ph_median_eduyrs_mn / statistics = mean.

filter off.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_pop.xls"
     operation=createfile.

output close * .

new file.

**************************************************************************************************
**************************************************************************************************

*open temp file produced by PH_POP.sps for children.
get file = datapath + "\PR_temp_children.sav".

compute wt=hv005/1000000.
weight by wt.

**************************************************************************************************
* Indicators for children living arrangements and orphanhood: excel file Tables_livarg_orph will be produced
**************************************************************************************************

*create age variable for children under 18.
recode hv105 (0,1=1) (2 thru 4=2) (5 thru 9=3) (10 thru 14=4) (15 thru 17=5) into agec.
variable labels agec "Age".
value labels agec 1 " <2" 2 " 2-4" 3 " 5-9" 4 " 10-14" 5 " 15-17".

*Note: if you would like to output these indicators for children under 15, then use the condition select if agec<5.

* Child living arrangements.
ctables
  /table agec [c] +
           hv104 [c] +
           hv025 [c] +
           hv024 [c] +
           hv270 [c]
            by
          ph_chld_liv_arrang [c] [rowpct.validn '' f5.1] + ph_chld_liv_arrang [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child living arrangements".	

*crosstabs agec hv104 hv025 hv024 hv270 by ph_chld_liv_arrang 
    /format = avalue tables
    /cells = row 
    /count asis.

******************************

* Child not living with a biological parent.
ctables
  /table agec [c] +
           hv104 [c] +
           hv025 [c] +
           hv024 [c] +
           hv270 [c]
            by
          ph_chld_liv_noprnt [c] [rowpct.validn '' f5.1] + ph_chld_liv_noprnt [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child not living with a biological parent".	

*crosstabs agec hv104 hv025 hv024 hv270 by ph_chld_liv_noprnt 
    /format = avalue tables
    /cells = row 
    /count asis.

******************************

* Child with one or both parents dead.
ctables
  /table agec [c] +
           hv104 [c] +
           hv025 [c] +
           hv024 [c] +
           hv270 [c]
            by
          ph_chld_orph [c] [rowpct.validn '' f5.1] + ph_chld_orph [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child with one or both parents dead".	

*crosstabs agec hv104 hv025 hv024 hv270 by ph_chld_orph 
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_livarg_orph.xls"
     operation=createfile.

output close * .

new file.
