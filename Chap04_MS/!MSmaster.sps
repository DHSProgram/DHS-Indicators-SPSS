* Encoding: windows-1252.
*******************************************************************************************************************************
Program: 				MSmaster.do
Purpose: 				Master file for the Marriage and Sexual Activity Chapter 
					The master file will call other do files that will produce the MS indicators and produce tables
Data outputs:			coded variables and table output on screen and in excel tables
Author: 				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified:		September 25, 2019 by Ivana Bjelic

*******************************************************************************************************************************.

*** User information for internal DHS use. Please disregard and adjust change paths to your own. *** 

*change working path.
 cd "C:/Users/39585/ICF/Analysis - Shared Resources/Code/DHS-Indicators-SPSS/Chap04_MS".

*change data path.
define datapath()
    "C:/Users/39585/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* IR Files.
define irdata()
    "UGIR60FL"
!enddefine.
* MMIR71FL TJIR70FL GHIR72FL UGIR7BFL KEIR71FL.

* MR Files.
define mrdata() 
    "UGMR60FL"
!enddefine.
* MMMR71FL TJMR70FL GHMR72FL UGMR7BFL.

define country() 
    "country, year"
!enddefine.

*
*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

*Purpose: 	Code marital status variables.
insert file = "MS_MAR_IR.sps".

*Purpose: 	Code sexual activity variables.
insert file = "MS_SEX_IR.sps".

*Purpose: 	Produce tables for indicators computed from above do files. 
insert file = "MS_tables_IR.sps".

*
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables

* open dataset.
get file =  datapath + "\"+ mrdata + ".sav".

*Purpose: 	Code marital status variables.
insert file = "MS_MAR_MR.sps".

*Purpose: 	Code sexual activity variables.
insert file = "MS_SEX_MR.sps".

*Purpose: 	Produce tables for indicators computed from above do files. 
insert file = "MS_tables_MR.sps".
*/
*******************************************************************************************************************************
*******************************************************************************************************************************
