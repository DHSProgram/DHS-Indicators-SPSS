* Encoding: UTF-8.
*****************************************************************************************************
Program: 			FG_CIRCUM_MR.sps
Purpose: 			Code to 
Data inputs: 		MR dataset
Data outputs:		coded variables
Author:				Shireen Assaf and translated to SPSS by Ivana Bjelic
Date last modified: October 27, 2020 by Shireen Assaf 
*
Note:				Heard of female cirucumcision and opinions on female cirucumcision can be computed for men and women
*				In older surveys there may be altnative variable names related to female circumcision. 
*				Please check Chapter 18 in Guide to DHS Statistics and the section "Changes over Time" to find alternative names.
*				Link:    https:*www.dhsprogram.com/Data/Guide-to-DHS-Statistics/index.htm#t=Knowledge_of_Female_Circumcision.htm%23Percentage_of_women_and8bc-1&rhtocid=_21_0_0
					
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
*
fg_heard			"Heard of female circumcision"
*	
fg_relig			"Opinion on whether female circumcision is required by their religion" 
fg_cont			"Opinion on whether female circumcision should continue" 

*----------------------------------------------------------------------------.

*Heard of female circumcision.
compute fg_heard = (mg100=1 or mg101=1).
variable labels fg_heard "Heard of female circumcision".
value labels fg_heard 0"No" 1"Yes".

*Opinion on whether female circumcision is required by their religion.
if fg_heard =1 fg_relig = mg118.
if mg118 = 9 fg_relig = 8.
variable labels fg_relig "Opinion on whether female circumcision is required by their religion".
apply dictionary from *
 /source variables=mg118
 /target variables=fg_relig.

*Opinion on whether female circumcision should continue.
if fg_heard =1 fg_cont = mg119.
if mg119 = 9 fg_cont = 8.
variable labels fg_cont "Opinion on whether female circumcision should continue".
apply dictionary from *
 /source variables=mg119
 /target variables=fg_cont.
