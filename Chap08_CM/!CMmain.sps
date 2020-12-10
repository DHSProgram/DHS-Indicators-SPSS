* Encoding: UTF-8.
*******************************************************************************************************************************
Program: 				CMmain.sps
Purpose: 				Main file for the Child Mortality Chapter
				The main file will call other do files that will produce the CM indicators and produce tables
Data outputs:			coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		September 23, 2019 by Ivana Bjelic
*******************************************************************************************************************************.

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*local user 39585	//change employee id number to personalize path.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap08_CM".

*.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.

* IR Files.
define irdata()
    "UGIR60FL"
!enddefine.
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL.

* BR Files.
define brdata() 
    "UGBR60FL"
!enddefine.
* MMBR71FL TJBR70FL GHBR72FL UGBR7AFL.

* KR Files.
define krdata() 
    "UGKR60FL"
!enddefine.
* MMBR71FL TJBR70FL GHBR72FL UGBR7AFL.

define country() 
    "country, year"
!enddefine.

****************************

* sps files that use the IR files.
insert file =  "CM_CHILD.sps".
*Purpose: 	Code child mortality indicators.
*Code contains programs that will produce a data file with the mortality rates overall and by background variables
*The outputs will be manipulated to produce tables that match the tables in the reports.  

insert file =  "CM_PMR.sps".
*Purpose: 	Code perinatal mortality.
*This  file uses IR and BR file.

insert file =  CM_tables1.sps.
*Purpose: 	Produce tables for indicators computed from above do files. 

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

insert file =  "CM_RISK_wm.sps".
*Purpose: 	Code high risk fertility indicators amoung women.
*WARNING: This do file will drop women that are not currently married.

insert file =  "CM_tables2_IR.sps".
*Purpose: 	Produce tables for high risk fertility. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************


* KR file variables.

* open dataset.
get file =  datapath + "\"+ krdata + ".sav".

insert file = "CM_RISK_births.sps".
*Purpose: 	Code high risk birth indicators and risk ratios.

insert file = "CM_tables2_KR.sps".
*Purpose: 	Produce tables for high risk births.

