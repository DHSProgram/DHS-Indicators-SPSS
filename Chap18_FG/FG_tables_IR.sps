* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FG_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: October 27, 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_Know:                        Contains the tables for heard of female circumcision among women and men 
	2. 	Tables_Circum_wm:               Contains the tables for female circumcision prevalence, type, age of circumcision, and who performed the circumcision
	3.	Tables_Opinion:                     Contains the tables for opinions related to female circumcision among women and men 


*Notes: 	Tables_Circum_gl that show the indicators of female circumcision among girls 0-14 is produced in the FG_GIRLS.sps file.

* We select for the age groups 15-49 for both men and women.
* Most surveys for women are only for 15-49, but a few surveys have older surveys so this selection can be necessary (line 36). 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.
*

* indicators from IR file.

compute wt=v005/1000000.
weight by wt.

*select age group.
select if v012>=15 and v012<=49.

**************************************************************************************************
*Heard of female circumcision.
ctables
  /table  v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fg_heard [c] [rowpct.validn '' f5.1] + fg_heard [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Heard of female circumcision (among women)".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by fg_heard
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_Know.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for prevalence of female circumcision
**************************************************************************************************
*Circumcised women.
ctables
  /table  v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fg_fcircum_wm [c] [rowpct.validn '' f5.1] + fg_fcircum_wm [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Circumcised women".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by fg_fcircum_wm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Type of circumcision.
ctables
  /table  v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fg_type_wm [c] [rowpct.validn '' f5.1] + fg_type_wm [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Type of circumcision".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by fg_type_wm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Age at circumcision.
ctables
  /table  v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fg_age_wm [c] [rowpct.validn '' f5.1] + fg_age_wm [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Age at circumcision".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by fg_age_wm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Person performing the circumcision among women age 15-49.
frequencies variables fg_who_wm.

****************************************************
*Sewn close.
frequencies variables fg_sewn_wm.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_Circum_wm.xls"
     operation=createfile.

output close * .


**************************************************************************************************
* Indicators for opinions related to female circumcision
**************************************************************************************************
*Opinion on whether female circumcision is required by their religion.
ctables
  /table  fg_fcircum_wm [c] +  /*female circumcision status
            v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fg_relig [c] [rowpct.validn '' f5.1] + fg_relig [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Opinion on whether female circumcision is required by their religion (among women)".		

*crosstabs 
    /tables = fg_fcircum_wm v013 v025 v106 v024 v190 by fg_relig
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Opinion on whether female circumcision should continue.
ctables
  /table  fg_fcircum_wm [c] +  /*female circumcision status
            v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fg_cont [c] [rowpct.validn '' f5.1] + fg_cont [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Opinion on whether female circumcision should continue (among women)".		

*crosstabs 
    /tables = fg_fcircum_wm v013 v025 v106 v024 v190 by fg_cont
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_Opinion.xls"
     operation=createfile.

output close * .

