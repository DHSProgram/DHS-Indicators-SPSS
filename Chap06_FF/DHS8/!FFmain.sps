* Encoding: windows-1252.
*******************************************************************************************************************************
Program: 				FFmain.sps
Purpose: 				Main file for the Fertility Preferences Chapter
						The main file will call other do files that will produce the FF indicators and produce tables
Data outputs:			coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		Octobar 13 2019 by Ivana Bjelic

*******************************************************************************************************************************.

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

* set working directory.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap06_FF".

define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* IR Files.
define irdata()
    "UGIR60FL"
!enddefine.
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL KEIR71FL.

* BR Files.
define mrdata() 
    "UGMR60FL"
!enddefine.
* MMMR71FL TJMR70FL GHMR72FL UGMR7BFL.

define country() 
    "country, year"
!enddefine.

****************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

*.
insert file = "FF_PREF_IR.sps".
*Purpose: 	Code desire for children and ideal number of children for women.

insert file = "FF_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from FF_PREF.sps file. 
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.

insert file = "FF_PLAN.sps".
*Purpose: 	Code fertility planning status indicator and produce table Table_FFplan.

insert file = "FF_WANT_TFR.sps".
*Purpose: 	Code wanted fertility and produces table Table_WANT_TFR.sps to match the final report. 

*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables.

* open dataset.
get file =  datapath + "\"+ mrdata + ".sav".

insert file = "FF_PREF_MR.sps".
*Purpose: 	Code desire for children and ideal number of children for men.

insert file = "FF_tables_MR.sps".
*Purpose: 	Produce tables for indicators computed from above sps files. 
* Note:		This will drop any men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
