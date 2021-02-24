* Encoding: UTF-8.
*****************************************************************************************************
Program: 			AM_gfr.sps
Purpose: 			Code to produce ASFRs and GFR for use in estimating maternal mortality
Data inputs: 		IR and BR survey lists
Data outputs:		coded variables
Author:			Trevor Croft for the code share project, and translated to SPSS by Ivana Bjelic
Date last modified: February 12, 2021 by Ivana Bjelic
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
fx		"age-specific fertility rate"
fx_adj            	"adjusted age-specific fertility rate"
TFR		"total fertility rate"
GFR 		"general fertility rate"
----------------------------------------------------------------------------


*----------------------------------------------------------------------------
NOTES
	This program should be run before AM_rates because ASFRs are needed to calculate 
	a re-weighted GFR. 
*
	This version uses awfactt for the calculation of the ASFRs and for the age-adjustment
	of the GFR and Maternal Mortality Rate.
*----------------------------------------------------------------------------.

dataset name women.
* Sample weight.
compute iweight = v005/1000000.
* For ever married samples to use the all women factors.
if v020=1 iweight = (awfactt/100)*(v005/1000000).

* Weight by exposure in current age group.
weight by iweight.

* Produce an age distribution of the women for later use for age adjusted estimates.
dataset declare agedis.
aggregate
  /outfile='agedis'
  /break=V013
  /Nwomen=N.

* Sum the women and add the sum to all cases.
dataset activate agedis.
aggregate
  /outfile=* mode=addvariables
  /break=
  /Tot_women=sum(Nwomen).

* Calculate the proportion of the women in each age group.
compute propagegrp = Nwomen/Tot_women.
execute.

* Now go back to the women's data file to produce mean number of siblings (including respondent) and sex ratio of siblings (excluding respondent).
dataset activate women.
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

* Set up the period length and related variables.
periodlen.

* Calculate exposure for fertility rate - split into 3 groups to allow for up to 10 year rates (each woman may have been exposed in up to 3 age groups).
* calculate age group and exposure in the age group.  Age groups coded 3-9 here and adjusted later.
compute higcm = V008 - kmax.
compute higage = trunc( (higcm - V011) / 60 ).
compute higexp = higcm - V011 - higage*60 + 1.
if (higexp > 60) higexp = 60.
if (higexp > totexp) higexp = totexp.
compute midage = higage-1.
compute midexp = totexp - higexp.
if (midexp > 60) midexp = 60.
if (midexp > totexp) midexp = totexp.
compute lowage = midage-1.
compute lowexp = totexp - higexp - midexp.

* Tally exposure by age group for each of the 3 sets of exposure.
use all.
compute age_grp = higage-2.
compute filter_$ = (age_grp>=1 and age_grp<=7).
filter by filter_$.
dataset declare exp1.
aggregate
  /outfile='exp1'
  /break=age_grp
  /higexp=sum(higexp).

use all.
compute age_grp = midage-2.
compute filter_$ = (age_grp>=1 and age_grp<=7).
filter by filter_$.
dataset declare exp2.
aggregate
  /outfile='exp2'
  /break=age_grp
  /midexp=sum(midexp).

use all.
compute age_grp = lowage-2.
compute filter_$ = (age_grp>=1 and age_grp<=7).
filter by filter_$.
dataset declare exp3.
aggregate
  /outfile='exp3'
  /break=age_grp
  /lowexp=sum(lowexp).

* Calculate births for fertility rate.
* Open the births data file.
get file =  datapath + "\"+ brdata + ".sav".

*create var to generate filename.
string file (a2).
compute file=lower (char.substr(brdata,3,2)).

* Set up the period length and related variables.
periodlen.

* Calculate age group of each birth and select only those in the period of interest and in the age groups of interest.
use all.
compute age_grp = trunc( (B3 - V011) / 60 ) - 2.
compute filter_$ = (B3 >= V008-kmin and B3 <= V008-kmax and age_grp>=1 and age_grp<=7).
execute.
filter by filter_$.

* Weight the data.
compute iweight=v005/1000000.
weight by iweight.

* Tally the births by age group.
dataset declare births.
aggregate
  /outfile='births'
  /break=age_grp
  /births=N.

* Open the births and attach the exposure variables.
dataset activate births.
match files
  /file=*
  /table='exp1'
  /table='exp2'
  /table='exp3'
  /table='agedis'
  /rename (V013=age_grp)
  /by age_grp.

* recode the empty cells for exposure to 0.
if (sysmis(lowexp)) lowexp = 0.
if (sysmis(midexp)) midexp = 0.
* Calculate total exposure and the age specific fertilty rates.
compute totexp = (higexp+midexp+lowexp)/12.
compute fx = births/totexp.
compute fx_adj = fx * propagegrp.

* Multiply fx and fx_adj by 1000 as aggregate doesn't seem to work when the sum is less than 1  !!!.
compute fx = fx * 1000.
compute fx_adj = fx_adj * 1000.

* Calculate total fertility rate.
* The total fertility rate (TFR) is calculated by summing the age-specific fertility rates (fx) calculated for each of the 5-year age groups of women.
aggregate outfile=* mode=addvariables overwrite=yes
 /break
 /tfr=sum(fx)
 /gfr=sum(fx_adj).

* Now divide fx and fx_adj by 1000 to reset as aggregate doesn't seem to work when the sum is less than 1  !!!.
compute fx = fx / 1000.
compute fx_adj = fx_adj / 1000.
compute tfr = tfr / 1000.
compute gfr = gfr / 1000.

* Compute the TFR.
compute tfr = tfr*5.
execute.

* Close all the datasets that are no longer needed, including the births file.
dataset close exp1.
dataset close exp2.
dataset close exp3.
