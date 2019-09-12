* Encoding: windows-1252.
******************************************************************************************************
Program: 			CH_tables_KR.sps
Purpose: 			produce tables for indicators
Author:				Shireen Assaf
Date last modified: September 01 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_Size:		Contains the tables for child's size indicators
	2.	Tables_ARI_FV.xls:	Contains the tables for ARI and fever indicators
	3.	Tables_DIAR.xls:	Contains the tables for diarrhea indicators
						Note: these tabouts do not include the watsan indicators (source of drinking water and type of 
						toilet facility). For these indicators please use the improvedtoilet_pr.sps and the improvedwater_pr.sps files 
						which will produce the watsan indicators using a PR file
						The PR file then needs to be merged with the coded KR file with the diarrhea indicators to include them in the tabulations
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

* create denominators.
compute num=1.
variable labels num "Number".

*Age in months.
recode age (0 thru 5=1) (6 thru 11=2) (12 thru 23=3) (24 thru 35=4) (36 thru 47=5) (48 thru 59=6) into agecats.
variable labels agecats "Age".
value labels agecats 1 "<6" 2 "6-11" 3 "12-23" 4 "24-35" 5 "36-47" 6 "48-59".

* mother's age at birth (years): <20, 20-34, 35-49.
compute months_age=b3-v011.
if months_age<20*12 mo_age_at_birth=1.
if months_age>=20*12 & months_age<35*12 mo_age_at_birth=2. 
if months_age>=35*12 & months_age<50*12 mo_age_at_birth=3.
variable labels mo_age_at_birth "Mother's age at birth (years)".
value labels mo_age_at_birth 1 "<20" 2 "20-34" 3 "35-49".

* birth order: 1, 2-3, 4-5, 6+.
do if not sysmis(bord).
+compute birth_order=1.
+if bord>1  birth_order=2.
+if bord>3 birth_order=3.
+if bord>5 birth_order=4.
end if.
variable labels birth_order "Birth order".
value labels birth_order 1 "1" 2 "2-3" 3 "4-5" 4 "6+".

*mother's smoking status.
compute smoke=2.
do repeat x=v463a v463b v463e v463f v463g v463j v463k v463l v463x.
+if x=1 smoke=1.
end repeat.
variable labels smoke "Mother's smoking status".
value labels smoke 1 "Smokes cigarrettes/tobacco" 2"Does not smoke".

*cooking fuel.
recode v161 (1 thru 4=1) (5=2) (6=3) (7=4) (8 thru 10=5) (11=6) (96=7) (95=8) (97 thru 99=sysmis) into fuel.
variable labels fuel "Cooking fuel".
value labels fuel 1 "electricity/gas" 2 "kerosene" 3 "coal" 4 "charcoal" 5 "wood/staw/grass/crop" 6 "animal dung" 7 "other" 8 "no food cooked in house".


* Non-standard background variable to add to tables

**************************************************************************************************
* Indicators for child's size variables
**************************************************************************************************
*Child's size at birth.
ctables
  /table  mo_age_at_birth [c] 
         + birth_order [c]
         + smoke [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_size_birth [c] [rowpct.validn '' f5.1] + ch_size_birth [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child's size at birth".			

*crosstabs 
    /tables = mo_age_at_birth birth_order smoke v025 v106 v024 v190 by ch_size_birth
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Child has a reported birth weight.
ctables
  /table  mo_age_at_birth [c] 
         + birth_order [c]
         + smoke [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_report_bw [c] [rowpct.validn '' f5.1] + ch_report_bw [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child has a reported birth weight".			

*crosstabs 
    /tables = mo_age_at_birth birth_order smoke v025 v106 v024 v190 by ch_report_bw
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Child weight is less than 2.5kg.
ctables
  /table  mo_age_at_birth [c] 
         + birth_order [c]
         + smoke [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_below_2p5 [c] [rowpct.validn '' f5.1] + ch_below_2p5 [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Child has a reported birth weight".			

*crosstabs 
    /tables = mo_age_at_birth birth_order smoke v025 v106 v024 v190 by ch_below_2p5
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Size.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Tables for ARI and fever indicators
**************************************************************************************************
*ARI symptoms.
ctables
  /table  agecats [c] 
         + b4 [c]
         + smoke [c]
         + fuel [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_ari [c] [rowpct.validn '' f5.1] + ch_ari [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "ARI symptoms".			

*crosstabs 
    /tables = agecats b4 smoke fuel v025 v106 v024 v190 by ch_ari
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*ARI treatment. 
* Note: This indicator and the remaining ARI indicators depend on the country specific definition of treatment. Check the 
* footnote in the final report for this table and exclude the necessary source in the CH_AR_FV file. 
ctables
  /table  agecats [c] 
         + b4 [c]
         + smoke [c]
         + fuel [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_ari_care [c] [rowpct.validn '' f5.1] + ch_ari_care [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "ARI treatment".			

*crosstabs 
    /tables = agecats b4 smoke fuel v025 v106 v024 v190 by ch_ari_care
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*ARI treatment same or next day.
ctables
  /table  agecats [c] 
         + b4 [c]
         + smoke [c]
         + fuel [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_ari_care_day [c] [rowpct.validn '' f5.1] + ch_ari_care_day [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "ARI treatment same or next day".			

*crosstabs 
    /tables = agecats b4 smoke fuel v025 v106 v024 v190 by ch_ari_care_day
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*** Source of advice or treatment for ARI symptoms ***
* only the following sources are computed, to get other sources that are country specific, please see the note on these indicators in the CH_ARI_FV.do file.

* among children with ARI symtoms.
frequencies variables ch_ari_govh ch_ari_govcent ch_ari_pclinc ch_ari_pdoc ch_ari_pharm.

* among children with ARI symtoms whom advice or treatment was sought.
frequencies variables ch_ari_govh_trt ch_ari_govcent_trt ch_ari_pclinc_trt ch_ari_pdoc_trt ch_ari_pharm_trt.	

**************************************************************************************************
*Fever symptoms.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_fever [c] [rowpct.validn '' f5.1] + ch_fever [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Fever symptoms".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_fever
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Fever treatment. 
* Note: This indicator and the remaining fever indicators depend on the country specific definition of treatment. Check the 
* footnote in the final report for this table and exclude the necessary source in the CH_AR_FV file. 
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_fev_care [c] [rowpct.validn '' f5.1] + ch_fev_care [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Fever treatment".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_fev_care
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Fever treatment same or next day.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_fev_care_day [c] [rowpct.validn '' f5.1] + ch_fev_care_day [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Fever treatment same or next day".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_fev_care_day
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Fever treatment with antibiotics.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_fev_antib [c] [rowpct.validn '' f5.1] + ch_fev_antib [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Fever treatment with antibiotics".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_fev_antib
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_ARI_FV.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Tables for diarrhea indicators
**************************************************************************************************
*Diarrhea symptoms.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar [c] [rowpct.validn '' f5.1] + ch_diar [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Diarrhea symptoms".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Diarrhea treatment. 
* Note: This indicator and some remaining diarrhea indicators depend on the country specific definition of treatment. Check the 
* footnote in the final report for this table and exclude the necessary source in the CH_DIAR file. 
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_care [c] [rowpct.validn '' f5.1] + ch_diar_care [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Diarrhea treatment".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_care
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Amount of liquids given during diarrhea.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_liq [c] [rowpct.validn '' f5.1] + ch_diar_liq [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Amount of liquids given during diarrhea".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_liq
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Amount of foood given during diarrhea.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_food [c] [rowpct.validn '' f5.1] + ch_diar_food [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Amount of foood given during diarrhea".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_food
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*** Table for Oral rehydration theapy and other treatments for diarrhea.
*ORS.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_ors [c] [rowpct.validn '' f5.1] + ch_diar_ors [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:ORS".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_ors
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************************************
*RHF.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_rhf [c] [rowpct.validn '' f5.1] + ch_diar_rhf [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:RHF".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_rhf
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*ORS or RHF.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_ors_rhf [c] [rowpct.validn '' f5.1] + ch_diar_ors_rhf [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:ORS or RHF".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_ors_rhf
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*Zinc.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_zinc [c] [rowpct.validn '' f5.1] + ch_diar_zinc [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:Zinc".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_zinc
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*Zinc and ORS.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_zinc_ors [c] [rowpct.validn '' f5.1] + ch_diar_zinc_ors [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:Zinc and ORS".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_zinc_ors
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*ORS or increased fluids.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_ors_fluid [c] [rowpct.validn '' f5.1] + ch_diar_ors_fluid [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:ORS or increased fluids".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_ors_fluid
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*ORT.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_ort [c] [rowpct.validn '' f5.1] + ch_diar_ort [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:ORT".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_ort
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*ORT and continued feeding.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_ort_feed [c] [rowpct.validn '' f5.1] + ch_diar_ort_feed [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:ORT and continued feeding".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_ort_feed
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*Antiobitiocs.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_antib [c] [rowpct.validn '' f5.1] + ch_diar_antib [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:Antiobitiocs".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_antib
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*Antimotility drugs.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_antim [c] [rowpct.validn '' f5.1] + ch_diar_antim [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:Antimotility drugs".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_antim
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*Intravenous solution.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_intra [c] [rowpct.validn '' f5.1] + ch_diar_intra [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:Intravenous solution".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_intra
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*Home remedy or other treatment.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_other [c] [rowpct.validn '' f5.1] + ch_diar_other [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:Home remedy or other treatment".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_other
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************
*No treatment.
ctables
  /table  agecats [c] 
         + b4 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_diar_notrt [c] [rowpct.validn '' f5.1] + ch_diar_notrt [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Table for Oral rehydration theapy and other treatments for diarrhea:No treatment".			

*crosstabs 
    /tables = agecats b4 v025 v024 v106 v190 by ch_diar_notrt
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*** Source of advice or treatment of Diarrhea ***.
* only the following sources are computed, to get other sources that are country specific, please see the note on these indicators in the CH_DIAR.sps file.

* among children with diarrhea.
frequencies variables ch_diar_govh ch_diar_govcent ch_diar_pclinc ch_diar_pdoc ch_diar_pharm.

* among children with diarrhea whom advice or treatment was sought.
frequencies variables ch_diar_govh_trt ch_diar_govcent_trt ch_diar_pclinc_trt ch_diar_pdoc_trt ch_diar_pharm_trt.

* among those that received ORS.	
frequencies variables ch_diar_govh_ors ch_diar_govcent_ors ch_diar_pclinc_ors ch_diar_pdoc_ors ch_diar_pharm_ors.

**************************************************************************************************

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_DIAR.xls"
     operation=createfile.

output close * .

