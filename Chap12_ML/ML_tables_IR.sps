* Encoding: windows-1252.
*******************************************************************************************************
Program: 			ML_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Cameron Taylor
Date last modified: August 31 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
Tables_IPTP:		Contains tables on IPTp uptake
*****************************************************************************************************/
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
if age<24 num=1.
variable labels num "Number".


* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file.

****************************************************
*Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received one or more doses of SP/Fansidar.
ctables
  /table  v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_one_iptp [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received one or more doses of SP/Fansidar".		

*crosstabs 
    /tables = v025 v024 v106 v190 by ml_one_iptp 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received two or more doses of SP/Fansidar.
ctables
  /table  v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_two_iptp [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received one or more doses of SP/Fansidar".		

*crosstabs 
    /tables = v025 v024 v106 v190 by ml_two_iptp 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received three or more doses of SP/Fansidar.
ctables
  /table  v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ml_three_iptp [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Women age 15-49 with a live birth in the 2 years preceding the survey who, during the pregnancy that resulted in the last live birth, received one or more doses of SP/Fansidar".		

*crosstabs 
    /tables = v025 v024 v106 v190 by ml_three_iptp 
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_IPTP.xls"
     operation=createfile.

output close * .

new file.
