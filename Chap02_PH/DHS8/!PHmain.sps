* Encoding: UTF-8.
*******************************************************************************************************************************
Program: 				PHmain.sps
Purpose: 				Main file for the Population and Housing Chapter 
						The main file will call other do files that will produce the PH indicators and produce tables
Data outputs:			Coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		July 16 2020 by Ivana Bjelic
*******************************************************************************************************************************/
set more off

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

* set working directory.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap02_PH".

define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

***************

* select your survey.

* HR Files.
define hrdata()
    "ZMHR71FL"
!enddefine.
* GHHR72FL  MMHR71FL UGHR7BFL ZMHR71FL ZWHR71FL MWHR7AFL

* PR Files.
define prdata()
    "ZMPR71FL"
!enddefine.
* GHPR72FL  MMPR71FL UGPR7BFL ZMPR71FL ZWPR71FL MWHR7AFL

define brdata()
    "ZMBR71FL"
!enddefine.
* GHBR72FL  MMBR71FL UGBR7BFL ZMBR71FL ZWBR71FL MWHR7AFL

define country() 
    "country, year"
!enddefine.

****************************

* HR file variables.

* open dataset.
get file =  datapath + "\"+ hrdata + ".sav".

*create var to generate filename.
string file (a2).
compute file=lower (char.substr(hrdata,3,2)).
string filename (a6).
compute filename = lower (char.substr(hrdata,1,6) ).
string file1 (a2).
compute file1=lower (char.substr(hrdata,1,2)).
string file2 (a2).
compute file2=lower (char.substr(hrdata,5,2)).

insert file = "PH_SANI.sps".
* Purpose: 	Code Sanitation indicators.

insert file = "PH_WATER.sps".
* Purpose: 	Code Water Source indicators.

insert file = "PH_HOUS.sps".
* Purpose:	Code housing indicators such as house material, assets, cooking fuel and place, and smoking in the home

insert file = "PH_tables_HR.sps".
* Purpose: 	Produce tables for indicators computed from the above do files. 
*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* PR file variables

* open dataset.
get file =  datapath + "\"+ prdata + ".sav".

*create var to generate filename.
string file (a2).
compute file=lower (char.substr(hrdata,3,2)).
string filename (a6).
compute filename = lower (char.substr(hrdata,1,6) ).
string file1 (a2).
compute file1=lower (char.substr(hrdata,1,2)).
string file2 (a2).
compute file2=lower (char.substr(hrdata,5,2)).

insert file = "PH_HNDWSH.sps".
* Purpose:	Code handwashing indicators.

insert file = "PH_tables_PR.sps".
* Purpose: 	Produce tables for indicators computed from the above sps files.

insert file = "PH_SCHOL.sps".
* Purpose:	Code eduation and schooling indicators. 
* Note: This code will merge BR and PR files and drop some cases. It will also produce the excel file Tables_schol.

* open dataset again since cases were droped in PH_SCHOL.sps.
get file =  datapath + "\"+ prdata + ".sav".

insert file = "PH_POP.sps".
* Purpose: 	Code to compute population characteristics, birth registration, education levels, household composition, orphanhood, and living arrangments.
* Warning: This sps file will collapse the data and therefore some indicators produced will be lost. 
*               However, they are saved in the file PR_temp_children.sav and this data file will be used to produce the tables for these indicators in the PH_table code. 
*               This do file will produce the Tables_hh_comps for household composition (usually Table 2.8 or 2.9 in the Final Report). 

insert file = "PH_tables2.sps".
* Purpose: 	Produce tables for indicators computed from the PH_POP.sps file.

insert file = "PH_GINI.sps".
* Purpose:	Code to produce Gini index table. 
* Note: 	This code will collapse the data and produce the table Table_gini.xls

*******************************************************************************************************************************
*******************************************************************************************************************************


*erase temp files.
erase file =  datapath + "\PR_temp.sav".
erase file =  datapath + "\PR_temp_children.sav".

