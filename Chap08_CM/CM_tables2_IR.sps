* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CM_tables_IR.sps
Purpose: 			produce tables for high risk birth and high risk fertility behavior
Author:				Shireen Assaf
Date last modified: October 09 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Table_Risk_wm:	Contains the tables of high risk fertilty behavior indicators among women
*****************************************************************************************************.

**************************************************************************************************
* High risk fertility indicators amoung women 
**************************************************************************************************.

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