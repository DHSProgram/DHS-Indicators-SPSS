* Encoding: windows-1252.
*******************************************************************************************************************************
Program: 				HKmain.do
Purpose: 				Main file for the HIV-AIDS Related Knowledge, Attitudes, and Behaviors 
						The main file will call other sps files that will produce the HK indicators and produce tables
Data outputs:			Coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		November 28, 2019 by Ivana Bjelic
*******************************************************************************************************************************.

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap13_HK".

define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.


* select your survey.
* IR Files.
define irdata()
    "MWIR7AFL"
!enddefine.
* MMIR71FL GHIR72FL UGIR7BFL.

* MR Files.
define mrdata()
    "MWMR7AFL"
!enddefine.
* MMMR71FL GHMR72FL UGMR7BFL.


*******************************************************************************************************************************
* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

insert file = "HK_KNW_ATD_IR.sps".
*Purpose: 	Code to compute HIV-AIDS related knowledge and attitude indicators.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_RSKY_BHV_IR.sps".
*Purpose: 	Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_TEST_CONSL_IR.sps".
*Purpose: 	Code for indicators on HIV prior testing and counseling.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_STI_IR.sps".
*Purpose: 	Code for STI indicators.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_BHV_YNG_IR.sps".
*Purpose: 	Code for sexual behaviors among young people.
*Note:		The sps file focuses on young people. 

insert file = "HK_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from the above sps files.

*/
*******************************************************************************************************************************

* MR file variables.

* open dataset.
get file =  datapath + "\"+ mrdata + ".sav".

insert file = "HK_KNW_ATD_MR.sps".
*Purpose: 	Code to compute HIV-AIDS related knowledge and attitude indicators .
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_RSKY_BHV_MR.sps".
*Purpose: 	Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_TEST_CONSL_MR.sps".
*Purpose: 	Code for indicators on HIV prior testing and counseling.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_CIRCUM.sps".
*Purpose: 	Code for indicators on male circumcision.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. This sps file is only for men. 

insert file = "HK_STI_MR.sps".
*Purpose: 	Code for STI indicators.
*Note:		The default age group to compute the indicators is 15-49, you can change this in the sps file. 

insert file = "HK_BHV_YNG_MR.sps".
*Purpose: 	Code for sexual behaviors among young people.
*Note:		The sps file focuses on young people. 

insert file = "HK_tables_MR.sps".
*Purpose: 	Produce tables for indicators computed from the above sps files.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************
