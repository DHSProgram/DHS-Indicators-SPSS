* Encoding: windows-1252.
 * /*******************************************************************************************************************************
Program: 				MLmaster.sps
Purpose: 				Master file for the Malaria Chapter. 
 * 						The master file will call other do files that will produce the ML indicators and produce tables.
 * Data outputs:			coded variables and table output on screen and in excel tables.  
 * Author: 				Shireen Assaf and translated to SPSS by Ivana Bjelic	
Date last modified:		August 29, 2019 by Ivana Bjelic
*******************************************************************************************************************************/

*** User information for internal DHS use. Please disregard and adjust paths to your own. *** 

*local user 39585	//change employee id number to personalize path.
cd "C:/Users/33697/ICF/Analysis - Shared Resources/Code/DHS-Indicators-SPSS/Chap12_ML".
*.
define datapath()
    "C:/Users/33697/ICF/Analysis - Shared Resources/Data/DHSdata"
!enddefine.

* select your survey.
* HR Files.
define hrdata()
    "UGHR60FL"
!enddefine.
* GHHR7BFL.

* PR Files.
define prdata()
    "UGPR60FL"
!enddefine.

* IR Files.
define irdata()
    "UGIR60FL"
!enddefine.

* KR Files.
define krdata()
    "UGKR60FL"
!enddefine.


****************************
* do files that use the HR files.

* open dataset.
get file =  datapath + "\"+ hrdata + ".sav".

*.
insert file = "ML_NETS_HH.sps".
*Purpose: Code household net indicators.

insert file = "ML_tables_HR.sps".
* Purpose: will produce the tables for ML_NETS_HH.sps file indicators.

insert file = "ML_EXISTING_ITN.sps".
* Purpose: Code indicators for source of nets and produce tables for these indicators. 

insert file = "ML_NETS_source.sps".
*Purpose: code source of mosquito net.
*Note: This code reshaps the date file and produces the table for this indicator that is appended to Tables_HH_ITN.xls file produced by the ML_tables.sps file. 
*The data file would need to be reopened to code other variables at the household level. 
*/
*******************************************************************************************************************************
* do files that use the PR files

* open dataset.
get file =  datapath + "\"+ prdata + ".sav".

insert file = "ML_NETS_use.sps".
*Purpose:	Code net use in population. In the ML_tables do file, the indicators will be outputed for the 
* 			population, children under 5, and pregnant women.

insert file = "ML_BIOMARKERS.sps".
*Purpose: 	Code anemia and malaria testing prevalence in children under 5

insert file = "ML_tables_PR.sps".
* Purpose: 	Will produce the tables for indiators produced from the above two do files.

insert file = "ML_NETS_access.sps".
*Purpse: code population access to ITN.
*Note: This code will produce an HRPR file and will also produce the tables for these indicators.
*/
*******************************************************************************************************************************

* do files that use IR file variables

* open dataset.
get file =  datapath + "\"+ irdata + ".sav".

insert file = "ML_IPTP.sps".
*Purpose:	Code malaria IPTP indicators.

insert file = "ML_tables_IR.sps".
*Purpose: 	Will produce the tables for indiators produced from the above do file.

*/
*******************************************************************************************************************************

* do files that use KR file variables

* open dataset.
get file =  datapath + "\"+ krdata + ".sav".

insert file = "ML_FEVER.sps".
*Purpose:	Code indicators on fever, fever care-seeking, and antimalarial drugs

insert file = "ML_tables_KR.sps".
*Purpose: 	Will produce the tables for indiators produced from the above do file.


*******************************************************************************************************************************
*******************************************************************************************************************************
