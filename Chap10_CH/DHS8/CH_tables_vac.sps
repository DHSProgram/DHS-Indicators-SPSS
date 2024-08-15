* Encoding: windows-1252.
* Encoding: .
****************************************************************************************************
Program: 			CH_tables_vac.sps
Purpose: 			produce tables for vaccination indicators
Author:				Ivana Bjelic
Date last modified: September 02 2019 by Ivana Bjelic
                    March 25 2021 by Trevor Croft to correct spelling of Pneumococcal

*This do file will produce the following table in excel:
Tables_Vac:		Contains the tables for child's vaccination indicators
	
*Note:	These tables will be produced for the age group selection in the CH_VAC.do file
			The default section is children 12-23 months. If estimates are requried for children 24-35 months, 
			the CH_VAC.do file needs to be run again with that age group selection and then this do file to produce files
			can be run agian. 
*****************************************************************************************************.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=v005/1000000.
weight by wt.

* Non-standard background variable to add to tables.
* birth order: 1, 2-3, 4-5, 6+.
do if not sysmis(bord).
+compute birth_order=1.
+if bord>1  birth_order=2.
+if bord>3 birth_order=3.
+if bord>5 birth_order=4.
end if.
variable labels birth_order "Birth order".
value labels birth_order 1 "1" 2 "2-3" 3 "4-5" 4 "6+".

* create denominators.
compute num=1.
variable labels num "Number".

**************************************************************************************************
* Table for vaccines by source
**************************************************************************************************
*BCG.
frequencies variables ch_bcg_card ch_bcg_moth ch_bcg_either.

*DPT.
frequencies variables ch_pent1_card ch_pent1_moth ch_pent1_either 
		ch_pent2_card ch_pent2_moth ch_pent2_either
		ch_pent3_card ch_pent3_moth ch_pent3_either.	

*Polio.
frequencies variables ch_polio0_card ch_polio0_moth ch_polio0_either 
		ch_polio1_card ch_polio1_moth ch_polio1_either 
		ch_polio2_card ch_polio2_moth ch_polio2_either
		ch_polio3_card ch_polio3_moth ch_polio3_either.

*Pneumococcal.
frequencies variables ch_pneumo1_card ch_pneumo1_moth ch_pneumo1_either	
		ch_pneumo2_card ch_pneumo2_moth ch_pneumo2_either
		ch_pneumo3_card ch_pneumo3_moth ch_pneumo3_either.

*Rotavirus.
frequencies variables ch_rotav1_card ch_rotav1_moth ch_rotav1_either 
		ch_rotav2_card ch_rotav2_moth ch_rotav2_either	
		ch_rotav3_card ch_rotav3_moth ch_rotav3_either.

*Measles.
frequencies variables ch_meas_card ch_meas_moth ch_meas_either.

*All basic vaccinations.
frequencies variables ch_allvac_card ch_allvac_moth ch_allvac_either.

*No vaccinations.
frequencies variables  ch_novac_card ch_novac_moth ch_novac_either.	
		
		
**************************************************************************************************
* Table for vaccinations by background variables: 
* Note: this table is for children age 12-23. If you have 
* selected the 24-35 age group in the CH_VAC.do file, then you must rerun the do file with selecting the 12-23
* age group in order to match the table.
**************************************************************************************************
*BCG.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_bcg_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "BCG".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_bcg_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*DPT1.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_pent1_either  [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "DPT1".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_pent1_either 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*DPT2.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_pent2_either  [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "DPT2".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_pent2_either 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*DPT3.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_pent3_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "DPT3".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_pent3_either 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Polio0.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_polio0_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Polio0".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_polio0_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Polio1.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_polio1_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Polio1".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_polio1_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Polio2.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_polio2_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Polio2".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_polio2_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Polio3.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_polio3_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Polio3".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_polio3_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Pneumococcal1.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_pneumo1_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Pneumococcal1".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_pneumo1_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Pneumococcal2.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_pneumo2_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Pneumococcal2".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_pneumo2_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Pneumococcal3.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_pneumo3_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Pneumococcal3".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_pneumo3_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Rotavirus1.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_rotav1_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Rotavirus1".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_rotav1_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Rotavirus2.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_rotav2_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Rotavirus2".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_rotav2_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Rotavirus3.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_rotav3_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Rotavirus3".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_rotav3_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Measles.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_meas_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Measles".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_meas_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*All basic vaccinations.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_allvac_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "All basic vaccinations".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_allvac_either
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*No vaccinations.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_novac_either [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "No vaccinations".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_novac_either
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Table for possession and observation of vaccination cards
**************************************************************************************************
*Ever had a vaccination card.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_card_ever_had [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever had a vaccination card".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_card_ever_had
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Vaccination card seen.
ctables
  /table  b4 [c] 
         + birth_order [c]
         + ch_card_seen [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_card_seen [c] [rowpct.validn '' f5.1] + num [s] [sum ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Vaccination card seen".			

*crosstabs 
    /tables = b4 birth_order ch_card_seen v025 v024 v106 v190 by ch_card_seen
    /format = avalue tables
    /cells = row 
    /count asis.

*****************************************************

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Vac.xls"
     operation=createfile.

output close * .

****************************************************

filter off.
