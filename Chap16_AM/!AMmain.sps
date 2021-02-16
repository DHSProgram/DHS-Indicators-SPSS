* Encoding: UTF-8.
********************************************************************************
Program:         AMmain.sps
Purpose:         Main file for the Mortality Chapter
				                  The main file will call other do files that will produce the AM indicators and produce tables
Data outputs:   Coded variables, table output on screen, and in excel tables
Author:            Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified:		February 12, 2021 by Ivana Bjelic
Note:               This program may take some time to run (5-10mins). Please wait until the program is finished before opening any excel files. 
********************************************************************************

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*working directory.
 cd "C:\Users\33697\ICF\Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap16_AM".

*data path where data files are stored.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* IR Files.
define irdata()
    "ZMIR61FL"
!enddefine.
*GMIR61FL.

* BR Files.
define brdata()
    "ZMBR61FL"
!enddefine.
*GMBR61FL.

********************************************************************************

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

*create var to generate filename.
string file (a2).
compute file=lower (char.substr(irdata,3,2)).

* ASFR and GFR do files.
insert file = "AM_gfr.sps".
*Purpose: 	Code fertility rates and general fertility rate for mortality calculations.

* Mortality Rate sps files.
insert file = "AM_rates.sps".
*Purpose: 	Code fertility rates. This do file will create tables.

*/
*******************************************************************************************************************************


