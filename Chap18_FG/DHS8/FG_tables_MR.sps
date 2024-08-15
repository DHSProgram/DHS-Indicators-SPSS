* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FG_tables_MR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: October 27, 2020 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. Tables_Know: Contains the tables for heard of female circumcision among women and men 
	2.	Tables_Opinion: Contains the tables for opinions related to female circumcision among women and men 

*Notes: For men the indicators are outputed for age 15-49 in line 26. 
*This can be commented out if the indicators are required for all men.		
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* limiting to men age 15-49.
select if not(mv012<15 | mv012>49).

compute wt=mv005/1000000.
weight by wt.

* indicators from MR file.
****************************************************************************
*Heard of female circumcision.
ctables
  /table  mv013 [c] +                 /*age
            mv025 [c] +                 /*residence
            mv024 [c] +                 /*region
            mv106 [c] +                 /*education
            mv190 [c]                    /*wealth 
              by
         fg_heard [c] [rowpct.validn '' f5.1] + fg_heard [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Heard of female circumcision (among men)".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by fg_heard
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_Know.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow .

output close * .

**************************************************************************************************
* Indicators for opinions related to female circumcision
**************************************************************************************************
*Opinion on whether female circumcision is required by their religion.
ctables
  /table  mv013 [c] +                 /*age
            mv025 [c] +                 /*residence
            mv024 [c] +                 /*region
            mv106 [c] +                 /*education
            mv190 [c]                    /*wealth 
              by
         fg_relig [c] [rowpct.validn '' f5.1] + fg_relig [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Opinion on whether female circumcision is required by their religion (among men)".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by fg_relig
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Opinion on whether female circumcision should continue.
ctables
  /table  mv013 [c] +                 /*age
            mv025 [c] +                 /*residence
            mv024 [c] +                 /*region
            mv106 [c] +                 /*education
            mv190 [c]                    /*wealth 
              by
         fg_cont [c] [rowpct.validn '' f5.1] + fg_cont [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Opinion on whether female circumcision should continue (among men)".	

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by fg_cont
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_Opinion.xls"
     operation=modifysheet sheet="Sheet1" location=lastrow .

output close * .

