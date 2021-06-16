* Encoding: UTF-8.
 ********************************************************************************************************************************
Program: 				FSmain.sps
Purpose: 				Main file for the Fistula Chapter
					The main file will call other do files that will produce the FS indicators and produce tables
Data outputs:			Coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		December 02, 2020 by Ivana Bjelic
Note:					This Chapter is a module and not part of the core questionnaire. 
 * 						Please check if the survey you are interested in has included this module in the survey. 
						
 * 						IMPORTANT!
						The variables for this chapter are not standardized and you would need to search for the variable names used in the survey of interest. 
 * 						The Afghanistan 2015 survey was used in the code. 
 * 						The FS_FIST.sps file contains notes on how to find the correct variables according the variable labels. The same code can then be used for the survey. 
						
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*working directory.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap19_FS".

*data path where data files are stored.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

****************************************************************************************************

* select your survey.

* IR Files.
define irdata()
    "AFIR71FL"
!enddefine.


*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

string file (a2).
compute file=lower (char.substr(irdata,3,2)).

insert file = "FS_FIST.sps".
*Purpose: 	Calculate fistula indicators among women

insert file = "FS_tables.sps".
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************
