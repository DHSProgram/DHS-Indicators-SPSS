* Encoding: windows-1252.
* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_tables_MR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: November 28 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1.	Tables_know_mn:	Contains the tables for HIV/AIDS knowledge indicators for men
	2.	Tables_atd_mn:	Contains the tables for HIV/AIDS attitude indicators for men
	3.	Tables_rsky_mn: 	Contains the tables for risky sexual behaviors for men
	4.	Tables_test_mn: 	Contains the tables for HIV prior testing and counseling for men
	5.	Tables_circum:	Contains the tables for circumcision indicators
	6.               Tables_sti_mn:	Contains the tables for STI indicators for men
	7.               Tables_bhv_yng_mn:	Contains the table for sexual behavior among young people for men

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


****************************************************************************
****************************************************************************

* indicators from MR file.
compute wt=mv005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".


**************************************************************************************************
* Knowledge and Attitudes towards HIV/AIDS
**************************************************************************************************
*Ever heard of AIDS.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_ever_heard [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever heard of AIDS".		

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_ever_heard 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know reduce risk - use condoms.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_knw_risk_cond [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know reduce risk - use condoms".		

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by hk_knw_risk_cond 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know reduce risk - limit to one partner.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_knw_risk_sex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know reduce risk - limit to one partner".		

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by hk_knw_risk_sex 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know reduce risk - use condoms and limit to one partner.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_knw_risk_condsex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know reduce risk - use condoms and limit to one partner".		

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by hk_knw_risk_condsex 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know healthy person can have HIV.
ctables
  /table  mv013 [c] by
         hk_knw_hiv_hlth [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know healthy person can have HIV".		

*crosstabs 
    /tables = mv013 by hk_knw_hiv_hlth 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know HIV cannot be transmitted by mosquito bites.
ctables
  /table  mv013 [c] by
         hk_knw_hiv_mosq [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know HIV cannot be transmitted by mosquito bites".		

*crosstabs 
    /tables = mv013 by hk_knw_hiv_mosq 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know HIV cannot be transmitted by supernatural means.
ctables
  /table  mv013 [c] by
         hk_knw_hiv_supernat [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know HIV cannot be transmitted by supernatural means".		

*crosstabs 
    /tables = mv013 by hk_knw_hiv_supernat 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know HIV cannot be transmitted by sharing food with HIV infected person.
ctables
  /table  mv013 [c] by
         hk_knw_hiv_food [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know HIV cannot be transmitted by sharing food with HIV infected person".		

*crosstabs 
    /tables = mv013 by hk_knw_hiv_food 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know healthy person can have HIV and reject two common local misconceptions.
ctables
  /table  mv013 [c] by
         hk_knw_hiv_hlth_2miscp [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know healthy person can have HIV and reject two common local misconceptions".		

*crosstabs 
    /tables = mv013 by hk_knw_hiv_hlth_2miscp
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*HIV comprehensive knowledge.
ctables
  /table  mv013 [c] by
         hk_knw_comphsv [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "HIV comprehensive knowledge".		

*crosstabs 
    /tables = mv013 by hk_knw_comphsv
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know that HIV MTCT can occur during pregnancy.
ctables
  /table  mv013 [c] by
         hk_knw_mtct_preg [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know that HIV MTCT can occur during pregnancy".		

*crosstabs 
    /tables = mv013 by hk_knw_mtct_preg
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know that HIV MTCT can occur during delivery.
ctables
  /table  mv013 [c] by
         hk_knw_mtct_deliv [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know that HIV MTCT can occur during delivery".		

*crosstabs 
    /tables = mv013 by hk_knw_mtct_deliv
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know that HIV MTCT can occur during breastfeeding.
ctables
  /table  mv013 [c] by
         hk_knw_mtct_brfeed [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know that HIV MTCT can occur during breastfeeding".		

*crosstabs 
    /tables = mv013 by hk_knw_mtct_brfeed
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know all three HIV MTCT.
ctables
  /table  mv013 [c] by
         hk_knw_mtct_all3 [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know all three HIV MTCT".		

*crosstabs 
    /tables = mv013 by hk_knw_mtct_all3
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Know risk of HIV MTCT can be reduced by meds.
ctables
  /table  mv013 [c] by
         hk_knw_mtct_meds [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know risk of HIV MTCT can be reduced by meds".		

*crosstabs 
    /tables = mv013 by hk_knw_mtct_meds
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_know_mn.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Attitudes on HIV/AIDS
**************************************************************************************************
*Think that children with HIV should not go to school with HIV negative children.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_atd_child_nosch [c] [rowpct.validn '' f5.1] + hk_atd_child_nosch [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Think that children with HIV should not go to school with HIV negative children".		

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_atd_child_nosch 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Would not buy fresh vegetabels from a shopkeeper who has HIV.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_atd_shop_notbuy [c] [rowpct.validn '' f5.1] + hk_atd_shop_notbuy [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Would not buy fresh vegetabels from a shopkeeper who has HIV".		

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_atd_shop_notbuy 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Have discriminatory attitudes towards people living with HIV-AIDS.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_atd_discriminat [c] [rowpct.validn '' f5.1] + hk_atd_discriminat [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have discriminatory attitudes towards people living with HIV-AIDS".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_atd_discriminat 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_atd_mn.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Risky sexual behavior
**************************************************************************************************
*Two or more sexual partners.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_sex_2plus [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Two or more sexual partners".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_sex_2plus 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Had sex with a person that was not their partner.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_sex_notprtnr [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had sex with a person that was not their partner".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_sex_notprtnr 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Have two or more sexual partners and used condom at last sex.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_cond_2plus [c] [rowpct.validn '' f5.1] + hk_cond_2plus [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have two or more sexual partners and used condom at last sex".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_cond_2plus 
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Had sex with a person that was not their partner and used condom.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_cond_notprtnr [c] [rowpct.validn '' f5.1] + hk_cond_notprtnr [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had sex with a person that was not their partner and used condom".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_cond_notprtnr
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Mean number of sexual partners.
*total.
frequencies variables hk_sexprtnr_mean.

compute filter = range(mv836,1,95).
filter by filter.

ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         mv836 [s] [mean '' f5.1]
  /slabels visible=no
  /titles title=
    "Mean number of sexual partners".

* sort cases by mv013.
* split file by mv013.
* descriptives variables mv836 /statistics=mean.
* split file off.

* sort cases by mv501.
* split file by mv501.
* descriptives variables mv836 /statistics=mean.
* split file off.

* sort cases by mv025.
* split file by mv025.
* descriptives variables mv836 /statistics=mean.
* split file off.

* sort cases by mv024.
* split file by mv024.
* descriptives variables mv836 /statistics=mean.
* split file off.

* sort cases by mv106.
* split file by mv106.
* descriptives variables mv836 /statistics=mean.
* split file off.

* sort cases by mv190.
* split file by mv190.
* descriptives variables mv836 /statistics=mean.
* split file off.

filter off.

**************************************************************************************************
*Ever paid for sex.
ctables
  /table  mv013 [c] by
         hk_paid_sex_ever [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever paid for sex".	

*crosstabs 
    /tables = mv013 by hk_paid_sex_ever
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Paid for sex in the last 12 months.
ctables
  /table  mv013 [c] by
         hk_paid_sex_12mo [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Paid for sex in the last 12 months".	

*crosstabs 
    /tables = mv013 by hk_paid_sex_12mo
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Used a condom at last paid sex in the last 12 months.
ctables
  /table  mv013 [c] by
         hk_paid_sex_cond [c] [rowpct.validn '' f5.1] +  hk_paid_sex_cond [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Used a condom at last paid sex in the last 12 months".	

*crosstabs 
    /tables = mv013 by hk_paid_sex_cond
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_rsky_mn.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* HIV prior testing and counseling 
**************************************************************************************************
*Know where to get HIV test.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_test_where [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Know where to get HIV test".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_test_where
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Had prior HIV test and whether they received results.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_test_prior [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Had prior HIV test and whether they received results".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_test_prior
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Ever tested.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_test_ever [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever tested".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_test_ever
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Tested in last 12 months and received test results.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_test_12m [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Tested in last 12 months and received test results".	

*crosstabs 
    /tables = mv013 mv501 mv025 mv024 mv106 mv190 by hk_test_12m
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Heard of self-test kits.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_hiv_selftest_heard [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Heard of self-test kits".	

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by hk_hiv_selftest_heard
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Ever used a self-test kit.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_hiv_selftest_use [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ever used a self-test kit".	

*crosstabs 
    /tables = mv013 mv025 mv024 mv106 mv190 by hk_hiv_selftest_use
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
* Circumcision
**************************************************************************************************
*Circumcised.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c] by
         hk_circum [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Circumcised".	

*crosstabs 
    /tables = mv013 mv025 mv024 by hk_circum
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Circumcision status and provider.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c] by
         hk_circum_status_prov [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Circumcision status and provider".	

*crosstabs 
    /tables = mv013 mv025 mv024 by hk_circum_status_prov
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_circum.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Self reported STIs
**************************************************************************************************
*STI in the past 12 months.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_sti [c] [rowpct.validn '' f5.1] + hk_sti [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "STI in the past 12 months".	

*crosstabs 
    /tables = mv013 mv501 hk_circum mv025 mv024 mv106 mv190 by hk_sti
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Discharge in the past 12 months.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_computet_disch [c] [rowpct.validn '' f5.1] + hk_computet_disch [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Discharge in the past 12 months".	

*crosstabs 
    /tables = mv013 mv501 hk_circum mv025 mv024 mv106 mv190 by hk_computet_disch
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Genital sore in past 12 months.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_gent_sore [c] [rowpct.validn '' f5.1] + hk_gent_sore [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Genital sore in past 12 months".	

*crosstabs 
    /tables = mv013 mv501 hk_circum mv025 mv024 mv106 mv190 by hk_gent_sore
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*STI or STI symptoms in the past 12 months.
ctables
  /table  mv013 [c]
         + mv501 [c]
         + mv025 [c]
         + mv024 [c] 
         + mv106 [c]
         + mv190 [c] by
         hk_sti_symp [c] [rowpct.validn '' f5.1] + hk_sti_symp [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "STI or STI symptoms in the past 12 months".	

*crosstabs 
    /tables = mv013 mv501 hk_circum mv025 mv024 mv106 mv190 by hk_sti_symp
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
  /xls  documentfile="Tables_sti_mn.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Sexual behavior among young people
**************************************************************************************************
.
compute filter = mv012<25.
filter by filter.

* new age variable among young. 
recode mv012 (15 thru 17=1) (18,19=2) (20 thru 22=3) (23,24=4) (else=sysmis) into age_yng.
variable labels age_yng "Age".
value labels age_yng 1  " 15-17" 2 " 18-19" 3 " 20-22" 4 " 23-24".

*Sex before 15.
ctables
  /table  age_yng [c]
         + mv025 [c]
         + mv106 [c] by
         hk_sex_15 [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Sex before 15".	

*crosstabs 
    /tables = age_yng mv025 mv106 by hk_sex_15
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
.
filter off.
compute filter = mv012>17 and mv012<25.
filter by filter.

*Sex before 18.
ctables
  /table  age_yng [c]
         + mv025 [c]
         + mv106 [c] by
         hk_sex_18 [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Sex before 18".	

*crosstabs 
    /tables = age_yng mv025 mv106 by hk_sex_18
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
.
filter off.
compute filter = mv012<25.
filter by filter.

*Never had sexual.
ctables
  /table  age_yng [c]
         + mv025 [c]
         + mv106 [c] by
         hk_nosex_youth [c] [rowpct.validn '' f5.1] + hk_nosex_youth [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Never had sexual".	

*crosstabs 
    /tables = age_yng mv025 mv106 by hk_nosex_youth
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************

recode mv502 (0=0) (1,2=1) into marstat.
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
  /xls  documentfile="Tables_bhv_yng_mn.xls"
     operation=createfile.

output close * .



