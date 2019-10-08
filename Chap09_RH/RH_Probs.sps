* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			RH_probs.sps
Purpose: 			Code indicators on problems accessing health care for women
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: June 30, 2019 by Ivana Bjelic
*****************************************************************************************************/

 *-------------------------------------------------------------------------------------------------------------------------//
Variables created in this file:
rh_prob_permit		"Problem health care access: permission to go"
rh_prob_money		"Problem health care access: getting money"
rh_prob_dist	                    	"Problem health care access: distance to facility"
rh_prob_alone		"Problem health care access: not wanting to go alone"
rh_prob_minone		"At least one problem in accessing health care"
/----------------------------------------------------------------------------------------------------------------------------*/

*Permission to go.
recode v467b (0,2,9 = 0 ) (1 = 1) into rh_prob_permit.
variable labels rh_prob_permit "Problem health care access: permission to go".
value labels rh_prob_permit 0 "no prob" 1 "prob".

*Getting money.
recode v467c (0, 2, 9 = 0) (1 = 1) into rh_prob_money.
variable labels  rh_prob_money "Problem health care access: getting money".
value labels rh_prob_money 0 "no prob" 1 "prob".
	
*Distance to facility.
recode v467d (0, 2, 9 = 0) (1 = 1) into rh_prob_dist.
variable labels  rh_prob_dist "Problem health care access: distance to facility".
value labels   rh_prob_dist  0 "no prob" 1 "prob".
	
*Not wanting to go alone.
recode v467f (0, 2, 9 = 0) (1 = 1) into rh_prob_alone.
variable labels  rh_prob_alone "Problem health care access: not wanting to go alone".
value labels  rh_prob_alone  0 "no prob" 1 "prob".
	
*At least one problem.
compute rh_prob_minone = rh_prob_permit+rh_prob_money+rh_prob_dist+rh_prob_alone.
if rh_prob_minone>1 rh_prob_minone = 1.
variable labels rh_prob_minone "At least one problem in accessing health care".
value labels rh_prob_minone  0 "no prob" 1 "at least one prob".
	
 
 
 