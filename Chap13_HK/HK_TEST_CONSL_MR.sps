* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_TEST_CONSL_MR.sps
Purpose: 			Code for indicators on HIV prior testing and counseling 
Data inputs: 		MR dataset
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
---------------------------------------------------------------------------.

* indicators from MR file.

*** Coverage of Prior HIV Testing ***

*Know where to get HIV test.
compute hk_test_where=0.
if  (mv781=1 | mv783=1) hk_test_where=1.
variable labels hk_test_where "Know where to get an HIV test".
value labels  hk_test_where 0"No" 1"Yes".

*Had prior HIV test and whether they received results.
if mv781=1 & mv828=1 hk_test_prior=1.
if mv781=1 & (mv828<>1 or sysmis(mv828)) hk_test_prior=2.
if (mv781<>1 or sysmis(mv781)) & (mv828<>1 or sysmis(mv828)) hk_test_prior=3.
variable labels hk_test_prior "Prior HIV testing status and whether received test result".
value labels  hk_test_prior 1"Tested and received results" 2"Tested and did not receive results" 3"Never tested".

*Ever tested.
compute hk_test_ever=0.
if  (mv781=1) hk_test_ever=1.
variable labels hk_test_ever "Ever been tested for HIV".
value labels  hk_test_ever 0"No" 1"Yes".

*Tested in last 12 months and received test results.
compute hk_test_12m=0.
if  (mv828=1 & range(mv826a,0,11)) hk_test_12m=1.
variable labels hk_test_12m "Tested for HIV in the past 12 months and received results of the last test".
value labels  hk_test_12m 0"No" 1"Yes".

*Heard of self-test kits.
compute hk_hiv_selftest_heard=0.
if  range(mv856,1,3) hk_hiv_selftest_heard=1.
variable labels hk_hiv_selftest_heard "Ever heard of HIV self-test kits".
value labels  hk_hiv_selftest_heard 0"No" 1"Yes".

*Ever used a self-test kit.
compute hk_hiv_selftest_use=0.
if  (mv856=1) hk_hiv_selftest_use=1.
variable labels hk_hiv_selftest_use "Ever used a HIV self-test kit".
value labels  hk_hiv_selftest_use 0"No" 1"Yes".
