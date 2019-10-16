* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_USE.sps
Purpose: 			Code contraceptive use indicators (ever and current use). Also source of method, brands, and information given. 
 * Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: August 13 2019 by Ivana Bjelic 
*****************************************************************************************************/

 * /*----------------------------------------------------------------------------
Variables created in this file:
fp_evuse_any		"Ever used any contraceptive method"
fp_evuse_mod		"Ever used any modern method"
fp_evuse_fster		"Ever used female sterilization"
fp_evuse_mster		"Ever used male sterilization"
fp_evuse_pill		"Ever used pill"
fp_evuse_iud		"Ever used IUD"
fp_evuse_inj		                  "Ever used injectables"
fp_evuse_imp		"Ever used implants"
fp_evuse_mcond		"Ever used male condoms"
fp_evuse_fcond		"Ever used female condom"
fp_evuse_diaph		"Ever used diaphragm"
fp_evuse_lam		"Ever used LAM"
fp_evuse_ec			"Ever used emergency contraception"
fp_evuse_omod		"Ever used other modern method"
fp_evuse_trad		"Ever used any traditional method"
fp_evuse_rhy		"Ever used rhythm"
fp_evuse_wthd		"Ever used withdrawal"
fp_evuse_other		"Ever used other"

 * fp_cruse_any		"Currently use any contraceptive method"
fp_cruse_mod		"Currently use any modern method
fp_cruse_fster		"Currently use female sterilization"
fp_cruse_mster		"Currently use male sterilization"
fp_cruse_pill		"Currently use pill"
fp_cruse_iud		"Currently use IUD"
fp_cruse_inj		                  "Currently use injectables"
fp_cruse_imp		"Currently use implants"
fp_cruse_mcond		"Currently use male condoms"
fp_cruse_fcond		"Currently use female condom"
fp_cruse_diaph		"Currently use diaphragm"
fp_cruse_lam		"Currently use LAM"
fp_cruse_ec			"Currently use emergency contraception"
fp_cruse_omod		"Currently use other modern method"
fp_cruse_trad		"Currently use any traditional method"
fp_cruse_rhy		"Currently use rhythm"
fp_cruse_wthd		"Currently use withdrawal"
fp_cruse_other		"Currently use other"

* fp_ster_age		"Age at time of sterilization for women"
fp_ster_median		"Median age at time of sterilization for women"

 * fp_source_tot		"Source of contraception - total"
fp_source_fster		"Source for female sterilization"
fp_source_pill		"Source for pill"
fp_source_iud		"Source for IUD"
fp_source_inj		"Source for injectables"
fp_source_imp		"Source for implants"
fp_source_mcond		"Source for male condom"

 * fp_brand_pill		"Pill users using a social marketing brand"
fp_brand_cond		"Male condom users using a social marketing brand"

 * fp_info_sideff		"Informed about side effects or problems among female sterilization, pill, IUD, injectables, and implant users"
fp_info_what_to_do	                  "Informed of what to do if experienced side effects among female sterilization, pill, IUD, injectables, and implant users"
fp_info_other_meth	                  "Informed of other methods by health or FP worker among female sterilization, pill, IUD, injectables, and implant users"
fp_info_all 		                  "Informed of all three (method information index) among female sterilization, pill, IUD, injectables, and implant users"

----------------------------------------------------------------------------*/

*** Ever use of contraceptive methods ***
* many surveys have these variables in the data files but have no observations, i.e. the data were not collected in the survey.

*Ever use any method.
compute fp_evuse_any = 0.
if (v302>0 & v302<8) fp_evuse_any = 1.
variable labels fp_evuse_any "Ever used any contraceptive method".
value labels fp_evuse_any 0 "No" 1 "Yes".

*Ever use modern method.
compute fp_evuse_mod = 0.
if v302=3 fp_evuse_mod = 1.
variable labels fp_evuse_mod "Ever used any modern method".
value labels fp_evuse_mod 0 "No" 1 "Yes".

*Ever use female sterilization.  
compute fp_evuse_fster = 0.
if (v305$06>0 & v305$06<8) fp_evuse_fster = 1.
variable labels fp_evuse_fster "Ever used female sterilization".
value labels fp_evuse_fster 0 "No" 1 "Yes".

*Ever use male sterilization. 
compute fp_evuse_mster = 0.
if  (v305$07>0 & v305$07<8) fp_evuse_mster = 1.
variable labels fp_evuse_mster "Ever used male sterilization".
value labels fp_evuse_mster 0 "No" 1 "Yes".

*Ever use the contraceptive pill.
compute fp_evuse_pill = 0.
if (v305$01>0 & v305$01<8) fp_evuse_pill = 1.
variable labels fp_evuse_pill "Ever used pill".
value labels fp_evuse_pill 0 "No" 1 "Yes".

*Ever use Interuterine contraceptive device.
compute fp_evuse_iud = 0.
if (v305$02>0 & v305$02<8) fp_evuse_iud = 1.
variable labels fp_evuse_iud "Ever used IUD".
value labels fp_evuse_iud 0 "No" 1 "Yes".

*Ever use injectables (Depo-Provera).
compute fp_evuse_inj = 0.
if  (v305$03>0 & v305$03<8) fp_evuse_inj = 1.
variable labels fp_evuse_inj "Ever used injectables".
value labels fp_evuse_inj 0 "No" 1 "Yes".

*Ever use implants (Norplant).
compute fp_evuse_imp = 0.
if  (v305$11>0 & v305$11<8) fp_evuse_imp = 1.
variable labels fp_evuse_imp "Ever used implants".
value labels fp_evuse_imp 0 "No" 1 "Yes".

*Ever use male condom. 
compute  fp_evuse_mcond = 0.
if (v305$05>0 & v305$05<8) fp_evuse_mcond = 1.
variable labels fp_evuse_mcond "Ever used male condoms".
value labels fp_evuse_mcond 0 "No" 1 "Yes".

*Ever use female condom. 
compute fp_evuse_fcond = 0.
if  (v305$14>0 & v305$14<8) fp_evuse_fcond = 1.
variable labels fp_evuse_fcond "Ever used female condom".
value labels fp_evuse_fcond 0 "No" 1 "Yes".

*Ever use diaphragm.
compute fp_evuse_diaph = 0.
if  (v305$04>0 & v305$04<8) fp_evuse_diaph = 1.
variable labels fp_evuse_diaph "Ever used diaphragm".
value labels fp_evuse_diaph 0 "No" 1 "Yes".

*Ever use standard days method (SDM).
compute fp_evuse_sdm = 0.
if  (v305$18>0 & v305$18<8) fp_evuse_sdm = 1.
variable labels fp_evuse_sdm "Ever used standard days method".
value labels fp_evuse_sdm 0 "No" 1 "Yes".

*Ever use Lactational amenorrhea method (LAM).
compute fp_evuse_lam = 0.
if  (v305$13>0 & v305$13<8) fp_evuse_lam = 1.
variable labels fp_evuse_lam "Ever used LAM".
value labels fp_evuse_lam 0 "No" 1 "Yes".

*Ever use emergency contraception.
compute fp_evuse_ec = 0.
if (v305$16>0 & v305$16<8) fp_evuse_ec = 1.
variable labels fp_evuse_ec "Ever used emergency contraception".
value labels fp_evuse_ec 0 "No" 1 "Yes".

*Ever use country-specific modern methods and other modern contraceptive methods.
compute fp_evuse_omod = 0.
if (v305$17>0 & v305$17<8) fp_evuse_omod = 1.
variable labels fp_evuse_omod "Ever used other modern method".
value labels fp_evuse_omod 0 "No" 1 "Yes".

*Ever use periodic abstinence (rhythm, calendar method).
compute fp_evuse_rhy = 0.
if  (v305$08>0 & v305$08<8) fp_evuse_rhy = 1.
variable labels fp_evuse_rhy "Ever used rhythm method".
value labels fp_evuse_rhy 0 "No" 1 "Yes".

*Ever use withdrawal (coitus interruptus).
compute fp_evuse_wthd = 0.
if (v305$09>0 & v305$09<8) fp_evuse_wthd = 1.
variable labels fp_evuse_wthd "Ever used withdrawal method".
value labels fp_evuse_wthd 0 "No" 1 "Yes".

*Ever use country-specific traditional methods, and folk methods.
compute fp_evuse_other = 0.
if (v305$10>0 & v305$10<8) fp_evuse_other = 1.
variable labels fp_evuse_other "Ever used other method".
value labels fp_evuse_other 0 "No" 1 "Yes".

*Ever use any traditional.
compute fp_evuse_trad= 0.
if (fp_evuse_rhy=1 | fp_evuse_wthd=1 | fp_evuse_other=1) fp_evuse_trad = 1.
variable labels fp_evuse_trad "Ever used any traditional method".
value labels fp_evuse_trad 0 "No" 1 "Yes".

********************************************************************************/

*** Current use of contraceptive methods ***

*Currently use any method.
compute fp_cruse_any = 0.
if (v313>0 & v313<8) fp_cruse_any = 1.
variable labels fp_cruse_any "Currently used any contraceptive method".
value labels fp_cruse_any 0 "No" 1 "Yes".

*Currently use modern method.
compute fp_cruse_mod = 0.
if v313=3 fp_cruse_mod = 1.
variable labels fp_cruse_mod "Currently used any modern method".
value labels fp_cruse_mod 0 "No" 1 "Yes".

*Currently use female sterilization.
compute fp_cruse_fster  = 0.
if v312=6 fp_cruse_fster = 1.
variable labels fp_cruse_fster "Currently used female sterilization".
value labels fp_cruse_fster 0 "No" 1 "Yes".

*Currently use male sterilization.
compute fp_cruse_mster = 0.
if  v312=7 fp_cruse_mster = 1.
variable labels fp_cruse_mster "Currently used male sterilization".
value labels fp_cruse_mster 0 "No" 1 "Yes".

*Currently use the contraceptive pill.
compute fp_cruse_pill = 0.
if  v312=1 fp_cruse_pill = 1.
variable labels fp_cruse_pill "Currently used pill".
value labels fp_cruse_pill 0 "No" 1 "Yes".

*Currently use Interuterine contraceptive device.
compute fp_cruse_iud = 0.
if  v312=2 fp_cruse_iud = 1.
variable labels fp_cruse_iud "Currently used IUD".
value labels fp_cruse_iud 0 "No" 1 "Yes".

*Currently use injectables (Depo-Provera).
compute fp_cruse_inj = 0.
if v312=3 fp_cruse_inj = 1.
variable labels fp_cruse_inj "Currently used injectables".
value labels fp_cruse_inj 0 "No" 1 "Yes".

*Currently use implants (Norplant).
compute fp_cruse_imp = 0.
if v312=11 fp_cruse_imp = 1.
variable labels fp_cruse_imp "Currently used implants".
value labels fp_cruse_imp 0 "No" 1 "Yes".

*Currently use male condom.
compute fp_cruse_mcond = 0.
if  v312=5 fp_cruse_mcond = 1.
variable labels fp_cruse_mcond "Currently used male condoms".
value labels fp_cruse_mcond 0 "No" 1 "Yes".

*Currently use female condom.
compute fp_cruse_fcond = 0.
if  v312=14 fp_cruse_fcond = 1.
variable labels fp_cruse_fcond "Currently used female condom".
value labels fp_cruse_fcond 0 "No" 1 "Yes".

*Currently use diaphragm.
compute fp_cruse_diaph = 0.
if v312=4 fp_cruse_diaph = 1.
variable labels fp_cruse_diaph "Currently used diaphragm".
value labels fp_cruse_diaph 0 "No" 1 "Yes".

*Currently use standard days method (SDM).
compute  fp_cruse_sdm = 0.
if  v312=18 fp_cruse_sdm = 1.
variable labels fp_cruse_sdm "Currently used standard days method".
value labels fp_cruse_sdm 0 "No" 1 "Yes".

*Currently use Lactational amenorrhea method (LAM).
compute fp_cruse_lam = 0.
if v312=13 fp_cruse_lam = 1.
variable labels fp_cruse_lam "Currently used LAM".
value labels fp_cruse_lam 0 "No" 1 "Yes".

*Currently use emergency contraception.
compute fp_cruse_ec = 0.
if v312=16 fp_cruse_ec = 1.
variable labels fp_cruse_ec "Currently used emergency contraception".
value labels fp_cruse_ec 0 "No" 1 "Yes".

*Currently use country-specific modern methods and other modern contraceptive methods.
compute fp_cruse_omod = 0.
if v312=17 fp_cruse_omod = 1.
variable labels fp_cruse_omod "Currently used other modern method".
value labels fp_cruse_omod 0 "No" 1 "Yes".

*Currently use periodic abstinence (rhythm, calendar method).
compute fp_cruse_rhy = 0.
if v312=8 fp_cruse_rhy = 1.
variable labels fp_cruse_rhy "Currently used rhythm method".
value labels fp_cruse_rhy 0 "No" 1 "Yes".

*Currently use withdrawal (coitus interruptus).
compute fp_cruse_wthd = 0.
if v312=9 fp_cruse_wthd = 1.
variable labels fp_cruse_wthd "Currently used withdrawal method".
value labels fp_cruse_wthd 0 "No" 1 "Yes".

*Currently use country-specific traditional methods, and folk methods.
compute fp_cruse_other = 0.
if v312=10 fp_cruse_other = 1.
*folklore method.
if v312=35 fp_cruse_other=1. 
variable labels fp_cruse_other "Currently used other method".
value labels fp_cruse_other 0 "No" 1 "Yes".

*Currently use any traditional.
compute fp_cruse_trad = 0.
if (v313>0 & v313<3) fp_cruse_trad = 1.
variable labels fp_cruse_trad "Currently used any traditional method".
value labels fp_cruse_trad 0 "No" 1 "Yes".

********************************************************************************/

*Age at female sterilization.
do if v312=6.
+ compute fp_ster_age = v320.
end if.
apply dictionary from *
 /source variables = V320
 /target variables = fp_ster_age.
variable labels fp_ster_age "Age at time of sterilization for women".

*Median age at sterilization.
do if (v312=6 and v320<5).
compute ster_age = trunc((v317 - v011) / 12).
end if.

* Total.
** 50% percentile.
compute wt = v005/1000000.
weight by v005.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=
  /sp50=median(ster_age).
	
compute dummyL=$sysmis.
if v312=6 & v320<5 dummyL = 0.
if ster_age<sp50 & v312=6 & v320<5 dummyL = 1.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=
  /sL=mean(dummyL).
	
compute dummyU=$sysmis.
if v312=6 & v320<5 dummyU = 0.
if ster_age <=sp50 & v312=6 & v320<5 dummyU = 1.
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=
  /sU=mean(dummyU).

compute fp_ster_median=sp50+(0.5-sL)/(sU-sL).
variable labels fp_ster_median "Median age at time of sterilization for women".

weight off.
	
*** Source of Contraceptive method ***
** only for women that are using a moden method and do not use LAM

*Source for all.
compute fp_source_tot = v326.
apply dictionary from *
 /source variables = v326
 /target variables = fp_source_tot.
variable labels fp_source_tot "Source of contraception - total".

*Source for female sterilization users.
do if v312 = 6.
+ compute fp_source_fster = v326.
end if.
apply dictionary from *
 /source variables = v326
 /target variables = fp_source_fster.
variable labels fp_source_fster "Source for female sterilization".

*Source for pill users.
do if v312 = 1.
+ compute fp_source_pill = v326.
end if.
apply dictionary from *
 /source variables = v326
 /target variables = fp_source_pill.
variable labels fp_source_pill "Source for pill".

*Source for IUD users.
do if v312 = 2.
+ compute fp_source_iud = v326.
end if.
apply dictionary from *
 /source variables = v326
 /target variables =  fp_source_iud.
variable labels fp_source_iud "Source for IUD".

*Source for injectable users.
do if v312 = 3.
+ compute fp_source_inj = v326.
end if.
apply dictionary from *
 /source variables = v326
 /target variables = fp_source_inj.
variable labels fp_source_inj "Source for injectables".

*Source for implant users.
do if v312 = 11.
+ compute fp_source_imp = v326.
end if.
apply dictionary from *
 /source variables = v326
 /target variables = fp_source_imp.
variable labels fp_source_imp "Source for implants".

*Source for male condom users.
do if v312 = 5.
+ compute fp_source_mcond = v326.
end if.
apply dictionary from *
 /source variables = v326
 /target variables = fp_source_mcond.
variable labels fp_source_mcond "Source for male condom".
*******************************************************************************

*** Brands used for pill and condom ***

*Brand used for pill.
do if (v312 = 1 and v323 <> 98).
+ compute fp_brand_pill = v323.
end if.
apply dictionary from *
 /source variables = V323
 /target variables = fp_brand_pill.
variable labels fp_brand_pill "Pill users using a social marketing brand".

*Brand used for male condom.
do if (v312 = 5 and v323a <> 98).
+ compute fp_brand_cond = v323a.
end if.
apply dictionary from *
 /source variables = V323A
 /target variables = fp_brand_cond.
variable labels fp_brand_cond "Male condom users using a social marketing brand".

*******************************************************************************

*** Infomation given ***

*Informed of side effects.
do if (v312=1 or v312=2 or v312=3 or v312=6 or v312=11) & (v008-v317<60).
+ compute fp_info_sideff = 0.
+ if  (v3a02=1 | v3a03=1) fp_info_sideff = 1.
end if.
variable labels fp_info_sideff "Informed about side effects or problems among female sterilization, pill, IUD, injectables, and implant users".
value labels fp_info_sideff 0 "No" 1 "Yes".

*Informed of what to do.
do if (v312=1 or v312=2 or v312=3 or v312=6 or v312=11) & (v008-v317<60).
+ compute fp_info_what_to_do = 0.
+ if  v3a04=1 fp_info_what_to_do = 1.
end if.
variable labels fp_info_what_to_do "Informed of what to do if experienced side effects among female sterilization, pill, IUD, injectables, and implant users".
value labels fp_info_what_to_do 0 "No" 1 "Yes".

*Informed of other methods to use.
do if (v312=1 or v312=2 or v312=3 or v312=6 or v312=11) & (v008-v317<60).
+ compute fp_info_other_meth = 0.
+ if  (v3a05=1 | v3a06=1) fp_info_other_meth = 1.
end if.
variable labels fp_info_other_meth "Informed of other methods by health or FP worker among female sterilization, pill, IUD, injectables, and implant users".
value labels fp_info_other_meth 0 "No" 1 "Yes".

*Informed of all three (method information index).
do if (v312=1 or v312=2 or v312=3 or v312=6 or v312=11) & (v008-v317<60).
+ compute fp_info_all = 0.
+ if ((v3a02=1 | v3a03=1) & v3a04=1 & (v3a05=1 | v3a06=1)) fp_info_all = 1.
end if.
variable labels fp_info_all "Informed of all three (method information index) among female sterilization, pill, IUD, injectables, and implant users".
value labels fp_info_all 0 "No" 1 "Yes".
