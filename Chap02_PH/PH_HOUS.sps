* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_HOUS.sps
Purpose: 			Code to compute household characteristics, possessions, and smoking in the home
Data inputs: 		HR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: June 16, 2020 by Ivana Bjelic
Note:				These indicators can also be computed using the PR file but you would need to select for dejure household memebers
					using hv102=1. Please see the Guide to DHS Statistics
					There may be some other country specific household possessions available in the dataset. 
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
*
ph_electric		"Have electricity"
ph_floor		"Flooring material"
ph_rooms_sleep	"Rooms for sleeping"
ph_cook_place	"Place for cooking"
ph_cook_fuel	"Type fo cooking fuel"
ph_cook_solid	"Using solid fuel for cooking"
ph_cook_clean	"Using clean fuel for cooking"
*	
ph_smoke		"Frequency of smoking at home"	
*
ph_radio		"Owns a radio"
ph_tv		"Owns a tv"
ph_mobile		"Owns a mobile phone"
ph_tel		"Owns a non-mobile telephone"
ph_comp		"Owns a computer"
ph_frig		"Owns a refrigerator"
ph_bike		"Owns a bicycle"
ph_cart		"Owns a animal drawn cart"
ph_moto		"Owns a motorcycle/scooter"
ph_car		"Owns a car or truck"
ph_boat		"Owns a boat with a motor"
ph_agriland		"Owns agricultural land"
ph_animals		"Owns livestock or farm animals"

*----------------------------------------------------------------------------.

*** Household characteristics ***

* Have electricity.
compute ph_electric= hv206.
variable labels ph_electric "Have electricity".
value labels ph_electric 0"No" 1"Yes".

* Flooring material.
compute ph_floor= hv213. 
variable labels ph_floor "Flooring material".
apply dictionary from *
 /source variables = hv213
 /target variables = ph_floor
.

* Number of rooms for sleeping.
recode hv216 (1=1) (2=2) (3 thru hi=3) into ph_rooms_sleep.
variable labels ph_rooms_sleep "Rooms for sleeping".
value labels ph_rooms_sleep 1 "One" 2  "Two" 3 "Three or more".

* Place for cooking.
compute ph_cook_place = hv241.
if hv226=95  ph_cook_place= 4.
add value labels hv241 4 "No food cooked in household".
variable labels ph_cook_place "Place for cooking".
apply dictionary from *
 /source variables = hv241
 /target variables = ph_cook_place
.

* Type of cooking fuel.
compute ph_cook_fuel= hv226. 
variable labels ph_cook_fuel "Type fo cooking fuel".
apply dictionary from *
 /source variables = hv226
 /target variables = ph_cook_fuel
.

* Solid fuel for cooking.
compute ph_cook_solid=0.
if  range(hv226,6,11) ph_cook_solid=1.
variable labels ph_cook_solid "Using solid fuel for cooking".
value labels ph_cook_solid 0"No" 1"Yes".

* Clean fuel for cooking.
compute ph_cook_clean=0.
if  range(hv226,1,4) ph_cook_clean=1.
variable labels ph_cook_clean "Using clean fuel for cooking".
value labels ph_cook_clean 0"No" 1"Yes".

* Frequency of smoking in the home.
compute ph_smoke= hv252.	
variable labels ph_smoke "Frequency of smoking at home".
apply dictionary from *
 /source variables = hv252
 /target variables = ph_smoke
.

*** Household possessions ***

* Radio.
compute ph_radio=0.
if  hv207=1 ph_radio=1.
variable labels ph_radio "Owns a radio".
value labels ph_radio 0"No" 1"Yes".

* TV.
compute ph_tv=0.
if  hv208=1 ph_tv=1.
variable labels ph_tv "Owns a tv".
value labels ph_tv 0"No" 1"Yes".

* Mobile phone.
compute ph_mobile=0.
if  hv243a=1 ph_mobile=1.
variable labels ph_mobile "Owns a mobile phone".
value labels ph_mobile 0"No" 1"Yes".

* Non-mobile phone.
compute ph_tel=0.
if  hv221=1 ph_tel=1.
variable labels ph_tel "Owns a non-mobile telephone".
value labels ph_tel 0"No" 1"Yes".

* Computer.
compute ph_comp=0.
if  hv243e=1 ph_comp=1.
variable labels ph_comp "Owns a computer".
value labels ph_comp 0"No" 1"Yes".

* Refrigerator.
compute ph_frig=0.
if  hv209=1 ph_frig=1.
variable labels ph_frig "Owns a refrigerator".
value labels ph_frig 0"No" 1"Yes".

* Bicycle.
compute ph_bike=0.
if  hv210=1 ph_bike=1.
variable labels ph_bike "Owns a bicycle".
value labels ph_bike 0"No" 1"Yes".

* Animal drawn cart.
compute ph_cart=0.
if  hv243c=1 ph_cart=1.
variable labels ph_cart "Owns a animal drawn cart".
value labels ph_cart 0"No" 1"Yes".

* Motorcycle or scooter.
compute ph_moto=0.
if  hv211=1 ph_moto=1.
variable labels ph_moto "Owns a motorcycle/scooter".
value labels ph_moto 0"No" 1"Yes".

* Car or truck.
compute ph_car=0.
if  hv212=1 ph_car=1.
variable labels ph_car "Owns a car or truck".
value labels ph_car 0"No" 1"Yes".

* Boat with a motor.
compute ph_boat=0.
if  hv243d=1 ph_boat=1.
variable labels ph_boat "Owns a boat with a motor".
value labels ph_boat 0"No" 1"Yes".

* Agricultural land.
compute ph_agriland=0.
if  hv244=1 ph_agriland=1.
variable labels ph_agriland "Owns agricultural land".
value labels ph_agriland 0"No" 1"Yes".

* Livestook.
compute ph_animals=0.
if hv246=1 ph_animals=1.
variable labels ph_animals "Owns livestock or farm animals".
value labels ph_animals 0"No" 1"Yes".

