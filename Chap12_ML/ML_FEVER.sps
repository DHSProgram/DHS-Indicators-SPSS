* Encoding: windows-1252.
*****************************************************************************************************
Program: 			ML_FEVER.sps
Purpose: 			Code indicators on fever, fever care-seeking, and antimalarial drugs
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:			Shireen Assaf and Cameron Taylor
Date last modified: August 31 by Ivana Bjelic
Notes:			There are similarities between the fever code in this do file and the ARI/Fever code for Chapter 10
			Several indicators (on care and specific antimalarial drugs) are country specific. Please see notes in the code.
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
ml_fever			"Fever symptoms in the 2 weeks before the survey"
ml_fev_care			"Advice or treatment sought for fever symptoms"
ml_fev_care_day		"Advice or treatment sought for fever symptoms on the same or next day"
ml_stick			"Child received heel or finger stick"
*
ml_fev_govh			"Fever treatment sought from government hospital among children with fever"
ml_fev_govh_trt		"Fever treatment sought from government hospital among children with fever that sought treatment"
ml_fev_govcent		"Fever treatment sought from government health center among children with fever"
ml_fev_govcent_trt            	"Fever treatment sought from government health center among children with fever that sought treatment"
ml_fev_pclinc		"Fever treatment sought from private hospital/clinic among children with fever"
ml_fev_pclinc_trt            	"Fever treatment sought from private hospital/clinic  among children with fever that sought treatment"
ml_fev_pdoc			"Fever treatment sought from private doctor among children with fever"
ml_fev_pdoc_trt		"Fever treatment sought from private doctor among children with fever that sought treatment"
ml_fev_pharm		"Fever treatment sought from a pharmacy among children with fever"
ml_fev_pharm_trt            	"Fever treatment sought from a pharmacy among children with fever that sought treatment"
*
ml_antimal			"Child took any antimalarial"
ml_act			"Child took an ACT"
ml_sp_fan			"Child took SP/Fansider"
ml_chloro			"Child took Chloroquine"
ml_amodia			"Child took Amodiaquine"
ml_quin_pill	                    	"Child took Quinine pills"
ml_quin_inj			"Child took Quinine injection or IV"
ml_artes_rec		"Child took Artesunate rectal"
ml_artes_inj		                  "Child took Artesunate injection or intravenous"
ml_antimal_other            	"Child took other antimalarial"
----------------------------------------------------------------------------.

*** Fever and care-seeking ***
*Fever.
do if b5<>0.
+compute ml_fever=(h22=1).
end if.
variable labels ml_fever "Fever symptoms in the 2 weeks before the survey".
value labels ml_fever 0 "No" 1 "Yes".

*Fever care-seeking.
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** the code below only excludes traditional practitioner (h32t). Some surveys also exclude pharmacies (h32k), shop (h32s) or other sources.
*** In some surveys traditional practitioner is h32w. Please check the data file using des h32*.
do if b5<>0 and ml_fever=1.
+compute ml_fev_care=0.
+do repeat x=h32a to h32x.
+  if x=1 ml_fev_care=1.
+end repeat.
end if.
/* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove.
* the 'k in the list on line 57 or do the following.
if b5<>0 & ml_fever=1 & h32k=1 ml_fev_care=0.
variable labels ml_fev_care "Advice or treatment sought for fever symptoms".
value labels ml_fev_care 0 "No" 1 "Yes".

*Fever care-seeking same or next day.
do if b5<>0 and ml_fever=1.
+compute ml_fev_care_day=0.
+if ml_fev_care=1 & h46b<2 ml_fev_care_day=1.
end if.
variable labels  ml_fev_care_day "Advice or treatment sought for fever symptoms on the same or next day".
value labels ml_fev_care_day 0 "No" 1 "Yes".

*Child with fever received heel or finger stick.
do if b5<>0 and ml_fever=1.
+compute ml_stick=0.
+if h47=1 ml_stick=1.
end if.
variable labels ml_stick "Child received heel or finger stick".
value labels ml_stick 0 "No" 1 "Yes".

*** Fever treatment by source ***.
* Two population bases: 1. among children with fever symptoms, 2. among children with fever symptoms that sought treatment
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. h32a-z indicates the source.

*Fever treamtment in government hospital.
do if b5<>0 and ml_fever=1.
+compute ml_fev_govh=0. 
+if h32a=1 ml_fev_govh=1.
end if.
variable labels ml_fev_govh "Fever treatment sought from government hospital among children with fever".
value labels ml_fev_govh 0 "No" 1 "Yes".

do if b5<>0 and ml_fev_care=1.
+compute ml_fev_govh_trt=0.
+if h32a=1 ml_fev_govh_trt=1.
end if.
variable labels ml_fev_govh_trt "Fever treatment sought from government hospital among children with fever that sought treatment".
value labels ml_fev_govh_trt 0 "No" 1 "Yes".

*Fever treamtment in government health center.
do if b5<>0 and ml_fever=1.
+compute ml_fev_govcent=0.
+if h32b=1 ml_fev_govcent=1.
end if.
variable labels ml_fev_govcent "Fever treatment sought from government health center among children with fever".
value labels ml_fev_govcent 0 "No" 1 "Yes".

do if b5<>0 and ml_fev_care=1.
+compute ml_fev_govcent_trt=0.
+if h32b=1 ml_fev_govcent_trt=1.
end if.
variable labels ml_fev_govcent_trt "Fever treatment sought from government health center among children with fever that sought treatment".
value labels ml_fev_govcent_trt 0 "No" 1 "Yes".

*Fever treatment from a private hospital/clinic.
do if b5<>0 and ml_fever=1.
+compute ml_fev_pclinc=0.
+if h32j=1 ml_fev_pclinc=1.
end if.
variable labels ml_fev_pclinc "Fever treatment sought from private hospital/clinic among children with fever".
value labels ml_fev_pclinc 0 "No" 1 "Yes".

do if b5<>0 and ml_fev_care=1.
+compute ml_fev_pclinc_trt=0.
+if h32j=1 ml_fev_pclinc_trt=1. 
end if.
variable labels ml_fev_pclinc_trt "Fever treatment sought from private hospital/clinic  among children with fever that sought treatment".
value labels ml_fev_pclinc_trt 0 "No" 1 "Yes".

*Fever treatment from a private doctor.
do if b5<>0 and ml_fever=1.
+compute ml_fev_pdoc=0.
+if h32l=1 ml_fev_pdoc=1.
end if.
variable labels  ml_fev_pdoc "Fever treatment sought from private doctor among children with fever".
value labels ml_fev_pdoc 0 "No" 1 "Yes".

do if b5<>0 and ml_fev_care=1.
+compute ml_fev_pdoc_trt=0.
+if h32l=1 ml_fev_pdoc_trt=1.
end if.
variable labels  ml_fev_pdoc_trt "Fever treatment sought from private doctor among children with fever that sought treatment".
value labels ml_fev_pdoc_trt 0 "No" 1 "Yes".

*Fever treatment from a pharmacy.
do if b5<>0 and ml_fever=1.
+compute ml_fev_pharm=0.
+if h32k=1 ml_fev_pharm=1.
end if.
variable labels  ml_fev_pharm "Fever treatment sought from a pharmacy among children with fever".
value labels ml_fev_pharm 0 "No" 1 "Yes".

do if b5<>0 and ml_fev_care=1.
+compute ml_fev_pharm_trt=0.
+if h32k=1 ml_fev_pharm_trt=1.
end if.
variable labels  ml_fev_pharm_trt "Fever treatment sought from a pharmacy among children with fever that sought treatment".
value labels ml_fev_pharm_trt 0 "No" 1 "Yes".


*** Antimalarial drugs ***
* Child with fever in past 2 weeks took any antimalarial
* This may need to be updated according to country specifications. 
* There may be additional survey-specific antimalarials in ml13f and ml13g or "s" variables. For instance in Ghana 2016 MIS there is s412f, s412g, s412h. Please search the date file.
* Also some drugs may be grouped. Please check final report and data files and adjust the code accordingly.
do if b5<>0 and ml_fever=1.
+compute ml_antimal=0.
+do repeat x=ml13a ml13aa ml13ab ml13b ml13c ml13d ml13da ml13e ml13f ml13g ml13h.
+  if x=1 ml_antimal=1.
+end repeat.
end if.
variable labels  ml_antimal "Child took any antimalarial".
value labels ml_antimal 0 "No" 1 "Yes".

*The antimalarial durg indicators below are among children with fever symptoms in the 2 weeks preceding the survey who took any antimalarial medication.	
*Child with fever in past 2 weeks took an ACT.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_act=0.
+if ml13e=1 ml_act=1.
end if.
variable labels ml_act "Child took an ACT".
value labels ml_act 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took SP/Fansider.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_sp_fan=0.
+if ml13a=1 ml_sp_fan=1.
end if.
variable labels  ml_sp_fan "Child took SP/Fansider".
value labels ml_sp_fan 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took Chloroquine.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_chloro=0.
+if ml13b=1 ml_chloro=1.
end if.
variable labels  ml_chloro "Child took Chloroquine".
value labels ml_chloro 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took Amodiaquine.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_amodia=0.
+if ml13c=1 ml_amodia=1.
end if.
variable labels ml_amodia "Child took Amodiaquine".
value labels ml_amodia 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took Quinine pills.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
compute ml_quin_pill=0.
if ml13d=1 ml_quin_pill=1.
end if.
variable labels ml_quin_pill "Child took Quinine pills".
value labels ml_quin_pill 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took Quinine injection or intravenous (IV).
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_quin_inj=0.
+if ml13da=1 ml_quin_inj=1.
end if.
variable labels ml_quin_inj "Child took Quinine injection or IV".
value labels ml_quin_inj 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took Artesunate rectal.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_artes_rec=0.
+if ml13aa=1 ml_artes_rec=1.
end if.
variable labels  ml_artes_rec "Child took Artesunate rectal".
value labels ml_artes_rec 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took Artesunate injection or intravenous.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_artes_inj=0.
+if ml13ab=1 ml_artes_inj=1.
end if.
variable labels  ml_artes_inj "Child took Artesunate injection or intravenous".
value labels ml_artes_inj 0 "No" 1 "Yes".

*Child with fever in past 2 weeks took other antimalarial.
do if b5<>0 and ml_fever=1 & ml_antimal=1.
+compute ml_antimal_other=0.
+if ml13h=1 ml_antimal_other=1.
end if.
variable labels  ml_antimal_other "Child took other antimalarial".
value labels ml_antimal_other 0 "No" 1 "Yes".
