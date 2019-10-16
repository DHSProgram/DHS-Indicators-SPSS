* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: Aug 18 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_Know_wm:		Contains the tables for knowledge indicators for women
	2. 	Tables_Use_ev:		Contains the tables for ever use of family planning for women
	3. 	Tables_Use_cr:		Contains the tables for current use of family planning for women + timing of sterlization
	4.	Tables_source_info:	                  Contains the tables for source of family planning method, brands used, and information given about the method for women
	not done 5.	Tables_Discont:		Contains the tables for discontinuation rates and reason for discontinuation for women
	6.	Tables_Need:		Contains the tables for unmet need, met need, demand satisfied, and future intention to use for women
	7.	Tables_Communicat:	                  Contains the tables for exposure to FP messages, decision on use/nonuse, discussions for women


 * Notes: 					For knowledge of contraceptive methods, ever use, current use, and unmet need variables, the population of
						interest can be selected (all women, currently married women, and sexually active women).
 * 						The reminaing indicators are reported for currently married women.

 * 						Make the secltion of the population of interest below for IR files. 

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

** Select population of interest.

*all women.
compute select=1.

*currently married women.
*compute select=(v502=1).

*sexually active unmarried women.
*compute select=0.
*if v502<>1 & v528<=30 select=1.

* create denominators.
compute nwm=1.
variable labels nwm "Number of women".

* indicators from IR file.

**************************************************************************************************.
* Indicators for knowleldege of contraceptive methods: excel file Tables_Know_wm will be produced
**************************************************************************************************.
filter by select.

*Knowledge of each method.
frequencies variables =	fp_know_any fp_know_mod fp_know_fster fp_know_mster fp_know_pill fp_know_iud fp_know_inj fp_know_imp
		fp_know_mcond fp_know_fcond fp_know_ec fp_know_sdm fp_know_lam fp_know_omod fp_know_trad fp_know_rhy
		fp_know_wthd fp_know_other.
		
frequencies variables =	fp_know_mean_all fp_know_mean_mar.


****************************************************
*Knowledge of any method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_know_any [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Knowledge of any method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_know_any
    /format = avalue tables
    /cells = row 
    /count asis.		

****************************************************.
*Knowledge of modern method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_know_mod [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Knowledge of modern method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_know_mod
    /format = avalue tables
    /cells = row 
    /count asis.	

****************************************************.
*Knowledge of fertile period.
frequencies variables fp_know_fert_all fp_know_fert_rhy fp_know_fert_sdm.

****************************************************.
*Correct nowledge of fertile period.
ctables
  /table v013 [c] by
         fp_know_fert_cor [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Correct nowledge of fertile period".	

*crosstabs 
    /tables = v013 by  fp_know_fert_cor 
    /format = avalue tables
    /cells = row 
    /count asis.	

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Know_wm.xls"
     operation=createfile.

output close *.

**************************************************************************************************
* Indicators for ever use of contraceptive methods: excel file Tables_Use_ev will be produced
**************************************************************************************************
** Ever use in not reported in DHS7 tabplan and many recent surveys do not have these variables.

*Ever use any by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_evuse_any [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use any by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_any
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use modern by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_evuse_mod [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use modern by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_mod
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use female sterlization by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_evuse_fster [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use female sterlization by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_fster 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use male sterlization by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_evuse_mster [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use male sterlization by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_mster
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use pill by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_evuse_pill  [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use pill by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_pill 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use IUD by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_evuse_iud [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use IUD by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_iud
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use injectables by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         fp_evuse_inj [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use injectables by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_inj
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use implants by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_imp [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use implants by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by  fp_evuse_imp
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use male condoms by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_mcond [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use male condoms by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by  fp_evuse_mcond
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use female condoms by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_fcond [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use male female condoms by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_fcond
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use diaphragm by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_diaph  [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use diaphragm by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_diaph 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use LAM by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_lam [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use LAM by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_lam
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use emergency contraceptive by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_ec [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use emergency contraceptive by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_ec
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use other moden method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_omod [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use other moden method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_omod
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use traditional method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_trad [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use traditional method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_trad
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use rhythm by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_rhy [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use rhythm by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_rhy
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use withdrawal by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_wthd [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use withdrawal by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_wthd
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever use other method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_evuse_other  [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever use other method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_evuse_other 
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Use_ev.xls"
     operation=createfile.

output close *.
**************************************************************************************************
* Indicators for current use of contraceptive methods: excel file Tables_Use_cr will be produced
**************************************************************************************************

*Currently using any by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_any [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using any by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_any
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using modern by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_mod [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using modern by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_mod 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using female sterlization by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_fster [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using female sterlization by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_fster
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using male sterlization by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_mster  [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using male sterlization by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_mster 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using pill by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_pill [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using pill by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_pill
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using IUD by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_iud [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using IUD by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_iud 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using injectables by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_inj [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using injectables by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_inj 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using implants by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_imp [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using implants by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_imp
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using male condoms by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_cruse_mcond [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using male condoms by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_mcond 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using female condoms by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_cruse_fcond [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using female condoms by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_fcond
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using diaphragm by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_cruse_diaph [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using diaphragm by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_diaph
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using LAM by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_lam [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using LAM by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_lam
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using emergency contraceptive by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_ec [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using emergency contraceptive by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_ec
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using other moden method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_omod [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using other moden method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_omod
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using traditional method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_cruse_trad [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using traditional method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_trad
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using rhythm by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_cruse_rhy [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using rhythm by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_rhy 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using withdrawal by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_cruse_wthd [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using withdrawal by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_wthd
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Currently using other method by background variables.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_cruse_other [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Currently using other method by background variables".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_cruse_other
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************

filter off.

*Timing of sterlization.
ctables
  /table v319 [c]
              by
            fp_ster_age [c] [rowpct.validn '' f5.1] +  fp_ster_age [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Timing of sterlization".			

*crosstabs 
    /tables = v319 by fp_ster_age
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Median age at sterlization.
ctables
  /table fp_ster_median [s] [mean '' f5.1] 
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "Median age at sterlization".	

*frequencies variables =  fp_ster_median
         /statistics = mean.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Use_cr.xls"
     operation=createfile.

output close *.

**************************************************************************************************
* Indicators for source and info. contraceptive methods: excel file Tables_source_info will be produced
**************************************************************************************************

*Source of contraception for main modern methods and total.

frequencies variables = fp_source_fster fp_source_iud fp_source_inj fp_source_imp fp_source_pill fp_source_mcond fp_source_tot.

****************************************************
*Pill users using a brand.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_brand_pill [c] [rowpct.validn '' f5.1] + fp_brand_pill [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Pill users using a brand".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_brand_pill
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Condom users using a brand.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_brand_cond [c] [rowpct.validn '' f5.1] +  fp_brand_cond [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Condom users using a brand".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_brand_cond
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************

compute filter = (v312 = 6 or v312 = 1 or v312 = 2 or v312 = 3 or v312 = 11).
filter by filter.
*Informed of side effects.
ctables
  /table v312 [c]
               by
            fp_info_sideff  [c] [rowpct.validn '' f5.1] + fp_info_sideff  [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of side effects".			

*crosstabs 
    /tables = v312 by fp_info_sideff 
    /format = avalue tables
    /cells = row 
    /count asis.

*by source of method (may need to recode, country specific).
ctables
  /table fp_source_tot [c]
               by
                fp_info_sideff [c] [rowpct.validn '' f5.1] +  fp_info_sideff  [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of side effects".			

*crosstabs 
    /tables = fp_source_tot by fp_info_sideff 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************

*Informed of what to do if experienced side effects.
ctables
  /table v312 [c]
               by
            fp_info_what_to_do [c] [rowpct.validn '' f5.1] + fp_info_what_to_do [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of what to do if experienced side effects".			

*crosstabs 
    /tables = v312 by fp_info_what_to_do
    /format = avalue tables
    /cells = row 
    /count asis.

*by source of method (may need to recode, country specific).
ctables
  /table fp_source_tot [c]
               by
            fp_info_what_to_do [c] [rowpct.validn '' f5.1] + fp_info_what_to_do [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of what to do if experienced side effects".			

*crosstabs 
    /tables = fp_source_tot by fp_info_what_to_do
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Informed of other methods.
ctables
  /table v312 [c]
               by
            fp_info_other_meth [c] [rowpct.validn '' f5.1] + fp_info_other_meth [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of other methods".			

*crosstabs 
    /tables = v312 by fp_info_other_meth
    /format = avalue tables
    /cells = row 
    /count asis.

*by source of method (may need to recode, country specific).
ctables
  /table fp_source_tot [c]
               by
            fp_info_other_meth [c] [rowpct.validn '' f5.1] +  fp_info_other_meth [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of other methods".			

*crosstabs 
    /tables = fp_source_tot by fp_info_other_meth
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************

*Informed of all three (Method Information Mix).
ctables
  /table v312 [c]
               by
            fp_info_all  [c] [rowpct.validn '' f5.1] + fp_info_all [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of all three (Method Information Mix)".			

*crosstabs 
    /tables = v312 by fp_info_all 
    /format = avalue tables
    /cells = row 
    /count asis.

*by source of method (may need to recode, country specific).
ctables
  /table fp_source_tot [c]
               by
            fp_info_all [c] [rowpct.validn '' f5.1] + fp_info_all [s] [validn '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Informed of all three (Method Information Mix)".			

*crosstabs 
    /tables = fp_source_tot by fp_info_all 
    /format = avalue tables
    /cells = row 
    /count asis.

filter off. 

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_source_info.xls"
     operation=createfile.

output close *.

**************************************************************************************************
* Indicators for unmet, met, demand satisfied and intention to use: excel file Tables_Need will be produced
**************************************************************************************************
****************************************************

filter by select.
*Unmet for spacing.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_unmet_space [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Unmet for spacing".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_unmet_space
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Unmet for limiting.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_unmet_limit [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Unmet for limiting".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_unmet_limit
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Unmet for total.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_unmet_tot [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Unmet for total".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_unmet_tot
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Met for spacing.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_met_space [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Met for spacing".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_met_space
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Met for limiting.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_met_limit [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Met for limiting".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_met_limit
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Met total.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            fp_met_tot [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Met total".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_met_tot
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Demand for spacing.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_demand_space [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Demand for spacing".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_demand_space
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Demand for limiting.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_demand_limit [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Demand for limiting".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_demand_limit
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Demand total.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_demand_tot [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Demand total".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_demand_tot
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Demand satisfied by modern methods.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_demsat_mod [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Demand satisfied by modern methods".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_demsat_mod
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Demand satisfied by any method.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_demsat_any [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Demand satisfied by any methods".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_demsat_any
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Future intention to use.

filter off.
compute selectMarried = (v502 = 1).
filter by selectMarried.

*recode number of living children.
recode v219 (0=0) (1=1) (2=2) (3=3) (4 thru 50=4) into numchild.
variable labels numchild "Number of living children".
value labels numchild 0 "0" 1 "1" 2 "2" 3 "3" 4 "4+".

ctables
  /table fp_future_use  [c] + nwm [c]
                by
           numchild [c] [colpct.validn '' f5.1] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Future intention to use".			

*crosstabs 
    /tables = fp_future_use by numchild
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Need.xls"
     operation=createfile.

output close *.

filter off. 

**************************************************************************************************
* Indicators for messages, decisions, and discussion: excel file Tables_Communicat will be produced
**************************************************************************************************

****************************************************
*FP messages by radio.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_message_radio [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by radio".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_message_radio
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages by TV.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_message_tv [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by TV".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_message_tv
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages by paper.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_message_paper [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by paper".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_message_paper 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages by mobile.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_message_mobile [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages by mobile".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_message_mobile
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages none of 4.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_message_noneof4 [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages none of 4".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_message_noneof4
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*FP messages none of 3.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
           fp_message_noneof3 [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "FP messages none of 3".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_message_noneof3
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide to use FP among users.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_decyes_user [c] [rowpct.validn '' f5.1] + fp_decyes_user [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide to use FP among users".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_decyes_user
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide not to use FP among nonusers.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_decno_nonuser [c] [rowpct.validn '' f5.1] + fp_decno_nonuser [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide to use FP among nonusers".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_decno_nonuser
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Discussing FP during visit from FP worker.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_fpvisit_discuss  [c] [rowpct.validn '' f5.1] + fp_fpvisit_discuss [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Discussing FP during visit from FP worker".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_fpvisit_discuss 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Discussing FP during visit to health facility.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_hf_discuss  [c] [rowpct.validn '' f5.1] + fp_hf_discuss [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Discussing FP during visit to health facility".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_hf_discuss
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Did not discuss FP during visit to health facility.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_hf_notdiscuss [c] [rowpct.validn '' f5.1] + fp_hf_notdiscuss [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Did not discuss FP during visit to health facility".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_hf_notdiscuss 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Did not discuss FP during visit to health facility or with FP worker.
ctables
  /table v013 [c]
         + v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          fp_any_notdiscuss [c] [rowpct.validn '' f5.1] + fp_hf_notdiscuss [s] [validn '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Did not discuss FP during visit to health facility".			

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by fp_any_notdiscuss
    /format = avalue tables
    /cells = row 
    /count asis.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Communicat.xls"
     operation=createfile.

output close *.

new file.