* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_tables_HR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: May 18 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_salt_hh:	Contains the tables for salt testing and iodized salt in households
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

****************************************************************************
****************************************************************************

* indicators from HR file.

compute wt=hv005/1000000.
weight by wt.

****************************************************
*Salt and salt testing status in housholds.
ctables
  /table  hv025 [c] +
            hv024 [c] +
            hv270 [c] 
              by
         nt_salt_any [c] [rowpct.validn '' f5.1] + nt_salt_any [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Given supplemental food among children 6-35 months".		

*crosstabs 
    /tables = hv025 hv024 hv270 by nt_salt_any
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Iodized salt in the household.
ctables
  /table  hv025 [c] +
            hv024 [c] +
            hv270 [c] 
              by
         nt_salt_iod [c] [rowpct.validn '' f5.1] + nt_salt_iod [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Iodized salt in the household".		

*crosstabs 
    /tables = hv025 hv024 hv270 by nt_salt_iod
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_salt_hh.xlsx"
     operation=createfile.

output close * .

****************************************************************************
****************************************************************************

new file.
