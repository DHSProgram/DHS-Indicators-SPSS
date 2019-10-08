* Encoding: windows-1252.
* Encoding: .
*******************************************************************************************************************************.
 * Program: 				RHmaster.sps
 * Purpose: 				Master file for the Reporductive Health Chapter 
						The master file will call other do files that will produce the RH indicators and produce tables
 * Data outputs:			coded variables and table output on screen and in excel tables
 * Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
 * Date last modified:	                06/26/2019 by Ivana Bjelic
 * Notes:		                                                                                                                           	
*******************************************************************************************************************************

*** User information for internal DHS use. Please disregard and adjust change paths to your own. *** 

*local user 39585	//change employee id number to personalize path.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap09_RH".

*.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* IR Files.
define irdata()
    "UGIR60FL"
!enddefine.
* MMIR71FL TJIR70FL UGIR60FL MWIR7HFL GHIR72FL.
* BR Files.
define brdata() 
    "UGBR60FL"
!enddefine.
* MMBR71FL TJBR70FL UGBR60FL MWBR7HFL GHBR72FL.

define country() 
    "country, year"
!enddefine.

****************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

*.
insert file = "RH_age_period_IR.sps".
*Purpose:	Compute the age variable and set the period for the analysis. Period currently set at 5 years.

*.
insert file = "RH_ANC.sps".
*Purpose: 	Code ANC indicators.

*.
insert file = "RH_PNC.sps".
*Purpose: 	Code PNC indicators for mother and newborn.

*.
insert file = 'RH_Probs.sps'.
*Purpose: 	Code indicators for problems accessing health care.

*.
insert file =  "RH_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from above do files. This will output 3 excel files for these indicators.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* BR file variables.

* open dataset.
get file =  datapath + "\"+ brdata + ".sav".

*.
insert file = "RH_age_period_BR.sps".
*Purpose:	Compute the age variable and set the period for the analysis. Period currently set at 5 years.

*.
insert file = "RH_DEL.sps".
*Purpose: 	Code Delivery indicators.

*.
insert file =  "RH_tables_BR.sps".
*Purpose: 	Produce tables for indicators computed from above do files. This will output 2 excel files for these indicators.

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

