* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			RH_ANC.do
Purpose: 			Code PNC indicators for women and newborns
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Ivana Bjelic
Date last modified: June 29 2019 by Ivana Bjelic 
*****************************************************************************************************/

 * /*----------------------------------------------------------------------------//
Variables created in this file:
rh_pnc_wm_timing	"Timing after delivery for mother's PNC check"
rh_pnc_wm_2days 	"PNC check within two days for mother"
rh_pnc_wm_pv 		"Provider for mother's PNC check"

 * rh_pnc_nb_timing	"Timing after delivery for newborn's PNC check"
rh_pnc_nb_2days 	"PNC check within two days for newborn"
rh_pnc_nb_pv 		"Provider for newborn's PNC check"	
/----------------------------------------------------------------------------*/
		
** For surveys 2005 or after, postnatal care was asked for both institutional and non-institutional births. 
** surveys before 2005 only ask PNC for non-institutional births but assumed women received PNC if they delivered at health facilities	 
** This is checked using variable m51$1 which was used in older surveys
** For some surveys it was m51a$1 not m51$1.
begin program.
import spss, spssaux
varList = "m51$1 m51a$1 m70$1 m71$1 m72$1 m73$1 m74$1 m75$1 m76$1"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables
  /break=
  /m51$1_included=mean(m51$1)
  /m70$1_included=mean(m70$1).

recode m51$1_included (lo thru hi = 1)(else = 0).
recode m70$1_included (lo thru hi = 1)(else = 0).

** To check if survey has m51$1, which was in the surveys before 2005. 
** If the code doesn not run, perhaps it is because you need to use m51a$1. Uncomment this section in that case.

*do if (m51$1_included = 1).
*+ compute m51$1=m51$1.
*else.
*+ compute m51$1=m51a$1.
*end if. 


*** Mother's PNC ***		
		
do if (m51$1_included=1).
*/PNC timing for mother.

do if (age<24 and bidx$01=1).
+  recode m51$1 (100 thru 103 = 1)(104 thru 123,200 = 2) (124 thru 171,201,202 = 3) (172 thru 197,203 thru 206 = 4)(207 thru 241, 301 thru 305=5) (198,199,298,299,398,399,998,999 = 9) (242 thru 297,306 thru 397 = 0) into rh_pnc_wm_timing.
+  if m50$1=0 or m50$1=9 rh_pnc_wm_timing = 0.
+  if (m52$1>29 & m52$1<97) or sysmis(m52$1) rh_pnc_wm_timing = 0.
end if.
+ variable labels rh_pnc_wm_timing "Timing after delivery for mother's PNC check".
+ value labels rh_pnc_wm_timing
  0 "no pnc check"
  1 "<4hr"
  2 "4-23hrs"
  3 "1-2 days"
  4 "3-6 days"
  5 "7-41 days"
  9 "dont know/missing".

*/PNC within 2days for mother.
+ recode rh_pnc_wm_timing (1 thru 3 = 1) (0, 4, 5, 9  = 0) into rh_pnc_wm_2days.
+ variable labels rh_pnc_wm_2days "PNC check within two days for mother".
+ value labels rh_pnc_wm_2days 
  1 "visit w/in 2 days"
  0 "No Visit w/in 2 days".
	
*/PNC provider for mother.	
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
+ do if (age < 24).
+  recode m52$1 (0 = 0) (11 = 1) (12,13 = 2) (14,15 = 3) (16 thru 90 = 4) (96 = 5) (else = 9) into rh_pnc_wm_pv.
+  if rh_pnc_wm_2days=0 rh_pnc_wm_pv = 0.	
+end if.
+ variable labels rh_pnc_wm_pv "Provider for mother's PNC check".
+ value labels rh_pnc_wm_pv 
  0 "No check"
  1 "Doctor"
  2 "Nurse/Midwife"
  3 "Other skilled provider"
  4 "Non-skilled provider"
  5 "Other"
  9 "Don't know or missing".
* if m51$1 doesnt exisit.
else.
* /PNC timing for mother.
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 	
*did the mother have any check.
+ if age<24  momcheck = 0.
+ if (m62$1=1 | m66$1=1) & age<24 momcheck = 1.
*create combined timing variable.
+  if (age<24 & momcheck=1) pnc_wm_time = 999.
*start with women who delivered in a health facility with a check.
+  if range(m64$1,11,29) & age<24 pnc_wm_time = m63$1.
*Account for provider of PNC- country specific- see table footnotes.
+  if (pnc_wm_time < 1000 & m64$1 >30 & m64$1 < 100 & age<24) pnc_wm_time = 0.
*Add in women who delivered at home with a check.
+ if  (pnc_wm_time = 999 & range(m68$1, 11,29) & age<24) pnc_wm_time = m67$1.
*Account for provider of PNC- country specific- see table footnotes.
+ if (m67$1 < 1000 & m68$1 >30 & m68$1 < 100 & age<24) pnc_wm_time = 0.
*Add in women who had no check.
+ if momcheck = 0 & age<24 pnc_wm_time = 0.
	
*Recode variable into categories as in FR.
+ recode pnc_wm_time (0,242 thru 299, 306 thru 899 = 0) (100 thru 103 = 1) (104 thru 123, 200 = 2) (124 thru 171, 201 thru 202 = 3) (172 thru 197, 203 thru 206 = 4) (207 thru 241,300 thru 305 = 5 )(else = 9) into rh_pnc_wm_timing.
+ if age>=24 rh_pnc_wm_timing = $sysmis.
+ variable labels rh_pnc_wm_timing "Timing after delivery for mother's PNC check".
+ value labels rh_pnc_wm_timing 
  0 "No check or past 41 days"
  1 "less than 4 hours"
  2 "4 to 23 hours"
  3 "1-2 days"
  4 "3-6 days"
  5 "7-41 days"
  9 "Don't know or missing".

*/PNC within 2days for mother.	
+ recode rh_pnc_wm_timing (1 thru 3 = 1) (0,4,5,9 = 0) into rh_pnc_wm_2days.
+ variable labels rh_pnc_wm_2days "PNC check within two days for mother".
+ value labels rh_pnc_wm_2days
 1 "Within 2 days"
 0 "Not in 2 days".
	
*/PNC provider for mother.	
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
	
*Providers of PNC for facility deliveries.
+ recode m64$1 (0 = 0) (11 = 1) (12,13 = 2) (14,15 = 3) (16 thru 90 = 4) (96 = 5) (else = 9) into pnc_wm_pv_hf.
+ if not (age<24 & rh_pnc_wm_2days=1)  pnc_wm_pv_hf = $sysmis.
+ if (rh_pnc_wm_2days=0 & age<24) pnc_wm_pv_hf = 0.
+ value labels pnc_wm_pv_hf
 0 "No check"
 1 "Doctor"
 2 "Nurse/Midwife"
 3 "Other skilled provider"
 4 "Non-skilled provider"
 5 "Other"
 9 "Don't know or missing".

*Providers of PNC for home deliveries or checks after discharge.
+ recode m68$1 (0 = 0) (11 = 1) (12,13 = 2) (14,15 = 3) (16 thru 90 = 4) (96 = 5) (else = 9) into pnc_wm_pv_home.
+ if not (age<24 & rh_pnc_wm_2days=1) pnc_wm_pv_home = $sysmis.
+ if (rh_pnc_wm_2days=0  & age<24) pnc_wm_pv_home = 0.
+ value labels pnc_wm_pv_home
 0 "No check"
 1 "Doctor"
 2 "Nurse/Midwife"
 3 "Other skilled provider"
 4 "Non-skilled provider"
 5 "Other"
 9 "Don't know or missing".

*Combine two PNC provider variables.	
+ compute rh_pnc_wm_pv = pnc_wm_pv_hf.
+ if (pnc_wm_pv_hf=9 & rh_pnc_wm_2days=1 & age<24)  rh_pnc_wm_pv = pnc_wm_pv_home.
+ variable labels rh_pnc_wm_pv "Provider for mother's PNC check".

end if.

*** Newborn's PNC ***

* some surveys (usally older surveys) do not have PNC indicators for newborns. For this you would need variables m70$1, m71$1, ..., m76$1.

** To check if survey has m70$1, m71$1, ..., m76$1.
*survey has newborn PNC indicators.
do if (m70$1_included=1).
+    do if (m51$1_included=1).
* PNC timing for newborn.
+        do if (age<24).
+            recode m71$1 (207 thru 297,301 thru 397 = 0) (100 = 1) (101 thru 103 = 2) (104 thru 123, 200 = 3) (124 thru 171, 201, 202 = 4) (172 thru 197, 203 thru 206 = 5) (198 thru 199, 298, 299, 398, 399, 998, 999 = 9)  into rh_pnc_nb_timing. 
*Recode babies with no check and babies with check by unskilled prov back to 0.
+             if (m70$1=0 | m70$1=9)  rh_pnc_nb_timing = 0.
*Account for provider of PNC- country specific- see table footnotes.
+             if (m72$1>29 & m72$1<97) or sysmis(m72$1) rh_pnc_nb_timing = 0.
+             if bidx$01<>1  rh_pnc_nb_timing = $sysmis.
+        end if.
*label variable.
+         variable labels rh_pnc_nb_timing "Timing after delivery for newborn's PNC check".
+         value labels rh_pnc_nb_timing
              0 "No check or past 7 days"
              1 "less than 1 hours"
              2 "1-3 hours"
              3 "4 to 23 hours"
              4 "1-2 days"
              5 "3-6 days new"
              9 "Don't know or missing". 
		

*PNC within 2days for newborn.
+        do if (age<24).
+            recode rh_pnc_nb_timing (1 thru 4 = 1) (sysmis, 0, 5, 9 = 0)into rh_pnc_nb_2days.
+        end if.
*label variable.	
+           variable labels rh_pnc_nb_2days "PNC check within two days for newborn".
+           value labels rh_pnc_nb_2days
                 1 "Within 2 days"
                 0 "Not in 2 days".

* PNC provider for newborn.
** this is country specific, please check table in final report.
+        do if (age<24).
+            recode m72$1 (0 = 0) (11 = 1) (12,13 = 2) (14,15 = 3) (16 thru 90 = 4) (96 = 5) (98,99 = 9)  into rh_pnc_nb_pv.
+            if not (age<24 & rh_pnc_nb_timing<9 & rh_pnc_nb_timing>0) rh_pnc_nb_pv=$sysmis.
+            if (rh_pnc_nb_2days =0 & age<24)  rh_pnc_nb_pv = 0.
+        end if.
+        variable labels rh_pnc_nb_pv "Provider for newborn's PNC check".
+        value labels rh_pnc_nb_pv 
                0 "No check"
                1 "Doctor"
                2 "Nurse/Midwife"
                3 "Other skilled provider"
                4 "Non-skilled provider"
                5 "Other"
                9 "Don't know or missing".

*m51$1_included=0.	
+    else. 
* PNC timing for newborn.	
* Newborn check.
+            if (m70$1=1 | m74$1=1) compute nbcheck = 1.
*create combined timing variable.
+             if (age<24 & nbcheck=1)  pnc_nb_timing_all = 999.
*start with women who delivered in a health facility with a check.
+           if (range(m76$1,11,29) & age<24) pnc_nb_timing_all = m75$1.
*Account for provider of PNC- country specific- see table footnotes.
+            if (pnc_nb_timing_all < 1000 & m76$1 >30 & m76$1 < 100 & age<24) pnc_nb_timing_all = 0.
*Add in women who delivered at home with a check.
+             if (pnc_nb_timing_all=999 & range(m72$1,11,29) & age<24) pnc_nb_timing_all = m71$1.
*Account for provider of PNC- country specific- see table footnotes.
+             if (m71$1 < 1000 & m72$1 >30 & m72$1 < 100 & age<24) pnc_nb_timing_all = 0.
*Add in women who had no check.
+             if ((nbcheck<>1) & age<24) pnc_nb_timing_all = 0.
*Recode variable into categories as in FR.
+            recode pnc_nb_timing_all (0 207 thru 297, 301 thru 397 = 0)  (100=1) (101 thru 103 =2) (104 thru 123, 200 = 3) (124 thru 171, 201, 202 = 4) (172 thru 197, 203 thru 206 = 5) (else = 9) into rh_pnc_nb_timing.
+            if (age>=24) rh_pnc_nb_timing = $sysmis.
*label variable.
+           variable labels rh_pnc_nb_timing "Timing after delivery for newborn's PNC check".
+           value labels rh_pnc_nb_timing
                0 "No check or past 7 days"
                1 "less than 1 hours"
                2 "1-3 hours"
                3 "4 to 23 hours"
                4 "1-2 days"
                5 "3-6 days new"
                9 "Don't know or missing".

*PNC within 2days for newborn.
+        do if (age<24).	
+            recode rh_pnc_nb_timing (1 thru 4 = 1) (0, 5, 9 = 0) into rh_pnc_nb_2days.
+        end if.
+            variable labels rh_pnc_nb_2days "PNC check within two days for newborn".
+            value labels rh_pnc_nb_2days
                 1 "Visit within 2 days"
                 0 "Not in 2 days".

*PNC provider for newborn.
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
		
*Providers of PNC for home deliveries or checks after discharge.
+            recode m72$1 (0 = 0) (11 = 1) (12,13 = 2) (14,15 = 3) (16 thru 90 = 4) (96 = 5) (else = 9) into pnc_nb_pv_home.
+            if not (age<24 & rh_pnc_nb_2days=1) pnc_nb_pv_home = $sysmis.
+            if (rh_pnc_nb_2days=0 & age<24) pnc_nb_pv_home = 0.
+            value labels pnc_nb_pv_home
                 0 "No check"
                 1 "Doctor"
                 2 "Nurse/Midwife"
                 3 "Other skilled provider"
                 4 "Non-skilled provider"
                 5 "Other"
                 9 "Don't know or missing".
		
*Providers of PNC for facility deliveries.
+            recode m76$1  (0 = 0) (11 = 1) (12,13 = 2) (14,15 = 3) (16 thru 90 = 4) (96 = 5) (else = 9) into pnc_nb_pv_hf.
+            if not (age<24 & rh_pnc_nb_2days=1)  pnc_nb_pv_hf = $sysmis.
+            if (rh_pnc_nb_2days=0  & age<24) pnc_nb_pv_hf = 0.
+            value labels pnc_nb_pv_hf 
                 0 "No check"
                 1 "Doctor"
                 2 "Nurse/Midwife"
                 3 "Other skilled provider"
                 4 "Non-skilled provider"
                 5 "Other"
                 9 "Don't know or missing".
		
*Combine two PNC provider variables.	
+            compute rh_pnc_nb_pv = pnc_nb_pv_hf.
+             if ((pnc_nb_pv_hf =9) &  rh_pnc_nb_2days =1 & age<24) rh_pnc_nb_pv = pnc_nb_pv_home.
*label variable.
+            variable labels rh_pnc_nb_pv "Provider for newborns's PNC check".
+            value labels rh_pnc_nb_pv 
                 0 "No check"
                 1 "Doctor"
                 2 "Nurse/Midwife"
                 3 "Other skilled provider"
                 4 "Non-skilled provider"
                 5 "Other"
                 9 "Don't know or missing".
		
    end if.
end if.

*survey does not have newborn PNC indicators.
do if (m70$1_included=0).
* replace indicators as missing.
+ compute rh_pnc_nb_timing = $sysmis.
+ compute rh_pnc_nb_2days = $sysmis.	
+ compute rh_pnc_nb_pv = $sysmis.
end if.
