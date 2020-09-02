* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_tables_PR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: July 17 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1.	Tables_handwsh:		Contains the table for handwashing indicators
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

compute wt=hv005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".

* indicators from PR file.

**************************************************************************************************
* Indicators for handwashing: excel file Tables_handwsh will be produced
**************************************************************************************************
*fixed place for handwashing.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_place_fxd [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Fixed place for handwashing".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_place_fxd
    /format = avalue tables
    /cells = row 
    /count asis.

********************
*mobile place for handwashing.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_place_mob [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mobile place for handwashing".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_place_mob
    /format = avalue tables
    /cells = row 
    /count asis.

********************
*fixed and mobile place for handwashing.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_place_any [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Fixed and mobile place for handwashing".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_place_any
    /format = avalue tables
    /cells = row 
    /count asis.

********************
*water for handwashing.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_place_any [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Water for handwashing".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_place_any
    /format = avalue tables
    /cells = row 
    /count asis.

********************
*soap for handwashing.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_soap [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Soap for handwashing".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_soap
    /format = avalue tables
    /cells = row 
    /count asis.


********************
*cleansing agent for handwashing.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_clnsagnt [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ceansing agent for handwashing".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_clnsagnt
    /format = avalue tables
    /cells = row 
    /count asis.

********************
*basic handwashing facility.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_basic [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Basic handwashing facility".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_basic
    /format = avalue tables
    /cells = row 
    /count asis.

********************
*limited handwashing facility.
ctables
  /table hv025 [c] +
           hv024 [c] +
           hv270 [c] 
       by 
        ph_hndwsh_limited [c] [rowpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Limited handwashing facility".		

*crosstabs 
    /tables = hv025 hv024 hv270 by ph_hndwsh_limited
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_handwsh.xls"
     operation=createfile.

output close * .

****************************************************************************.
****************************************************************************.
new file.
