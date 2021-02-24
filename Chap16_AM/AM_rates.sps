* Encoding: UTF-8.
*****************************************************************************************************
Program: 			AM_RATES.sps
Purpose: 			Code to produce adult and maternal mortality rates for specific windows of time
Data inputs: 		IR survey list
Data outputs:		AM_Tables.xlsx and AM_completeness.xlsx
Author:				Trevor Croft and modified by Ivana Bjelic for the code share project
Date last modified: February 16, 2021 by Ivana Bjelic
Note:				See below 
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
mx			"mortality rate"
q_15_to_50	(aka 15q35)	                  "probability of dying between ages 15 and 50"
mmx                                               "maternal mortality rate"
PMDF		                  "proportions maternal among deaths of females of reproductive age"
MMRatio 	                                    "maternal mortality ratio
PRMRatio                         	"pregnancy related mortality ratio"
mLTR	                                    "lifetime risk of maternal death"
prLTR                                              "lifetime risk of pregnancy-related death"
----------------------------------------------------------------------------.

*----------------------------------------------------------------------------
*
MATERNAL MORTALITY RATIO
	The MMRatio is the MMRate divided by the GFR, where the GFR is from the same time period as the 
	MMRate but is age-standardized according to the age distribution of the women in the IR file 
	Note that this GFR is defined as the number of births to women 15-49, divided by the number of 
	(or exposure by) women age 15-49; it is not the DHS GFR.
*
OUTPUTS
	After this program has been run and the files have been saved you will find
	two excel workbooks. One labeled AM_tables.xlsx will have all mortality rates
	The other is labeled AM_completeness.xlsx and will have all completeness of sibling
	information.
*
NOTES
*	
	The program agrees exactly with DHS procedures.
*
	It is a complete re-write, not a translation, of the CSPro program. It includes 
	many comments and explanations and is intended for users who are already familiar
	with demographic rates and with SPSS. It is expected that users will make modifications.
*
	The program does not include an option for covariates. DHS does not recommend 
	the calculation of maternal mortality rates or ratios within subpopulations and 
	will not facilitate this, but of course users can modify the program if they wish
	The only covariates in the data files are characteristics of the respondent, not
	of her siblings.
*
	There is no difference between never-married and ever-married surveys in the calculation
	of the asdrs. It only uses the sibling data in the IR file, from the survey of women.  
*
	The rates are given to many decimal places and do not include factors of 1000
	or 100,000. YOU MUST APPLY THOSE FACTORS YOURSELF.
*	
	As is standard DHS practice, exposure or events in the month of interview are ignored.
*
	Calculate exposure to successive age intervals within the interval of observation
	The age intervals are numbered 1 for 15-19 through 7 for 45-49.
*
	The first cmc when the sibling is in age interval i is mm4+(i+2)*60 and the last cmc when the sibling is in age interval i
	 is the first cmc plus 59. The months of exposure to age interval i within the window is mexp_i.
*
	first_1 is the cmc when the sibling reached age interval 1 (age 15-19), and last_1 is the last cmc when the sibling was in age
	interval 1 (age 15-19), etc., up to interval 7 (age 45-49)
*
	The filenames include the two-character country code, characters 5 and 6 from the 
	IR filename, and the starting and ending dates of the window of time. 
*  
                When implementing a crosstabs command instead of ctables command please change:
                 ctables to *ctables.
                *crosstabs to crosstabs
                *frequencies to frequencies.

*
VARIABLES
	mm1  "Sex"
	mm2  "Survival status"
	mm3  "Current age"
	mm4  "Date of birth (cmc)"
	mm6  "Years since death"
	mm7  "Age at death"
	mm8  "Date of death (cmc)"
	mm9  "Death and pregnancy"
	mm12 "Length of time between sibling's delivery and death"
	mm14 "Number of sibling's children"
	mm16 "Sibling's death due to violence or accident" (In surveys from 2016 onwards)
*
	pregnancy-related death: mm9 is 2, 3, 5, or 6, and mm16 is not used
	maternal death:          mm9 is 2, 3, or 5,    and mm16=0 
*
	mm2 codes:
			   0 dead
			   1 alive
			   8 don't know
	mm9 codes:
			   0 never pregnant
			   1 death not related
			   2 died while pregnant
			   3 died during delivery
			   4 since delivery         NOT USED
			   5 6 weeks after delivery
			   6 2 months after delivery ADDITIONAL BETWEEN 6 WEEKS AND 2 MONTHS
			  98 don't know
*
	mm12 codes:
			 100 same day
			 101 days: 1
			 199 days: number missing
			 201 months: 1
			 299 months: number missing
			 301 years: 1
			 399 years: number missing
			 997 inconsistent
			 998 don't know
*
	mm16 codes
			   0 no
			   1 violence
			   2 accident
*
	mm12 is not needed
*
	mm4 and mm8 are always coded but may include some impossible values; apparently not always edited
*
	mm3 is equivalent to int((v008-mm4)/12)  age in years if alive
	mm6 is equivalent to int((v008-mm8)/12)  age in years at death if dead
	mm7 is equivalent to int((mm8-mm4)/12)   years since death if dead
*
	Only keep the variables that are needed: mm 1, 2, 4, 8, 9, 16
*
	If mm16 is present and if it equals 1 or 2, then change mm9 from 2 to 1
*
	The program produces several tables that appear in the output file.  You can insert lines for export excel, 
                    or can copy from the output file, whatevere is most convenient for you.  All the the main rates,
	  age-specific and overall, age-adjusted, are exported as SPSS .sav file and as Excel files, for you to manipulate.

******************************************************************************.

dataset activate women.
use all.

* Define the period to use, the upper limit (months preceding the interview), and the lower limit.
define periodlen ().
* Specify the interval or window for the rates with two scalars.
* When counting backwards, the month of interview is month 0 and is never included.
* The normal specification is for years 0-6 before the survey, i.e. 7 years.
* For this, set scalar lw=-6 and uw=0. "l" for lower, "u" for upper, "w" for window.
* The conversion to sibling-specific start_month and end_month is done in start_month_end_month.
compute lw=-6.
compute uw=0.
compute period = uw-lw+1.
compute kmax = 1.
compute kmin = 12*period.
compute totexp = kmin-kmax+1.
!enddefine.

* Go to the IR file and reshape the mm variables.

* Need to check for mm16; if an older survey, must give it a value.
begin program.
import spss, spssaux
varList = "mm16$01 mm16$02 mm16$03 mm16$04 mm16$05 mm16$06 mm16$07 mm16$08 mm16$09 mm16$10 mm16$11 mm16$12 mm16$13 mm16$14 mm16$15 mm16$16 mm16$17 mm16$18 mm16$19 mm16$20"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.
execute.

save outfile = "tmpIR.sav"/keep 
  caseid v001 v002 v003 v005 v006 v008 v011 v013 mmc1 mmc2
  mmidx$01 mmidx$02 mmidx$03 mmidx$04 mmidx$05 mmidx$06 mmidx$07 mmidx$08 mmidx$09 mmidx$10 mmidx$11 mmidx$12 mmidx$13 mmidx$14 mmidx$15 mmidx$16 mmidx$17 mmidx$18 mmidx$19 mmidx$20
  mm1$01 mm1$02 mm1$03 mm1$04 mm1$05 mm1$06 mm1$07 mm1$08 mm1$09 mm1$10 mm1$11 mm1$12 mm1$13 mm1$14 mm1$15 mm1$16 mm1$17 mm1$18 mm1$19 mm1$20
  mm2$01 mm2$02 mm2$03 mm2$04 mm2$05 mm2$06 mm2$07 mm2$08 mm2$09 mm2$10 mm2$11 mm2$12 mm2$13 mm2$14 mm2$15 mm2$16 mm2$17 mm2$18 mm2$19 mm2$20
  mm3$01 mm3$02 mm3$03 mm3$04 mm3$05 mm3$06 mm3$07 mm3$08 mm3$09 mm3$10 mm3$11 mm3$12 mm3$13 mm3$14 mm3$15 mm3$16 mm3$17 mm3$18 mm3$19 mm3$20
  mm4$01 mm4$02 mm4$03 mm4$04 mm4$05 mm4$06 mm4$07 mm4$08 mm4$09 mm4$10 mm4$11 mm4$12 mm4$13 mm4$14 mm4$15 mm4$16 mm4$17 mm4$18 mm4$19 mm4$20
  mm5$01 mm5$02 mm5$03 mm5$04 mm5$05 mm5$06 mm5$07 mm5$08 mm5$09 mm5$10 mm5$11 mm5$12 mm5$13 mm5$14 mm5$15 mm5$16 mm5$17 mm5$18 mm5$19 mm5$20
  mm6$01 mm6$02 mm6$03 mm6$04 mm6$05 mm6$06 mm6$07 mm6$08 mm6$09 mm6$10 mm6$11 mm6$12 mm6$13 mm6$14 mm6$15 mm6$16 mm6$17 mm6$18 mm6$19 mm6$20
  mm7$01 mm7$02 mm7$03 mm7$04 mm7$05 mm7$06 mm7$07 mm7$08 mm7$09 mm7$10 mm7$11 mm7$12 mm7$13 mm7$14 mm7$15 mm7$16 mm7$17 mm7$18 mm7$19 mm7$20
  mm8$01 mm8$02 mm8$03 mm8$04 mm8$05 mm8$06 mm8$07 mm8$08 mm8$09 mm8$10 mm8$11 mm8$12 mm8$13 mm8$14 mm8$15 mm8$16 mm8$17 mm8$18 mm8$19 mm8$20
  mm9$01 mm9$02 mm9$03 mm9$04 mm9$05 mm9$06 mm9$07 mm9$08 mm9$09 mm9$10 mm9$11 mm9$12 mm9$13 mm9$14 mm9$15 mm9$16 mm9$17 mm9$18 mm9$19 mm9$20
  mm10$01 mm10$02 mm10$03 mm10$04 mm10$05 mm10$06 mm10$07 mm10$08 mm10$09 mm10$10 mm10$11 mm10$12 mm10$13 mm10$14 mm10$15 mm10$16 mm10$17 mm10$18 mm10$19 mm10$20
  mm11$01 mm11$02 mm11$03 mm11$04 mm11$05 mm11$06 mm11$07 mm11$08 mm11$09 mm11$10 mm11$11 mm11$12 mm11$13 mm11$14 mm11$15 mm11$16 mm11$17 mm11$18 mm11$19 mm11$20
  mm12$01 mm12$02 mm12$03 mm12$04 mm12$05 mm12$06 mm12$07 mm12$08 mm12$09 mm12$10 mm12$11 mm12$12 mm12$13 mm12$14 mm12$15 mm12$16 mm12$17 mm12$18 mm12$19 mm12$20
  mm13$01 mm13$02 mm13$03 mm13$04 mm13$05 mm13$06 mm13$07 mm13$08 mm13$09 mm13$10 mm13$11 mm13$12 mm13$13 mm13$14 mm13$15 mm13$16 mm13$17 mm13$18 mm13$19 mm13$20
  mm14$01 mm14$02 mm14$03 mm14$04 mm14$05 mm14$06 mm14$07 mm14$08 mm14$09 mm14$10 mm14$11 mm14$12 mm14$13 mm14$14 mm14$15 mm14$16 mm14$17 mm14$18 mm14$19 mm14$20
  mm15$01 mm15$02 mm15$03 mm15$04 mm15$05 mm15$06 mm15$07 mm15$08 mm15$09 mm15$10 mm15$11 mm15$12 mm15$13 mm15$14 mm15$15 mm15$16 mm15$17 mm15$18 mm15$19 mm15$20
  mm16$01 mm16$02 mm16$03 mm16$04 mm16$05 mm16$06 mm16$07 mm16$08 mm16$09 mm16$10 mm16$11 mm16$12 mm16$13 mm16$14 mm16$15 mm16$16 mm16$17 mm16$18 mm16$19 mm16$20.

get file = "tmpIR.sav".

varstocases
  /make mmidx from mmidx$01 mmidx$02 mmidx$03 mmidx$04 mmidx$05 mmidx$06 mmidx$07 mmidx$08 mmidx$09 mmidx$10 mmidx$11 mmidx$12 mmidx$13 mmidx$14 mmidx$15 mmidx$16 mmidx$17 mmidx$18 mmidx$19 mmidx$20
  /make mm1 from mm1$01 mm1$02 mm1$03 mm1$04 mm1$05 mm1$06 mm1$07 mm1$08 mm1$09 mm1$10 mm1$11 mm1$12 mm1$13 mm1$14 mm1$15 mm1$16 mm1$17 mm1$18 mm1$19 mm1$20
  /make mm2 from mm2$01 mm2$02 mm2$03 mm2$04 mm2$05 mm2$06 mm2$07 mm2$08 mm2$09 mm2$10 mm2$11 mm2$12 mm2$13 mm2$14 mm2$15 mm2$16 mm2$17 mm2$18 mm2$19 mm2$20
  /make mm3 from mm3$01 mm3$02 mm3$03 mm3$04 mm3$05 mm3$06 mm3$07 mm3$08 mm3$09 mm3$10 mm3$11 mm3$12 mm3$13 mm3$14 mm3$15 mm3$16 mm3$17 mm3$18 mm3$19 mm3$20
  /make mm4 from mm4$01 mm4$02 mm4$03 mm4$04 mm4$05 mm4$06 mm4$07 mm4$08 mm4$09 mm4$10 mm4$11 mm4$12 mm4$13 mm4$14 mm4$15 mm4$16 mm4$17 mm4$18 mm4$19 mm4$20
  /make mm5 from mm5$01 mm5$02 mm5$03 mm5$04 mm5$05 mm5$06 mm5$07 mm5$08 mm5$09 mm5$10 mm5$11 mm5$12 mm5$13 mm5$14 mm5$15 mm5$16 mm5$17 mm5$18 mm5$19 mm5$20
  /make mm6 from mm6$01 mm6$02 mm6$03 mm6$04 mm6$05 mm6$06 mm6$07 mm6$08 mm6$09 mm6$10 mm6$11 mm6$12 mm6$13 mm6$14 mm6$15 mm6$16 mm6$17 mm6$18 mm6$19 mm6$20
  /make mm7 from mm7$01 mm7$02 mm7$03 mm7$04 mm7$05 mm7$06 mm7$07 mm7$08 mm7$09 mm7$10 mm7$11 mm7$12 mm7$13 mm7$14 mm7$15 mm7$16 mm7$17 mm7$18 mm7$19 mm7$20
  /make mm8 from mm8$01 mm8$02 mm8$03 mm8$04 mm8$05 mm8$06 mm8$07 mm8$08 mm8$09 mm8$10 mm8$11 mm8$12 mm8$13 mm8$14 mm8$15 mm8$16 mm8$17 mm8$18 mm8$19 mm8$20
  /make mm9 from mm9$01 mm9$02 mm9$03 mm9$04 mm9$05 mm9$06 mm9$07 mm9$08 mm9$09 mm9$10 mm9$11 mm9$12 mm9$13 mm9$14 mm9$15 mm9$16 mm9$17 mm9$18 mm9$19 mm9$20
  /make mm10 from mm10$01 mm10$02 mm10$03 mm10$04 mm10$05 mm10$06 mm10$07 mm10$08 mm10$09 mm10$10 mm10$11 mm10$12 mm10$13 mm10$14 mm10$15 mm10$16 mm10$17 mm10$18 mm10$19 mm10$20
  /make mm11 from mm11$01 mm11$02 mm11$03 mm11$04 mm11$05 mm11$06 mm11$07 mm11$08 mm11$09 mm11$10 mm11$11 mm11$12 mm11$13 mm11$14 mm11$15 mm11$16 mm11$17 mm11$18 mm11$19 mm11$20
  /make mm12 from mm12$01 mm12$02 mm12$03 mm12$04 mm12$05 mm12$06 mm12$07 mm12$08 mm12$09 mm12$10 mm12$11 mm12$12 mm12$13 mm12$14 mm12$15 mm12$16 mm12$17 mm12$18 mm12$19 mm12$20
  /make mm13 from mm13$01 mm13$02 mm13$03 mm13$04 mm13$05 mm13$06 mm13$07 mm13$08 mm13$09 mm13$10 mm13$11 mm13$12 mm13$13 mm13$14 mm13$15 mm13$16 mm13$17 mm13$18 mm13$19 mm13$20
  /make mm14 from mm14$01 mm14$02 mm14$03 mm14$04 mm14$05 mm14$06 mm14$07 mm14$08 mm14$09 mm14$10 mm14$11 mm14$12 mm14$13 mm14$14 mm14$15 mm14$16 mm14$17 mm14$18 mm14$19 mm14$20
  /make mm15 from mm15$01 mm15$02 mm15$03 mm15$04 mm15$05 mm15$06 mm15$07 mm15$08 mm15$09 mm15$10 mm15$11 mm15$12 mm15$13 mm15$14 mm15$15 mm15$16 mm15$17 mm15$18 mm15$19 mm15$20
  /make mm16 from mm16$01 mm16$02 mm16$03 mm16$04 mm16$05 mm16$06 mm16$07 mm16$08 mm16$09 mm16$10 mm16$11 mm16$12 mm16$13 mm16$14 mm16$15 mm16$16 mm16$17 mm16$18 mm16$19 mm16$20
  /keep=caseid v001 v002 v003 v005 v006 v008 v011 v013 mmc1 mmc2
  /null=drop.

*--------------------------------------------------------------------------
NOTE: 
Important for redefinition of Pregnancy Related Mortality Ratio (PRMR)
in surveys from 2016 onwards
*	
If mm9=2, and mm16=1 or 2, recode mm9 to 1
replace mm9=1 if mm9=2 & (mm16=1 | mm16=2)
*
For earlier surveys that do not include mm16, it is only possible to 
calculate PRMR; what was previously called maternal mortality (MM) is now called 
pregancy related mortality (PRM)
*	
See https://blog.dhsprogram.com/mmr-prmr/ for more information on these indicators.
*--------------------------------------------------------------------------.

* specify the lower and upper cmcs of the interval of observation, start_month and end_month.
	
*--------------------------------------------------------------------------
NOTE:
This uses scalars lw and uw that were set earlier; usually lw=-6 and uw=0, 
but not always!
--------------------------------------------------------------------------.

* Calculate the end date and start date for the desired window of time.

*--------------------------------------------------------------------------
NOTE:
There are two ways to specify the window of time using lw (lower end of window)
and uw (upper end of window).
*
Method 1: as calendar year intervals, e.g. with
		- scalar lw=1992
		- scalar uw=1996
		for a window from January 1992 through December 1996, inclusive.
*
Method 2: as an interval before the date of interview, e.g. with
		- scalar lw=-2
		- scalar uw=0  
		for a window from 0 to 2 years before the interview, inclusive
		(that is, three years)
*
The program knows you are using method 2 if the two numbers
you enter are negative or zero.
*
start_month is the cmc for the earliest month in the window and
end_month is the cmc for the latest month in the window
*	
coding that WILL NOT include the month of interview in the most recent interval 
in order to match with DHS results

*--------------------------------------------------------------------------.

* Date of interview.
compute doi=v008.

* Set up the period length and related variables.
periodlen.

compute iweight=v005/1000000.

* Section for "years before survey". lw and uw will be <=0 (see Method 2 above).
do if lw<=0.
+ compute start_month=doi+12*lw-12.
+ compute end_month=doi+12*uw-1.
end if.

* Section for calendar years. lw and uw will be >0 (see Method 1 above).
do if lw>0.
+ compute start_month=12*(lw-1900)+1.
+ compute end_month=12*(uw-1900)+12.
end if.

compute end_month=min(end_month,doi).

* calculate the reference date.
weight by iweight.

aggregate /outfile=* mode =addvariables
 /break 
 /mean_start_month=mean(start_month)
 /mean_end_month=mean(end_month)
 /mean_doi=mean(doi).

* Convert back to continuous time, which requires an adjustment of half a month (i.e. -1/24).
* (This adjustment is not often made but should be.).

compute refdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12.
compute mean_doi=1900-(1/24)+mean_doi/12.

* Tabulate the timing--during pregnancy, at childbirth, afterwards.

* tabulate mm9 for all maternal deaths, unweighted.
frequencies variables mm9.

* tabulate mm9 for all maternal deaths, weighted.
weight by iweight.
frequencies variables mm9.

* tabulate mm9 for all maternal deaths in the window, unweighted.
compute filter=(mm8>=start_month & mm8<=end_month).
filter by filter.
weight off.
frequencies variables mm9.

* tabulate mm9 for all maternal deaths in the window, weighted.
weight by iweight.
frequencies variables mm9.
filter off.
save outfile = "adult_mm_vars.sav".
dataset close women.
new file.

erase file = "tmpIR.sav".
	
*--------------------------------------------------------------------------
NOTE:
*	
adult_mm_vars.sav is an individual-level file for with one record for each 
sibling in the IR file. If there was also a sibling module in the men's survey,
a parallel routine must be added.
*--------------------------------------------------------------------------.

* Re-open the IR data file.
get file =  datapath + "\"+ irdata + ".sav".
dataset name women.

* Select complete interviews.
select if (V015 = 1).

* weight the data with the women's file weight.
compute wmweight = V005/1000000.
weight by wmweight.

* Compute a variable used for totals in the tables.
compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Produce mean number of siblings (including respondent) and sex ratio of siblings (excluding respondent).
* First calculate an entry for the total.
compute xage=9.
dataset declare sibs1.
aggregate
  /outfile='sibs1'
  /break=xage
  /MMC1=mean(MMC1).
* Now do the same by age group.
dataset declare sibs.
compute xage = V013.
aggregate
  /outfile='sibs'
  /break=xage
  /MMC1=mean(MMC1).
* Activate this file of siblings and combine into one file.
dataset activate sibs.
add files
  /file=*
  /file='sibs1'.

* end of fertility and sibship analysis prior to MMR.

* ---------------------------------------------------------------------------------------------------- .

* Calculate the table on completeness of information. 

*--------------------------------------------------------------------------.
 * NOTE: 
 * This routine calculates the table on completeness of information. 
 * It does not depend on the window of time that is used for the rates.

 * The data quality tables may be UNWEIGHTED, as in Cambodia 2014, or WEIGHTED, 
  as in Tanzania 2010; here they will be produced both unweighted and weighted.
*--------------------------------------------------------------------------.

* open file.
get file = "adult_mm_vars.sav".

compute iweight = V005/1000000.

* select only those with sex given.
select if (MM1 = 1 or MM1 = 2).

* Tabulate survival status by sex for all deaths, weighted.
weight by iweight.
ctables
  /table MM2 [c] by MM1 [c] [count, "No.", colpct.validn, "Col %"]
  /categories variables=all total=yes position=after
  /titles title="Survival status by sex for all deaths, weighted".

 * crosstabs MM2 by MM1
    /format = avalue tables
    /cells = count column
    /count asis.	

* Tabulate survival status by sex for all deaths, unweighted.
weight off.
ctables
  /table MM2 [c] by MM1 [c] [count, "No.", colpct.validn, "Col %"]
  /categories variables=all total=yes position=after
  /titles title="Survival status by sex for all deaths, unweighted".

 * crosstabs MM2 by MM1
    /format = avalue tables
    /cells = count column
    /count asis.

* There should not be any cases with survival status=9 or NA, but if there are, 
* change to dk.
if mm2>8 or missing (mm2) mm2=8.

*--------------------------------------------------------------------------
 * NOTE: 
 * If the sibling is alive: label for mm3 indicates that age is missing if mm3 is 98.
 * However, it appears that "." is used.  Allow for 99 too.
*--------------------------------------------------------------------------.

* Similarly for mm6 and mm7.
compute age_AD_YSD_missing=$sysmis.
if mm2=1 age_AD_YSD_missing=0.
if mm2=1 & (mm3=98 | mm3=99 | sysmis(mm3) | missing(mm3) ) age_AD_YSD_missing=1.
crosstabs age_AD_YSD_missing by MM1
    /format = avalue tables
    /cells = column
    /count asis.

* If the sibling has died, YSD is years since death (mm6) and AD is age at death (mm7).
compute YSD_missing=0.
compute AD_missing=0.
if mm2=0 & (mm6=98 | mm6=99 | sysmis(mm6) | missing(mm6)) YSD_missing=1.
if mm2=0 & (mm7=98 | mm7=99 | sysmis(mm7) | missing(mm7))  AD_missing=1.

if mm2=0 age_AD_YSD_missing=2.
if mm2=0 & AD_missing=1 & YSD_missing=0  age_AD_YSD_missing=3.
if mm2=0 & AD_missing=0 & YSD_missing=1  age_AD_YSD_missing=4.
if mm2=0 & AD_missing=1 & YSD_missing=1   age_AD_YSD_missing=5.

value labels age_AD_YSD_missing 
  0 "Living, age reported"  
  1 "Living, age missing" 
  2 "Dead, AD and YSD reported" 
  3 "Dead, missing only AD" 
  4 "Dead, missing only YSD" 
  5 "Dead, missing AD and YSD".

* save.
save outfile = "completeness.sav".

* Create tabulations for completeness.
output close *.

* survival status by sex for all deaths, unweighted and weighted, percentaged.
* incompleteness of date by sex for surviving siblings.
* incompleteness of date by sex for dead siblings.
if mm2=1 age_AD_YSD_missing_L=age_AD_YSD_missing.
if mm2=0 age_AD_YSD_missing_D=age_AD_YSD_missing.
variable labels age_AD_YSD_missing_L "Living siblings".
variable labels age_AD_YSD_missing_D "Dead siblings".
apply dictionary from * 
   /source variables =age_AD_YSD_missing
   /target variables= age_AD_YSD_missing_L age_AD_YSD_missing_D 
   /varinfo vallabels=replace.

ctables
  /table MM2 [c] + age_AD_YSD_missing_L [c] +age_AD_YSD_missing_D[c] by MM1 [c] [count, "No.", colpct.validn, "Col %"]
  /categories variables=MM1 MM2 age_AD_YSD_missing_L age_AD_YSD_missing_D  total=yes position=after
  /categories variables=all empty=exclude
  /titles title="Completeness of information on siblings, unweighted".

*crosstabs MM2 age_AD_YSD_missing_L  age_AD_YSD_missing_D by MM1
    /format = avalue tables
    /cells = column count
    /count asis.

* weighted tables.
weight by iweight.
ctables
  /table MM2 [c] + age_AD_YSD_missing_L [c] +age_AD_YSD_missing_D[c] by MM1 [c] [count, "No.", colpct.validn, "Col %"]
  /categories variables=MM1 MM2 age_AD_YSD_missing_L age_AD_YSD_missing_D  total=yes position=after
  /categories variables=all empty=exclude
  /titles title="Completeness of information on siblings, weighted".

*crosstabs MM2 age_AD_YSD_missing_L  age_AD_YSD_missing_D by MM1
    /format = avalue tables
    /cells = column count
    /count asis.
	
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls documentfile="AM_completeness.xls"
     operation=createfile.

output close * .
	
**********************************************
* end of completness of information tables.

dataset close sibs.
dataset close sibs1.

* ---------------------------------------------------------------------------------------------------- .

* Activate the maternal mortality data again and close down the data files we don't need any more.
get file= "adult_mm_vars.sav".

* select only those with sex given.
select if (MM1 = 1 or MM1 = 2).
dataset name mm.

* weight the data.
compute iweight=v005/1000000.
weight by iweight.
use all.

* Calculate exposure for maternal mortality rate.
* Calculate the upper limits.
compute higcm = V008 - kmax.
compute lowcm = V008 - kmin.
if (MM2 = 0 & MM8 < higcm) higcm = MM8.
* Check for lowcm before date of birth.
if (lowcm < MM4) lowcm = MM4.
* calculate total exposure and upper age group.
compute totexp = higcm - lowcm + 1.
if (totexp < 0) totexp = 0.
compute higage = trunc( (higcm - MM4) / 60 ).
* Initialize flags for adult male, adult female, and maternal deaths.
compute ad = 0.
compute pd = 0.
compute md = 0.
* Check if mm16 exists, if no, assign mm16_exists to 0.
aggregate outfile=* mode=addvariables
/mm16_exists=mean(mm16).
if sysmis(mm16_exists) mm16_exists=0.
* For dead siblings, if died between 15 and 49 then set the flags for adult male, adult female and maternal deaths.
do if (MM2 = 0 & higage >= 3 & higage <= 9 & MM8 >= V008-kmin & MM8 <= V008-kmax).
+ compute ad = 1.
*--------------------------------------------------------------------------
 * Pregnancy-related deaths.
 * NOTE: Identify deaths in the interval of age and time. Very important for all 
the rates and ratios. Note that PR includes mm9=6. Not good but gives a match 
with MM estimates before the question on violence and accidents was added  
--------------------------------------------------------------------------.
+ if (MM1 = 2 & (MM9 >= 2 & MM9 <= 6)) pd = 1.
* Now restrict to maternal deaths, a subset of pregnancy related deaths.
* if the data exists - check mm16 (accidents and violence - to be excluded).
+ if (MM1 = 2 & (MM9 >= 2 & MM9 <= 5) & ((mm16_exists<>0 & mm16<>1 & mm16<>2) or mm16_exists=0)) md = 1.
end if.

* Tally deaths by age group for adult male, adult female, and maternal deaths, by age group (from 15-49).
use all.
compute age_grp = higage-2.
compute filter_$ = (age_grp>=1 and age_grp<=7).
filter by filter_$.
dataset declare deaths.
aggregate
  /outfile='deaths'
  /break=age_grp MM1
  /lw=mean(lw)
  /uw=mean(uw)
  /refdate=mean(refdate)
  /mean_doi=mean(mean_doi)
  /ad=sum(ad)
  /pd=sum(pd)
  /md=sum(md).

* Calculate exposure for mortality rates - split into 3 groups to allow for up to 10 year rates (each sibling may have been exposed in up to 3 age groups).
* calculate age group and exposure in the age group.  age groups coded 3-9 here and adjusted later.
use all.
compute higexp = higcm - MM4 - higage*60 + 1.
if (higexp < 0) higexp = 0.
if (higexp > 60) higexp = 60.
if (higexp > totexp) higexp = totexp.
compute midage = higage-1.
compute midexp = totexp - higexp.
if (midexp > 60) midexp = 60.
if (midexp > totexp) midexp = totexp.
compute lowage = midage-1.
compute lowexp = totexp - higexp - midexp.

formats totexp higcm lowcm higage midage lowage age_grp higexp midexp lowexp  (f4.0).

* Tally exposure by age group for each of the 3 sets of exposure.
use all.
compute age_grp = higage-2.
compute filter_$ = ((MM2 = 1 or MM2 = 0) and age_grp>=1 and age_grp<=7).
filter by filter_$.
dataset declare exp1.
aggregate
  /outfile='exp1'
  /break=age_grp MM1
  /higexp=sum(higexp).

use all.
compute age_grp = midage-2.
compute filter_$ = ((MM2 = 1 or MM2 = 0) and age_grp>=1 and age_grp<=7).
filter by filter_$.
dataset declare exp2.
aggregate
  /outfile='exp2'
  /break=age_grp MM1
  /midexp=sum(midexp).

use all.
compute age_grp = lowage-2.
compute filter_$ = ((MM2 = 1 or MM2 = 0) and age_grp>=1 and age_grp<=7).
filter by filter_$.
dataset declare exp3.
aggregate
  /outfile='exp3'
  /break=age_grp MM1
  /lowexp=sum(lowexp).

* Activiate the deaths file and merge in the 3 sets of exposure variables, plus the age distribution, all by age group.
dataset activate deaths.
match files
  /file=*
  /table='exp1'
  /table='exp2'
  /table='exp3'
  /by age_grp MM1.

sort cases by age_grp.
match files
  /file=*
  /table='agedis'
  /rename (V013=age_grp)
  /by age_grp.

* Compute total exposure for females and for males.
compute totexp = (higexp+midexp+lowexp)/12.
* Calculate mortality rates by age group.
compute mx = ad/totexp.
compute mpx = pd/totexp.
compute mmx = md/totexp.
* calculate age adjustments for the mortality rates.
compute mx_adj = mx * propagegrp.
compute mpx_adj = mpx * propagegrp.
compute mmx_adj = mmx * propagegrp.

* Combine the mortality and fertility datasets.
match files
  /file=*
  /table='births'
  /by age_grp.
execute.

* Multiply mrtality rates by 1000 as aggregate doesn't seem to work when the sum is less than 1  !!!.
compute mx_adj = mx_adj * 1000.
compute mpx_adj = mpx_adj * 1000.
compute mmx_adj = mmx_adj * 1000.

* Aggregate the deaths, exposure and age adjusted rates as well as TFR and GFR to produce the totals entry.
dataset declare rates.
aggregate
  /outfile='rates'
  /break = MM1
  /lw=mean(lw)
  /uw=mean(uw)
  /refdate=mean(refdate)
  /mean_doi=mean(mean_doi)
  /ad=sum(ad)
  /pd=sum(pd)
  /md=sum(md)
  /totexp=sum(totexp)
  /mx_adj=sum(mx_adj)
  /mpx_adj=sum(mpx_adj)
  /mmx_adj=sum(mmx_adj)
  /tfr=mean(tfr)
  /gfr=mean(gfr).

dataset declare ratestot.
aggregate
  /outfile='ratestot'
  /lw=mean(lw)
  /uw=mean(uw)
  /refdate=mean(refdate)
  /mean_doi=mean(mean_doi)
  /ad=sum(ad)
  /pd=sum(pd)
  /md=sum(md)
  /totexp=sum(totexp)
  /mx_adj=sum(mx_adj)
  /mpx_adj=sum(mpx_adj)
  /mmx_adj=sum(mmx_adj)
  /tfr=mean(tfr)
  /gfr=mean(gfr).

* Add the totals entry to the deaths and exposure by age group.
add files
  /file=*
  /file='rates'
  /file='ratestot'.
execute.

* Now divide mortality rates by 1000 to reset as aggregate doesn't seem to work when the sum is less than 1  !!!.
compute mx_adj = mx_adj / 1000.
compute mpx_adj = mpx_adj / 1000.
compute mmx_adj = mmx_adj / 1000.
execute.

dataset close women.
dataset close agedis.
dataset close rates.
dataset close ratestot.
dataset close exp1.
dataset close exp2.
dataset close exp3.
dataset close mm.

* Add a variable for the total and label it and the age groups.
if (sysmis(age_grp) and sysmis(mm1)) total = 0.
variable labels total "".
value labels total 0 "Total 15-49".
if (sysmis(age_grp) and mm1=1) sex = 1.
if (sysmis(age_grp) and mm1=2) sex = 2.
variable labels sex "sex".
value labels sex 1 "Men" 2 "Women".
value labels total 0 "Total 15-49".
if total=0 age_grp=10.
if sex=1 age_grp=8.
if sex=2 age_grp=9.
value labels age_grp 1 '15-19' 2 '20-24' 3 '25-29' 4 '30-34' 5 '35-39' 6 '40-44' 7 '45-49' 8 "Men (15-49)" 9 "Women (15-49)" 10 'Total'.

* Calcalute the proportion pregnancy of the adult female deaths.
if (mm1=2) prpmdf = pd / ad.
* Calcalute the proportion maternal of the adult female deaths.
if (mm1=2) mpmdf = md / ad.
* Set the mortality rates in the total line to the age adjusted mortality rates (for adult male, adult female and maternal deaths).
if (total=0 or sex=1 or sex=2) mx = mx_adj.
if (total=0 or sex=1 or sex=2) mpx = mpx_adj.
if (total=0 or sex=1 or sex=2) mmx = mmx_adj.

variable labels
 mm1 'sex'
 /ad 'wtd_deaths'
 /pd 'wtd_prdeaths'
 /md 'wtd_mdeaths'
 /totexp 'wtd_yexp'
 /mx_adj 'mx_adj: Age-adjusted adult mortality rate for 15-49. Multiply by 1000 to present per 1000 persons'
 /mpx_adj 'mpx_adj: Age-adjusted pregnancy-related mortality rate for women 15-49. Multiply by 1000 to present per 1000 women'
 /mmx_adj 'mmx_adj: Age-adjusted maternal mortality rate for women 15-49. Multiply by 1000 to present per 1000 women'
 /mx 'mx: Adult mortality rate for 15-49. Multiply by 1000 to present per 1000 persons'
 /mpx 'mpx: Pregnancy-related mortality rate for women 15-49. Multiply by 1000 to present per 1000 women'
 /mmx 'mmx: Maternal mortality rate for women 15-49. Multiply by 1000 to present per 1000 women'
.

value labels mm1 1 "Men" 2 "Women".

* Tabulation of results.
oms
 /select tables
 /if subtypes = ['Case Processing Summary']
 /destination viewer = no.

output close *.

define saveSheet(!positional !tokens(1))
output export 
/xls documentfile = "AM_tables.xls"
sheet=!1
operation=modifysheet
/contents export = visible layers = printsetting modelviews = printsetting.
output close * .
!enddefine .

* tabulate the adult male and female mortality rates.
sort cases by mm1 age_grp.
compute filter=age_grp<=7.
filter by filter.
summarize
  /tables=refdate mean_doi mm1 age_grp mx ad totexp lw uw
  /format validlist nocasenum nototal
  /title='Adult mortality by age'
  /missing=variable
  /cells=count.

savesheet "Adult mortality by age".

filter off.
* tabulate PR mortality by age.
compute filter=(mm1=2 and age_grp<=7).
filter by filter.
summarize
  /tables=refdate mean_doi mm1 age_grp mpx fx prpmdf pd totexp lw uw
  /format validlist nocasenum nototal
  /title='PR mortality by age'
  /missing=variable
  /cells=count.

savesheet "PR mortality by age".

filter off.
* tabulate maternal mortality by age.
compute filter=(mm1=2 and age_grp<=7).
filter by filter.
summarize
  /tables=refdate mean_doi mm1 age_grp mmx fx mpmdf md totexp lw uw
  /format validlist nocasenum nototal
  /title='Maternal mortality by age'
  /missing=variable
  /cells=count.

savesheet "Maternal mortality by age".

filter off.
* tabulate maternal mortality ratio.
compute filter=(sex=2).
filter by filter.
do if (sex = 2).
+ compute PRMRatio = mpx_adj / gfr.
+ compute MMRatio = mmx_adj / gfr.
* two versions of the LTR (Lifetime Risk); In LTR2 the factor 16.7 is an approximation from another source.
+ compute prLTR1 = 1 - (1 - PRMRatio)**tfr.
+ compute mLTR1 = 1 - (1 - MMRatio)**tfr.
end if.

variable labels
  MMRatio 'mmratio: Maternal mortality ratio. Multiply by 100000 to present per 100,000 live births'
 /PRMRatio 'prmratio: Pregnancy-related mortality ratio. Multiply by 100000 to present per 100,000 live births'
 /prLTR1 'prLTR1: Lifetime risk of pregnancy-related mortality'
 /mLTR1 'mLTR1: Lifetime risk of maternal mortality'
.

summarize
  /tables=sex tfr MMRatio mLTR1 PRMRatio prLTR1
  /format validlist nocasenum nototal
  /title='Maternal Mortality Ratio'
  /missing=variable
  /cells=count.

savesheet "Maternal Mortality Ratio".

filter off.

* Calculate 35q15 for men and women.
* See DHS Guide to Statistics for use of 2.4 rather than 2.5 in the following formula.
compute qx = 1 - ( 5 * (mx) / (1+2.4*(mx)) ).
do if (age_grp = 1).
+ compute prob = qx.
else if (not sysmis(age_grp)).
+ compute prob = lag(prob) * qx.
end if.
do if (sex = 1 or sex = 2).
+ compute q_15_to_50= (1 - lag(prob)).
end if.

compute filter = (sex=1 or sex=2).
filter by filter.
summarize
  /tables=refdate mean_doi sex q_15_to_50 lw uw
  /format validlist nocasenum nototal
  /title="Adult mortality probabilities"
  /missing=variable
  /cells=count.

savesheet "Adult mortality probabilities".

*reset women specific variables to 0.
if sex=1 gfr=0.
if sex=1 tfr=0.
summarize
  /tables=sex lw uw refdate mean_doi ad pd md totexp mx_adj mpx_adj mmx_adj gfr PRMRatio MMRatio tfr prpmdf mpmdf q_15_to_50 prLTR1 mLTR1
  /format validlist nocasenum nototal
  /title="Mortality summary"
  /missing=variable
  /cells=count.

savesheet "Mortality summary".

* Clean up all of the data files.
dataset close deaths.
dataset close births.
new file.
