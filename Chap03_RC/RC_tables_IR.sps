* Encoding: windows-1252.
*****************************************************************************************************
Program: 			RC_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: October 17 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	 Tables_background_wm:	Contains the tables for background variables for women
	2. 	 Tables_educ_wm:		Contains the tables for education indicators for women
	3.	 Tables_media_wm:		Contains the tables for media exposure and internet use for women
	4.	 Tables_employ_wm:		Contains the tables for employment and occupation indicators for women
	5.                Tables_insurance_wm:		Contains the tables for health insurance indicators for women
	6.                Tables_tobac_wm:		Contains the tables for tobacco use indicators for women

*
Notes: 					 						
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

* indicators from IR file.
**************************************************************************************************
* Background characteristics: excel file Tables_background_wm will be produced
**************************************************************************************************

****************************************************.
frequencies variables =v013 v501 v025 v106 v024 v190.	

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_background_wm.xls"
     operation=createfile.

output close * .

*/
**************************************************************************************************
* Indicators for education and literacy: excel file Tables_educ_wm will be produced
**************************************************************************************************
*Highest level of schooling.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v190 [c] by
         rc_edu [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Highest level of schooling".		

*crosstabs 
    /tables = v013 v025 v024 v190 by rc_edu
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Median years of schooling.
*median age at first marriage by age group.
descriptives variables =
    rc_edu_median
 /statistics = mean.

****************************************************
*Literacy levels.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v190 [c] by
         rc_litr_cats [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Literacy levels".		

*crosstabs 
    /tables = v013 v025 v024 v190 by rc_litr_cats
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Literate.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v190 [c] by
         rc_litr [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Literate".		

*crosstabs 
    /tables = v013 v025 v024 v190 by rc_litr_cats
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_educ_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for media exposure and internet use: excel file Tables_media_wm will be produced
**************************************************************************************************
*Reads a newspaper.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_media_newsp [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Reads a newspaper".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_media_newsp
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Watches TV.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_media_tv [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Watches TV".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_media_tv
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Listens to radio.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_media_radio [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Listens to radio".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_media_radio
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*All three media.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_media_allthree [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "All three media".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_media_allthree
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*None of the media forms.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_media_none [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "None of the media forms".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_media_none
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Ever used the internet.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_intr_ever [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever used the internet".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_intr_ever
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Internet use in the last 12 months.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_intr_use12mo [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Internet use in the last 12 months".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_intr_use12mo
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Internet use frequency.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_intr_usefreq [c] [rowpct.validn '' f5.1] + rc_intr_usefreq [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Internet use in the last 12 months".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_intr_usefreq
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_media_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for employment and occupation: excel file Tables_employ_wm will be produced
**************************************************************************************************
*Employment status.
ctables
  /table  v013 [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_empl [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Employment status".		

*crosstabs 
    /tables = v013 v502 v025 v024 v106 v190 by rc_empl
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************************************
*Occupation.
ctables
  /table  v013 [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_occup [c] [rowpct.validn '' f5.1] + rc_occup [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Occupation".		

*crosstabs 
    /tables = v013 v502 v025 v024 v106 v190 by rc_occup
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************************************.
do if any(v731,1,2,3).
+recode v717 (1 thru 3,6 thru 9, 96 thru 99, sysmis=0) (4,5=1) into agri.
end if.
variable labels agri "Type of employment".
value labels agri 0 "Non-Agriculture" 1 "Agriculture".

ctables
  /table  rc_empl_type [c]
         + rc_empl_earn [c]
         + rc_empl_cont [c] by
         agri [c] [colpct.validn '' f5.1] + agri [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Type of employment".		

*crosstabs 
    /tables = rc_empl_type rc_empl_earn rc_empl_cont by agri
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_employ_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for health insurance: excel file Tables_insurance_wm will be produced
**************************************************************************************************
*Social security.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_hins_ss [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Social security".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_hins_ss
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Other employer based insurance.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_hins_empl [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Other employer based insurance".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_hins_empl
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Community-based insurance.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_hins_comm [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Community-based insurance".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_hins_comm
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Private insurance.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_hins_priv [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Private insurance".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_hins_priv
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Other type of insurance.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_hins_other [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Other type of insurance".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_hins_other
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Have any insurance.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_hins_any [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have any insurance".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_hins_any
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************.
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_insurance_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for tobacco use: excel file Tables_tobac_wm will be produced
**************************************************************************************************
*Smokes cigarettes.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_tobc_cig [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Smokes cigarettes".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_tobc_cig
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Smokes other type of tobacco.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_tobc_other [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Smokes other type of tobacco".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_tobc_other
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Smokes any tobacco.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rc_tobc_smk_any [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Smokes any tobacco".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by rc_tobc_smk_any
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Smokeless tobacco use.

*Snuff by mouth.
frequencies variables =  rc_tobc_snuffm.

*Snuff by nose.
frequencies variables = rc_tobc_snuffn.

*Chews tobacco.
frequencies variables = rc_tobc_chew.

*Betel quid with tobacco.
frequencies variables = rc_tobv_betel.

*Other type of smokless tobacco.
frequencies variables = rc_tobc_osmkless.

*Any smokeless tobacco.
frequencies variables = rc_tobc_anysmkless.

*Uses any type of tobacco.
frequencies variables = rc_tobc_any.

****************************************************.
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_tobac_wm.xls"
     operation=createfile.

output close * .

****************************************************************************.
****************************************************************************.
new file.
