* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_BHV_YNG_MR.sps
Purpose: 			Code for sexual behaviors among young people
Data inputs: 		MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Nov 29, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. 
			
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_15			"Had sexual intercourse before age 15 among those age 15-24"
hk_sex_18			"Had sexual intercourse before age 18 among those age 18-24"
hk_nosex_youth		"Never had sexual intercourse among never-married age 15-24"
hk_sex_youth_test            	"Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"
----------------------------------------------------------------------------.

* indicators from MR file.

**************************.
*Sex before 15.
do if (mv012<=24).
+compute hk_sex_15=0.
+if range(mv531,1,14) hk_sex_15=1.
end if.
variable labels hk_sex_15 "Had sexual intercourse before age 15 among those age 15-24".
value labels  hk_sex_15 0"No" 1"Yes".

*Sex before 18.
do if (mv012>=18 and mv012<=24).
+compute hk_sex_18=0.
+if range(mv531,1,17) hk_sex_18=1.
end if.
variable labels hk_sex_18 "Had sexual intercourse before age 18 among those age 18-24".
value labels  hk_sex_18 0"No" 1"Yes".

*Never had sexual.
do if (mv012<=24 and mv501=0).
+compute hk_nosex_youth=0.
+if (mv525=0 | mv525=99) hk_nosex_youth=1.
end if.
variable labels hk_nosex_youth "Never had sexual intercourse among never-married age 15-24".
value labels  hk_nosex_youth 0"No" 1"Yes".

*Tested and received HIV test results.
do if ((mv012<=24) and (mv527<252 or mv527>299) and mv527<=311 and mv527>=100 and not sysmis(mv527)).
+compute hk_sex_youth_test=0.
+if (range(mv527,100,251) | range(mv527,300,311)) & mv828=1 & range(mv826a,0,11) hk_sex_youth_test=1.
end if.
variable labels hk_sex_youth_test "Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24".
value labels  hk_sex_youth_test 0"No" 1"Yes".



