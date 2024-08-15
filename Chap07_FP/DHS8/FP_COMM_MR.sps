* Encoding: windows-1252.
*****************************************************************************************************
*****************************************************************************************************
Program: 			FP_COMM_MR.sps
Purpose: 			Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 
 * Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: Aug 06 2019 by Ivana Bjelic

 * Notes:				For men (MR file) only the FP messages indicators are created. 
*****************************************************************************************************

* /*----------------------------------------------------------------------------
fp_message_radio		"Exposure to family planning message by radio"
fp_message_tv		"Exposure to family planning message by TV"
fp_message_paper		"Exposure to family planning message by newspaper/magazine"
fp_message_mobile		"Exposure to family planning message by mobile phone"
fp_message_noneof4		"Not exposed to any of the four media sources"
fp_message_noneof3 		"Not exposed to TV, radio, or paper media sources"
fp_decyes_user		"Who makes the decision to use family planning among users"
fp_decno_nonuser		"Who makes decision not to use family planning among non-users"
fp_fpvisit_discuss		"Women non-users that were visited by a FP worker who discussed FP"
fp_hf_discuss		"Women non-users who visited a health facility in last 12 months and discussed FP"
fp_hf_notdiscuss		"Women non-users who visited a health facility in last 12 months and did not discuss FP"
fp_any_notdiscuss		"Women non-users who did not discuss FP neither with FP worker or in a health facility"
----------------------------------------------------------------------------*

* indicators from MR file

*** Family planning messages ***

*Family planning messages by radio.
compute fp_message_radio = 0.
if mv384a = 1 fp_message_radio = 1.
variable labels fp_message_radio "Exposure to family planning message by radio".
value labels fp_message_radio 0 "No" 1 "Yes".

*Family planning messages by TV.
compute fp_message_tv = 0.
if mv384b = 1 fp_message_tv = 1.
variable labels fp_message_tv "Exposure to family planning message by TV".
value labels fp_message_tv 0 "No" 1 "Yes".

*Family planning messages by newspaper and/or magazine.
compute fp_message_paper = 0.
if mv384c = 1 fp_message_paper = 1.
variable labels fp_message_paper "Exposure to family planning message by newspaper/magazine".
value labels fp_message_paper 0 "No" 1 "Yes".

*Family planning messages by mobile.
compute fp_message_mobile = 0.
if mv384d = 1 fp_message_mobile = 1.
variable labels fp_message_mobile "Exposure to family planning message by mobile phone".
value labels fp_message_mobile 0 "No" 1 "Yes".

*Did not hear a family planning message from any of the 4 media sources.
compute fp_message_noneof4 = 0.
if (mv384a <> 1 & mv384b <> 1 & mv384c <> 1 & mv384d <> 1) fp_message_noneof4 = 1.
variable labels fp_message_noneof4 "Not exposed to any of the four media sources".
value labels fp_message_noneof4 0 "No" 1 "Yes".

*Did not hear a family planning message from radio, TV or paper.
compute fp_message_noneof3 = 0.
if (mv384a <> 1 & mv384b <> 1 & mv384c <> 1) fp_message_noneof3 = 1.
variable labels fp_message_noneof3 "Not exposed to TV, radio, or paper media sources".
value labels fp_message_noneof3 0 "No" 1 "Yes".

