* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_KNOW_MR.sps
Purpose: 			Code contraceptive knowledge indicators
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Aug 15 2019 by Ivana Bjelic
*****************************************************************************************************/

 * /*----------------------------------------------------------------------------*
Variables created in this file:
fp_know_any		"Know any contraceptive method"
fp_know_mod		"Know any modern method"
fp_know_fster		"Know female sterilization"
fp_know_mster		"Know male sterilization"
fp_know_pill		                   "Know pill"
fp_know_iud			"Know IUD"
fp_know_inj			"Know injectables"
fp_know_imp		"Know implants"
fp_know_mcond		"Know male condoms"
fp_know_fcond		"Know female condom"
fp_know_ec			"Know emercomputecy contraception"
fp_know_sdm		"Know standard days method"
fp_know_lam		"Know LAM"
fp_know_omod		"Know other modern method"
fp_know_trad		"Know any traditional method"
fp_know_rhy		"Know rhythm method"
fp_know_wthd		"Know withdrawal method"
fp_know_other		"Know other method"
fp_know_mean_all            	"Mean number of methods known - all"
fp_know_mean_mar        	"Mean number of methods known - among currently married"
fp_know_fert_all                	"Knowledge of fertile period among all women"
fp_know_fert_rhy            	"Knowledge of fertile period among rhythm method users"
fp_know_fert_sdm            	"Knowledge of fertile period among standard days method users"
fp_know_fert_cor            	"Correct knowledge of fertile period"
/----------------------------------------------------------------------------*/

* indicators from MR file.

*Any method.
compute fp_know_any = (mv301>0 & mv301<8).
variable labels fp_know_any "Know any contraceptive method".
value labels  fp_know_any 0 "No" 1 "Yes".

*Modern method.
compute fp_know_mod = (mv301=3).
variable labels fp_know_mod "Know any modern method".
value labels  fp_know_mod 0 "No" 1 "Yes".

*Female sterilization.
compute fp_know_fster = (mv304$06>0 & mv304$06<8).
variable labels fp_know_fster "Know female sterilization".
value labels fp_know_fster 0 "No" 1 "Yes".

*Male sterilization. 
compute fp_know_mster = (mv304$07>0 & mv304$07<8).
variable labels fp_know_mster "Know male sterilization".
value labels fp_know_mster 0 "No" 1 "Yes".

*The contraceptive pill.
compute fp_know_pill = (mv304$01>0 & mv304$01<8).
variable labels fp_know_pill "Know pill".
value labels fp_know_pill 0 "No" 1 "Yes".

*Interuterine contraceptive device.
compute fp_know_iud = (mv304$02>0 & mv304$02<8).
variable labels fp_know_iud "Know IUD".
value labels  fp_know_iud 0 "No" 1 "Yes".

*Injectables (Depo-Provera).
compute fp_know_inj = (mv304$03>0 & mv304$03<8).
variable labels fp_know_inj "Know injectables".
value labels fp_know_inj 0 "No" 1 "Yes".

*Implants (Norplant).
compute fp_know_imp = (mv304$11>0 & mv304$11<8).
variable labels fp_know_imp "Know implants".
value labels fp_know_imp 0 "No" 1 "Yes".

*Male condom.
compute fp_know_mcond = (mv304$05>0 & mv304$05<8).
variable labels fp_know_mcond "Know male condoms".
value labels fp_know_mcond 0 "No" 1 "Yes".

*Female condom.
compute fp_know_fcond = (mv304$14>0 & mv304$14<8).
variable labels fp_know_fcond "Know female condom".
value labels fp_know_fcond 0 "No" 1 "Yes".

*Emercomputecy contraception.
compute fp_know_ec = (mv304$16>0 & mv304$16<8).
variable labels fp_know_ec "Know emercomputecy contraception".
value labels fp_know_ec 0 "No" 1 "Yes".

*Standard days method (SDM).
compute fp_know_sdm = (mv304$18>0 & mv304$18<8).
variable labels fp_know_sdm "Know standard days method".
value labels fp_know_sdm 0 "No" 1 "Yes".

*Lactational amenorrhea method (LAM).
compute fp_know_lam = (mv304$13>0 & mv304$13<8).
variable labels fp_know_lam "Know LAM".
value labels fp_know_lam 0 "No" 1 "Yes".

*Country-specific modern methods and other modern contraceptive methods.
compute fp_know_omod = (mv304$17>0 & mv304$17<8).
variable labels fp_know_omod "Know other modern method".
value labels fp_know_omod 0 "No" 1 "Yes".

*Periodic abstinence (rhythm, calendar method).
compute fp_know_rhy = (mv304$08>0 & mv304$08<8).
variable labels fp_know_rhy "Know rhythm method".
value labels fp_know_rhy 0 "No" 1 "Yes".

*Withdrawal (coitus interruptus).
compute fp_know_wthd = (mv304$09>0 & mv304$09<8).
variable labels fp_know_wthd "Know withdrawal method".
value labels fp_know_wthd 0 "No" 1 "Yes".

*Country-specific traditional methods, and folk methods.
compute fp_know_other = (mv304$10>0 & mv304$10<8).
variable labels fp_know_other "Know other method".
value labels fp_know_other 0 "No" 1 "Yes".

*Any traditional.
compute fp_know_trad=0.
if (fp_know_rhy | fp_know_wthd=1 | fp_know_other=1) fp_know_trad=1.
variable labels fp_know_trad "Know any traditional method".
value labels fp_know_trad 0 "No" 1 "Yes".

*Mean methods known.
compute fp_know_sum=fp_know_fster + fp_know_mster + fp_know_pill + fp_know_iud + fp_know_inj + fp_know_imp + 
		 fp_know_mcond + fp_know_fcond + fp_know_ec + fp_know_sdm + fp_know_lam + 
		 fp_know_rhy + fp_know_wthd + fp_know_omod + fp_know_other.
	
compute wt = mv005/1000000.
weight by wt.
aggregate /outfile =* mode = addvariables overwrite = yes /break= / fp_know_mean_all=mean(fp_know_sum).	
variable labels fp_know_mean_all "Mean number of methods known - all".

compute filter = mv502 = 1.
filter by filter.
aggregate /outfile =* mode = addvariables overwrite = yes /break= / fp_know_mean_mar=mean(fp_know_sum).	
variable labels fp_know_mean_mar "Mean number of methods known - among currently married".
filter off.
weight off.
