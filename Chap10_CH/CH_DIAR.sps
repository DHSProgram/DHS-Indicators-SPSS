* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CH_DIAR.sps
Purpose: 			Code diarrhea variables
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: September 02 2019 by Ivana Bjelic
Notes:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
ch_diar			"Diarrhea in the 2 weeks before the survey"
ch_diar_care		"Advice or treatment sought for diarrhea"
*
ch_diar_liq			"Amount of liquids given for child with diarrhea"
ch_diar_food		"Amount of food given for child with diarrhea"
*
ch_diar_ors			"Given oral rehydration salts for diarrhea"
ch_diar_rhf			"Given recommended homemade fluids for diarrhea"
ch_diar_ors_rhf		"Given either ORS or RHF for diarrhea"
ch_diar_zinc		"Given zinc for diarrhea"
ch_diar_zinc_ors	                   "Given zinc and ORS for diarrhea"
ch_diar_ors_fluid            	"Given ORS or increased fluids for diarrhea"
ch_diar_ort			"Given oral rehydration treatment and increased liquids for diarrhea"
ch_diar_ort_feed                	"Given ORT and continued feeding for diarrhea"
ch_diar_antib		"Given antibiotic drugs for diarrhea"
ch_diar_antim		"Given antimotility drugs for diarrhea"
ch_diar_intra		"Given Intravenous solution for diarrhea"
ch_diar_other		"Given home remedy or other treatment  for diarrhea"
ch_diar_notrt		"No treatment for diarrhea"
*
ch_diar_govh 		"Diarrhea treatment sought from government hospital among children with diarrhea"
ch_diar_govh_trt             	"Diarrhea treatment sought from government hospital among children with diarrhea that sought treatment"
ch_diar_govh_ors             	"Diarrhea treatment sought from government hospital among children with diarrhea that received ORS"
ch_diar_govcent             	"Diarrhea treatment sought from government health center among children with diarrhea"
ch_diar_govcent_trt                          "Diarrhea treatment sought from government health center among children with diarrhea that sought treatment"
ch_diar_govcent_ors                         "Diarrhea treatment sought from government health center among children with diarrhea that received ORS"
ch_diar_pclinc 		"Diarrhea treatment sought from private hospital/clinic among children with diarrhea"
ch_diar_pclinc_trt             	"Diarrhea treatment sought from private hospital/clinic among children with diarrhea that sought treatment"
ch_diar_pclinc_ors         	"Diarrhea treatment sought from private hospital/clinic among children with diarrhea that received ORS"
ch_diar_pdoc 		"Diarrhea treatment sought from private doctor among children with diarrhea"
ch_diar_pdoc_trt             	"Diarrhea treatment sought from private doctor among children with diarrhea that sought treatment"
ch_diar_pdoc_ors             	"Diarrhea treatment sought from private doctor among children with diarrhea that received ORS"
ch_diar_pharm 		"Diarrhea treatment sought from a pharmacy among children with diarrhea"
ch_diar_pharm_trt             	"Diarrhea treatment sought from a pharmacy among children with diarrhea that sought treatment"
ch_diar_pharm_ors             	"Diarrhea treatment sought from a pharmacy among children with diarrhea that received ORS"
----------------------------------------------------------------------------.
	
*Diarrhea symptoms.
do if b5<>0.
+compute ch_diar=0.
+if h11=1 | h11=2 ch_diar=1.
end if.
variable labels ch_diar "Diarrhea in the 2 weeks before the survey".
value labels ch_diar 0 "No" 1 "Yes".

*Diarrhea treatment.
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** the code below only excludes traditional practitioner (h12t). Some surveys also exclude pharmacies (h12k), shop (h12s) or other sources.
do if b5<>0 and ch_diar=1.
+compute ch_diar_care=0.
+do repeat x=h12a to h12x.
+  if x=1 ch_diar_care=1.
+end repeat.
* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove.
* the 'k in the list on line 66 or do the following.
*+if h12k=1 ch_diar_care=0.
end if.
variable labels ch_diar_care "Advice or treatment sought for diarrhea".
value labels ch_diar_care 0 "No" 1 "Yes".
    
*Liquid intake.
do if ch_diar=1.
+recode h38 (5=1)(4=2)(3=3)(2=4)(0=5)(8=9) into ch_diar_liq.
end if.
variable labels ch_diar_liq "Amount of liquids given for child with diarrhea".
value labels ch_diar_liq 1  "More" 2 "Same as usual" 3  "Somewhat less" 4 "Much less" 5 "None" 9"DK/Missing".

*Food intake.
do if ch_diar=1.
+recode h39 (5=1) (4=2) (3=3) (2=4) (0=5)(1=6)(8=9) into ch_diar_food.
end if.
variable labels ch_diar_food "Amount of food given for child with diarrhea".
value labels ch_diar_food 1  "More" 2 "Same as usual" 3  "Somewhat less" 4 "Much less" 5 "None" 6  "Never gave food" 9 "Don't know/missing".

*ORS.
do if ch_diar=1.
+compute ch_diar_ors=0.
+if (h13=1 | h13=2 | h13b=1) ch_diar_ors=1.
end if.
variable labels ch_diar_ors "Given oral rehydration salts for diarrhea".
value labels ch_diar_ors 0 "No" 1 "Yes".

*RHF.
do if ch_diar=1.
+compute ch_diar_rhf=0.
+if (h14=1 | h14=2) ch_diar_rhf=1.
end if.
variable labels ch_diar_rhf "Given recommended homemade fluids for diarrhea".
value labels ch_diar_rhf 0 "No" 1 "Yes".

*ORS or RHF.
do if ch_diar=1.
+compute ch_diar_ors_rhf=0.
+if (h13=1 | h13=2 | h13b=1 | h14=1 | h14=2) ch_diar_ors_rhf=1.
end if.
variable labels ch_diar_ors_rhf "Given either ORS or RHF for diarrhea".
value labels ch_diar_ors_rhf 0 "No" 1 "Yes".

*Zinc.
do if ch_diar=1.
+compute ch_diar_zinc=0.
+if  (h15e=1) ch_diar_zinc=1.
end if.
variable labels ch_diar_zinc "Given zinc for diarrhea".
value labels ch_diar_zinc 0 "No" 1 "Yes".

*Zinc and ORS.
do if ch_diar=1.
+compute ch_diar_zinc_ors=0.
+if ((h13=1 | h13=2 | h13b=1) & (h15e=1)) ch_diar_zinc_ors=1.
end if.
variable labels ch_diar_zinc_ors "Given zinc and ORS for diarrhea".
value labels ch_diar_zinc_ors 0 "No" 1 "Yes".

*ORS or increased liquids.
do if ch_diar=1.
+compute ch_diar_ors_fluid=0.
+if (h13=1 | h13=2 | h13b=1 | h38=5) ch_diar_ors_fluid=1.
end if.
variable labels ch_diar_ors_fluid "Given ORS or increased fluids for diarrhea".
value labels ch_diar_ors_fluid 0 "No" 1 "Yes".

*ORT.
do if ch_diar=1.
+compute ch_diar_ort=0.
+if (h13=1 | h13=2 | h14=1 | h14=2 | h38=5) ch_diar_ort=1. 
*older surveys do not have h13b.
+if h13b=1 ch_diar_ort=1.
end if.
variable labels ch_diar_ort "Given oral rehydration treatment and increased liquids for diarrhea".
value labels ch_diar_ort 0 "No" 1 "Yes".

*ORT and continued feeding.
do if ch_diar=1.
+compute ch_diar_ort_feed=0.
+if ((h13=1 | h13=2 | h13b=1 | h14=1 | h14=2 | h38=5)&(h39>=3 & h39<=5)) ch_diar_ort_feed=1.
end if.
variable labels ch_diar_ort_feed "Given ORT and continued feeding for diarrhea".
value labels ch_diar_ort_feed 0 "No" 1 "Yes".

*Antiobiotics.
do if ch_diar=1.
compute ch_diar_antib=0.
if (h15=1 | h15b=1) ch_diar_antib=1.
end if.
variable labels ch_diar_antib "Given antibiotic drugs for diarrhea".
value labels ch_diar_antib 0 "No" 1 "Yes".

*Antimotility drugs.
do if ch_diar=1.
+compute ch_diar_antim=0.
+if h15a=1 ch_diar_antim=1.
end if.
variable labels ch_diar_antim "Given antimotility drugs for diarrhea".
value labels ch_diar_antim 0 "No" 1 "Yes".

*Intravenous solution.
do if ch_diar=1.
+compute ch_diar_intra=0.
+if h15c=1 ch_diar_intra=1.
end if.
variable labels ch_diar_intra "Given Intravenous solution for diarrhea".
value labels ch_diar_intra 0 "No" 1 "Yes".

*Home remedy or other treatment.
do if ch_diar=1.
+compute ch_diar_other=0.
+if h15d=1 | h15f=1 | h15g=1 | h15h=1 | h15i=1 | h15j=1 | h15k=1 | h15l=1 | h15m=1 | h20=1 ch_diar_other=1.
end if.
variable labels ch_diar_other "Given home remedy or other treatment for diarrhea".
value labels ch_diar_other 0 "No" 1 "Yes".

*No treatment.
do if ch_diar=1.
+compute ch_diar_notrt=0.
+if h21a=1 ch_diar_notrt=1.
* to double check if received any treatment then the indicator should be replaced to 0.
+do repeat x=ch_diar_ors ch_diar_rhf ch_diar_ors_rhf ch_diar_zinc ch_diar_zinc_ors ch_diar_ors_fluid ch_diar_ort ch_diar_ort_feed ch_diar_antib ch_diar_antim ch_diar_intra ch_diar_other.
+  if x=1 ch_diar_notrt=0.
+end repeat.
+end if.
variable labels ch_diar_notrt "No treatment for diarrhea".
value labels ch_diar_notrt 0 "No" 1 "Yes".

***Diarrhea treatment by source (among children with diarrhea symptoms).
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. h12a-z indicates the source.

*Diarrhea treamtment in government hospital.
do if b5<>0 and ch_diar=1.
+compute ch_diar_govh=0.
+if ch_diar=1 & h12a=1 ch_diar_govh=1.
end if.
variable labels ch_diar_govh "Diarrhea treatment sought from government hospital among children with diarrhea".
value labels ch_diar_govh 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_care=1.
+compute ch_diar_govh_trt=0.
+if h12a=1 ch_diar_govh_trt=1.
end if.
variable labels ch_diar_govh_trt "Diarrhea treatment sought from government hospital among children with diarrhea that sought treatment".
value labels ch_diar_govh_trt 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_ors=1.
+compute ch_diar_govh_ors=0.
+if h12a=1 ch_diar_govh_ors=1.
end if.
variable labels ch_diar_govh_ors "Diarrhea treatment sought from government hospital among children with diarrhea that received ORS".
value labels ch_diar_govh_ors 0 "No" 1 "Yes".

*Diarrhea treamtment in government health center.
do if b5<>0 and ch_diar=1.
+compute ch_diar_govcent=0.
+if h12b=1 ch_diar_govcent=1.
end if.
variable labels ch_diar_govcent "Diarrhea treatment sought from government health center among children with diarrhea".
value labels ch_diar_govcent 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_care=1.
+compute ch_diar_govcent_trt=0.
+if h12b=1 ch_diar_govcent_trt=1.
end if.
variable labels ch_diar_govcent_trt "Diarrhea treatment sought from government health center among children with diarrhea that sought treatment".
value labels ch_diar_govcent_trt 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_ors=1.
compute ch_diar_govcent_ors=0.
if h12b=1 ch_diar_govcent_ors=1.
end if.
variable labels ch_diar_govcent_ors "Diarrhea treatment sought from government health center among children with diarrhea that received ORS".
value labels ch_diar_govcent_ors 0 "No" 1 "Yes".

*Diarrhea treatment from a private hospital/clinic.
do if b5<>0 and ch_diar=1.
+compute ch_diar_pclinc=0.
+if h12j=1 ch_diar_pclinc=1 .
end if.
variable labels ch_diar_pclinc "Diarrhea treatment sought from private hospital/clinic among children with diarrhea".
value labels ch_diar_pclinc 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_care=1.
+compute ch_diar_pclinc_trt=0.
+if h12j=1 ch_diar_pclinc_trt=1.
end if.
variable labels ch_diar_pclinc_trt "Diarrhea treatment sought from private hospital/clinic among children with diarrhea that sought treatment".
value labels ch_diar_pclinc_trt 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_ors=1.
+compute ch_diar_pclinc_ors=0.
+if h12j=1 ch_diar_pclinc_ors=1.
end if.
variable labels ch_diar_pclinc_ors "Diarrhea treatment sought from private hospital/clinic among children with diarrhea that received ORS".
value labels ch_diar_pclinc_ors 0 "No" 1 "Yes".

*Diarrhea treatment from a private doctor.
do if b5<>0 and ch_diar=1.
+compute ch_diar_pdoc=0.
+if h12l=1 ch_diar_pdoc=1.
end if.
variable labels ch_diar_pdoc "Diarrhea treatment sought from private doctor among children with diarrhea".
value labels ch_diar_pdoc 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_care=1.
+compute ch_diar_pdoc_trt=0.
+if h12l=1 ch_diar_pdoc_trt=1.
end if.
variable labels ch_diar_pdoc_trt "Diarrhea treatment sought from private doctor among children with diarrhea that sought treatment".
value labels ch_diar_pdoc_trt 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_ors=1.
+compute ch_diar_pdoc_ors=0.
+if h12a=1 ch_diar_pdoc_ors=1.
end if.
variable labels ch_diar_pdoc_ors "Diarrhea treatment sought from private doctor among children with diarrhea that received ORS".
value labels ch_diar_pdoc_ors 0 "No" 1 "Yes".

do if b5<>0 and ch_diar=1.
*Diarrhea treatment from a pharmacy.
+compute ch_diar_pharm=0.
+if h12k=1 ch_diar_pharm=1.
end if.
variable labels ch_diar_pharm "Diarrhea treatment sought from a pharmacy among children with diarrhea".
value labels ch_diar_pharm 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_care=1.
+compute ch_diar_pharm_trt=0.
+if h12k=1 ch_diar_pharm_trt=1. 
end if.
variable labels ch_diar_pharm_trt "Diarrhea treatment sought from a pharmacy among children with diarrhea that sought treatment".
value labels ch_diar_pharm_trt 0 "No" 1 "Yes".

do if b5<>0 and ch_diar_ors=1.
+compute ch_diar_pharm_ors=0.
+if h12k=1 ch_diar_pharm_ors=1.
end if.
variable labels ch_diar_pharm_ors "Diarrhea treatment sought from a pharmacy among children with diarrhea that received ORS".
value labels ch_diar_pharm_ors 0 "No" 1 "Yes".
