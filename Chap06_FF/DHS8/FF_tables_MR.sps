* Encoding: windows-1252.
*****************************************************************************************************
Program: 			FF_tables_MR.sps
Purpose: 			produce tables for indicators of fertility preferences chapter
Author:				Ivana Bjelic
Date last modified: September 20 2019 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Tables_Pref_mn:	Contains tables for fertility preferences for men 

*Notes: For men the indicators are outputed for age 15-49 in line 25. 
*This can be commented out if the indicators are required for all men.		
*****************************************************************************************************.

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* limiting to men age 15-49.
select if not(mv012<15 | mv012>49).

compute wt=mv005/1000000.
weight by wt.

**************************************************************************************************
* Indicators for fertilty preferences
**************************************************************************************************
*Type of desire for children.
* tabulate by number of living children which includes currrent pregnancy for wife.
compute numch=mv218.
if mv213=1 numch=numch+1.
if numch>6 numch=6.
variable labels numch "Number of living children".
value labels numch 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6+".


ctables
  /table numch [c] by
         ff_want_type [c] [rowpct.validn '' f5.1] + ff_want_type [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Type of desire for children".		

*crosstabs 
    /tables = numch by ff_want_type 
    /format = avalue tables
    /cells = row
    /count asis
    /missing=include.


****************************************************

*Want no more children.
ctables
  /table (mv025[c] + mv106[c] + mv190[c]) > numch [c] by
         ff_want_nomore [c] [rowpct.validn '' f5.1] + ff_want_nomore [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Want no more children".		

*crosstabs 
    /tables = numch by ff_want_nomore by mv025
    /format = avalue tables
    /cells = row
    /count asis
    /missing=include.

*crosstabs 
    /tables = numch by ff_want_nomore by mv106
    /format = avalue tables
    /cells = row
    /count asis
    /missing=include.

*crosstabs 
    /tables = numch by ff_want_nomore by mv190
    /format = avalue tables
    /cells = row
    /count asis
    /missing=include.

****************************************************
*Ideal number of children.
ctables
  /table numch [c] by
         ff_ideal_num [c] [rowpct.validn '' f5.1] + ff_ideal_num [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Ideal number of children by number of living children".

*crosstabs 
    /tables = numch by ff_ideal_num 
    /format = avalue tables
    /cells = row
    /count asis
    /missing=include.

****************************************************

* mean ideal number of children for all men 14-59.
ctables
  /table ff_ideal_mean_all[s][mean,'',f5.1]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mean ideal number of children for all men 14-59".

*descriptives variables ff_ideal_mean_all 
/statistics = mean.

* to obtain mean ideal number of children for all men 15-49 and by number of children.
compute filter = mv613<95.
filter by filter.
ctables
  /table numch [c] by mv613[s][mean,'',f5.1]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mean ideal number of children for all men 14-59".

* sort cases by numch.
* split file separate by numch.
* descriptives variables = mv613/statistics=mean.
* split file off.

filter off.

* mean ideal number of children for married men 15-49.
ctables
  /table ff_ideal_mean_mar[s][mean,'',f5.1]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mean ideal number of children for married men 15-49".

*descriptives variables ff_ideal_mean_mar 
/statistics = mean.

* to obtain mean ideal number of children for married women 15-49 and by number of children.
compute filter = mv613<95 & mv502=1.
filter by filter.
ctables
  /table numch[c] by mv613[s][mean,'',f5.1]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mean ideal number of children for married men 14-59".

* sort cases by numch.
* split file separate by numch.
* descriptives variables = mv613/statistics=mean.
* split file off.

filter off.

****************************************************

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_Pref_mn.xlsx"
     operation=createfile.

output close * .

new file.


