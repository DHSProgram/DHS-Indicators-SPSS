* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FS_FIST.sps
Purpose: 			Code to compute fistula indicators among women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: December 02, 2020 by Shireen Assaf 
*
Note:				
There are no standard variables names for these variables
These variables will likely be included in the data file as country-specific variables
Country-specific variables begin with an “s”, though in this chapter we use “fistula_v*” to denote variables as they are not standard
Country-specific variables should be checked. These tables are not standard across all surveys over time. There is some variation in the presentation of these results among final reports
*
This do file provides a guide to how the fistula indicators can be computed but it is necessary to check the country-specific variables for each survey and adjust the code accordingly.
					
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
fs_heard		"Ever heard of fistula"
fs_ever_exp		"Ever experienced fistula"
fs_current		"Currently have fistula"
*	
fs_cause		"Reported cause of fistula"
fs_days_symp	"Reported number of days since symptoms began"
*	
fs_trt_provid	                  "Provider type for fistula treatment"
fs_trt_outcome	"Outcome of treatment sought for fistula"
fs_trt_operat	"Had operation for fistula"
fs_notrt_reason	"Reason for not seeking treatment"
*
----------------------------------------------------------------------------.

*Change variables below according to the survey: the variables below are for Afghanistan 2015 survey. 
*Use find command in SPSS and variable view to find fistula related varaibles. 

*Heard of fistula.
*use varaible labeled as "ever heard of fistula".
compute fs_heard = 0.
if s1102=1  fs_heard=1.
variable labels fs_heard "Ever heard of fistula".
value labels fs_heard 0"No" 1"Yes".

*Ever experienced fistula.
*use variable labeled as "involuntary loss of urine and/or feces through the vagina".
compute fs_ever_exp = 0.
if s1101=1 fs_ever_exp=1.
variable labels fs_ever_exp "Ever experienced fistula".
value labels fs_ever_exp 0"No" 1"Yes".

*Reported cause of fistula.
* use two variables one labeled as "problem start after normal or difficult labor and delivery" here this is s1104 and "problem start after delivered a baby or had a stillbirth" here this is s1103
* you may need to add more country-specific categories here. To do this find a variable with the label "Reported cause of fistula".
if s1103<3 fs_cause=9.
if s1104=1 & s1103=1 fs_cause=1.
if s1104=1 & s1103=2 fs_cause=2.
if s1104=2 & s1103=1 fs_cause=3.
if s1104=2 & s1103=2 fs_cause=4.
variable labels fs_cause "Reported cause of fistula".
value labels fs_cause 1"Normal labor and delivery, baby born alive" 2"Normal labor and delivery, baby stillborn" 3"Very difficult labor and delivery, baby born alive" 4"Very difficult labor and delivery, baby stillborn" 9"Missing".

*Reported number of days since symptoms began.
*find variable with label "days after problem leakage started" here this is s1106.
if s1103<3 fs_days_symp=9.
if s1106<2 fs_days_symp=1.
if range(s1106,2,4) fs_days_symp=2.
if range(s1106,5,7) fs_days_symp=3.
if range(s1106,8,90) fs_days_symp=4.
if sysmis(fs_cause) fs_days_symp=$sysmis. 
variable labels fs_days_symp "Reported number of days since symptoms began".
value labels fs_days_symp 1"0-1 day" 2"2-4 days" 3"5-7 days" 4"8+ days" 9"Missing".

*Provider type for fistula treatment.
* use two variables one labeled as "sought treatment for fistula" here this is s1107 and "from whom have you sought a treatment" here this is s1109.
missing values s1107 ().
missing values s1109 ().
if s1101=1 & s1107=1 fs_trt_provid = s1109.
if s1101=1 & s1109>6 fs_trt_provid=9.
if s1101=1 & s1107<>1 fs_trt_provid=0.
variable labels fs_trt_provid "Provider type for fistula treatment".
value labels fs_trt_provid 0"No treatment" 1"Doctor" 2"Nurse/Midwife" 3"Community/village health worker" 6"Other" 9"Missing".

*Outcome of treatment sought for fistula.
* find a variable with "treatment" or "leakage" in the label.
missing values s1111 ().
if s1101=1 & s1107=1 fs_trt_outcome = s1111.
if s1101=1 & s1107=1 & s1111>6 fs_trt_outcome=9.
variable labels fs_trt_outcome "Outcome of treatment sought for fistula".
value labels fs_trt_outcome 1"Leakage stopped completely" 2"Not stopped but reduced" 3"Not stopped at all" 4"Did not receive any treatment" 9"Missing".

*Had operation for fistula.
if s1101=1 & s1107=1 fs_trt_operat = 0.
if s1110=1 fs_trt_operat=1.
variable labels fs_trt_operat "Had operation for fistula".
value labels fs_trt_operat 0"No" 1"Yes".

*Reason for not seeking treatment.
if fs_ever_exp=1 & fs_trt_outcome=4 fs_notrt_reason = $sysmis. 
if s1108x=1 or s1108e=1 fs_notrt_reason = 8.
if s1108f=1 fs_notrt_reason = 7.
if s1108h=1 fs_notrt_reason = 6.
if s1108d=1 fs_notrt_reason = 5.
if s1108g=1 fs_notrt_reason = 4.
if s1108c=1 fs_notrt_reason = 3.
if s1108b=1 fs_notrt_reason = 2.
if s1108a=1 fs_notrt_reason = 1.
if sysmis(s1108a) & fs_ever_exp=1 & fs_trt_outcome=4 fs_notrt_reason = 9. 
variable labels fs_notrt_reason "Reason for not seeking treatment".
value labels fs_notrt_reason 1"Did not know the problem can be fixed" 2"Did not know where to go" 3"Too expensive" 4"Embarrassment" 5"Too far" 6"Problem disappeard" 7"Could not get permission" 8"Other" 9"Missing".

