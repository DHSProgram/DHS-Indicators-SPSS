* Encoding: windows-1252.
 *************************************************************************************************************************************************************************************************************
Program: 			RH_tables_BR.sps
Purpose: 			produce tables for indicators
Author:			 Ivana Bjelic
Date last modified: July 17 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
Tables_Deliv:	Contains the tables for the delivery indicators
***********************************************************************************************************************************************************************************************************/

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs.

compute wt=v005/1000000.

weight by wt.

* create denominator.
do if (age < period).
    compute nbr=1.
end if.
variable labels nbr "Number of births".

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************
* indicators from BR file.

****************************************************
* place of delivery.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
          rh_del_place [c] [rowpct.validn '' f5.1] + nbr [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Live births in past 5 yrs by place of delivery".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_del_place 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* type of health facilty.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_del_pltype [c] [rowpct.validn '' f5.1] + nbr [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Live births in past 5 yrs by place of delivery".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_del_pltype 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* type of provider.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_del_pv [c] [rowpct.validn '' f5.1] + nbr [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Person providing assistance during delivery ".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_del_pv
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* skilled provider.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_del_pvskill [c] [rowpct.validn '' f5.1] + nbr [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Skilled assistance during delivery".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_del_pvskill
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* C-section delivery.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_del_ces [c] [rowpct.validn '' f5.1] + nbr [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "C-section delivery".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_del_ces
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* C-section delivery timing.
ctables
  /table  v025 [c] 
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         rh_del_cestime [c] [rowpct.validn '' f5.1] + nbr [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "C-section delivery timing".

*crosstabs 
    /tables = v025 v024 v106 v190 by rh_del_cestime
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Duration of stay after delivery.

* Vaginal births.
* C-section births.
ctables
  /table  rh_del_cestimeR [c] by
         rh_del_stay [c] [rowpct.validn '' f5.1]+ rh_del_stay [s] [validn, 'Number of women', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=rh_del_stay total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Duration of stay after delivery".

*crosstabs 
    /tables = rh_del_cestimeR by rh_del_stay
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************.
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Deliv"
     operation=createfile.

output close * .

new file.

