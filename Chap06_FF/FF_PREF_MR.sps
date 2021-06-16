* Encoding: windows-1252.
*****************************************************************************************************
Program: 			FF_PREF_MR.sps
Purpose: 			Code to compute fertility preferences in men and women
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: September 08 2019 by Ivana Bjelic 
Note:				The five indicators below can be computed for men and women
				For men the indicator is computed for age 15-49 in line 56. This can be commented out if the indicators are required for all men.
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
ff_want_type		"Type of desire for children"
ff_want_nomore		"Want no more children"
ff_ideal_num		"Ideal number of children"
ff_ideal_mean_all            	"Mean ideal number of children for all"
ff_ideal_mean_mar            	"Mean ideal number of children for married"
----------------------------------------------------------------------------*.
* indicators from MR file.

* limiting to men age 15-49.
select if (mv012<=49).

*Desire for children.
* indicator is computed for men in a union.
do if mv502=1.
+compute ff_want_type= mv605.
end if.
missing values MV605 ().
apply dictionary from *
 /source variables = MV605
 /target variables = ff_want_type.
variable labels ff_want_type "Type of desire for children".

*Want no more.
*this includes men who are sterilzed or their partner is sterilzed.
*indicator is computed for men in a union.
do if mv502=1.
+recode mv605 (5,6=1) (else=0) into ff_want_nomore.
end if.
variable labels ff_want_nomore "Want no more children".
value labels ff_want_nomore 1 "Yes" 0 "No".

*Ideal number of children.
recode mv613 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6 thru 94=6) (95 thru 99=9) into ff_ideal_num.
variable labels ff_ideal_num "Ideal number of children".
value labels ff_ideal_num 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6+" 9 "non-numeric response".

*Mean ideal number of children - all men.

*Mean ideal number of children - all men.
compute iw = mv005/1000000.
weight by iw.
compute filter = mv613<95 & mv012<=49.
filter by filter.
aggregate 
 /outfile=* mode=addvariables overwrite=yes
 /break = 
 /V613_sum=SUM(mV613)
 /V613_num=N(mV613).
compute ff_ideal_mean_all=V613_sum/V613_num.
formats ff_ideal_mean_all (f2.1).
variable labels ff_ideal_mean_all "Mean ideal number of children for all".

*Mean ideal number of children - married men.
filter off.
compute filter = (mv613<95 & mv502=1 & mv012<=49).
filter by filter.
aggregate 
 /outfile=* mode=addvariables overwrite=yes
 /break = 
 /V613mar_sum=SUM(mV613)
 /V613mar_num=N(mV613).
compute ff_ideal_mean_mar= V613mar_sum/V613mar_num.
formats ff_ideal_mean_mar (f2.1).
variable labels ff_ideal_mean_mar "Mean ideal number of children for married".

filter off.
weight off.

