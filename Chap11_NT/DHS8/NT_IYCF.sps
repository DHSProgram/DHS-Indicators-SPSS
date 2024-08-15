* Encoding: windows-1252.
*****************************************************************************************************
Program: 			NT_IYCF.sps
Purpose: 			Code to compute infant and child feeding indicators
Data inputs: 		KR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: May 16 2020 by Ivana Bjelic
Note:				
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
nt_bf_status		                  "Breastfeeding status for last-born child under 2 years"
nt_ebf			"Exclusively breastfed - last-born under 6 months"
nt_predo_bf			"Predominantly breastfed - last-born under 6 months"
nt_ageapp_bf		"Age-appropriately breastfed - last-born under 2 years"
nt_food_bf			"Introduced to solid, semi-solid, or soft foods - last-born 6-8 months"
*
nt_bf_curr			"Currently breastfeeding - last-born under 2 years"
nt_bf_cont_1yr		"Continuing breastfeeding at 1 year (12-15 months) - last-born under 2 years"
nt_bf_cont_2yr		"Continuing breastfeeding at 2 year (20-23 months) - last-born under 2 years"
*
nt_formula			"Child given infant formula in day/night before survey - last-born under 2 years"
nt_milk			"Child given other milk in day/night before survey- last-born under 2 years"
nt_liquids			"Child given other liquids in day/night before survey- last-born under 2 years"
nt_bbyfood			"Child given fortified baby food in day/night before survey- last-born under 2 years"
nt_grains			"Child given grains in day/night before survey- last-born under 2 years"
nt_vita			"Child given vitamin A rich food in day/night before survey- last-born under 2 years"
nt_frtveg			"Child given other fruits or vegetables in day/night before survey- last-born under 2 years"
nt_root			"Child given roots or tubers in day/night before survey- last-born under 2 years"
nt_nuts			"Child given legumes or nuts in day/night before survey- last-born under 2 years"
nt_meatfish			"Child given meat, fish, shellfish, or poultry in day/night before survey- last-born under 2 years"
nt_eggs			"Child given eggs in day/night before survey- last-born under 2 years"
nt_dairy			"Child given cheese, yogurt, or other milk products in day/night before survey- last-born under 2 years"
nt_solids			"Child given any solid or semisolid food in day/night before survey- last-born under 2 years"
*
nt_fed_milk			"Child given milk or milk products- last-born 6-23 months"
nt_mdd			"Child with minimum dietary diversity- last-born 6-23 months"
nt_mmf			"Child with minimum meal frequency- last-born 6-23 months"
nt_mad			"Child with minimum acceptable diet- last-born 6-23 months"
*
nt_ch_micro_vaf		"Youngest children age 6-23 mos living with mother given Vit A rich food"
nt_ch_micro_irf		"Youngest children age 6-23 mos living with mother given iron rich food"

----------------------------------------------------------------------------.

*** Breastfeeding and complemenatry feeding ***

*currently breastfed.
compute nt_bf_curr=0.
if m4=95 nt_bf_curr=1.
variable labels nt_bf_curr "Currently breastfeeding - last-born under 2 years".
value labels nt_bf_curr 1 "Yes" 0 "No".

*breastfeeding status.
compute water=0.
compute liquids=0.
compute milk=0.
compute solids=0.

*Child is given water.
if (v409>=1 & v409<=7) water=1.
		   
*Child given liquids.
do repeat x = v409a v410 v410a v412c v413a v413b v413c v413d.
+if x>=1 and x<=7 liquids=1.
end repeat.

*Given powder/tinned milk, formula, or fresh milk.
do repeat x = 411 v411a.
+if x>=1 and x<=7 milk=1.
end repeat.

*Given any solid food.
do repeat x =v414a v414b v414c v414d v414e v414f v414g v414h v414i v414j v414k v414l v414m v414n v414o v414p v414q v414r v414s  v414t v414u  v414v v414w.
+if x>=1 and x<=7 solids=1.
end repeat.
if v412a=1 or v412b=1 or m39a=1 solids=1.

compute nt_bf_status=1.
if water=1 nt_bf_status=2.
if liquids=1 nt_bf_status=3. 
if milk=1 nt_bf_status=4. 
if solids=1 nt_bf_status=5.
if nt_bf_curr=0 nt_bf_status=0.
variable labels nt_bf_status "Breastfeeding status for last-born child under 2 years".
value labels nt_bf_status 0"not bf" 1"exclusively bf" 2"bf & plain water" 3"bf & non-milk liquids" 4"bf & other milk" 5"bf & complemenatry foods".
	
*exclusively breastfed.
do if age<6.
+recode nt_bf_status (1=1) (else=0) into nt_ebf.
end if.
variable labels nt_ebf "Exclusively breastfed - last-born under 6 months".
value labels nt_ebf 1 "Yes" 0 "No".

*predominantly breastfeeding.
do if age<6.
+recode nt_bf_status (1 thru 3=1) (else=0) into nt_predo_bf.
end if.
variable labels nt_predo_bf "Predominantly breastfed - last-born under 6 months".
value labels nt_predo_bf 1 "Yes" 0 "No".

*age appropriate breastfeeding.
compute nt_ageapp_bf=0.
if nt_ebf=1 nt_ageapp_bf=1.
if nt_bf_status=5 & age>=6 and age<=23 nt_ageapp_bf=1.
variable labels nt_ageapp_bf "Age-appropriately breastfed - last-born under 2 years".
value labels nt_ageapp_bf 1 "Yes" 0 "No".

*introduced to food.
compute nt_food_bf = 0.
if (v412a=1 or v412b=1 or m39a=1) nt_food_bf=1.
do repeat x = v414a v414b v414c v414d v414e v414f v414g v414h v414i v414j v414k v414l v414m v414n v414o v414p v414q v414r v414s v414t v414u v414v v414w.
+ if x=1 nt_food_bf=1.
end repeat.
if age<6 or age>8 nt_food_bf=$sysmis.
variable labels nt_food_bf "Introduced to solid, semi-solid, or soft foods - last-born 6-8 months".
value labels nt_food_bf 1 "Yes" 0 "No".
	
*continuing breastfeeding at 1 year.
do if age>=12 and age<=15.
+compute nt_bf_cont_1yr=0.
+if m4=95 nt_bf_cont_1yr=1.
end if.
variable labels nt_bf_cont_1yr "Continuing breastfeeding at 1 year (12-15 months) - last-born under 2 years".
value labels nt_bf_cont_1yr 1 "Yes" 0 "No".

*continuing breastfeeding at 2 years.
do if age>=20 and age<=23.
+compute nt_bf_cont_2yr=0.
+if m4=95 nt_bf_cont_2yr=1.
end if.
variable labels nt_bf_cont_2yr "Continuing breastfeeding at 2 year (20-23 months) - last-born under 2 years".
value labels nt_bf_cont_2yr 1 "Yes" 0 "No".

*** Foods consumed ***

*country specific foods. These can be added to the foods below based on the survey.
*see examples in lines 186 and 200.
compute food1=0.
if v414a=1 food1=1.
compute food2=0.
if v414b=1 food2=1.
compute food3=0.
if v414c=1 food3=1.
compute food4=0.
if v414d=1 food4=1.

*Given formula.
compute nt_formula=0.
if v411a=1 nt_formula=1.
variable labels nt_formula "Child given infant formula in day/night before survey - last-born under 2 years".
value labels nt_formula 1 "Yes" 0 "No".

*Given other milk.
compute nt_milk=0.
if v411=1 nt_milk=1.
variable labels nt_milk "Child given other milk in day/night before survey- last-born under 2 years".
value labels nt_milk 1 "Yes" 0 "No". 

*Given other liquids.
compute nt_liquids=0.
if  v410=1 or v412c=1 or v413=1 nt_liquids=1.
variable labels nt_liquids "Child given other liquids in day/night before survey- last-born under 2 years".
value labels nt_liquids 1 "Yes" 0 "No". 

*Give fortified baby food.
compute nt_bbyfood=0.
if v412a=1 nt_bbyfood=1.
variable labels nt_bbyfood "Child given fortified baby food in day/night before survey- last-born under 2 years".
value labels nt_bbyfood 1 "Yes" 0 "No". 

*Given grains.
compute nt_grains=0.
if v412a=1 or v414e=1 nt_grains=1.
variable labels nt_grains "Child given grains in day/night before survey- last-born under 2 years".
value labels nt_grains 1 "Yes" 0 "No". 

*Given Vit A rich foods.
compute nt_vita=0.
if v414i=1 or v414j=1 or v414k=1 nt_vita=1.
variable labels nt_vita "Child given vitamin A rich food in day/night before survey- last-born under 2 years".
value labels nt_vita 1 "Yes" 0 "No". 

*Given other fruits or vegetables.
compute nt_frtveg=0.
if v414l=1 nt_frtveg=1.
variable labels nt_frtveg "Child given other fruits or vegetables in day/night before survey- last-born under 2 years".
value labels nt_frtveg 1 "Yes" 0 "No". 

*Given roots and tubers.
compute nt_root=0.
if v414f=1 nt_root=1.
variable labels nt_root "Child given roots or tubers in day/night before survey- last-born under 2 years".
value labels nt_root 1 "Yes" 0 "No". 
* country specific for Uganda 2016 DHS.
if v000="UG7" and food1=1 nt_root=1.

*Given nuts or legumes.
compute nt_nuts=0.
if v414o=1 nt_nuts=1.
variable labels nt_nuts "Child given legumes or nuts in day/night before survey- last-born under 2 years".
value labels nt_nuts 1 "Yes" 0 "No". 

*Given meat, fish, shellfish, or poultry.
compute nt_meatfish=0.
if v414h=1 or v414m=1 or v414n=1 nt_meatfish=1.
variable labels nt_meatfish "Child given meat, fish, shellfish, or poultry in day/night before survey- last-born under 2 years".
value labels nt_meatfish 1 "Yes" 0 "No". 
* country specific for Uganda 2016 DHS.
if v000="UG7" and food2=1 nt_meatfish=1.
	
*Given eggs.
compute nt_eggs=0.
if v414g=1 nt_eggs=1.
variable labels nt_eggs "Child given eggs in day/night before survey- last-born under 2 years".
value labels nt_eggs 1 "Yes" 0 "No". 

*Given dairy.
compute nt_dairy=0.
if v414p=1 or v414v=1 nt_dairy=1.
variable labels nt_dairy "Child given cheese, yogurt, or other milk products in day/night before survey- last-born under 2 years".
value labels nt_dairy 1 "Yes" 0 "No". 

*Given other solid or semi-solid foods.
compute nt_solids=0.
if (nt_bbyfood=1 or nt_grains=1 or nt_vita=1 or nt_frtveg=1 or nt_root=1 or nt_nuts=1 or nt_meatfish=1 or nt_eggs=1 or nt_dairy=1 or v414s=1) nt_solids=1.
variable labels nt_solids "Child given any solid or semisolid food in day/night before survey- last-born under 2 years".
value labels nt_solids 1 "Yes" 0 "No". 

*** Minimum feeding indicators ***

*Fed milk or milk products.
compute totmilkf = 0.
if v469e<8 totmilkf=totmilkf + v469e.
if v469f<8 totmilkf=totmilkf + v469f.
if v469x<8 totmilkf=totmilkf + v469x.
do if age>=6 and age<=23.
+compute nt_fed_milk=0.
+if (totmilkf>=2 or m4=95) nt_fed_milk=1.
end if.
variable labels nt_fed_milk "Child given milk or milk products- last-born 6-23 months".
value labels nt_fed_milk 1 "Yes" 0 "No".

*Min dietary diversity.
* 8 food groups.
*1. breastmilk.
compute group1=0.
if m4=95 group1=1.

*2. infant formula, milk other than breast milk, cheese or yogurt or other milk products.
compute group2=0.
if nt_formula=1 or nt_milk=1 or nt_dairy=1 group2=1.

*3. foods made from grains, roots, tubers, and bananas/plantains, including porridge and fortified baby food from grains.
compute group3=0.
if nt_grains=1 or nt_root=1 or nt_bbyfood=1 group3=1.
	 
*4. vitamin A-rich fruits and vegetables.
compute group4=0.
if  nt_vita=1 group4=1.

*5. other fruits and vegetables.
compute group5=0.
if nt_frtveg=1 group5=1.

*6. eggs.
compute group6=0.
if nt_eggs=1 group6=1.

*7. meat, poultry, fish, and shellfish (and organ meats).
compute group7=0.
if nt_meatfish=1 group7=1.

*8. legumes and nuts.
compute group8=0.
if nt_nuts=1 group8=1.

* add the food groups.
compute foodsum = sum(group1, group2, group3, group4, group5, group6, group7, group8).
do if age>=6 and age<=23.
+recode foodsum (0 thru 4, sysmis=0) (5 thru 8=1) into nt_mdd.
end if.
variable labels nt_mdd "Child with minimum dietary diversity, 5 out of 8 food groups- last-born 6-23 months".
value labels nt_mdd 1 "Yes" 0 "No". 
*older surveys are 4 out of 7 food groups, can use code below.
*compute foodsum = sum(group2, group3, group4, group5, group6, group7, group8) 
*recode foodsum (1 thru 3, sysmis=0) (4 thru 7=1) into nt_mdd.

*Min meal frequency.
compute feedings=totmilkf.
if m39>0 & m39<8 feedings= feedings + m39.
do if age>=6 and age<=23.
+compute nt_mmf=0.
+if (m4=95 & range(m39,2,7) & range(age,6,8)) or (m4=95 & range(m39,3,7) & range(age,9,23)) or (m4<>95 & feedings>=4 & range(age,6,23)) nt_mmf=1.
end if.
variable labels nt_mmf "Child with minimum meal frequency- last-born 6-23 months".
value labels nt_mmf 1 "Yes" 0 "No".

*Min acceptable diet.
compute foodsum2 = sum(nt_grains, nt_root, nt_nuts, nt_meatfish, nt_vita, nt_frtveg, nt_eggs).
do if age>=6 and age<=23.
+compute nt_mad=0.
+if (m4=95 & nt_mdd=1 & nt_mmf=1) or (m4<>95 & foodsum2>=4 & nt_mmf=1 & totmilkf>=2) nt_mad=1.
end if.
variable labels nt_mad "Child with minimum acceptable diet- last-born 6-23 months".
value labels nt_mad 1 "Yes" 0 "No".

*Consumed Vit A rich food.
compute nt_ch_micro_vaf=0.
do repeat x = v414g v414h v414i v414j v414k v414m v414n.
+if x=1 nt_ch_micro_vaf=1.
end repeat.
if age<6 or age>23 nt_ch_micro_vaf=$sysmis.
variable labels nt_ch_micro_vaf "Youngest children age 6-23 mos living with mother given Vit A rich food".
value labels nt_ch_micro_vaf 1 "Yes" 0 "No". 

*Consumed iron rich food.
compute nt_ch_micro_irf=0.
do repeat x = v414g v414h v414m v414n.
+if x=1 nt_ch_micro_irf=1.
end repeat.
if age<6 or age>23 nt_ch_micro_irf=$sysmis.
variable labels nt_ch_micro_irf "Youngest children age 6-23 mos living with mother given iron rich food".
value labels nt_ch_micro_irf 1 "Yes" 0 "No". 

