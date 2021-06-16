* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_KNOW_IR.sps
Purpose: 			Code contraceptive knowledge indicators
Data inputs: 		IR dataset
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

* indicators from IR file.

*Any method.
compute fp_know_any = (v301>0 & v301<8).
variable labels fp_know_any "Know any contraceptive method".
value labels  fp_know_any 0 "No" 1 "Yes".

*Modern method.
compute fp_know_mod = (v301=3).
variable labels fp_know_mod "Know any modern method".
value labels  fp_know_mod 0 "No" 1 "Yes".

*Female sterilization.
compute fp_know_fster = (v304$06>0 & v304$06<8).
variable labels fp_know_fster "Know female sterilization".
value labels fp_know_fster 0 "No" 1 "Yes".

*Male sterilization. 
compute fp_know_mster = (v304$07>0 & v304$07<8).
variable labels fp_know_mster "Know male sterilization".
value labels fp_know_mster 0 "No" 1 "Yes".

*The contraceptive pill.
compute fp_know_pill = (v304$01>0 & v304$01<8).
variable labels fp_know_pill "Know pill".
value labels fp_know_pill 0 "No" 1 "Yes".

*Interuterine contraceptive device.
compute fp_know_iud = (v304$02>0 & v304$02<8).
variable labels fp_know_iud "Know IUD".
value labels  fp_know_iud 0 "No" 1 "Yes".

*Injectables (Depo-Provera).
compute fp_know_inj = (v304$03>0 & v304$03<8).
variable labels fp_know_inj "Know injectables".
value labels fp_know_inj 0 "No" 1 "Yes".

*Implants (Norplant).
compute fp_know_imp = (v304$11>0 & v304$11<8).
variable labels fp_know_imp "Know implants".
value labels fp_know_imp 0 "No" 1 "Yes".

*Male condom.
compute fp_know_mcond = (v304$05>0 & v304$05<8).
variable labels fp_know_mcond "Know male condoms".
value labels fp_know_mcond 0 "No" 1 "Yes".

*Female condom.
compute fp_know_fcond = (v304$14>0 & v304$14<8).
variable labels fp_know_fcond "Know female condom".
value labels fp_know_fcond 0 "No" 1 "Yes".

*Emercomputecy contraception.
compute fp_know_ec = (v304$16>0 & v304$16<8).
variable labels fp_know_ec "Know emercomputecy contraception".
value labels fp_know_ec 0 "No" 1 "Yes".

*Standard days method (SDM).
compute fp_know_sdm = (v304$18>0 & v304$18<8).
variable labels fp_know_sdm "Know standard days method".
value labels fp_know_sdm 0 "No" 1 "Yes".

*Lactational amenorrhea method (LAM).
compute fp_know_lam = (v304$13>0 & v304$13<8).
variable labels fp_know_lam "Know LAM".
value labels fp_know_lam 0 "No" 1 "Yes".

*Country-specific modern methods and other modern contraceptive methods.
compute fp_know_omod = (v304$17>0 & v304$17<8).
variable labels fp_know_omod "Know other modern method".
value labels fp_know_omod 0 "No" 1 "Yes".

*Periodic abstinence (rhythm, calendar method).
compute fp_know_rhy = (v304$08>0 & v304$08<8).
variable labels fp_know_rhy "Know rhythm method".
value labels fp_know_rhy 0 "No" 1 "Yes".

*Withdrawal (coitus interruptus).
compute fp_know_wthd = (v304$09>0 & v304$09<8).
variable labels fp_know_wthd "Know withdrawal method".
value labels fp_know_wthd 0 "No" 1 "Yes".

*Country-specific traditional methods, and folk methods.
compute fp_know_other = (v304$10>0 & v304$10<8).
variable labels fp_know_other "Know other method".
value labels fp_know_other 0 "No" 1 "Yes".

*Any traditional.
compute fp_know_trad=0.
if (fp_know_rhy | fp_know_wthd=1 | fp_know_other=1) fp_know_trad=1.
variable labels fp_know_trad "Know any traditional method".
value labels fp_know_trad 0 "No" 1 "Yes".


*Mean methods known.
compute fp_know_sum	=	fp_know_fster + fp_know_mster + fp_know_pill + fp_know_iud + fp_know_inj + fp_know_imp + 
			fp_know_mcond + fp_know_fcond + fp_know_ec + fp_know_sdm + fp_know_lam + 
			fp_know_rhy + fp_know_wthd + fp_know_omod + fp_know_other.
				
compute wt = v005/1000000.
weight by wt.
aggregate /outfile =* mode = addvariables overwrite = yes /break= / fp_know_mean_all=mean(fp_know_sum).	
variable labels fp_know_mean_all "Mean number of methods known - all".

compute filter = v502 = 1.
filter by filter.
aggregate /outfile =* mode = addvariables overwrite = yes /break= / fp_know_mean_mar=mean(fp_know_sum).	
variable labels fp_know_mean_mar "Mean number of methods known - among currently married".
filter off.
weight off.

***Knowldge of fertile period ***.
recode v217 (4 = 1)(1 = 2)(2 = 3)(3 = 4)(6 = 5)(5 = 6)(8 = 8)(9 = 9) into fp_know_fert_all.
variable labels fp_know_fert_all "Knowledge of fertile period among all users".
value labels fp_know_fert_all 
1 "Just before her menstrual period begins" 
2 "During her menstrual period"
3 "Right after her menstrual period has ended"
4 "Halfway between two menstrual periods"
5 "Other"
6 "No specific time"
8 "Don't know"
9 "Missing".

do if v312=8.
+ recode v217 (4 = 1)(1 = 2)(2 = 3)(3 = 4)(6 = 5)(5 = 6)(8 = 8)(9 = 9) into fp_know_fert_rhy.
end if.
variable labels fp_know_fert_rhy "Knowledge of fertile period among rhythm method users".
value labels fp_know_fert_rhy 
1 "Just before her menstrual period begins" 
2 "During her menstrual period"
3 "Right after her menstrual period has ended"
4 "Halfway between two menstrual periods"
5 "Other"
6 "No specific time"
8 "Don't know"
9 "Missing".
	
do if  v312=18.
+ recode v217 (4 = 1)(1 = 2)(2 = 3)(3 = 4)(6 = 5)(5 = 6)(8 = 8)(9 = 9) into fp_know_fert_sdm.	
end if.
variable labels fp_know_fert_sdm "Knowledge of fertile period among standard days method users".
value labels fp_know_fert_sdm 
1 "Just before her menstrual period begins" 
2 "During her menstrual period"
3 "Right after her menstrual period has ended"
4 "Halfway between two menstrual periods"
5 "Other"
6 "No specific time"
8 "Don't know"
9 "Missing".
			
compute fp_know_fert_cor = (v217=3).
variable labels fp_know_fert_cor "Correct knowledge of fertile period".
value labels fp_know_fert_cor 0 "No" 1 "Yes".
