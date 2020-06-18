* Encoding: windows-1252.
*******************************************************************************************************************************
Program: 				NTmain.sps
Purpose: 				Main file for the Nutrition Chapter
						The main file will call other do files that will produce the NT indicators and produce tables
Data outputs:			coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		      May 17, 2020 by Ivana Bjelic

*******************************************************************************************************************************.
*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*local user 39585	//change employee id number to personalize path.
cd "C:\Users\33697\ICF/Analysis - Shared Resources\Code\DHS-Indicators-SPSS\Chap11_NT".

define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

**************************************************************************************************************

* select your survey.

* KR Files.
define krdata()
    "UGKR7BFL"
!enddefine.
* MMKR71FL TJKR70FL GHKR72FL TLKR71FL.

* PR Files.
define prdata()
    "UGPR7BFL"
!enddefine.
* MMPR71FL TJPR70FL GHPR72FL TLPR71FL.

* IR Files.
define irdata()
    "UGIR7BFL"
!enddefine.
* MMIR71FL TJIR70FL GHIR72FL TLIR71FL.

* MR Files.
define mrdata()
    "UGMR7BFL"
!enddefine.
* MMMR71FL TJMR70FL GHMR72FL TLMR71FL.

* HR Files.
define hrdata()
    "UGHR7BFL"
!enddefine.
* MMHR71FL TJHR70FL GHHR72FL TLHR71FL .

****************************

* KR file variables.

* Note: For the NT_MICRO sps file, you need to merge the KR with the HR file. 
* The merge will be performed before running any of the do files below. 

get file =  datapath + "\"+ hrdata + ".sav"
/rename (hv001=v001) (hv002=v002)
/keep v001 v002 hv234a.

save outfile = datapath + "\temp.sav".

* open KR dataset.
get file =  datapath + "\"+ krdata + ".sav".
match files
/file=*
/table= datapath + "\temp.sav"
/by v001 v002.

**** child's age ****.
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

* if b19 is present and not empty.
do if b19_included = 1.
    compute age = b19.
else.
** if b19 is not present, compute age.
    compute age = v008 - b3.
end if.

*******************

insert file = "NT_BRST_FED.sps".
*Purpose: 	Code breastfeeding indicators
*

insert file = "NT_CH_MICRO.sps".
*Purpose: 	Code micronutrient indicators

insert file = "NT_tables_KR.sps".
*Purpose: 	Produce tables for indicators computed from above do files. 

* Note: The following sps files select for the youngest child under 2 years living with the mother. Therefore some cases will be dropped. 

* Selecting for youngest child under 24 months and living with mother.
select if age < 24 & b9 = 0.
* if caseid is the same as the prior case, then not the last born.
select if caseid <> lag(caseid).

insert file = "NT_IYCF.sps".
*Purpose: 			Code to compute infant and child feeding indicators

insert file = "NT_tables2.sps".
*Purpose: 	Produce tables for indicators computed from above sps files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************
* PR file variables

* open dataset.
get file =  datapath + "\"+ prdata + ".sav".

insert file = "NT_CH_NUT.sps".
*Purpose: 	Code child's anthropometry indicators.

insert file = "NT_tables_PR.sps".
*Purpose: 	Produce tables for indicators computed from above sps files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* HR file variables.

* open dataset.
get file =  datapath + "\"+ hrdata + ".sav".

insert file = "NT_SALT.sps".
*Purpose: 	Code salt indicators

insert file = "NT_tables_HR.sps".
*Purpose: 	Produce tables for indicators computed from above sps files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* IR file variables.

* A merge with the HR file is required to compute one of the indicators. 

get file =  datapath + "\"+ hrdata + ".sav"
/rename (hv001=v001) (hv002 = v002)
/keep v001 v002 hv234a.

save outfile = datapath + "\temp.sav".

* open IR dataset.
get file =  datapath + "\"+ irdata + ".sav".
match files
/file=*
/table=datapath + "\temp.sav"
/by v001 v002.

insert file = "NT_WM_NUT.sps".
*Purpose: 	Code women's anthropometric indicators.

insert file = "NT_tables_IR.sps".
*Purpose: 	Produce tables for indicators computed from above sps files. 

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* MR file variables.

* A merge with the PR file is required to compute the indicators below.

get file =  datapath + "\"+ prdata + ".sav"
/rename (hv001=mv001) (hv002 = mv002) (hvidx = mv003)
/keep mv001 mv002 mv003 hv042 hb55 hb56 hb57 hb40 hv103.

save outfile = datapath + "\temp.sav".

* open MR dataset.
get file =  datapath + "\"+ mrdata + ".sav".
match files
/file=*
/table=datapath + "\temp.sav"
/by mv001 mv002 mv003.

insert file = "NT_MN_NUT.sps".
*Purpose: 	Code men's anthropometric indicators

insert file = "NT_tables_MR.sps".
*Purpose: 	Produce tables for indicators computed from above sps files. 

*/

*******************************************************************************************************************************
*******************************************************************************************************************************

erase file = datapath + "\temp.sav".
