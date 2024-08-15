* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HV_backgroundvars.sps
Purpose: 			compute the background variables needed for the HV_tables 
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: January 14 2020 by Ivana Bjelic

*****************************************************************************************************/

* computeerate background variable that are not standard variables in the date files.
* These variables are used for the tabulations of HIV prevalence in the final reports.

* employed in the last 12 months.
recode v731 (0=0) (1 thru 3=1) (8,9=sysmis) into empl.
variable labels empl "Employment in the past 12 months".
value labels empl 0 "Not employed" 1 "Employed".

*polygamy for women.
compute poly_w=$sysmis.
if v502<>1 poly_w=0.
if v502=1 & v505=0 poly_w=1.
if v502=1 & v505>0 poly_w=2.
variable labels poly_w "Type of union".
value labels poly_w 0"Not currently in union" 1 "In non-polygynous union" 2 "In polygynous union".

*polygamy for men.
compute poly_m=$sysmis.
if v502<>1 poly_m=0.
if v502=1 & v035=1 poly_m=1.
if v502=1 & v035>1 poly_m=2.
variable labels poly_m "Type of union".
value labels poly_m 0"Not currently in union" 1 "In non-polygynous union" 2 "In polygynous union".

*polygamy for total.
compute poly_t =1.
if v502<>1 poly_t=0.
if poly_w=2 & poly_m=2 poly_t=2.
variable labels poly_t "Type of union".
value labels poly_t 0"Not currently in union" 1 "In non-polygynous union" 2 "In polygynous union".

*Times slept away from home in the past 12 months.
recode v167 (0=0) (1,2=1) (3,4=2) (5 thru 90=3) (98,99=sysmis) into timeaway.
variable labels timeaway "Times slept away from home in past 12 months".
value labels timeaway 0 "None" 1 " 1-2" 2 " 3-4" 3 " 5+".

* Time away in the past 12 months for more than 1 month.
compute timeaway12m =$sysmis.
if v167>0 & v168=1 timeaway12m=1.
if v167>0 & v168=0 timeaway12m=2.
if v167=0 timeaway12m=3.
variable labels timeaway12m "Time away in the past 12 months".
value labels timeaway12m 1"Away for more than 1 month at a time" 2"Away only for less than 1 month at a time" 3"Not away".

*currently pregnant.
recode v213 (0 =0) (1,8=1) (9=sysmis) into preg.
variable labels preg "Currently pregnant".
value labels preg 0 "No" 1 "Yes".

* to check if survey has b19, which should be used instead to compute age. 
begin program.
import spss, spssaux
varList = "b19$01"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.
aggregate
  /outfile = * mode=addvariables
  /break=
  /b19$01_included=mean(b19$01).
recode b19$01_included (lo thru hi = 1)(else = 0).

***************************

* if b19 is present and not empty.
do if b19$01_included = 1.
    compute age = b19$01.
else.
** if b19 is not present, compute age.
*ANC for last birth in the past 3 years.
*need age of most recent child to limit to 3 years.
    compute age = v008 - b3$01.
end if.

if (m2n$1=1 or age>=36) ancplace = 0.
do repeat x=m57e$1 m57f$1 m57g$1 m57h$1 m57i$1 m57j$1 m57k$1 m57l$1.
+ if m14$1>0 and age<=36 and x=1 ancplace=1.
end repeat. 
do repeat x=m57a$1 m57b$1 m57c$1 m57d$1 m57m$1 m57n$1 m57o$1 m57p$1 m57q$1 m57r$1 m57s$1 m57t$1 m57u$1 m57v$1 m57x$1.
+ if m14$1>0 and age<=36 and x=1 ancplace=2.
end repeat.
recode ancplace (sysmis=0)(else=copy).
variable labels ancplace "ANC for last birth in past 3 years".	
value labels ancplace 0"No ANC/No birth in past 3 years" 1"ANC provided by public sector" 2"ANC provided by other than public sector".

*age at first sex.
do if v531>0.
+ recode v531 (1 thru 15=1) (16,17=2) (18,19=3) (20 thru 96=4) (97 thru 99=sysmis) into agesex.
end if.
variable labels agesex "Age at first sexual intercourse".
value labels agesex 1 " <16" 2  " 16-17" 3 " 18/19" 4  " 20+".

*Number of lifetime partners.
do if v531>0.
+recode v836 (1=1) (2=2) (3,4=3) (5 thru 9=4) (10 thru 95=5) (98,99=sysmis) into numprtnr.
end if.
variable labels numprtnr "Number of lifetime partners".
value labels numprtnr 1 " 1" 2 " 2" 3 " 3-4" 4  " 5-9" 5 " 10+".

*Multiple sexual partners in the past 12 months.
do if v531>0.
+if v766b=0 multisex=0.
+if (range(v527,100,251) | range(v527,300,311)) & v766b=1 multisex=1.
+if (range(v527,100,251) | range(v527,300,311)) & range(v766b,2,99) multisex=2.
end if.
variable labels multisex "Multiple sexual partners in past 12 months".
value labels multisex 0" 0" 1" 1" 2 " 2+".

*Non-marital, non-cohabiting partner in the past 12 months.
do if (v531>0).
+recode v766a (0=0) (1=1) (2 thru 95=2) (98,99=sysmis)  into prtnrcohab.
end if.
variable labels prtnrcohab "Non-marital, non-cohabiting partner in the past 12 months".
value labels prtnrcohab 0  " 0"  1 " 1" 2 " 2+".

*Condom use at last sexual intercourse in past 12 months.
do if (v531>0).
+if v766b=0 condomuse=0.
+if v761=0  condomuse=1.
+if v761=1  condomuse=2.
end if.
variable labels condomuse "Condom use at last sexual intercourse in the past 12 months".
value labels condomuse 0"No sex in past 12 months" 1"Did not use condom" 2"Used condom".

*Paid for sex in the past 12 months.
compute paidsex= v793.
if v793a=0 paidsex=2.
if sysmis(v793) | v531=0 paidsex=$sysmis.
variable labels paidsex "Paid for sexual intercourse in the past 12 months".
value labels paidsex 0"No" 1"Yes-Used condom" 2"Yes-Did not use condom".

*STI in the past 12 months.
do if v531>0.
+compute sti12m= (v763a=1 | v763b=1 | v763c=1).
end if.
variable labels sti12m "Had an STI or STI symptoms in the past 12 months".
value labels sti12m 0 "No" 1 "Yes".

*Had prior HIV test and whether they received results.
do if v531<>0.
+if v781=1 & v828=1 test_prior = 1.
+if v781=1 & v828=0 test_prior = 2.
+if v781=0 test_prior = 3.
end if.
variable labels test_prior "Prior HIV testing status and whether received test result".
value labels test_prior 1"Tested and received results" 2"Tested and did not receive results" 3"Never tested".

* new age variable among young. 
recode v012 (15 thru 17=1) (18,19=2) (20 thru 22=3) (23,24=4) (else=sysmis) into age_yng.
value labels age_yng 1 " 15-17" 2 " 18-19" 3 " 20-22" 4" 23-24".
