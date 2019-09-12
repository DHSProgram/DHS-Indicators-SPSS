* Encoding: windows-1252.
*****************************************************************************************************
Program: 			CH_SIZE.sps
Purpose: 			Code child size variables
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: September 01 2019 by Ivana Bjelic 
*****************************************************************************************************

*----------------------------------------------------------------------------
Variables created in this file:
ch_size_birth	"Size of child at birth as reported by mother"
ch_report_bw	"Has a reported birth weight"
ch_below_2p5	"Birth weight less than 2.5 kg"
----------------------------------------------------------------------------.

*Child's size at birth.
recode m18 (5=1) (4=2) (1,2,3=3) (8,9=9) into ch_size_birth.
variable labels ch_size_birth "Child's size at birth".
value labels ch_size_birth 1  "Very small" 2 "Smaller than average" 3  "Average or larger" 9  "Don't know/missing".

*Child's reported birth weight.
recode m19 (0 thru 9000=1) (else=0) into ch_report_bw.
variable labels ch_report_bw "Child's reported birth weight".
value labels ch_report_bw 0 "No" 1 "Yes".

*Child before 2.5kg.
do if ch_report_bw=1.
+recode m19 (0 thru 2499=1) (else=0) into ch_below_2p5.
end if.
variable labels ch_below_2p5 "Child before 2.5kg".
value labels ch_below_2p5 0 "No" 1 "Yes".
