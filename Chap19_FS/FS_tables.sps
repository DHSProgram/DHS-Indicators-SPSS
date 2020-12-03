* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FS_tables.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: December 2, 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
Tables_FIST:		Contains the tables for heard of female circumcision among women and men 
	
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
select if v012>=15 or v012<=49.

**************************************************************************************************
*Heard of fistula.
ctables
  /table  v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fs_heard [c] [rowpct.validn '' f5.1] + fs_heard [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Heard of fistula".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by fs_heard
    /format = avalue tables
    /cells = row 
    /count asis.

*************************************************************************************************
*Ever experienced fistula.
ctables
  /table  v013 [c] +                 /*age
            v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fs_ever_exp [c] [rowpct.validn '' f5.1] + fs_ever_exp [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever experienced fistula".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by fs_ever_exp
    /format = avalue tables
    /cells = row 
    /count asis.

*************************************************************************************************
*Reported cause of fistula.
frequencies variables fs_cause.

*Reported number of days since symptoms began.
frequencies variables fs_days_symp.

*************************************************************************************************
*Provider type for fistula treatment.
ctables
  /table  v025 [c] +                 /*residence
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fs_trt_provid [c] [rowpct.validn '' f5.1] + fs_trt_provid [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Provider type for fistula treatment".		

*crosstabs 
    /tables = v025 v106 v190 by fs_trt_provid
    /format = avalue tables
    /cells = row 
    /count asis.

*************************************************************************************************
*Outcome of treatment sought for fistula.
ctables
  /table  v025 [c] +                 /*residence
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fs_trt_outcome [c] [rowpct.validn '' f5.1] + fs_trt_outcome [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Outcome of treatment sought for fistula".		

*crosstabs 
    /tables = v025 v106 v190 by fs_trt_outcome
    /format = avalue tables
    /cells = row 
    /count asis.

*************************************************************************************************
*Had operation for fistula.
ctables
  /table  v025 [c] +                 /*residence
            v106 [c] +                 /*education
            v190 [c]                    /*wealth 
              by
         fs_trt_operat [c] [rowpct.validn '' f5.1] + fs_trt_operat [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had operation for fistula".		

*crosstabs 
    /tables = v025 v106 v190 by fs_trt_operat
    /format = avalue tables
    /cells = row 
    /count asis.

*************************************************************************************************
*Reason for not seeking treatment.
frequencies variables fs_notrt_reason.

*************************************************************************************************

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_FIST.xls"
     operation=createfile.

output close * .
