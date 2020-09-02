* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_HNDWSH.sps
Purpose: 			Code to compute handwashing indicators
Data inputs: 		PR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: June 16, 2020 by Ivana Bjelic
Note:				The HR file can also be used to code these indicators among households. The condition hv102 would need to be removed. 
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
ph_hndwsh_place_fxd			"Fixed place for handwashing"
ph_hndwsh_place_mob			"Mobile place for handwashing"
ph_hndwsh_place_any			"Either fixed or mobile place for handwashing"
ph_hndwsh_water			"Place observed for handwashing with water"
ph_hndwsh_soap			"Place observed for handwashing with soap"
ph_hndwsh_clnsagnt			"Place observed for handwashing with cleansing agent other than soap"
ph_hndwsh_basic			"Basic handwashing facility"
ph_hndwsh_limited			"Limited handwashing facility"

*----------------------------------------------------------------------------.

* Fixed place for handwashing.
do if hv102=1.
+compute ph_hndwsh_place_fxd=0.
+if  hv230a=1 ph_hndwsh_place_fxd=1.
end if.
variable labels ph_hndwsh_place_fxd "Fixed place for handwashing".
value labels ph_hndwsh_place_fxd 0"No" 1"Yes".

* Mobile place for handwashing.
do if hv102=1.
+compute ph_hndwsh_place_mob=0.
+if  hv230a=2 ph_hndwsh_place_mob=1.
end if.
variable labels ph_hndwsh_place_mob "Mobile place for handwashing".
value labels ph_hndwsh_place_mob 0"No" 1"Yes".

* Fixed or mobile place for handwashing.
do if hv102=1.
+compute ph_hndwsh_place_any=0.
+if any(hv230a,1,2) ph_hndwsh_place_any=1.
end if.
variable labels ph_hndwsh_place_any "Either fixed or mobile place for handwashing".
value labels ph_hndwsh_place_any 0"No" 1"Yes".

* Place observed for handwashing with water.
do if hv102=1.
+if any(hv230a,1,2)  ph_hndwsh_water= 0.
+if hv230b=1 ph_hndwsh_water= 1.
end if.
variable labels ph_hndwsh_water "Place observed for handwashing with water".
value labels ph_hndwsh_water 0"No" 1"Yes".

* Place observed for handwashing with soap.
do if hv102=1.
+if any(hv230a,1,2) ph_hndwsh_soap=0.
+if hv232=1 ph_hndwsh_soap=1.
end if.
variable labels ph_hndwsh_soap "Place observed for handwashing with soap".
value labels ph_hndwsh_soap 0"No" 1"Yes".

* Place observed for handwashing with cleansing agent other than soap.
do if hv102=1.
if any(hv230a,1,2) ph_hndwsh_clnsagnt= 0.
if hv232b=1 ph_hndwsh_clnsagnt=1.
end if.
variable labels ph_hndwsh_clnsagnt "Place observed for handwashing with cleansing agent other than soap".
value labels ph_hndwsh_clnsagnt 0"No" 1"Yes".

* Basic handwashing facility.
do if hv102=1.
if any(hv230a,1,2,3) ph_hndwsh_basic= 0.
if hv230b=1 & hv232=1 ph_hndwsh_basic = 1.
end if.
variable labels ph_hndwsh_clnsagnt "Basic handwashing facility".
value labels ph_hndwsh_clnsagnt 0"No" 1"Yes".

* Limited handwashing facility.
do if hv102=1.
+if any(hv230a,1,2,3) ph_hndwsh_limited=0.
+if hv230b=0 or hv232=0 ph_hndwsh_limited = 1.
end if.
variable labels ph_hndwsh_limited	"Limited handwashing facility".
value labels ph_hndwsh_limited 0"No" 1"Yes".
