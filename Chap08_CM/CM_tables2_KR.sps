* Encoding: UTF-8.
*****************************************************************************************************
Program: 			CM_tables_KR.sps
Purpose: 			produce tables for high risk birth and high risk fertility behavior
Author:			Ivana Bjelic
Date last modified: September 23, 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Table_Risk_birth:	Contains the tables of high risk births indicators
*****************************************************************************************************.

**************************************************************************************************
* High risk births and risk ratios
**************************************************************************************************
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies
   *descriptives to descriptives.

get file = datapath + "\cm_risk_births.sav".

compute wt=v005/1000000.

weight by wt.

* Percentage of births with risk - among births in the 5 years precedig the survey.

frequencies variables = cm_riskb_none cm_riskb_unavoid cm_riskb_any_avoid cm_riskb_u18 cm_riskb_o34 cm_riskb_interval cm_riskb_order 
cm_riskb_any_single cm_riskb_mult1 cm_riskb_mult2 cm_riskb_mult3 cm_riskb_mult4 cm_riskb_mult5 cm_riskb_any_mult 
cm_riskb_u18_avoid cm_riskb_o34_avoid cm_riskb_interval_avoid cm_riskb_order_avoid.

* Risk ratios - among births in the 5 years precedig the survey.
get file = datapath + "\temp.sav".

ctables
  /table cat by
         rr [s] [mean '' f5.2] 
  /titles title=
    "Percentage of births with risk - among births in the 5 years precedig the survey".		

* sort cases by cat.
* split file by cat.
* descriptives variables = rr / statistics = mean.
* split file off.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Risk_births.xls"
     operation=createfile.

output close *.

new file.

erase file = datapath + "\temp.sav".
erase file = datapath + "\cm_risk_births.sav".
