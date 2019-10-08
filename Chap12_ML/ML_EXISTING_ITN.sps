* Encoding: windows-1252.
*****************************************************************************************************
Program: 			ML_EXISTING_ITN.do
Purpose: 			Code indicators for source of nets
Data inputs: 		HR survey list
Data outputs:		coded variables and the tables for the indicator produced which will be saved in the Tables_HH_ITN.xls excel file
Author:				Cameron Taylor and modified by Shireen Assaf, , translated to SPSS by Ivana Bjelic
Date last modified: August 31 2019 by Ivana Bjelic
*****************************************************************************************************

*----------------------------------------------------------------------------
Variables created in this file:
ml_sleepnet 		"Someone slept under net last night"
----------------------------------------------------------------------------*.
get file =  datapath + "\"+ hrdata + ".sav".

*Reshaping the dataset to a long format to tabulate amoung nets.
varstocases 
/make hml10_ from hml10$1 to hml10$7 
/make hml21_ from hml21$1 to hml21$7.

*Identifying if the net was used.
compute ml_sleepnet=0.
if hml21_=1 ml_sleepnet=1.
variable labels ml_sleepnet "Someone slept under net last night".
value labels ml_sleepnet 0 "No" 1 "Yes".

*Net is an ITN.
compute ml_ownnet=0.
if hml10_=1 ml_ownnet=1.
variable labels ml_ownnet "Net is an ITN".
value labels ml_ownnet 0 "No" 1 "Yes".

* Tables for these indicators.

compute wt=hv005/1000000.

weight by wt.

* create denominators.
compute numH=1.
variable labels numH "Number of households".

compute filter = (ml_ownnet=1).
filter by filter.

*ITN was used by anyone the night before the survey.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_sleepnet [c] [rowpct.validn '' f5.1] + numH [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "ITN was used by anyone the night before the survey".			

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_sleepnet 
    /format = avalue tables
    /cells = row 
    /count asis.		

* output to excel.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_HH_ITN.xls"
     operation=modifysheet  sheet='sheet1'
     location=lastrow.

output close *.

new file.
 
