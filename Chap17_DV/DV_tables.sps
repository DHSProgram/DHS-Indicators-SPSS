* Encoding: UTF-8.
*****************************************************************************************************
Program: 			DV_tables.sps
Purpose: 			produce tables for domestic violence indicators
Author:				Ivana Bjelic
Date last modified: September 16 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_DV_viol:	Contains the tables for indicators of experiencing violence ever and help seeking
	2. 	Tables_DV_cntrl:	Contains the tables for marital control indicators
	3. 	Tables_DV_prtnr:	Contains the tables for indicators of experiencing violence by their partners ever and help seeking
*
Notes: 
*****************************************************************************************************/
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************.

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.
*
subgroups dv_age residence region marital work livingchild education wealth.

*generate weight variable.
compute wt = v005/1000000.
compute dwt = d005/1000000.

weight by dwt.

* create denominators.
compute num=1.
variable labels num "Number".

**************************************************************************************************
* Indicators for physical violence: excel file DV_tables will be produced
**************************************************************************************************
* EXPERIENCE OF PHYSICAL VIOLENCE (Tables_DV_viol)
* Experience of physical violence since age 15.
*by age.
*by residence.
*by region.
*by marital status.
*by working status.
*by number of living children.
*by education.
*by wealth.

ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_phy [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Experience of physical violence since age 15".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_phy
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Experience of physical violence in last 12 months.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_phy_12m [c] [rowpct.validn '' f5.1] + num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Experience of physical violence in last 12 months".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_phy_12m
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
* Physcial violence during pregnancy.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_phy_preg [c] [rowpct.validn '' f5.1] + dv_phy_preg [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Physcial violence during pregnancy".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_phy_preg
    /format = avalue tables
    /cells = row 
    /count asis.
	
**************************************************************************************************
* Persons committing physical violence.
* by current husband.
frequencies variables dv_phy_hus_curr.
* by former husband.
frequencies variables dv_phy_hus_form.
* by current boyfriend.
frequencies variables dv_phy_bf_curr .
* by former boyfriend.
frequencies variables dv_phy_bf_form.
* by father.
frequencies variables dv_phy_father.
* by mother.
frequencies variables dv_phy_mother.
* by sibling.
frequencies variables dv_phy_sibling.
* by child.
frequencies variables dv_phy_bychild.
* by other relative.
frequencies variables dv_phy_other_rel.
* by mother in law.
frequencies variables dv_phy_mother_inlaw.
* by father in law.
frequencies variables dv_phy_father_inlaw	.
* by other in law.
frequencies variables dv_phy_other_inlaw.
* by teacher.
frequencies variables dv_phy_teacher.
* by employer or someone at work.
frequencies variables dv_phy_atwork.
* by police or soldier.
frequencies variables dv_phy_police.
* by other.
frequencies variables dv_phy_other.

* by marital status.
crosstabs dv_phy_hus_curr dv_phy_hus_form dv_phy_bf_curr dv_phy_bf_form dv_phy_father 
               dv_phy_mother dv_phy_sibling dv_phy_bychild dv_phy_other_rel dv_phy_mother_inlaw 
               dv_phy_father_inlaw dv_phy_other_inlaw dv_phy_teacher dv_phy_atwork dv_phy_police by marital_2
    /format = avalue tables
    /cells = column 
    /count asis.
	
**************************************************************************************************
* EXPERIENCE OF SEXUAL VIOLENCE.
* Experience of sexual violence ever.
* ever.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_sex [c] [rowpct.validn '' f5.1] + dv_sex [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Experience of sexual violence - ever".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_sex
    /format = avalue tables
    /cells = row 
    /count asis.


* in last 12 months.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_sex_12m [c] [rowpct.validn '' f5.1] + dv_sex_12m [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Experience of sexual violence - in last 12 months".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_sex_12m
    /format = avalue tables
    /cells = row 
    /count asis.


**************************************************************************************************
* Persons committing sexual violence.
* by current husband.
frequencies variables dv_sex_hus_curr.
* by former husband.
frequencies variables dv_sex_hus_form.
* by current or former boyfriend.
frequencies variables dv_sex_bf .
* by father.
frequencies variables dv_sex_father.
* by sibling.
frequencies variables dv_sex_brother.
* by other relative.
frequencies variables dv_sex_other_rel.
* by in law.
frequencies variables dv_sex_inlaw.
* by friend.
frequencies variables dv_sex_friend.
*  by friend of the family.
frequencies variables dv_sex_friend_fam.
* by teacher.
frequencies variables dv_sex_teacher.
* by employer or someone at work.
frequencies variables dv_sex_atwork.
* by religious leader.
frequencies variables dv_sex_relig.
* by police or soldier.
frequencies variables dv_sex_police.
* by stranger.
frequencies variables dv_sex_stranger.
* by other.
frequencies variables dv_sex_other.
* missing.
frequencies variables dv_sex_missing.

* by marital status.
crosstabs dv_sex_hus_curr dv_sex_hus_form dv_sex_bf dv_sex_father dv_sex_brother
               dv_sex_other_rel dv_sex_inlaw dv_sex_friend dv_sex_friend_fam dv_sex_teacher
               dv_sex_atwork dv_sex_relig dv_sex_police dv_sex_stranger dv_sex_other dv_sex_missing by marital_2
    /format = avalue tables
    /cells = column 
    /count asis.


**************************************************************************************************
* Age at first experienced sexual violence.
ctables
  /table  dv_age [c] +
            marital_2 [c]
              by
         dv_sex_age_10 [c] [rowpct.validn '' f5.1] +
         dv_sex_age_12 [c] [rowpct.validn '' f5.1] + 
         dv_sex_age_15 [c] [rowpct.validn '' f5.1] + 
         dv_sex_age_18 [c] [rowpct.validn '' f5.1] + 
         dv_sex_age_22 [c] [rowpct.validn '' f5.1] + num [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Age at first experienced sexual violence".		

*crosstabs 
    /tables = dv_age marital_2 by dv_sex_age_10 dv_sex_age_12 dv_sex_age_15 dv_sex_age_18 dv_sex_age_22
    /format = avalue tables
    /cells = row 
    /count asis.	
	
**************************************************************************************************
* Experience of different forms of violence.
* ever physical violence.
* ever sexual violence.
* physical AND sexual violence.
* physical OR sexual violence.
* only physical, only sexual, or both.
ctables
  /table  dv_age [c] 
              by
         dv_phy_only [c] [rowpct.validn '' f5.1] + dv_sex_only [c] [rowpct.validn '' f5.1] + dv_phy_sex_any [c] [rowpct.validn '' f5.1] + dv_phy_sex [c] [rowpct.validn '' f5.1] + num [s][sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Experience of different forms of violence".		

*crosstabs 
    /tables = dv_age by dv_phy_only dv_sex_only dv_phy_sex_any dv_phy_sex
    /format = avalue tables
    /cells = row 
    /count asis.
	
********************************************************************************
* HELP SEEKING FOR THOSE EXPERIENCE VIOLENCE (Tables_DV_viol).
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_help_seek [c] [rowpct.validn '' f5.1] + dv_help_seek [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Help seeking for those experience violence".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_help_seek
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************	
* SOURCES OF HELP.
ctables
  /table  dv_help_fam [c] +
            dv_help_hfam [c] +
            dv_help_husb [c] +
            dv_help_bf [c] +
            dv_help_friend [c] +
            dv_help_neighbor [c] +
            dv_help_relig [c] +
            dv_help_doc [c] +
            dv_help_police [c] +
            dv_help_lawyer [c] +
            dv_help_sw [c] +
            dv_help_other [c]            
              by
         dv_viol_type [c] [colpct.validn '' f5.1] 
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Sources of help".		

*crosstabs 
    /tables = dv_help_fam dv_help_hfam dv_help_husb dv_help_bf dv_help_friend dv_help_neighbor dv_help_relig dv_help_doc dv_help_police dv_help_lawyer dv_help_sw dv_help_other by dv_viol_type
    /format = avalue tables
    /cells = column 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_DV_viol.xls"
     operation=createfile.

output close * .
	
**************************************************************************************************
* MARITAL CONTROL (Tables_DV_cntrl).
* partner jealous if spoke to other men.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_jeals [c] [rowpct.validn '' f5.1] + dv_prtnr_jeals [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: partner jealous if spoke to other men".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_jeals
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************	
* accused her of being unfaithful.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_accus [c] [rowpct.validn '' f5.1] + dv_prtnr_accus [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: accused her of being unfaithful".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_accus
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************	
* prevented her from meeting female friends.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_friends [c] [rowpct.validn '' f5.1] + dv_prtnr_friends [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: prevented her from meeting female friends".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_friends
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************
* tried to limit her contact with her family.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_fam [c] [rowpct.validn '' f5.1] + dv_prtnr_fam [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: tried to limit her contact with her family".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_fam
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************
* insisted on knowing where she is at all times.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_where [c] [rowpct.validn '' f5.1] + dv_prtnr_where [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: insisted on knowing where she is at all times".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_where
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************
* did not trust her with money.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_money [c] [rowpct.validn '' f5.1] + dv_prtnr_money [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: did not trust her with money".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_money
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************	
* displays 3 or more behaviors.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_cntrl_3 [c] [rowpct.validn '' f5.1] + dv_prtnr_cntrl_3 [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: displays 3 or more behaviors".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_cntrl_3
    /format = avalue tables
    /cells = row 
    /count asis.

********************************************************************************
* displays none of the behaviors.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
         dv_prtnr_cntrl_0 [c] [rowpct.validn '' f5.1] + dv_prtnr_cntrl_0 [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Marital control: displays none of the behaviors".		

*crosstabs 
    /tables = dv_age residence region marital work livingchild education wealth by dv_prtnr_cntrl_0
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_DV_cntrl.xls"
     operation=createfile.

output close * .

********************************************************************************
* TYPES OF SPOUSAL VIOLENCE (Tables_DV_prtnr).

********************************************************************************
* physical violence by recent/current partner.
ctables 
 /table dv_prtnr_phy [c] [colpct '' f5.1,count '' f5.0] + dv_prtnr_phy_12m [c] [colpct '' f5.1,count '' f5.0] + dv_prtnr_phy_12m_f  [c] [colpct '' f5.1,count '' f5.0] 
  /categories variables=all total=yes position=after label="Total"
  /titles title=
    "Physical violence by recent/current partner".	

*descriptives variables = dv_prtnr_phy dv_prtnr_phy_12m dv_prtnr_phy_12m_f .


********************************************************************************
* types of violence.
ctables 
 /table dv_prtnr_phy [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_push [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_slap [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_twist [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_punch [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_kick [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_choke [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_weapon [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_sex [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_force [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_force_act [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_threat_act [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_emot [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_humil [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_threat [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_insult [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_sex_any [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_sex_emot_any [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_push_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_slap_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_twist_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_punch_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_kick_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_choke_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_weapon_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_sex_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_force_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_force_act_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_threat_act_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_emot_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_humil_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_threat_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_insult_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_sex_any_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_sex_emot_any_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_push_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_slap_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_twist_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_punch_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_kick_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_choke_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_weapon_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_sex_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_force_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_force_act_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_threat_act_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_emot_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_humil_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_threat_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_insult_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_sex_any_12m_f [c] [colpct '' f5.1,count '' f5.0] + 
            dv_prtnr_phy_sex_emot_any_12m_f [c] [colpct '' f5.1,count '' f5.0] 
  /categories variables=all total=yes position=after label="Total"
  /titles title=
    "Types of violence".	

*descriptives variables =  dv_prtnr_phy dv_prtnr_push dv_prtnr_slap dv_prtnr_twist dv_prtnr_punch dv_prtnr_kick dv_prtnr_choke dv_prtnr_weapon dv_prtnr_sex dv_prtnr_force dv_prtnr_force_act 
            dv_prtnr_threat_act dv_prtnr_emot dv_prtnr_humil dv_prtnr_threat dv_prtnr_insult dv_prtnr_phy_sex_any dv_prtnr_phy_sex_emot_any dv_prtnr_phy_12m dv_prtnr_push_12m dv_prtnr_slap_12m 
            dv_prtnr_twist_12m dv_prtnr_punch_12m dv_prtnr_kick_12m dv_prtnr_choke_12m dv_prtnr_weapon_12m dv_prtnr_sex_12m dv_prtnr_force_12m dv_prtnr_force_act_12m dv_prtnr_threat_act_12m 
            dv_prtnr_emot_12m dv_prtnr_humil_12m dv_prtnr_threat_12m dv_prtnr_insult_12m dv_prtnr_phy_sex_any_12m dv_prtnr_phy_sex_emot_any_12m dv_prtnr_phy_12m_f dv_prtnr_push_12m_f 
            dv_prtnr_slap_12m_f dv_prtnr_twist_12m_f dv_prtnr_punch_12m_f dv_prtnr_kick_12m_f dv_prtnr_choke_12m_f dv_prtnr_weapon_12m_f dv_prtnr_sex_12m_f dv_prtnr_force_12m_f dv_prtnr_force_act_12m_f 
            dv_prtnr_threat_act_12m_f dv_prtnr_emot_12m_f dv_prtnr_humil_12m_f dv_prtnr_threat_12m_f dv_prtnr_insult_12m_f dv_prtnr_phy_sex_any_12m_f dv_prtnr_phy_sex_emot_any_12m_f.


********************************************************************************
* physical violence by any partner.

********************************************************************************
* types of violence.
ctables 
 /table dv_aprtnr_phy [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_sex [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_emot [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_phy_sex_any [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_phy_sex_emot_any [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_phy_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_sex_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_emot_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_phy_sex_any_12m [c] [colpct '' f5.1,count '' f5.0] + 
            dv_aprtnr_phy_sex_emot_any_12m [c] [colpct '' f5.1,count '' f5.0] 
  /categories variables=all total=yes position=after label="Total"
  /titles title=
    "Types of violence".	

*descriptives variables = dv_aprtnr_phy dv_aprtnr_sex dv_aprtnr_emot dv_aprtnr_phy_sex_any dv_aprtnr_phy_sex_emot_any dv_aprtnr_phy_12m dv_aprtnr_sex_12m dv_aprtnr_emot_12m dv_aprtnr_phy_sex_any_12m dv_aprtnr_phy_sex_emot_any_12m.

ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
            dv_prtnr_phy [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_sex [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_emot [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex_emot [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex_any [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex_emot_any [c] [rowpct.validn '' f5.1] +
            num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Types of violence".	

*crosstabs dv_age 
            residence
            region
            marital
            work 
            livingchild
            education
            wealth 
              by
            dv_prtnr_phy  
            dv_prtnr_sex  
            dv_prtnr_emot  
            dv_prtnr_phy_sex  
            dv_prtnr_phy_sex_emot  
            dv_prtnr_phy_sex_any  
            dv_prtnr_phy_sex_emot_any
                /format = avalue tables
                /cells = row 
                /count asis.
	
********************************************************************************
* violence by empowerment indicators.
ctables
  /table  husb_edu [c] +                 /* by husband's education
            husb_drink [c] +               /* by husband's alcohol consumption
            edu_diff [c] +                    /* by spousal education difference
            age_diff [c] +                    /* by spousal age difference
            dv_prtnr_cntrl_cat [c] +     /* by marital control behaviors
            decisions [c] +                 /* by decisions women participate in
            beating [c] +                    /* by reasons husband's beating is justified
            father_beat [c] +               /* by father beat mother
            afraid [c]                          /* by fear of husband
              by
            dv_prtnr_phy [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_sex [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_emot [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex_emot [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex_any [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_phy_sex_emot_any [c] [rowpct.validn '' f5.1] +
            num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Violence by empowerment indicators".	

*crosstabs husb_edu            /* by husband's education
            husb_drink              /* by husband's alcohol consumption
            edu_diff                   /* by spousal education difference
            age_diff                   /* by spousal age difference
            dv_prtnr_cntrl_cat    /* by marital control behaviors
            decisions                /* by decisions women participate in
            beating                   /* by reasons husband's beating is justified
            father_beat              /* by father beat mother
            afraid                      /* by fear of husband
              by
            dv_prtnr_phy 
            dv_prtnr_sex 
            dv_prtnr_emot 
            dv_prtnr_phy_sex 
            dv_prtnr_phy_sex_emot 
            dv_prtnr_phy_sex_any 
            dv_prtnr_phy_sex_emot_any
                  /format = avalue tables
                  /cells = row 
                  /count asis.

********************************************************************************
* violence by any partner in last 12 months.
ctables
  /table  dv_age [c] +
            residence [c] +
            region [c] +
            marital [c] +
            work [c] +
            livingchild [c] +
            education [c] +
            wealth [c]
              by
            dv_aprtnr_phy_12m [c] [rowpct.validn '' f5.1] + 
            dv_aprtnr_sex_12m [c] [rowpct.validn '' f5.1] + 
            dv_aprtnr_emot_12m [c] [rowpct.validn '' f5.1] + 
            dv_aprtnr_phy_sex_12m [c] [rowpct.validn '' f5.1] + 
            dv_aprtnr_phy_sex_emot_12m [c] [rowpct.validn '' f5.1] + 
            dv_aprtnr_phy_sex_any_12m [c] [rowpct.validn '' f5.1] + 
            dv_aprtnr_phy_sex_emot_any_12m [c] [rowpct.validn '' f5.1] +
            num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Violence by any partner in last 12 months".	

*crosstabs dv_age 
            residence
            region
            marital
            work 
            livingchild
            education
            wealth 
              by
            dv_aprtnr_phy_12m  
            dv_aprtnr_sex_12m  
            dv_aprtnr_emot_12m  
            dv_aprtnr_phy_sex_12m  
            dv_aprtnr_phy_sex_emot_12m  
            dv_aprtnr_phy_sex_any_12m  
            dv_aprtnr_phy_sex_emot_any_12m
                /format = avalue tables
                /cells = row 
                /count asis.

********************************************************************************
* violence by duration of marriage.
ctables
  /table  mar_years [c]             /* by years of marriage
              by
            dv_mar_viol_0 [c] [rowpct.validn '' f5.1] + 
            dv_mar_viol_2 [c] [rowpct.validn '' f5.1] + 
            dv_mar_viol_5 [c] [rowpct.validn '' f5.1] + 
            dv_mar_viol_10 [c] [rowpct.validn '' f5.1] +
            num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Violence by duration of marriage".

*crosstabs mar_years 
              by
            dv_mar_viol_0  
            dv_mar_viol_2 
             dv_mar_viol_5
            dv_mar_viol_10
                /format = avalue tables
                /cells = row 
                /count asis.

********************************************************************************
* injuries due to spousal violence.
ctables
  /table  dv_phy [c] +                           /* by ever experienced physical violence
            dv_phy_12m  [c] +                  /* by ever experienced physical violence
            dv_sex [c] +                           /* by ever experienced physical violence
            dv_sex_12m  [c] +                  /* by ever experienced physical violence
            dv_phy_sex_any [c] +             /* by ever experienced physical violence
            dv_phy_sex_any_12m [c]        /* by ever experienced physical violence
              by
            dv_prtnr_cuts [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_injury [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_broken [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_injury_any [c] [rowpct.validn '' f5.1] +
            num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Injuries due to spousal violence".

*crosstabs dv_phy                          /* by ever experienced physical violence
            dv_phy_12m                      /* by ever experienced physical violence
            dv_sex                              /* by ever experienced sexual violence
            dv_sex_12m                      /* by ever experienced sexual violence in last 12 months
            dv_phy_sex_any                /* by ever experienced physical OR sexual violence
            dv_phy_sex_any_12m        /* by ever experienced physical OR sexual violence in last 12 months
              by
            dv_prtnr_cuts  
            dv_prtnr_injury 
            dv_prtnr_broken
            dv_prtnr_injury_any
                /format = avalue tables
                /cells = row 
                /count asis.

********************************************************************************
*injuries due to spousal violence.
ctables
  /table  dv_prtnr_phy [c] +                           /* by every experienced physical violence by partner
            dv_prtnr_phy_12m  [c] +                  /* by every experienced physical violence by partner
            dv_prtnr_sex [c] +                           /* by every experienced sexual violence by partner
            dv_prtnr_sex_12m  [c] +                  /* by every experienced sexual violence by partner in last 12 months 
            dv_prtnr_phy_sex_any [c] +             /* by every experienced physical OR sexual violence by partner
            dv_prtnr_phy_sex_any_12m [c]        /* by every experienced physical OR sexual violence by partner in last 12 months
              by
            dv_prtnr_cuts [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_injury [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_broken [c] [rowpct.validn '' f5.1] + 
            dv_prtnr_injury_any [c] [rowpct.validn '' f5.1] +
            num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Injuries due to spousal violence".

*crosstabs dv_prtnr_phy                           /* by every experienced physical violence by partner
            dv_prtnr_phy_12m                       /* by every experienced physical violence by partner
            dv_prtnr_sex                               /* by every experienced sexual violence by partner
            dv_prtnr_sex_12m                      /* by every experienced sexual violence by partner in last 12 months 
            dv_prtnr_phy_sex_any                 /* by every experienced physical OR sexual violence by partner
            dv_prtnr_phy_sex_any_12m         /* by every experienced physical OR sexual violence by partner in last 12 months
              by
            dv_prtnr_cuts  
            dv_prtnr_injury 
            dv_prtnr_broken
            dv_prtnr_injury_any
                /format = avalue tables
                /cells = row 
                /count asis.

********************************************************************************
* INITIATE VIOLENCE AGAINST HUSBAND.
ctables
  /table  dv_prtnr_phy [c] +                           /* by ever experienced spousal physical violence 
            dv_prtnr_phy_12m  [c] +                  /* by experienced spousal physical violence in last 12 mos
            dv_age [c] +                                   /* by age
            residence [c] +                               /* by residence 
            region [c] +                                    /* by region
            marital [c] +                                   /* by marital status
            work [c] +                                      /* by working status
            livingchild [c] +                               /* by number of living children
            education [c] +                               /* by education
            wealth [c] +                                    /* by wealth
            husb_edu [c] +                               /* by  husband’s/partner’s education
            husb_drink [c] +                             /* by husband’s/partner’s alcohol consumption
            edu_diff [c] +                                  /* by spousal education difference
            age_diff [c] +                                  /* by spousal age difference
            dv_prtnr_cntrl_cat [c] +                    /* by number of marital control behaviours displayed by husband/partner
            decisions [c] +                               /* by number of decisions in which women participate
            beating [c] +                                  /* by number of reasons for which wife beating is justified
            father_beat [c] +                             /* by father beat mother
            afraid [c]                                        /* by woman afraid of husband/partner
              by
            dv_abusedhus_phy [c] [rowpct.validn '' f5.1] + 
            dv_abusedhus_phy_12m [c] [rowpct.validn '' f5.1] +
            num [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Initiate violence against husband".

*crosstabs  dv_prtnr_phy                    /* by ever experienced spousal physical violence 
            dv_prtnr_phy_12m                 /* by experienced spousal physical violence in last 12 mos
            dv_age                                  /* by age
            residence                              /* by residence 
            region                                   /* by region
            marital                                  /* by marital status
            work                                     /* by working status
            livingchild                              /* by number of living children
            education                              /* by education
            wealth                                   /* by wealth
            husb_edu                              /* by  husband’s/partner’s education
            husb_drink                            /* by husband’s/partner’s alcohol consumption
            edu_diff                                 /* by spousal education difference
            age_diff                                 /* by spousal age difference
            dv_prtnr_cntrl_cat                   /* by number of marital control behaviours displayed by husband/partner
            decisions                               /* by number of decisions in which women participate
            beating                                  /* by number of reasons for which wife beating is justified
            father_beat                             /* by father beat mother
            afraid                                     /* by woman afraid of husband/partner
              by
            dv_abusedhus_phy
            dv_abusedhus_phy_12m
                /format = avalue tables
                /cells = row 
                /count asis.


****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="Tables_DV_prtnr.xls"
     operation=createfile.

output close * .


new file.
