* Encoding: windows-1252.
**********************************************************************
program: 			improvedtoilet_allcountries.sps
Purpose: 			creates variable for binary improved sanitation according to JSTOR standard 
Data inputs: 		pr file
Data outputs:		none
Author of do file:	03/15/2018	Courtney Allen
Date last moddo ified:         09/03/2019 by Ivana Bjelic                                                          
                                                                                          04/16/2018	Courtney Allen - to use a filename var
					05/08/2018	Courtney Allen - to use new codes 10, 15, 16
					01/28/2019 	Courtney Allen - includes all new surveys
**********************************************************************.

*
*-This do file can be run on any loop of countries indicating the dataset name 
with `c'. 
*-Code should be same for pr or pr files (must replace all 'pr' with 'pr').
*-computeerates two variables:
	Variable 1 - toilet (the standard DHS-7 recode for water source)
		10	 improved but shared toilet
		11	 flush - to piped sewer system
		12	 flush - to septic tank
		13	 flush - to pit latrine
		14	 flush - to somewhere else
		15	 flush - don't know where		
		16               flush - unspecdo ified		
		20               pit latrine - improved but shared
		21	 pit latrine - ventilated improved pit (vip)
		22	 pit latrine - with slab
		23	 pit latrine - without slab / open pit
		31	 no facility/bush/field
		41	 composting toilet
		42	 bucket toilet
		43	 hanging toilet/latrine
		44	 river/stream/sea/pond/lake
		51	 other improved
		96	 other
							
	
*	Variable 2 - toiletimprove (binary variable for improved/unimproved water source according to JMP) 
		0-unimproved 
			10   improved but shared toilet
			14	 flush - to somewhere else
			15   flush - don't know where
			20   pit latrine - improved but shared
			23	 pit latrine - without slab / open pit
			31	 no facility/bush/field
			42	 bucket toilet
			43	 hanging toilet/latrine
			44	 river/stream/sea/pond/lake
			96	 other
		1-improved
			11	 flush - to piped sewer system
			12	 flush - to septic tank
			13	 flush - to pit latrine
			16	 flush - unspecdo ified
			21	 pit latrine - ventilated improved pit (vip)
			22	 pit latrine - with slab
			41	 composting toilet
			51	 other improved


*create var to computeerate filename.
string filename (A6).

compute filename = substr(filename,1,6).

********************************************************************************
*FIRST CREATE STANDARD CODES FOR ALL SURVEYS
********************************************************************************

do if filename="afpr70".
recode hv205 
43 = 23 
44 = 51 
(else = copy) into toilet.
end if.
do if filename="alpr50".
compute toilet = hv205.
end if.
do if filename="alpr71".
compute toilet = hv205.
end if.
do if filename="ampr42".
recode hv205 
11 = 16 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="ampr54".
recode hv205 
41 = 42 
(else = copy) into toilet.
end if.
do if filename="ampr61".
recode hv205 
44 = 96 
(else = copy) into toilet.
end if.
do if filename="ampr72".
compute toilet = hv205.
end if.
do if filename="aopr51".
compute toilet = hv205.
end if.
do if filename="aopr62".
recode hv205 
15 = 16 
(else = copy) into toilet.
end if.
do if filename="aopr71".
recode hv205 
13 = 14 
14 = 11 
15 = 12 
16 = 14 
17 = 11 
18 = 12 
19 = 14 
22 = 21 
24 = 21 
25 = 21 
26 = 43 
27 = 21 
28 = 21 
29 = 43 
42 = 23 
(else = copy) into toilet.
end if.
do if filename="azpr52".
compute toilet = hv205.
end if.
do if filename="bdpr31".
recode hv205 
11 = 12 
21 = 22 
22 = 23 
24 = 43 
(else = copy) into toilet.
end if.
do if filename="bdpr3a".
recode hv205 
11 = 12 
21 = 22 
22 = 23 
24 = 43 
(else = copy) into toilet.
end if.
do if filename="bdpr41".
recode hv205 
11 = 12 
21 = 22 
22 = 23 
24 = 43 
(else = copy) into toilet.
end if.
do if filename="bdpr4j".
recode hv205 
11 = 12 
21 = 22 
22 = 23 
24 = 43 
(else = copy) into toilet.
end if.
do if filename="bdpr51".
compute toilet = hv205.
end if.
do if filename="bdpr61".
compute toilet = hv205.
end if.
do if filename="bdpr72".
compute toilet = hv205.
end if.
do if filename="bfpr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="bfpr31".
recode hv205 
11 = 16 
12 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="bfpr43".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="bfpr62".
compute toilet = hv205.
end if.
do if filename="bfpr70".
compute toilet = hv205.
end if.
do if filename="bjpr31".
recode hv205 
21 = 22 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="bjpr41".
recode hv205 
11 = 16 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="bjpr51".
recode hv205 
15 = 14 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="bjpr61".
compute toilet = hv205.
end if.
do if filename="bopr31".
recode hv205 
11 = 16 
13 = 12 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="bopr3b".
recode hv205 
11 = 16 
12 = 10 
13 = 16 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="bopr41".
recode hv205 
11 = 16 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="bopr51".
compute toilet = hv205.
end if.
do if filename="brpr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="brpr31".
recode hv205 
12 = 14 
13 = 44 
21 = 22 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="bupr61".
compute toilet = hv205.
end if.
do if filename="bupr6h".
recode hv205 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="bupr70".
compute toilet = hv205.
end if.
do if filename="cdpr50".
recode hv205 
11 = 16 
21 = 23 
23 = 21 
(else = copy) into toilet.
end if.
do if filename="cdpr61".
compute toilet = hv205.
end if.
do if filename="cfpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="cgpr51".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="cgpr5h".
recode hv205 
11 = 16 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="cgpr60".
compute toilet = hv205.
end if.
do if filename="cipr35".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
23 = 21 
(else = copy) into toilet.
end if.
do if filename="cipr3a".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="cipr50".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="cipr62".
compute toilet = hv205.
end if.
do if filename="cmpr22".
recode hv205 
11 = 16 
21 = 42 
22 = 23 
32 = 44 
33 = 31 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="cmpr31".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="cmpr44".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="cmpr61".
compute toilet = hv205.
end if.
do if filename="copr22".
recode hv205 
11 = 16 
21 = 23 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="copr31".
recode hv205 
12 = 13 
13 = 14 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="copr41".
recode hv205 
12 = 13 
13 = 14 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="copr53".
recode hv205 
12 = 13 
13 = 14 
21 = 23 
22 = 44 
(else = copy) into toilet.
end if.
do if filename="copr61".
recode hv205 
12 = 13 
13 = 14 
21 = 23 
22 = 44 
(else = copy) into toilet.
end if.
do if filename="copr72".
recode hv205 
12 = 13 
13 = 14 
21 = 23 
22 = 44 
(else = copy) into toilet.
end if.
do if filename="drpr21".
recode hv205 
11 = 16 
12 = 16 
21 = 23 
22 = 23 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="drpr32".
recode hv205 
11 = 16 
12 = 10 
21 = 22 
22 = 23 
23 = 22 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="drpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="drpr4a".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="drpr52".
recode hv205 
11 = 16 
12 = 16 
21 = 22 
22 = 23 
23 = 22 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="drpr5a".
recode hv205 
11 = 16 
12 = 16 
21 = 22 
22 = 23 
23 = 22 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="drpr61".
compute toilet = hv205.
end if.
do if filename="drpr6a".
compute toilet = hv205.
end if.
do if filename="egpr21".
recode hv205 
13 = 22 
14 = 22 
21 = 23 
22 = 23 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="egpr33".
recode hv205 
12 = 22 
13 = 22 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="egpr42".
recode hv205 
12 = 22 
13 = 22 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="egpr4a".
recode hv205 
12 = 22 
13 = 22 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="egpr51".
recode hv205 
13 = 22 
21 = 23 
32 = 42 
(else = copy) into toilet.
end if.
do if filename="egpr5a".
recode hv205 
13 = 22 
(else = copy) into toilet.
end if.
do if filename="egpr61".
recode hv205 
16 = 12 
17 = 11 
18 = 11 
(else = copy) into toilet.
end if.
do if filename="etpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="etpr51".
recode hv205 
24 = 41 
25 = 42 
26 = 43 
(else = copy) into toilet.
end if.
do if filename="etpr61".
compute toilet = hv205.
end if.
do if filename="etpr70".
compute toilet = hv205.
end if.
do if filename="gapr41".
recode hv205 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="gapr60".
compute toilet = hv205.
end if.
do if filename="ghpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="ghpr41".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
23 = 42 
(else = copy) into toilet.
end if.
do if filename="ghpr4b".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
32 = 42 
(else = copy) into toilet.
end if.
do if filename="ghpr5a".
compute toilet = hv205.
end if.
do if filename="ghpr72".
compute toilet = hv205.
end if.
do if filename="ghpr7b".
compute toilet = hv205.
end if.
do if filename="gmpr60".
compute toilet = hv205.
end if.
do if filename="gnpr41".
recode hv205 
11 = 16 
21 = 23 
31 = 23 
41 = 31 
(else = copy) into toilet.
end if.
do if filename="gnpr52".
recode hv205 
11 = 16 
21 = 23 
23 = 21 
(else = copy) into toilet.
end if.
do if filename="gnpr62".
compute toilet = hv205.
end if.
do if filename="gupr34".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="gupr41".
recode hv205 
12 = 11 
13 = 12 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="gupr71".
recode hv205 
13 = 14 
14 = 15 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="gypr51".
recode hv205 
61 = 43 
(else = copy) into toilet.
end if.
do if filename="gypr5i".
compute toilet = hv205.
end if.
do if filename="hnpr52".
recode hv205 
13 = 16 
21 = 51 
22 = 41 
24 = 44 
(else = copy) into toilet.
end if.
do if filename="hnpr62".
recode hv205 
13 = 16 
21 = 51 
22 = 41 
24 = 44 
(else = copy) into toilet.
end if.
do if filename="htpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
23 = 21 
24 = 20 
(else = copy) into toilet.
end if.
do if filename="htpr42".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="htpr52".
recode hv205 
51 = 42 
61 = 43 
(else = copy) into toilet.
end if.
do if filename="htpr61".
recode hv205 
44 = 43 
45 = 51 
(else = copy) into toilet.
end if.
do if filename="htpr70".
compute toilet = hv205
end if.
do if filename="iapr23".
recode hv205 
11 = 16 
12 = 10 
13 = 16 
21 = 23 
22 = 23 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="iapr42".
recode hv205 
11 = 16 
12 = 10 
13 = 16 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="iapr52".
recode hv205 
44 = 23 
(else = copy) into toilet.
end if.
do if filename="iapr74".
recode hv205 
44 = 23 
(else = copy) into toilet.
end if.
do if filename="idpr21".
compute toilet = hv205.
end if.
do if filename="idpr31".
compute toilet = hv205.
end if.
do if filename="idpr3a".
compute toilet = hv205.
end if.
do if filename="idpr42".
recode hv205 
11 = 12 
12 = 14 
21 = 10 
31 = 44 
41 = 23 
51 = 31 
(else = copy) into toilet.
end if.
do if filename="idpr51".
recode hv205 
11 = 12 
12 = 14 
13 = 10 
21 = 23 
32 = 44 
33 = 31 
34 = 44 
35 = 31 
36 = 31 
(else = copy) into toilet.
end if.
do if filename="idpr63".
recode hv205 
11 = 12 
12 = 14 
13 = 10 
21 = 23 
32 = 44 
(else = copy) into toilet.
end if.
do if filename="jopr21".
compute toilet = hv205.
end if.
do if filename="jopr31".
recode hv205 
11 = 16 
12 = 16 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="jopr42".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="jopr51".
recode hv205 
12 = 13 
13 = 14 
(else = copy) into toilet.
end if.
do if filename="jopr61".
recode hv205 
12 = 13 
13 = 14 
(else = copy) into toilet.
end if.
do if filename="jopr6c".
compute toilet = hv205.
end if.
do if filename="kepr33".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="kepr3a".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="kepr42".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="kepr52".
compute toilet = hv205.
end if.
do if filename="kepr71".
compute toilet = hv205.
end if.
do if filename="kepr7a".
compute toilet = hv205.
end if.
do if filename="kepr7h".
compute toilet = hv205.
end if.
do if filename="khpr42".
recode hv205 
11 = 12 
12 = 11 
21 = 22 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="khpr51".
compute toilet = hv205.
end if.
do if filename="khpr61".
compute toilet = hv205.
end if.
do if filename="khpr73".
compute toilet = hv205.
end if.
do if filename="kkpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="kkpr42".
recode hv205 
11 = 16 
21 = 23 
(else = copy) into toilet.
end if.
do if filename="kmpr32".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="kmpr61".
compute toilet = hv205.
end if.
do if filename="kypr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="kypr61".
compute toilet = hv205.
end if.
do if filename="lbpr51".
compute toilet = hv205.
end if.
do if filename="lbpr5a".
compute toilet = hv205.
end if.
do if filename="lbpr61".
compute toilet = hv205.
end if.
do if filename="lbpr6a".
compute toilet = hv205.
end if.
do if filename="lbpr70".
compute toilet = hv205.
end if.
do if filename="lspr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="lspr61".
compute toilet = hv205.
end if.
do if filename="lspr71".
compute toilet = hv205.
end if.
do if filename="mapr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="mapr43".
recode hv205 
11 = 16 
12 = 16 
13 = 96 
21 = 23 
22 = 23 
32 = 42 
(else = copy) into toilet.
end if.
do if filename="mbpr53".
recode hv205 
31 = 41 
41 = 42 
(else = copy) into toilet.
end if.
do if filename="mdpr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
23 = 22 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="mdpr31".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="mdpr42".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="mdpr51".
recode hv205 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="mdpr61".
recode hv205 
23 = 22 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="mdpr6h".
recode hv205 
23 = 22 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="mdpr71".
compute toilet = hv205.
end if.
do if filename="mlpr32".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="mlpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="mlpr53".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="mlpr60".
compute toilet = hv205.
end if.
do if filename="mlpr6a".
compute toilet = hv205.
end if.
do if filename="mlpr70".
compute toilet = hv205.
end if.
do if filename="mmpr71".
compute toilet = hv205.
end if.
do if filename="mvpr52".
compute toilet = hv205.
end if.
do if filename="mvpr71".
compute toilet = hv205.
end if.
do if filename="mwpr22".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="mwpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="mwpr4e".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="mwpr61".
recode hv205 
11 = 16 
(else = copy) into toilet.
end if.
do if filename="mwpr6h".
compute toilet = hv205.
end if.
do if filename="mwpr71".
compute toilet = hv205.
end if.
do if filename="mwpr7h".
compute toilet = hv205.
end if.
do if filename="mwpr7i".
compute toilet = hv205.
end if.
do if filename="mzpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="mzpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 31 
30 = 31 
(else = copy) into toilet.
end if.
do if filename="mzpr51".
compute toilet = hv205.
end if.
do if filename="mzpr62".
recode hv205 
15 = 16 
(else = copy) into toilet.
end if.
do if filename="mzpr71".
recode hv205 
11 = 16 
12 = 16 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="ncpr31".
recode hv205 
15 = 14 
21 = 23 
22 = 21 
24 = 43 
30 = 31 
(else = copy) into toilet.
end if.
do if filename="ncpr41".
recode hv205 
13 = 12 
15 = 14 
21 = 23 
22 = 21 
30 = 31 
32 = 43 
(else = copy) into toilet.
end if.
do if filename="ngpr21".
compute toilet = hv205.
end if.
do if filename="ngpr41".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
23 = 42 
(else = copy) into toilet.
end if.
do if filename="ngpr4b".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
32 = 44 
(else = copy) into toilet.
end if.
do if filename="ngpr53".
compute toilet = hv205.
end if.
do if filename="ngpr61".
compute toilet = hv205.
end if.
do if filename="ngpr6a".
compute toilet = hv205.
end if.
do if filename="ngpr71".
compute toilet = hv205.
end if.
do if filename="nipr22".
recode hv205 
11 = 16 
12 = 10 
13 = 16 
21 = 23 
22 = 21 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="nipr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="nipr51".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="nipr61".
compute toilet = hv205.
end if.
do if filename="nmpr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
23 = 42 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="nmpr41".
recode hv205 
11 = 16 
12 = 22 
21 = 23 
22 = 21 
23 = 42 
(else = copy) into toilet.
end if.
do if filename="nmpr51".
compute toilet = hv205.
end if.
do if filename="nmpr61".
compute toilet = hv205.
end if.
do if filename="nppr31".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
31 = 42 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="nppr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="nppr51".
compute toilet = hv205.
end if.
do if filename="nppr60".
compute toilet = hv205.
end if.
do if filename="nppr7h".
compute toilet = hv205.
end if.
do if filename="pepr21".
recode hv205 
11 = 16 
12 = 10 
23 = 22 
24 = 22 
25 = 23 
26 = 23 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="pepr31".
recode hv205 
11 = 16 
12 = 16 
13 = 16 
14 = 16 
21 = 23 
22 = 23 
31 = 44 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="pepr41".
recode hv205 
11 = 16 
12 = 16 
13 = 16 
14 = 16 
21 = 23 
22 = 23 
30 = 31 
41 = 44 
(else = copy) into toilet.
end if.
do if filename="pepr51".
recode hv205 
11 = 31 
12 = 16 
24 = 43 
31 = 44 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="pepr5i".
recode hv205 
11 = 31 
12 = 16 
24 = 43 
31 = 44 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="pepr61".
recode hv205 
11 = 31 
12 = 16 
24 = 43 
31 = 44 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="pepr6a".
recode hv205 
11 = 31 
12 = 16 
24 = 43 
31 = 44 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="pepr6i".
recode hv205 
11 = 31 
12 = 16 
24 = 43 
31 = 44 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="phpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 23 
24 = 43 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="phpr3b".
recode hv205 
11 = 16 
12 = 10 
21 = 13 
22 = 23 
30 = 31 
31 = 43 
(else = copy) into toilet.
end if.
do if filename="phpr41".
recode hv205 
11 = 16 
12 = 10 
21 = 13 
22 = 23 
31 = 43 
32 = 31 
(else = copy) into toilet.
end if.
do if filename="phpr52".
compute toilet = hv205
end if.
do if filename="phpr61".
recode hv205 
51 = 96 
(else = copy) into toilet.
end if.
do if filename="phpr70".
recode hv205 
71 = 96 
(else = copy) into toilet.
end if.
do if filename="pkpr21".
recode hv205 
13 = 16 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="pkpr52".
recode hv205 
13 = 14 
14 = 15 
(else = copy) into toilet.
end if.
do if filename="pkpr61".
compute toilet = hv205.
end if.
do if filename="pkpr71".
compute toilet = hv205.
end if.
do if filename="pypr21".
compute toilet = hv205.
end if.
do if filename="rwpr21".
recode hv205 
13 = 16 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="rwpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="rwpr53".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="rwpr5a".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="rwpr61".
compute toilet = hv205.
end if.
do if filename="rwpr6q".
compute toilet = hv205.
end if.
do if filename="rwpr70".
compute toilet = hv205.
end if.
do if filename="rwpr7a".
compute toilet = hv205.
end if.
do if filename="slpr51".
recode hv205 
71 = 44 
(else = copy) into toilet.
end if.
do if filename="slpr61".
compute toilet = hv205.
end if.
do if filename="slpr71".
compute toilet = hv205.
end if.
do if filename="snpr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="snpr32".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="snpr4h".
recode hv205 
11 = 16 
12 = 14 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="snpr50".
compute toilet = hv205.
end if.
do if filename="snpr5h".
compute toilet = hv205.
end if.
do if filename="snpr61".
recode hv205 
24 = 51 
26 = 23 
(else = copy) into toilet.
end if.
do if filename="snpr6d".
recode hv205 
24 = 51 
26 = 23 
(else = copy) into toilet.
end if.
do if filename="snpr6r".
recode hv205 
24 = 51 
26 = 23 
(else = copy) into toilet.
end if.
do if filename="snpr70".
recode hv205 
24 = 51 
26 = 23 
(else = copy) into toilet.
end if.
do if filename="snpr7h".
recode hv205 
24 = 51 
26 = 23 
(else = copy) into toilet.
end if.
do if filename="snpr7i".
recode hv205 
24 = 51 
26 = 23 
(else = copy) into toilet.
end if.
do if filename="snpr7z".
compute toilet = hv205.
end if.
do if filename="snprg0".
recode hv205 
24 = 51 
26 = 23 
(else = copy) into toilet.
end if.
do if filename="stpr50".
compute toilet = hv205.
end if.
do if filename="szpr51".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tdpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tdpr41".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tdpr71".
recode hv205 
11 = 12 
12 = 13 
13 = 14 
14 = 15 
(else = copy) into toilet.
end if.
do if filename="tgpr31".
recode hv205 
21 = 22 
22 = 23 
23 = 12 
24 = 22 
(else = copy) into toilet.
end if.
do if filename="tgpr61".
compute toilet = hv205.
end if.
do if filename="tgpr71".
compute toilet = hv205.
end if.
do if filename="tjpr61".
compute toilet = hv205.
end if.
do if filename="tjpr70".
compute toilet = hv205.
end if.
do if filename="tlpr61".
compute toilet = hv205.
end if.
do if filename="tlpr71".
compute toilet = hv205.
end if.
do if filename="trpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 13 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="trpr41".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 13 
(else = copy) into toilet.
end if.
do if filename="trpr4a".
recode hv205 
11 = 16 
21 = 23 
22 = 13 
(else = copy) into toilet.
end if.
do if filename="tzpr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tzpr3a".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tzpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tzpr4a".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tzpr4i".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="tzpr51".
recode hv205 
15 = 16 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="tzpr63".
compute toilet = hv205.
end if.
do if filename="tzpr6a".
recode hv205 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="tzpr7a".
recode hv205 
24 = 23 
(else = copy) into toilet.
end if.
do if filename="tzpr7q".
recode hv205 
24 = 21 
(else = copy) into toilet.
end if.
do if filename="uapr51".
compute toilet = hv205.
end if.
do if filename="ugpr33".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="ugpr41".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="ugpr52".
recode hv205 
11 = 16 
22 = 23 
23 = 22 
24 = 23 
25 = 22 
(else = copy) into toilet.
end if.
do if filename="ugpr5h".
recode hv205 
11 = 16 
22 = 23 
23 = 22 
24 = 23 
25 = 22 
(else = copy) into toilet.
end if.
do if filename="ugpr60".
recode hv205 
11 = 16 
22 = 23 
23 = 22 
24 = 23 
25 = 22 
44 = 51 
(else = copy) into toilet.
end if.
do if filename="ugpr6a".
compute toilet = hv205.
end if.
do if filename="ugpr72".
recode hv205 
24 = 22 
25 = 23 
(else = copy) into toilet.
end if.
do if filename="ugpr7a".
compute toilet = hv205.
end if.
do if filename="uzpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="vnpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="vnpr41".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="vnpr52".
recode hv205 
11 = 16 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="yepr21".
recode hv205 
13 = 11 
14 = 12 
24 = 14 
25 = 23 
26 = 16 
31 = 42 
32 = 31 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="yepr61".
recode hv205 
24 = 23 
25 = 23 
(else = copy) into toilet.
end if.
do if filename="zapr31".
recode hv205 
11 = 16 
12 = 10 
21 = 42 
22 = 23 
(else = copy) into toilet.
end if.
do if filename="zapr71".
recode hv205 
23 = 21 
44 = 51 
(else = copy) into toilet.
end if.
do if filename="zmpr21".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
41 = 96 
(else = copy) into toilet.
end if.
do if filename="zmpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="zmpr42".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="zmpr51".
compute toilet = hv205.
end if.
do if filename="zmpr61".
compute toilet = hv205.
end if.
do if filename="zwpr31".
recode hv205 
11 = 16 
12 = 10 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="zwpr42".
recode hv205 
11 = 16 
21 = 23 
22 = 21 
(else = copy) into toilet.
end if.
do if filename="zwpr52".
recode hv205 
91 = 41 
92 = 42 
(else = copy) into toilet.
end if.
do if filename="zwpr62".
compute toilet = hv205.
end if.
do if filename="zwpr71".
compute toilet = hv205.
end if.

********************************************************************************
*CREATE LABELS AND IMPROVED SANITATION VARIABLE
********************************************************************************

value labels toilet		10	"improved but shared toilet"	
			11	"flush - to piped sewer system" 
			12	"flush - to septic tank"		
			13	"flush - to pit latrine"		
			14	"flush - to somewhere else"	
			15	"flush - don't know where"		
			16               "flush - unspecdo ified"			
			20               "pit latrine - improved but shared" 
			21	 "pit latrine - ventilated improved pit (vip)"	
			22	 "pit latrine - with slab"		
			23	 "pit latrine - without slab / open pit" 
			31	 "no facility/bush/field" 		
			41	 "composting toilet"			
			42	 "bucket toilet"				
			43	 "hanging toilet/latrine"		
			44	 "river/stream/sea/pond/lake"	
			51	 "other improved"				
			96	 "other"	.					


recode toilet (11 thru 13, 16, 21, 22, 41, 51 = 1 "improved toilet") (10, 14, 15, 20, 23, 31, 42 thru 44, 96 = 0 "unimproved") (99=sysmis) into toiletimprove.
recode hv225 (sysmis=0)(9=0)(else=copy).
*shared toilet is not improved.
if hv225=1 toiletimprove = 0.

execute.
delete variables = filename.
