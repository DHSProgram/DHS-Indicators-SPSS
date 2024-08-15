* Encoding: windows-1252.
 * /*****************************************************************************************************
Program: 			FP_EVENTS.sps
Purpose: 			Create Events Files from Calendar Data
Data inputs: 		IR dataset
Data outputs:		Reshaped events file for analysis
Author:				Trevor Croft and translated to SPSS by Ivana Bjelic
Date last modified: September 30 2019 by Ivana Bjelic for codeshare project 				
*****************************************************************************************************/

 * /*----------------------------------------------------------------------------*
ev004		"Event number"
ev900  		"CMC event begins"
ev901  		"CMC event ends"
ev901a 		"Duration of event"
ev902a 		"Event code (alpha)"
ev903a 		"Discontinuation code (alpha)"
ev902  		"Event code"
ev903  		"Discontinuation code"
ev904  		"Prior event code" 
ev904x 		"Duration of prior event"
ev905  		"Next event code"
ev905x 		"Duration of next event"
ev906a 		"Married at end of episode (alpha)"
ev906  		"Married at end of episode"
/----------------------------------------------------------------------------*/

erase file = "eventsfile.sav".

* set up which calendar columns to look at - column numbers can vary across phases of DHS.
* method use and pregnancies - always column 1.
define !calendar1 ()
vcal$1.
!enddefine.
* reasons for discontinuation - usually column 2.
define !calendar2 ()
vcal$2.
!enddefine.
* marriage - when it exists it is usually column 3.
define !calendar3 ()
vcal$3.
!enddefine.
* set length of calendar in a macro.
define !vcal_len() 80 !enddefine.

*check to see if marriage calendar exists.
begin program.
import spss, spssaux
varList = "vcal$3"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "string " + " ".join(undefined) + "(a1)"
  spss.Submit(cmd)
end program.

execute.
* check  vcal3 is emtpy.
compute vcal3_len = length(rtrim(vcal$3)).
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=
  /vcal$3_included=mean(vcal3_len).
recode vcal$3_included (1 thru hi = 1)(0 = 0).


*PART 1.

* --------------------------------------------------*
Convert calendar into separate variables per month
Starting at the chronological beginning of the 
calendar, episodes are counted when there is a change
from one month to another.
*---------------------------------------------------*.

*set length of calendar.
compute mloop = length(ltrim(rtrim(vcal$1))).
set mxloops =  100.

*set episode number to 0.
compute eps = 0.							

*set prev calendar column 1 to anything.
string prev_vcal1 (a1).
compute prev_vcal1 = "_".

vector vcal1_ (!vcal_len a1) vector vcal2_(!vcal_len a1) vcal3_(!vcal_len a1) ev004(!vcal_len f2.0).

loop #i=1 to !vcal_len.

 compute #j = !vcal_len-#i+1.
*contraceptive method, non-use, or birth, pregnancy, or termination.
   compute vcal1_(#i)=char.substr(!calendar1,#j,1).
*reason for discontinuation.
   compute vcal2_(#i)=char.substr(!calendar2,#j,1).
*check if we have marriage info.
   compute vcal3_(#i)=" ".
   if  vcal$3_included = 1 vcal3_(#i)=char.substr(!calendar3,#j,1).
*increase the episode number if there is a change in vcal_1.
  if vcal1_(#i) <> prev_vcal1 eps = eps+1.

*set the episode number.
   compute ev004(#i) = eps.			
	
*save the vcal1 value for the next time through the loop.
   compute prev_vcal1 = vcal1_(#i).		
end loop.



*PART 2.
		
*---------------------------------------------------*
Reshape data into a file with one record per month
of the calendar.

*drop the calendar variables now we have the separate month by month variables.
execute.
delete variables vcal$1 vcal$2 vcal$3 eps prev_vcal1.

*reshape the new month by month variables into a long format.
varstocases
 /make ev004 from ev0041 to ev004!vcal_len
 /make vcal1_ from vcal1_1 to vcal1_!vcal_len
 /make vcal2_ from vcal2_1 to vcal2_!vcal_len
 /make vcal3_ from vcal3_1 to vcal3_!vcal_len
 /index i (!vcal_len)
 /null=keep.
.


*label the event number variable.
variable labels ev004 "Event number".

*PART 3
		
*--------------------------------------------------*
Calculate CMC for each month and drop months beyond 
the month of interview.
*---------------------------------------------------*.
	
*create the century month code (CMC) for each month.
compute cmc=v017+i-1.
print formats cmc (f2.0).

*drop the blank episode after the date of interview.
select if i <= v019. 

*PART 4.

*---------------------------------------------------*
Convert from a single month per record to an event 
per record. Each event will have newly created 
variables containing the start (ev900) and end (ev901)
dates of the event as well as the duration (ev901a)
of that event.
*---------------------------------------------------*.

*collapse the episodes within each case, keeping start and end, the event code,
*and other useful information (this list will be similar to the variables kept in beginning on line 30).

dataset declare Events.
aggregate
  /outfile='Events'
  /break=caseid ev004
  /v001 = first (v001)
  /v002 = first (v002)
  /v003 = first (v003)
  /v005 = first (v005)
  /v007 = first (v007)
  /v008 = first (v008)
  /v011 = first (v011)
  /v017 = first (v017)
  /v018 = first (v018)
  /v019 = first (v019)
  /v021 = first (v021)
  /v023 = first (v023)
  /v101 = first (v101)
  /v102 = first (v102)
  /v106 = first (v106)
  /v190 = first (v190)
  /ev900 = first (cmc)
  /ev901 = last (cmc)
  /ev901a = Nu (cmc)
  /ev902a = last (vcal1_)
  /ev903a = last (vcal2_)
  /ev906a = last (vcal3_)
.

dataset activate Events.

*label the variables created in the collapse statement.
variable labels ev900  "CMC event begins".
variable labels ev901  "CMC event ends".
variable labels ev901a "Duration of event".
variable labels ev902a "Event code (alpha)".
variable labels ev903a "Discontinuation code (alpha)".
formats ev004 (f2.0).
formats ev900 ev901 (f4.0).

*PART 5.

*---------------------------------------------------*
Convert the event string variable for the episode (ev902a)
to numeric (ev902).
		
 * NOTE: Set up a list of codes used in the calendar, with 
the position in the string of codes being the code that 
will be assigned use a tilde (~) to mark gaps in the 
coding that are not used for this survey.
	
 * Emergency contraception (E), Other modern method (M) and 
Standard days method (S) are recent additions as standard 
codes and may mean something different in earlier surveys. 
 * Some of the codes are survey specific so this will need 
adjusting.
*--------------------------------------------------*.

*tab vcal1_ to see the full list of codes to handle for the survey you are using.
string methodlist (a20).
compute methodlist = "123456789WNALCFEMS~".

*convert the contraceptive methods to numeric codes, using the position in the string.
compute ev902 = char.index(methodlist,ev902a).
	
*now convert the birth, termination and pregnancy codes to 81, 82, 83 respectively.
compute preg = char.index("BTP",ev902a).
if preg>0 ev902 = preg+80.
execute.
delete variables preg.
execute.

*convert the missing code to 99.
if ev902a = "?" ev902 = 99.
	
*now check if there are any codes that were not converted, and change these to -1.
if ev902 = 0 & ev902a <> "0" ev902 = -1.

*list cases where the event code was not recoded.
compute filter =  ev902=-1.
filter by filter.
list caseid ev004 ev902 ev902a.
filter off.

*PART 6.

*---------------------------------------------------*
Convert the discontinuation string variable for the 
episode (ev903a) to numeric (ev903).
*---------------------------------------------------*.
	
*set up a list of codes used in the calendar.
*use a tilde (~) to mark gaps in the coding that are not used for this survey .
string reasonlist (a20).
compute reasonlist = "123456789CFAD~~~~".
	
*convert the reasons for discontinuation to numeric codes, using the position in the string.
if ev903a <> " " ev903 = char.index(reasonlist,ev903a).
	
*now convert the special codes for other, don't know and missing to 96, 98, 99 respectively.
compute special = char.index("W~K?",ev903a).
if special > 0 ev903 = special + 95.
execute.
delete variables special.
execute.
	
*now check if there are any codes that were not converted, and change these to -1.
if ev903 = 0 & ev903a <> " " ev903 = -1.

*list cases where the reason for discontinuation code was not recoded.
compute filter =  ev903=-1.
filter by filter.
list variables caseid ev004 ev903 ev903a.
filter off.


*PART 7.

*---------------------------------------------------*
Capture the prior and next events and their durations.
*---------------------------------------------------*.

*capture the previous event and its duration for this respondent.
*capture the following event and its duration for this respondent.
if (caseid = lag(caseid)) ev904  = lag(ev902).
if (caseid = lag(caseid)) ev904x = lag(ev901a).
* need to sort the data in reverse order of the episode to be able to use the lag function.
sort cases by caseid ev004(d).
* capture the following event by looking at the event for the next episode for this woman.
if (caseid = lag(caseid)) ev905  = lag(ev902).
if (caseid = lag(caseid)) ev905x = lag(ev901a).
* re sort back into order.
sort cases by caseid ev004(a).
execute.


*PART 8.

*--------------------------------------------------*
Label the events file variables
---------------------------------------------------*.

*label the event file variables and values.
variable labels ev902  "Event code".
variable labels ev903  "Discontinuation code".
variable labels ev904  "Prior event code".
variable labels ev904x "Duration of prior event".
variable labels ev905  "Next event code".
variable labels ev905x "Duration of next event".
value labels ev902 ev904 ev905
 0 "No method used" 
 1 "Pill" 
 2 "IUD" 
 3 "Injectable" 
 4 "Diaphragm" 
 5 "Condom" 
 6 "Female sterilization" 
 7 "Male sterilization" 
 8 "Periodic abstinence/Rhythm" 
 9 "Withdrawal" 
10 "Other traditional methods" 
11 "Norplant" 
12 "Abstinence" 
13 "Lactational amenorrhea method" 
14 "Female condom"
15 "Foam and Jelly" 
16 "Emergency contraception" 
17 "Other modern method" 
18 "Standard days method" 
81 "Birth" 
82 "Termination" 
83 "Pregnancy" 
99 "Missing" 
 -1 "***Unknown code not recoded***".
value labels ev903
 0 "No discontinuation" 
 1 "Became pregnant while using" 
 2 "Wanted to become pregnant" 
 3 "Husband disapproved" 
 4 "Side effects" 
 5 "Health concerns" 
 6 "Access/availability" 
 7 "Wanted more effective method" 
 8 "Inconvenient to use" 
 9 "Infrequent sex/husband away" 
10 "Cost" 
11 "Fatalistic" 
12 "Difficult to get pregnant/menopause" 
13 "Marital dissolution" 
96 "Other" 
98 "Don't know" 
99 "Missing" 
-1 "***Unknown code not recoded***".
formats  ev901a ev902 ev903 ev904 ev904x ev905 ev905x (f2.0).

*PART 9.

*---------------------------------------------------*
Convert marriage codes (ev906a) to numeric (ev906),
if marriage code exists
*---------------------------------------------------*.
*confirm existence of marriage variable.
begin program.
import spss, spssaux
varList = "ev906a"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "string " + " ".join(undefined) + "(a1)"
  spss.Submit(cmd)
end program.

execute.

compute ev906a_len = length(rtrim(ev906a)).
aggregate
  /outfile = * mode=addvariables overwrite = yes
  /break=
  /ev906a_included=mean(ev906a_len).
recode ev906a_included (1 thru hi = 1)(0 = 0).

* variable exists.
do if ev906a_included = 1.
+ compute ev906 = 7.
+ if ev906a="0" ev906=0.
+ if ev906a="X" ev906=1.
+ if ev906a="?" ev906=9.
+ variable labels ev906a "Married at end of episode (alpha)".
+ variable labels ev906  "Married at end of episode".
+ variable labels ev906 marriage 0 "Not married" 1 "Married" 7 "Unknown code" 9 "Missing".
+ formats ev906 (f1.0).
end if.

*PART 10.
	
*---------------------------------------------------*
Save events file. See begining of do file for list of
created variables.
*---------------------------------------------------*.
*save the events file.
save outfile = "eventsfile.sav".