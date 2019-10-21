* Encoding: windows-1252.
*****************************************************************************************************
Program: 			WE_tables_MR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: October 19 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1.	Tables_emply_mn:	Contains the tables for employment and earning indicators for men
	2.	Tables_assets_mn:	Contains the tables for asset ownwership indicators for men
	3.	Tables_empw_mn:	Contains the tables for empowerment indicators, justification of wife beating, and decision making for men
*
Notes:		For men, the tables are produced according to the age group identified in the WE_ASSETS_MR and the WE_EMPW_MR sps files. Currently it is for men 15-49 by default
		This can be changed in the sps files that constuct the indicators. 
*	
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=mv005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".

* Number of living children.
recode mv218 (0=0) (1,2=1) (3,4=2) (5 thru hi=3) (99,sysmis = sysmis) into numch.
variable labels numch "Number of living children".
value labels numch 0  " 0" 1 " 1-2" 2 " 3-4" 3 " 5+".

**************************************************************************************************
* Employment and earnings
**************************************************************************************************
*Employment in the last 12 months.
ctables
  /table  mv013 [c]
              by
         we_empl [c] [rowpct.validn '' f5.1] + we_empl [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Employment in the last 12 months".		

*crosstabs 
    /tables = mv013 by we_empl
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Employment by type of earnings.
ctables
  /table  mv013 [c]
              by
         we_empl_earn [c] [rowpct.validn '' f5.1] + we_empl_earn [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Employment by type of earnings".		

*crosstabs 
    /tables = mv013 by we_empl_earn
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decision on husband's cash earnings.
ctables
  /table  mv013 [c]
         + numch [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_earn_mn_decide [c] [rowpct.validn '' f5.1] + we_earn_mn_decide [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decision on husband's cash earnings".		

*crosstabs 
    /tables = mv013 numch mv025 mv106 mv024 mv190 by we_earn_mn_decide
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_emply_mn.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Ownership of assets
**************************************************************************************************
*Own a house.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_own_house [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Own a house".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by we_own_house
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Own land.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_own_land [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Own land".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by we_own_land
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Title or deed ownwership for house.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_house_deed [c] [rowpct.validn '' f5.1] + we_house_deed [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Title or deed ownwership for house".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by we_house_deed
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Title or deed ownwership for land.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_land_deed [c] [rowpct.validn '' f5.1] + we_land_deed [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Title or deed ownwership for land".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by we_land_deed
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Have a bank account.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_bank [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have a bank account".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by we_bank
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Have a mobile phone.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_mobile [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Have a mobile phone".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by we_mobile
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Use mobile phone for financial transactions.
ctables
  /table  mv013 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_mobile_finance [c] [rowpct.validn '' f5.1] + we_mobile_finance [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Use mobile phone for financial transactions".		

*crosstabs 
    /tables = mv013 mv025 mv106 mv024 mv190 by we_mobile_finance
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_assets_mn.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Decision making indicators
**************************************************************************************************
*Decision making indicators.

*on health and household purchases.
frequencies variables = we_decide_health we_decide_hhpurch.

****************************************************
*Employment by earning either alone or jointly with partner.
if mv731=0 emply=0.
if mv731>0 & mv731<8 & (mv741=1 | mv741=2) emply=1.
if mv731>0 & mv731<8 & (mv741=0 | mv741=3) emply=2.
variable labels emply "Employment in the last 12 months".
value labels emply 0"Not employed" 1"Employed for cash" 2"Employed not for cash".

*Decide on own health care.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_decide_health_self [c] [rowpct.validn '' f5.1] + we_decide_health_self [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on own health care either alone or jointly with partner".		

*crosstabs 
    /tables = mv013 emply numch mv025 mv106 mv024 mv190 by we_decide_health_self
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide on household purchases either alone or jointly with partner.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_decide_hhpurch_self [c] [rowpct.validn '' f5.1] + we_decide_hhpurch_self [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on household purchases either alone or jointly with partner".		

*crosstabs 
    /tables = mv013 emply numch mv025 mv106 mv024 mv190 by we_decide_hhpurch_self
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide on both health and purchases.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_decide_all [c] [rowpct.validn '' f5.1] + we_decide_all [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on both health and purchases".		

*crosstabs 
    /tables = mv013 emply numch mv025 mv106 mv024 mv190 by we_decide_all
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Decide on neither of two decisions (health and purchases).
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_decide_none [c] [rowpct.validn '' f5.1] + we_decide_none [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Decide on neither of two decisions (health and purchases)".		

*crosstabs 
    /tables = mv013 emply numch mv025 mv106 mv024 mv190 by we_decide_none
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Justification of mviolence
**************************************************************************************************
*Justify wife beating if burns food.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_dvjustify_burn [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if burns food".		

*crosstabs 
    /tables = mv013 emply numch mv502 mv025 mv106 mv024 mv190 by we_dvjustify_burn
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if argues with him.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_dvjustify_argue [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if argues with him".		

*crosstabs 
    /tables = mv013 emply numch mv502 mv025 mv106 mv024 mv190 by we_dvjustify_argue
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if goes out with telling him.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_dvjustify_goout [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if goes out with telling him".		

*crosstabs 
    /tables = mv013 emply numch mv502 mv025 mv106 mv024 mv190 by we_dvjustify_goout
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if neglects children.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_dvjustify_neglect [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if neglects children".		

*crosstabs 
    /tables = mv013 emply numch mv502 mv025 mv106 mv024 mv190 by we_dvjustify_neglect
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating if refuses sex.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_dvjustify_refusesex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating if refuses sex".		

*crosstabs 
    /tables = mv013 emply numch mv502 mv025 mv106 mv024 mv190 by we_dvjustify_refusesex
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify wife beating - at least one reason.
ctables
  /table  mv013 [c]
         + emply [c]
         + numch [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_dvjustify_onereas [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify wife beating - at least one reason".		

*crosstabs 
    /tables = mv013 emply numch mv502 mv025 mv106 mv024 mv190 by we_dvjustify_onereas
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify having no sex if husband is having sex with another woman.
ctables
  /table  mv013 [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_justify_refusesex [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify having no sex if husband is having sex with another woman".		

*crosstabs 
    /tables = mv013 mv502 mv025 mv106 mv024 mv190 by we_justify_refusesex
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
*Justify asking husband to use condom if he has STI.
ctables
  /table  mv013 [c]
         + mv502 [c]
         + mv025 [c]
         + mv024 [c]
         + mv106 [c]
         + mv190 [c] by
         we_justify_cond [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Justify asking husband to use condom if he has STI".		

*crosstabs 
    /tables = mv013 mv502 mv025 mv106 mv024 mv190 by we_justify_cond
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_empw_mn.xls"
     operation=createfile.

output close * .

new file.


