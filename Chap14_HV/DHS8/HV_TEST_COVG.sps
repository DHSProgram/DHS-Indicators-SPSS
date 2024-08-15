* Encoding: windows-1252.	
*****************************************************************************************************
Program: 			HK_TEST_COVG.sps
Purpose: 			Code for coverage of HIV testing
Data inputs: 		PR file merged with AR file
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: January 14, 2020 by Ivana Bjelic
Note:				
			
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
hv_hiv_test_wm	"Testing status among wommen eligible for HIV testing"
hv_hiv_test_mn	"Testing status among men eligible for HIV testing"
hv_hiv_test_tot	"Testing status among total eligible for HIV testing"
	
*----------------------------------------------------------------------------.

* Note: The denominator is among de facto population that is selected for HIV testing. 
* Here hv027 (selected for men's survey) are those selected for HIV. 

*HIV testing status among women.
compute test=$sysmis. 
if ha63=1 & (hiv03<>8 or sysmis(hiv03)) test=1.
if ha63=3 test=2.
if ha63=2 test=3.
if any(ha63,4,5,6,9) or hiv03=8 test=4.
if hv103=0 or hv027=0 test=$sysmis.

recode ha65 (1=1) (2 thru 7=2) into interv.
compute hv_hiv_test_wm= test*10+interv.
recode hv_hiv_test_wm (11=1)(12=2)(21=3)(22=4)(31=5)(32=6)(41=7)(42=8).
variable labels hv_hiv_test_wm "Testing status among wommen eligible for HIV testing".
value labels hv_hiv_test_wm 
    1"DHS tested/interviewed" 
    2"DHS tested/not interveiwed" 
    3"Refused to give blood/interviewed" 
    4"Refused to give blood/not interviewed" 
    5"Not available for blood collection/interveiwed" 
    6"Not available for blood collection/not interveiwed" 
    7"Other or missing/interviewed" 
    8"Other or missing/not interveiwed".

execute.
delete variables test interv.

*HIV testing status among men.
compute test=$sysmis.
if hb63=1 & (hiv03<>8 | sysmis(hiv03))  test=1.
if hb63=3  test=2.
if hb63=2  test=3.
if any(hb63,4,5,6,9) | hiv03=8 test=4.
if hv103=0 | hv027=0  test=$sysmis.

recode hb65 (1=1) (2 thru 7=2) into interv.
compute hv_hiv_test_mn=  test*10+interv.
recode hv_hiv_test_mn (11=1)(12=2)(21=3)(22=4)(31=5)(32=6)(41=7)(42=8).
variable labels hv_hiv_test_mn "Testing status among men eligible for HIV testing".
value labels hv_hiv_test_mn 
    1"DHS tested/interviewed" 
    2"DHS tested/not interveiwed" 
    3"Refused to give blood/interviewed" 
    4"Refused to give blood/not interviewed" 
    5"Not available for blood collection/interveiwed" 
    6"Not available for blood collection/not interveiwed" 
    7"Other or missing/interviewed" 
    8"Other or missing/not interveiwed".

execute.
delete variables test interv.

*HIV testing status among total population (men and women).
compute hv_hiv_test_tot = $sysmis.
if hv104=2 hv_hiv_test_tot= hv_hiv_test_wm.
if hv104=1 hv_hiv_test_tot= hv_hiv_test_mn.
variable labels hv_hiv_test_tot "Testing status among total eligible for HIV testing".
value labels hv_hiv_test_tot 
    1"DHS tested/interviewed" 
    2"DHS tested/not interveiwed" 
    3"Refused to give blood/interviewed" 
    4"Refused to give blood/not interviewed" 
    5"Not available for blood collection/interveiwed" 
    6"Not available for blood collection/not interveiwed" 
    7"Other or missing/interviewed" 
    8"Other or missing/not interveiwed".

*check.
* compute filter=(hv105>=15 & hv105<50).
* filter by filter.
* frequencies variables = hv_hiv_test_wm hv_hiv_test_mn hv_hiv_test_tot.
* filter off.