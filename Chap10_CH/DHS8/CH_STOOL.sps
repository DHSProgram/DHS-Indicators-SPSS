* Encoding: windows-1252.
*******************************************************************************************************
Program: 			CH_STOOL.sps
Purpose: 			Code disposal of child's stook variable
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: September 06 2019 by Ivana Bjelic
Notes:				This sps file will drop cases. 
 * 					This is because the denominator is the youngest child under age 2 living with the mother. 			
 * 					The do file will also produce the tables for these indicators. 
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
ch_stool_dispose	"How child's stool was disposed"
ch_stool_safe	"Child's stool was disposed of appropriately"
----------------------------------------------------------------------------*.

* keep if under 24 months and living with mother.
select if (age < 24 & b9 = 0).

* and keep the last born of those.
* if caseid is the same as the prior case, then not the last born.

select if (caseid <> lag(caseid)).

*Stool disposal method.
recode v465 (1=1) (2=2) (5=3) (3=4) 	(4=5) (9=6) (96=96) (98=99) into ch_stool_dispose.
variable labels ch_stool_dispose "How child's stool was disposed among youngest children under age 2 living with mother".
value labels ch_stool_dispose 
1  "Child used toilet or latrine" 
2  "Put/rinsed into toilet or latrine" 
3  "Buried"
4  "Put/rinsed into drain or ditch"
5  "Thrown into garbage"
6  "Left in the open"
96 "Other" 
99 "DK/Missing".

*Safe stool disposal.
recode ch_stool_dispose (1,2,3 =1) (else=0) into ch_stool_safe.
variable labels ch_stool_safe "Child's stool was disposed of appropriately among youngest children under age 2 living with mother".
value labels ch_stool_safe 1  "Safe disposal" 0  "not safe".

****************************************************************************
* Produce tables for the above indicators 
****************************************************************************
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=v005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".

*Age in months.
recode age (0 thru 5=1) (6 thru 11=2) (12 thru 23=3) (24 thru 35=4) (36 thru 47=5) (48 thru 59=6) into agecats.
variable labels agecats "Age".
value labels agecats 1 "<6" 2 "6-11" 3 "12-23" 4 "24-35" 5 "36-47" 6 "48-59".

****************************************************************************
*Disposal of children's stool.
*Age in months (this may need to be recoded for this table).
ctables
  /table  agecats [c] 
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_stool_dispose [c] [rowpct.validn '' f5.1] + ch_stool_dispose [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Disposal of children's stool".			

*crosstabs 
    /tables = agecats v025 v024 v106 v190 by ch_stool_dispose
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Safe disposal of stool.
*Age in months (this may need to be recoded for this table).
ctables
  /table  agecats [c] 
         + v025 [c]
         + v024 [c]
         + v106 [c]
         + v190 [c] by
         ch_stool_safe [c] [rowpct.validn '' f5.1] + ch_stool_safe [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Safe disposal of stool".			

*crosstabs 
    /tables = agecats v025 v024 v106 v190 by ch_stool_safe
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_Stool.xls"
     operation=createfile.

output close * .

new file.
