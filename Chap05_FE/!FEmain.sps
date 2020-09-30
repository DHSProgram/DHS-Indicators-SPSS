* Encoding: UTF-8.
********************************************************************************
Program: 				FEmain.sps
Purpose: 				Main file for the Fertility Chapter
						The main file will call other do files that will produce
						the FE indicators and produce tables
Data outputs:			coded variables, table output on screen, and in excel tables
Author: 				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified:		September 29, 2020

********************************************************************************/

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697.

* change working path.
define workingpath()
 "C:/Users//$user//ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap05_FE"
!enddefine.

* change data path.
define datapath()
    "C:/Users//$user//ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

cd workingpath.

************************
* select your survey.

* IR Files.
define irdata()
    "NGIR7AFL"
!enddefine.
*TJIR72FL GHIR72FL TJBR72FL

* PR Files.
define prdata()
    "NGPR7AFL"
!enddefine.

* KR Files.
define krdata()
    "NGKR7AFL"
!enddefine.

*BR Files.
define brdata()
    "NGBR7AFL"
!enddefine.


define country() 
    "country, year"
!enddefine.

****************************

********************************************************************************
	
* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

* Fertility Rate sps files.
insert file = "FE_TFR.sps".
*Purpose: 	Code fertility rates. This do file will create tables.

* Reopen dataset for ASFR 10 to 14.
get file =  datapath + "\"+ irdata + ".sav".

insert file = "FE_ASFR_10_14.sps".
*Purpose: 	Code ASFR for 10-14 year olds. This file will create tables.

*/
* Reopen dataset for current fertility indicators.
get file =  datapath + "\"+ irdata + ".sav".

*create var to generate filename.
string file (a2).
compute file = lower ( char.substr(irdata,3,2) ).
 
insert file = "FE_FERT.sps".
*Purpose: 	Code fertility indicators about first birth, pregnancy, menopause and children born.

insert file = "FE_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from above do files. 


* PR file variables.

* open dataset.
get file =  datapath + "\"+ prdata + ".sav".

*create var to generate filename.
string file (a2).
compute file = lower ( char.substr(prdata,3,2) ).

insert file = "FE_CBR.sps".
* Purpose: 	Code crude birth rates. This file will create CBR tables. 
* This sps file must be run after the FE_TFR.sps file is run as it uses the variables created.


* BR file variables.
get file =  datapath + "\"+ brdata + ".sav".

*create var to generate filename.
string file (a2).
compute file = lower ( char.substr(brdata,3,2) ).

insert file = "FE_medians.sps".
* Purpose: Code median duration of amenorrhea, postpartum abstinence, and insusceptibility fertility.

* Reopen dataset for the other do files.

get file =  datapath + "\"+ brdata + ".sav".

*create var to generate filename.
string file (a2).
compute file = lower ( char.substr(brdata,3,2) ).

insert file = "FE_INT.sps".
* Purpose: Code indicators reflecting birth intervals and postpartum experience.

insert file = "FE_tables_BR.sps".
*Purpose: 	Produce tables for indicators computed from above do files. 

