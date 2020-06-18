* Encoding: windows-1252.
*******************************************************************************************************************************
Program: 				RCmain.do
Purpose: 				Main file for the Respondents' Characteristics Chapter
						The main file will call other do files that will produce the RC indicators and produce tables
Data outputs:			Coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		October 12 2019 by Ivana Bjelic
*******************************************************************************************************************************.

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

* set working directory.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap03_RC".

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

insert file = "RC_CHAR_IR.sps".
*Purpose: 	Code respondent characteristic indicators for women
* Note:		This will drop any women over age 49. You can change this selection. Please check the notes in the do file.

insert file = "RC_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from RC_CHAR.do file. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables.

* open dataset.
get file =  datapath + "\"+ mrdata + ".sav".

insert file = "RC_CHAR_MR.sps".
*Purpose: 	Code respondent characteristic indicators for men
* Note:		This will drop any men over age 49. You can change this selection. Please check the notes in the do file.

insert file = "RC_tables_MR.sps".
*Purpose: 	Produce tables for indicators computed from RC_CHAR.do file. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************