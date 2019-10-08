* Encoding: windows-1252.
*******************************************************************************************************************************
Program: 				CHmaster.sps
Purpose: 				Master file for the Child Health Chapter. 
 * 						The master file will call other do files that will produce the CH indicators and produce tables
Data outputs:			coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		September 01 2019 by Ivana Bjelic

*******************************************************************************************************************************.

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*local user 39585	//change employee id number to personalize path.
cd "C:/Users/33697/ICF/Analysis - Shared Resources/Code/DHS-Indicators-SPSS/Chap10_CH".
*.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* KR Files.
define krdata()
    "UGKR60FL"
!enddefine.
* MMKR71FL TJKR70FL GHKR72FL UGKR7AFL.

* IR Files.
define irdata()
    "UGIR60FL"
!enddefine.
* MMIR71FL TJIR70FL GHIR72FL UGIR7AFL.

****************************.

* KR file variables.

* open dataset.
get file =  datapath + "\"+ krdata + ".sav".

*** Child's age ***.
begin program.
import spss, spssaux
varList = "b19"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /b19_included=mean(b19).
recode b19_included (lo thru hi = 1)(else = 0).

***************************

* if b19 is present and not empty.
do if  b19_included = 1.
    compute age = b19.
else.
** if b19 is not present, compute age.
    compute age = v008 - b3.
end if.

**************************.

insert file = "CH_SIZE.sps".
*Purpose: 	Code child size indicators.

insert file = "CH_ARI_FV.sps".
*Purpose: 	Code ARI indicators.

insert file = "CH_DIAR.sps".
*Purpose: 	Code diarrhea indicators.

insert file = "CH_tables_KR.sps".
*Purpose: 	Produce tables for indicators computed from above do files. 

insert file = "CH_VAC.sps".
*Purpose: 	Code vaccination indicators.
*Note: This do file drops children that are not in a specific age group. 

insert file = "CH_tables_vac.sps".
*Purpose: 	Produce tables for vaccination indicators.

insert file = "CH_STOOL.sps".
*Purpose:	Safe disposal of stool
*Notes:				This do file will drop cases. 
*					This is because the denominator is the youngest child under age 2 living with the mother. 			
*					The do file will also produce the tables for these indicators. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables.

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

insert file = "CH_KNOW_ORS.sps".
*Purpose: 	Code knowledge of ORS

insert file = "CH_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from above do files. 

*******************************************************************************************************************************
*******************************************************************************************************************************
