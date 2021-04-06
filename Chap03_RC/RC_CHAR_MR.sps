* Encoding: windows-1252.
*****************************************************************************************************
Program: 			RC_CHAR_MR.sps
Purpose: 			Code to compute respondent characteristics in men and women
Data inputs: 		MR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: October 17 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women
					For men the indicator is computed for age 15-49 in line 55. This can be commented out if the indicators are required for all men
					Please check the note on health insurance. This can be country specific and also reported for specific populations. 
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
rc_edu			"Highest level of schooling attended or completed"
rc_edu_median		"Median years of education"
rc_litr_cats		                  "Level of literacy"
rc_litr			"Literate - higher than secondary or can read part or whole sentence"
rc_media_newsp		"Reads a newspaper at least once a week"
rc_media_tv			"Watches television at least once a week"
rc_media_radio		"Listens to radio at least once a week"
rc_media_allthree            	"Accesses to all three media at least once a week"
rc_media_none		"Accesses none of the three media at least once a week"
rc_intr_ever        		"Ever used the internet"
rc_intr_use12mo		"Used the internet in the past 12 months"
rc_intr_usefreq		"Internet use frequency in the past month - among users in the past 12 months"
rc_empl			"Employment status"
rc_occup			"Occupation among those employed in the past 12 months"
rc_empl_type		"Type of employer among those employed in the past 12 months"
rc_empl_earn		"Type of earnings among those employed in the past 12 months"
rc_empl_cont		"Continuity of employment among those employed in the past 12 months"
rc_hins_ss			"Health insurance coverage - social security"
rc_hins_empl		"Health insurance coverage - other employer-based insurance"
rc_hins_comm		"Health insurance coverage - mutual health org. or community-based insurance"
rc_hins_priv	                    	"Health insurance coverage - privately purchased commercial insurance"
rc_hins_other		"Health insurance coverage - other type of insurance"
rc_hins_any			"Have any health insurance"
rc_tobc_cig			"Smokes cigarettes"
rc_tobc_other		"Smokes other type of tobacco"
rc_tobc_smk_any		"Smokes any type of tobacco"
rc_smk_freq			"Smoking frequency"
rc_cig_day			"Average number of cigarettes smoked per day"
rc_tobc_snuffm		"Uses snuff smokeless tobacco by mouth"
rc_tobc_snuffn		"Uses snuff smokeless tobacco by nose"
rc_tobc_chew		"Chews tobacco"
rc_tobv_betel		"Uses betel quid with tobacco"
rc_tobc_osmkless                	"Uses other type of smokeless tobacco"
rc_tobc_any			"Uses any type of tobacco - smoke or smokeless"
----------------------------------------------------------------------------*/

* indicators from MR file.

* limiting to men age 15-49.
select if (mv012<=49).

*** Education ***.

*Highest level of education.
compute rc_edu= mv149.
apply dictionary from *
 /source variables = mv149
 /target variables = rc_edu.
variable labels rc_edu "Highest level of schooling attended or completed".

*Median years of education.
do if not(mv133>95 | mv149>7).
+compute eduyr=mv133.
+if mv133>20 & mv133<95 eduyr=20.
end if.

weight by mv005.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sp50=median(eduyr).
	
compute dummyL=0.
if eduyr<sp50 dummyL = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sL=mean(dummyL).
	
compute dummyU=0.
if eduyr<=sp50 dummyU = 1.
aggregate
  /outfile = * mode=addvariables  overwrite = yes
  /break=
  /sU=mean(dummyU).

compute rc_edu_median=sp50-1+(0.5-sL)/(sU-sL).
variable labels rc_edu_median	"Median years of education".

weight off.
	
*Literacy level.
recode mv155 (2=1 ) (1=2) (0=3) (3=4) (4=5) into rc_litr_cats.
if mv106=3 rc_litr_cats=0.
variable labels rc_litr_cats "Level of literacy".
value labels rc_litr_cats 0"Higher than secondary education" 1"Can read a whole sentence"2 "Can read part of a sentence" 3 "Cannot read at all" 4 "No card with required language" 5 "Blind/visually impaired".

*Literate.
compute rc_litr=0.
if (mv106=3 | mv155=1 | mv155=2) rc_litr=1.	
variable labels rc_litr "Literate - higher than secondary or can read part or whole sentence".
value labels rc_litr
0 "No"
1 "Yes".


*** Media exposure ***.

*Media exposure – newspaper.
recode mv157 (2,3=1) (0,1=0) into rc_media_newsp.
variable labels rc_media_newsp "Reads a newspaper at least once a week".
value labels rc_media_newsp
0 "No"
1 "Yes".

*Media exposure – TV.
recode mv159 (2,3=1) (0,1=0) into rc_media_tv.
variable labels rc_media_tv "Watches television at least once a week".
value labels rc_media_tv
0 "No"
1 "Yes".

*Media exposure – Radio.
recode mv158 (2,3=1) (0,1=0) into rc_media_radio.
variable labels rc_media_radio "Listens to radio at least once a week".
value labels rc_media_radio
0 "No"
1 "Yes".

*Media exposure - all three.
compute rc_media_allthree=0.
if any (mv157,2,3) & any (mv158,2,3) & any (mv159,2,3) rc_media_allthree=1. 
variable labels rc_media_allthree "Accesses to all three media at least once a week".
value labels rc_media_allthree
0 "No"
1 "Yes".

*Media exposure – none.
compute rc_media_none=0.
if (mv157<>2 & mv157<>3) & (mv158<>2 & mv158<>3) & (mv159<>2 & mv159<>3) rc_media_none=1. 
variable labels rc_media_none "Accesses none of the three media at least once a week".
value labels rc_media_none
0 "No"
1 "Yes".

*Ever used internet.
recode mv171a (0=0) (1 thru 3=1) into rc_intr_ever. 
variable labels rc_intr_ever "Ever used the internet".
value labels rc_intr_ever
0 "No"
1 "Yes".

*Used interent in the past 12 months.
recode mv171a (0,2,3=0) (1=1) into rc_intr_use12mo.
variable labels rc_intr_use12mo "Used the internet in the past 12 months".
value labels rc_intr_use12mo
0 "No"
1 "Yes".

*Internet use frequency.
do if mv171a=1.
+compute rc_intr_usefreq= mv171b.
end if.
apply dictionary from *
 /source variables = mv171b
 /target variables = rc_intr_usefreq.
variable labels rc_intr_usefreq "Internet use frequency in the past month - among users in the past 12 months".

*** Employment ***.

*Employment status.
recode mv731 (0=0) (1=1) (2,3=2) (8=9) into rc_empl.
variable labels rc_empl "Employment status".
value labels rc_empl
0 "Not employed in last 12 months"
1 "Not currently working but was employed in last 12 months"
2 "Currently employed"
9 "Don't know/missing".

*Occupation.
do if any (mv731,1,2,3).
+recode mv717 (1=1) (2=2) (3,7=3) (8=4) (9=5) (6=6) (4,5=7) (96 thru 99, sysmis =9) into rc_occup.
end if.
variable labels rc_occup "Occupation among those employed in the past 12 months".
value labels rc_occup
1 "Professional"
2 "Clerical"
3 "Sales and services"
4 "Skilled manual"
5 "Unskilled manual"
6 "Domestic service"
 7 "Agriculture"
9 "Don't know/missing".

* Some survyes do not ask the following employment questions so a capture was added to skip these variables if they are not present. 
*Type of employer.
do if any (mv731,1,2,3).
+compute rc_empl_type=mv719.
end if.
apply dictionary from *
 /source variables = MV719
 /target variables = rc_empl_type.
variable labels rc_empl_type "Type of employer among those employed in the past 12 months".

*Type of earnings.
do if any (mv731,1,2,3).
+compute rc_empl_earn=mv741.
end if.
apply dictionary from *
 /source variables = MV741
 /target variables = rc_empl_earn.
variable labels rc_empl_earn "Type of earnings among those employed in the past 12 months".

*Continuity of employment.
do if any (mv731,1,2,3).
+compute rc_empl_cont=mv732 .
end if.
apply dictionary from *
 /source variables = MV732
 /target variables = rc_empl_cont.
variable labels rc_empl_cont "Continuity of employment among those employed in the past 12 months".

*** Health insurance ***.
* Note: The different types of health insurance can be country specific. Please check the v481* variables to see which ones you need.
* In addition, some surveys report this for all women/men and some report it among those that have heard of insurance. Please check what the population of interest is for reporting these indicators.

*Health insurance - Social security.
compute rc_hins_ss = mv481c=1.
variable labels rc_hins_ss "Health insurance coverage - social security".
value labels rc_hins_ss 0 "No" 1 "Yes".

*Health insurance - Other employer-based insurance.
compute rc_hins_empl = mv481b=1.
variable labels rc_hins_empl "Health insurance coverage - other employer-based insurance".
value labels rc_hins_empl 0 "No" 1 "Yes".

*Health insurance - Mutual Health Organization or community-based insurance.
compute rc_hins_comm = mv481a=1.
variable labels rc_hins_comm "Health insurance coverage - mutual health org. or community-based insurance".
value labels rc_hins_comm 0 "No" 1 "Yes".

*Health insurance - Privately purchased commercial insurance.
compute rc_hins_priv = mv481d=1.
variable labels rc_hins_priv "Health insurance coverage - privately purchased commercial insurance".
value labels rc_hins_priv 0 "No" 1 "Yes".

*Health insurance – Other.
compute rc_hins_other=0.
do repeat x=mv481e mv481f mv481g mv481h mv481x.
+  if x=1 rc_hins_other=1.
end repeat.
variable labels rc_hins_other "Health insurance coverage - other type of insurance".
value labels rc_hins_other 0 "No" 1 "Yes".

*Health insurance – Any.
compute rc_hins_any=0.
do repeat x=mv481a mv481b mv481c mv481d mv481e mv481f mv481g mv481h mv481x.
+  if x=1 rc_hins_any=1.
end repeat.	
variable labels rc_hins_any "Have any health insurance".
value labels rc_hins_any 0 "No" 1 "Yes".

*** Tobacco Use ***.

*Smokes cigarettes.
compute rc_tobc_cig=0.
do repeat x=mv464a mv464b mv464c mv484a mv484b mv484c.
+  if (x>0 and x<=888) rc_tobc_cig=1.
end repeat.
variable labels rc_tobc_cig "Smokes cigarettes".
value labels rc_tobc_cig
0 "No"
1 "Yes".

*Smokes other type of tobacco.
compute rc_tobc_other=0.
do repeat x=mv464d mv464e mv464f mv464g mv484d mv484e mv484f mv484g.
+  if (x>0 and x<=888) rc_tobc_other=1.
end repeat.
variable labels rc_tobc_other "Smokes other type of tobacco".
value labels rc_tobc_other
0 "No"
1 "Yes".

*Smokes any type of tobacco.
compute rc_tobc_smk_any=0.
do repeat x=mv464a mv464b mv464c mv464d mv464e mv464f mv464g mv484a mv484b mv484c mv484d mv484e mv484f mv484g.
+  if (x>0 and x<=888) rc_tobc_smk_any=1.
end repeat.
variable labels rc_tobc_smk_any "Smokes any type of tobacoo".
value labels rc_tobc_smk_any
0 "No"
1 "Yes".

*Smoking frequency.
compute rc_smk_freq=mv463aa.
variable labels rc_smk_freq "Smoking frequency".
value labels rc_smk_freq 0"Non-smoker" 1"Daily smoker" 2"Occasional smoker".

*Average numberof cigarettes per day.
recode mv464a (sysmis,888=0)(else=copy) into ciga.
recode mv464b (sysmis,888=0)(else=copy) into cigb.
recode mv464c (sysmis,888=0)(else=copy) into cigc.
compute cigdaily=ciga+cigb+cigc.
do if (rc_smk_freq=1 & cigdaily>0).
+recode cigdaily (1 thru 4=1) (5 thru 9=2) (10 thru 14=3) (15 thru 24=4) (25 thru 95=5) (else=9 ) into rc_cig_day.
end if.
variable labels rc_cig_day "Average number of cigarettes smoked per day".
value labels rc_cig_day
1 "<5"
2 " 5-9"
3 " 10-14"
4 " 15-24"
5 " 25+"
9 "Don't know/missing".

*Snuff by mouth.
compute rc_tobc_snuffm = (range (mv464h,1,888) | range (mv484h,1,888)).
variable labels rc_tobc_snuffm "Uses snuff smokeless tobacco by mouth".
value labels rc_tobc_snuffm
0 "No"
1 "Yes".

*Snuff by nose.
compute rc_tobc_snuffn = (range (mv464i,1,888) | range (mv484i,1,888)).
variable labels rc_tobc_snuffn "Uses snuff smokeless tobacco by nose".
value labels rc_tobc_snuffn
0 "No"
1 "Yes".

*Chewing tobacco.
compute rc_tobc_chew = (range (mv464j,1,888) | range (mv484j,1,888)).
variable labels rc_tobc_chew "Chews tobacco".
value labels rc_tobc_chew
0 "No"
1 "Yes".

*Betel quid with tobacco.
compute rc_tobv_betel = (range (mv464k,1,888) | range (mv484k,1,888)).
variable labels rc_tobv_betel "Uses betel quid with tobacco".
value labels rc_tobv_betel
0 "No"
1 "Yes".

*Other type of smokeless tobacco.
*Note: there may be other types of smokeless tobacco, please check all mv464* and mv484* variables. 
compute rc_tobc_osmkless = (range (mv464l,1,888) | range (mv484l,1,888)).
variable labels rc_tobc_osmkless "Uses other type of smokeless tobacco".
value labels rc_tobc_osmkless
0 "No"
1 "Yes".

*Any smokeless tobacco.
compute rc_tobc_anysmkless=0.
do repeat x=mv464h mv464i mv464j mv464k mv464l mv484h mv484i mv484j mv484k mv484l.
+  if (x>0 and x<=888) rc_tobc_anysmkless=1.
end repeat.
if rc_tobc_osmkless=1 rc_tobc_anysmkless=1.
variable labels rc_tobc_anysmkless "Uses any type of smokeless tobacco".
value labels rc_tobc_anysmkless
0 "No"
1 "Yes".

*Any tobacco.
compute rc_tobc_any= (any (mv463aa,1,2) | any (mv463ab,1,2)).
variable labels rc_tobc_any "Uses any type of tobacco - smoke or smokeless".
value labels rc_tobc_any
0 "No"
1 "Yes".
