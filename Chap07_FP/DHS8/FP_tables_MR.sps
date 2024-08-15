* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_tables_MR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: Aug 18 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Tables_Know_mn:		Contains the tables for knowledge indicators for men
	2.               Tables_message_mn:	                  Contains the tables for exposure for FP messages for men


 * Notes: 					For knowledge of contraceptive methods, ever use, current use, and unmet need variables, the population of
						interest can be selected (all women, currently married women, and sexually active women).
 * 						The reminaing indicators are reported for currently married women.
 * 						Make the secltion of the population of interest below (line 38) for MR files. 

*Notes: For men the indicators are outputed for age 15-49 in line 32. 
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

** Select population of interest.
*all men.
compute select=1.

*currently married men.
*compute select=(mv502=1).

*sexually active unmarried men.
*compute select=0.
*if mv502<>1 & mv528<=30 select=1.

*selected men 15-49.
compute filter = (select=1 & mv013<8).
filter by filter.

* create denominators.
compute nmn=1.
variable labels nmn "Number of men".

**************************************************************************************************
* Indicators for knowleldege of contraceptive methods: excel file Tables_Know_mn will be produced
**************************************************************************************************
*Knowledge of each method.

frequencies variables = fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp 
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy 
		fp_know_wthd fp_know_other.

ctables
  /table  fp_know_mean_all  [s] [mean '' f5.1]  +  fp_know_mean_mar  [s] [mean '' f5.1]  
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "Knowledge of each method".	

*frequencies variables = fp_know_mean_all  fp_know_mean_mar 
         /statistics = mean.	

*/
****************************************************
*Knowledge of any method by background variables.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_know_any [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Knowledge of any method by background variables".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_know_any
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Knowledge of modern method by background variables.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_know_mod [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Knowledge of modern method by background variables".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_know_mod
    /format = avalue tables
    /cells = row 
    /count asis.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Know_mn.xls"
     operation=createfile.

output close *.
filter off.

**************************************************************************************************
* Indicators for messages: excel file Tables_message_mn will be produced
**************************************************************************************************

** selected men 15-49.
compute filter = (mv013<8).
filter by filter.

****************************************************
*FP messages by radio.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_message_radio [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by radio".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_message_radio
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages by TV.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_message_tv [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by TV".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_message_tv
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages by paper.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_message_paper [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by paper".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_message_paper 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages by mobile.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_message_mobile [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by mobile".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_message_mobile 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages none of 4.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_message_noneof4 [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages none of 4".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_message_noneof4 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages none of 3.
ctables
  /table mv013 [c]
         + mv025 [c] 
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
           fp_message_noneof3 [c] [rowpct.validn '' f5.1] + nmn [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages none of 3".			

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by fp_message_noneof3 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_message_mn.xls"
     operation=createfile.

output close *.

****************************************************

filter off.
new file.

