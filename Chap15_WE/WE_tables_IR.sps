* Encoding: windows-1252.
*****************************************************************************************************
Program: 			WE_tables_IR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: October 19 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
1. 	Tables_emply_wm:	Contains the tables for employment and earning indicators for women
2. 	Tables_assets_wm:	Contains the tables for asset ownwership indicators for women
3. 	Tables_empw_wm:	Contains the tables for empowerment indicators, justification of wife beating, and decision making for women
*
Notes:	For women the indicators are outputed for age 15-49 in line 30. 
*This can be commented out if the indicators are required for all women.		

*Please see note on line 725 for constructing addition tables for the empowerment indicators*	
	Please check note on line 701 and 705. Only the first column for the first crosstabulation and the last column for the second crosstabulation are reported in the final report. 
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* limiting to women age 15-49.
select if not(v012<15 | v012>49).

compute wt=v005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".

* Number of living children.
recode v218 (0=0) (1,2=1) (3,4=2) (5 thru hi=3) (99,sysmis = sysmis) into numch.
variable labels numch "Number of living children".
value labels numch 0  " 0" 1 " 1-2" 2 " 3-4" 3 " 5+".

**************************************************************************************************
* Employment and earnings
**************************************************************************************************
*Employment in the last 12 months.
ctables
  /table  v013 [c]
              by
         we_empl [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Employment in the last 12 months".		

*crosstabs 
    /tables = v013 by we_empl
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Employment by type of earnings.
ctables
  /table  v013 [c]
              by
         we_empl_earn [c] [rowpct.validn '' f5.1] + we_empl_earn [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Employment by type of earnings".		

*crosstabs 
    /tables = v013 by we_empl_earn
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decision on wife's cash earnings.
ctables
  /table  v013 [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_earn_wm_decide [c] [rowpct.validn '' f5.1] + we_earn_wm_decide [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decision on wife's cash earnings".		

*crosstabs 
    /tables = v013 numch v025 v106 v024 v190 by we_earn_wm_decide
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Comparison of wife's cash earnings with husband.
ctables
  /table  v013 [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_earn_wm_compare [c] [rowpct.validn '' f5.1] + we_earn_wm_compare [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Comparison of wife's cash earnings with husband".		

*crosstabs 
    /tables = v013 numch v025 v106 v024 v190 by we_earn_wm_compare
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decision on husbands's cash earnings.
ctables
  /table  v013 [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_earn_hs_decide [c] [rowpct.validn '' f5.1] + we_earn_hs_decide [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decision on husbands's cash earnings".		

*crosstabs 
    /tables = v013 numch v025 v106 v024 v190 by we_earn_hs_decide
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decision on wife's cash earnings by comparison of wife to husband's earnings.
frequencies variables = we_earn_wm_compare we_earn_wm_decide.

*Decision on husband's cash earnings by comparison of wife to husband's earnings.
compute we_earn_wm_compare2=we_earn_wm_compare.
if (we_empl_earn=0 | we_empl_earn=3)  we_earn_wm_compare2=5.
if we_empl=0 we_earn_wm_compare2=6.
variable labels we_earn_wm_compare2 "comparison of wife to husband's earnings".
value labels we_earn_wm_compare2 
1 "More than husband"
2 "Less than husband" 
3 "Same as husband" 
4 "Husband has no cash earnings or not working" 
5 "Woman worked but has no cash earnings" 
6 "Woman did not work" 
8 "Don't know/missing".

crosstabs
    /tables = we_earn_wm_compare2 by we_earn_hs_decide
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_emply_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Ownership of assets
**************************************************************************************************
*Own a house.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_own_house [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Own a house".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_own_house
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Own land.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_own_land [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Own land".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_own_land
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Title or deed ownwership for house.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_house_deed [c] [rowpct.validn '' f5.1] + we_house_deed [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Title or deed ownwership for house".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_house_deed
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Title or deed ownwership for land.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_land_deed [c] [rowpct.validn '' f5.1] + we_land_deed [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Title or deed ownwership for land".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_land_deed
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Have a bank account.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_bank [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have a bank account".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_bank
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Have a mobile phone.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_mobile [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have a mobile phone".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_mobile
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Use mobile phone for financial transactions.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_mobile_finance [c] [rowpct.validn '' f5.1] + we_mobile_finance [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Use mobile phone for financial transactions".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_mobile_finance
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_assets_wm.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Decision making indicators
**************************************************************************************************
*Decision making indicators.

*on health, household purchases, and visits.
frequencies variables = we_decide_health we_decide_hhpurch we_decide_visits.

****************************************************
*Employment by earning .
if v731=0 emply=0.
if v731>0 & v731<8 & (v741=1 | v741=2) emply=1.
if v731>0 & v731<8 & (v741=0 | v741=3) emply=2.
variable labels emply "Employment in the last 12 months".
value labels emply 0"Not employed" 1"Employed for cash" 2"Employed not for cash".

*Decide on own health care either alone or jointly with partner.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_decide_health_self [c] [rowpct.validn '' f5.1] + we_decide_health_self [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on own health care either alone or jointly with partner".		

*crosstabs 
    /tables = v013 emply numch v025 v106 v024 v190 by we_decide_health_self
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide on household purchases either alone or jointly with partner.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_decide_hhpurch_self [c] [rowpct.validn '' f5.1] + we_decide_hhpurch_self [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on household purchases either alone or jointly with partner".		

*crosstabs 
    /tables = v013 emply numch v025 v106 v024 v190 by we_decide_hhpurch_self
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide on visits either alone or jointly with partner.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_decide_visits_self [c] [rowpct.validn '' f5.1] + we_decide_visits_self [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on visits either alone or jointly with partner".		

*crosstabs 
    /tables = v013 emply numch v025 v106 v024 v190 by we_decide_visits_self
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide on all three: health, purchases, and visits.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_decide_all [c] [rowpct.validn '' f5.1] + we_decide_all [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on all three: health, purchases, and visits".		

*crosstabs 
    /tables = v013 emply numch v025 v106 v024 v190 by we_decide_all
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide on none of three.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_decide_none [c] [rowpct.validn '' f5.1] + we_decide_none [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on none of three".		

*crosstabs 
    /tables = v013 emply numch v025 v106 v024 v190 by we_decide_none
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Justification of violence
**************************************************************************************************
*Justify wife beating if burns food.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_dvjustify_burn [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if burns food".		

*crosstabs 
    /tables = v013 emply numch v502 v025 v106 v024 v190 by we_dvjustify_burn
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if argues with him.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_dvjustify_argue [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if argues with him".		

*crosstabs 
    /tables = v013 emply numch v502 v025 v106 v024 v190 by we_dvjustify_argue
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if goes out with telling him.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_dvjustify_goout [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if goes out with telling him".		

*crosstabs 
    /tables = v013 emply numch v502 v025 v106 v024 v190 by we_dvjustify_goout
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if neglects children.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_dvjustify_neglect [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if neglects children".		

*crosstabs 
    /tables = v013 emply numch v502 v025 v106 v024 v190 by we_dvjustify_neglect
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if refuses sex.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_dvjustify_refusesex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if refuses sex".		

*crosstabs 
    /tables = v013 emply numch v502 v025 v106 v024 v190 by we_dvjustify_refusesex
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating - at least one reason.
ctables
  /table  v013 [c]
         + emply [c]
         + numch [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_dvjustify_onereas [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating - at least one reason".		

*crosstabs 
    /tables = v013 emply numch v502 v025 v106 v024 v190 by we_dvjustify_onereas
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify having no sex if husband is having sex with another woman.
ctables
  /table  v013 [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_justify_refusesex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify having no sex if husband is having sex with another woman".		

*crosstabs 
    /tables = v013 v502 v025 v106 v024 v190 by we_justify_refusesex
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify asking husband to use condom if he has STI.
ctables
  /table  v013 [c]
         + v502 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_justify_cond [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify asking husband to use condom if he has STI".		

*crosstabs 
    /tables = v013 v502 v025 v106 v024 v190 by we_justify_cond
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Can say no to husband if they dont want to have sex.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_havesay_refusesex [c] [rowpct.validn '' f5.1] + we_havesay_refusesex [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify asking husband to use condom if he has STI".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_havesay_refusesex
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Can ask husband to use a condom.
ctables
  /table  v013 [c]
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         we_havesay_condom [c] [rowpct.validn '' f5.1] + we_havesay_condom [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Can ask husband to use a condom".		

*crosstabs 
    /tables = v013 v025 v106 v024 v190 by we_havesay_condom
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Number of decisions by those who disagree with all reasons that justify wife beating (only first column).
crosstabs 
    /tables = we_num_decide by we_num_justifydv
    /format = avalue tables
    /cells = row 
    /count asis.

*Number of reasons that justify wife beating by those who participate in all decision making (only last column).
crosstabs 
    /tables = we_num_justifydv by we_num_decide
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_empw_wm.xls"
     operation=createfile.

output close * .

******************************************************
Note:
The women empowerment indicators we_num_decide and we_num_justifydv may also be tabulated by current contraceptive use and unment need (chapter 7), ideal number of children (chapter 6),
and reproductive health indicators (chapter 9). Please check these chapters to create the indicators of interest that you would like to include in the tabulations. 
*
For instance the code below would give the contraceptive use for those that participate in all three decision making items. 
* compute filter =we_num_decide=2.
* filter by filter.
* frequencies variables v313.
* filter off.
*****************************************************.

new file.
