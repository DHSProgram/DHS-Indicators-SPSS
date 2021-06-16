* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HV_tables.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: March 31 2020 by Ivana Bjelic

*This do file will produce the following table in excel:
Tables_prev_cpl:	Contains the tables for HIV prevalence for couples
		
*****************************************************************************************************.
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* indicators from the CR file.

* use HIV weight.
compute wt=hiv05/1000000.
weight by wt.

**************************************************************************************************
* HIV prevalence among couples
**************************************************************************************************

ctables
  /table  v013 [c] +
            mv013 [c] +     
            v025 [c] +
            v024 [c] +
            v106 [c] +
            v190 [c] 
              by
         hv_couple_hiv_status [c] [rowpct.validn '' f5.1] + hv_couple_hiv_status [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "HIV prevalence among couples".		

*crosstabs 
    /tables = v013 mv013 v025 v024 v106 mv106 v190by hv_couple_hiv_status
    /format = avalue tables
    /cells = row 
    /count asis.
***********	

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_prev_cpl.xls"
     operation=createfile.

output close * .

new file.