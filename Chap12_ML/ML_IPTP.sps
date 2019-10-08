* Encoding: windows-1252.
*****************************************************************************************************
Program: 			ML_IPTP.do
Purpose: 			Code malaria IPTP indicators
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Cameron Taylor and Shireen Assaf, , translated to SPSS by Ivana Bjelic
Date last modified: August 31 by Ivana Bjelic
*****************************************************************************************************.

*----------------------------------------------------------------------------
Variables created in this file:
ml_one_iptp		"One or more doses of SP/Fansidar"
ml_two_iptp		"Two or more doses of SP/Fansidar"
ml_three_iptp	"Three or more doses of SP/Fansidar"
----------------------------------------------------------------------------*

*Age of most recent birth.
** To check if survey has b19. If variable doesnt exist, empty variable is created.
begin program.
import spss, spssaux
varList = "b19$01"
createList = set(varList.split())
allvars = set(spssaux.VariableDict().variables)
undefined = createList - allvars
if undefined:
  cmd = "numeric " + " ".join(undefined)
  spss.Submit(cmd)
end program.

execute.

aggregate
  /outfile = * mode=addvariables overwrite=yes
  /break=
  /b19_included=mean(b19$01).
recode b19_included (lo thru hi = 1)(else = 0).

***************************

* if b19 is present and not empty.
do if  b19_included = 1.
    compute age = b19$01.
else.
** if b19 is not present, compute age.
    compute age = v008 - b3$01.
end if.

*1+ doses SP/Fansidar.
do if age<24.
+compute ml_one_iptp=0.
+if m49a$1=1 ml_one_iptp=1.
end if.
variable labels  ml_one_iptp "One or more doses of SP/Fansidar".
value labels ml_one_iptp 0 "No" 1 "Yes".
	
*2+ doses SP/Fansidar.
do if age<24.
+compute ml_two_iptp=0.
+if m49a$1=1 & ml1$1>=2 & ml1$1<=97 ml_two_iptp=1.
end if.
variable labels ml_two_iptp "Two or more doses of SP/Fansidar".
value labels ml_two_iptp 0 "No" 1 "Yes".

*3+ doses SP/Fansidar.
do if age<24.
+compute ml_three_iptp=0.
+if m49a$1=1 & ml1$1>=3 & ml1$1<=97 ml_three_iptp=1.
end if.
variable labels ml_three_iptp "Three or more doses of SP/Fansidar".
value labels ml_three_iptp 0 "No" 1 "Yes".
