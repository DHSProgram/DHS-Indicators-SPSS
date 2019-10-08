* Encoding: windows-1252.
*****************************************************************************************************
 * Program: 			RH_age_period_BR.sps
 * Purpose: 			compute the age variable and set the period for the analysis
 * Author:			Shireen Assaf and translated to SPSS by Ivana Bjelic
 * Date last modified: 07/16/2019 by Ivana Bjelic

 * Notes: 				Choose reference period to select last 2 years or last 5 years
 					Using the a period of the last 2 years will not match final report but would provide more recent information.
 * 					The PNC indicator is always reported for the last 2 years before the survey. Therefore, 
					the period for this indicator was set as 24 in the PNC do files.
*****************************************************************************************************.

* choose reference period, last 2 years or last 5 years.
*compute period = 24.
compute period = 60.

** To check if survey has b19. If variable doesnt exist, empty variable is created.
begin program.
import spss, spssaux
varList = "b19"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables
  /break=
  /b19_included=mean(b19).
recode b19_included (lo thru hi = 1)(else = 0).

***************************

* BR file variables.
* if b19 is present and not empty.
do if  b19_included = 1.
    compute age = b19.
else.
** if b19 is not present, compute age.
    compute age = v008 - b3.
end if.




