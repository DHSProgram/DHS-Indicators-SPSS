* Encoding: UTF-8.
*****************************************************************************************************
Program: 			PH_GINI.sps
Purpose: 			Code to compute the Gini coefficient
Data inputs: 		PR dataset
Data outputs:		coded variables
Author:				Tom Pullum, modified by Shireen Assaf for this project, translated to SPSS by Ivana Bjelic
Date last modified: July 28, 2020 by Ivana Bjelic
Note:				This program will collapse the data and export the results to a table called Table_gini.xls
			         The programs below contain many notes to describe how the Gini coefficient was computed. 

*****************************************************************************************************.

* EXECUTION BEGINS HERE

* It can happen that the hh head (hv101=1) is not de jure and it can happen that no one in the household
* is de jure (hv012=0).

* cases  is like the number of people in a wealth category   
* assets is like the amount of wealth in that wealth category 
* category is a categorization of cases, ordered by wealth; could be quintiles or deciles or percentiles.
* In the DHS calculation for Table 2.6 the full range of hv271 scores is broken into 100 intervals that
* have equal width but do not include equal numbers of cases, i.e. they are not percentiles.
* It can happen that some intervals are empty, especially for sub populations, but this would not affect the calculation.
* The categories could be numbered low to high or high to low. Makes no difference, except in the sign of the coefficient,
* and we always take the absolute value of the coefficient.

* This version uses the PR file but then reduces to just the household head and multiplies the weight by hv012.

* The "keep" line is outside the subprograms because it must include any special identifiers for regions in Table 2.6.

get file =  datapath + "\"+ prdata + ".sav"/keep hv005 hv012 hv024 hv025 hv101 hv270 hv271.

* prepare data.

* Keep one case per household (e.g. hvidx=1 or hv101=1 or hvidx=hv003) in households with at least one de jure member.
select if hv101=1 & hv012>0.

* Distribution of hv270 and n, match the report.
* compute iweight=hv012*hv005/1000000.
* weight by iweight.
* frequencies variables hv270.

* Can construct the wealth quintiles (this will match hv270 exactly), using the de jure total.
* rank variables=hv271 (a) /ntiles (5) /print=no /ties=mean.
* However, use hv270, which is already constructed

* Each household has hv012 de jure members.
compute cases=hv012*hv005/1000000.

save outfile =  datapath + "\PR_temp_gini.sav".

***************************************************************************************

define calc_gini (backvar = !tokens(1)).

get file =  datapath + "\PR_temp_gini.sav".

* Create total variable.
!if (!backvar=total) !then
compute total = 1.
variable labels total 'Total'.
value labels total 1 'Total'.
!ifend. 

* Can get the distribution of the wealth quintiles at this point if desired.
* Save however desired.
* compute iweight=hv012*hv005/1000000.
* weight by iweight.
* descriptives variables = hv270.

aggregate outfile = * mode = addvariables overwrite = yes
/break !backvar
/minG=min(hv271)
/maxG=max(hv271).

* The formula in the Guide is incomplete and has unbalanced parentheses: ((hv271-min)/((max-min)/(n-1))+1.
* Instead calculate with "trunc". Note that these intervals are not percentiles. They are equal-width intervals. 

compute category=1+trunc(99*(hv271-minG)/(maxG-minG)).

* The following command would give percentiles but that's not what DHS uses.
* compute pweight=hv012*hv005.
* weight by pweight.
* rank variables=hv271 (a) /ntiles (100) /print=no /ties=mean.

* IMPORTANT! The assets for the household are weighted by hv005 but not multiplied by the number of household members.
compute assets=(hv271-minG)*hv005/1000000.
aggregate outfile = * mode = addvariables overwrite = yes
/break = category !backvar
/cases=sum(cases)
/assets=sum(assets)
.

* Note: some categories may be empty; best to renumber them; must be certain they are in sequence.
sort cases by category.
compute newCategory = 1.
do if (category <> lag(category)).
+ compute newCategory = lag(newCategory)+1.
else.
+ compute newCategory = lag(newCategory).
end if.

aggregate outfile = datapath + "\PR_temp_gini2.sav"
/break newCategory !backvar
/cases=mean(cases)
/assets=mean(assets)
/ncats=max(newCategory)
.

get file = datapath + "\PR_temp_gini2.sav".

sort cases by !backvar newCategory.

aggregate outfile = * mode=addvariables overwrite=yes
/break !backvar
/totcases=sum(cases)
/totassests=sum(assets).

* Calculate the DHS version of the Gini but with proportions rather than difference of cumulative proportions
* for the first factor in the product. 
* calculate proportions.
compute cases_prop = cases/totcases.
compute assets_prop = assets/totassests.

* Calculate cumulative proportions for cases and assets. 
do if newCategory=1.
+compute cases_cumprop = cases_prop.
+compute assets_cumprop = assets_prop.
+compute term=cases_prop*assets_cumprop.
else.
do if (!backvar = lag(!backvar)).
+ compute cases_cumprop = cases_prop + lag(cases_cumprop).
+ compute assets_cumprop = assets_prop + lag(assets_cumprop).
+compute term=cases_prop*(lag(assets_cumprop)+assets_cumprop).
*+compute term2=(cases_cumprop-lag(cases_cumprop))*(assets_cumprop+lag(assets_cumprop)).
end if.
end if.

* term is the base times the mean height (x2) for each trapezoid under the diagonal. The factor of 2 washes out
* because the Gini is defined in terms of half the area in the square, i.e. the area under the diagonal.
* The width or base of each trapezoid is the proportion of the cases in the interval.
* Empty intervals would have no impact on the sum.
aggregate outfile=* mode = addvariables overwrite = yes
/break !backvar
/term=sum(term).

compute Gini=abs(1-term).

!if (!backvar=total) !then
aggregate outfile=datapath + "\tempRes.sav"
 /break !backvar
 /Gini=mean(Gini).
execute.
!else
aggregate outfile=datapath + "\tempBack.sav"
 /break !backvar
 /Gini=mean(Gini).
execute.
!ifend.

!if (!backvar<>total) !then
get file=datapath + "\tempRes.sav".
add files
  /file=*
  /file=datapath + "\tempBack.sav".
save outfile=datapath + "\tempRes.sav".
execute.
!ifend.

new file.

!enddefine.

***************************************************************************************
* Calculate gini.

calc_gini backvar=total.

calc_gini backvar=HV025.

calc_gini backvar=HV024.

get file =  datapath + "\tempRes.sav".

string survey (a4).
compute survey = "NG7A".

variable labels gini "Gini coefficient".
***************************************************************************************
***************************************************************************************

* Exporting results.

* Show results.
ctables
/table total [c] + hv025 [c] + hv024 [c] by gini [s][mean,'',f5.2]
/titles title="Gini coefficient".

*crosstabs total hv025 hv024 by gini.

****************************************************
* Export Output.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Table_gini.xls"
     operation=createfile.

output close * .

new file.

*erase temporary files.
erase file = datapath + "\tempRes.sav".
erase file = datapath + "\PR_temp_gini.sav".
erase file = datapath + "\PR_temp_gini2.sav".
erase file = datapath + "\tempBack.sav".
