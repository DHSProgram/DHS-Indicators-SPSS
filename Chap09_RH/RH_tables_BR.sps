* Encoding: windows-1252.
 *************************************************************************************************************************************************************************************************************
Program: 			RH_tables_BR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: July 17 2019 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_ANCvisits:	Contains the tables for ANC provider, ANC skilled provider, ANC number of visits, and timing of ANC visit by background variables
	2.	Tables_ANCcomps: 	Contains tables for all ANC components
  	3.	Tables_Probs: 	Contains the tables for problems accessing health care
	4.	Tables_PNC:	Contains the tables for the PNC indicators for women and newborns
	5.	Tables_Deliv:	Contains the tables for the delivery indicators
***********************************************************************************************************************************************************************************************************/

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

****************************************************.
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Deliv"
     operation=createfile.

output close * .

new file.

