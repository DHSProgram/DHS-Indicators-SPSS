* Encoding: windows-1252.
*******************************************************************************************************************************
Program: 				WEmain.sps
Purpose: 				Main file for the Women's Empowerment Chapter
						The main file will call other do files that will produce the WE indicators and produce tables
Data outputs:			Coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		October 19 2019 by Ivana Bjelic
*******************************************************************************************************************************

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap15_WE".

define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* IR Files.
define irdata()
    "ETIR71FL"
!enddefine.
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL KEIR71FL.

* MR Files.
define mrdata() 
    "ETMR71FL"
!enddefine.
* MMMR71FL TJMR70FL GHMR72FL UGMR7BFL.

define country() 
    "country, year"
!enddefine.

****************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

insert file = "WE_ASSETS_IR.sps".
*Purpose: 	Code employment, earnings, and asset ownership for women
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

insert file = "WE_EMPW_IR.sps".
*Purpose: 	Code decision making and justification of violence among women
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

insert file = "WE_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables.

* open dataset.
get file =  datapath + "\"+ mrdata + ".sav".

insert file = "WE_ASSETS_MR.sps".
*Purpose: 	Code employment, earnings, and asset ownership for men
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

insert file = "WE_EMPW_MR.sps".
*Purpose: 	Code decision making and justification of violence among men
*Note:		The default age group to compute the indicators is 15-49, you can change this in the do file. 

insert file = "WE_tables_MR.sps".
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
