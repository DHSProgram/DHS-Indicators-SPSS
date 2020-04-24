* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HV_PREV_MR.sps
Purpose: 			Code for HIV prevalence
Data inputs: 		MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: April 01, 2020 by Ivana Bjelic
Note:				This is using the merged file IRMRARmerge.sav
			
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
hv_hiv_pos				"HIV positive test result"
hv_hiv1_pos				"HIV-1 positive test result"
hv_hiv2_pos				"HIV-2 positive test result"
hv_hiv1or2_pos			"HIV-1 or HIV-2 positive test result"
*
hv_pos_ever_test	                    	"Ever tested for HIV and received result of most recent test among HIV positive"
hv_pos_12m_test			"Tested in the past 12 months and received result among HIV positive"
hv_pos_more12m_test		                  "Tested 12 or more months ago and received result among HIV positive"
hv_pos_ever_noresult                        	"Ever tested for HIV and did not receive the result of most recent test among HIV positive"
hv_pos_nottested	                    	"Not previously tested among HIV positive"
*
hv_neg_ever_test	                    	"Ever tested for HIV and received result of most recent test among HIV negative"
hv_neg_12m_test			"Tested in the past 12 months and received result among HIV negative"
hv_neg_more12m_test	                    	"Tested 12 or more months ago and received result among HIV negative"
hv_neg_ever_noresult                        	"Ever tested for HIV and did not receive the result of most recent test among HIV negative"
hv_neg_nottested	                    	"Not previously tested among HIV negative"
	
*----------------------------------------------------------------------------.

*MR.

* Although the file MR is indicated in line 35, this is using the merged file IRMRARmerge.sav

***************************************

*HIV positive result.
compute hv_hiv_pos = 0.
if (hiv03=1) hv_hiv_pos = 1.
variable labels hv_hiv_pos "HIV positive test result".
value labels hv_hiv_pos 0"No" 1"Yes".

*HIV-1 postive result.
compute hv_hiv1_pos = 0.
if any(hiv03,1,3) hv_hiv1_pos = 1.
variable labels hv_hiv1_pos "HIV-1 positive test result".
value labels hv_hiv1_pos 0"No" 1"Yes".

*HIV-2 positive result.
compute hv_hiv2_pos = 0.
if (hiv03=2) hv_hiv2_pos = 1.
variable labels hv_hiv2_pos "HIV-2 positive test result".
value labels hv_hiv2_pos 0"No" 1"Yes".

*HIV-1 or HIV-2 positive result.
compute hv_hiv1or2_pos = 0.
if any(hiv03,1,2,3) hv_hiv1or2_pos = 1.
variable labels hv_hiv1or2_pos "HIV-1 or HIV-2 positive test result".
value labels hv_hiv1or2_pos 0"No" 1"Yes".
	
*Ever tested among HIV positive.
do if any(hiv03,1,3).
+compute hv_pos_ever_test = 0.
+if (v781=1 & v828=1) hv_pos_ever_test = 1.
end if.
variable labels hv_pos_ever_test "Ever tested for HIV and received result of most recent test among HIV positive".
value labels  hv_pos_ever_test 0"No" 1"Yes".

*Tested in the last 12 months among HIV positive.
do if any(hiv03,1,3).
+compute hv_pos_12m_test = 0.
+if (v781=1 & v826a<12 & v828=1) hv_pos_12m_test = 1.
end if.
variable labels hv_pos_12m_test "Tested in the past 12 months and received result among HIV positive".
value labels hv_pos_12m_test 0"No" 1"Yes".

*Tested 12 ore more months ago among HIV positive.
do if any(hiv03,1,3).
+compute hv_pos_more12m_test = 0.
+if (v781=1 &  v826a>=12 & v828=1) hv_pos_more12m_test = 1.
end if.
variable labels hv_pos_more12m_test "Tested 12 or more months ago and received result among HIV positive".
value labels hv_pos_more12m_test 0"No" 1"Yes".

*Ever tested but did not receive most recent result among HIV positive.
do if any(hiv03,1,3).
+compute hv_pos_ever_noresult = 0.
+if (v781=1 & v828<>1) hv_pos_ever_noresult = 1.
end if.
variable labels hv_pos_ever_noresult "Ever tested for HIV and did not receive the result of most recent test among HIV positive".
value labels hv_pos_ever_noresult 0"No" 1"Yes".

*Not previously tested among HIV positive.
do if any(hiv03,1,3).
+compute hv_pos_nottested = 0.
+if (v781<>1) hv_pos_nottested = 1.
end if.
variable labels hv_pos_nottested "Not previously tested among HIV positive".
value labels hv_pos_nottested 0"No" 1"Yes".

*Ever tested among HIV negative.
do if any(hiv03,0,2,7,9).
+compute hv_neg_ever_test = 0.
+if (v781=1 & v828=1) hv_neg_ever_test = 1.
end if.
variable labels hv_neg_ever_test "Ever tested for HIV and received result of most recent test among HIV negative".
value labels hv_neg_ever_test 0"No" 1"Yes".

*Tested in the last 12 months among HIV negative.
do if any(hiv03,0,2,7,9).
+compute hv_neg_12m_test = 0.
+if (v781=1 & v826a<12 & v828=1) hv_neg_12m_test = 1.
end if.
variable labels hv_neg_12m_test "Tested in the past 12 months and received result among HIV negative".
value labels hv_neg_12m_test 0"No" 1"Yes".

*Tested 12 ore more months ago among HIV negative.
do if any(hiv03,0,2,7,9).
+compute hv_neg_more12m_test = 0.
+if (v781=1 & v826a>=12)  hv_neg_more12m_test = 1.
end if.
variable labels hv_neg_more12m_test "Tested 12 or more months ago and received result among HIV negative".
value labels hv_neg_more12m_test 0"No" 1"Yes".

*Ever tested but did not receive most recent result among HIV negative.
do if any(hiv03,0,2,7,9).
+compute hv_neg_ever_noresult = 0.
+if (v781=1 & v828<>1) hv_neg_ever_noresult = 1.
end if.
variable labels hv_neg_ever_noresult "Ever tested for HIV and did not receive the result of most recent test among HIV negative".
value labels hv_neg_ever_noresult 0"No" 1"Yes".

*Not previously tested among HIV negative.
do if any(hiv03,0,2,7,9).
+compute hv_neg_nottested = 0.
+if  (v781<>1) hv_neg_nottested = 1.
end if.
variable labels hv_neg_nottested "Not previously tested among HIV negative".
value labels hv_neg_nottested 0"No" 1"Yes".
	