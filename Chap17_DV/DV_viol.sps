* Encoding: UTF-8.
* Encoding: .
*****************************************************************************************************
Program: 			DV_viol.sps
Purpose: 			Code domestic violence indicators from the IR file
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified: September 29 2020
*****************************************************************************************************/

*______________________________________________________________________________
Variables created in this file:

*EXPERIENCE OF PHYSICAL, SEXUAL, EMOTIONAL VIOLENCE
	dv_phy			"Experienced physical violence since age 15"
	dv_phy_12m		"Experienced physical violence in the past 12 months"
	dv_phy_preg		"Experienced physical violence during pregnancy"
	dv_sex			"Ever experienced sexual violence"
	dv_sex_12m		"Experienced sexual violence in the past 12 months"
	dv_sex_age			"Specific age experienced sexual violence"
	dv_phy_only			"Experienced physical violence only"
	dv_sex_only			"Experienced sexual violence only"
	dv_phy_sex_all		"Experienced physical and sexual violence"
	dv_phy_sex_any		"Experienced physical or sexual violence"
	dv_viol_type		                  "Experienced physical only, sexual only, or both"

*PERSONS COMMITTING PHYSICAL OR SEXUAL VIOLENCE
	dv_phy_hus_curr		"Person committing physical violence: current husband/partner"
	dv_phy_hus_form		"Person committing physical violence: former husband/partner"
	dv_phy_bf_curr		"Person committing physical violence: current boyfriend"
	dv_phy_bf_form		"Person committing physical violence: former boyfriend"
	dv_phy_father		"Person committing physical violence: father/step-father"
	dv_phy_mother		"Person committing physical violence: mother/step-mother"
	dv_phy_sibling		"Person committing physical violence: sister or bother"
	dv_phy_bychild		"Person committing physical violence: daughter/son"
	dv_phy_other_rel	                  "Person committing physical violence: other relative"
	dv_phy_mother_inlaw	                  "Person committing physical violence: mother-in-law"
	dv_phy_father_inlaw	                  "Person committing physical violence: father-in-law"
	dv_phy_other_inlaw	                  "Person committing physical violence: other-in-law"
	dv_phy_teacher		"Person committing physical violence: teacher"
	dv_phy_atwork		"Person committing physical violence: employer/someone at work"
	dv_phy_police		"Person committing physical violence: police/soldier"
	dv_phy_other		"Person committing physical violence: other"
*	
	dv_sex_hus_curr		"Person committing sexual violence: current husband/partner"
	dv_sex_hus_form		"Person committing sexual violence: former husband/partner"
	dv_sex_bf			"Person committing sexual violence: current/former boyfriend"
	dv_sex_father		"Person committing sexual violence: father/step-father"
	dv_sex_brother		"Person committing sexual violence: brother/step-brother"
	dv_sex_other_rel             	"Person committing sexual violence: other relative"
	dv_sex_inlaw		"Person committing sexual violence: in-law"
	dv_sex_friend		"Person committing sexual violence: friend/acquaintance"
	dv_sex_friend_fam          	"Person committing sexual violence: family friend"
	dv_sex_teacher		"Person committing sexual violence: teacher"
	dv_sex_atwork		"Person committing sexual violence: employer/someone at work"
	dv_sex_relig	                  	"Person committing sexual violence: priest or religious leader"
	dv_sex_police		"Person committing sexual violence: police/soldier"
	dv_sex_stranger		"Person committing sexual violence: stranger"
	dv_sex_other		"Person committing sexual violence: other"
	dv_sex_missing		"Person committing sexual violence: missing"			??????????different from line 20 above?

*SEEKING HELP AFTER VIOLENCE	
	dv_help_seek		"Help-seeking behavior of women who ever experienced physical or sexual violence"
	dv_help_phy			"Sources of help sought for physical violence among women who sought help"
	dv_help_sex			"Sources of help sought for sexual violence among women who sought help"
	dv_help_phy_sex_all             	"Sources of help sought for physical and sexual violence among women who sought help"
	dv_help_phy_sex_any            	"Sources of help sought for physical or sexual violence among women who sought help"
	
*	
	dv_help_fam                                    "Source of help: own family"
	dv_help_hfam                                  "Source of help: husband's family"
	dv_help_husb                                  "Source of help: husband"
	dv_help_bf 			"Source of help: boyfriend"
	dv_help_friend 		"Source of help: friend"
	dv_help_neighbor                       	"Source of help: neighbor"
	dv_help_relig 		"Source of help: religious"
	dv_help_doc                                    "Source of help: doctor"
	dv_help_police                                 "Source of help: police"
	dv_help_lawyer                                 "Source of help: lawyer"
	dv_help_sw                                      "Source of help: social worker"
	dv_help_other                                  "Source of help: other"


______________________________________________________________________________*/

*------------------------------------------------------------------------------
-->EDIT subgroups here if other subgroups are needed. 
*	Subgroups currently include: Residence, region, marital status, 
	number of living children, employment status, education, and wealth.
*------------------------------------------------------------------------------.

**SET UP COVARIATES, WEIGHTING, LABELS.
*subgroups.
compute all1 = 1.

compute residence = v025.
apply dictionary from *
 /source variables = v025
 /target variables = residence
.

compute region = v024.
apply dictionary from *
 /source variables = v024
 /target variables = region
.

compute wealth = v190.
apply dictionary from *
 /source variables = v190
 /target variables = wealth
.

compute education = v149.
apply dictionary from *
 /source variables = v149
 /target variables = education
.

compute marital = v502.
apply dictionary from *
 /source variables = v502
 /target variables = marital
.
variable labels marital "marital status".

compute afraid = d129.
apply dictionary from *
 /source variables = d129
 /target variables = afraid
.

compute husb_edu= v701.
apply dictionary from *
 /source variables = v701
 /target variables = husb_edu
.

compute father_beat = d121.
apply dictionary from *
 /source variables = d121
 /target variables = father_beat
.


*marital group of never married and ever married.
recode v502 (0=1) (1,2=2) into marital_2.
variable labels marital_2 "Ever or never married".
value labels marital_2 1 "never married" 2  "ever married".
	
*DV age groups.
compute dv_age = v013.
if v013=5 dv_age = 4.
if (v013=6 or v013=7) dv_age = 5.
variable labels dv_age "age groups".
value labels dv_age 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-39" 5 "40-49".

*living children.
recode v218 (0 = 0)(1,2 = 1)(3,4 = 3)(5 thru 97 = 5)(98,99 = 98) into livingchild.
variable labels livingchild "living children".
value labels livingchild 0 "0" 1 "1-2" 3 "3-4" 5 "5+" 98 "DK/missing".

*work status and type of earnings.
compute work = 0.
 *earns cash.
if (v741=1 or v741=2) work = 1.
*does not earn cash.
if (v741=0 or v741=3) work = 2.
if (v741=9) work = 9.
variable labels work "work status and type of earnings".
value labels work 0 "not employed" 1 "earns cash" 2 "does not earn cash" 9 "missing type of earnings".

*generate husband/wife education difference.
if v502=1 edu_diff = 0.
if (v715>v133) and v502=1 edu_diff = 1.
if (v715<v133) and v502=1 edu_diff = 2.
if (v715=v133) and v502=1 edu_diff = 3.
if (v715=0 and v133=0 and v502=1) edu_diff = 4.
if (v715=98 or v133=98) and v502=1 edu_diff = 5.
variable labels edu_diff "Spousal education difference".
value labels edu_diff 1 "husband better educated" 2 "wife better educated" 3 "equally educated" 4 "neither educated" 5 "DK/missing".

*generate husband/wife age difference.
if v502=1 age_diff_temp = v730-v012. 
recode age_diff_temp (-50 thru -1 = 1) (0=2) (1 thru 4=3) (5 thru 9=4) (10 thru hi=5) into age_diff.
variable labels age_diff "Spousal age difference".
value labels age_diff 1 "Wife older" 2 "Same age" 3  "Wife 1-4 yrs younger" 4 "Wife 5-9 yrs younger" 5 "Wife 10+ yrs younger".

*husband's alcohol consumption.
compute husb_drink = d113.
if d114=0 husb_drink = 1.
if d114=2 husb_drink = 2.
if d114=1 husb_drink = 3.
variable labels husb_drink "husband's drinking habits".
value labels husb_drink 0 "doesn't drink" 1 "drinks, never drunk" 2 "drinks, sometimes drunk" 3 "drinks, often drunk".

*number of decisions women participate in.
recode v743a (1,2=1) (4 thru 6=0) into decision_a.
recode v743b (1,2=1) (4 thru 6=0) into decision_b.
recode v743d (1,2=1) (4 thru 6=0) into decision_d.

if v502=1 decisions = sum(decision_a, decision_b, decision_d).
variable labels decisions "Number of decisions in which women participate".

*number of decisions for which wife beating is justified.
recode v744a (8=0)(else=copy) into beating_a.
recode v744b (8=0)(else=copy) into beating_b.
recode v744c (8=0)(else=copy) into beating_c.
recode v744d (8=0)(else=copy) into beating_d.
recode v744e (8=0)(else=copy) into beating_e.

compute beating = sum(beating_a, beating_b, beating_c, beating_d, beating_e).
variable labels beating "Number of reasons beating is justified".

**EXPERIENCED PHYSICAL VIOLENCE.

*ever.
if v044=1 dv_phy = 0.
*violence by current partner.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+if x>=1 and x<=4 dv_phy = 1.
end repeat.
*violence by former partner.
if d130a>=1 and d130a<=4 dv_phy = 1.
*violence by anyone other than partner.
if d115y=0 dv_phy = 1.
*violence during pregnancy.
if d118y=0 dv_phy = 1.

variable labels dv_phy	"Experienced physical violence since age 15".
value labels dv_phy 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 dv_phy_12m = 0.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+if x=1 or x=2 dv_phy_12m = 1.
end repeat.
if d117a=1 or d117a=2 or d130a=1 dv_phy_12m = 1.
variable labels dv_phy_12m "Experienced physical violence in past 12 mos".
value labels dv_phy_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 dv_phy_12m_f = 0.
*sometimes.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+if x=2 dv_phy_12m_f = 2.
end repeat.
if d117a=2 dv_phy_12m_f = 2.
*often.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+if x=1 dv_phy_12m_f = 1.
end repeat.
if d117a=1 dv_phy_12m_f = 1.
variable labels dv_phy_12m_f "Experienced physical violence in the past 12 mos, frequency".
value labels dv_phy_12m_f 0 "no" 1 "often" 2 "sometimes".

*physical violence during pregnancy.
*ever had a pregnancy.
if v044=1 and (v201>0 or v213=1 or v228=1) dv_phy_preg = 0.
if d118y=0 dv_phy_preg = 1.	
variable labels dv_phy_preg "Experienced physical violence during pregnancy".
value labels dv_phy_preg 0 "no" 1 "yes".

**PERSONS COMMITTING PHYSICAL VIOLENCE.
*current partner.
if dv_phy=1 dv_phy_hus_curr = 0.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+if v502=1 and ((x>0 and x<=4) or d118a=1) dv_phy_hus_curr = 1.
end repeat.
variable labels dv_phy_hus_curr "Person committing physical violence: current husband/partner".
value labels dv_phy_hus_curr 0 "no" 1 "yes".

*former partner.
if dv_phy=1 dv_phy_hus_form = 0.
if (v502=1 or v502=2) and (d115j=1 or d118j=1 or (d130a>0 and not sysmis(d130a))) dv_phy_hus_form = 1.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+if v502=2 and (x>0 and x<=4) dv_phy_hus_form = 1.
end repeat.
variable labels dv_phy_hus_form "Person committing physical violence: former husband/partner".
value labels dv_phy_hus_form 0 "no" 1 "yes".

*current boyfriend.
if dv_phy=1 dv_phy_bf_curr = 0.
if d115k=1 or d118k=1 dv_phy_bf_curr = 1.
variable labels dv_phy_bf_curr "Person committing physical violence: current boyfriend".
value labels dv_phy_bf_curr 0 "no" 1 "yes".

*former boyfriend.
if dv_phy=1 dv_phy_bf_form = 0.
if d115l=1 or d118l=1 dv_phy_bf_form = 1. 
variable labels dv_phy_bf_form "Person committing physical violence: former boyfriend".
value labels dv_phy_bf_form 0 "no" 1 "yes".

*father step-father.
if dv_phy=1 dv_phy_father = 0.
if d115c=1 or d118c=1 dv_phy_father = 1.
variable labels dv_phy_father "Person committing physical violence: father/step-father".
value labels dv_phy_father 0 "no" 1 "yes".

*mother or step-mother.
if dv_phy=1 dv_phy_mother = 0.
if d115b=1 or d118b=1 dv_phy_mother = 1.
variable labels dv_phy_mother "Person committing physical violence: mother/step-mother".
value labels dv_phy_mother 0 "no" 1 "yes".

*sister or brother.
if dv_phy=1 dv_phy_sibling = 0.
if d115f=1 or d118f=1 dv_phy_sibling = 1.
variable labels dv_phy_sibling "Person committing physical violence: sister or bother".
value labels dv_phy_sibling 0 "no" 1 "yes".

*daughter/son.
if dv_phy=1 dv_phy_bychild = 0.
if d115d=1 or d118d=1 dv_phy_bychild = 1.
variable labels dv_phy_bychild "Person committing physical violence: daughter/son".
value labels dv_phy_bychild 0 "no" 1 "yes".

*other relative.
if dv_phy=1 dv_phy_other_rel = 0.
if d115g=1 or d118g=1 dv_phy_other_rel = 1.
variable labels dv_phy_other_rel "Person committing physical violence: other relative".
value labels dv_phy_other_rel 0 "no" 1 "yes".

*mother-in-law.
if dv_phy=1 dv_phy_mother_inlaw = 0.
if d115o=1 or d118o=1 dv_phy_mother_inlaw = 1.
variable labels dv_phy_mother_inlaw "Person committing physical violence: mother-in-law".
value labels dv_phy_mother_inlaw 0 "no" 1 "yes".

*father-in-law.
if dv_phy=1 dv_phy_father_inlaw = 0.
if d115p=1 or d118p=1 dv_phy_father_inlaw = 1.
variable labels dv_phy_father_inlaw "Person committing physical violence: father-in-law".
value labels dv_phy_father_inlaw 0 "no" 1 "yes".

*other-in-law.
if dv_phy=1 dv_phy_other_inlaw = 0.
if d115q=1 or d118q=1 dv_phy_other_inlaw = 1.
variable labels dv_phy_other_inlaw "Person committing physical violence: other-in-law".
value labels dv_phy_other_inlaw 0 "no" 1 "yes".

*teacher.
if dv_phy=1 dv_phy_teacher = 0.
if d115v=1 or d118v=1 dv_phy_teacher = 1.
variable labels dv_phy_teacher "Person committing physical violence: teacher".
value labels dv_phy_teacher 0 "no" 1 "yes".

*employer/someone at work.
if dv_phy=1 dv_phy_atwork = 0.
if d115w=1 or d118w=1 dv_phy_atwork = 1.
variable labels dv_phy_atwork "Person committing physical violence: employer/someone at work".
value labels dv_phy_atwork 0 "no" 1 "yes".

*police/soldier.
if dv_phy=1 dv_phy_police = 0.
if d115xe=1 or d118xe=1 dv_phy_police = 1.
variable labels dv_phy_police "Person committing physical violence: police/soldier".
value labels dv_phy_police 0 "no" 1 "yes".

*other.
if dv_phy=1 dv_phy_other = 0.
if d115x=1 or d118x=1 dv_phy_other = 1.
variable labels dv_phy_other "Person committing physical violence: other".
value labels dv_phy_other 0 "no" 1 "yes".




**EXPERIENCED SEXUAL VIOLENCE.
*ever.
if v044=1 dv_sex = 0.
*violence by current partner.
do repeat x = d105h d105i d105k.
+if x>=1 and x<=4 dv_sex = 1.
end repeat.
*violence by former partner.
if d130b>=1 and d130b<=4 dv_sex = 1.
*violence by anyone other than partner.
if d124=1 dv_sex = 1.	  
*forced to perform unwanted acts.
if d125=1 dv_sex = 1.	 
variable labels dv_sex	"Ever experienced sexual violence".
value labels dv_sex 0 "no" 1 "yes".

		
*in the last 12 months.
if v044=1 dv_sex_12m = 0.
do repeat x = d105h d105i d105k.
+if x=1 or x=2 dv_sex_12m = 1.
end repeat.
if d130b=1 or d124=1 dv_sex_12m = 1.
variable labels dv_sex_12m "Experienced sexual violence in past 12 mos".
value labels dv_sex_12m 0  "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 dv_sex_12m_f = 0.
 *sometimes.
do repeat x = d105h d105i d105k.
+if x=2 dv_sex_12m_f = 2.
end repeat.
if d117a=2 dv_sex_12m_f = 2.
 *often.
do repeat x = d105h d105i d105k.
+if x=1 dv_sex_12m_f = 1.
end repeat.
if d117a=1 dv_sex_12m_f = 1.
variable labels dv_sex_12m_f "Experienced sexual violence in the past 12 mos, frequency".
value labels dv_sex_12m_f 0 "no" 1 "yes, often" 2 "yes, sometimes".

**EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE.
*ever.
if v044=1 dv_phy_sex = 0.
if (dv_phy=1 and dv_sex=1) dv_phy_sex = 1.
variable labels dv_phy_sex "Ever experienced physical AND sexual violence".
value labels dv_phy_sex 0  "no" 1 "yes".

*in the last 12 months.
if v044=1 dv_phy_sex_12m = 0.
if (dv_phy_12m=1 and dv_sex_12m=1) dv_phy_sex_12m = 1.
variable labels dv_phy_sex_12m "Experienced physical AND sexual violence in the last 12 months".
value labels dv_phy_sex_12m 0  "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 dv_phy_sex_12m_f = 0.
if (dv_phy_12m=1 and dv_sex_12m=1) dv_phy_sex_12m_f = 1.
if (dv_phy_12m=2 and dv_sex_12m=2) dv_phy_sex_12m_f = 2.
variable labels dv_phy_sex_12m_f	"Experienced physical AND sexual violence in the last 12 months, frequency".
value labels dv_phy_sex_12m_f 0 "no" 1 "yes, often" 2 "yes, sometimes".

**EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE.
*ever.
if v044=1 dv_phy_sex_any = 0.
if (dv_phy=1 or dv_sex=1) dv_phy_sex_any = 1.
variable labels dv_phy_sex_any "Ever experienced physical OR sexual violence".
value labels dv_phy_sex_any 0  "no" 1 "yes".

*in the last 12 months.
if v044=1 dv_phy_sex_any_12m = 0.
if (dv_phy_12m=1 or dv_sex_12m=1) dv_phy_sex_any_12m = 1.
variable labels dv_phy_sex_any_12m "Experienced physical OR sexual violence in the last 12 months".
value labels dv_phy_sex_any_12m 0  "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1  dv_phy_sex_any_12m_f = 0.
if (dv_phy_12m=1 or dv_sex_12m=1) dv_phy_sex_any_12m_f = 1.
if (dv_phy_12m=2 or dv_sex_12m=2) dv_phy_sex_any_12m_f = 2.
variable labels dv_phy_sex_any_12m_f "Experienced physical OR sexual violence in the last 12 months, frequency".
value labels  dv_phy_sex_any_12m_f 0 "no" 1 "yes, often" 2 "yes, sometimes".

*which type.
if dv_phy_sex_any=1 dv_viol_type = 0.
if (dv_phy=1 and dv_sex=0) dv_viol_type = 1.
if (dv_phy=0 and dv_sex=1) dv_viol_type = 2.
if (dv_phy=1 and dv_sex=1) dv_viol_type = 3.
variable labels dv_viol_type "Ever experienced physical only, sexual only, or both".
value labels dv_viol_type 1 "physical only" 2 "sexual only" 3 "both".

*physical only.
if v044=1 dv_phy_only = 0. 
if (dv_phy=1 and dv_sex=0) dv_phy_only = 1.
variable labels dv_phy_only "Ever experienced only physical violence".
value labels dv_phy_only 0  "no" 1 "yes".

*sexual only.
if v044=1 dv_sex_only = 0.
if (dv_phy=0 and dv_sex=1) dv_sex_only = 1.
variable labels dv_sex_only "Ever experienced only sexual violence".
value labels dv_sex_only 0  "no" 1 "yes".
		
**AGE EXPERIENCED SEXUAL VIOLENCE.
*by age 10.
if v044=1 dv_sex_age_10 = 0.
if d126<10 dv_sex_age_10 = 1.
variable labels dv_sex_age_10 "First experienced sexual violence by age 10".
value labels dv_sex_age_10 0  "no" 1 "yes".
	
*by age 12.
if v044=1 dv_sex_age_12 = 0.
if d126<12 dv_sex_age_12 = 1.
variable labels dv_sex_age_12 "First experienced sexual violence by age 12".
value labels dv_sex_age_12 0  "no" 1 "yes".

*by age 15.
if v044=1 dv_sex_age_15 = 0.
if d126<15 dv_sex_age_15 = 1.
variable labels dv_sex_age_15 "First experienced sexual violence by age 15".
value labels dv_sex_age_15 0  "no" 1 "yes".


*by age 18.
if v044=1 dv_sex_age_18 = 0.
if d126<18 dv_sex_age_18 = 1.
variable labels dv_sex_age_18 "First experienced sexual violence by age 18".
value labels dv_sex_age_18 0  "no" 1 "yes".

*by age 22.
if v044=1 dv_sex_age_22 = 0.
if d126<22 dv_sex_age_22 = 1.
variable labels dv_sex_age_22 "First experienced sexual violence by age 22".
value labels dv_sex_age_22 0  "no" 1 "yes".

**PERSONS COMMITTING SEXUAL VIOLENCE.
*current partner.
if dv_sex=1 dv_sex_hus_curr = 0.
do repeat x = d105h d105i d105k.
+if v502=1 and ((x>0 and x<=4) or d127=1) dv_sex_hus_curr = 1.
end repeat.
variable labels dv_sex_hus_curr "Person committing sexual violence: current husband/partner".
value labels dv_sex_hus_curr 0  "no" 1 "yes".

*former partner.
if dv_sex=1 dv_sex_hus_form = 0. 
if v502=1 and (d127=2 and v503<>1) dv_sex_hus_form = 1.
if (v502=1 or v502=2) and (d130b>0 and not sysmis(d130b)) dv_sex_hus_form = 1.
do repeat x = d105h d105i d105k.
+if v502=2 and (d127=2 or (x>0 and x<=4)) dv_sex_hus_form = 1.
end repeat.
variable labels dv_sex_hus_form "Person committing sexual violence: former husband/partner".
value labels dv_sex_hus_form 0  "no" 1 "yes".

*current or former boyfriend.
if dv_sex=1 dv_sex_bf = 0.
if (v502=1 and d127=2 and v503=1) or (v502=0 and (d127=1 or d127=2)) dv_sex_bf = 1.
if d127=3 dv_sex_bf = 1.
variable labels dv_sex_bf "Person committing sexual violence: current/former boyfriend".
value labels dv_sex_bf 0  "no" 1 "yes".

*father step-father.
if dv_sex=1 dv_sex_father = 0.
if d127=4 dv_sex_father = 1.
variable labels dv_sex_father "Person committing sexual violence: father/step-father".
value labels dv_sex_father 0  "no" 1 "yes".

*brother.
if dv_sex=1 dv_sex_brother = 0.
if d127=5 dv_sex_brother = 1.
variable labels dv_sex_brother "Person committing sexual violence: bother".
value labels dv_sex_brother 0  "no" 1 "yes".

*other relative.
if dv_sex=1 dv_sex_other_rel = 0.
if d127=6 dv_sex_other_rel = 1.
variable labels dv_sex_other_rel "Person committing sexual violence: other relative".
value labels dv_sex_other_rel 0  "no" 1 "yes".

*in-law.
if dv_sex=1 dv_sex_inlaw = 0.
if d127=7 dv_sex_inlaw = 1.
variable labels dv_sex_inlaw "Person committing sexual violence: an in-law".
value labels dv_sex_inlaw 0  "no" 1 "yes".

*friend or acquaintance.
if dv_sex=1 dv_sex_friend = 0.
if d127=8 dv_sex_friend = 1.
variable labels dv_sex_friend "Person committing sexual violence: own friend/acquaintance".
value labels dv_sex_friend 0  "no" 1 "yes".

*friend of the family.
if dv_sex=1 dv_sex_friend_fam = 0.
if d127=9 dv_sex_friend_fam = 1.
variable labels dv_sex_friend_fam "Person committing sexual violence: a family friend".
value labels dv_sex_friend_fam 0  "no" 1 "yes".

*teacher.
if dv_sex=1 dv_sex_teacher = 0.
if d127=10 dv_sex_teacher = 1.
variable labels dv_sex_teacher "Person committing sexual violence: teacher".
value labels dv_sex_teacher 0  "no" 1 "yes".

*employer/someone at work.
if dv_sex=1 dv_sex_atwork = 0.
if d127=11 dv_sex_atwork = 1.
variable labels dv_sex_atwork "Person committing sexual violence: employer/someone at work".
value labels dv_sex_atwork 0  "no" 1 "yes".

*police/soldier.
if dv_sex=1 dv_sex_police = 0.
if d127=12 dv_sex_police = 1.
variable labels dv_sex_police "Person committing sexual violence: police/soldier".
value labels dv_sex_police 0  "no" 1 "yes".

*priest/religious leader.
if dv_sex=1 dv_sex_relig = 0.
if d127=13 dv_sex_relig = 1.
variable labels dv_sex_relig "Person committing sexual violence: a priest or religious leader".
value labels dv_sex_relig 0  "no" 1 "yes".

*stranger.
if dv_sex=1 dv_sex_stranger = 0.
if d127=14 dv_sex_stranger = 1.
variable labels dv_sex_stranger "Person committing sexual violence: stranger".
value labels dv_sex_stranger 0  "no" 1 "yes".

*other.
if dv_sex=1 dv_sex_other = 0.
if d127=96 dv_sex_other = 1.
variable labels dv_sex_other "Person committing sexual violence: other".
value labels dv_sex_other 0  "no" 1 "yes".
	
*missing.
if dv_sex=1 dv_sex_missing = 0.
if d127=99 dv_sex_missing = 1.
variable labels dv_sex_missing "Person committing sexual violence: missing".
value labels dv_sex_missing 0  "no" 1 "yes".

********************************************************************************
**Seeking help after violence
********************************************************************************
	
*sought help.
if dv_phy_sex_any=1 dv_help_seek = 0.
if d119y=0 dv_help_seek = 1.
if (d119y=1 and d128=1) dv_help_seek = 2.
if (d119y=1 and d128=0) dv_help_seek = 3.
variable labels dv_help_seek "Sought help to stop violence".
value labels dv_help_seek 1 "Sought help" 2 "Didn't seek help, told someone" 3 "Didn't seek help, didn't tell someone".
	
*sources of help: own family.
if dv_help_seek=1 dv_help_fam = 0.
do repeat x = d119b d119c d119d d119e d119f d119g d119h d119m d119n.
+if x=1 dv_help_fam = 1.
end repeat.
variable labels dv_help_fam "Sought help from own family".
value labels dv_help_fam 0  "no" 1 "yes".

*sources of help: husband's family.
if dv_help_seek=1 dv_help_hfam = 0.
do repeat x = d119i d119o d119p d119q d119r.
+if x=1 dv_help_hfam = 1.
end repeat.
variable labels dv_help_hfam "Sought help from husband's family".
value labels dv_help_hfam 0  "no" 1 "yes".

*sources of help: husband.
if dv_help_seek=1 dv_help_husb = 0.
do repeat x = d119a d119j.
+if x=1 dv_help_husb = 1.
end repeat.
variable labels dv_help_husb "Sought help from husband".
value labels dv_help_husb 0  "no" 1 "yes".

*sources of help: boyfriend.
if dv_help_seek=1 dv_help_bf = 0.
do repeat x = d119k d119l.
+if x=1 dv_help_bf = 1.
end repeat.
variable labels dv_help_bf "Sought help from boyfriend".
value labels dv_help_bf 0  "no" 1 "yes".

*sources of help: friend.
if dv_help_seek=1 dv_help_friend = 0.
do repeat x = d119s d119t d119xd.
+if x=1 dv_help_friend = 1.
end repeat.
variable labels dv_help_friend "Sought help from friend".
value labels dv_help_friend 0  "no" 1 "yes".

*sources of help: neighbor.
if dv_help_seek=1 dv_help_neighbor = 0.
do repeat x = d119u.
+if x=1 dv_help_neighbor = 1.
end repeat.
variable labels dv_help_neighbor "Sought help from neighbor".
value labels dv_help_neighbor 0  "no" 1 "yes".

*sources of help: religious leader.
if dv_help_seek=1 dv_help_relig = 0.
do repeat x = d119xf.
+if x=1 dv_help_relig = 1.
end repeat.
variable labels dv_help_relig "Sought help from religious leader".
value labels dv_help_relig 0  "no" 1 "yes".

*sources of help: doctor or medical personnel.
if dv_help_seek=1 dv_help_doc = 0.
do repeat x = d119xh.
+if x=1 dv_help_doc = 1.
end repeat.
variable labels dv_help_doc "Sought help from doctor or medical personnel".
value labels dv_help_doc 0  "no" 1 "yes".

*sources of help: police.
if dv_help_seek=1 dv_help_police = 0.
do repeat x = d119xe.
+if x=1 dv_help_police = 1.
end repeat.
variable labels dv_help_police "Sought help from police".
value labels dv_help_police 0  "no" 1 "yes".

*sources of help: lawyer.
if dv_help_seek=1 dv_help_lawyer = 0.
do repeat x = d119xg.
+if x=1 dv_help_lawyer = 1.
end repeat.
variable labels dv_help_lawyer "Sought help from lawyer".
value labels dv_help_lawyer 0  "no" 1 "yes".

*sources of help: social work organization.
if dv_help_seek=1 dv_help_sw = 0.
do repeat x = d119xb.
+if x=1 dv_help_sw = 1.
end repeat.
variable labels dv_help_sw "Sought help from social work organization".
value labels dv_help_sw 0  "no" 1 "yes".

*sources of help: other.
if dv_help_seek=1 dv_help_other = 0.
do repeat x = d119v d119w d119x d119xa d119xc d119xi d119xj d119xk.
+if x=1 dv_help_other = 1.
end repeat.
variable labels dv_help_other "Sought help from other".
value labels dv_help_other 0  "no" 1 "yes".


