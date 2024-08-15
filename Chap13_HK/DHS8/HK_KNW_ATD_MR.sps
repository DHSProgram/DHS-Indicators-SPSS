* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HK_KNW_ATD_MR.sps
Purpose: 			Code to compute HIV-AIDS related knowledge and attitude indicators 
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: November 28, 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women. No age selection is made here.

*					Indicator hk_knw_hiv_hlth_2miscp (line 88) is country specific, please check the final report for the two most common misconceptions. 
*					Currently coded as rejecting that HIV can be transmitted by mosquito bites and supernatural means.			
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
hk_ever_heard		"Have ever heard of HIV or AIDS"
hk_knw_risk_cond		"Know you can reduce HIV risk by using condoms at every sex"
hk_knw_risk_sex		"Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners"
hk_knw_risk_condsex		"Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner"
hk_knw_hiv_hlth		"Know that a healthy looking person can have HIV"
hk_knw_hiv_mosq		"Know that HIV cannot be transmitted by mosquito bites"
hk_knw_hiv_supernat		"Know that HIV cannot be transmitted by supernatural means"
hk_knw_hiv_food		"Know that cannot become infected by sharing food with a person who has HIV"
hk_knw_hiv_hlth_2miscp	                  "Know that a healthy looking person can have HIV and reject the two most common local misconceptions"
hk_knw_comphsv		"Have comprehensive knowledge about HIV"
*	
hk_knw_mtct_preg		"Know that HIV mother to child transmission can occur during pregnancy"
hk_knw_mtct_deliv		"Know that HIV mother to child transmission can occur during delivery"
hk_knw_mtct_brfeed		"Know that HIV mother to child transmission can occur by breastfeeding"
hk_knw_mtct_all3		"Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding"
hk_knw_mtct_meds		"Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs"
*	
hk_atd_child_nosch		"Think that children living with HIV should not go to school with HIV negative children"
hk_atd_shop_notbuy		"Would not buy fresh vegetables from a shopkeeper who has HIV"
hk_atd_discriminat		"Have discriminatory attitudes towards people living with HIV"
----------------------------------------------------------------------------.

* indicators from MR file.

*** HIV related knowledge ***
*Ever heard of HIV/AIDS.
compute hk_ever_heard=0.
if (mv751=1) hk_ever_heard=1.
variable labels hk_ever_heard "Have ever heard of HIV or AIDS".
value labels  hk_ever_heard 0"No" 1"Yes".

*Know reduce risk - use condoms.
compute hk_knw_risk_cond=0.
if  (mv754cp=1) hk_knw_risk_cond=1.
variable labels hk_knw_risk_cond "Know you can reduce HIV risk by using condoms at every sex".
value labels  hk_knw_risk_cond 0"No" 1"Yes".

*Know reduce risk - limit to one partner.
compute hk_knw_risk_sex=0.
if (mv754dp=1) hk_knw_risk_sex=1.
variable labels hk_knw_risk_sex "Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners".
value labels  hk_knw_risk_sex 0"No" 1"Yes".

*Know reduce risk - use condoms and limit to one partner.
compute hk_knw_risk_condsex=0.
if (mv754cp=1 & mv754dp=1) hk_knw_risk_condsex=1.
variable labels hk_knw_risk_condsex "Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner".
value labels  hk_knw_risk_condsex 0"No" 1"Yes".

*Know healthy person can have HIV.
compute hk_knw_hiv_hlth=0.
if  (mv756=1) hk_knw_hiv_hlth=1.
variable labels hk_knw_hiv_hlth "Know that a healthy looking person can have HIV".
value labels  hk_knw_hiv_hlth 0"No" 1"Yes".

*Know HIV cannot be transmitted by mosquito bites.
compute hk_knw_hiv_mosq=0.
if  (mv754jp=0) hk_knw_hiv_mosq=1.
variable labels hk_knw_hiv_mosq "Know that HIV cannot be transmitted by mosquito bites".
value labels  hk_knw_hiv_mosq 0"No" 1"Yes".

*Know HIV cannot be transmitted by supernatural means.
compute hk_knw_hiv_supernat=0.
if  (mv823=0) hk_knw_hiv_supernat=1.
variable labels hk_knw_hiv_supernat "Know that HIV cannot be transmitted by supernatural means".
value labels  hk_knw_hiv_supernat 0"No" 1"Yes".

*Know HIV cannot be transmitted by sharing food with HIV infected person.
compute hk_knw_hiv_food=0.
if  (mv754wp=0) hk_knw_hiv_food=1.
variable labels hk_knw_hiv_food "Know that cannot become infected by sharing food with a person who has HIV".
value labels  hk_knw_hiv_food 0"No" 1"Yes".

*Know healthy person can have HIV and reject two common local misconceptions.
compute hk_knw_hiv_hlth_2miscp=0.
if (mv756=1 & mv754jp=0 & mv823=0) hk_knw_hiv_hlth_2miscp=1.
variable labels hk_knw_hiv_hlth_2miscp "Know that a healthy looking person can have HIV and reject the two most common local misconceptions".
value labels  hk_knw_hiv_hlth_2miscp 0"No" 1"Yes".

*HIV comprehensive knowledge.
compute hk_knw_comphsv=0.
if  (mv754cp=1 & mv754dp=1 & mv756=1 & mv754jp=0 & mv823=0) hk_knw_comphsv=1.
variable labels hk_knw_comphsv "Have comprehensive knowledge about HIV".
value labels  hk_knw_comphsv 0"No" 1"Yes".

*Know that HIV MTCT can occur during pregnancy.
compute hk_knw_mtct_preg=0.
if  (mv774a=1) hk_knw_mtct_preg=1.
variable labels hk_knw_mtct_preg "Know that HIV mother to child transmission can occur during pregnancy".
value labels  hk_knw_mtct_preg 0"No" 1"Yes".

*Know that HIV MTCT can occur during delivery.
compute hk_knw_mtct_deliv=0.
if  (mv774b=1) hk_knw_mtct_deliv=1.
variable labels hk_knw_mtct_deliv "Know that HIV mother to child transmission can occur during delivery".
value labels  hk_knw_mtct_deliv 0"No" 1"Yes".

*Know that HIV MTCT can occur during breastfeeding.
compute hk_knw_mtct_brfeed=0.
if  (mv774c=1) hk_knw_mtct_brfeed=1.
variable labels hk_knw_mtct_brfeed "Know that HIV mother to child transmission can occur by breastfeeding".
value labels  hk_knw_mtct_brfeed 0"No" 1"Yes".

*Know all three HIV MTCT.
compute  hk_knw_mtct_all3=0.
if (mv774a=1 & mv774b=1 & mv774c=1)  hk_knw_mtct_all3=1.
variable labels hk_knw_mtct_all3 "Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding".
value labels  hk_knw_mtct_all3 0"No" 1"Yes".

*Know risk of HIV MTCT can be reduced by meds.
compute hk_knw_mtct_meds=0.
if (mv824=1) hk_knw_mtct_meds=1.
variable labels hk_knw_mtct_meds "Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs".
value labels  hk_knw_mtct_meds 0"No" 1"Yes".

*** Attitudes ***

*Think that children with HIV should not go to school with HIV negative children.
do if mv751<>0.
+compute hk_atd_child_nosch=0.
+if  (mv857a=0) hk_atd_child_nosch=1.
end if.
variable labels hk_atd_child_nosch "Think that children living with HIV should not go to school with HIV negative children".
value labels  hk_atd_child_nosch 0"No" 1"Yes".

*Would not buy fresh vegetabels from a shopkeeper who has HIV.
do if mv751<>0.
+compute hk_atd_shop_notbuy=0.
+if  (mv825=0) hk_atd_shop_notbuy=1.
end if.
variable labels hk_atd_shop_notbuy "Would not buy fresh vegetables from a shopkeeper who has HIV".
value labels  hk_atd_shop_notbuy 0"No" 1"Yes".

*Have discriminatory attitudes towards people living with HIV-AIDS.
do if mv751<>0.
+compute hk_atd_discriminat=0.
+if  (mv857a=0 | mv825=0) hk_atd_discriminat=1.
end if.
variable labels hk_atd_discriminat "Have discriminatory attitudes towards people living with HIV".
value labels  hk_atd_discriminat 0"No" 1"Yes".
