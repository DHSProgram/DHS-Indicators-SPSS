* Encoding: windows-1252.
*******************************************************************************************************
Program: 			ML_tables_PR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: August 31 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. Tables_HH_ITN_USE:	\Contains the tables for ITN use among de facto population, children, and pregnant women
	2. Tables_MAL_ANEMIA:	Contains the table for children 6–59 months old tested for anemia and tables for children with severe anemia (<8.0 g/dL)
	3. Tables_MALARIA:		Contains the table for children 6-59 months old tested for malaria and children with malaria infection via RDT and microscopy
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************


*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=hv005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".


* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from PR file.

**************************************************************************************************
* Indicators for population who slept under a net or ITN the night before the survey
**************************************************************************************************
*De facto household population who slept the night before the survey under a mosquito net (treated or untreated).
recode hv105 (0 thru 4=1) (5 thru 14=2) (15 thru 34=3) (35 thru 49=4) (50 thru 95=5) (96 thru 99=sysmis) into age.
variable labels age "Age".
value labels age 1 "<5" 2 "5-14" 3 "15-34" 4 "35-49" 5 "50+".

compute filter = (hv103=1).
filter by filter.

ctables
  /table  age [c] 
         + hv104 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_slept_net [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "De facto household population who slept the night before the survey under a mosquito net (treated or untreated)".			

*crosstabs 
    /tables = age hv104 hv025 hv024 hv270 by ml_slept_net 
    /format = avalue tables
    /cells = row 
    /count asis.		

****************************************************
*De facto household population who slept the night before the survey under an ITN.
ctables
  /table  age [c] 
         + hv104 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_slept_itn [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "De facto household population who slept the night before the survey under an ITN".			

*crosstabs 
    /tables = age hv104 hv025 hv024 hv270 by ml_slept_itn 
    /format = avalue tables
    /cells = row 
    /count asis.		

filter off.
****************************************************.
compute filter = (hv103=1 & hml16<5).
filter by filter.

*Children under age 5 who slept the night before the survey under a mosquito net (treated or untreated).
ctables
  /table  hv104 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_slept_net [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Children under age 5 who slept the night before the survey under a mosquito net (treated or untreated)".		

*crosstabs 
    /tables = hv104 hv025 hv024 hv270 by ml_slept_net 
    /format = avalue tables
    /cells = row 
    /count asis.	

****************************************************
*Children under age 5 who slept the night before the survey under an ITN.
ctables
  /table  hv104 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_slept_itn [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Children under age 5 who slept the night before the survey under an ITN".		

*crosstabs 
    /tables = hv104 hv025 hv024 hv270 by ml_slept_itn 
    /format = avalue tables
    /cells = row 
    /count asis.	

filter off.

****************************************************.
compute filter = (hv103=1 & hv104=2 & hml18=1 & hml16>=15 & hml16<=49).
filter by filter.

*Pregnant women age 15-49 who slept the night before the survey under a mosquito net (treated or untreated).
ctables
  /table hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_slept_net [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Pregnant women age 15-49 who slept the night before the survey under a mosquito net (treated or untreated)".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_slept_net 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Pregnant women age 15-49 who slept the night before the survey under an ITN.
ctables
  /table hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_slept_itn [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Pregnant women age 15-49 who slept the night before the survey under an ITN".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_slept_itn 
    /format = avalue tables
    /cells = row 
    /count asis.

filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_HH_ITN_USE.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for anemia and malaria testing and prevalence: 
* Note: Testing indicators are not weighted
**************************************************************************************************
*Tested for Anemia.
ctables
  /table hc27 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_test_anemia [c] [rowpct.validn '' f5.1] + ml_test_anemia [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tested for Anemia".		

*crosstabs 
    /tables = hc27 hv025 hv024 hv270 by ml_test_anemia 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Children with hemoglobin lower than 8.0 g/dl.
ctables
  /table hc27 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_anemia [c] [rowpct.validn '' f5.1] + ml_anemia [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Children with hemoglobin lower than 8.0 g/dl".		

*crosstabs 
    /tables = hc27 hv025 hv024 hv270 by ml_anemia 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Testing of Parasitemia (via microscopy) in children 6-59 months.
ctables
  /table hc27 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_test_micmal [c] [rowpct.validn '' f5.1] + ml_anemia [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Testing of Parasitemia (via microscopy) in children 6-59 months".		

*crosstabs 
    /tables = hc27 hv025 hv024 hv270 by ml_test_micmal 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Parasitemia (via microscopy) in children 6-59 months.
ctables
  /table hc27 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_micmalpos [c] [rowpct.validn '' f5.1] + ml_anemia [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Parasitemia (via microscopy) in children 6-59 months".		

*crosstabs 
    /tables = hc27 hv025 hv024 hv270 by ml_micmalpos 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Testing of Parasitemia (vis RDT) in children 6-59 months.
ctables
  /table hc27 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_test_rdtmal [c] [rowpct.validn '' f5.1] + ml_anemia [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Testing of Parasitemia (vis RDT) in children 6-59 months".		

*crosstabs 
    /tables = hc27 hv025 hv024 hv270 by ml_test_rdtmal 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Parasitemia (vis RDT) in children 6-59 months.
ctables
  /table hc27 [c]
         + hv025 [c]
         + hv024 [c]
         + hv270 [c] by
         ml_rdtmalpos [c] [rowpct.validn '' f5.1] + ml_anemia [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Parasitemia (vis RDT) in children 6-59 months".		

*crosstabs 
    /tables = hc27 hv025 hv024 hv270 by ml_rdtmalpos 
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_MAL_ANEMIA.xls"
     operation=createfile.

output close * .

****************************************************

new file.
