* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_CIRCUM.sps
Purpose: 			Code for indicators on male circumcision
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Nov 28, 2019 by Ivana Bjelic
Note:				The indicators are computed for all men. No age selection is made here. 
			
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
hk_circum			"Circumcised"
hk_circum_status_prov	                  "Circumcision status and provider"
----------------------------------------------------------------------------*.

* Indicators from MR file.

**************************
*Circumcised.
compute hk_circum=0.
if (mv483=1) hk_circum=1.
variable labels hk_circum "Circumcised".
value labels hk_circum 0"No" 1"Yes".

*Circumcision status and provider.
compute hk_circum_status_prov= mv483b.
if mv483b>2 hk_circum_status_prov=3.
if mv483=0 hk_circum_status_prov=0.
if mv483=8 hk_circum_status_prov=9.
variable labels  hk_circum_status_prov "Circumcision status and provider".
value labels hk_circum_status_prov 0"Not circumsised" 1"Traditional practitioner, family member, or friend" 2"Health work or health professional" 3 "Other/dont know/missing" 9"Dont know/missing circumcision status".







