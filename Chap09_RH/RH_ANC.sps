* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			RH_ANC.sps
Purpose: 			Code ANC indicators
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Ivana Bjelic
Date last modified: June 29 2019 by Ivana Bjelic 
*****************************************************************************************************/

 *----------------------------------------------------------------------------//
Variables created in this file:
rh_anc_pv			"Person providing assistance during ANC"
rh_anc_pvskill		"Skilled assistance during ANC"
rh_anc_numvs		"Number of ANC visits"
rh_anc_4vs			"Attended 4+ ANC visits"
rh_anc_moprg		"Attended ANC <4 months of pregnancy"
rh_anc_median		"Median months pregnant at first visit" (scalar not a variable)
rh_anc_iron			"Took iron tablet/syrup during the pregnancy of last birth"
rh_anc_parast		"Took intestinal parasite drugs during pregnancy of last birth"
rh_anc_prgcomp		"Informed of pregnancy complications during ANC visit"
rh_anc_bldpres		"Blood pressure was taken during ANC visit"
rh_anc_urine		"Urine sample was taken during ANC visit"
rh_anc_bldsamp		"Blood sample was taken during ANC visit"
rh_anc_toxinj		"Received 2+ tetanus injections during last pregnancy"
rh_anc_neotet		"Protected against neonatal tetanus"
/----------------------------------------------------------------------------*/

*** ANC visit indicators ***

* ANC by type of provider.
** Note: Please check the final report for this indicator to determine the categories and adjust the code and label accordingly. 
do if (age < period).
+ if sysmis(m2a$1) = 0 rh_anc_pv = 6.
+ if m2f$1 = 1 or m2g$1 = 1 or m2h$1 = 1 or m2i$1 = 1 or m2j$1 = 1 or m2k$1 = 1 or m2l$1 = 1 or m2m$1 = 1 rh_anc_pv = 4.
+ if m2c$1 = 1 or m2d$1 = 1 or m2e$1 = 1 rh_anc_pv = 3.
+ if m2b$1 = 1  rh_anc_pv = 2.
+ if m2a$1 = 1  rh_anc_pv = 1.
+ if m2a$1 = 9  rh_anc_pv = 5.
end if.
variable labels rh_anc_pv "Person providing assistance during ANC".
value labels rh_anc_pv
1 "Doctor" 		
2 "Nurse/midwife"	
3 "Other health worker" 
4 "TBA/other/relative"	
5 "Missing"
6 "No ANC".

* ANC by skilled provider.
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
do if (age < period).
+ recode rh_anc_pv (1 thru 3 = 1) (4, 5, 6 = 0) into rh_anc_pvskill.
end if.
variable labels rh_anc_pvskill "Skilled assistance during ANC".
value labels rh_anc_pvskill 0 "Unskilled/no one" 1 "Skilled provider".

* Number of ANC visits in 4 categories that match the table in the final report.
do if (age < period).
+ recode m14$1 (0=0) (1=1) (2,3=2) (4 thru 90=3) (98,99=9) into rh_anc_numvs.
end if.
variable labels rh_anc_numvs "Number of ANC visits".
value labels  rh_anc_numvs
0 "None"
1 "1"
2 "2-3"
3 "4+"
9 "don't know/missing".
	
* 4+ ANC visits.
do if (age < period).
+ recode rh_anc_numvs (0, 1, 2, 9 = 0) (3=1) into rh_anc_4vs.
end if.
variable labels rh_anc_4vs "Attended 4+ ANC visits".
value labels rh_anc_4vs 0 "no" 1 "yes".

* Number of months pregnant at time of first ANC visit.
do if sysmis(m14$1)=0 and (age < period).
+ recode m13$1 (0 thru 3=1) (4,5=2) (6,7=3)(8 thru 90=4) (else=9) into rh_anc_moprg.
+ if m14$1 = 0 rh_anc_moprg = 0.
end if.
variable labels rh_anc_moprg "Number of months pregnant at time of first ANC visit".
value labels rh_anc_moprg 
0 "no anc"
1 "<4"
2 "4-5"
3 "6-7"
4 "8+"
9 "don't know/missing".

* ANC before 4 months.
recode rh_anc_moprg (0, 2 thru 5=0) (1=1) into rh_anc_4mo.
variable labels rh_anc_4mo "Attended ANC < 4 months of pregnancy".
value labels rh_anc_4mo  0 "no" 1 "yes".

* Median number of months pregnant at time of 1st ANC.
* Any ANC visits (for denominator).
recode m14$1 (0, 99 = 0) (1 thru 60,98 = 1) into ancany.
value labels ancany 0 "None" 1 "1+ ANC visit".
	
recode m13$1 (98,99=sysmis) (else=copy) into anctiming.
* Total.
** 50% percentile.
weight by v005.
aggregate
  /outfile = * mode=addvariables
  /break=
  /sp50=median(anctiming).
	
compute dummyU=$sysmis.
if ancany=1 dummyU = 0.
if anctiming<sp50 & ancany=1 dummyU = 1.
aggregate
  /outfile = * mode=addvariables
  /break=
  /sU=mean(dummyU).
	
compute dummyL=$sysmis.
if ancany=1 dummyL = 0.
if anctiming<=sp50 & ancany=1 dummyL = 1.
aggregate
  /outfile = * mode=addvariables
  /break=
  /sL=mean(dummyL).

compute rh_anc_median=(sp50-1)+((0.5-sL)/(sU-sL))+0.1.
variable labels rh_anc_median "Total- Median months pregnant at first visit".
	
* Urban/Rural.
aggregate
  /outfile = * mode=addvariables
  /break=v025
  /sp50urbrur=median(anctiming).
	
compute dummyUurbrur=$sysmis.
if ancany=1 dummyUurbrur = 0.
if anctiming<sp50 & ancany=1 dummyUurbrur = 1.
aggregate
  /outfile = * mode=addvariables
  /break=v025
  /sUurbrur=mean(dummyUurbrur).
	
compute dummyLurbrur=$sysmis.
if ancany=1 dummyLurbrur = 0.
if anctiming<=sp50 & ancany=1 dummyLurbrur = 1.
aggregate
  /outfile = * mode=addvariables
  /break=v025
  /sLurbrur=mean(dummyLurbrur).

do if  v025=1.
+ compute rh_anc_median_urban=(sp50urbrur-1)+((0.5-sLurbrur)/(sUurbrur-sLurbrur))+0.1.
end if.
do if  v025=2.
+ compute rh_anc_median_rural=(sp50urbrur-1)+((0.5-sLurbrur)/(sUurbrur-sLurbrur))+0.1.
end if.
variable labels rh_anc_median_urban "Urban- Median months pregnant at first visit".
variable labels rh_anc_median_rural "Rural- Median months pregnant at first visit".	

weight off.
	
*** ANC components ***	
*(0 8 9=0 "no") 
* Took iron tablets or syrup.
do if (v208 > 0 and age < period).
+ recode m45$1 (1=1) (else=0) into rh_anc_iron.
end if.
variable labels rh_anc_iron "Took iron tablet/syrup during pregnancy of last birth".
value labels rh_anc_iron 0 "no" 1 "yes".
	
* Took intestinal parasite drugs.
do if (v208 > 0 and age < period).
+recode M60$1 (1=1) (else=0) into rh_anc_parast.
end if.
variable labels rh_anc_parast "Took intestinal parasite drugs during pregnancy of last birth".
value labels rh_anc_parast 0 "no" 1 "yes".
* for surveys that do not have this variable.
*compute rh_anc_parast=$sysmis.
	
* Among women who had ANC for their most recent birth.

*/Informed of pregnancy complications.
if ancany=1 rh_anc_prgcomp = 0.
if m43$1=1 & ancany=1 rh_anc_prgcomp = 1.
variable labels rh_anc_prgcomp "Informed of pregnancy complications during ANC visit".
value labels rh_anc_prgcomp 0 "no" 1 "yes".
	
*/Blood pressure measured.
if ancany=1 rh_anc_bldpres = 0.
if m42c$1=1 & ancany=1 rh_anc_bldpres=1.
variable labels rh_anc_bldpres "Blood pressure was taken during ANC visit".
value labels rh_anc_bldpres 0 "no" 1 "yes".
	
*/Urine sample taken.
if ancany=1 rh_anc_urine = 0.
if m42d$1=1 & ancany=1 rh_anc_urine=1.
variable labels rh_anc_urine "Urine sample was taken during ANC visit".
value labels rh_anc_urine 0 "no" 1 "yes".
	
*/Blood sample taken.
if ancany=1 rh_anc_bldsamp = 0.
if m42e$1=1 & ancany=1 rh_anc_bldsamp = 1.
variable labels rh_anc_bldsamp "Blood sample was taken during ANC visit".
value labels rh_anc_bldsamp 0 "no" 1 "yes".
	
*/tetnaus toxoid injections.
recode m1$1 (0, 1, 8, 9 = 0) (2 thru 7 = 1) into rh_anc_toxinj.
if age>=period rh_anc_toxinj = $sysmis.
variable labels rh_anc_toxinj "Received 2+ tetanus injections during last pregnancy".
value labels rh_anc_toxinj 0 "no" 1 "yes".
	
*/neonatal tetanus.
* this was copied from the DHS user forum. Code was prepared by Lindsay Mallick.

** To check if survey has m1a$1. If variable doesnt exist, empty variable is created.
*older surverys do not have this indicator.m1a$1 (number of tetanus injections before pregnancy) is needed to compute this indicator.
begin program.
import spss, spssaux
varList = "m1a$1"
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
  /m1a$1_included=mean(m1a$1).

recode m1a$1_included (lo thru hi = 1)(else = 0).

* for surveys that have this indicator.
do if m1a$1_included=1.
+ compute tet2lastp = 0.
+ if m1$1>1 & m1$1<8 tet2lastp = 1.
	
* temporary vars needed to compute the indicator.
+ compute totet = 0.
+ compute ttprotect = 0.		   
+ if (m1$1>0 & m1$1<8) totet = m1$1.
+ if (m1a$1 > 0 & m1a$1 < 8) totet = m1a$1 + totet.
				   
*now generating variable for date of last injection - will be 0 for women with at least 1 injection at last pregnancy.
+ compute lastinj = 9999.
+ if (m1$1>0 & m1$1 <8) lastinj = 0.
+ compute ageyr = (age)/12.
*years ago of last shot - (age at of child), yields some negatives.
+ if m1d$1 <20 & (m1$1=0 | (m1$1>7 & m1$1<9996))  lastinj = (m1d$1 - ageyr).

*now generate summary variable for protection against neonatal tetanus.
if tet2lastp =1  ttprotect = 1.
* at least 2 shots in last 3 years.
if (totet>=2 & lastinj<=2) ttprotect = 1.
*at least 3 shots in last 5 years.
if (totet>=3 & lastinj<=4) ttprotect = 1.
*at least 4 shots in last 10 years.
if (totet>=4 &  lastinj<=9) ttprotect = 1.
*at least 2 shots in lifetime.
if totet>=5 ttprotect = 1 .

+ variable labels ttprotect "Full neonatal tetanus protection".
				   
+ compute rh_anc_neotet = ttprotect.
+ if  bidx$01<>1 or age>=period rh_anc_neotet =$sysmis. 
+ if  sysmis(ancany) rh_anc_neotet =$sysmis.
+ variable labels rh_anc_neotet "Protected against neonatal tetanus".
+ value labels rh_anc_neotet 0 "no" 1 "yes".
	
end if.

*for surveys that do not have this indicator, generate indicator as missing value. 
do if m1a$1_included <> 1.
compute rh_anc_neotet=$sysmis.
end if.

************************************************************************
	