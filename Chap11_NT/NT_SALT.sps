* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_SALT.sps
Purpose: 			Code to compute salt indicators in households
Data inputs: 		HR file
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: May 18 2020 by Ivana Bjelic
Note:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
nt_salt_any	"Salt among all households"
nt_salt_iod	"Households with iodized salt"

*----------------------------------------------------------------------------.

*Salt among all households.
recode hv234a (0,1=1) (6=2) (3=3) into nt_salt_any.
variable labels nt_salt_any "Salt among all households".
value labels nt_salt_any
1 "With salt tested"
2 "With salt but not tested"
3 "No salt in household".

*Have iodized salt.
do if hv234a<3.
+compute nt_salt_iod=0.
+if hv234a=1 nt_salt_iod=1.
end if.
variable labels nt_salt_iod "Households with iodized salt".
value labels nt_salt_iod 1 "Yes" 0 "No".
