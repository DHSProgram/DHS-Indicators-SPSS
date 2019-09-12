* Encoding: windows-1252.
 *************************************************************************************************************************************************************************************************************
Program: 			RH_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: July 16 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_ANCvisits:	Contains the tables for ANC provider, ANC skilled provider, ANC number of visits, and timing of ANC visit by background variables
	2.	Tables_ANCcomps: 	Contains tables for all ANC components
  	3.	Tables_Probs: 	Contains the tables for problems accessing health care
	4.	Tables_PNC:	Contains the tables for the PNC indicators for women and newborns
***********************************************************************************************************************************************************************************************************/

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=v005/1000000.

weight by wt.

* create denominators.
do if (age < period).
    compute nwm=1.
end if.
variable labels nwm "Number of women".

do if (age < period and ancany = 1).
    compute nwmANC=1.
end if.
variable labels nwmANC "Number of women with ANC".

do if (age < 24).
    compute nwmPNC=1.
end if.
variable labels nwmPNC "Number of women/births".

compute numwT=1.
variable labels numwT "Number of women".


* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IR file.

* Indicators involving ANC visit: excel file Tables_ANCvisits will be produced.
*********************************************************************************
* Person providing assistance during ANC.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_pv [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Person providing assistance during ANC".			

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_pv
    /format = avalue tables
    /cells = row 
    /count asis.					
	
****************************************************
* Skilled assistance during ANC.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_pvskill [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Skilled assistance during ANC".	

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_pvskill
    /format = avalue tables
    /cells = row 
    /count asis.	

****************************************************
* Number of ANC visits in categories.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_numvs [c] [rowpct.validn '' f5.1] + nwmANC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Number of ANC visits".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_numvs
    /format = avalue tables
    /cells = row 
    /count asis.

* no table for rh_anc_4vs. 
****************************************************
* Number of months pregnant before 1st ANC visit.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_moprg [c] [rowpct.validn '' f5.1] + nwmANC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Number of months pregnant before 1st ANC visit".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_moprg
    /format = avalue tables
    /cells = row 
    /count asis.	

* no table for rh_anc_4mo. 
****************************************************
* Output for rh_ancmedian, rh_ancmedian_urban rh_ancmedian_rural.
ctables
  /table rh_anc_median [s] [mean '' f5.1]  +  rh_anc_median_urban  [s] [mean '' f5.1]  + rh_anc_median_rural [s] [mean '' f5.1] 
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "Median number of months pregnant before 1st ANC visit".	

*frequencies variables = rh_anc_median rh_anc_median_urban rh_anc_median_rural 
         /statistics = mean.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_ANCvisits"
     operation=createfile.

output close * .

****************************************************

* Indicators involving ANC components: excel file Tables_ANCcomps will be produced
*************************************************************************************
* took iron during pregnancy.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c]  by
          rh_anc_iron [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Took iron during pregnancy".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_iron
    /format = avalue tables
    /cells = row 
    /count asis.
	
****************************************************
* took intestinal parasite drugs during pregnacy.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_parast [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Took intestinal parasite drugs during pregnacy".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_parast
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* told of pregnancy complications.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c]  by
         rh_anc_prgcomp [c] [rowpct.validn '' f5.1] + nwmANC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Told of pregnancy complications".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_prgcomp
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* blood pressure was taken during ANC visit.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_bldpres [c] [rowpct.validn '' f5.1] + nwmANC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Blood pressure was taken during ANC visit".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_bldpres
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* urine sample taken during ANC visit.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_urine [c] [rowpct.validn '' f5.1]  + nwmANC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Urine sample taken during ANC visit".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_urine 
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* blood sample taken during ANC visit.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
            rh_anc_bldsamp [c] [rowpct.validn '' f5.1]  + nwmANC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Blood sample taken during ANC visit".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_bldsamp
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* had 2+ tetanus injections.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_toxinj [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had 2+ tetanus injections".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_toxinj
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* protected against neonatal tetanus.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_anc_neotet [c] [rowpct.validn '' f5.1] + nwm [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Protected against neonatal tetanus".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_anc_neotet
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_ANCcomps"
     operation=createfile.

output close * .

****************************************************

* Indicators for PNC indicators
*************************************************************************************
* PNC timing for mother.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_pnc_wm_timing [c] [rowpct.validn '' f5.1] + nwmPNC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "PNC timing for mother".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_pnc_wm_timing
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* PNC within 2days for mother.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_pnc_wm_2days [c] [rowpct.validn '' f5.1] + nwmPNC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "PNC within 2days for mother".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_pnc_wm_2days
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* PNC provider for mother.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c]  by
            rh_pnc_wm_pv [c] [rowpct.validn '' f5.1] + nwmPNC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "PNC provider for mother".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_pnc_wm_pv
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* PNC timing for newborn.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_pnc_nb_timing [c] [rowpct.validn '' f5.1] + nwmPNC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "PNC timing for newborn".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_pnc_nb_timing
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* PNC within 2 days for newborn.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_pnc_nb_2days [c] [rowpct.validn '' f5.1] + nwmPNC [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "PNC within 2 days for newborn".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_pnc_nb_2days
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* PNC provider for newborn.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_pnc_nb_pv [c] [rowpct.validn '' f5.1] + nwmPNC [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "PNC provider for newborn".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_pnc_nb_pv
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_PNC"
     operation=createfile.

output close * .

* Indicators for problems accessing health care: excel file Tables_Probs will be produced
********************************************************************************************
* problem permission to go.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_prob_permit [c] [rowpct.validn '' f5.1] + numwT [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Problem: Permission to go".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_prob_permit
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* problem getting money.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_prob_money [c] [rowpct.validn '' f5.1] + numwT [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Problem: Getting money".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_prob_money 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* problem distance.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          rh_prob_dist [c] [rowpct.validn '' f5.1] + numwT [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Problem: Distance".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_prob_dist
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* problem don't want to go alone.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_prob_alone [c] [rowpct.validn '' f5.1] + numwT [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Problem: Don't want to go alone".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_prob_alone
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* at least one problem.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          rh_prob_minone [c] [rowpct.validn, '', f5.1] + numwT [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "At least one problem".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_prob_minone
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_probs"
     operation=createfile.

output close * .

****************************************************

new file.

