* Encoding: windows-1252.
* Encoding: wininsert file = "ws-1252.
*******************************************************************************************************************************
Program: 				HVmain.sps
Purpose: 				Main file for HIV Prevalence
						The main file will call other insert file = " files that will produce the HV indicators and produce tables
Data outputs:			Coded variables and table output on screen and in excel tables
Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified:		January 14, 2020 by Ivana Bjelic
*******************************************************************************************************************************

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*global user 39585	//change employee id number to personalize path
global user 33697

cd "C:/Users//`user'//ICF/Analysis - Shared Resources/Code/DHS-Indicators-SPSS/Chap14_HV".

define datapath()
    "C:/Users//`user'//ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.


* select your survey.
* IR Files.
define irdata()
    "GHIR72FL"
!enddefine.
* MMIR71FL GHIR72FL UGIR7BFL.

* MR Files.
define mrdata()
    "GHMR71FL"
!enddefine.
* MMMR71FL GHMR72FL UGMR7BFL.

*CR files.
define crdata()
    "GHCR71FL"
!enddefine.
* MMCR71FL GHCR72FL UGCR7BFL.

*PR files.
define prdata()
    "GHPR72FL"
!enddefine.
* MMPR71FL GHPR72FL UGPR7BFL.

*AR files - files with HIV test results.
define ardata()
    "GHAR71FL"
!enddefine.
* MMAR71FL GHAR72FL UGAR7BFL.

****************************.

* PR file variables.
* merge AR file to PR file.
* open AR dataset.
get file =  datapath + "\"+ ardata + ".sav".
rename variables (hivclust=hv001)(hivnumb=hv002)(hivline=hvidx).
sort cases by hv001 hv002 hvidx.
save outfile = datapath + "\temp.sav".

* open PR dataset.
get file =  datapath + "\"+ prdata + ".sav".
sort cases by hv001 hv002 hvidx.

match files
/file= *
/table = datapath + "\temp.sav"
/by hv001 hv002 hvidx.

insert file = "HV_TEST_COVG.sps".
*Purpose: 	Code to compute HIV testing status

insert file = "HV_tables_PR.sps".
*Purpose: 	Produce tables for indicators computed from the above sps file".

*******************************************************************************************************************************

*IR, MR, AR file.

* A merge of the IR and MR files with the AR file is needed to produce the Total HIV prevalence and present them by background variables present in the IR and MR files.
* The following merge sequence will produce an IRMRARmerge.sav file for the survey of interest.

* merge AR file to IR file.
get file =  datapath + "\"+ ardata + ".sav".
rename variables (hivclust=v001)(hivnumb=v002)(hivline=v003).
sort cases by v001 v002 v003.
save outfile = datapath + "\temp.sav".

get file =  datapath + "\"+ irdata + ".sav".
sort cases by v001 v002 v003.

match files
/file= *
/table = datapath + "\temp.sav"
/by v001 v002 v003.

compute sex=2.
select if (not sysmis(HIV03)).
save outfile = datapath + "\IRARtemp.sav".

* merge AR file to MR file.
get file =  datapath + "\"+ ardata + ".sav".
rename variables (hivclust=mv001)(hivnumb=mv002)(hivline=mv003).
sort cases by mv001 mv002 mv003.
save outfile = datapath + "\temp.sav".

get file =  datapath + "\"+ mrdata + ".sav".
sort cases by mv001 mv002 mv003.

match files
/file= *
/table = datapath + "\temp.sav"
/by mv001 mv002 mv003.

compute sex=1.
select if (not sysmis(HIV03)).
save outfile = datapath + "\MRARtemp.sav".

* append IRARtemp and MRARtemp.
get file = datapath + "\MRARtemp.sav".
*IMPORTANT! we are renaming all mv* variables to v* variables. 
begin program.  
import spss, spssaux  
filteredvarlist=[v.VariableName for v in spssaux.VariableDict(pattern="^MV.*")]  
spss.Submit( "rename variables (%s=%s)." %  
    ("\n".join(filteredvarlist), "\n".join([v[1: ] for v in filteredvarlist]))  
)  
end program.

add files
/file= *
/file = datapath + "\IRARtemp.sav".

value labels sex 1 "man" 2 "woman".
save outfile = datapath + "\IRMRARmerge.sav".

*erase the temporary files. Comment out if you would like to keep these merged files. 
erase file =  datapath + "\IRARtemp.sav".
erase file =  datapath + "\MRARtemp.sav".
erase file =  datapath + "\temp.sav".

insert file = "HV_PREV_MR.sps".
*Purpose: 	Code for HIV prevalence.

insert file = "HV_CIRCUM.sps".
*Purpose:	Code for HIV prevalence by circumcision indicators.

insert file = "HV_backgroundvars.sps".
*Purpose:	Code the background variables needed for the HV_tables.

save outfile = datapath + "\IRMRARmerge.sav".

insert file = "HV_tables_MR.sps".
*Purpose: 	Produce tables for indicators computed from the above sps files.
* Note:		This will drop any women and men not in 15-49 age range. You can change this selection. Please check the notes in the do file.

*erase merged file. Comment out if you would like to keep this file
*erase IRMRARmerge.dta

*/
*******************************************************************************************************************************
*******************************************************************************************************************************

* CR file variables.

* merge CR and AR files.
get file =  datapath + "\"+ ardata + ".sav".
rename variables (hivclust=v001)(hivnumb=v002)(hivline=v003)(hiv03=w_hiv03).
sort cases by v001 v002 v003.
save outfile = datapath + "\w_temp.sav"/keep=v001 v002 v003 w_hiv03 w_hiv03.

get file =  datapath + "\"+ ardata + ".sav".
rename variables (hivclust=mv001)(hivnumb=mv002)(hivline=mv003)(hiv03=m_hiv03).
sort cases by mv001 mv002 mv003.
save outfile = datapath + "\m_temp.sav"/keep=mv001 mv002 mv003 m_hiv03 hiv05.

get file =  datapath + "\"+ crdata + ".sav".
sort cases by v001 v002 v003.
match files
/file= *
/table = datapath + "\w_temp.sav"
/by v001 v002 v003.
sort cases by mv001 mv002 mv003.
match files
/file= *
/table = datapath + "\m_temp.sav"
/by mv001 mv002 mv003.

select if (not sysmis(w_hiv03) and not sysmis (m_hiv03)).

insert file = "HV_PREV_CR.sps".
*Purpose: 	Code for HIV prevalence among couples

insert file = "HV_tables_CR.sps".
*Purpose: 	Produce tables for indicators computed from the above sps file".

* erase temporary files.
erase files = datapath + "\w_temp.sav".
erase files = datapath + "\m_temp.sav".


*******************************************************************************************************************************
*******************************************************************************************************************************
