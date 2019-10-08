* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CH_KNOW_ORS.do
Purpose: 			Code knowledge of ORS variable
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: September 01 2019 by Ivana Bjelic
Notes:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
ch_know_ors		"Know about ORS as treatment for diarrhea among women with birth in the last 5 years"
----------------------------------------------------------------------------*.

*Know ORS.
do if v208<>0.
+compute ch_know_ors=0.
+if v416>0 & v416<3 ch_know_ors=1.
end if.
variable labels ch_know_ors "Know about ORS as treatment for diarrhea among women with birth in the last 5 years".
value labels ch_know_ors 0 "No" 1 "Yes".
