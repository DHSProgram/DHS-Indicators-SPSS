* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HV_PREV_CR.sps
Purpose: 			Code for HIV prevalence
Data inputs: 		CR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: January 14, 2020 by Ivana Bjelic
Note:				This is using the merged file IRMRARmerge.sav
			
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
hv_couple_hiv_status                        	"HIV status for couples living in the same household both of whom had HIV test in survey"
	
* CR file.

compute hv_couple_hiv_status=$sysmis.
if (w_hiv03<>1 or w_hiv03<>3) and(m_hiv03<>1 or m_hiv03<>3) hv_couple_hiv_status=1.
if (w_hiv03<>1 or w_hiv03<>3) and(m_hiv03=1 or m_hiv03=3) hv_couple_hiv_status=2.
if (w_hiv03=1 or w_hiv03=3) and(m_hiv03<>1 or m_hiv03<>3) hv_couple_hiv_status=3.
if (w_hiv03=1 or w_hiv03=3) and(m_hiv03=1 or m_hiv03=3) hv_couple_hiv_status=4.
variable labels hv_couple_hiv_status "HIV status for couples living in the same household both of whom had HIV test in survey".
value labels hv_couple_hiv_status 1"Both HIV negative" 2"Man HIV positive, woman HIV negative" 3"Woman HIV positive, man HIV negative" 4"Both HIV positive".
