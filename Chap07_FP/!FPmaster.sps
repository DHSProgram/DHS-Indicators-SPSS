* Encoding: windows-1252.
* Encoding: .
*******************************************************************************************************************************
Program: 				FPmaster.sps
Purpose: 				Master file for the Family Planning Chapter
						The master file will call other do files that will produce the FP indicators and produce tables
Data outputs:			coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		        Aug 15 by Ivana Bjelic

*Notes:				Indicators for men only cover knowledge of contraceptive methods and exposure to family planning messages
				Indicators are coded for all women/all men unless indicated otherwise
				In the tables do file you can select other populations of interest (ex: among those currently in a union)
*******************************************************************************************************************************/.

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

* set working directory.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap07_FP".

define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* IR Files.
define irdata()
    "UGIR60FL"
!enddefine.
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL.

* MR Files.
define mrdata() 
    "UGMR60FL"
!enddefine.
* MMMR71FL TJMR70FL GHMR72FL UGMR7AFL.

define country() 
    "country, year"
!enddefine.

****************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

*.
insert file = "FP_KNOW_IR.sps".
*Purpose: 	Code contraceptive knowledge variables.

*.
insert file = "FP_USE.sps".
*Purpose: 	Code contraceptive use variables (ever use and current use).

*.
insert file = "FP_NEED.sps".
* Purpose: 	Code contraceptive unmet need, met need, demand satisfied, intention to use.

*.
insert file = "FP_COMM_IR.sps".
* Purpose: 	Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 

*.
insert file = "FP_tables_IR.sps".
* Purpose: 	Produce tables for indicators computed from above do files. 


*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables.

* open dataset.
get file =  datapath + "\"+ mrdata + ".sav".

*.
insert file = "FP_KNOW_MR.sps".
*Purpose: 	Code contraceptive knowledge variables.

*.
insert file = "FP_COMM_MR.sps".
* Purpose: 	Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 

*.
insert file = "FP_tables_MR.sps".
* Purpose: 	Produce tables for indicators computed from above do files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* Discontinuation rates - need IR file.

*SETUP.
* open dataset.
* keep minimal variables due. 
get file =  datapath + "\"+ irdata + ".sav"
 /keep = caseid v001 v002 v003 v005 v007 v008 v011 v017 v018 v019 v021 v023 v101 v102 v106 v190 vcol$1 to vcal$9.

*.
insert file = "FP_EVENTS.sps".
* Purpose: 	Create an event file where the episode of contraceptive use is the unit of analysis.

insert file = "FP_DISCONT.sps".
* Purpose: 	Code discontinuation variables (discontinuaution rates and reasons for discontinuation) and create discontinuation tables
* Note: This do file will create the discontinuation results table Tables_Discont_12m.xlsx and a SPSS dataset eventsfile.sav for the survey. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

