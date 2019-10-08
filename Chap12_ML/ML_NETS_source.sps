* Encoding: windows-1252.
*****************************************************************************************************
Program: 			ML_NETS_source.do
Purpose: 			Code indicators for source of nets
Data inputs: 		HR survey list
Data outputs:		coded variables and the table Tables_Net_Source.xls for the tabulations for the indicators
Author:				Cameron Taylor and modified by Shireen Assaf for the code share project, translated to SPSS by Ivana Bjelic
Date last modified: August 30 2019 by Ivana Bjelic
*****************************************************************************************************/

*----------------------------------------------------------------------------
Variables created in this file:
ml_net_dist		"Received a net from mass distribution, ANC, immunization, or at birth"
ml_net_source	"Source of mosquito net"
----------------------------------------------------------------------------*
*open HR file.
get file =  datapath + "\"+ hrdata + ".sav".

*Reshaping the dataset to a long format to tabulate among nets in household.
varstocases 
/make hml22_ from hml22$1 to hml22$7 
/make hml23_ from hml23$1 to hml23$7.

*Number of mosquito nets.
compute ml_numnet=0.
if hml22_>=0 & hml22_<=99 ml_numnet=1.
variable labels ml_numnet "Number of mosquito nets".

select if (ml_numnet<>0).

*Received a mosquito net obtained from campaign, anc, or immunization.
compute ml_net_dist=0.
if hml22_>=1 ml_net_dist=1.
variable labels ml_net_dist "Received a net from mass distribution, ANC, immunization, or at birth".

*Source of net.
*Note hml23_ can have several country specific categories. Pleace check and adjust the code accordingly. 
*In the code below, several country specific categories were grouped in category 9. 
compute ml_net_source=$sysmis.
if hml23_=11 | hml23_=12 | hml23_=13 ml_net_source=5.
if hml23_>=20 & hml23_<30 ml_net_source=6.
if hml23_=31 ml_net_source=7.
if hml23_=32 ml_net_source=8.
if hml23_ >32 & hml23_ <96 ml_net_source=9.
if hml23_=96 ml_net_source=10.
if hml23_>97 ml_net_source=11.
if hml22_=1 ml_net_source=1.
if hml22_=2 ml_net_source=2.
if hml22_=3 ml_net_source=3.
if hml22_=4 ml_net_source=4.
variable labels ml_net_source "Source of mosquito net".
value labels ml_net_source 
1 "mass distribution campaign" 
2 "ANC visit" 
3 "immunisation visit" 4"at birth" 
5 "gov. facility" 
6 "private facility" 
7 "pharmacy" 
8 "shop/market" 
9 "other country specific" 
10 "other" 
11 "don'tknow/missing".

* Table for source.
compute wt=hv005/1000000.
weight by wt.

*Mosquito nets obtained from mass distribution.
ctables
  /table  hv025 [c] 
         + hv024 [c]
         + hv270 [c] by
         ml_net_source [c] [rowpct.validn '' f5.1] + ml_numnet [s] [sum,'', f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=all total=yes position=after label="Total"
  /slabels visible=no
  /titles title=
    "Mosquito nets obtained from mass distribution".			

*crosstabs 
    /tables = hv025 hv024 hv270 by ml_net_source 
    /format = avalue tables
    /cells = row 
    /count asis.		

* output to excel.
output export
  /contents  export=visible  layers=printsetting  modelviews=printsetting
  /xls  documentfile="Tables_HH_ITN.xls"
     operation=modifysheet  sheet='sheet1'
     location=lastrow.

output close *.

new file.

****************************************************
