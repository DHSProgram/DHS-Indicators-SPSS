* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_Need.sps
Purpose: 			Code contraceptive unmet need, met need, demand satisfied, intention to use
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Aug 06 2019 by Ivana Bjelic
					March 17 2021 by Trevor Croft to update coding to match v626a when generating for older surveys, 
					  and allow for DHS-7 surveys in general code and add in some survey-specific code
*****************************************************************************************************/

 * /*----------------------------------------------------------------------------
fp_unmet_space			"Unmet need for spacing"
fp_unmet_limit			"Unmet need for limiting"
fp_unmet_tot			"Unmet need total"
fp_met_space			"Met need for spacing"
fp_met_limit   "Met need for limiting"
fp_met_tot				"Met need total"
fp_demand_space			"Total demand for spacing"
fp_demand_limit			"Total demand for limiting"
fp_demand_tot			"Total demand -total"
fp_demsat_mod			"Demand satisfied by modern methods"
fp_demsat_any			"Demand satisfied by any method"
fp_future_use			"Intention of use of contraception in the future among non-users"
----------------------------------------------------------------------------*/


* check if unmet need variable v626a is present.
* If variable doesnt exist, empty variable is created.
begin program.
import spss, spssaux
varList = "v626a"
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
  /v626a_included=mean(v626a).
recode v626a_included (lo thru hi = 1)(else = 0).


* survey specific code for surveys that do not have v626a.
do if (v626a_included=0).

compute v626a = $sysmis.
**Set unmet need to NA for unmarried women if survey only included ever-married women or only collected necessary data for married women.
* includes DHS II survey (v605 only asked to married women).
* Morocco 2003-04, Turkey 1998 (no sexual activity data for unmarried women).
* Cote D'Ivoire 1994, Haiti 1994-95 (v605 only asked to married women).
**Set unmet need to NA for unmarried women if survey only included ever-married women .
if (v502<>1 & v020=1) v626a=98.
* includes DHS II survey (v605 only asked to married women),
* Morocco 2003-04, Turkey 1998 (no sexual activity data for unmarried women),
* Cote D'Ivoire 1994, Haiti 1994-95 (v605 only asked to married women)
* India 2005-06 (v605 only asked to ever-married women), Nepal 2006 (v605 not asked to unmarried and "married, guana not performed" women).
if v502<>1 & (substr(v000,3,1)="2" | v000="MA4" | v000="TR2" | (v000="CI3" & v007=94) | v000="HT3" | v000="IA5" | v000="NP5")  v626a=98.

** CONTRACEPTIVE USERS - GROUP 1.
do if (sysmis(v626a) & v312<>0).
* using to space - all contraceptive users, except those below.
+ compute v626a=3.
* using to limit if wants no more, sterilized, or declared infecund.
+ if (v605>=5 & v605<=7) v626a=4.
end if.

**PREGNANT or POSTPARTUM AMENORRHEIC (PPA) WOMEN - GROUP 2.
* Determine who should be in Group 2.
* generate time since last birth.
compute tsinceb=v222.

* generate time since last period in months from v215.
if (v215>=100 & v215<=190) tsincep=trunc((v215-100)/30).
if (v215>=200 & v215<=290) tsincep=trunc((v215-200)/4.3).
if (v215>=300 & v215<=390) tsincep=(v215-300).
if (v215>=400 & v215<=490) tsincep=(v215-400)*12.
* initialize pregnant or postpartum amenorrheic (PPA) women.
compute pregPPA=0.
if (v213=1 | m6$1=96) pregPPA=1.
* For women with missing data or "period not returned" on date of last menstrual period, use information from time since last period.
do if (sysmis(m6$1) | m6$1=99 | m6$1=97).
*   if last period is before last birth in last 5 years.
+ if (not sysmis(tsinceb) & not sysmis(tsincep) & tsincep>tsinceb & tsinceb<60) pregPPA=1.
*   if said "before last birth" to time since last period in the last 5 years.
+ if (not sysmis(tsinceb) & v215=995 & tsinceb<60) pregPPA=1.
end if.

* select only women who are pregnant or PPA for <24 months.
compute pregPPA24=0.
if (v213=1 | (pregPPA=1 & not sysmis(tsinceb) & tsinceb<24)) pregPPA24=1.

* Classify wantedness of current pregnancy/last birth.
* current pregnancy.
compute wantedlast=v225.
* recode 'God's will' (survey-specific response) as not in need for Niger 1992.
if (v000="NI2" & wantedlast=4) wantedlast=1.
* last birth.
if ((sysmis(wantedlast) | wantedlast=9) & v213<>1) wantedlast = m10$1.
* recode 'not sure' and 'don't know' (country-specific responses) as unmet need for spacing for Cote D'Ivoire 1994 and Madagascar 1992.
recode wantedlast (4, 8 = 2).
* Unmet need status of pregnant women or women PPA for <24 months.
do if (sysmis(v626a) & pregPPA24=1).
* no unmet need if wanted current pregnancy/last birth then/at that time.
if (wantedlast=1) v626a = 7.
* unmet need for spacing if wanted current pregnancy/last birth later.
if (wantedlast=2) v626a = 1.  
* unmet need for limiting if wanted current pregnancy/last birth not at all.
if (wantedlast=3) v626a = 2.
* missing=missing.
if (sysmis(wantedlast) | wantedlast=9) v626a = 99.
end if.

**DETERMINE FECUNDITY - GROUP 3 (Boxes refer to Figure 2 flowchart in report).
compute infec=0.
**Boxes 1-4 only apply to women who are not pregnant and not PPA<24 months.
do if (sysmis(v626a) & v213<>1 & pregPPA24<>1).

**Box 1 - applicable only to currently married.
* married 5+ years ago, no children in past 5 years, never used contraception, excluding pregnant and PPA <24 months.
+ do if (v502=1 & not sysmis(v512) & v512>=5 & (sysmis(tsinceb) | tsinceb>59) & pregPPA24<>1).
+   if (v302 =0 ) infec=1 .
* in DHS VI, v302 replaced by v302a.
+   if (v302a=0 & (substr(v000,3,1)="6" | substr(v000,3,1)="7" | substr(v000,3,1)="8")) infec=1 .
* the following two line will generate error messages if the variable does not exist in the dataset you are using, but the error message can be ignored.
* survey-specific code for Cambodia 2010.
+   if (s313 =0 & v000="KH5" & (v007=2010 | v007=2011)) infec=1 .
* survey-specific code for Tanzania 2010.
+   if (s309b=0 & v000="TZ5" & (v007=2009 | v007=2010)) infec=1 .
+ end if.

**Box 2.
* declared infecund on future desires for children.
+ if (v605=7) infec=2.

**Box 3.
* menopausal/hysterectomy on reason not using contraception - slightly different recoding in DHS III and IV+.
* DHS IV+ surveys.
+ if (v3a08d=1 & (substr(v000,3,1)="4" | substr(v000,3,1)="5" | substr(v000,3,1)="6" | substr(v000,3,1)="7" | substr(v000,3,1)="8")) infec=3.
* DHSIII surveys.
+ if (v375a=23 & (substr(v000,3,1)="3" | substr(v000,3,1)="T")) infec=3.
* special code for hysterectomy for Brazil 1996, Guatemala 1995 and 1998-9  (code 23 = menopausal only).
+ if (v375a=28 & (v000="BR3" | v000="GU3")) infec=3.
* Reason not using did not exist in DHSII, use reason not intending to use in future.
+ if (v376=14 & substr(v000,3,1)="2") infec=3.

* below set of codes are all survey-specific replacements for reason not using contraception.
* the following lines will generate error messages if the variable does not exist in the dataset you are using, but the error message can be ignored.
* survey-specific code for Cote D'Ivoire 1994.
if (v000= "CI3" & v007=94 & v376=23) infec=3.
* survey-specific code for Gabon 2000.
if (v000= "GA3" & s607d=1) infec=3.
* survey-specific code for Haiti 1994/95.
if (v000= "HT3" & v376=23) infec=3.
* survey-specific code for Jordan 2002.
if (v000= "JO4" & (v376=23 | v376=24)) infec=3.
* survey-specific code for Kazakhstan 1999.
if (v000= "KK3" & v007=99 & s607d=1) infec=3.
* survey-specific code for Maldives 2009.
if (v000= "MV5" & v376=23) infec=3.
* survey-specific code for Mauritania 2000.
if (v000= "MR3" & s607c=1) infec=3.
* survey-specific code for Tanzania 1999.
if (v000= "TZ3" & v007=99 & s607d=1) infec=3.
* survey-specific code for Turkey 2003.
if (v000= "TR4" & v375a=23) infec=3.

**Box 4.
* Time since last period is >=6 months and not PPA.
+ if (not sysmis(tsincep) & tsincep>=6 & pregPPA<>1) infec=4.

**Box 5.
* menopause/hysterectomy on time since last period.
+ if (v215=994) infec=5.
* hysterectomy has different code for some surveys, but in 3 surveys it means "currently pregnant" - Yemen 1991, Turkey 1998, Uganda 1995).
+ if (v215=993 & v000 <> "TR3" & v000 <> "UG3" & v000 <> "YE2") infec=5.
* never menstruated on time since last period, unless had a birth in the last 5 years.
+ if (v215=996 & (sysmis(tsinceb) | tsinceb>59)) infec=5.

**Box 6.
* time since last birth>= 60 months and last period was before last birth.
+ if (v215=995 & not sysmis(tsinceb) & tsinceb>59) infec=6.
* never had a birth, but last period reported as before last birth - assume code should have been 994 or 996.
+ if (v215=995 & sysmis(tsinceb)) infec=6.

**INFECUND - GROUP 3.
+ if (infec>0 & sysmis(v626a)) v626a=9.

** End of code for women who are not pregnant and not PPA<24 months.
end if.

**NO NEED FOR UNMARRIED WOMEN WHO ARE NOT SEXUALLY ACTIVE.
* determine if sexually active in last 30 days.
compute sexact=0.
if (v528>=0 & v528<=30) sexact=1.
* older surveys used code 95 for sex in the last 4 weeks (Tanzania 1996).
if (v528=95) sexact=1.
* if unmarried and never had sex, assume no need.
if (sysmis(v626a) & v502<>1 & v525=0) v626a=0. 
* if unmarried and not sexually active in last 30 days, assume no need.
if (sysmis(v626a) & v502<>1 & sexact<>1) v626a=8. 

**FECUND WOMEN - GROUP 4.
do if sysmis(v626a).
* wants within 2 years.
+ if (v605=1) v626a=7.
* survey-specific code: treat 'up to god' (country-specific response) as not in need for India (different codes for 1992-3 and 1998-9).
+ if (v605=9 & v000="IA3") v626a=7.
+ if (v602=6 & v000="IA2") v626a=7.
* wants in 2+ years, wants undecided timing, or unsure if wants.
* survey-specific code for Lesotho 2009.
+ if (v000="LS5" & sysmis(v605)) v605=4.
+ if (v605>=2 & v605<=4) v626a=1.
* wants no more.
+ if (v605=5) v626a=2.
end if.

recode v626a (sysmis=99).

value labels v626a 
  0 "never had sex"
  1 "unmet need for spacing"
  2 "unmet need for limiting"
  3 "using for spacing"
  4 "using for limiting"
  7 "no unmet need"
  8 "not sexually active"
  9 "infecund or menopausal"
 98 "unmarried - EM sample or no data"
 99 "missing"
.

* end of creation of v626a.
end if.

* Recode the unmet need variable created above.	
	
*Unmet need spacing.
compute fp_unmet_space = (v626a=1).
variable labels fp_unmet_space "Unmet need for spacing".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Unmet need limiting.
compute fp_unmet_limit = (v626a=2).
variable labels fp_unmet_limit "Unmet need for limiting".
value labels fp_unmet_limit 0 "No" 1 "Yes".

*Unmet need total.
compute fp_unmet_tot = (v626a=1|v626a=2).
variable labels fp_unmet_tot "Unmet need total".
value labels fp_unmet_tot 0 "No" 1 "Yes".

*Met need spacing.
compute fp_met_space = v626a=3.
variable labels fp_met_space "Met need for spacing".
value labels fp_met_space 0 "No" 1 "Yes".

*Met need limiting.
compute fp_met_limit = v626a=4.
variable labels fp_met_limit "Met need for limiting".
value labels fp_met_limit 0 "No" 1 "Yes".

*Met need total.
compute fp_met_tot = (v626a=3|v626a=4).
variable labels fp_met_tot "Met need total".
value labels fp_met_tot 0 "No" 1 "Yes".

*Total demand for spacing.
compute fp_demand_space = (v626a=1|v626a=3).
variable labels fp_demand_space "Total demand for spacing".
value labels fp_demand_space 0 "No" 1 "Yes".

*Total demand for limiting.
compute fp_demand_limit = (v626a=2|v626a=4).
variable labels fp_demand_limit "Total demand for limiting".
value labels fp_demand_limit 0 "No" 1 "Yes".

*Total demand -total.
compute fp_demand_tot = range(v626a,1,4).
variable labels fp_demand_tot "Total demand for limiting - total".
value labels fp_demand_tot 0 "No" 1 "Yes".

*Demand satisfied by modern methods.
compute fp_demsat_mod = 0.
if (v626a=3 | v626a=4) & v313=3 fp_demsat_mod = 1.
*eliminate no need from denominator.
if not range(v626a,1,4) fp_demsat_mod = $sysmis.  
variable labels fp_demsat_mod "Demand satisfied by modern methods".
value labels fp_demsat_mod 0 "No" 1 "Yes".

*Demand satisfied by any methods.
compute fp_demsat_any=0.
if (v626a=3 | v626a=4)  fp_demsat_any = 1.
*eliminate no need from denominator.
if not range(v626a,1,4) fp_demsat_any = $sysmis.  
variable labels fp_demsat_any "Demand satisfied by any methods".
value labels fp_demsat_any 0 "No" 1 "Yes".


*Future intention to use.
do if (v502=1 and v312=0).
+compute fp_future_use = v362.
end if.
apply dictionary from *
 /source variables = v362
 /target variables = fp_future_use.
variable labels fp_future_use "Intention of use of contraception in the future among non-users".


