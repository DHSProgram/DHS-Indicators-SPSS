* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HV_CIRCUM.sps
Purpose: 			Code for Circumcision and HIV
Data inputs: 		MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: March 31, 2020 by Ivana Bjelic
Note:				This is using the merged file IRMRARmerge.sav
			
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
hv_hiv_circum_skilled	                  "Circumcised by a health professional and HIV positive"
hv_hiv_circum_trad		"Circumcised by a traditional practitioner, family, or friend and HIV positive"
hv_hiv_circum_pos		"Circumcised and HIV positive"
hv_hiv_uncircum_pos		"Uncircumcised and HIV positive"
	
*----------------------------------------------------------------------------.

*Circumcised by health professional and HIV positive.
do if v483=1 & v483b=2.
+compute hv_hiv_circum_skilled=0.
+if (hiv03=1 or hiv03=3) hv_hiv_circum_skilled=1.
end if.
variable labels hv_hiv_circum_skilled "Circumcised by a health professional and HIV positive".
value labels hv_hiv_circum_skilled 0"No" 1"Yes".

*Circumcised by traditional practitioner/family/friend and HIV positive.
do if v483=1 & v483b=1.
+compute hv_hiv_circum_trad= 0.
+if (hiv03=1 or hiv03=3) hv_hiv_circum_trad=1.
end if.
variable labels hv_hiv_circum_trad "Circumcised by a traditional practitioner, family, or friend and HIV positive".
value labels hv_hiv_circum_trad 0"No" 1"Yes".

*Circumcised and HIV positive.
do if (v483=1).
+compute hv_hiv_circum_pos= 0. 
+if (hiv03=1 or hiv03=3) hv_hiv_circum_pos=1.
end if.
variable labels hv_hiv_circum_pos "Circumcised and HIV positive".
value labels hv_hiv_circum_pos 0"No" 1"Yes".

*Uncircumcised and HIV positive.
do if v483<>1. 
+compute hv_hiv_uncircum_pos= 0.
+if (hiv03=1 or hiv03=3) hv_hiv_uncircum_pos=1.
end if.
variable labels hv_hiv_uncircum_pos "Uncircumcised and HIV positive".
value labels hv_hiv_uncircum_pos 0"No" 1"Yes".
