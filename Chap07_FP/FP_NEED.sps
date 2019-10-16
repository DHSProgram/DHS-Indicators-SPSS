* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_Need.sps
Purpose: 			Code contraceptive unmet need, met need, demand satisfied, intention to use
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Aug 06 2019 by Ivana Bjelic
*****************************************************************************************************/

 * /*----------------------------------------------------------------------------
fp_unmet_space			"Unmet need for spacing"
fp_unmet_limit			"Unmet need for limiting"
fp_unmet_tot			"Unmet need total"
fp_met_space			"Met need for spacing"
fp_met_limit		                    	"Met need for limiting"
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

*countries with v626a

do if v626a_included=1.

*Unmet need spacing.
compute fp_unmet_space = (v626a=1).
variable labels fp_unmet_space "Unmet need for spacing".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Unmet need limiting.
compute fp_unmet_limit = (v626a=2).
variable labels fp_unmet_limit "Unmet need for limiting".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Unmet need total.
compute fp_unmet_tot = (v626a=1 or v626a=2).
variable labels fp_unmet_tot "Unmet need total".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Met need spacing.
compute fp_met_space = (v626a=3).
variable labels fp_met_space "Met need for spacing".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Met need limiting.
compute fp_met_limit = (v626a=4).
variable labels fp_met_limit "Met need for limiting".
value labels fp_met_limit 0 "No" 1 "Yes".

*Met need total.
compute fp_met_tot = (v626a=3 or v626a=4).
variable labels fp_met_tot "Met need total".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Total demand for spacing.
compute fp_demand_space = (v626a=1 or v626a=3).
variable labels fp_demand_space "Total demand for spacing".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Total demand for limiting.
compute fp_demand_limit = (v626a=2 or v626a=4).
variable labels fp_demand_limit "Total demand for limiting".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Total demand -total.
compute fp_demand_tot = (v626a = 1 or v626a = 3 or v626a = 2 or v626a = 4).
variable labels fp_demand_tot "Total demand for limiting - total".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Demand satisfied by modern methods.
compute fp_demsat_mod = 0.
if (v626a=3 or v626a=4) & v313=3  fp_demsat_mod = 1.
*eliminate no need from denominator.
if (v626a = 0 or v626a = 7 or v626a = 8 or v626a = 9) fp_demsat_mod= $sysmis.
variable labels fp_demsat_mod "Demand satisfied by modern methods".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Demand satisfied by any methods.
compute fp_demsat_any=0.
if (v626a=3 or v626a=4)  fp_demsat_any=1.
*eliminate no need from denominator.
if (v626a = 0 or v626a = 7 or v626a = 8 or v626a = 9) fp_demsat_any= $sysmis.
variable labels fp_demsat_any "Demand satisfied by any methods".
value labels fp_unmet_space 0 "No" 1 "Yes".

end if.

* computeeral code for surveys that do not have v626a.
do if v626a_included=0 and (v000<>"BR31" and v000<>"KH61" and v000<>"CO61" and v000<>"CI35" and v000<>"GA41" and
		   v000<>"GU41" and v000<>"GU34" and v000<>"HT31" and v000<>"IA23" and v000<>"IA42" and
	                     v000<>"IA52" and v000<>"JO42" and v000<>"KK42" and v000<>"LS61" and v000<>"IA42" and
		   v000<>"MD21" and v000<>"MV52" and v000<>"MA43" and v000<>"NP51" and v000<>"NI22" and 
		   v000<>"TZ3A" and v000<>"TZ41" and v000<>"TZ63" and v000<>"TR31" and v000<>"TR41" and
		    v000<>"TR4A" and v000<>"UG33" and v000<>"YE21" ).
	
** CONTRACEPTIVE USERS - GROUP 1.
* using to limit if wants no more, sterilized, or declared infecund.
if v312<>0 & (v605>=5 & v605<=7) v626a = 4.
* using to space - all other contraceptive users.
if v312<>0 v626a = 3.

**PREGNANT or POSTPARTUM AMENORRHEIC (PPA) WOMEN - GROUP 2.
* Determine who should be in Group 2.
* compute time since last birth.
compute tsinceb=v008-b3$01.
* computeerate time since last period in months from v215.
if (v215>=100 & v215<=190) tsincep = trunc((v215-100)/30).
if (v215>=200 & v215<=290) tsincep = trunc((v215-200)/4.3).
if (v215>=300 & v215<=390) tsincep = (v215-300).
if (v215>=400 & v215<=490) tsincep = (v215-400)*12.	
	
* initialize pregnant or postpartum amenorrheic (PPA) women.
if (v213=1 or m6$1=96) pregPPA=1.
* For women with missing data or "period not returned" on date of last menstrual period, use information from time since last period.
* if last period is before last birth in last 5 years.
if (sysmis(m6$1) | m6$1=99 | m6$1=97) & tsincep> tsinceb & tsinceb<60 & not sysmis(tsincep) & not sysmis(tsinceb) pregPPA=1.
* or if said "before last birth" to time since last period in the last 5 years.
if (sysmis(m6$1) | m6$1=99 | m6$1=97) & v215=995 & tsinceb<60 & not sysmis(tsinceb) pregPPA=1.
* select only women who are pregnant or PPA for <24 months.
 if v213=1 | (pregPPA=1 & tsinceb<24) pregPPA24=1.

* Classify based on wantedness of current pregnancy/last birth.
* current pregnancy.
compute wantedlast=v225.
* last birth.
if (sysmis(wantedlast) | wantedlast=9) & v213<>1 wantedlast = m10$1.
* no unmet need if wanted current pregnancy/last birth then/at that time.
if pregPPA24=1 & wantedlast=1 v626a = 7.
* unmet need for spacing if wanted current pregnancy/last birth later.
if pregPPA24=1 & wantedlast=2 v626a = 1. 
* unmet need for limiting if wanted current pregnancy/last birth not at all.
if pregPPA24=1 & wantedlast=3 v626a = 2. 
* missing=missing.
if pregPPA24=1 & (sysmis(wantedlast) | wantedlast=9) v626a = 99. 

**NO NEED FOR UNMARRIED WOMEN WHO ARE NOT SEXUALLY ACTIVE.
* determine if sexually active in last 30 days.
if v528>=0 & v528<=30 sexact=1.
* if unmarried and not sexually active in last 30 days, assume no need.
if v502<>1 & sexact<>1 v626a =97.

**DETERMINE FECUNDITY - GROUP 3 (Boxes refer to Figure 2 flowchart in report).
**Box 1 - applicable only to currently married.
* married 5+ years ago, no children in past 5 years, never used contraception, excluding pregnant and PPA <24 months.
if v502=1 & v512>=5 & not sysmis(v512) & (tsinceb>59 | sysmis(tsinceb)) & v302=0  & pregPPA24<>1 infec=1.		
* in DHS VI, v302 replaced by v302a.
if v502=1 & v512>=5 & not sysmis(v512) & (tsinceb>59 | sysmis(tsinceb)) & v302a=0 & pregPPA24<>1 & substr(v000,3,1)="6" infec=1.
**Box 2.
* declared infecund on future desires for children.
 if v605=7 infec=1.
**Box 3.
* menopausal/hysterectomy on reason not using contraception - slightly different recoding in DHS III and IV+.
* DHS IV+ surveys.
 if v3a08d=1 & (substr(v000,3,1)="4" | substr(v000,3,1)="5" | substr(v000,3,1)="6")  infec=1.
* DHSIII surveys.
if  v375a=23 & (substr(v000,3,1)="3" | substr(v000,3,1)="T") infec=1.
* reason not using did not exist in DHSII, use reason not intending to use in future.
if  v376=14 & substr(v000,3,1)="2"  infec=1.
**Box 4.
* Time since last period is >=6 months and not PPA.
if tsincep>=6 & not sysmis(tsincep) & pregPPA<>1 infec=1.
**Box 5.
* menopausal/hysterectomy on time since last period.
if v215=994 infec=1.
* never menstruated on time since last period, unless had a birth in the last 5 years.
if v215=996 & (tsinceb>59 | sysmis(tsinceb)) infec=1.
if  v000= "GA3" & s607d=1 infec=1.
**Box 6.
* time since last birth>= 60 months and last period was before last birth.
if v215=995 & tsinceb>=60 & sysmis(tsinceb) infec=1.
* never had a birth, but last period reported as before last birth - assume code should have been 994 or 996.
if v215=995 & sysmis(tsinceb) infec=1.
* exclude pregnant and PP amenorrheic < 24 months.
if pregPPA24=1 infec = $sysmis.
if infec=1 v626a = 9. 

**FECUND WOMEN - GROUP 4.
* wants within 2 years.
if v605=1 v626a = 7. 
* wants in 2+ years, wants undecided timing, or unsure if wants.
if v605>=2 & v605<=4 v626a = 1.
* wants no more.
if v605=5 v626a = 2. 
recode v626a (sysmis = 99).
value labels v626a 
1 "unmet need for spacing" 
2 "unmet need for limiting" 
3 "using for spacing" 
4 "using for limiting" 
7 "no unmet need" 
9 "infecund or menopausal" 
97 "not sexually active" 
98 "unmarried - EM sample or no data" 
99 "missing"
.

* Recode the unmet need variable created above.	
	
*Unmet need spacing.
compute fp_unmet_space = (v626a=1).
variable labels fp_unmet_space "Unmet need for spacing".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Unmet need limiting.
compute fp_unmet_limit = (v626a=2).
variable labels fp_unmet_limit "Unmet need for limiting".
value labels fp_unmet_space 0 "No" 1 "Yes".

*Unmet need total.
compute fp_unmet_tot = (v626a=1|v626a=2).
variable labels fp_unmet_tot "Unmet need total".
value labels fp_unmet_tot 0 "No" 1 "Yes".

*Met need spacing.
compute fp_met_space = (v626a=3).
variable labels fp_met_space "Met need for spacing".
value labels fp_met_space 0 "No" 1 "Yes".

*Met need limiting.
compute fp_met_limit = (v626a=4).
variable labels fp_unmet_limit "Met need for limiting".
value labels fp_unmet_limit 0 "No" 1 "Yes".

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
compute fp_demand_tot = range(v626a,1,3,2,4).
variable labels fp_demand_tot "Total demand for limiting - total".
value labels fp_demand_tot 0 "No" 1 "Yes".

*Demand satisfied by modern methods.
compute fp_demsat_mod = 0.
if (v626a=3 | v626a=4) & v313=3 fp_demsat_mod = 1.
*eliminate no need from denominator.
if v626a>4 fp_demsat_mod = $sysmis.  
variable labels fp_demsat_mod "Demand satisfied by modern methods".
value labels fp_demsat_mod 0 "No" 1 "Yes".

*Demand satisfied by any methods.
compute fp_demsat_any=0.
if (v626a=3 | v626a=4)  fp_demsat_any = 1.
*eliminate no need from denominator.
if v626a>4 fp_demsat_any = $sysmis.  
variable labels fp_demsat_any "Demand satisfied by any methods".
value labels fp_demsat_any 0 "No" 1 "Yes".

end if.

* survey specific code for surveys that do not have v626a.
do if v626a_included=0 & (v000="BR31" | v000="KH61" | v000="CO61" | v000="CI35" | v000="GA41" | 
		   v000="GU41" | v000="GU34" | v000="HT31" | v000="IA23" | v000="IA42" | 
	                     v000="IA52" | v000="JO42" | v000="KK42" | v000="LS61" | v000="IA42" | 
		   v000="MD21" | v000="MV52" | v000="MA43" | v000="NP51" | v000="NI22" | 
		   v000="TZ3A" | v000="TZ41" | v000="TZ63" | v000="TR31" | v000="TR41" | 
		    v000="TR4A" | v000="UG33" | v000="YE21" ).

**Set unmet need to NA for unmarried women if survey only included ever-married women or only collected necessary data for married women.
* includes DHS II survey (v605 only asked to married women).
* Morocco 2003-04, Turkey 1998 (no sexual activity data for unmarried women).
* Cote D'Ivoire 1994, Haiti 1994-95 (v605 only asked to married women).
* India 2005-06 (v605 only asked to ever-married women), Nepal 2006 (v605 not asked to unmarried and "married, guana not performed" women).
if v502<>1 & (v020=1 | substr(v000,3,1)="2" | v000="MA4" | v000="TR2" | (v000="CI3" & v007=94) | v000="HT3" | v000="IA5" | v000="NP5")  v626a=98.

** CONTRACEPTIVE USERS - GROUP 1.
* using to limit if wants no more, sterilized, or declared infecund.
if v312<>0 & (v605>=5 & v605<=7) v626a = 4.
* using to space - all other contraceptive users.
if v312<>0 v626a = 3. 

**PREGNANT or POSTPARTUM AMENORRHEIC (PPA) WOMEN - GROUP 2.
* Determine who should be in Group 2.
* computeerate time since last birth.
compute tsinceb=v008-b3$01.
* computeerate time since last period in months from v215.
if (v215>=100 & v215<=190) tsincep = trunc((v215-100)/30).
if (v215>=200 & v215<=290) tsincep = trunc((v215-200)/4.3).
if (v215>=300 & v215<=390) tsincep = (v215-300).	
if (v215>=400 & v215<=490) tsincep = (v215-400)*12.	
* initialize pregnant or postpartum amenorrheic (PPA) women.
if v213=1 | m6$1=96 pregPPA=1.
* For women with missing data or "period not returned" on date of last menstrual period, use information from time since last period.
* if last period is before last birth in last 5 years.
if (sysmis(m6$1) | m6$1=99 | m6$1=97) & tsincep>tsinceb & tsinceb<60 & not sysmis(tsincep) & not sysmis(tsinceb) pregPPA=1.
* or if said "before last birth" to time since last period in the last 5 years.
if (sysmis(m6$1) | m6$1=99 | m6$1=97) & v215=995 & tsinceb<60 & not sysmis (tsinceb) pregPPA=1.
* select only women who are pregnant or PPA for <24 months.
if v213=1 | (pregPPA=1 & tsinceb<24) pregPPA24=1.

* Classify based on wantedness of current pregnancy/last birth.
* current pregnancy.
compute wantedlast = v225.
* last birth.
if (sysmis(wantedlast) | wantedlast=9) & v213<>1 wantedlast = m10$1.
* recode 'not sure' and 'don't know' (survey-specific responses) as unmet need for spacing for Cote D'Ivoire 1994 and Madagascar 1992.
recode wantedlast (4, 8 = 2).
* no unmet need if wanted current pregnancy/last birth then/at that time.
if pregPPA24=1 & wantedlast=1 v626a = 7.
* unmet need for spacing if wanted current pregnancy/last birth later.
if pregPPA24=1 & wantedlast=2 v626a = 1.  
* unmet need for limiting if wanted current pregnancy/last birth not at all.
if pregPPA24=1 & wantedlast=3 v626a = 2.
* missing=missing.
if pregPPA24=1 & (sysmis(wantedlast) | wantedlast=9) v626a = 99.

**NO NEED FOR UNMARRIED WOMEN WHO ARE NOT SEXUALLY ACTIVE.
* determine if sexually active in last 30 days.
if v528>=0 & v528<=30 sexact = 1.
* older surveys used code 95 for sex in the last 4 weeks (Tanzania 1996).
if v528=95 sexact = 1. 
* if unmarried and not sexually active in last 30 days, assume no need.
if v502<>1 & sexact<>1 v626a = 97. 

**DETERMINE FECUNDITY - GROUP 3 (Boxes refer to Figure 2 flowchart in report).
**Box 1 - applicable only to currently married.
* married 5+ years ago, no children in past 5 years, never used contraception, excluding pregnant and PPA <24 months.
if v502=1 & v512>=5 & not sysmis(v512) & (tsinceb>59 | sysmis(tsinceb)) & v302=0  & pregPPA24<>1 infec=1.	
* in DHS VI, v302 replaced by v302a.
if v502=1 & v512>=5 & not sysmis(v512) & (tsinceb>59 | sysmis(tsinceb)) & v302a=0 & pregPPA24<>1 & substr(v000,3,1)="6" infec=1.
* survey-specific code for Cambodia 2010.
if v502=1 & v512>=5 & not sysmis(v512) & (tsinceb>59 | sysmis(tsinceb)) & s313=0  & pregPPA24<>1 & v000="KH5" & (v007=2010 | v007=2011) infec=1.
* survey-specific code for Tanzania 2010.
if v502=1 & v512>=5 & not sysmis(v512) & (tsinceb>59 | sysmis(tsinceb)) & s309b=0 & pregPPA24<>1 & v000="TZ5" & (v007=2009 | v007=2010) infec=1.
**Box 2.
* declared infecund on future desires for children.
 if v605=7 infec=1.
**Box 3.
* menopausal/hysterectomy on reason not using contraception - slightly different recoding in DHS III and IV+.
* DHS IV+ surveys.
if v3a08d=1 & (substr(v000,3,1)="4" | substr(v000,3,1)="5" | substr(v000,3,1)="6") infec=1.
* DHSIII surveys.
if  v375a=23 & (substr(v000,3,1)="3" | substr(v000,3,1)="T") infec=1.
* special code for hysterectomy for Brazil 1996, Guatemala 1995 and 1998-9  (code 23 = menopausal only).
if  v375a=28 & (v000="BR3" | v000="GU3") infec=1.
* reason not using did not exist in DHSII, use reason not intending to use in future.
if  v376=14 & substr(v000,3,1)="2" infec=1.
* below set of codes are all survey-specific replacements for reason not using contraception.
* survey-specific code for Cote D'Ivoire 1994.
if  v000= "CI3" & v007=94 & v376=23 infec=1.
* survey-specific code for Gabon 2000.
if   v000= "GA3" & s607d=1 infec=1.
**Box 4.
* Time since last period is >=6 months and not PPA.
if tsincep>=6 & not sysmis(tsincep) & pregPPA<>1 infec=1.
**Box 5.
* menopausal/hysterectomy on time since last period.
if v215=994 infec=1.
* hysterectomy has different code for some surveys, but in 3 surveys it means "currently pregnant" - Yemen 1991, Turkey 1998, Uganda 1995).
if v215=993 & v000<>"TR3" & v000<>"UG3" & v000<>"YE2" infec=1.
* never menstruated on time since last period, unless had a birth in the last 5 years.
if v215=996 & (tsinceb>59 | sysmis(tsinceb)) infec=1. 
**Box 6.
*time since last birth>= 60 months and last period was before last birth.
if v215=995 & tsinceb>=60 & not sysmis(tsinceb) infec=1.
* Never had a birth, but last period reported as before last birth - assume code should have been 994 or 996.
if v215=995 & sysmis(tsinceb) infec=1.
* exclude pregnant and PP amenorrheic < 24 months.
if pregPPA24=1 infec=$sysmis.
if infec=1 v626a =9. 

**FECUND WOMEN - GROUP 4.
* wants within 2 years.
if v605=1 v626a = 7. 
* wants in 2+ years, wants undecided timing, or unsure if wants.
* survey-specific code for Lesotho 2009.
if v000="LS5" v605 = 4. 
if v605>=2 & v605<=4 v626a = 1. 
* wants no more.
if v605=5 v626a = 2. 
recode v626a (sysmis = 99).
value labels v626a 
1 "unmet need for spacing" 
2 "unmet need for limiting" 
3 "using for spacing" 
4 "using for limiting" 
7 "no unmet need" 
9 "infecund or menopausal" 
97 "not sexually active" 
98 "unmarried - EM sample or no data" 
99 "missing"
.
	
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
compute fp_demand_tot = range(v626a,1,3,2,4).
variable labels fp_demand_tot "Total demand for limiting - total".
value labels fp_demand_tot 0 "No" 1 "Yes".

*Demand satisfied by modern methods.
compute fp_demsat_mod = 0.
if (v626a=3 | v626a=4) & v313=3 fp_demsat_mod = 1.
*eliminate no need from denominator.
if v626a>4 fp_demsat_mod = $sysmis.  
variable labels fp_demsat_mod "Demand satisfied by modern methods".
value labels fp_demsat_mod 0 "No" 1 "Yes".

*Demand satisfied by any methods.
compute fp_demsat_any=0.
if (v626a=3 | v626a=4)  fp_demsat_any = 1.
*eliminate no need from denominator.
if v626a>4 fp_demsat_any = $sysmis.  
variable labels fp_demsat_any "Demand satisfied by any methods".
value labels fp_demsat_any 0 "No" 1 "Yes".

end if.

*Future intention to use.
do if (v502=1 and v312=0).
+compute fp_future_use = v362.
end if.
apply dictionary from *
 /source variables = v362
 /target variables = fp_future_use.
variable labels fp_future_use "Intention of use of contraception in the future among non-users".
