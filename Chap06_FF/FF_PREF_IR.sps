* Encoding: windows-1252.
*****************************************************************************************************
Program: 			FF_PREF_IR.sps
Purpose: 			Code to compute fertility preferences in men and women
Data inputs: 		IR dataset
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

* indicators from IR file.

*Desire for children.
*indicator is computed for women in a union.
do if (v502=1).
+compute ff_want_type= v605.
+recode ff_want_type(sysmis=9).
end if.
missing values V605 ().
apply dictionary from *
 /source variables = V605
 /target variables = ff_want_type.
variable labels ff_want_type "Type of desire for children".

*Want no more.
*this includes women who are sterilzed or their partner is sterilzed.
*indicator is computed for women in a union.
do if (v502=1).
recode v605 (5,6=1) (else=0) into ff_want_nomore.
end if.
variable labels ff_want_nomore "Want no more children".
value labels ff_want_nomore 1 "Yes" 0 "No".

*Ideal number of children.
recode v613 (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6 thru 94=6) (95 thru 99=9) into ff_ideal_num.
variable labels ff_ideal_num "Ideal number of children".
value labels ff_ideal_num 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6+" 9 "non-numeric response".

*Mean ideal number of children - all women.
compute iw = v005/1000000.
weight by iw.
compute filter = v613<95.
filter by filter.
aggregate 
 /outfile=* mode=addvariables overwrite=yes
 /break = 
 /V613_sum=SUM(V613)
 /V613_num=N(V613).
compute ff_ideal_mean_all=V613_sum/V613_num.
formats ff_ideal_mean_all (f2.1).
variable labels ff_ideal_mean_all "Mean ideal number of children for all".

*Mean ideal number of children - married women.
filter off.
compute filter = (v613<95 & v502=1).
filter by filter.
aggregate 
 /outfile=* mode=addvariables overwrite=yes
 /break = 
 /V613mar_sum=SUM(V613)
 /V613mar_num=N(V613).
compute ff_ideal_mean_mar= V613mar_sum/V613mar_num.
formats ff_ideal_mean_mar (f2.1).
variable labels ff_ideal_mean_mar "Mean ideal number of children for married".

filter off.
weight off.
