* Encoding: windows-1252.
*****************************************************************************************************
Program: 			ML_NETS_access.sps
Purpose: 			POPULATION ACCESS TO ITNS and POPULATION/CHILD/PREGNANT WOMEN USE OF ITNS AMONG HH WITH ITNs
Data inputs: 		HR and PR dataset
Data outputs:		coded variables and the tables Tables_ITN_access.xls and Tables_HH_ITN_USE.xls for the tabulations for the indicators
Author:				Cameron Taylor and modified by Shireen Assaf for the code share project, , translated to SPSS by Ivana Bjelic
Date last modified: August 31 2019 by Ivana Bjelic
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
ml_pop_access	"Population with access to an ITN"
ml_slept_itn_hhitn	"Slept under an ITN last night amound household population with at least 1 ITN"
----------------------------------------------------------------------------*
*** Percentage of the population with access to an ITN ***

*open HR file.
get file =  datapath + "\"+ hrdata + ".sav".

sort cases by hv001 hv002.

*Number of ITNs per household.
do repeat x = hml10$1 to hml10$7 / y = itnhh_01 to itnhh_07.
compute y = (x=1).
recode y (sysmis=0)(else=copy).
end repeat.
compute ml_numitnhh=itnhh_01 + itnhh_02 + itnhh_03 + itnhh_04 + itnhh_05 + itnhh_06 + itnhh_07.
variable labels ml_numitnhh "Number of ITNs per household".

save outfile "HRmerge.sav".

*Merge pr file hr file.
get file =  datapath + "\"+ prdata + ".sav".
sort cases by hv001 hv002.

match files 
/file = *
/table = "HRmerge.sav"
/by hv001 hv002.

*Households with > 1 ITN per 2 members.
*Potential users divided by defacto household members is greater or equal to one.
*Potential ITN users in Household.
compute ml_potuse = ml_numitnhh*2 .
variable labels ml_potuse "Potential ITN users in household".

*Population with access to an ITN.
do if hv013>0.
+compute ml_pop_access = ml_potuse/hv013.
+if ml_potuse/hv013 >1 ml_pop_access=1. 
end if.
variable labels ml_pop_access "Population with access to an ITN".

*******************************************************************************.
*Table for access
********************************************************************************.
compute wt=hv005/1000000.
weight by wt.
compute numdefacto=hv013.
variable labels numdefacto "Number of persons who stayed in the household the night before the survey".
add value labels numdefacto 8 "8+".
formats numdefacto ml_numitnhh (f1.0).
if hv013>8 numdefacto=8.

compute filter = (hv103=1).
filter by filter.

*Tabulation of number of ITNs by number of persons who stayed in the household the night before the survey.
*The last table shown is for 8+ number of person in the household.
ctables
  /table  ml_numitnhh [c]  by
         numdefacto [c] [colpct.validn '' f5.1] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Number of ITNs by number of persons who stayed in the household the night before the survey".			

*crosstabs 
    /tables = ml_numitnhh by numdefacto
    /format = avalue tables
    /cells = column
    /count asis.	

*Percent of population with access to an ITN by number of persons who stayed in the household the night before the survey.
*The last table shown is for 8+ number of person in the household.
*The percentage would be the mean shown in output times 100.
ctables
  /table  ml_pop_access [s][mean '' f5.3]  by
         numdefacto [c] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent of population with access to an ITN by number of persons who stayed in the household the night before the survey".			

*sort cases by numdefacto.
*split file layered by numdefacto.
*frequencies variables = ml_pop_access /statistics = mean / order = analysis.
*split file off.

*Percent of population with access to an ITN by background variables
*The percentage would be the mean shown in output times 100.
ctables
  /table  hv025 [c] + hv024 [c] +hv270 [c] by
        ml_pop_access [s][mean '' f5.3]          
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percent of population with access to an ITN by background variables".			

* sort cases by hv025.
* split file layered by hv025.
* frequencies variables = ml_pop_access /statistics = mean / order = analysis.
* split file off.
* sort cases by hv024.
* split file layered by hv024.
* frequencies variables = ml_pop_access /statistics = mean / order = analysis.
* split file off.
* sort cases by hv270.
* split file layered by hv270.
* frequencies variables = ml_pop_access /statistics = mean / order = analysis.
* split file off.


**********************************************************************************************
**********************************************************************************************

insert file = "ML_NETS_use.sps".

*Slept under an ITN last night among households with at least 1 ITN.
do if (hml10$1=1|hml10$2=1|hml10$3=1|hml10$4=1|hml10$5=1|hml10$6=1|hml10$7=1).
+compute ml_slept_itn_hhitn=0.
+if (ml_netcat=1) ml_slept_itn_hhitn=1.
end if.
variable labels ml_slept_itn_hhitn "Slept under an ITN last night among household population with at least 1 ITN".
value labels ml_slept_itn_hhitn 0 "No" 1 "Yes".

*Tables by background variables.
	

*** Overall Population ***.
* create denominators.
compute num=1.
variable labels num "Number".

*age of household memeber.
recode hv105 (0 thru 4=1) (5 thru 14=2) (15 thru 34=3) (35 thru 49=4) (98,99=9) (else=5) into age.
variable labels age "Age".
value labels age 1 "<5" 2 "5-14" 3 "15-34" 4 "35-49" 5 "50+" 9 "Don’t know/missing".

compute filter = (hv103=1).
filter by filter.

ctables
  /table  age [c]
         + hv104 [c] 
         + hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_slept_itn_hhitn [c] [rowpct.validn '' f5.1] + ml_slept_itn_hhitn [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Use of mosquito nets by persons in the household: overall population".			

*crosstabs 
    /tables = age hv104 hv025 hv024 hv270 by ml_slept_itn_hhitn 
    /format = avalue tables
    /cells = row 
    /count asis.


*** Children under 5 ***.
filter off.
compute filter = (hv103=1 & hml16<5).
filter by filter.

ctables
  /table  hv104 [c] 
         + hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_slept_itn_hhitn [c] [rowpct.validn '' f5.1] + ml_slept_itn_hhitn [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Use of mosquito nets by persons in the household: Children under 5".			

*crosstabs 
    /tables = age hv104 hv025 hv024 hv270 by ml_slept_itn_hhitn 
    /format = avalue tables
    /cells = row 
    /count asis.


*** Pregnant women age 15-49 ***.
filter off.
compute filter = (hv103=1 & hv104=2 & hml18=1 & hml16 >=15 & hml16<=49).
filter by filter.

ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_slept_itn_hhitn [c] [rowpct.validn '' f5.1] + ml_slept_itn_hhitn [s] [validn ,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Use of mosquito nets by persons in the household: Pregnant women age 15-49".			

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_slept_itn_hhitn 
    /format = avalue tables
    /cells = row 
    /count asis.


* output to excel.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_HH_ITN_USE.xls"
     operation=createfile.

output close *.

new file.

erase file = "HRmerge.sav".

****************************************************
