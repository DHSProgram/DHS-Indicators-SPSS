* Encoding: windows-1252.
*****************************************************************************************************
Program: 			HV_tables.sps
Purpose: 			produce tables for indicators
Author:				Ivana Bjelic
Date last modified: January 17 2020 by Ivana Bjelic

*Note this do file will produce the following tables in excel:
	1. 	Tables_coverage:	Contains the tables for HIV testing coverage for women, men, and total. THESE TABLES ARE UNWEIGHTED
*
Notes: 	Line 34 selects for the age group of interest for the coverage indicators
	The default is age 15-49. For all other tables (except couples) the default was set as 15-49 in the master file
	Not all surveys have testing that distinguish between HIV-1 and HIV-2. These tables are commented out in line 135 Uncomment if you need them. 
		
*****************************************************************************************************.
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************
*  When implementing a crosstabs command instead of ctables command please change:
    ctables to *ctables.
   *crosstabs to crosstabs
   *frequencies to frequencies.

* indicators from PR file.

* THE TABLES PRODUCED HERE ARE UNWEIGHTED.

* select age group.
select if (hv105>=15 and hv105<=49).
 
* compute age groups for women.
recode ha1 (15 thru 19=1) (20 thru 24=2) (25 thru 29=3) (30 thru 34=4) (35 thru 39=5) (40 thru 44=6) (45 thru 49=7) into age_wm.
variable labels age_wm "Age".
value labels age_wm 1  " 15-19" 2  " 20-24" 3 " 25-29" 4 " 30-34" 5 " 35-39" 6 " 40-44" 7 " 45-49".
 
* compute age groups for men.
recode hb1 (15 thru 19=1) (20 thru 24=2) (25 thru 29=3) (30 thru 34=4) (35 thru 39=5) (40 thru 44=6) (45 thru 49=7) into age_mn.
variable labels age_mn "Age".
value labels age_mn 1  " 15-19" 2  " 20-24" 3 " 25-29" 4 " 30-34" 5 " 35-39" 6 " 40-44" 7 " 45-49".
 
*education for women.
recode ha66 (8,9=9)(else=copy) into edu_wm.
apply dictionary from *
/source variables = HA66
/target variables = edu_wm.
 
*education for men.
recode hb66 (8,9=9)(else=copy) into edu_mn.
apply dictionary from *
/source variables = HA66
/target variables = edu_mn.
 
**************************************************************************************************
* Coverage of HIV testing 
**************************************************************************************************
*Testing status among women.
ctables
  /table  hv025 [c] +
            hv024 [c] +
            age_wm [c] +
            edu_wm [c] +
            hv270 [c] 
              by
         hv_hiv_test_wm [c] [rowpct.validn '' f5.1] + hv_hiv_test_wm [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Testing status among women".		

*crosstabs 
    /tables = hv025 hv024 age_wm edu_wm hv270 by hv_hiv_test_wm
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Testing status among men.
ctables
  /table  hv025 [c] +
            hv024 [c] +
            age_mn [c] +
            edu_mn [c] +
            hv270 [c] 
              by
         hv_hiv_test_mn [c] [rowpct.validn '' f5.1] + hv_hiv_test_mn [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Testing status among men".		

*crosstabs 
    /tables = hv025 hv024 age_mn edu_mn hv270 by hv_hiv_test_mn
    /format = avalue tables
    /cells = row 
    /count asis.

**************************************************************************************************
*Testing status total.
ctables
  /table  hv025 [c] +
            hv024 [c] 
              by
         hv_hiv_test_tot [c] [rowpct.validn '' f5.1] + hv_hiv_test_tot [s] [validn,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Testing status total".		

*crosstabs 
    /tables = hv025 hv024 by hv_hiv_test_tot
    /format = avalue tables
    /cells = row 
    /count asis.

* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_coverage.xls"
     operation=createfile.

output close * .

new file.