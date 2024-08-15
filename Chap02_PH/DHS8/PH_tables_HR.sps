* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_tables_HR.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: August 26 2020 by Ivana Bjelic

*This do file will produce the following tables in excel:
	1. 	Tables_hh_wash:		Contains the table for WASH (water and santitation) indicators
	2. 	Tables_hh_charac:		Contains the table for household characteristics
	3. 	Tables_hh_poss:		Contains the table for household possessions

*Notes: 					 						
*****************************************************************************************************

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

compute wt=hv005/1000000.

weight by wt.

* create denominators.
compute num=1.
variable labels num "Number".

* indicators from HR file.


**************************************************************************************************
* Indicators for WASH indicators: excel file Tables_hh_WASH will be produced
**************************************************************************************************
* all WASH characteristics are crosstabulated by place of residence.

*type of water source.
ctables
  /table  ph_wtr_source [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "type of water source".		

*crosstabs 
    /tables = ph_wtr_source by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

*improved drinking water source.
ctables
  /table  ph_wtr_improve [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "improved drinking water source".		

*crosstabs 
    /tables = ph_wtr_improve by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

*round trip time to obtaining water.
ctables
  /table  ph_wtr_time [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "round trip time to obtaining water".		

*crosstabs 
    /tables = ph_wtr_time by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

*basic or limited water service.
ctables
  /table  ph_wtr_basic [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "basic or limited water service".		

*crosstabs 
    /tables = ph_wtr_basic by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

*availability of water among those using piped water.
ctables
  /table  ph_wtr_avail [c] [colpct.validn '' f5.1] +
            ph_wtr_avail [s] [validn ,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "availability of water among those using piped water".		

*crosstabs 
    /tables = ph_wtr_avail by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

*treatment of water: boil.
ctables
  /table  ph_wtr_trt_boil [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: boil.".		

*crosstabs 
    /tables = ph_wtr_trt_boil by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

	
*treatment of water: bleach or chlorine.
ctables
  /table  ph_wtr_trt_chlor [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: bleach or chlorine".		

*crosstabs 
    /tables = ph_wtr_trt_chlor by hv025
    /format = avalue tables
    /cells = column 
    /count asis.
	
*treatment of water: straining through cloth.
ctables
  /table  ph_wtr_trt_cloth [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: straining through cloth".		

*crosstabs 
    /tables = ph_wtr_trt_cloth by hv025
    /format = avalue tables
    /cells = column 
    /count asis.
	
*treatment of water: ceramic, sand or other filter.
ctables
  /table  ph_wtr_trt_filt [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: ceramic, sand or other filter".		

*crosstabs 
    /tables = ph_wtr_trt_filt by hv025
    /format = avalue tables
    /cells = column 
    /count asis.
	
*treatment of water: solar disinfection.
ctables
  /table  ph_wtr_trt_solar [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: solar disinfection".		

*crosstabs 
    /tables = ph_wtr_trt_solar by hv025
    /format = avalue tables
    /cells = column 
    /count asis.
	
*treatment of water: letting stand and settle.
ctables
  /table  ph_wtr_trt_stand [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: letting stand and settle".		

*crosstabs 
    /tables = ph_wtr_trt_stand by hv025
    /format = avalue tables
    /cells = column 
    /count asis.	

*treatment of water: other.
ctables
  /table  ph_wtr_trt_other [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: other".		

*crosstabs 
    /tables = ph_wtr_trt_other by hv025
    /format = avalue tables
    /cells = column 
    /count asis.
	
*treatment of water: no treatment.
ctables
  /table  ph_wtr_trt_none [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: no treatment".		

*crosstabs 
    /tables = ph_wtr_trt_none by hv025
    /format = avalue tables
    /cells = column 
    /count asis.	
	
*treatment of water: appropriate treatment.
ctables
  /table  ph_wtr_trt_appr [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "treatment of water: appropriate treatment".		

*crosstabs 
    /tables = ph_wtr_trt_appr by hv025
    /format = avalue tables
    /cells = column 
    /count asis.	
	
*type of sanitation.
ctables
  /table  ph_sani_type [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "type of sanitation".		

*crosstabs 
    /tables = ph_sani_type by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

*basic or limited sanitation.
ctables
  /table  ph_sani_basic [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "basic or limited sanitation".		

*crosstabs 
    /tables = ph_sani_basic by hv025
    /format = avalue tables
    /cells = column 
    /count asis.

*location of sanitation facility.
ctables
  /table  ph_sani_location [c] [colpct.validn '' f5.1] +
        ph_sani_location [s] [validn ,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "location of sanitation facility".		

*crosstabs 
    /tables = ph_sani_location by hv025
    /format = avalue tables
    /cells = column 
    /count asis.


* output to excel.
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_hh_wash.xls"
     operation=createfile.

output close * .

**************************************************************************************************
* Indicators for household characteristics: excel file Tables_hh_charac will be produced
**************************************************************************************************
* all household characteristics are crosstabulated by place of residence.
*electricity.
*floor marital.
*rooms for sleeping.
*place for cooking.
*cooking fuel.
*solid fuel for cooking.
*clean fuel for cooking.
*frequency of smoking in the home

ctables
  /table  ph_electric [c] [colpct.validn '' f5.1] +
        ph_floor [c] [colpct.validn '' f5.1] +
        ph_rooms_sleep [c] [colpct.validn '' f5.1] +
        ph_cook_place [c] [colpct.validn '' f5.1] +
        ph_cook_fuel [c] [colpct.validn '' f5.1] +
        ph_cook_solid [c] [colpct.validn '' f5.1] +
        ph_cook_clean [c] [colpct.validn '' f5.1] +
        ph_smoke [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025 [c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Household characteristics".		

*crosstabs 
    /tables = hv025 by ph_electric ph_floor ph_rooms_sleep ph_cook_place ph_cook_fuel ph_cook_solid ph_cook_clean ph_smoke
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_hh_charac.xls"
     operation=createfile.

output close * .


**************************************************************************************************
* Indicators for household possessions: excel file Tables_hh_poss will be produced
**************************************************************************************************
* all household possessions are crosstabulated by place of residence.
*radio.
*TV.
*mobile.
*telephone.
*computer.
*refrigerator.
*bicycle.
*animal drawn cart.
*motorcycle/scooter.
*car or truck.
*boat with a motor.
*agricultural land.
*livestock or farm animals.

ctables
  /table ph_radio [c] [colpct.validn '' f5.1] +
        ph_tv [c] [colpct.validn '' f5.1] +
        ph_mobile [c] [colpct.validn '' f5.1] +
        ph_tel [c] [colpct.validn '' f5.1] +
        ph_comp [c] [colpct.validn '' f5.1] +
        ph_frig [c] [colpct.validn '' f5.1] +
        ph_bike [c] [colpct.validn '' f5.1] +
        ph_cart [c] [colpct.validn '' f5.1] +
        ph_moto [c] [colpct.validn '' f5.1] +
        ph_car [c] [colpct.validn '' f5.1] +
        ph_boat [c] [colpct.validn '' f5.1] +
        ph_agriland [c] [colpct.validn '' f5.1] +
        ph_animals [c] [colpct.validn '' f5.1] +
        num [s] [sum,'', f5.0] by hv025[c]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Household possessions".		

*crosstabs 
    /tables = hv025 by ph_radio ph_tv ph_mobile ph_tel ph_comp ph_frig ph_bike ph_cart ph_moto ph_car ph_boat ph_agriland ph_animals 
    /format = avalue tables
    /cells = row 
    /count asis.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_hh_poss.xls"
     operation=createfile.

output close * .

****************************************************************************.
****************************************************************************.
new file.

