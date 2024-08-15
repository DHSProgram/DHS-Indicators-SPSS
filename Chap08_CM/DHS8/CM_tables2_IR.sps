* Encoding: UTF-8.
*****************************************************************************************************
Program: 			CM_tables_IR.sps
Purpose: 			produce tables for high risk birth and high risk fertility behavior
Author:			Ivana Bjelic
Date last modified: October 09, 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Table_Risk_wm:	Contains the tables of high risk fertilty behavior indicators among women

*Notes: For women the indicators are outputed for age 15-49 in line 30. 
*This can be commented out if the indicators are required for all women.	
*****************************************************************************************************.

**************************************************************************************************
* High risk fertility indicators amoung women 
**************************************************************************************************.

* limiting to women age 15-49.
select if not(v012<15 | v012>49).

compute wt=v005/1000000.
weight by wt.

frequencies variables = cm_riskw_none cm_riskw_unavoid cm_riskw_any_avoid cm_riskw_u18 cm_riskw_o34 cm_riskw_interval cm_riskw_order
cm_riskw_any_single cm_riskw_mult1 cm_riskw_mult2 cm_riskw_mult3 cm_riskw_mult4 cm_riskw_mult5 cm_riskw_any_mult 
cm_riskw_u18_avoid cm_riskw_o34_avoid cm_riskw_interval_avoid cm_riskw_order_avoid.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_Risk_wm.xls"
     operation=createfile.

output close *.

new file.