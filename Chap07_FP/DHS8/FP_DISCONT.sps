* Encoding: windows-1252.
******************************************************************************************************
Program: 			FP_DISCONT.sps
Purpose: 			Create contraceptive discontinuation rates
Data inputs: 		Event data files (created from IR files)
Data outputs:		data set with 12-month discontinuation rates
Author:				Trevor Croft 
Date last modified: September 30 2019 by Ivana Bjelic for codeshare project

 * NOTE: 				this code can also be found in the online Contraceptive Tutorial: Example 9
LINK HERE ---->>>>  https:*www.dhsprogram.com/data/calendar-tutorial/ 				
*****************************************************************************************************/


*----------------------------------------------------------------------------*
Outputs:
Tables_Discont_12m.xlsx	This excel file has a table listing 12-month discontinuation
					rates by reason, method, and switching. The table also includes
					the unweighted and weighted Ns.
*							
eventsfile.sav				Events dataset file for the survey
/----------------------------------------------------------------------------*/

* -------------------------------------------------*
NOTE ON DISCONTINUATION RATES
When calculating discontinuation rates using event 
files note that the denominator in this table 
is all women, including sterilized women also 
includes missing methods to match the final reports.
*--------------------------------------------------*.

* name the dataset.
dataset name eventsfile.

*STEP 1.
* ------------------------------------------------*
Calculate exposure, late entries and censoring 
for the period 3-62 months prior to the interview
--------------------------------------------------*.

*compute wt.
compute wt = v005/1000000.

*drop events that were ongoing when calendar began.
select if (v017 <> ev900).

*drop births, terminations, pregnancies, and episodes of non-use.
*keep missing methods. to exclude missing change 99 below to 100.
select if (ev902 <= 80 or ev902 >= 99) and ev902<>0.

* time from beginning of event to interview.
compute tbeg_int = v008 - ev900.
variable labels tbeg_int "time from beginning of event to interview".

*time from end of event to interview.
compute tend_int = v008 - ev901.
variable labels tend_int "time from end of event to interview".
formats tbeg_int tend_int (f2.0).

*discontinuation variable.
compute discont = 0.
if ev903 <> 0 discont = 1.

*censoring those who discontinue in last three months.
if tend_int < 3 discont = 0.
variable labels discont "discontinuation indicator".
value labels discont 0 "No discontinuation" 1 "Discontinuation".
formats discont (f1.0).
frequencies variables=discont.
crosstabs tables=ev903 by discont /cells=count column /count=asis.

*generate late entry variable.
compute entry = 0.
if tbeg_int >= 63 entry = tbeg_int - 62.
variable labels entry "Late entry months".
formats entry (f1.0).
crosstabs tbeg_int by entry.

*taking away exposure time outside of the 3 to 62 month window.
compute exposure = ev901a.
if (tend_int < 3) exposure = ev901a - (3 - tend_int).
recode exposure (-3 thru 0=0).
variable labels exposure "Exposure".
formats exposure (f2.0).

*drop those events that started in the month of the interview and two months prior.
select if (tbeg_int >= 3).

*drop events that started and ended before 62 months prior to survey.
select if (tbeg_int <= 62 | tend_int <= 62).

*to remove sterilized women from denominator use the command below - not used for DHS standard.
*if ev902 = 6 exposure = $sysmis. 

*censor any discontinuations that are associated with use > 59 months (not censored here in this example).
*if (exposure - entry) > 59 discont = 0.

*STEP 2.
* -------------------------------------------------*
Recode contraceptive methods, discontinuation reason, 
and construct switching
--------------------------------------------------*.

* recode contraceptive method.
* -------------------------------------------------*
NOTE: IUD, Periodic Abstinence, and Withdrawal skipped 
and grouped with other due to small numbers of cases
You can tab ev902 to examine categories with few cases.
*--------------------------------------------------*.

recode ev902 					
  (sysmis = sysmis) 
  (1 = 1) /*(2 = 2)*/ (3 = 3) (11 = 4) (5 = 5) /*(8 = 6)*/ /*(9 = 7)*/ (13,18 = 8) (else = 9) into method.
value labels method 
    1 "Pill"
    2 "IUD"
    3 "Injectables"
    4 "Implant"
    5 "Male condom"
    6 "Periodic abstinence"
    7 "Withdrawal"
    8 "LAM/EC"
    9 "Other"
    99 "All methods".
   /* used later */

formats method (f1.0).
crosstabs ev902 by method.
	
* -------------------------------------------------*
NOTE: LAM and Emergency contraception are grouped here
Other category is Female Sterilization, Male sterilization,
Other Traditional, Female Condom, Other Modern, Standard 
Days Method	plus IUD, Periodic Abstinence, Withdrawal
You need to adjust global meth_list below if changing
the grouping of methods above.
*--------------------------------------------------*.

compute filter$ = (discont = 1).
filter by filter$.
* recode reasons for discontinuation - ignoring switching.
recode ev903
  (0 sysmis = sysmis)
  (1       = 1 /* Method failure */)
  (2       = 2 /* Desire to become pregnant */)
  (9 12 13 = 3 /* Other fertility related reasons */)
  (4 5     = 4 /* Side effects/health concerns */)
  (7       = 5 /* Wanted more effective method */)
  (6 8 10  = 6 /* Other method related */)
  (else    = 7 /* Other/DK */)
  into reason.
variable labels reason "Reason for discontinuation".
value labels reason
    1 "Method failure"
    2 "Desire to become pregnant"
    3 "Other fertility related reasons"
    4 "Side effects/health concerns"
    5 "Wanted more effective method"
    6 "Other method related"
    7 "Other/DK".

formats reason (f1.0).
if (discont <> 1) reason = $sysmis.
crosstabs ev903 by reason.

filter off.

*switching methods.
sort cases by caseid (a) ev004 (d).
	
if (caseid = lag(caseid) & ev901+1 = lag(ev900)) switch = 1.
* if reason was "wanted more effective method" allow for a 1-month gap.
if (ev903 = 7 & ev905 = 0 & caseid = lag(caseid) & ev901+2 >= lag(ev900)) switch = 1.

* not a switch if returned back to the same method.
* there should be none of these, so there should be no changes from this command.
if (caseid = lag(caseid) & ev902 = lag(ev902) & ev901+1 = lag(ev900)) switch = $sysmis.

variable labels switch "Switching method".
value labels switch 1 "Switched method".
formats switch (f1.0).

frequencies variables = switch.

* -------------------------------------------------*
NOTE: that these are likely rare, so there may be
no or few changes from the command above 
*--------------------------------------------------*.
	
*calculate variable for switching for discontinuations we are using.
compute discont_sw = $sysmis.
if switch = 1 & discont = 1 discont_sw = 1.
if sysmis(discont_sw) & ev903 <> 0 & not sysmis(ev903) & discont = 1 discont_sw = 0.
variable labels discont_sw "Discontinuation for switching".
value labels discont_sw 1 "switch" 0 "other reason".
frequencies variables = discont_sw.

*STEP 3.
* -------------------------------------------------*
Calculate the competing risks cumulative incidence 
for each method and for all methods
*--------------------------------------------------*.

weight by wt.

* Split reason for discontinuation into separate 0/1 variables.
recode reason (1 = 1)(else = 0) into reason_1.
recode reason (2 = 1)(else = 0) into reason_2.
recode reason (3 = 1)(else = 0) into reason_3.
recode reason (4 = 1)(else = 0) into reason_4.
recode reason (5 = 1)(else = 0) into reason_5.
recode reason (6 = 1)(else = 0) into reason_6.
recode reason (7 = 1)(else = 0) into reason_7.
variable labels 
  reason_1 "Method failure"
  reason_2 "Desire to become pregnant"
  reason_3 "Other fertility related reasons"
  reason_4 "Side effects/health concerns"
  reason_5 "Wanted more effective method"
  reason_6 "Other method related"
  reason_7 "Other/DK".
formats reason_1 reason_2 reason_3 reason_4 reason_5 reason_6 reason_7 (f1.0).

* Aggregate counts by exposure of totals exposure (N) and discontinuations for each reason.
* by method.
dataset declare aggr_meth.
aggregate
  /outfile='aggr_meth'
  /break=method exposure
  /discont =sum(discont)
  /reason_1=sum(reason_1)
  /reason_2=sum(reason_2)
  /reason_3=sum(reason_3)
  /reason_4=sum(reason_4)
  /reason_5=sum(reason_5)
  /reason_6=sum(reason_6)
  /reason_7=sum(reason_7)
  /discont_sw=sum(discont_sw)
  /expo=N
  /expo_u=NU.

* for All methods.
dataset declare aggr_all.
aggregate
  /outfile='aggr_all'
  /break=exposure
  /discont =sum(discont)
  /reason_1=sum(reason_1)
  /reason_2=sum(reason_2)
  /reason_3=sum(reason_3)
  /reason_4=sum(reason_4)
  /reason_5=sum(reason_5)
  /reason_6=sum(reason_6)
  /reason_7=sum(reason_7)
  /discont_sw=sum(discont_sw)
  /expo=N
  /expo_u=NU.

* combine file of exposure for all methods and by method into one.
dataset activate aggr_meth.
add files
  /file=*
  /file='aggr_all'.
execute.

* recode missing to 99 for all methods.
recode method (sysmis = 99).

* Switch back to the events file for the late entries.
dataset activate eventsfile.

* Aggregate counts of late entries - to be removed later from cumulative exposure.
* by method.
dataset declare aggr_late_meth.
aggregate
  /outfile='aggr_late_meth'
  /break=method entry
  /lateentry=N
  /lateentry_u=NU.

* for All methods.
dataset declare aggr_late_all.
aggregate
  /outfile='aggr_late_all'
  /break=entry
  /lateentry=N
  /lateentry_u=NU.

* combine file of late entries for all methods and by method into one.
dataset activate aggr_late_meth.
add files
  /file=*
  /file='aggr_late_all'.
execute.

* recode missing to 99 for all methods.
recode method (sysmis = 99).

* drop cases without late entry (entry = 0).
select if (entry >  0).
* rename late entry variable to exposure.
rename variables entry = exposure.

* merge the exposure and late entries files into one file by method and exposure.
dataset activate aggr_meth.
match files
  /file = *
  /table = 'aggr_late_meth'
  /by method exposure.

* set any missing late entries and any missing switching to 0.
if (sysmis(lateentry)) lateentry = 0.
if (sysmis(lateentry_u)) lateentry_u = 0.
if (sysmis(discont_sw)) discont_sw = 0.
execute.

* close separate files that are no longer needed.
dataset close aggr_all.
dataset close aggr_late_all.
dataset close aggr_late_meth.
dataset close eventsfile.

* Accumulate the exposure and the episodes for the prior months.

* reverse the order of the file so longest exposure first to allow for cumulation of the exposures.
sort cases method (a) exposure (d).
* initialize the cumulative exposure to 0.
compute cum_expo = 0.
compute episodes = 0.
compute cum_expo_u = 0.
* if the last month (first entry) for the method, set the cumulative exposure to the monthly exposure minus the late entries. 
if (missing(lag(method)) or method<>lag(method)) cum_expo = expo - lateentry.
if (missing(lag(method)) or method<>lag(method)) episodes = expo.
if (missing(lag(method)) or method<>lag(method)) cum_expo_u = expo_u - lateentry_u.
* if not the last month (first entry) for the method, 
* set the cumulative exposure to the previous months cumulative exposure plus the monthly exposure minus the late entries. 
if (method=lag(method)) cum_expo = lag(cum_expo) + expo - lateentry.
if (method=lag(method)) episodes = lag(episodes) + expo.
if (method=lag(method)) cum_expo_u = lag(cum_expo_u) + expo_u - lateentry_u.
execute.

* drop the cases beyond 12 months exposure now as we are only interested in 12 month discontinuation rates. 
* change to 24 or 36 if two year or three year discontinuation rates are desired.
select if (exposure <= 12).
* resort the data to enable the calculation of the life table.
sort cases method (a) exposure (a).

* Monthly rates of discontinuation.
* Convert counts of discontinuation and switching rates to monthly rates.
compute discont = discont/cum_expo.
compute discont_sw = discont_sw/cum_expo.
compute reason_1 = reason_1/cum_expo.
compute reason_2 = reason_2/cum_expo.
compute reason_3 = reason_3/cum_expo.
compute reason_4 = reason_4/cum_expo.
compute reason_5 = reason_5/cum_expo.
compute reason_6 = reason_6/cum_expo.
compute reason_7 = reason_7/cum_expo.

* Construct the life table.
do if (exposure = 1).
* First month of life table = 1 minus the monthly rate for month 1.
+ compute lt_reason_1 = 1 - reason_1.
+ compute lt_reason_2 = 1 - reason_2.
+ compute lt_reason_3 = 1 - reason_3.
+ compute lt_reason_4 = 1 - reason_4.
+ compute lt_reason_5 = 1 - reason_5.
+ compute lt_reason_6 = 1 - reason_6.
+ compute lt_reason_7 = 1 - reason_7.
+ compute lt_discont = 1 - discont.
+ compute lt_discont_sw = 1 - discont_sw.
else.
* remaining months.
+ compute lt_reason_1 = lag(lt_reason_1) - (lag(lt_discont) * reason_1).
+ compute lt_reason_2 = lag(lt_reason_2) - (lag(lt_discont) * reason_2).
+ compute lt_reason_3 = lag(lt_reason_3) - (lag(lt_discont) * reason_3).
+ compute lt_reason_4 = lag(lt_reason_4) - (lag(lt_discont) * reason_4).
+ compute lt_reason_5 = lag(lt_reason_5) - (lag(lt_discont) * reason_5).
+ compute lt_reason_6 = lag(lt_reason_6) - (lag(lt_discont) * reason_6).
+ compute lt_reason_7 = lag(lt_reason_7) - (lag(lt_discont) * reason_7).
+ compute lt_discont = lag(lt_discont) - (lag(lt_discont) * discont).
+ compute lt_discont_sw = lag(lt_discont_sw) - (lag(lt_discont) * discont_sw).
end if.
execute.
formats lt_reason_1 lt_reason_2 lt_reason_3 lt_reason_4 lt_reason_5 lt_reason_6 lt_reason_7 lt_discont lt_discont_sw (f8.6).

* STEP 4.
* -------------------------------------------------*
Total episodes, including late entries can
be found in first row of life table 
use offset of 11 from 12th row to point to first. 
*--------------------------------------------------*.

if (exposure = 12) nepisodes = lag(episodes,11).
if (exposure = 12) nexpo_u = lag(cum_expo_u,11).
variable labels 
  nepisodes "Number of episodes of use [5]" 
 /nexpo_u "Unweighted exposure in first month".
formats nepisodes nexpo_u (f6.0).
execute.


* STEP 5.
* -------------------------------------------------*
Select just the 12 months exposure to report.
*--------------------------------------------------*.

select if (exposure = 12).

* Now extract 12 month discontinuation rates.
+ compute disc_reason_1 = 100* (1 - lt_reason_1).
+ compute disc_reason_2 = 100* (1 - lt_reason_2).
+ compute disc_reason_3 = 100* (1 - lt_reason_3).
+ compute disc_reason_4 = 100* (1 - lt_reason_4).
+ compute disc_reason_5 = 100* (1 - lt_reason_5).
+ compute disc_reason_6 = 100* (1 - lt_reason_6).
+ compute disc_reason_7 = 100* (1 - lt_reason_7).
+ compute disc_any      = 100* (1 - lt_discont).
+ compute disc_switch   = 100* (1 - lt_discont_sw).
formats disc_reason_1 disc_reason_2 disc_reason_3 disc_reason_4 
               disc_reason_5 disc_reason_6 disc_reason_7 disc_any disc_switch (f5.1).
variable labels 
  disc_reason_1 "Method failure"
  disc_reason_2 "Desire to become pregnant"
  disc_reason_3 "Other fertility related reasons"
  disc_reason_4 "Side effects/health reasons"
  disc_reason_5 "Wanted more effective method"
  disc_reason_6 "Other method related reasons"
  disc_reason_7 "Other/DK"
  disc_any "Any reason"
  disc_switch "Switched to another method".

save outfile = "drates_12m.sav".
dataset name drates_12m.

* STEP 6.
* -------------------------------------------------
Output results in various ways
--------------------------------------------------*.

* Create excel sheet with discontinuation rates for Reasons(rows) and Methods(columns).
ctables
  /vlabels variables=method display=none
  /vlabels variables=disc_reason_1 disc_reason_2 disc_reason_3 disc_reason_4 disc_reason_5 
                                 disc_reason_6 disc_reason_7 disc_any disc_switch nepisodes nexpo_u display=label
  /format maxcolwidth=55
  /table   (disc_reason_1 + disc_reason_2 + disc_reason_3 + disc_reason_4 +
   disc_reason_5 + disc_reason_6 + disc_reason_7 + disc_any + disc_switch) [s] [mean,'',f6.1] by method [c]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
  "Discontinuation rates for Reasons and Methods"
.
* sort cases by method.
* split file by method.
* descriptives variables disc_reason_1 disc_reason_2 disc_reason_3 disc_reason_4 disc_reason_5 disc_reason_6 disc_reason_7 disc_any disc_switch nepisodes nexpo_u /statistics=mean.
* split file off.

* Create excel sheet that will match final report table with Methods(rows) and Reasons(columns).
	
ctables
  /vlabels variables=method display=none
  /vlabels variables=disc_reason_1 disc_reason_2 disc_reason_3 disc_reason_4 disc_reason_5 
                                 disc_reason_6 disc_reason_7 disc_any disc_switch nepisodes nexpo_u display=label
  /format maxcolwidth=55
  /table method [c] by 
  (disc_reason_1 + disc_reason_2 + disc_reason_3 + disc_reason_4 +
   disc_reason_5 + disc_reason_6 + disc_reason_7 + disc_any + disc_switch) [s] [mean,'',f6.1] + (nepisodes + nexpo_u) [s] [mean,'',f8.0]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
  "Twelve-month contraceptive discontinuation rates"
.

* sort cases by method.
* split file by method.
* descriptives variables disc_reason_1 disc_reason_2 disc_reason_3 disc_reason_4 disc_reason_5 disc_reason_6 disc_reason_7 disc_any disc_switch nepisodes nexpo_u /statistics=mean.
* split file off.

output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xlsx  documentfile="Tables_Discont_12m.xlsx"
     operation=createfile.
output close *.

new file.
dataset close drates_12m.

*these are the discontinuation rates stored as a SPSS data file. If you wish to have this file uncomment the line below.
erase file = "drates_12m.sav".


