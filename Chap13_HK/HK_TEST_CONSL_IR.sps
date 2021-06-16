* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_TEST_CONSL_IR.sps
Purpose: 			Code for indicators on HIV prior testing and counseling 
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Nov 29, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. No age selection is made here.
			
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
hk_test_where		"Know where to get an HIV test"
hk_test_prior		"Prior HIV testing status and whether received test result"
hk_test_ever		"Ever been tested for HIV"
hk_test_12m		"Tested for HIV in the past 12 months and received results of the last test"
*
hk_hiv_selftest_heard	                  "Ever heard of HIV self-test kits"
hk_hiv_selftest_use		"Ever used a HIV self-test kit"

* for women only	
hk_hiv_consl_anc		"Received counseling on HIV during ANC visit among women with a birth 2 years before the survey"
hk_test_consl_anc		"Received HIV test during ANC visit and received results and post-test counseling among women with a birth 2 years before the survey"
hk_test_noconsl_anc		"Received HIV test during ANC visit and received results but no post-test counseling among women with a birth 2 years before the survey"
hk_test_noresult_anc	                  "Received HIV test during ANC visit and did not receive test results among women with a birth 2 years before the survey"
hk_hiv_receivedall_anc      	"Received HIV counseling, HIV test, and test results during ANC visit among women with a birth 2 years before the survey"
hk_test_anclbr_result      	"Received HIV test during ANC visit or labor and received results among women with a birth 2 years before the survey"
hk_test_anclbr_result     	"Received HIV test during ANC visit or labor but did not receive results among women with a birth 2 years before the survey"
	
----------------------------------------------------------------------------.

* indicators from IR file.

*** Coverage of Prior HIV Testing ***

*Know where to get HIV test.
compute hk_test_where=0.
if (v781=1 | v783=1) hk_test_where=1.
variable labels hk_test_where "Know where to get an HIV test".
value labels  hk_test_where 0"No" 1"Yes".

*Had prior HIV test and whether they received results.
if v781=1 & v828=1 hk_test_prior=1.
if v781=1 & (v828<>1 or sysmis(v828)) hk_test_prior=2.
if (v781<>1 or sysmis(v781)) & (v828<>1 or sysmis(v828)) hk_test_prior=3.
variable labels hk_test_prior "Prior HIV testing status and whether received test result".
value labels  hk_test_prior 1"Tested and received results" 2"Tested and did not receive results" 3"Never tested".

*Ever tested.
compute hk_test_ever=0.
if (v781=1) hk_test_ever=1.
variable labels hk_test_ever "Ever been tested for HIV".
value labels  hk_test_ever 0"No" 1"Yes".

*Tested in last 12 months and received test results.
compute hk_test_12m=0.
if  (v828=1 & range(v826a,0,11)) hk_test_12m=1.
variable labels hk_test_12m "Tested for HIV in the past 12 months and received results of the last test".
value labels  hk_test_12m 0"No" 1"Yes".

*Heard of self-test kits.
compute hk_hiv_selftest_heard=0.
if range(v856,1,3) hk_hiv_selftest_heard=1.
variable labels hk_hiv_selftest_heard "Ever heard of HIV self-test kits".
value labels  hk_hiv_selftest_heard 0"No" 1"Yes".

*Ever used a self-test kit.
compute hk_hiv_selftest_use=0.
if (v856=1) hk_hiv_selftest_use=1.
variable labels hk_hiv_selftest_use "Ever used a HIV self-test kit".
value labels  hk_hiv_selftest_use 0"No" 1"Yes".

*** Pregnant Women Counseled and Tested for HIV ***

* Indicators are among women with a live birth in the two years preceiding the survey. 
* To make this restriction we need to compute the age of most recent child (agec).

** To check if survey has b19. If variable doesnt exist, empty variable is created.
begin program.
import spss, spssaux
varList = "b19$01"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /b19_included=mean(b19$01).
recode b19_included (lo thru hi = 1)(else = 0).

***************************

* BR file variables.
* if b19 is present and not empty.
do if  b19_included = 1.
    compute agec = b19$01.
else.
** if b19 is not present, compute age.
    compute agec = v008 - b3$01.
end if.

***	

*Received counseling on HIV during ANC visit.
do if  (agec<24).
+compute hk_hiv_consl_anc=0.
+if (v838a=1 & v838b=1 & v838c=1) hk_hiv_consl_anc=1.
end if.
variable labels hk_hiv_consl_anc "Received counseling on HIV during ANC visit among women with a birth 2 years before the survey".
value labels  hk_hiv_consl_anc 0"No" 1"Yes".

*Tested for HIV during ANC visit and received results and post-test counseling.
do if  (agec<24).
+compute hk_test_consl_anc=0.
+if (v841=1 & v855=1) hk_test_consl_anc=1.
end if.	
variable labels hk_test_consl_anc "Received HIV test during ANC visit and received results and post-test counseling among women with a birth 2 years before the survey".
value labels  hk_test_consl_anc 0"No" 1"Yes".

*Tested for HIV during ANC visit and received results but no post-test counseling.
do if  (agec<24).
+compute hk_test_noconsl_anc=0.
+if ( v841=1 & v855<>1) hk_test_noconsl_anc=1.
end if.
variable labels hk_test_noconsl_anc "Received HIV test during ANC visit and received results but no post-test counseling among women with a birth 2 years before the survey".
value labels  hk_test_noconsl_anc 0"No" 1"Yes".

*Tested for HIV during ANC visit and did not receive test results.
do if  (agec<24).
+compute hk_test_noresult_anc=0.
+if (v841=0) hk_test_noresult_anc=1.
end if.	
variable labels hk_test_noresult_anc "Received HIV test during ANC visit and did not receive test results among women with a birth 2 years before the survey".
value labels  hk_test_noresult_anc 0"No" 1"Yes".

*Received HIV counseling, test, and results.
do if  (agec<24).
+compute hk_hiv_receivedall_anc=0.
+if (v838a =1 & v838b =1 & v838c =1 & v840 =1 & v841 =1) hk_hiv_receivedall_anc=1.
end if.
variable labels hk_hiv_receivedall_anc "Received HIV counseling, HIV test, and test results during ANC visit among women with a birth 2 years before the survey".
value labels  hk_hiv_receivedall_anc 0"No" 1"Yes".

*Received HIV test during ANC or labor and received results.
do if  (agec<24).
+compute hk_test_anclbr_result=0.
+if (v840=1 | v840a=1) & (v841=1 | v841a=1) hk_test_anclbr_result=1.
end if.
variable labels hk_test_anclbr_result "Received HIV test during ANC visit or labor and received results among women with a birth 2 years before the survey".
value labels  hk_test_anclbr_result 0"No" 1"Yes".

*Received HIV test during ANC or labor but did not receive results.
do if  (agec<24).
+compute hk_test_anclbr_noresult=0.
+if ((v840=1 | v840a=1) & ((v841<>1 or sysmis(v841)) & (v841a<>1 or sysmis(v841a)))) hk_test_anclbr_noresult=1.
end if.
variable labels hk_test_anclbr_noresult "Received HIV test during ANC visit or labor but did not receive results among women with a birth 2 years before the survey".
value labels  hk_test_anclbr_noresult 0"No" 1"Yes".
