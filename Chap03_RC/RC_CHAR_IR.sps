* Encoding: windows-1252.
*****************************************************************************************************
Program: 			RC_CHAR_IR.sps
Purpose: 			Code to compute respondent characteristics in men and women
Data inputs: 		IR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: October 12 2019 by Ivana Bjelic
Note:				The indicators below can be computed for men and women
					Please check the note on health insurance. This can be country specific and also reported for specific populations. 
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
rc_edu               "Highest level of schooling attended or completed"
rc_edu_median   "Median years of education"
rc_litr_cats         "Level of literacy"
rc_litr			               "Literate - higher than secondary or can read part or whole sentence"
rc_media_newsp   "Reads a newspaper at least once a week"
rc_media_tv          "Watches television at least once a week"
rc_media_radio     "Listens to radio at least once a week"
rc_media_allthree  "Accesses to all three media at least once a week"
rc_media_none		   "Accesses none of the three media at least once a week"
rc_intr_ever        		"Ever used the internet"
rc_intr_use12mo		"Used the internet in the past 12 months"
rc_intr_usefreq		   "Internet use frequency in the past month - among users in the past 12 months"
rc_empl		   	"Employment status"
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
rc_tobc_snuffm		"Uses snuff smokeless tobacco by mouth"
rc_tobc_snuffn		"Uses snuff smokeless tobacco by nose"
rc_tobc_chew		"Chews tobacco"
rc_tobv_betel		"Uses betel quid with tobacco"
rc_tobc_osmkless                	"Uses other type of smokeless tobacco"
rc_tobc_any			"Uses any type of tobacco - smoke or smokeless"
----------------------------------------------------------------------------*/

* indicators from IR file.

*** Education ***.

*Highest level of education.
compute rc_edu= v149.
apply dictionary from *
 /source variables = v149 
 /target variables = rc_edu.
variable labels rc_edu "Highest level of schooling attended or completed".

*Median years of education.
do if not (v133>95 | v149>7).
+compute eduyr=v133.
+if v133>20 & v133<95 eduyr=20.
end if.
	
weight by v005.
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
recode v155 (2=1) (1=2) (0=3) (3=4) (4=5) into rc_litr_cats.
if v106=3 rc_litr_cats=0.
variable labels rc_litr_cats "Level of literacy".
value labels rc_litr_cats 0"Higher than secondary education" 1"Can read a whole sentence"2 "Can read part of a sentence" 3 "Cannot read at all" 4 "No card with required language" 5 "Blind/visually impaired".

*Literate.
compute rc_litr=0.
if v106=3 | v155=1 | v155=2 rc_litr=1.
variable labels rc_litr "Literate - higher than secondary or can read part or whole sentence".
value labels rc_litr
0 "No"
1 "Yes".

*** Media exposure ***.

*Media exposure - newspaper.
recode v157 (2,3=1) (0,1=0) into rc_media_newsp.
variable labels rc_media_newsp "Reads a newspaper at least once a week".
value labels rc_media_newsp
0 "No"
1 "Yes".

*Media exposure - TV.
recode v159 (2,3=1) (0,1=0) into rc_media_tv.
variable labels rc_media_tv "Watches television at least once a week".
value labels rc_media_tv
0 "No"
1 "Yes".	

*Media exposure - Radio.
recode v158 (2,3=1) (0,1=0) into rc_media_radio.
variable labels rc_media_radio "Listens to radio at least once a week".
value labels rc_media_radio
0 "No"
1 "Yes".	

*Media exposure - all three.
compute rc_media_allthree=0.
if any (v157,2,3) & any (v158,2,3) & any (v159,2,3) rc_media_allthree=1.
variable labels rc_media_allthree "Accesses to all three media at least once a week".
value labels rc_media_allthree
0 "No"
1 "Yes".

*Media exposure - none.
compute rc_media_none=0.
if (v157<>2 & v157<>3) & (v158<>2 & v158<>3) & (v159<>2 & v159<>3) rc_media_none=1.
variable labels rc_media_none "Accesses none of the three media at least once a week".
value labels rc_media_none
0 "No"
1 "Yes".

*Ever used internet.
recode v171a (0=0) (1 thru 3=1) into rc_intr_ever.
variable labels rc_intr_ever "Ever used the internet".
value labels rc_intr_ever
0 "No"
1 "Yes".

*Used interent in the past 12 months.
recode v171a (0,2,3=0) (1=1) into rc_intr_use12mo.
variable labels rc_intr_use12mo "Used the internet in the past 12 months".
value labels rc_intr_use12mo
0 "No"
1 "Yes".

*Internet use frequency.
do if v171a=1.
+compute rc_intr_usefreq= v171b.
end if.
apply dictionary from *
 /source variables = v171b 
 /target variables = rc_intr_usefreq.
variable labels rc_intr_usefreq "Internet use frequency in the past month - among users in the past 12 months".

*** Employment ***.
*Employment status.
recode v731 (0=0) (1=1) (2,3=2) (8=9) into rc_empl.
variable labels rc_empl "Employment status".
value labels rc_empl 
0 "Not employed in last 12 months"
1 "Not currently working but was employed in last 12 months"
2 "Currently employed"
9 "Don't know/missing".

*Occupation.
do if any (v731,1,2,3).
+recode v717 (1=1) (2=2) (3,7=3) (8=4) (9=5) (6=6) (4,5=7) (96 thru 99, sysmis=9) into rc_occup.
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

*Type of employer.
do if any (v731,1,2,3).
+compute rc_empl_type=v719.
end if.
apply dictionary from *
 /source variables = V719
 /target variables = rc_empl_type.
variable labels rc_empl_type "Type of employer among those employed in the past 12 months".

*Type of earnings.
do if any (v731,1,2,3).
+compute rc_empl_earn=v741.
end if.
apply dictionary from *
 /source variables = V741
 /target variables = rc_empl_earn.
variable labels rc_empl_earn "Type of earnings among those employed in the past 12 months".

*Continuity of employment.
do if any (v731,1,2,3).
+compute rc_empl_cont=v732.
end if.
apply dictionary from *
 /source variables = V732
 /target variables = rc_empl_cont.
variable labels rc_empl_cont "Continuity of employment among those employed in the past 12 months".

*** Health insurance ***.
* Note: The different types of health insurance can be country specific. Please check the v481* variables to see which ones you need.
* In addition, some surveys report this for all women/men and some report it among those that have heard of insurance. Please check what the population of interest is for reporting these indicators.
*Health insurance - Social security.
compute rc_hins_ss = (v481c=1).
variable labels rc_hins_ss "Health insurance coverage - social security".
value labels rc_hins_ss 0 "No" 1 "Yes".

*Health insurance - Other employer-based insurance.
compute rc_hins_empl = (v481b=1).
variable labels rc_hins_empl "Health insurance coverage - other employer-based insurance".
value labels rc_hins_empl 0 "No" 1 "Yes".

*Health insurance - Mutual Health Organization or community-based insurance.
compute rc_hins_comm = (v481a=1).
variable labels rc_hins_comm "Health insurance coverage - mutual health org. or community-based insurance".
value labels rc_hins_comm 0 "No" 1 "Yes".

*Health insurance - Privately purchased commercial insurance.
compute rc_hins_priv = (v481d=1).
variable labels rc_hins_priv "Health insurance coverage - privately purchased commercial insurance".
value labels rc_hins_priv 0 "No" 1 "Yes".

*Health insurance – Other.
compute rc_hins_other=0.
do repeat x=v481e v481f v481g v481h v481x.
+  if x=1 rc_hins_other=1.
end repeat.
variable labels rc_hins_other "Health insurance coverage - other type of insurance".
value labels rc_hins_other 0 "No" 1 "Yes".

*Health insurance – Any.
compute rc_hins_any=0.
do repeat x=v481a v481b v481c v481d v481e v481f v481g v481h v481x.
+  if x=1 rc_hins_any=1.
end repeat.
variable labels rc_hins_any "Have any health insurance".
value labels rc_hins_any 0 "No" 1 "Yes".

*** Tobacco use ***.

*Smokes cigarettes.
compute rc_tobc_cig=(any (v463aa,1,2) | v463e=1).
recode rc_tobc_cig (sysmis=0)(else=copy).
variable labels rc_tobc_cig "Smokes cigarettes".
value labels rc_tobc_cig
0 "No"
1 "Yes".

*Smokes other type of tobacco.
compute rc_tobc_other= (v463b=1 | v463f=1 | v463g=1). 
variable labels rc_tobc_other "Smokes other type of tobacco".
value labels rc_tobc_other
0 "No"
1 "Yes".

*Smokes any type of tobacco.
compute rc_tobc_smk_any= (any (v463aa,1,2) | v463e=1 | v463b=1 | v463f=1 | v463g=1). 
recode rc_tobc_smk_any (sysmis=0)(else=copy).
variable labels rc_tobc_smk_any "Smokes any type of tobacco".
value labels rc_tobc_smk_any
0 "No"
1 "Yes".

*Snuff by mouth.
compute rc_tobc_snuffm = v463h=1.
variable labels rc_tobc_snuffm "Uses snuff smokeless tobacco by mouth".
value labels rc_tobc_snuffm
0 "No"
1 "Yes".

*Snuff by nose.
compute rc_tobc_snuffn = v463d=1.
variable labels rc_tobc_snuffn "Uses snuff smokeless tobacco by nose".
value labels rc_tobc_snuffn
0 "No"
1 "Yes".

*Chewing tobacco.
compute rc_tobc_chew = v463c=1.
variable labels rc_tobc_chew "Chews tobacco".
value labels rc_tobc_chew
0 "No"
1 "Yes".

*Betel quid with tobacco.
compute rc_tobv_betel = v463i=1.
variable labels rc_tobv_betel "Uses betel quid with tobacco".
value labels rc_tobv_betel
0 "No"
1 "Yes".

*Other type of smokeless tobacco.
*Note: there may be other types of smokeless tobacco, please check all v463* variables. 
compute rc_tobc_osmkless = v463l=1.
variable labels rc_tobc_osmkless "Uses other type of smokeless tobacco".
value labels rc_tobc_osmkless
0 "No"
1 "Yes".

*Any smokeless tobacco.
compute rc_tobc_anysmkless=0.
do repeat x=v463h v463d v463c v463l.
+  if x=1 rc_tobc_anysmkless=1.
end repeat.
if rc_tobc_osmkless=1 rc_tobc_anysmkless=1.
variable labels rc_tobc_anysmkless "Uses any type of smokeless tobacco".
value labels rc_tobc_anysmkless
0 "No"
1 "Yes".

*Any tobacco.
compute rc_tobc_any= any (v463aa,1,2) | any (v463ab,1,2).
variable labels rc_tobc_any "Uses any type of tobacco - smoke or smokeless".
value labels rc_tobc_any
0 "No"
1 "Yes".

