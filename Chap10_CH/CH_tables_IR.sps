* Encoding: windows-1252.
******************************************************************************************************
Program: 			CH_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: September 01 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
Tables_KnowORS.xls:	Contains the tables for knowledge of ORS among women
*****************************************************************************************************.
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=v005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".


****************************************************************************

* indicators from IR file.

recode v013 (1=1) (2=2) (3,4=3) (5 thru 7=4) into age.
variable labels age "Age".
value labels age 1  "15-19" 2 "20-24" 3 "25-34" 4 "35-49".

*Knowledge of ORS among women.
ctables
  /table  age [c] 
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_know_ors [c] [rowpct.validn '' f5.1] + ch_know_ors [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Knowledge of ORS among women".			

*crosstabs 
    /tables = age v025 v024 v106 v190 by ch_know_ors
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_KnowORS.xls"
     operation=createfile.

output close * .

****************************************************

new file.
