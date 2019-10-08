* Encoding: windows-1252.
*****************************************************************************************************
Program: 			ML_NETS_use.sps
Purpose: 			POPULATION/CHILD/PREGNANT WOMEN USE OF NETS
Data inputs: 		PR survey list
Data outputs:		coded variables
Author:				Cameron Taylor and translated to SPSS by Ivana Bjelic
Date last modified: August 31 2019 by Ivana Bjelic
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
ml_slept_net                    "Slept under any mosquito net last night"
ml_slept_itn	                    "Slept under an ITN last night"
----------------------------------------------------------------------------*

*Categorizing nets.
if hml12=0 ml_netcat=0 .
if hml12=1|hml12=2 ml_netcat=1. 
if hml12=3 ml_netcat=2.
variable labels  ml_netcat "Mosquito net categorization".

*Slept under any mosquito net last night.
compute ml_slept_net=(ml_netcat=1|ml_netcat=2).
variable labels  ml_slept_net "Slept under any mosquito net last night".
value labels ml_slept_net 0 "No" 1 "Yes".
	
*Slept under an ITN last night.
compute ml_slept_itn=(ml_netcat=1).
variable labels  ml_slept_itn  "Slept under an ITN last night".
value labels ml_slept_itn 0 "No" 1 "Yes".


