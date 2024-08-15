* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_BHV_YNG_IR.sps
Purpose: 			Code for sexual behaviors among young people
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Nov 29, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. No age selection is made here. 
			
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_15			"Had sexual intercourse before age 15 among those age 15-24"
hk_sex_18			"Had sexual intercourse before age 18 among those age 18-24"
hk_nosex_youth		"Never had sexual intercourse among never-married age 15-24"
hk_sex_youth_test            	"Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"
----------------------------------------------------------------------------.

* indicators from IR file.

**************************.
*Sex before 15.
do if (v012<=24).
+compute hk_sex_15=0.
+if range(v531,1,14) hk_sex_15=1.
end if.
variable labels hk_sex_15 "Had sexual intercourse before age 15 among those age 15-24".
value labels  hk_sex_15 0"No" 1"Yes".

*Sex before 18.
do if (v012>=18 and v012<=24).
+compute hk_sex_18=0.
+if range(v531,1,17) hk_sex_18=1.
end if.
variable labels hk_sex_18 "Had sexual intercourse before age 18 among those age 18-24".
value labels  hk_sex_18 0"No" 1"Yes".

*Never had sexual.
do if (v012<=24 and v501=0).
+compute hk_nosex_youth=0.
+if (v525=0 | v525=99) hk_nosex_youth=1.
end if.
variable labels hk_nosex_youth "Never had sexual intercourse among never-married age 15-24".
value labels  hk_nosex_youth 0"No" 1"Yes".

*Tested and received HIV test results.
do if ((v012<=24) and (v527<252 or v527>299) and v527<=311 and v527>=100 and not sysmis(v527)).
+compute hk_sex_youth_test=0.
+if (range(v527,100,251) | range(v527,300,311)) & v828=1 & range(v826a,0,11) hk_sex_youth_test=1.
end if.
variable labels hk_sex_youth_test "Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24".
value labels  hk_sex_youth_test 0"No" 1"Yes".
