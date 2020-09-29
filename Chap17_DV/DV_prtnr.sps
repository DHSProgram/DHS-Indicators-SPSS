* Encoding: UTF-8.
*****************************************************************************************************
Program: 			DV_prtnr.sps
Purpose: 			Code domestic violence for spousal violence indicators from the IR file
Data inputs: 		IR data files
Data outputs:		coded variables
Author:				Courtney Allen and translated to SPSS by Ivana Bjelic
Date last modified: September 29 2020
*****************************************************************************************************/

*______________________________________________________________________________
Variables created in this file:
	
*CURRENT PARTNER VIOLENCE	
	----------------------------------------------------------------------------
*each indicator in this series has an additional 2 variables with the suffixes
	"12m"	indicates event occurred in last 12 months, and 
	"12m_f" indicates a new variable that describes if the event that occurred 
	often or sometimes.*
*	
	For example:
	dv_prtnr_slap			"Ever slapped by partner"
	dv_prtnr_slap_12m			"Slapped in past 12 mos. by partner"
	dv_prtnr_slap_12m_f        		"Slapped in past 12 mos. by partner, frequency"
	----------------------------------------------------------------------------

*physical
	dv_prtnr_phy	  
	dv_prtnr_push			"Ever pushed, shook, or had something thrown at her in past 12 mos. by partner"
	dv_prtnr_slap			"Ever slapped by partner"
	dv_prtnr_twist			"Ever had arm twisted or hair pulled mos. by partner"
	dv_prtnr_punch			"Ever punched with first or something else that could hurt her by partner"
	dv_prtnr_kick			"Ever kicked, dragged, or beat up by partner"
	dv_prtnr_choke			"Ever tried to choke or burn her by partner"
	dv_prtnr_weapon			"Ever threatened or attacked with a knife, gun, or other weapon by partner"
		 
*sexual
	dv_prtnr_sex			"Ever experienced any sexual violence by partner"
	dv_prtnr_force			"Physically forced to have sex when she did not want to by partner"
	dv_prtnr_force_act			"Physically forced to perform other sexual acts when she did not want to by partner"
	dv_prtnr_threat_act			"Forced with threats or in any other way to perform sexual acts she did not want to by partner"
		
*emotional
	dv_prtnr_emot			"Any emotional violence by partner"
	dv_prtnr_humil			"Humiliated in front of others by partner"
	dv_prtnr_threat			"Threatened to hurt or harm her or someone she cared about by partner"
	dv_prtnr_insult			"Insulted or made to feel bad about herself by partner"
		
*combinations of violence (combinations do not need a _freq variable)
	dv_prtnr_phy_sex			"Ever experienced physical AND sexual violence by partner"
	dv_prtnr_phy_sex_emot    		"Ever experienced physical AND sexual AND emotional violence by partner"
	dv_prtnr_phy_sex_any    		"Ever experienced physical OR sexual violence by partner"
	dv_prtnr_phy_sex_emot_any                	"Ever experienced physical OR sexual OR emotional violence by partner"
				
*ANY PARTNER VIOLENCE	
	dv_aprtnr_phy			"Experienced physical by any partner"
	dv_aprtnr_sex			"Experienced sexual violence by any partner"
	dv_aprtnr_emot			"Experienced emotional violence by any partner"
	dv_aprtnr_phy_sex			"Experienced physical and sexual violence by any partner"
	dv_aprtnr_phy_sex_any		                  "Ever experienced physical OR sexual violence by any partner"
	dv_aprtnr_phy_sex_emot		"Ever experienced physical AND sexual AND emotional violence by any partner"
	dv_aprtnr_phy_sex_emot_any            	"Ever experienced physical OR sexual OR emotional violence by any partner"
*		
	dv_prtnr_viol_years                            	"Experience of physical or sexual violence by partner by specific exact years since marriage - among women only married once"
	dv_prtnr_viol_none                            	"Did not experience physical or sexual violence by partner - among women only married once"
	
*VIOLENCE BY MARRIAGE DURATION
	dv_marr_viol_0                		"Exp"erience of violence by exact marriage duration: before marriage"
	dv_marr_viol_2                		"Exp"erience of violence by exact marriage duration: 2 yrs of marriage"
	dv_marr_viol_5                		"Exp"erience of violence by exact marriage duration: 5 yrs of marriage"
	dv_marr_viol_10                		"Exp"erience of violence by exact marriage duration: 10 yrs of marriage"

*INITIATION OF SPOUSAL VIOLENCE BY WOMEN
	dv_prtnr_cuts                    		 "Have cuts, bruises, or aches as a result of the violence by partner"
	dv_prtnr_injury                    		"Have eye injuries, sprains, dislocations, or burns as a result of the violence by partner"
	dv_prtnr_broken                    		"Deep wounds, broken bones, broken teeth, or any other serious injury as a result of the violence by partner"
	dv_prtnr_injury_any                            	"Have any injury as a result of the violence by partner"
*	
	dv_abusedhus_phy                                             "Ever committed physical violence against partner when he was not already beating or physically hurting her"
	dv_abusedhus_phy_12m                                     "Committed physical violence against partner in past 12 mos. when he was not already beating or physically hurting her"

*SEEKING HELP AFTER VIOLENCE	
	dv_help_seek                    		"Help-seeking behavior of women who ever experienced physical or sexual violence"
	dv_help_phy	                    		"Sources of help sought for physical violence among women who sought help"
	dv_help_sex    			"Sources of help sought for sexual violence among women who sought help"
	dv_help_phy_sex_all                            	"Sources of help sought for physical and sexual violence among women who sought help"
	dv_help_phy_sex_any                        	"Sources of help sought for physical or sexual violence among women who sought help"
	
*
	dv_help_fam                                        	"Source of help: own family"
	dv_help_hfam                                                     "Source of help: husband's family"
	dv_help_husb                                                     "Source of help: husband"
	dv_help_bf                                                         "Source of help: boyfriend"
	dv_help_friend                                                    "Source of help: friend"
	dv_help_neighbor                                                "Source of help: neighbor"
	dv_help_relig                                                      "Source of help: religious"
	dv_help_doc                                                       "Source of help: doctor"
	dv_help_police                                                    "Source of help: police"
	dv_help_lawyer                                                   "Source of help: lawyer"
	dv_help_sw                                                         "Source of help: social worker"
	dv_help_other                                                     "Source of help: other"
_____________________________________________________________________________*/


********************************************************************************
**covariates needed for tables
********************************************************************************
*duration of marriage.
recode v512 (0,1= 1) (2 thru 4=2) (5 thru 9=3) (10 thru 50=4) into mar_years.
variable labels mar_years "Years since first cohabitation".
value labels mar_years 1 "<2" 2 "2-4" 3 "5-9" 4  "10+".


********************************************************************************	
**Current partner physical violence, by types of violence
********************************************************************************	

*ANY PARTNER VIOLENCE.
*ever.
if v044=1 and v502>0 dv_prtnr_phy = 0.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+ if x>0 and x<=3 dv_prtnr_phy = 1.
end repeat.
variable labels dv_prtnr_phy "Any physical violence by partner".
value labels dv_prtnr_phy 0 "no" 1 "yes".

*in last 12 months.
if v044=1 and v502>0 dv_prtnr_phy_12m = 0.
do repeat x = d105a d105b d105c d105d d105e d105f d105g d105j.
+ if x=1 or x=2 dv_prtnr_phy_12m = 1.
end repeat.
variable labels dv_prtnr_phy_12m	"Any physical violence in past 12 mos. by partner".
value labels dv_prtnr_phy_12m 0 "no" 1 "yes".

*in last 12 months, freq.
if v044=1 and v502>0 dv_prtnr_phy_12m_f = 0.
do repeat x = 2 1.
+if d105a=x dv_prtnr_phy_12m_f =x.
+if d105b=x dv_prtnr_phy_12m_f =x.
+if d105c=x dv_prtnr_phy_12m_f =x.
+if d105d=x dv_prtnr_phy_12m_f =x.
+if d105e=x dv_prtnr_phy_12m_f =x.
+if d105f=x dv_prtnr_phy_12m_f =x.
+if d105g=x dv_prtnr_phy_12m_f =x.
+if d105j=x dv_prtnr_phy_12m_f =x.
end repeat.
variable labels dv_prtnr_phy_12m_f	"Any physical violence in past 12 mos. by partner, frequency".
value labels dv_prtnr_phy_12m_f  0 "no" 1 "often" 2 "sometimes".


*TYPE OF VIOLENCE: PUSHED, SHOOK, OR SOMETHING THROWN AT HER.
*ever.
if v044=1 and v502>0 dv_prtnr_push = 0.
if d105a>0 and d105a<=3 dv_prtnr_push = 1.
variable labels dv_prtnr_push "Ever pushed, shook, or had something thrown at her by partner".
value labels dv_prtnr_push 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_push_12m = 0.
if (d105a=1 or d105a=2) dv_prtnr_push_12m = 1.
variable labels dv_prtnr_push_12m	"Pushed, shook, or had something thrown at her in past 12 mos. by partner".
value labels dv_prtnr_push_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_push_12m_f = 0.
if d105a=1 dv_prtnr_push_12m_f = 1.
if d105a=2 dv_prtnr_push_12m_f = 2.
variable labels dv_prtnr_push_12m_f "Pushed, shook, or had something thrown at her in past 12 mos. by partner, frequency".
value labels dv_prtnr_push_12m_f  0 "no" 1 "often" 2 "sometimes".
	
	
*TYPE OF VIOLENCE: SLAPPED.
*ever.
if v044=1 and v502>0 dv_prtnr_slap = 0. 
if d105b>0 and d105b<=3 dv_prtnr_slap = 1.
variable labels dv_prtnr_slap "Ever slapped by partner".
value labels dv_prtnr_slap 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_slap_12m = 0. 
if (d105b=1 or d105b=2) dv_prtnr_slap_12m = 1.
variable labels dv_prtnr_slap_12m "Slapped in past 12 mos. by partner".
value labels  dv_prtnr_slap_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_slap_12m_f = 0. 
if d105b=1 dv_prtnr_slap_12m_f = 1.
if d105b=2 dv_prtnr_slap_12m_f = 2.
variable labels dv_prtnr_slap_12m_f "Slapped in past 12 mos. by partner, frequency".
value labels  dv_prtnr_slap_12m_f 0 "no" 1 "often" 2 "sometimes".

	
*TYPE OF VIOLENCE: ARM TWISTED OR HAIR PULLED.
*ever.
if v044=1 and v502>0 dv_prtnr_twist = 0. 
if d105j>0 and d105j<=3 dv_prtnr_twist = 1.
variable labels dv_prtnr_twist "Had arm twisted or hair pulled in past partner".
value labels  dv_prtnr_twist 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_twist_12m = 0.
if (d105j=1 or d105j=2) dv_prtnr_twist_12m = 1.
variable labels dv_prtnr_twist_12m	"Had arm twisted or hair pulled in past 12 mos. by partner".
value labels dv_prtnr_twist_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_twist_12m_f = 0.
if d105j=1 dv_prtnr_twist_12m_f = 1.
if d105j=2 dv_prtnr_twist_12m_f = 2. 
variable labels dv_prtnr_twist_12m_f "Had arm twisted or hair pulled in past 12 mos. by partner, frequency".
value labels dv_prtnr_twist_12m_f 0 "no" 1 "often" 2 "sometimes".

	
	
*TYPE OF VIOLENCE: PUNCHED.
*ever.
if v044=1 and v502>0 dv_prtnr_punch = 0.
if d105c>0 and d105c<=3 dv_prtnr_punch = 1. 
variable labels dv_prtnr_punch "Punched with first or something else that could hurt her by partner".
value labels dv_prtnr_punch 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_punch_12m = 0.
if (d105c=1 or d105c=2) dv_prtnr_punch_12m = 1.
variable labels dv_prtnr_punch_12m "Punched with first or something else that could hurt her in past 12 mos. by partner".
value labels dv_prtnr_punch_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_punch_12m_f = 0.
if d105c=1 dv_prtnr_punch_12m_f = 1.
if d105c=2 dv_prtnr_punch_12m_f = 2.
variable labels dv_prtnr_punch_12m_f "Punched with first or something else that could hurt her in past 12 mos. by partner, frequency".
value labels  dv_prtnr_punch_12m_f 0 "no" 1 "often" 2 "sometimes".
	
	
	
*TYPE OF VIOLENCE: KICKED, DRAGGED, BEAT UP.
*ever.
if v044=1 and v502>0 dv_prtnr_kick = 0.
if d105d>0 and d105d<=3 dv_prtnr_kick = 1.
variable labels dv_prtnr_kick "Kicked, dragged, or beat up by partner".
value labels dv_prtnr_kick 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_kick_12m = 0.
if (d105d=1 or d105d=2) dv_prtnr_kick_12m = 1.
variable labels dv_prtnr_kick_12m	"Kicked, dragged, or beat up in past 12 mos. by partner".
value labels dv_prtnr_kick_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_kick_12m_f = 0. 
if d105d=1 dv_prtnr_kick_12m_f = 1.
if d105d=2 dv_prtnr_kick_12m_f = 2.
variable labels dv_prtnr_kick_12m_f "Kicked, dragged, or beat up in past 12 mos. by partner, frequency".
value labels dv_prtnr_kick_12m_f 0 "no" 1 "often" 2 "sometimes".

		
		
*TYPE OF VIOLENCE: CHOKED.
*ever.
if v044=1 and v502>0 dv_prtnr_choke = 0.
if d105e>0 and d105e<=3 dv_prtnr_choke = 1.
variable labels dv_prtnr_choke "Tried to choke or burn her by partner".
value labels dv_prtnr_choke 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_choke_12m = 0. 
if (d105e=1 or d105e=2) dv_prtnr_choke_12m = 1. 
variable labels dv_prtnr_choke_12m "Tried to choke or burn her in past 12 mos. by partner".
value labels dv_prtnr_choke_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_choke_12m_f = 0.
if d105e=1 dv_prtnr_choke_12m_f = 1.
if d105e=2 dv_prtnr_choke_12m_f = 2. 
variable labels dv_prtnr_choke_12m_f "Tried to choke or burn her in past 12 mos. by partner, frequency".
value labels dv_prtnr_choke_12m_f 0 "no" 1 "often" 2 "sometimes".

	
	
*TYPE OF VIOLENCE: THREATENED WITH WEAPON.
*ever.
if v044=1 and v502>0 dv_prtnr_weapon = 0. 
if d105f>0 and d105f<=3 dv_prtnr_weapon = 1.
variable labels dv_prtnr_weapon "Threatened or attacked with a knife, gun, or weapon by partner".
value labels dv_prtnr_weapon 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_weapon_12m = 0.
if d105f=1 or d105f=2 dv_prtnr_weapon_12m = 1.
variable labels dv_prtnr_weapon_12m "Threatened or attacked with a knife, gun, or weapon in past 12 mos. by partner".
value labels dv_prtnr_weapon_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_weapon_12m_f = 0.
if d105f=1 dv_prtnr_weapon_12m_f = 1.
if d105f=2 dv_prtnr_weapon_12m_f = 2.
variable labels dv_prtnr_weapon_12m_f "Threatened or attacked with a knife, gun, or weapon in past 12 mos. by partner, frequency".
value labels dv_prtnr_weapon_12m_f 0 "no" 1 "often" 2 "sometimes".
	
	
	
	
	
********************************************************************************	
**Current partner sexual violence: types of violence
********************************************************************************
*ANY SEXUAL VIOLENCE.
*ever.
if v044=1 and v502>0 dv_prtnr_sex = 0.
do repeat x = d105h d105i d105k.
if x>0  and x<=3 dv_prtnr_sex = 1.
end repeat.
variable labels dv_prtnr_sex "Any sexual violence in past by partner".
value labels dv_prtnr_sex 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_sex_12m = 0.
do repeat x = d105h d105i d105k.
+if (x=1 or x=2) dv_prtnr_sex_12m = 1.
end repeat.
variable labels dv_prtnr_sex_12m	"Any sexual violence in past 12 mos. by partner".
value labels dv_prtnr_sex 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_sex_12m_f = 0.
do repeat x = 2 1.
+if d105h = x dv_prtnr_sex_12m_f = x.
+if d105i = x dv_prtnr_sex_12m_f = x.
+if d105k = x dv_prtnr_sex_12m_f = x.
end repeat.
variable labels dv_prtnr_sex_12m_f "Any sexual violence in past 12 mos. by partner, frequency".
value labels dv_prtnr_sex_12m_f 0 "no" 1 "often" 2 "sometimes".

		
		
*TYPE OF VIOLENCE: FORCED TO HAVE SEX
*ever.
if v044=1 and v502>0 dv_prtnr_force = 0. 
if d105h>0 and d105h<=3 dv_prtnr_force = 1.
variable labels dv_prtnr_force "Physically forced to have unwanted sex by partner".
value labels dv_prtnr_force 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_force_12m = 0.
if (d105h=1 or d105h=2) dv_prtnr_force_12m = 1.
variable labels dv_prtnr_force_12m	"Physically forced to have unwanted sex in past 12 mos. by partner".
value labels dv_prtnr_force_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_force_12m_f = 0.
if d105h=1 dv_prtnr_force_12m_f = 1.
if d105h=2 dv_prtnr_force_12m_f = 2.
variable labels dv_prtnr_force_12m_f "Physically forced to have unwanted sex in past 12 mos. by partner, frequency".
value labels dv_prtnr_force_12m_f 0 "no" 1 "often" 2 "sometimes".

		
*TYPE OF VIOLENCE: FORCED TO PERFORM OTHER SEXUAL ACTS.
*ever.
if v044=1 and v502>0 dv_prtnr_force_act = 0.
if d105k>0 and d105k<=3 dv_prtnr_force_act = 1.
variable labels dv_prtnr_force_act "Physically forced to perform other sexual acts when she did not want to by partner".
value labels dv_prtnr_force_act 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_force_act_12m = 0.
if (d105k=1 or d105k=2) dv_prtnr_force_act_12m = 1. 
variable labels dv_prtnr_force_act_12m "Physically forced to perform other sexual acts when she did not want to in past 12 mos. by partner".
value labels  dv_prtnr_force_act_12m 0 "no" 1 "yes".
		
*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_force_act_12m_f = 0. 
if d105k=1 dv_prtnr_force_act_12m_f = 1.
if d105k=2 dv_prtnr_force_act_12m_f = 2. 
variable labels dv_prtnr_force_act_12m_f "Physically forced to perform other sexual acts when she did not want to in past 12 mos. by partner, frequency".
value labels dv_prtnr_force_act_12m_f 0 "no" 1 "often" 2 "sometimes".

		
		
*TYPE OF VIOLENCE: FORCED WITH THREATS.
*ever.
if v044=1 and v502>0 dv_prtnr_threat_act = 0. 
if d105i>0 and d105i<=3 dv_prtnr_threat_act = 1.
variable labels dv_prtnr_threat_act "Ever forced with threats or other ways to perform sexual acts she did not want to by partner".
value labels  dv_prtnr_threat_act 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_threat_act_12m = 0.
if (d105i=1 or d105i=2) dv_prtnr_threat_act_12m = 1.
variable labels dv_prtnr_threat_act_12m "Forced with threats or other ways to perform sexual acts she did not want to in past 12 mos. by partner".
value labels dv_prtnr_threat_act_12m 0 "no" 1 "yes".

*in the last 12 months by frequency (often or sometimes).
compute dv_prtnr_threat_act_12m_f = 0.
if d105i=1 dv_prtnr_threat_act_12m_f = 1.
if d105i=2 dv_prtnr_threat_act_12m_f = 2.
variable labels dv_prtnr_threat_act_12m_f "Forced with threats or other ways to perform sexual acts she did not want to in past 12 mos. by partner, frequency".
value labels dv_prtnr_threat_act_12m_f 0 "no" 1 "often" 2 "sometimes".
		
		
		
********************************************************************************	
**Current partner emotional violence: types of violence
********************************************************************************
	
*EXPERIENCED AND EMOTIONAL VIOLENCE.
*ever.
if v044=1 and v502>0 dv_prtnr_emot = 0.
do repeat x = d103a d103b d103c.
+if x>0 and x<=3 dv_prtnr_emot = 1.
end repeat.
variable labels dv_prtnr_emot "Any emotional violence by partner".
value labels dv_prtnr_emot 1 "yes" 0 "no".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_emot_12m = 0.
do repeat x = d103a d103b d103c.
+if x=1 or x=2 v_prtnr_emot_12m = 1.
end repeat.
variable labels dv_prtnr_emot_12m "Any emotional violence by partner in past 12 mos. by partner".
value labels dv_prtnr_emot_12m 1 "yes" 0 "no".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_emot_12m_f = 0.
do repeat x = 2 1.
if d103a=x dv_prtnr_emot_12m_f = x.
if d103b=x dv_prtnr_emot_12m_f = x.
if d103c=x dv_prtnr_emot_12m_f = x.
end repeat.
variable labels dv_prtnr_emot_12m_f "Any emotional violence by partner in past 12 mos. by partner, frequency".
value labels dv_prtnr_emot_12m_f 0 "no" 1 "often" 2 "sometimes".
		
		
*HUMILIATED IN FRONT OF OTHERS.
*ever.
if v044=1 and v502>0 dv_prtnr_humil = 0.
if d103a>0 and d103a<=3 dv_prtnr_humil = 1.
variable labels dv_prtnr_humil "Humiliated in front of others by partner".
value labels dv_prtnr_humil 1 "yes" 0 "no".

*in last 12 months.
if v044=1 and v502>0 dv_prtnr_humil_12m = 0.
if (d103a=1 or d103a=2) dv_prtnr_humil_12m = 1.
variable labels dv_prtnr_humil_12m "Humiliated in front of others in past 12 mos. by partner".
value labels dv_prtnr_humil_12m 1 "yes" 0 "no".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_humil_12m_f = 0.
if d103a=1 dv_prtnr_humil_12m_f = 1.
if d103a=2 dv_prtnr_humil_12m_f = 2.
variable labels dv_prtnr_humil_12m_f "Humiliated in front of others in past 12 mos. by partner, frequency".
value labels dv_prtnr_humil_12m_f 0 "no" 1 "often" 2 "sometimes".
		
		
		
*THREATENED TO HURT OR HARM HER OR SOMEONE SHE CARED ABOUT.
*ever.
if v044=1 and v502>0 dv_prtnr_threat = 0.
if d103b>0 and d103b<=3 dv_prtnr_threat = 1. 
variable labels dv_prtnr_threat "Threatened to hurt or harm her or someone she cared about by partner".
value labels dv_prtnr_threat 1 "yes" 0 "no".
		
*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_threat_12m = 0.
if (d103b=1 or d103b=2) dv_prtnr_threat_12m = 1.
variable labels dv_prtnr_threat_12m "Threatened to hurt or harm her or someone she cared about in past 12 mos. by partner".
value labels dv_prtnr_threat_12m 1 "yes" 0 "no".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_threat_12m_f = 0.
if d103b=1 dv_prtnr_threat_12m_f = 1. 
if d103b=2 dv_prtnr_threat_12m_f = 2.
variable labels dv_prtnr_threat_12m_f "Threatened to hurt or harm her or someone she cared about in past 12 mos. by partner, frequency".
value labels dv_prtnr_threat_12m_f 0 "no" 1 "often" 2 "sometimes".

		

*INSULTED OR MADE TO FEEL BAD ABOUT HERSELF.
*ever.
if v044=1 and v502>0 dv_prtnr_insult = 0. 
if d103c>0 and d103c<=3 dv_prtnr_insult = 1.
variable labels dv_prtnr_insult "Insulted or made to feel bad about herself by partner".
value labels dv_prtnr_insult 1 "yes" 0 "no".
		
*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_insult_12m = 0.
if (d103c=1 or d103c=2) dv_prtnr_insult_12m = 1.
variable labels dv_prtnr_insult_12m "Insulted or made to feel bad about herself in past 12 mos. by partner".
value labels dv_prtnr_insult_12m 1 "yes" 0 "no".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_insult_12m_f = 0.
if d103c=1 dv_prtnr_insult_12m_f = 1.
if d103c=2 dv_prtnr_insult_12m_f = 2. 
variable labels dv_prtnr_insult_12m_f "Insulted or made to feel bad about herself in past 12 mos. by partner, frequency".
value labels dv_prtnr_insult_12m_f 0 "no" 1 "often" 2 "sometimes".		
		
		
		
********************************************************************************	
**Combinations of types of violence
********************************************************************************
	
*EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE BY PARTNER.
*ever.
if v044=1 and v502>0 dv_prtnr_phy_sex = 0.
if (dv_prtnr_phy=1 and dv_prtnr_sex=1) dv_prtnr_phy_sex = 1.
variable labels dv_prtnr_phy_sex "Ever experienced physical and sexual violence by partner".
value labels dv_prtnr_phy_sex 1 "yes" 0 "no".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_phy_sex_12m = 0.
if (dv_prtnr_phy_12m=1 and dv_prtnr_sex_12m=1) dv_prtnr_phy_sex_12m = 1.
variable labels dv_prtnr_phy_sex_12m "Experienced physical and sexual violence by partner in the last 12 months".
value labels dv_prtnr_phy_sex_12m 1 "yes" 0 "no".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_phy_sex_12m_f = 0.
if (dv_prtnr_phy_12m=2 and dv_prtnr_sex_12m=2) dv_prtnr_phy_sex_12m_f = 2.
if (dv_prtnr_phy_12m=1 and dv_prtnr_sex_12m=1) dv_prtnr_phy_sex_12m_f = 1.
variable labels dv_prtnr_phy_sex_12m_f "Experienced physical and sexual violence by partner in the last 12 months, frequency".
value labels dv_prtnr_phy_sex_12m_f 0 "no" 1 "often" 2 "sometimes".	
		
		
*EXPERIENCED PHYSICAL AND SEXUAL AND EMOTIONAL VIOLENCE BY PARTNER.
*ever.
if v044=1 and v502>0 dv_prtnr_phy_sex_emot = 0. 
if (dv_prtnr_phy=1 and dv_prtnr_sex=1 and dv_prtnr_emot=1) dv_prtnr_phy_sex_emot = 1.
variable labels dv_prtnr_phy_sex_emot "Ever experienced physical and sexual and emotional violence by partner".
value labels dv_prtnr_phy_sex_emot 1 "yes" 0 "no".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_phy_sex_emot_12m = 0.
if (dv_prtnr_phy_12m=1 and dv_prtnr_sex_12m=1 and dv_prtnr_emot_12m=1) dv_prtnr_phy_sex_emot_12m = 1.
variable labels dv_prtnr_phy_sex_emot_12m "Experienced physical and sexual and emotional violence by partner in the last 12 months".
value labels dv_prtnr_phy_sex_emot_12m 1 "yes" 0 "no".
		
*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_phy_sex_emot_12m_f = 0.
if (dv_prtnr_phy_12m_f=2 and dv_prtnr_sex_12m_f=2 and  dv_prtnr_emot_12m_f=2) dv_prtnr_phy_sex_emot_12m_f = 2.
if (dv_prtnr_phy_12m_f=1 and dv_prtnr_sex_12m_f=1 and  dv_prtnr_emot_12m_f=1) dv_prtnr_phy_sex_emot_12m_f = 1.
variable labels dv_prtnr_phy_sex_emot_12m_f "Experienced physical and sexual and emotional violence by partner in the last 12 months, frequency".
value labels dv_prtnr_phy_sex_emot_12m_f 0 "no" 1 "often" 2 "sometimes".	

		
	
*EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE BY PARTNER.
*ever.
if v044=1 and v502>0 dv_prtnr_phy_sex_any = 0.
if (dv_prtnr_phy=1 or dv_prtnr_sex=1) dv_prtnr_phy_sex_any = 1.
variable labels dv_prtnr_phy_sex_any "Ever experienced physical OR sexual violence by partner".
value labels dv_prtnr_phy_sex_any 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_phy_sex_any_12m = 0.
if (dv_prtnr_phy_12m=1 or dv_prtnr_sex_12m=1) dv_prtnr_phy_sex_any_12m = 1. 
variable labels dv_prtnr_phy_sex_any_12m "Experienced physical OR sexual violence by partner in the last 12 months".
value labels dv_prtnr_phy_sex_any_12m 1 "yes" 0 "no".

*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_phy_sex_any_12m_f = 0.
if (dv_prtnr_phy_12m_f=2 or dv_prtnr_sex_12m_f=2) dv_prtnr_phy_sex_any_12m_f = 2.
if (dv_prtnr_phy_12m_f=1 or dv_prtnr_sex_12m_f=1) dv_prtnr_phy_sex_any_12m_f = 1.
variable labels dv_prtnr_phy_sex_any_12m_f"Experienced physical OR sexual violence by partner in the last 12 months, frequency".
value labels dv_prtnr_phy_sex_any_12m_f 0 "no" 1 "often" 2 "sometimes".
		
		
		
*EXPERIENCED PHYSICAL OR SEXUAL OR EMOTIONAL VIOLENCE BY PARTNER.
*ever.
if v044=1 and v502>0 dv_prtnr_phy_sex_emot_any = 0.
if (dv_prtnr_phy=1 or dv_prtnr_sex=1 or dv_prtnr_emot=1) dv_prtnr_phy_sex_emot_any = 1.
variable labels dv_prtnr_phy_sex_emot_any "Ever experienced physical OR sexual OR emotional violence by partner".
value labels dv_prtnr_phy_sex_emot_any 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_prtnr_phy_sex_emot_any_12m = 0. 
if (dv_prtnr_phy_12m=1 or dv_prtnr_sex_12m=1 or dv_prtnr_emot_12m=1) dv_prtnr_phy_sex_emot_any_12m = 1. 
variable labels dv_prtnr_phy_sex_emot_any_12m "Experienced physical OR sexual OR emotional violence by partner in the last 12 months".
value labels dv_prtnr_phy_sex_emot_any_12m 1 "yes" 0 "no".
	
*in the last 12 months by frequency (often or sometimes).
if v044=1 and v502>0 dv_prtnr_phy_sex_emot_any_12m_f = 0.
if (dv_prtnr_phy_12m_f=2 or dv_prtnr_sex_12m_f=2 or dv_prtnr_emot_12m_f=2) dv_prtnr_phy_sex_emot_any_12m_f = 2.
if (dv_prtnr_phy_12m_f=1 or dv_prtnr_sex_12m_f=1 or dv_prtnr_emot_12m_f=1) dv_prtnr_phy_sex_emot_any_12m_f = 1. 
variable labels dv_prtnr_phy_sex_emot_any_12m_f "Experienced physical OR sexual OR emotional violence by partner in the last 12 months, frequency".
value labels dv_prtnr_phy_sex_emot_any_12m_f 0 "no" 1 "often" 2 "sometimes".

		
********************************************************************************	
**Violence by ANY partner in the 12 months before the survey
********************************************************************************
	
*EXPERIENCED PHYSICAL VIOLENCE BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY.
*ever.
if v044=1 and v502>0 dv_aprtnr_phy = 0.
if (dv_prtnr_phy=1 or (d130a>0 and d130a<=3)) dv_aprtnr_phy = 1.
variable labels dv_aprtnr_phy "Experienced physical violence by any partner".
value labels dv_aprtnr_phy 0 "no" 1 "yes".

*in the last 12 months.
if v044=1 and v502>0 dv_aprtnr_phy_12m = 0.
if (dv_prtnr_phy_12m=1 or d130a=1) dv_aprtnr_phy_12m = 1.
variable labels dv_aprtnr_phy_12m "Experienced physical violence in past 12 mos. by any partner".
value labels  dv_aprtnr_phy_12m 0 "no" 1 "yes".

*EXPERIENCED SEXUAL VIOLENCE BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY.
*ever.
if v044=1 and v502>0 dv_aprtnr_sex = 0.
if (dv_prtnr_sex=1 or (d130b>0 and d130b<=3)) dv_aprtnr_sex = 1.
variable labels dv_aprtnr_sex "Experienced sexual violence by any partner".
value labels dv_aprtnr_sex 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_aprtnr_sex_12m = 0.
if (dv_prtnr_sex_12m=1 or d130b=1) dv_aprtnr_sex_12m = 1.
variable labels dv_aprtnr_sex_12m "Experienced sexual violence in past 12 mos. by any partner".
value labels dv_aprtnr_sex_12m 0 "no" 1 "yes".

	
	
*EXPERIENCED EMOTIONAL VIOLENCE BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY.
*ever.
if v044=1 and v502>0 dv_aprtnr_emot = 0.
if (dv_prtnr_emot=1 or (d130c>0 and d130c<=3)) dv_aprtnr_emot = 1.
variable labels dv_aprtnr_emot "Experienced emotional violence by any partner".
value labels dv_aprtnr_emot 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_aprtnr_emot_12m = 0.
if (dv_prtnr_emot_12m=1 or d130c=1) dv_aprtnr_emot_12m = 1.
variable labels dv_aprtnr_emot_12m "Experienced emotional violence in past 12 mos. by any partner".
value labels dv_aprtnr_emot_12m 0 "no" 1 "yes".


		
*EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE BY ANY PARTNER.
*ever.
if v044=1 and v502>0 dv_aprtnr_phy_sex = 0.
if (dv_aprtnr_phy=1 and dv_aprtnr_sex=1 ) dv_aprtnr_phy_sex = 1.
variable labels dv_aprtnr_phy_sex "Experienced physical AND sexual violence by any partner".
value labels dv_aprtnr_phy_sex 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_aprtnr_phy_sex_12m = 0.
if (dv_aprtnr_phy_12m=1 and dv_aprtnr_sex_12m=1) dv_aprtnr_phy_sex_12m = 1.
variable labels dv_aprtnr_phy_sex_12m "Experienced physical AND sexual violence in past 12 mos. by any partner".
value labels dv_aprtnr_phy_sex_12m 0 "no" 1 "yes".

		
		
*EXPERIENCED PHYSICAL AND SEXUAL VIOLENCE AND EMOTIONAL BY ANY PARTNER.
*ever.
if v044=1 and v502>0 dv_aprtnr_phy_sex_emot = 0.
if (dv_aprtnr_phy=1 and dv_aprtnr_sex=1 and dv_aprtnr_emot=1) dv_aprtnr_phy_sex_emot = 1.
variable labels dv_aprtnr_phy_sex_emot "Experienced physical AND sexual AND emotional violence by any partner".
value labels dv_aprtnr_phy_sex_emot 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_aprtnr_phy_sex_emot_12m = 0.
if (dv_aprtnr_phy_12m=1 and dv_aprtnr_sex_12m=1 and dv_aprtnr_emot_12m=1) dv_aprtnr_phy_sex_emot_12m = 1.	
variable labels dv_aprtnr_phy_sex_emot_12m "Experienced physical AND sexual AND emotional violence in past 12 mos. by any partner".
value labels dv_aprtnr_phy_sex_emot_12m 0 "no" 1 "yes".

	
	
*EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE BY ANY PARTNER.
*ever.
if v044=1 and v502>0 dv_aprtnr_phy_sex_any = 0.
if (dv_aprtnr_phy=1 or dv_aprtnr_sex=1) dv_aprtnr_phy_sex_any = 1.
variable labels dv_aprtnr_phy_sex_any "Experienced physical OR sexual violence by any partner".
value labels dv_aprtnr_phy_sex_any 0 "no" 1 "yes".
		
*in the last 12 months.
if v044=1 and v502>0 dv_aprtnr_phy_sex_any_12m = 0. 
if (dv_aprtnr_phy_12m=1 or dv_aprtnr_sex_12m=1) dv_aprtnr_phy_sex_any_12m = 1.
variable labels dv_aprtnr_phy_sex_any_12m "Experienced physical OR sexual violence in past 12 mos. by any partner".
value labels dv_aprtnr_phy_sex_any_12m 0 "no" 1 "yes".

		
		
*EXPERIENCED PHYSICAL OR SEXUAL VIOLENCE OR EMOTIONAL BY ANY PARTNER IN THE 12 MONTHS BEFORE SURVEY.
*ever.
if v044=1 and v502>0 dv_aprtnr_phy_sex_emot_any = 0.
if (dv_aprtnr_phy=1 or dv_aprtnr_sex=1 or dv_aprtnr_emot=1) dv_aprtnr_phy_sex_emot_any = 1.
variable labels dv_aprtnr_phy_sex_emot_any "Experienced physical OR sexual OR emotional violence by any partner".
value labels dv_aprtnr_phy_sex_emot_any 0 "no" 1 "yes".
	
*in the last 12 months.
if v044=1 and v502>0 dv_aprtnr_phy_sex_emot_any_12m = 0. 
if (dv_aprtnr_phy_12m=1 or dv_aprtnr_sex_12m=1 or dv_aprtnr_emot_12m=1) dv_aprtnr_phy_sex_emot_any_12m = 1. 
variable labels dv_aprtnr_phy_sex_emot_any_12m "Experienced physical OR sexual OR emotional violence in past 12 mos. by any partner".
value labels dv_aprtnr_phy_sex_emot_any_12m 0 "no" 1 "yes".


	
********************************************************************************
**Experience of violence by marital duration
********************************************************************************
*TIMING OF FIRST VIOLENT EVENT IN MARRIAGE (among married women who only married once).
*before marraige.
if v502=1 and v503=1 and v044=1 dv_mar_viol_0= 0. 
if d109=95 and v502=1 and v503=1 dv_mar_viol_0 = 1. 
variable labels dv_mar_viol_0 "Experience of violence by exact marriage duration: before marriage".
value labels dv_mar_viol_0 0 "other" 1 "before marriage".

*by 2 years of marriage.
if v502=1 and v503=1 and v044=1 dv_mar_viol_2= 0.
if (d109<2 or d109=95) and v502=1 and v503=1 dv_mar_viol_2 = 1.
variable labels dv_mar_viol_2 "Experience of violence by exact marriage duration: 2 yrs of marriage".
value labels dv_mar_viol_2 0 "other" 1 "by 2 years of marriage".
		
*by 5 years of marriage.
if v502=1 and v503=1 and v044=1 dv_mar_viol_5= 0. 
if (d109<5 or d109=95) and v502=1 and v503=1 dv_mar_viol_5 = 1.
variable labels dv_mar_viol_5 "Experience of violence by exact marriage duration: 5 yrs of marriage".
value labels dv_mar_viol_5 0 "other" 1 "by 5 years of marriage".

*by 10 years of marriage.
if v502=1 and v503=1 and v044=1 dv_mar_viol_10= 0.
if (d109<10 or d109=95) and v502=1 and v503=1 dv_mar_viol_10 = 1. 
variable labels dv_mar_viol_10 "Experience of violence by exact marriage duration: 10 yrs of marriage".
value labels dv_mar_viol_10 0 "other" 1 "by 10 years of marriage".		
		
		

********************************************************************************
**Injuries due to spousal violence
********************************************************************************
	
*cuts, bruises aches.
if v044=1 and v502>0 and dv_prtnr_phy_sex_any = 1 dv_prtnr_cuts = 0.
if d110a=1 dv_prtnr_cuts = 1.
variable labels dv_prtnr_cuts "Have cuts, bruises, or aches as a result of the violence by partner".
value labels dv_prtnr_cuts 0 "no" 1 "yes".

*eye injuries, sprains, dislocations, burns.
if v044=1 and v502>0 and dv_prtnr_phy_sex_any = 1 dv_prtnr_injury = 0.
if d110b=1 dv_prtnr_injury = 1.
variable labels dv_prtnr_injury "Have eye injuries, sprains, dislocations, or burns from violence by partner".
value labels dv_prtnr_injury 0 "no" 1 "yes".

*deep wounds, broken bones.
if v044=1 and v502>0 and dv_prtnr_phy_sex_any = 1 dv_prtnr_broken = 0.
if d110d=1 dv_prtnr_broken = 1.
variable labels dv_prtnr_broken "Deep wounds, broken bones/teeth, other serious injury from violence by partner".
value labels dv_prtnr_broken 0 "no" 1 "yes".

*any injury as result of partner violence.
if v044=1 and v502>0 and dv_prtnr_phy_sex_any = 1 dv_prtnr_injury_any = 0.
if d110a=1 or d110b=1 or d110d=1dv_prtnr_injury_any = 1.
variable labels dv_prtnr_injury_any	"Have any injury from violence by partner".
value labels dv_prtnr_injury_any 0 "no" 1 "yes".

		
		
********************************************************************************
**Initiation of spousal violence by women
********************************************************************************

*committed violence against partner.
if v044=1 and v502>0  dv_abusedhus_phy = 0.
if d112=1 or d112=2 dv_abusedhus_phy = 1.
variable labels dv_abusedhus_phy "Ever committed violence against partner when he was not already beating her".
value labels dv_abusedhus_phy 0 "no" 1 "yes".

*committed violence against partner in last 12 months.
if v044=1 and v502>0 dv_abusedhus_phy_12m = 0.
if d112a=1 or d112a=2 dv_abusedhus_phy_12m = 1.
variable labels dv_abusedhus_phy_12m "Committed violence against partner in past 12 mos. when he was not already beating her".
value labels dv_abusedhus_phy_12m 0 "no" 1 "yes".

