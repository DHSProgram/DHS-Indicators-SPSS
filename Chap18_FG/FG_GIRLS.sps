* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FG_GIRLS.sps
Purpose: 			Code to compute female circumcision indicators among girls 0-14
Data inputs: 		IR and BR survey list
Data outputs:		coded variables
Author:				Tom Pullum and Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: October 28, 2020 by Ivana Bjelic
Note:				Women in the IR file are asked about the circumcision of their daughters.
*					However, we need to reshape the file so that the data file uses daughters as the unit of analysis. 
*					We also need to merge the IR and BR file to include all daughters 0-14 in the denominator.
*					All the daughters age 0-14 must be in the denominator, including those whose mothers have
					g100=0; just those with g121=1 go into the numerator
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*	
fg_fcircum_gl	"Circumcised among girls age 0-14"	
fg_age_gl		"Age at circumcision among girls age 0-14"
fg_who_gl		"Person who performed the circumcision among girls age 0-14"
fg_sewn_gl		"Female circumcision type is sewn closed among girls age 0-14"
	
*----------------------------------------------------------------------------.

***************** Creating a file for daughters age 0-14 *********************
* Prepare the IR file for merging.
get file =  datapath + "\"+ irdata + ".sav".

* Reshape the IR file so there is one record per daughter.
varstocases
 /make gidx from GIDX$01 to GIDX$20
 /make g121 from G121$01 to G121$20
 /make g122 from G122$01 to G122$20
 /make g123 from G123$01 to G123$20
 /make g124 from G124$01 to G124$20
.

select if not sysmis(gidx).

rename variables (gidx=bidx).
compute in_IR=1.

sort cases by v001 v002 v003 bidx.

save outfile =  datapath + "\IRtemp.sav"/keep v001 v002 v003 bidx g121 g122 g123 g124 in_IR.

* Prepare the BR file.
get file =  datapath + "\"+ brdata + ".sav".

* Identify girls, living and age 0-14 (b15=1 is redundant).
select if (b4=2 & b5=1 & b8<=14).

* Crucial line to drop the mothers and daughters who did not get the long questionnaire.
* drop the girl if the g question were not asked of her mother.
select if not sysmis(G100).

compute age5=1+trunc(b8/5).
value labels age5 1 " 0-4" 2 " 5-9" 3 " 10-14".

* in_BR identifies a daughter who is eligible for a g121 code.
compute in_BR=1.

* MERGE THE BR FILE WITH THE RESHAPED IR FILE.
sort cases by v001 v002 v003 bidx.
match files file=*
/table = datapath + "\IRtemp.sav"
/by v001 v002 v003 bidx.

* Some girls in the BR file do not have a value on g121 because their mothers had not heard of female circumcision.
* Crucial line to get the correct denominator.
if in_BR=1 & sysmis(in_IR) g121=0.

*drop if in_BR=.

******************************************************************************

*Circumcised girls 0-14.
compute fg_fcircum_gl=0.
if g121=1 fg_fcircum_gl=1.
variable labels fg_fcircum_gl "Circumcised among girls age 0-14".
value labels fg_fcircum_gl 0"No" 1"Yes".

*Age circumcision among girls 0-14.
compute fg_age_gl = 0.
if g122=0 fg_age_gl = 1.
if range(g122,1,4) fg_age_gl = 2.
if range(g122,5,9)  fg_age_gl = 3.
if range(g122,10,14)  fg_age_gl = 4.
if g122=98 or g122=99 fg_age_gl = 9.
if g121=0 fg_age_gl = 0.
variable labels fg_age_gl "Age at circumcision among girls age 0-14".
value labels fg_age_gl 0"not circumcised" 1"<1" 2"1-4" 3"5-9" 4"10-14" 9"Don't know/missing".

*Person performing the circumcision among girls age 0-14.
do if g121=1.
+recode g124 (21=1) (22=2) (26=3) (11=4) (12=5) (16=6) (96=7) (98,99=9) into fg_who_gl.
end if.
variable labels fg_who_gl "Person who performed the circumcision among girls age 0-14".
value labels fg_who_gl 1 "traditional circumciser" 2 "traditional birth attendant" 3 "other traditional agent" 4 "doctor" 5 "nurse/midwife" 6 "other health professional" 7 "other" 9 "don't know/missing".

*Type of circumcision among girls age 0-14.
do if g121=1.
+recode g123 (0=0) (1=1) (8,9=9) into fg_sewn_gl.
end if.
variable labels fg_sewn_gl "Female circumcision type is sewn closed among girls age 0-14".
value labels fg_sewn_gl 0 "not sewn close" 1 "sewn close" 9 "don't know/missing".

**************************************************************************************************
**************************************************************************************************

* Produce Tables_Circum_gl excel file which contains the tables for the indicators of female circumcision among girls age 0-14.

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.
*

compute wt=v005/1000000.
weight by wt.

*Prevalence of circumcision and age of circumcision.

* Age of circumcision by current age.
ctables
  /table  age5 [c] 
              by
         fg_age_gl [c] [rowpct.validn '' f5.1] + fg_age_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Age of circumcision by current age".		

*crosstabs 
    /tables = age5 by fg_age_gl
    /format = avalue tables
    /cells = row 
    /count asis.


* Prevalence of circumcision by current age.
ctables
  /table  age5 [c] 
              by
         fg_fcircum_gl [c] [rowpct.validn '' f5.1] + fg_fcircum_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Prevalence of circumcision by current age".		

*crosstabs 
    /tables = age5 by fg_fcircum_gl
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************

*Prevalence of circumcision by mother's background characteristics.

*Circumcised mother.
do if not sysmis(g100).
compute fg_fcircum_wm = 0.
if g102=1 fg_fcircum_wm = 1.
end if.
variable labels fg_fcircum_wm "Circumcised among women age 15-49".
value labels fg_fcircum_wm 0"No" 1"Yes".

***** Among girls age 0-4 *****.
compute filter = (age5=1).
filter by filter.
ctables
  /table  v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            fg_fcircum_wm [c] +  /*mother's circumcision status
            v190 [c]                    /*wealth 
              by
         fg_fcircum_gl [c] [rowpct.validn '' f5.1] + fg_fcircum_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among girls age 0-4".		

*crosstabs 
    /tables = v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_wm by fg_fcircum_gl
    /format = avalue tables
    /cells = row 
    /count asis.

***** Among girls age 5-9 *****.
filter off.
compute filter = (age5=2).
filter by filter.
ctables
  /table  v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            fg_fcircum_wm [c] +  /*mother's circumcision status
            v190 [c]                    /*wealth 
              by
         fg_fcircum_gl [c] [rowpct.validn '' f5.1] + fg_fcircum_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among girls age 5-9".		

*crosstabs 
    /tables = v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_wm by fg_fcircum_gl
    /format = avalue tables
    /cells = row 
    /count asis.

***** Among girls age 10-14 *****.
filter off.
compute filter = (age5=3).
filter by filter.
ctables
  /table  v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            fg_fcircum_wm [c] +  /*mother's circumcision status
            v190 [c]                    /*wealth 
              by
         fg_fcircum_gl [c] [rowpct.validn '' f5.1] + fg_fcircum_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among girls age 10-14".		

*crosstabs 
    /tables = v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_wm by fg_fcircum_gl
    /format = avalue tables
    /cells = row 
    /count asis.

***** Among girls age 0-14 : Total *****.
filter off.
ctables
  /table  v025 [c] +                 /*residence
            v024 [c] +                 /*region
            v106 [c] +                 /*education
            fg_fcircum_wm [c] +  /*mother's circumcision status
            v190 [c]                    /*wealth 
              by
         fg_fcircum_gl [c] [rowpct.validn '' f5.1] + fg_fcircum_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Among girls age 10-14: Total".		

*crosstabs 
    /tables = v025 v106 v024 fg_fcircum_wm v190 fg_fcircum_wm by fg_fcircum_gl
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Person performing the circumcision among women girls 0-14 and type of cirucumcision.
ctables
  /table  age5 [c] 
              by
         fg_who_gl [c] [rowpct.validn '' f5.1] + fg_who_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Person performing the circumcision among women girls 0-14 and type of cirucumcision".		

*crosstabs 
    /tables = age5 by fg_who_gl
    /format = avalue tables
    /cells = row 
    /count asis.

****
*Sewn close.
ctables
  /table  age5 [c] 
              by
         fg_sewn_gl [c] [rowpct.validn '' f5.1] + fg_sewn_gl [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Sewn close".		

*crosstabs 
    /tables = age5 by fg_sewn_gl
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_Circum_gl.xls"
     operation=createfile.

output close * .

new file.

erase file = datapath + "\IRtemp.sav".
