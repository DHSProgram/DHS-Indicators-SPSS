* Encoding: UTF-8.
*******************************************************************************************************************************
Program: 				DVmain.sps
Purpose: 				Main file for the Domesitc Violence Chapter
						The main file will call other do files that will produce the DV indicators and produce tables
Data outputs:			Coded variables and table output on screen and in excel tables
Author: 				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified:		September 10 2020 by Ivana Bjelic
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap17_DV".

*data path where data files are stored.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.


***************

* select your survey.

* IR Files.
define irdata()
    "MMIR7AFL"
!enddefine.
*NGIR7AFL MWIR7AFL.

****************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

*create var to generate filename.
string file (a2).
compute file=lower (char.substr(irdata,3,2)).

insert file = "DV_viol.sps".
*Purpose: 	Calculate violence indicators, such as age at first violence, ever experienced violence.

insert file = "DV_prtnr.sps".
*Purpose: 	Calculate violence indicators that have to do with spousal/partner violence and seeking help.

insert file ="DV_cntrl.sps".
*Purpose: 	Calculate violence indicators that have to do with spousal/partner violence and seeking help.

insert file = "DV_tables.sps".
*Purpose: 	Produce tables for indicators computed from the above do files.
* Note:		This will drop any women not in 15-49 age range. You can change this selection. Please check the notes in the do file.
*/
*******************************************************************************************************************************
*******************************************************************************************************************************



