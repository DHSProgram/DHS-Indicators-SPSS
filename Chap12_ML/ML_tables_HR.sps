* Encoding: windows-1252.
*******************************************************************************************************
Program: 			ML_tables_HR.sps
Purpose: 			produce tables for indicators
Author:			 Ivana Bjelic
Date last modified: August 30 2019 by Ivana Bjelic

*This do file will produce the following table in excel:
	Tables_HH_ITN:		Contains the tables for houeshold possession of ITNs 
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
compute numH=1.
variable labels numH "Number of households".


* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from HR file.

**************************************************************************************************
* Indicators for household ownership of nets
**************************************************************************************************
*Household ownership of one mosquito net.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_mosquitonet [c] [rowpct.validn '' f5.1] + numH [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Household ownership of one mosquito net".			

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_mosquitonet 
    /format = avalue tables
    /cells = row 
    /count asis.					
	
****************************************************
*Household ownership of ITNs.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_itnhh [c] [rowpct.validn '' f5.1] + numH [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Household ownership of ITNs".			

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_itnhh 
    /format = avalue tables
    /cells = row 
    /count asis.		

****************************************************
*Average number of mosquito nets per household.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_numnets [s] [mean '' f5.1] + numH [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Average number of mosquito nets per household".			

 * sort cases by hv025.
 * split file layered by hv025.
 * frequencies variables = ml_numnets /statistics = mean / order = analysis.
 * split file off.
 * sort cases by hv024.
 * split file layered by hv024.
 * frequencies variables = ml_numnets /statistics = mean / order = analysis.
 * split file off.
 * sort cases by hv270.
 * split file layered by hv270.
 * frequencies variables = ml_numnets /statistics = mean / order = analysis.
 * split file off.

****************************************************
*Average number of ITNs per household.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_numitnhh [s] [mean '' f5.1] + numH [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Average number of ITNs per household".			

 * sort cases by hv025.
 * split file layered by hv025.
 * frequencies variables = ml_numitnhh /statistics = mean / order = analysis.
 * split file off.
 * sort cases by hv024.
 * split file layered by hv024.
 * frequencies variables = ml_numitnhh /statistics = mean / order = analysis.
 * split file off.
 * sort cases by hv270.
 * split file layered by hv270.
 * frequencies variables = ml_numitnhh /statistics = mean / order = analysis.
 * split file off.

.

****************************************************
*Households with at least one mosquito net for every 2 persons.
compute filter = hv013>=1.
filter by filter.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_mosnethhaccess [c] [rowpct.validn '' f5.1] + numH [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Households with at least one mosquito net for every 2 persons".			

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_mosnethhaccess 
    /format = avalue tables
    /cells = row 
    /count asis.	

****************************************************
*Households with at least one ITN for every 2 persons.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_hhaccess [c] [rowpct.validn '' f5.1] + numH [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Households with at least one ITN for every 2 persons".			

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_hhaccess 
    /format = avalue tables
    /cells = row 
    /count asis.

filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_HH_ITN.xls"
     operation=createfile.

output close * .

****************************************************

new file.
