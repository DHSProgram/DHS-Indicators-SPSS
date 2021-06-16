* Encoding: UTF-8.
*******************************************************************************************************************************
Program: 			FGmain.sps
Purpose: 			Main file for the Female Genital Cutting Chapter
			The main file will call other do files that will produce the DV indicators and produce tables
Data outputs:		Coded variables and table output on screen and in excel tables
Author: 			Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:	                  December 03, 2020 by Ivana Bjelic
Note:			This Chapter is a module and not part of the core questionnaire
			Please check if the survey you are interested in has included this module in the survey. 
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*working directory.
define workingpath()
    "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap18_FG".
!enddefine.

*data path where data files are stored.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

cd workingpath.

* select your survey.

* IR Files.
define irdata()
    "ETIR71FL"
!enddefine.

* BR Files.
define brdata()
    "ETBR71FL"
!enddefine.

* MR Files.
define mrdata()
    "ETMR71FL"
!enddefine.

****************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

*create var to generate filename.
string file (a2).
compute file=lower (char.substr(irdata,3,2)).

insert file = "FG_CIRCUM_IR.sps".
*Purpose: 	Calculate female circumcision indicators among women.

insert file = "FG_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*/
*******************************************************************************************************************************

* BR file variables.

* open dataset.
get file =  datapath + "\"+ brdata + ".sav".

insert file = "FG_GIRLS.sps".
*Purpose: 	Calculate female circumcision indicators among girls age 0-14
*	This do file will also create the tables for these indicators
* This code only uses the BR file. Older surveys may not have information about the daughter's cirucumcision in the BR file. 
* The information may instead be in the IR file. In that case please use the FG_GIRLS_merge.do file.  

*insert file = "FG_GIRLS_merge.sps".
*Purpose: 	Calculate female circumcision indicators among girls age 0-14
*	This do file will also create the tables for these indicators
* Use this do file if information about the daughter's circumcision status is not found in the BR file. 
* To compute female circumcision among girls 0-14, we need to merge the IR and BR files
* This code will reshape the IR file and merge with the BR file so we create a file for daughters. 
* The information on female circumcision of daughter is reported by the mother in the IR file
*/
*******************************************************************************************************************************

* MR file variables.

* open dataset.
get file =  datapath + "\"+ mrdata + ".sav".

string file (a2).
compute file=lower (char.substr(mrdata,3,2)).

insert file = "FG_CIRCUM_MR.sps".
*Purpose: 	Calculate female circumcision indicators among men (related to knowledge and opinion).

insert file = "FG_tables_MR.sps".
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any men not in 15-49 age range. You can change this selection. Please check the notes in the do file.
*/


