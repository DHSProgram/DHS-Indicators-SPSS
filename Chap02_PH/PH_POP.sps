* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_POP.sps
Purpose: 			Code to compute population characteristics, birth registration, education levels, household composition, orphanhood, and living arrangments
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: July 24, 2020 by Ivana Bjelic
Note:				In line 244 the code will collapse the data and therefore some indicators produced will be lost
                                                                        However, they are saved in the file PR_temp_children.sps and this data file will be used to produce the tables for these indicators in the PH_table code
                                                                        This code will produce the Tables_hh_comps for household composition. 
*****************************************************************************************************.


*----------------------------------------------------------------------------
Variables created in this file:
*
ph_pop_age			"De facto population by five-year age groups"
ph_pop_depend		"De facto population by dependency age groups"
ph_pop_cld_adlt		"De facto population by child and adult populations"
ph_pop_adols		"De factor population that are adolesents"
*	
ph_birthreg_cert                	"Child under 5 with registered birth and birth certificate"
ph_birthreg_nocert            	"Child under 5 with registered birth and no birth certificate"
ph_birthreg			"Child under 5 with registered birth"
*
ph_highest_edu                               "Highest level of schooling attended or completed among those age 6 or over"
ph_median_eduyrs_wm                    "Median years of education among those age 6 or over - Females"
ph_median_eduyrs_mn                    "Median years of education among those age 6 or over - Males"
*
ph_wealth_quint		"Wealth quintile - dejure population"
*
ph_chld_liv_arrang            	"Living arrangement and parents survival status for child under 18"
ph_chld_liv_noprnt            	"Child under 18 not living with a biological parent"
ph_chld_orph		"Child under 18 with one or both parents dead"
*
ph_hhhead_sex		"Sex of household head"
ph_num_members		"Number of usual household members"
*	
ph_orph_double		"Double orphans under age 18"
ph_orph_single		"Single orphans under age 18"
ph_foster			"Foster children under age 18"
ph_orph_foster		"Orphans and/or foster children under age 18"
*----------------------------------------------------------------------------.

*** Population characteristics ***

if hv103=1 ager=trunc(hv105/5).

* Five year age groups.
recode ager (0=0) (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (11=11) (12=12) (13=13) (14=14) (15=15) (16 thru 18=16) (19 thru hi=98) into ph_pop_age.
if hv105=95 & hv103=1 ph_pop_age=16.
variable labels ph_pop_age "De facto population by five-year age groups".
value labels ph_pop_age
 0    " <5"
 1    " 5-9"
 2    " 10-14"
 3    " 15-19"
 4    " 20-24"
 5    " 25-29"
 6    " 30-34"
 7    " 35-39"
 8    " 40-44"
 9    " 45-49"
 10   " 50-54"
 11   " 55-59"
 12   " 60-64"
 13   " 65-69"
 14   " 70-74"
 15   " 75-79"
 16   " 80+"
 98   "Don't know/missing".

* Dependency age groups.
recode ager (0 thru 2=1) (3 thru 12=2) (13 thru 18=3) (19 thru hi=98) into ph_pop_depend.
if hv105=95 & hv103=1 ph_pop_depend=3.
variable labels ph_pop_depend "De facto population by dependency age groups".
value labels ph_pop_depend 1  " 0-14" 2  " 15-64" 3  " 65+" 98 "Don't know/missing".

* Child and adult populations.
do if hv103=1.
+recode hv105 (0 thru 17=1) (18 thru 97=2) (98 thru hi=98) into ph_pop_cld_adlt.
end if.
variable labels ph_pop_cld_adlt "De facto population by child and adult populations".
value labels ph_pop_cld_adlt 1  " 0-17" 2 " 18+"  98 "Don't know/missing".

* Adolescent population.
do if hv103=1.
recode hv105 (10 thru 19=1) (else=0) into ph_pop_adols.
end if.
variable labels ph_pop_adols "De facto population that are adolesents".
value labels ph_pop_adols 1  " Adolescents" 0 " Not adolesents".

*** Birth registration ***

* Child registered and with birth certificate.
do if hv102=1 & hv105<5.
+compute ph_birthreg_cert=0.
+if  hv140=1 ph_birthreg_cert=1.
end if.
variable labels ph_birthreg_cert "Child under 5 with registered birth and birth certificate".
value labels ph_birthreg_cert 0 "No" 1 "Yes".

* Child registered and with no birth certificate.
do if hv102=1 & hv105<5.
+compute  ph_birthreg_nocert=0.
+if  hv140=2 ph_birthreg_nocert=1.
end if.
variable labels ph_birthreg_nocert "Child under 5 with registered birth and no birth certificate".
value labels ph_birthreg_nocert 0 "No" 1 "Yes".

* Child is registered.
do if hv102=1 & hv105<5.
+compute ph_birthreg=0.
+if  any(hv140,1,2) ph_birthreg=1.
end if.
variable labels ph_birthreg "Child under 5 with registered birth".
value labels ph_birthreg 0 "No" 1 "Yes".

*** Wealth quintile ***

do if hv102=1.
+compute ph_wealth_quint = hv270.
end if.
variable labels ph_wealth_quint "Wealth quintile - dejure population".

*** Education levels ***

* Highest level of schooling attended or completed.
if hv103=1 & range(hv105,6,99) ph_highest_edu= hv109.
variable labels ph_highest_edu "Highest level of schooling attended or completed among those age 6 or over".
apply dictionary from *
 /source variables = hv109
 /target variables = ph_highest_edu
.

* Median years of education - Females.
if hv103=1 & range(hv105,6,99) & range(hv108,0,96) & hv104=2 eduyr=hv108.

* 50% percentile.
weight by hv005.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sp50=median(eduyr).
	
compute dummyL=$sysmis.
if hv103=1 & range(hv105,6,99) & range(hv108,0,96) & hv104=2 dummyL = 0.
if eduyr<sp50 dummyL = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sL=mean(dummyL).
	
compute dummyU=$sysmis.
if hv103=1 & range(hv105,6,99) & range(hv108,0,96) & hv104=2 dummyU = 0.
if eduyr<=sp50 dummyU = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sU=mean(dummyU).

compute ph_median_eduyrs_wm=sp50-1+(0.5-sL)/(sU-sL).
variable labels ph_median_eduyrs_wm "Median years of education among those age 6 or over - Females".

execute.
delete variables eduyr sp50 dummyL dummyU sL sU.
weight off.
	
* Median years of education - Males.
if hv103=1 & range(hv105,6,99) & range(hv108,0,96) & hv104=1 eduyr=hv108.

* 50% percentile.
weight by hv005.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sp50=median(eduyr).
	
compute dummyL=$sysmis.
if hv103=1 & range(hv105,6,99) & range(hv108,0,96) & hv104=1 dummyL = 0.
if eduyr<sp50 dummyL = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sL=mean(dummyL).
	
compute dummyU=$sysmis.
if hv103=1 & range(hv105,6,99) & range(hv108,0,96) & hv104=1 dummyU = 0.
if eduyr<=sp50 dummyU = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sU=mean(dummyU).

compute ph_median_eduyrs_mn=sp50-1+(0.5-sL)/(sU-sL).
variable labels ph_median_eduyrs_mn "Median years of education among those age 6 or over - Males".

execute.
delete variables eduyr sp50 dummyL dummyU sL sU.
weight off.

*** Living arrangments ***

* IMPORTANT: Children must be de jure residents AND coresidence with parents requires that
* the parents are also de jure residents.

* add a code 99 to hv112 if the mother is in the hh but is not de jure.
* add a code 99 to hv114 if the mother is in the hh but is not de jure.

* Preparing files to produce the indicators, this required several merges.

save outfile =  datapath + "\PR_temp.sav" /keep hv001 hv002 hvidx hv005 hv009 hv024 hv025 hv101 to hv105 hv111 to hv114 hv270 ph_pop_age to ph_median_eduyrs_mn.

* Prepare a file of potential mothers.
get file = datapath + "\PR_temp.sav".
select if not (hv104=1).
select if not (hv105<15).
compute in_mothers=1.
rename variables hv102 = hv102_mo.
execute.
delete variables hv112.
rename variables hvidx = hv112.
sort cases by hv001 hv002 hv112.
save outfile =  datapath + "\PR_temp_mothers.sav" /keep hv001 hv002 hv112 hv102_mo.

* Prepare a file of potential fathers.
get file = datapath + "\PR_temp.sav".
select if not (hv104=2).
select if not (hv105<15).
compute in_fathers=1.
rename variables hv102 = hv102_fa.
execute.
delete variables hv114.
rename variables hvidx = hv114.
sort cases by hv001 hv002 hv114.
save outfile =  datapath + "\PR_temp_fathers.sav"/keep hv001 hv002 hv114 hv102_fa.

* Prepare file of children for merges.
get file = datapath + "\PR_temp.sav".
select if not (hv102=0).
select if not (hv105>17).
compute in_children=1.

* Merge children with potential mothers.
sort cases by hv001 hv002 hv112.
match files
/file=*
/table = datapath + "\PR_temp_mothers.sav"
/by hv001 hv002 hv112.

* Merge children with potential fathers.
sort cases by hv001 hv002 hv114.
match files
/file=*
/table = datapath + "\PR_temp_fathers.sav"
/by hv001 hv002 hv114.

compute hv112r=hv112.
compute hv114r=hv114.

* Code 99 of the mother or father is not de jure.
if hv112>0 & hv102_mo=0 hv112r=99.
if hv114>0 & hv102_fa=0 hv114r=99.

select if in_children=1.
execute.
delete variables in_children.

value labels HV112R 0 "Mother not in household" 99 "In hh but not de jure".
value labels HV114R 0 "Father not in household" 99 "In hh but not de jure".

crosstabs hv112r by hv114r.

* Living arrangement for children under 18.
compute orphan_type=$sysmis.
if hv111=1 & hv113=1     orphan_type=1.
if hv111=1 & hv113=0     orphan_type=2.
if hv111=0 & hv113=1     orphan_type=3.
if hv111=0 & hv113=0     orphan_type=4.
if hv111>1 or hv113>1     orphan_type=5.

compute cores_type=$sysmis.
if (hv112r>0  & hv112r<99)  & (hv114r>0  & hv114r<99)     cores_type=1.
if (hv112r>0  & hv112r<99)  & (hv114r=0 or hv114r=99)     cores_type=2.
if (hv112r=0 or hv112r=99) & (hv114r>0  & hv114r<99)      cores_type=3.
if (hv112r=0 or hv112r=99) & (hv114r=0 or hv114r=99)       cores_type=4.

compute ph_chld_liv_arrang=$sysmis.
if cores_type=1                                                         ph_chld_liv_arrang=1.
if cores_type=2 & (orphan_type=1 or orphan_type=3)   ph_chld_liv_arrang=2.
if cores_type=2 & (orphan_type=2 or orphan_type=4)   ph_chld_liv_arrang=3.
if cores_type=3 & (orphan_type=1 or orphan_type=2)   ph_chld_liv_arrang=4.
if cores_type=3 & (orphan_type=3 or orphan_type=4)   ph_chld_liv_arrang=5.
if cores_type=4 & orphan_type=1                               ph_chld_liv_arrang=6.
if cores_type=4 & orphan_type=3                               ph_chld_liv_arrang=7.
if cores_type=4 & orphan_type=2                               ph_chld_liv_arrang=8.
if cores_type=4 & orphan_type=4                               ph_chld_liv_arrang=9.
if orphan_type=5                                                       ph_chld_liv_arrang=10.

value labels orphan_type 
    1 "Both parents alive" 
    2 "Mother alive, father dead" 
    3 "Father alive, mother dead" 
    4 "Both parents dead" 
    5 "Info missing".

value labels cores_type 
    1 "Living with both parents" 
    2 "With mother, not father" 
    3 "With father, not mother" 
    4 "Living with neither parent".

value labels ph_chld_liv_arrang 
    1 "With both parents" 
    2 "With mother only, father alive" 
    3 "With mother only, father dead" 
    4 "With father only, mother alive" 
    5 "With father only, mother dead" 
    6 "With neither, both alive" 
    7 "With neither, only father alive" 
    8 "With neither, only mother alive" 
    9 "With neither, both dead" 
    10 "Survival info missing".

variable labels ph_chld_liv_arrang	"Living arrangment and parents survival status for child under 18".

* Child under 18 not living with either parent.
compute ph_chld_liv_noprnt=0.
if ph_chld_liv_arrang>=6 & ph_chld_liv_arrang<=9 ph_chld_liv_noprnt=1.
variable labels ph_chld_liv_noprnt "Child under 18 not living with a biological parent".
value labels ph_chld_liv_noprnt 1 "yes" 0 "no".

* Child under 18 with one or both parents dead.
compute ph_chld_orph=0.
if hv111=0 or hv113=0 ph_chld_orph=1. 
variable labels ph_chld_orph "Child under 18 with one or both parents dead".
value labels ph_chld_orph 1 "yes" 0 "no".


*** Orphanhood ***

* Double orphan: both parents dead.
compute ph_orph_double=0.
if hv111=0 & hv113=0 ph_orph_double=1.

* Single orphan: one parent dead.
compute ph_orph_single=0.
if ph_chld_orph=1 & ph_orph_double=0 ph_orph_single=1.

* Foster child: not living with a parent but one or more parents alive.
compute ph_foster=0.
if cores_type=4 ph_foster=1.

* Foster child and/or orphan.
compute ph_orph_foster=0.
if ph_foster=1 or ph_orph_single=1 or ph_orph_double=1 ph_orph_foster=1. 

sort cases by hv001 hv002 hvidx.
save outfile = datapath + "\PR_temp_children.sav".

*** Household characteristics *** 
*  Warning, this code will collapse the data and therefore the indicators produced will be lost. However, they are saved in the file PR_temp2_children.sav.

get file = datapath + "\PR_temp.sav".
select if hv102=1.
sort cases by hv001 hv002 hvidx.
match files
/file=*
/table = datapath + "\PR_temp_children.sav"
/by hv001 hv002 hvidx.

* Household size.
compute n=1.
aggregate outfile=* mode=addvariables overwrite=yes
/break hv001 hv002
/hhsize=N(n)
/ph_orph_double=sum(ph_orph_double)
/ph_orph_single=sum(ph_orph_single)
/ph_foster=sum(ph_foster)
/ph_orph_foster=sum(ph_orph_foster).
compute  ph_num_members=hhsize.
if hhsize>9 ph_num_members=9. 

* Sort to be sure that the head of the household (with hv101=1) is the first person listed in the household.
sort cases by hv001 hv002 hv101.

* Reduce to one record per household, that of the hh head.
select if hv101=1.

variable labels ph_num_members "Number of usual members".
value labels ph_num_members 1"1" 2"2" 3"3" 4"4" 5"5" 6"6" 7"7" 8"8" 9"9+".

if ph_foster>1           ph_foster=1.
if ph_orph_foster>1   ph_orph_foster=1.
if ph_orph_single>1   ph_orph_single=1.
if ph_orph_double>1  ph_orph_double=1.

value labels ph_foster 1 "yes" 0 "no".
value labels ph_orph_foster 1 "yes" 0 "no".
value labels ph_orph_single 1 "yes" 0 "no".
value labels ph_orph_double 1 "yes" 0 "no".

variable labels ph_orph_foster "Orphans and/or foster children under age 18".
variable labels ph_foster "Foster children under age 18".
variable labels ph_orph_single "Single orphans under age 18".
variable labels ph_orph_double "Double orphans under age 18".

variable labels hv025 "type of place of residence".

* Sex of household head.
rename variables hv104 = ph_hhhead_sex.
variable labels ph_hhhead_sex "Sex of household head".

****************************************************

*** Table for household composition ***

compute wt = hv005/1000000.
weight by wt.

* Household headship.
* Number of usual members.
ctables
  /table  ph_hhhead_sex [c] [colpct.validn '' f5.1] + ph_num_members [c] [colpct.validn '' f5.1] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Household composition".		

*crosstabs 
    /tables = ph_hhhead_sex ph_num_members by hv025
    /format = avalue tables
    /cells = row 
    /count asis.

* Mean household size; use fweight.
weight off.
compute fweight=hv005.
weight by fweight.

ctables
  /table  hhsize [s] [mean '' f5.1] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mean household size".	

* descriptives variables hhsize /statistics = mean.
* compute filter = hv025=1.
* filter by filter.
* descriptives variables hhsize /statistics = mean.
* filter off.
* compute filter = hv025=2.
* filter by filter.
* descriptives variables hhsize /statistics = mean.
* filter off.


* Percentage of households with orphans and foster children under 18.
weight off.
compute wt = hv005/1000000.
weight by wt.

ctables
  /table  ph_orph_double [c] [colpct.validn '' f5.1] + ph_orph_single [c] [colpct.validn '' f5.1] + ph_foster [c] [colpct.validn '' f5.1] + ph_orph_foster [c] [colpct.validn '' f5.1]  by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Percentage of households with orphans and foster children under 18".		

*crosstabs 
    /tables = ph_orph_double ph_orph_single ph_foster ph_orph_foster by hv025
    /format = avalue tables
    /cells = row 
    /count asis.


****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_hh_comps.xls"
     operation=createfile.

output close * .

new file.

****************************************************

*erase unnessary temp files.
erase file =  datapath + "\PR_temp_fathers.sav".
erase file =  datapath + "\PR_temp_mothers.sav".
 