* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: November 28 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_know_wm:	Contains the tables for HIV/AIDS knowledge indicators for women
	2. 	Tables_atd_wm:	Contains the tables for HIV/AIDS attitude indicators for women
	3.	Tables_rsky_wm: 	Contains the tables for risky sexual behaviors for women
	4.	Tables_test_wm: 	Contains the tables for HIV prior testing and counseling for women
	5.	Tables_sti_wm:	Contains the tables for STI indicators for women
	6.               Tables_bhv_yng_wm:	Contains the table for sexual behavior among young people for women

*Notes:	Several tables in the final reports are reported about young people (15-24). 
*To produce these tables you can rerun the code among young people age group using v013 by droping cases over 24 years (i.e select if v013<=2).

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

* create denominators.
compute num=1.
variable labels num "Number".

****************************************************

* indicators from IR file.

****************************************************

**************************************************************************************************
* Knowledge of HIV/AIDS
**************************************************************************************************
*Ever heard of AIDS.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_ever_heard [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever heard of AIDS".		

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_ever_heard 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know reduce risk - use condoms.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_knw_risk_cond [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know reduce risk - use condoms".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by hk_knw_risk_cond 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know reduce risk - limit to one partner.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_knw_risk_sex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know reduce risk - limit to one partner".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by hk_knw_risk_sex 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know reduce risk - use condoms and limit to one partner.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_knw_risk_condsex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know reduce risk - use condoms and limit to one partner".		

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by hk_knw_risk_condsex 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know healthy person can have HIV.
ctables
  /table  v013 [c] by
         hk_knw_hiv_hlth [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know healthy person can have HIV".		

*crosstabs 
    /tables = v013 by hk_knw_hiv_hlth 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know HIV cannot be transmitted by mosquito bites.
ctables
  /table  v013 [c] by
         hk_knw_hiv_mosq [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know HIV cannot be transmitted by mosquito bites".		

*crosstabs 
    /tables = v013 by hk_knw_hiv_mosq 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know HIV cannot be transmitted by supernatural means.
ctables
  /table  v013 [c] by
         hk_knw_hiv_supernat [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know HIV cannot be transmitted by supernatural means".		

*crosstabs 
    /tables = v013 by hk_knw_hiv_supernat 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know HIV cannot be transmitted by sharing food with HIV infected person.
ctables
  /table  v013 [c] by
         hk_knw_hiv_food [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know HIV cannot be transmitted by sharing food with HIV infected person".		

*crosstabs 
    /tables = v013 by hk_knw_hiv_food 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know healthy person can have HIV and reject two common local misconceptions.
ctables
  /table  v013 [c] by
         hk_knw_hiv_hlth_2miscp [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know healthy person can have HIV and reject two common local misconceptions".		

*crosstabs 
    /tables = v013 by hk_knw_hiv_hlth_2miscp
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*HIV comprehensive knowledge.
ctables
  /table  v013 [c] by
         hk_knw_comphsv [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "HIV comprehensive knowledge".		

*crosstabs 
    /tables = v013 by hk_knw_comphsv
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know that HIV MTCT can occur during pregnancy.
ctables
  /table  v013 [c] by
         hk_knw_mtct_preg [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know that HIV MTCT can occur during pregnancy".		

*crosstabs 
    /tables = v013 by hk_knw_mtct_preg
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know that HIV MTCT can occur during delivery.
ctables
  /table  v013 [c] by
         hk_knw_mtct_deliv [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know that HIV MTCT can occur during delivery".		

*crosstabs 
    /tables = v013 by hk_knw_mtct_deliv
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know that HIV MTCT can occur during breastfeeding.
ctables
  /table  v013 [c] by
         hk_knw_mtct_brfeed [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know that HIV MTCT can occur during breastfeeding".		

*crosstabs 
    /tables = v013 by hk_knw_mtct_brfeed
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know all three HIV MTCT.
ctables
  /table  v013 [c] by
         hk_knw_mtct_all3 [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know all three HIV MTCT".		

*crosstabs 
    /tables = v013 by hk_knw_mtct_all3
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know risk of HIV MTCT can be reduced by meds.
ctables
  /table  v013 [c] by
         hk_knw_mtct_meds [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know risk of HIV MTCT can be reduced by meds".		

*crosstabs 
    /tables = v013 by hk_knw_mtct_meds
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_know_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Attitudes on HIV/AIDS
**************************************************************************************************
*Think that children with HIV should not go to school with HIV negative children.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_atd_child_nosch [c] [rowpct.validn '' f5.1] + hk_atd_child_nosch [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Think that children with HIV should not go to school with HIV negative children".		

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_atd_child_nosch 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Would not buy fresh vegetabels from a shopkeeper who has HIV.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_atd_shop_notbuy [c] [rowpct.validn '' f5.1] + hk_atd_shop_notbuy [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Would not buy fresh vegetabels from a shopkeeper who has HIV".		

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_atd_shop_notbuy 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Have discriminatory attitudes towards people living with HIV-AIDS.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_atd_discriminat [c] [rowpct.validn '' f5.1] + hk_atd_discriminat [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have discriminatory attitudes towards people living with HIV-AIDS".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_atd_discriminat 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_atd_wm.xls"
     operation=createfile.

output close * .	

**************************************************************************************************
* Risky sexual behavior
**************************************************************************************************
*Two or more sexual partners.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_sex_2plus [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Two or more sexual partners".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_sex_2plus 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Had sex with a person that was not their partner.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_sex_notprtnr [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had sex with a person that was not their partner".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_sex_notprtnr 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Have two or more sexual partners and used condom at last sex.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_cond_2plus [c] [rowpct.validn '' f5.1] + hk_cond_2plus [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have two or more sexual partners and used condom at last sex".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_cond_2plus 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Had sex with a person that was not their partner and used condom.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_cond_notprtnr [c] [rowpct.validn '' f5.1] + hk_cond_notprtnr [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had sex with a person that was not their partner and used condom".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_cond_notprtnr
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Mean number of sexual partners.
*total.
frequencies variables hk_sexprtnr_mean.

compute filter = range(v836,1,95).
filter by filter.

ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         v836 [s] [mean '' f5.1]
  /slabels visible=no
  /titles title=
    "Mean number of sexual partners".

* sort cases by v013.
* split file by v013.
* descriptives variables v836 /statistics=mean.
* split file off.

* sort cases by v501.
* split file by v501.
* descriptives variables v836 /statistics=mean.
* split file off.

* sort cases by v025.
* split file by v025.
* descriptives variables v836 /statistics=mean.
* split file off.

* sort cases by v024.
* split file by v024.
* descriptives variables v836 /statistics=mean.
* split file off.

* sort cases by v106.
* split file by v106.
* descriptives variables v836 /statistics=mean.
* split file off.

* sort cases by v190.
* split file by v190.
* descriptives variables v836 /statistics=mean.
* split file off.

filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_rsky_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* HIV prior testing and counseling 
**************************************************************************************************
*Know where to get HIV test.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_where [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know where to get HIV test".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_where
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Had prior HIV test and whether they received results.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_prior [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had prior HIV test and whether they received results".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_prior
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Ever tested.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_ever [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever tested".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_ever
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Tested in last 12 months and received test results.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_12m [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tested in last 12 months and received test results".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_12m
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Heard of self-test kits.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_hiv_selftest_heard [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Heard of self-test kits".	

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by hk_hiv_selftest_heard
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Ever used a self-test kit.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_hiv_selftest_use [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever used a self-test kit".	

*crosstabs 
    /tables = v013 v025 v024 v106 v190 by hk_hiv_selftest_use
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Received counseling on HIV during ANC visit.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_hiv_consl_anc [c] [rowpct.validn '' f5.1] +  hk_hiv_consl_anc [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Received counseling on HIV during ANC visit".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_hiv_consl_anc
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Tested for HIV during ANC visit and received results and post-test counseling.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_consl_anc [c] [rowpct.validn '' f5.1] + hk_test_consl_anc [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tested for HIV during ANC visit and received results and post-test counseling".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_consl_anc
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Tested for HIV during ANC visit and received results but no post-test counseling.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_noconsl_anc [c] [rowpct.validn '' f5.1] + hk_test_noconsl_anc [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tested for HIV during ANC visit and received results but no post-test counseling".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_noconsl_anc
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Tested for HIV during ANC visit and did not receive test results.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_noresult_anc [c] [rowpct.validn '' f5.1] + hk_test_noresult_anc [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tested for HIV during ANC visit and did not receive test results".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_noresult_anc
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Received HIV counseling, test, and results.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_hiv_receivedall_anc [c] [rowpct.validn '' f5.1] + hk_hiv_receivedall_anc [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Received HIV counseling, test, and results".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_hiv_receivedall_anc
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Received HIV test during ANC or labor and received results.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_anclbr_result [c] [rowpct.validn '' f5.1] + hk_test_anclbr_result [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Received HIV test during ANC or labor and received results".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_anclbr_result
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Received HIV test during ANC or labor but did not receive results.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_test_anclbr_noresult [c] [rowpct.validn '' f5.1] + hk_test_anclbr_noresult [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Received HIV test during ANC or labor but did not receive results".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_test_anclbr_noresult
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_test_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Self reported STIs
**************************************************************************************************
*STI in the past 12 months.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_sti [c] [rowpct.validn '' f5.1] + hk_sti [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "STI in the past 12 months".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_sti
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Discharge in the past 12 months.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_computet_disch [c] [rowpct.validn '' f5.1] + hk_computet_disch [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Discharge in the past 12 months".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_computet_disch
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Genital sore in past 12 months.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_gent_sore [c] [rowpct.validn '' f5.1] + hk_gent_sore [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Genital sore in past 12 months".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_gent_sore
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*STI or STI symptoms in the past 12 months.
ctables
  /table  v013 [c]
         + v501 [c]
         + v025 [c]
         + v024 [c] 
         + v106 [c]
         + v190 [c] by
         hk_sti_symp [c] [rowpct.validn '' f5.1] + hk_sti_symp [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "STI or STI symptoms in the past 12 months".	

*crosstabs 
    /tables = v013 v501 v025 v024 v106 v190 by hk_sti_symp
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Care-seeking indicators for STIs.
frequencies variables = hk_sti_trt_doc hk_sti_trt_pharm hk_sti_trt_other hk_sti_notrt.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_sti_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Sexual behavior among young people
**************************************************************************************************
.
compute filter = v012<25.
filter by filter.

* new age variable among young. 
recode v012 (15 thru 17=1) (18,19=2) (20 thru 22=3) (23,24=4) (else=sysmis) into age_yng.
variable labels age_yng "Age".
value labels age_yng 1  " 15-17" 2 " 18-19" 3 " 20-22" 4 " 23-24".

*Sex before 15.
ctables
  /table  age_yng [c]
         + v025 [c]
         + v106 [c] by
         hk_sex_15 [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Sex before 15".	

*crosstabs 
    /tables = age_yng v025 v106 by hk_sex_15
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
.
filter off.
compute filter = v012>17 and v012<25.
filter by filter.

*Sex before 18.
ctables
  /table  age_yng [c]
         + v025 [c]
         + v106 [c] by
         hk_sex_18 [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Sex before 18".	

*crosstabs 
    /tables = age_yng v025 v106 by hk_sex_18
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
.
filter off.
compute filter = v012<25.
filter by filter.

*Never had sexual.
ctables
  /table  age_yng [c]
         + v025 [c]
         + v106 [c] by
         hk_nosex_youth [c] [rowpct.validn '' f5.1] + hk_nosex_youth [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Never had sexual".	

*crosstabs 
    /tables = age_yng v025 v106 by hk_nosex_youth
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************

recode v502 (0=0) (1,2=1) into marstat.
variable labels marstat "Marital status".
value labels marstat 0 "Never married" 1 "Ever married".

*Tested and received HIV test results.
ctables
  /table  age_yng [c]
         + marstat [c] by
         hk_sex_youth_test [c] [rowpct.validn '' f5.1] + hk_sex_youth_test [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tested and received HIV test results".	

*crosstabs 
    /tables = age_yng marstat by hk_sex_youth_test
    /format = avalue tables
    /cells = row 
    /count asis.

filter off.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_bhv_yng_wm.xls"
     operation=createfile.

output close * .

new file.
