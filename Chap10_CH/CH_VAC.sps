* Encoding: windows-1252.
******************************************************************************************************
Program: 			CH_VAC.sps
Purpose: 			Code vaccination variables.
 * Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: September 02 2019 by Ivana Bjelic. 
 * Notes:				Estimates can be created for two age groups (12-23) and (24-35). 
					
 * 					!! Please choose the age group of interest in line 100.
					
 * 					Vaccination indicators are country specific. However, most common vaccines are coded below and the same logic can be applied to others.
 * 					When the vaccine is a single dose, the logic for single dose vaccines can be used (ex: bcg).
 * 					When the vaccine has 3 doses, the logic for multiple dose vaccines can be used (ex: dpt)
*****************************************************************************************************.
*----------------------------------------------------------------------------
Variables created in this file:
ch_bcg_card		"BCG vaccination according to card"
ch_bcg_moth		"BCG vaccination according to mother"
ch_bcg_either		"BCG vaccination according to either source"
*
ch_pent1_card		"Pentavalent 1st dose vaccination according to card"
ch_pent1_moth		"Pentavalent 1st dose vaccination according to mother"
ch_pent1_either		"Pentavalent 1st dose vaccination according to either source"
ch_pent2_card		"Pentavalent 2nd dose vaccination according to card"
ch_pent2_moth		"Pentavalent 2nd dose vaccination according to mother"
ch_pent2_either		"Pentavalent 2nd dose vaccination according to either source"
ch_pent3_card		"Pentavalent 3rd dose vaccination according to card"
ch_pent3_moth		"Pentavalent 3rd dose vaccination according to mother"
ch_pent3_either		"Pentavalent 3rd dose vaccination according to either source"
*
ch_polio0_card		"Polio at birth vaccination according to card"
ch_polio0_moth		"Polio at birth vaccination according to mother"
ch_polio0_either                	"Polio at birth vaccination according to either source"
ch_polio1_card		"Polio 1st dose vaccination according to card"
ch_polio1_moth		"Polio 1st dose vaccination according to mother"
ch_polio1_either                	"Polio 1st dose vaccination according to either source"
ch_polio2_card		"Polio 2nd dose vaccination according to card"
ch_polio2_moth		"Polio 2nd dose vaccination according to mother"
ch_polio2_either                	"Polio 2nd dose vaccination according to either source"
ch_polio3_card		"Polio 3rd dose vaccination according to card"
ch_polio3_moth		"Polio 3rd dose vaccination according to mother"
ch_polio3_either                	"Polio 3rd dose vaccination according to either source"
*
ch_peumo1_card		"Peumococcal 1st dose vaccination according to card"
ch_peumo1_moth		"Peumococcal 1st dose vaccination according to mother"
ch_peumo1_either            	"Peumococcal 1st dose vaccination according to either source"
ch_peumo2_card		"Peumococcal 2nd dose vaccination according to card"
ch_peumo2_moth		"Peumococcal 2nd dose vaccination according to mother"
ch_peumo2_either            	"Peumococcal 2nd dose vaccination according to either source"
ch_peumo3_card		"Peumococcal 3rd dose vaccination according to card"
ch_peumo3_moth		"Peumococcal 3rd dose vaccination according to mother"
ch_peumo3_either            	"Peumococcal 3rd dose vaccination according to either source"
*
ch_rotav1_card		"Rotavirus 1st dose vaccination according to card"
ch_rotav1_moth		"Rotavirus 1st dose vaccination according to mother"
ch_rotav1_either                	"Rotavirus 1st dose vaccination according to either source"
ch_rotav2_card		"Rotavirus 2nd dose vaccination according to card"
ch_rotav2_moth		"Rotavirus 2nd dose vaccination according to mother"
ch_rotav2_either                	"Rotavirus 2nd dose vaccination according to either source"
ch_rotav3_card		"Rotavirus 3rd dose vaccination according to card"
ch_rotav3_moth		"Rotavirus 3rd dose vaccination according to mother"
ch_rotav3_either                	"Rotavirus 3rd dose vaccination according to either source"
*
ch_meas_card		"Measles vaccination according to card"
ch_meas_moth		"Measles vaccination according to mother"
ch_meas_either		"Measles vaccination according to either source"
*
ch_allvac_card		"All basic vaccinations according to card"
ch_allvac_moth		"All basic vaccinations according to mother"
ch_allvac_either                	"All basic vaccinations according to either source"
*
ch_novac_card		"No vaccinations according to card"
ch_novac_moth		"No vaccinations according to mother"
ch_novac_either		"No vaccinations according to either source"
*
ch_card_ever_had            	"Ever had a vacciation card"
ch_card_seen		"Vaccination card seen"
----------------------------------------------------------------------------*.

*** Two age groups used for reporting. 
* choose age group of interest.	

compute agegroup=0.
if age>=12 & age<=23 agegroup=1.

* compute agegroup=0.
* if age>=24 & age<=35 agegroup=1.

* selecting children.
compute filter = (agegroup=1 & b5=1).
filter by filter.
*******************************************************************************

* Source of vaccination information. We need this variable to code vaccination indicators by source.
recode h1 (1=1) (else=2) into source.
variable labels source "Source of vaccination information".
value labels source 1 "card" 2 "mother".

*** BCG ***
*BCG either source.
recode h2 (0,8=0) (else=1) into ch_bcg_either.

*BCG mother's report.
compute ch_bcg_moth=ch_bcg_either.
if source=1 ch_bcg_moth=0.

*BCG by card.
compute ch_bcg_card=ch_bcg_either.
if source=2 ch_bcg_card=0.

variable labels ch_bcg_card	"BCG vaccination according to card".
variable labels ch_bcg_moth	"BCG vaccination according to mother".
variable labels ch_bcg_either	"BCG vaccination according to either source".
value labels ch_bcg_card ch_bcg_moth ch_bcg_either 0 "No" 1 "Yes".

*** Pentavalent ***.
*DPT 1, 2, 3 either source.
recode h3 (0,8=0 ) (else=1) into dpt1.
recode h5 (0,8=0 ) (else=1) into dpt2.
recode h7 (0,8=0 ) (else=1) into dpt3.
compute dptsum= dpt1+dpt2+dpt3.

* this step is performed for multi-dose vaccines to take care of any gaps in the vaccination history. See DHS guide to statistics 
* for further explanation. 
compute ch_pent1_either=(dptsum>=1).
compute ch_pent2_either=(dptsum>=2).
compute ch_pent3_either=(dptsum>=3).

*DPT 1, 2, 3 mother's report.
compute ch_pent1_moth=ch_pent1_either.
if source=1 ch_pent1_moth=0.

compute ch_pent2_moth=ch_pent2_either.
if source=1 ch_pent2_moth=0.

compute ch_pent3_moth=ch_pent3_either.
if source=1 ch_pent3_moth=0.

*DPT 1, 2, 3 by card.
compute ch_pent1_card=ch_pent1_either.
if source=2 ch_pent1_card=0. 

compute ch_pent2_card=ch_pent2_either.
if source=2 ch_pent2_card=0.

compute ch_pent3_card=ch_pent3_either.
if source=2 ch_pent3_card=0.

execute.
delete variables dpt1 dpt2 dpt3 dptsum.

variable labels ch_pent1_card	"Pentavalent 1st dose vaccination according to card".
variable labels ch_pent1_moth	"Pentavalent 1st dose vaccination according to mother".
variable labels ch_pent1_either       "Pentavalent 1st dose vaccination according to either source".
variable labels ch_pent2_card	"Pentavalent 2nd dose vaccination according to card".
variable labels ch_pent2_moth	"Pentavalent 2nd dose vaccination according to mother".
variable labels ch_pent2_either       "Pentavalent 2nd dose vaccination according to either source".
variable labels ch_pent3_card	"Pentavalent 3rd dose vaccination according to card".
variable labels ch_pent3_moth	"Pentavalent 3rd dose vaccination according to mother".
variable labels ch_pent3_either	"Pentavalent 3rd dose vaccination according to either source".
value labels ch_pent1_card  ch_pent1_moth ch_pent1_either ch_pent2_card ch_pent2_moth ch_pent2_either ch_pent3_card ch_pent3_moth ch_pent3_either 0 "No" 1 "Yes".

*** Polio ***.

*polio 0, 1, 2, 3 either source.
recode h0 (0,8=0 ) (else=1) into ch_polio0_either.

recode h4 (0,8=0 ) (else=1) into polio1.
recode h6 (0,8=0 ) (else=1) into polio2.
recode h8 (0,8=0 ) (else=1) into polio3.
compute poliosum=polio1 + polio2 + polio3.

* this step is performed for multi-dose vaccines to take care of any gaps in the vaccination history. See DHS guide to statistics 
* for further explanation.
compute ch_polio1_either=(poliosum>=1).
compute ch_polio2_either=(poliosum>=2).
compute ch_polio3_either=(poliosum>=3).

*polio 0, 1, 2, 3 mother's report.
compute ch_polio0_moth=ch_polio0_either.
if source=1 ch_polio0_moth=0.

compute ch_polio1_moth=ch_polio1_either.
if source=1 ch_polio1_moth=0.

compute ch_polio2_moth=ch_polio2_either.
if source=1 ch_polio2_moth=0.

compute ch_polio3_moth=ch_polio3_either.
if source=1 ch_polio3_moth=0.

*polio 0, 1, 2, 3 by card.
compute ch_polio0_card=ch_polio0_either.
if source=2 ch_polio0_card=0.

compute ch_polio1_card=ch_polio1_either.
if source=2 ch_polio1_card=0.

compute ch_polio2_card=ch_polio2_either.
if source=2 ch_polio2_card=0.

compute ch_polio3_card=ch_polio3_either.
if source=2 ch_polio3_card=0.

execute.
delete variables poliosum polio1 polio2 polio3.

variable labels ch_polio0_card "Polio at birth vaccination according to card".
variable labels ch_polio0_moth "Polio at birth vaccination according to mother".
variable labels ch_polio0_either "Polio at birth vaccination according to either source".
variable labels ch_polio1_card "Polio 1st dose vaccination according to card".
variable labels ch_polio1_moth "Polio 1st dose vaccination according to mother".
variable labels ch_polio1_either "Polio 1st dose vaccination according to either source".
variable labels ch_polio2_card "Polio 2nd dose vaccination according to card".
variable labels ch_polio2_moth "Polio 2nd dose vaccination according to mother".
variable labels ch_polio2_either "Polio 2nd dose vaccination according to either source".
variable labels ch_polio3_card "Polio 3rd dose vaccination according to card".
variable labels ch_polio3_moth "Polio 3rd dose vaccination according to mother".
variable labels ch_polio3_either "Polio 3rd dose vaccination according to either source".
value labels ch_polio0_card ch_polio0_moth ch_polio0_either ch_polio1_card ch_polio1_moth ch_polio1_either ch_polio2_card ch_polio2_moth ch_polio2_either ch_polio3_card ch_polio3_moth ch_polio3_either 0 "No" 1 "Yes".

*** Pneumococcal  ***
*Pneumococcal 1, 2, 3 either source.
* for surveys that do not have information on this vaccine.
compute h54=$sysmis.
compute h55=$sysmis.
compute h56=$sysmis.

recode h54 (0,8=0 ) (else=1) into peumo1.
recode h55 (0,8=0 ) (else=1) into peumo2.
recode h56 (0,8=0 ) (else=1) into peumo3.
compute peumosum= peumo1+peumo2+peumo3.

* this step is performed for multi-dose vaccines to take care of any gaps in the vaccination history. See DHS guide to statistics 
* for further explanation.
compute ch_peumo1_either=(peumosum>=1).
compute ch_peumo2_either=(peumosum>=2).
compute ch_peumo3_either=(peumosum>=3).

*Pneumococcal 1, 2, 3 mother's report.
compute ch_peumo1_moth=ch_peumo1_either.
if source=1 ch_peumo1_moth=0.

compute ch_peumo2_moth=ch_peumo2_either.
if source=1 ch_peumo2_moth=0.

compute ch_peumo3_moth=ch_peumo3_either.
if source=1 ch_peumo3_moth=0.

*Pneumococcal 1, 2, 3 by card.
compute ch_peumo1_card=ch_peumo1_either.
if source=2 ch_peumo1_card=0.

compute ch_peumo2_card=ch_peumo2_either.
if source=2 ch_peumo2_card=0.

compute ch_peumo3_card=ch_peumo3_either.
if source=2 ch_peumo3_card=0.

execute.
delete variables peumo1 peumo2 peumo3 peumosum.

variable labels ch_peumo1_card "Peumococcal 1st dose vaccination according to card".
variable labels ch_peumo1_moth "Peumococcal 1st dose vaccination according to mother".
variable labels ch_peumo1_either "Peumococcal 1st dose vaccination according to either source".
variable labels ch_peumo2_card "Peumococcal 2nd dose vaccination according to card".
variable labels ch_peumo2_moth "Peumococcal 2nd dose vaccination according to mother".
variable labels ch_peumo2_either "Peumococcal 2nd dose vaccination according to either source".
variable labels ch_peumo3_card "Peumococcal 3rd dose vaccination according to card".
variable labels ch_peumo3_moth "Peumococcal 3rd dose vaccination according to mother".
variable labels ch_peumo3_either "Peumococcal 3rd dose vaccination according to either source".
value labels ch_peumo1_card ch_peumo1_moth ch_peumo1_either ch_peumo2_card ch_peumo2_moth ch_peumo2_either ch_peumo3_card ch_peumo3_moth ch_peumo3_either 0 "No" 1 "Yes".

*** Rotavirus  ****
*Rotavirus 1, 2, 3 either source.
* for surveys that do not have information on this vaccine..
compute h57=$sysmis.
compute h58=$sysmis.
compute h59=$sysmis.

recode h57 (0,8=0 ) (else=1) into rotav1.
recode h58 (0,8=0 ) (else=1) into rotav2.
recode h59 (0,8=0 ) (else=1) into rotav3.
compute rotavsum= rotav1+rotav2+rotav3.

* this step is performed for multi-dose vaccines to take care of any gaps in the vaccination history. See DHS guide to statistics 
* for further explanation.
compute ch_rotav1_either=rotavsum>=1.
compute ch_rotav2_either=rotavsum>=2.
compute ch_rotav3_either=rotavsum>=3.

*Rotavirus 1, 2, 3 mother's report.
compute ch_rotav1_moth=ch_rotav1_either.
if source=1 ch_rotav1_moth=0.

compute ch_rotav2_moth=ch_rotav2_either.
if source=1 ch_rotav2_moth=0.

compute ch_rotav3_moth=ch_rotav3_either.
if source=1 ch_rotav3_moth=0.

*Rotavirus 1, 2, 3 by card.
compute ch_rotav1_card=ch_rotav1_either.
if source=2 ch_rotav1_card=0.

compute ch_rotav2_card=ch_rotav2_either.
if source=2 ch_rotav2_card=0.

compute ch_rotav3_card=ch_rotav3_either.
if source=2 ch_rotav3_card=0.

execute.
delete variables rotav1 rotav2 rotav3 rotavsum.

variable labels ch_rotav1_card      "Rotavirus 1st dose vaccination according to card".
variable labels ch_rotav1_moth     "Rotavirus 1st dose vaccination according to mother".
variable labels ch_rotav1_either    "Rotavirus 1st dose vaccination according to either source".
variable labels ch_rotav2_card      "Rotavirus 2nd dose vaccination according to card".
variable labels ch_rotav2_moth     "Rotavirus 2nd dose vaccination according to mother".
variable labels ch_rotav2_either    "Rotavirus 2nd dose vaccination according to either source".
variable labels ch_rotav3_card      "Rotavirus 3rd dose vaccination according to card".
variable labels ch_rotav3_moth     "Rotavirus 3rd dose vaccination according to mother".
variable labels ch_rotav3_either    "Rotavirus 3rd dose vaccination according to either source".
value labels ch_rotav1_card ch_rotav1_moth ch_rotav1_either ch_rotav2_card ch_rotav2_moth ch_rotav2_either ch_rotav3_card ch_rotav3_moth ch_rotav3_either 0 "No" 1 "Yes".

*** Measles ***.
*measles either source.
recode h9 (0,8=0 ) (else=1) into ch_meas_either.

*measles mother's report.
compute ch_meas_moth=ch_meas_either.
if source=1 ch_meas_moth=0.

*measles by card.
compute ch_meas_card=ch_meas_either.
if source=2 ch_meas_card=0.

variable labels ch_meas_card "Measles vaccination according to card".
variable labels ch_meas_moth "Measles vaccination according to mother".
variable labels ch_meas_either "Measles vaccination according to either source".
value labels ch_meas_card ch_meas_moth ch_meas_either 0 "No" 1 "Yes".

*** All vaccinations ***.
compute ch_allvac_either=(ch_bcg_either=1&ch_pent3_either=1&ch_polio3_either=1&ch_meas_either=1).
variable labels ch_allvac_either "All basic vaccinations according to either source".
value labels ch_allvac_either 0 "No" 1 "Yes".

compute ch_allvac_moth=ch_allvac_either.
if source=1 ch_allvac_moth=0.
variable labels ch_allvac_moth "All basic vaccinations according to mother".
value labels ch_allvac_moth 0 "No" 1 "Yes".

compute ch_allvac_card=ch_allvac_either.
if source=2 ch_allvac_card=0.
variable labels ch_allvac_card "All basic vaccinations according to card".
value labels ch_allvac_card 0 "No" 1 "Yes".

*** No vaccinations ***.
compute ch_novac_either=ch_bcg_either=0&ch_pent1_either=0&ch_pent2_either=0&ch_pent3_either=0 &ch_polio0_either=0&ch_polio1_either=0&ch_polio2_either=0&ch_polio3_either=0&ch_meas_either=0.
variable labels ch_novac_either "No vaccinations according to either source".
value labels ch_novac_either 0 "No" 1 "Yes".

compute ch_novac_moth=ch_novac_either.
if source=1 ch_novac_moth=0.
variable labels ch_novac_moth "No vaccinations according to mother".
value labels ch_novac_moth 0 "No" 1 "Yes".

compute ch_novac_card=ch_novac_either.
if source=2 ch_novac_card=0.
variable labels ch_novac_card "No vaccinations according to card".
value labels ch_novac_card 0 "No" 1 "Yes".

*** vaccination card possession ***.
recode h1(1 thru 3=1) (else=0) into ch_card_ever_had.
variable labels ch_card_ever_had "Ever had a vacciation card".
value labels ch_card_ever_had 0 "No" 1 "Yes".

recode h1(1=1) (else=0) into ch_card_seen.
variable labels ch_card_seen "Vaccination card seen".
value labels ch_card_seen 0 "No" 1 "Yes".
