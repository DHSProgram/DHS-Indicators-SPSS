* Encoding: windows-1252.
*********************************************************************
Program: 			improvedwater_pr.sps
Purpose: 			creates variable for binary improved water source according to JSTOR standard 
Data inputs: 		pr
Data outputs:		none
Author of do file:	04/08/2018	Courtney Allen
Date last modified:    09/03/2019 by Ivana Bjelic                                                           
                                                                                          04/16/2018	Courtney Allen to use filename var
					01/28/2019	Courtney Allen included most recent surveys
**********************************************************************/

*
*-This do file can be run on any loop of countries indicating the dataset name 
with `c'. 
*-Code should be same for pr or hr files (must replace all 'pr' with 'pr').
*-computeerates two variables:
	Variable 1 - watersource (the standard DHS-7 recode for water source)
		11	 piped into dwelling
		12	 piped to yard/plot
		13	 public tap/standpipe
		14	 piped to neighbor
		15	 piped outside of yard/lot
		21	 tube well or borehole
		30	 well - protection unspecified
		31	 protected well
		32	 unprotected well
		40	 spring - protection unspecified
		41	 protected spring
		42	 unprotected spring
		43	 surface water (river/dam/lake/pond/stream/canal/irrigation channel)
		51	 rainwater
		61	 tanker truck
		62	 cart with small tank
		63	 cistern
		64	 water in drums/cans
		65	 purchased water
		71	 bottled water
		72	 purified water, filtration plant
		73	 satchet water
		96	 other
	
*	Variable 2 - waterimprove (binary variable for improved/unimproved water source according to JMP) 
		0-unimproved 
			30	 well - protection unspecified	
			32	 unprotected well
			40	 spring - protection unspecified
			42	 unprotected spring
			43	 surface water (river/dam/lake/pond/stream/canal/irrigation channel)
			96	 other	
		1-improved
			11	 piped into dwelling
			12	 piped to yard/plot
			13	 public tap/standpipe
			14	 piped to neighbor
			15	 piped outside of yard/lot
			21	 tube well or borehole
			31	 protected well
			41	 protected spring
			51	 rainwater
			61	 tanker truck	
			62	 cart with small tank	
			63	 cistern	
			64	 water in drums/cans	
			65	 purchased water	
			71	 bottled water
			72	 purified water, filtration plant
			73	 satchet water

*create var to computeerate filename.

string filename (A6).
compute filename = substr(filename,1,6).

********************************************************************************
*FIRST CREATE STANDARD CODES FOR ALL SURVEYS
********************************************************************************

*SPSS Code.
do if filename= "afpr70".
recode hv201
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "alpr50".
compute watersource = hv201.
end if.
do if filename= "alpr71".
recode hv201 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "ampr42".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "ampr54".
recode hv201 
21 = 32 
32 = 41 
41 = 43 
(else = copy) into watersource.
end if.
do if filename= "ampr61".
recode hv201 
14 = 11 
(else = copy) into watersource.
end if.
do if filename= "ampr72".
recode hv201 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "aopr51".
compute watersource = hv201.
end if.
do if filename= "aopr62".
compute watersource = hv201.
end if.
do if filename= "aopr71".
recode hv201 
13 = 14 
14 = 13 
33 = 21 
63 = 62 
(else = copy) into watersource.
end if.
do if filename= "azpr52".
compute watersource = hv201.
end if.
do if filename= "bdpr31".
recode hv201 
22 = 32 
31 = 43 
32 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "bdpr3a".
recode hv201 
22 = 32 
31 = 43 
32 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "bdpr41".
recode hv201 
22 = 32 
31 = 43 
32 = 43 
(else = copy) into watersource.
end if.
do if filename= "bdpr4j".
recode hv201 
22 = 32 
23 = 31 
24 = 32 
41 = 43 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "bdpr51".
compute watersource = hv201.
end if.
do if filename= "bdpr61".
compute watersource = hv201.
end if.
do if filename= "bdpr72".
compute watersource = hv201.
end if.
do if filename= "bfpr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "bfpr31".
recode hv201 
12 = 11 
21 = 30 
22 = 30 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
51 = 71 
61 = 65 
(else = copy) into watersource.
end if.
do if filename= "bfpr43".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "bfpr62".
compute watersource = hv201.
end if.
do if filename= "bfpr70".
compute watersource = hv201.
end if.
do if filename= "bjpr31".
recode hv201 
22 = 31 
23 = 32 
31 = 41 
32 = 43 
41 = 51 
42 = 51 
(else = copy) into watersource.
end if.
do if filename= "bjpr41".
recode hv201 
22 = 31 
23 = 32 
41 = 40 
42 = 43 
52 = 51 
(else = copy) into watersource.
end if.
do if filename= "bjpr51".
recode hv201 
52 = 51 
(else = copy) into watersource.
end if.
do if filename= "bjpr61".
compute watersource = hv201.
end if.
do if filename= "bopr31".
recode hv201 
12 = 13 
13 = 14 
21 = 30 
32 = 43 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "bopr3b".
recode hv201 
13 = 15 
21 = 30 
31 = 43 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "bopr41".
recode hv201 
13 = 15 
22 = 32 
42 = 43 
45 = 14 
(else = copy) into watersource.
end if.
do if filename= "bopr51".
recode hv201 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "brpr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "brpr31".
recode hv201 
21 = 30 
22 = 30 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "bupr61".
compute watersource = hv201.
end if.
do if filename= "bupr6h".
compute watersource = hv201.
end if.
do if filename= "bupr70".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "cdpr50".
recode hv201 
32 = 31 
33 = 31 
34 = 32 
35 = 32 
36 = 32 
44 = 43 
45 = 43 
(else = copy) into watersource.
end if.
do if filename= "cdpr61".
compute watersource = hv201.
end if.
do if filename= "cfpr31".
recode hv201 
11 = 12 
12 = 13 
21 = 30 
22 = 30 
23 = 30 
31 = 40 
32 = 43 
33 = 43 
(else = copy) into watersource.
end if.
do if filename= "cgpr51".
recode hv201 
13 = 14 
21 = 32 
22 = 32 
32 = 31 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "cgpr5h".
compute watersource = hv201.
end if.
do if filename= "cgpr60".
compute watersource = hv201.
end if.
do if filename= "cipr35".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "cipr3a".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "cipr50".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
42 = 40 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "cipr62".
compute watersource = hv201.
end if.
do if filename= "cmpr22".
recode hv201 
13 = 14 
14 = 13 
22 = 32 
31 = 43 
41 = 51 
51 = 96 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "cmpr31".
recode hv201 
13 = 14 
14 = 13 
22 = 32 
31 = 43 
41 = 51 
51 = 65 
(else = copy) into watersource.
end if.
do if filename= "cmpr44".
recode hv201 
13 = 14 
14 = 15 
22 = 32 
31 = 32 
41 = 43 
42 = 41 
(else = copy) into watersource.
end if.
do if filename= "cmpr61".
compute watersource = hv201.
end if.
do if filename= "copr22".
recode hv201 
12 = 11 
13 = 15 
14 = 13 
21 = 30 
31 = 43 
41 = 51 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "copr31".
recode hv201 
12 = 11 
13 = 15 
14 = 13 
21 = 30 
31 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "copr41".
recode hv201 
12 = 11 
21 = 30 
41 = 43 
(else = copy) into watersource.
end if.
do if filename= "copr53".
recode hv201 
12 = 11 
22 = 32 
42 = 43 
62 = 64 
(else = copy) into watersource.
end if.
do if filename= "copr61".
recode hv201 
12 = 11 
22 = 32 
42 = 43 
62 = 64 
(else = copy) into watersource.
end if.
do if filename= "copr72".
recode hv201 
12 = 11 
22 = 32 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "drpr21".
recode hv201 
21 = 30 
31 = 43 
41 = 51 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "drpr32".
recode hv201 
21 = 30 
31 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "drpr41".
recode hv201 
22 = 32 
23 = 32 
25 = 31 
26 = 31 
31 = 40 
32 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "drpr4a".
recode hv201 
21 = 30 
41 = 43 
(else = copy) into watersource.
end if.
do if filename= "drpr52".
compute watersource = hv201.
end if.
do if filename= "drpr5a".
compute watersource = hv201.
end if.
do if filename= "drpr61".
compute watersource = hv201.
end if.
do if filename= "drpr6a".
compute watersource = hv201.
end if.
do if filename= "egpr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 43 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "egpr33".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 43 
(else = copy) into watersource.
end if.
do if filename= "egpr42".
recode hv201 
21 = 30 
22 = 30 
23 = 30 
31 = 30 
32 = 30 
33 = 30 
41 = 43 
72 = 65 
(else = copy) into watersource.
end if.
do if filename= "egpr4a".
recode hv201 
21 = 30 
22 = 30 
23 = 30 
31 = 30 
32 = 30 
33 = 30 
41 = 43 
(else = copy) into watersource.
end if.
do if filename= "egpr51".
recode hv201 
21 = 32 
22 = 42 
31 = 21 
32 = 31 
33 = 41 
41 = 43 
(else = copy) into watersource.
end if.
do if filename= "egpr5a".
compute watersource = hv201.
end if.
do if filename= "egpr61".
compute watersource = hv201.
end if.
do if filename= "etpr41".
recode hv201 
13 = 15 
21 = 32 
22 = 42 
23 = 31 
24 = 41 
31 = 43 
32 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "etpr51".
recode hv201 
13 = 15 
21 = 32 
22 = 42 
31 = 21 
32 = 31 
33 = 41 
41 = 43 
(else = copy) into watersource.
end if.
do if filename= "etpr61".
compute watersource = hv201.
end if.
do if filename= "etpr70".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "gapr41".
recode hv201 
11 = 12 
12 = 13 
21 = 31 
22 = 31 
23 = 32 
24 = 32 
31 = 40 
32 = 43 
33 = 43 
41 = 51 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "gapr60".
recode hv201 
32 = 31 
33 = 32 
34 = 32 
(else = copy) into watersource.
end if.
do if filename= "ghpr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
35 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "ghpr41".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
35 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "ghpr4b".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
81 = 73 
(else = copy) into watersource.
end if.
do if filename= "ghpr5a".
recode hv201 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "ghpr72".
recode hv201 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "ghpr7b".
recode hv201 
13 = 14 
14 = 13 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "gmpr60".
compute watersource = hv201.
end if.
do if filename= "gnpr41".
recode hv201 
21 = 30 
22 = 30 
31 = 41 
32 = 42 
33 = 43 
34 = 43 
35 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "gnpr52".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
34 = 21 
44 = 43 
45 = 43 
(else = copy) into watersource.
end if.
do if filename= "gnpr62".
compute watersource = hv201.
end if.
do if filename= "gupr34".
recode hv201 
11 = 13 
12 = 13 
13 = 15 
22 = 30 
32 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "gupr41".
recode hv201 
11 = 13 
12 = 13 
13 = 15 
14 = 13 
21 = 30 
31 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "gupr71".
recode hv201 
14 = 15 
31 = 13 
32 = 30 
41 = 43 
42 = 43 
43 = 41 
44 = 42 
(else = copy) into watersource.
end if.
do if filename= "gypr51".
recode hv201 
22 = 32 
81 = 43 
91 = 62 
92 = 72 
(else = copy) into watersource.
end if.
do if filename= "gypr5i".
compute watersource = hv201.
end if.
do if filename= "hnpr52".
recode hv201 
13 = 11 
14 = 11 
21 = 32 
31 = 30 
32 = 21 
41 = 43 
62 = 13 
(else = copy) into watersource.
end if.
do if filename= "hnpr62".
recode hv201 
13 = 11 
14 = 11 
31 = 30 
44 = 13 
45 = 43 
(else = copy) into watersource.
end if.
do if filename= "htpr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
35 = 43 
41 = 51 
51 = 61 
52 = 65 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "htpr42".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 30 
32 = 30 
44 = 43 
45 = 43 
81 = 65 
(else = copy) into watersource.
end if.
do if filename= "htpr52".
recode hv201 
63 = 43 
64 = 65 
(else = copy) into watersource.
end if.
do if filename= "htpr61".
recode hv201 
13 = 14 
14 = 13 
32 = 31 
33 = 32 
34 = 32 
72 = 65 
(else = copy) into watersource.
end if.
do if filename= "htpr70".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "iapr23".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
24 = 21 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "iapr42".
recode hv201 
11 = 12 
12 = 13 
22 = 21 
23 = 30 
24 = 32 
25 = 31 
26 = 32 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "iapr52".
compute watersource = hv201.
end if.
do if filename= "iapr74".
compute watersource = hv201.
end if.
do if filename= "idpr21".
recode hv201 
22 = 30 
31 = 40 
32 = 43 
41 = 51 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "idpr31".
recode hv201 
22 = 31 
23 = 32 
31 = 41 
32 = 42 
33 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "idpr3a".
recode hv201 
22 = 31 
23 = 32 
31 = 41 
32 = 42 
33 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "idpr42".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "idpr51".
recode hv201 
33 = 32 
34 = 32 
35 = 32 
36 = 31 
37 = 31 
38 = 31 
44 = 40 
45 = 43 
46 = 43 
47 = 43 
(else = copy) into watersource.
end if.
do if filename= "idpr63".
recode hv201 
33 = 32 
34 = 32 
35 = 32 
36 = 31 
37 = 31 
38 = 31 
44 = 40 
45 = 43 
46 = 43 
47 = 43 
81 = 72 
(else = copy) into watersource.
end if.
do if filename= "jopr21".
compute watersource = hv201.
end if.
do if filename= "jopr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "jopr42".
recode hv201 
41 = 40 
(else = copy) into watersource.
end if.
do if filename= "jopr51".
compute watersource = hv201.
end if.
do if filename= "jopr61".
compute watersource = hv201.
end if.
do if filename= "jopr6c".
compute watersource = hv201.
end if.
do if filename= "kepr33".
recode hv201 
12 = 13 
22 = 32 
31 = 43 
32 = 43 
41 = 51 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "kepr3a".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 43 
32 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "kepr42".
recode hv201 
21 = 32 
22 = 32 
32 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "kepr52".
compute watersource = hv201.
end if.
do if filename= "kepr71".
compute watersource = hv201.
end if.
do if filename= "kepr7a".
recode hv201 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "kepr7h".
recode hv201 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "khpr42".
recode hv201 
11 = 12 
12 = 13 
21 = 32 
22 = 32 
32 = 31 
33 = 21 
34 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "khpr51".
compute watersource = hv201.
end if.
do if filename= "khpr61".
compute watersource = hv201.
end if.
do if filename= "khpr73".
compute watersource = hv201.
end if.
do if filename= "kkpr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "kkpr42".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
24 = 43 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "kmpr32".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
41 = 51 
42 = 51 
(else = copy) into watersource.
end if.
do if filename= "kmpr61".
compute watersource = hv201.
end if.
do if filename= "kypr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "kypr61".
compute watersource = hv201.
end if.
do if filename= "lbpr51".
compute watersource = hv201.
end if.
do if filename= "lbpr5a".
compute watersource = hv201.
end if.
do if filename= "lbpr61".
compute watersource = hv201.
end if.
do if filename= "lbpr6a".
compute watersource = hv201.
end if.
do if filename= "lbpr70".
recode hv201 
13 = 14 
14 = 13 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "lspr41".
recode hv201 
13 = 14 
14 = 13 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
34 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "lspr61".
recode hv201 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "lspr71".
compute watersource = hv201.
end if.
do if filename= "mapr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "mapr43".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "mbpr53".
recode hv201 
62 = 63 
63 = 62 
81 = 41 
82 = 42 
(else = copy) into watersource.
end if.
do if filename= "mdpr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "mdpr31".
recode hv201 
22 = 30 
23 = 32 
24 = 21 
25 = 30 
26 = 32 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "mdpr42".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "mdpr51".
compute watersource = hv201.
end if.
do if filename= "mdpr61".
compute watersource = hv201.
end if.
do if filename= "mdpr6h".
compute watersource = hv201.
end if.
do if filename= "mdpr71".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "mlpr32".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "mlpr41".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "mlpr53".
compute watersource = hv201.
end if.
do if filename= "mlpr60".
compute watersource = hv201.
end if.
do if filename= "mlpr6a".
compute watersource = hv201.
end if.
do if filename= "mlpr70".
compute watersource = hv201.
end if.
do if filename= "mmpr71".
recode hv201 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "mvpr52".
recode hv201 
52 = 51 
(else = copy) into watersource.
end if.
do if filename= "mvpr71".
recode hv201 
14 = 13 
52 = 51 
(else = copy) into watersource.
end if.
do if filename= "mwpr22".
recode hv201 
12 = 13 
13 = 12 
22 = 30 
23 = 31 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
(else = copy) into watersource.
end if.
do if filename= "mwpr41".
recode hv201 
21 = 32 
32 = 21 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "mwpr4e".
recode hv201 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "mwpr61".
compute watersource = hv201.
end if.
do if filename= "mwpr6h".
compute watersource = hv201.
end if.
do if filename= "mwpr71".
compute watersource = hv201.
end if.
do if filename= "mwpr7h".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "mwpr7i".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "mzpr31".
recode hv201 
12 = 14 
21 = 30 
22 = 30 
23 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "mzpr41".
recode hv201 
11 = 12 
12 = 14 
21 = 12 
22 = 14 
23 = 32 
41 = 43 
(else = copy) into watersource.
end if.
do if filename= "mzpr51".
compute watersource = hv201.
end if.
do if filename= "mzpr62".
recode hv201 
33 = 21 
(else = copy) into watersource.
end if.
do if filename= "mzpr71".
recode hv201 
33 = 21 
(else = copy) into watersource.
end if.
do if filename= "ncpr31".
recode hv201 
21 = 30 
22 = 30 
31 = 43 
32 = 40 
41 = 51 
61 = 65 
(else = copy) into watersource.
end if.
do if filename= "ncpr41".
recode hv201 
31 = 30 
32 = 30 
41 = 43 
42 = 40 
61 = 72 
(else = copy) into watersource.
end if.
do if filename= "ngpr21".
compute watersource = hv201.
end if.
do if filename= "ngpr41".
recode hv201 
11 = 12 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
52 = 61 
61 = 71 
71 = 21 
(else = copy) into watersource.
end if.
do if filename= "ngpr4b".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
62 = 65 
(else = copy) into watersource.
end if.
do if filename= "ngpr53".
compute watersource = hv201.
end if.
do if filename= "ngpr61".
recode hv201 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "ngpr6a".
recode hv201 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "ngpr71".
recode hv201 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "nipr22".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "nipr31".
recode hv201 
12 = 13 
21 = 30 
22 = 31 
23 = 32 
24 = 32 
25 = 21 
31 = 40 
32 = 43 
33 = 43 
41 = 51 
51 = 62 
(else = copy) into watersource.
end if.
do if filename= "nipr51".
recode hv201 
41 = 40 
(else = copy) into watersource.
end if.
do if filename= "nipr61".
recode hv201 
63 = 65 
(else = copy) into watersource.
end if.
do if filename= "nmpr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
35 = 21 
41 = 51 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "nmpr41".
recode hv201 
21 = 32 
22 = 42 
31 = 21 
32 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "nmpr51".
compute watersource = hv201.
end if.
do if filename= "nmpr61".
compute watersource = hv201.
end if.
do if filename= "nppr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
24 = 21 
31 = 40 
32 = 43 
34 = 41 
(else = copy) into watersource.
end if.
do if filename= "nppr41".
recode hv201 
11 = 12 
12 = 13 
21 = 30 
22 = 30 
31 = 21 
32 = 21 
41 = 40 
42 = 43 
43 = 41 
(else = copy) into watersource.
end if.
do if filename= "nppr51".
recode hv201 
44 = 41 
(else = copy) into watersource.
end if.
do if filename= "nppr60".
recode hv201 
44 = 41 
(else = copy) into watersource.
end if.
do if filename= "nppr7h".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "pepr21".
recode hv201 
12 = 13 
13 = 12 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
41 = 51 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "pepr31".
recode hv201 
12 = 11 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "pepr41".
recode hv201 
21 = 30 
22 = 30 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "pepr51".
recode hv201 
21 = 30 
22 = 30 
41 = 40 
(else = copy) into watersource.
end if.
do if filename= "pepr5i".
recode hv201 
21 = 30 
22 = 30 
41 = 40 
(else = copy) into watersource.
end if.
do if filename= "pepr61".
recode hv201 
21 = 30 
22 = 30 
41 = 40 
(else = copy) into watersource.
end if.
do if filename= "pepr6a".
recode hv201 
21 = 30 
22 = 30 
41 = 40 
(else = copy) into watersource.
end if.
do if filename= "pepr6i".
recode hv201 
21 = 30 
22 = 30 
41 = 40 
(else = copy) into watersource.
end if.
do if filename= "phpr31".
recode hv201 
12 = 13 
21 = 11 
22 = 12 
23 = 30 
24 = 30 
31 = 32 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "phpr3b".
recode hv201 
21 = 31 
22 = 32 
31 = 41 
32 = 42 
33 = 43 
34 = 43 
35 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "phpr41".
recode hv201 
21 = 32 
(else = copy) into watersource.
end if.
do if filename= "phpr52".
recode hv201 
33 = 32 
72 = 14 
73 = 14 
(else = copy) into watersource.
end if.
do if filename= "phpr61".
recode hv201 
33 = 32 
(else = copy) into watersource.
end if.
do if filename= "phpr70".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "pkpr21".
recode hv201 
12 = 13 
13 = 12 
23 = 21 
24 = 32 
32 = 43 
41 = 51 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "pkpr52".
recode hv201 
22 = 21 
(else = copy) into watersource.
end if.
do if filename= "pkpr61".
recode hv201 
22 = 21 
63 = 72 
(else = copy) into watersource.
end if.
do if filename= "pkpr71".
recode hv201 
13 = 14 
14 = 13 
63 = 72 
(else = copy) into watersource.
end if.
do if filename= "pypr21".
compute watersource = hv201.
end if.
do if filename= "rwpr21".
recode hv201 
12 = 13 
13 = 12 
23 = 21 
24 = 21 
31 = 40 
32 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "rwpr41".
recode hv201 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "rwpr53".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "rwpr5a".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "rwpr61".
compute watersource = hv201.
end if.
do if filename= "rwpr6q".
compute watersource = hv201.
end if.
do if filename= "rwpr70".
compute watersource = hv201.
end if.
do if filename= "rwpr7a".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "slpr51".
compute watersource = hv201.
end if.
do if filename= "slpr61".
compute watersource = hv201.
end if.
do if filename= "slpr71".
recode hv201 
13 = 14 
14 = 13 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "snpr21".
recode hv201 
11 = 12 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "snpr32".
recode hv201 
11 = 12 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "snpr4h".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "snpr50".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "snpr5h".
compute watersource = hv201.
end if.
do if filename= "snpr61".
compute watersource = hv201.
end if.
do if filename= "snpr6d".
compute watersource = hv201.
end if.
do if filename= "snpr6r".
compute watersource = hv201.
end if.
do if filename= "snpr70".
compute watersource = hv201.
end if.
do if filename= "snpr7h".
compute watersource = hv201.
end if.
do if filename= "snpr7i".
compute watersource = hv201.
end if.
do if filename= "snpr7z".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "snprg0".
compute watersource = hv201.
end if.
do if filename= "stpr50".
compute watersource = hv201.
end if.
do if filename= "szpr51".
compute watersource = hv201.
end if.
do if filename= "tdpr31".
recode hv201 
12 = 13 
21 = 32 
22 = 31 
23 = 32 
24 = 31 
31 = 43 
32 = 43 
41 = 51 
51 = 61 
61 = 65 
(else = copy) into watersource.
end if.
do if filename= "tdpr41".
recode hv201 
11 = 12 
12 = 13 
21 = 32 
22 = 32 
32 = 31 
44 = 43 
52 = 65 
53 = 65 
54 = 65 
55 = 65 
(else = copy) into watersource.
end if.
do if filename= "tdpr71".
compute watersource = hv201.
end if.
do if filename= "tgpr31".
recode hv201 
12 = 14 
22 = 31 
23 = 32 
31 = 41 
32 = 43 
41 = 51 
42 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "tgpr61".
recode hv201 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "tgpr71".
recode hv201 
13 = 14 
14 = 13 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "tjpr61".
compute watersource = hv201.
end if.
do if filename= "tjpr70".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "tlpr61".
compute watersource = hv201.
end if.
do if filename= "tlpr71".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "trpr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
42 = 43 
51 = 61 
61 = 71 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "trpr41".
recode hv201 
11 = 12 
12 = 13 
21 = 30 
22 = 30 
31 = 41 
32 = 40 
33 = 43 
41 = 51 
51 = 61 
61 = 71 
71 = 72 
(else = copy) into watersource.
end if.
do if filename= "trpr4a".
recode hv201 
11 = 12 
21 = 30 
31 = 30 
42 = 40 
81 = 72 
(else = copy) into watersource.
end if.
do if filename= "tzpr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
35 = 43 
41 = 51 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "tzpr3a".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "tzpr41".
recode hv201 
21 = 32 
22 = 31 
23 = 21 
31 = 41 
32 = 42 
33 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "tzpr4a".
recode hv201 
21 = 32 
32 = 21 
44 = 43 
45 = 43 
(else = copy) into watersource.
end if.
do if filename= "tzpr4i".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
24 = 32 
32 = 31 
33 = 31 
34 = 21 
41 = 40 
42 = 43 
44 = 43 
62 = 65 
(else = copy) into watersource.
end if.
do if filename= "tzpr51".
recode hv201 
21 = 32 
22 = 32 
23 = 32 
24 = 32 
32 = 31 
33 = 31 
34 = 21 
42 = 43 
44 = 43 
62 = 65 
91 = 62 
(else = copy) into watersource.
end if.
do if filename= "tzpr63".
recode hv201 
22 = 32 
23 = 32 
24 = 32 
25 = 32 
33 = 31 
34 = 31 
35 = 31 
36 = 21 
45 = 40 
(else = copy) into watersource.
end if.
do if filename= "tzpr6a".
compute watersource = hv201.
end if.
do if filename= "tzpr7a".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "tzpr7q".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "uapr51".
compute watersource = hv201.
end if.
do if filename= "ugpr33".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
34 = 41 
41 = 51 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "ugpr41".
recode hv201 
21 = 32 
22 = 32 
32 = 31 
33 = 21 
34 = 21 
41 = 40 
42 = 43 
44 = 43 
81 = 41 
(else = copy) into watersource.
end if.
do if filename= "ugpr52".
recode hv201 
22 = 21 
23 = 21 
33 = 31 
34 = 31 
35 = 32 
36 = 32 
44 = 43 
45 = 43 
46 = 43 
91 = 41 
(else = copy) into watersource.
end if.
do if filename= "ugpr5h".
recode hv201 
22 = 32 
23 = 32 
33 = 31 
34 = 31 
35 = 21 
44 = 43 
45 = 43 
46 = 43 
(else = copy) into watersource.
end if.
do if filename= "ugpr60".
recode hv201 
22 = 21 
23 = 21 
33 = 31 
34 = 31 
35 = 32 
36 = 32 
44 = 43 
45 = 43 
46 = 43 
(else = copy) into watersource.
end if.
do if filename= "ugpr6a".
recode hv201 
81 = 41 
(else = copy) into watersource.
end if.
do if filename= "ugpr72".
recode hv201 
22 = 21 
44 = 41 
63 = 62 
(else = copy) into watersource.
end if.
do if filename= "ugpr7a".
recode hv201 
13 = 14 
14 = 13 
63 = 62 
72 = 73 
(else = copy) into watersource.
end if.
do if filename= "uzpr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "vnpr31".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "vnpr41".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
34 = 43 
41 = 51 
51 = 61 
(else = copy) into watersource.
end if.
do if filename= "vnpr52".
recode hv201 
11 = 12 
12 = 13 
31 = 30 
32 = 30 
41 = 40 
42 = 43 
44 = 43 
(else = copy) into watersource.
end if.
do if filename= "yepr21".
recode hv201 
13 = 11 
14 = 12 
23 = 21 
24 = 32 
32 = 43 
35 = 51 
36 = 43 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "yepr61".
recode hv201 
14 = 72 
15 = 72 
32 = 30 
43 = 40 
44 = 41 
45 = 43 
72 = 64 
(else = copy) into watersource.
end if.
do if filename= "zapr31".
recode hv201 
31 = 43 
41 = 51 
51 = 61 
61 = 71 
(else = copy) into watersource.
end if.
do if filename= "zapr71".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "zmpr21".
recode hv201 
12 = 13 
21 = 30 
22 = 30 
31 = 40 
32 = 43 
33 = 43 
51 = 61 
71 = 96 
(else = copy) into watersource.
end if.
do if filename= "zmpr31".
recode hv201 
12 = 13 
21 = 30 
22 = 32 
23 = 32 
24 = 21 
31 = 40 
32 = 43 
33 = 43 
(else = copy) into watersource.
end if.
do if filename= "zmpr42".
recode hv201 
22 = 32 
23 = 32 
24 = 32 
32 = 31 
33 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource.
end if.
do if filename= "zmpr51".
compute watersource = hv201.
end if.
do if filename= "zmpr61".
compute watersource = hv201.
end if.
do if filename= "zwpr31".
recode hv201 
12 = 13 
21 = 31 
22 = 32 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
(else = copy) into watersource.
end if.
do if filename= "zwpr42".
recode hv201 
21 = 31 
22 = 32 
23 = 21 
31 = 40 
32 = 43 
33 = 43 
41 = 51 
(else = copy) into watersource.
end if.
do if filename= "zwpr52".
recode hv201 
71 = 62 
81 = 43 
(else = copy) into watersource.
end if.
do if filename= "zwpr62".
compute watersource = hv201.
end if.
do if filename= "zwpr71".
recode hv201 
13 = 14 
14 = 13 
(else = copy) into watersource.
end if.
do if filename= "khpr42".
recode sh22b 
11 = 12 
12 = 13 
21 = 32 
22 = 32 
32 = 31 
33 = 21 
34 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource_wet.
end if.
do if filename= "khpr42".
recode hv201 
11 = 12 
12 = 13 
21 = 32 
22 = 32 
32 = 31 
33 = 21 
34 = 31 
41 = 40 
42 = 43 
(else = copy) into watersource_dry.
end if.
do if filename= "khpr51".
compute watersource_wet = hv201w
end if.
do if filename= "khpr51".
compute watersource_dry = hv201d.
end if.
do if filename= "khpr61".
compute watersource_wet = sh104b.
end if.
do if filename= "khpr61".
compute watersource_dry = sh102.
end if.
do if filename= "khpr73".
compute watersource_wet = sh104b.
end if.
do if filename= "khpr73".
compute watersource_dry = sh102.
end if.

do if filename= "khpr42" | "`c'"= "khpr51" |"`c'"= "khpr61" | "`c'"= "khpr73".
recode hv006 (11 thru 12, 2 thru 4=1) (5 thru 10=2) into interview_season.
variable labels interview_season "interview season".
value labels interview_season 1  "dry season" 2 "rainy season".
*dry season interviews.
if interview_season= 1 watersource = watersource_dry.
*rainy season interviews.
if interview_season= 2  watersource = watersource_wet.
end if.


********************************************************************************
*CREATE LABELS AND CLEAN WATER VARIABLE
********************************************************************************


value labels  watersource 	11               "piped into dwelling"	
			12	 "piped to yard/plot" 	
			13	 "public tap/standpipe" 
			14	 "piped to neighbor"	
			15	 "piped outside of yard/lot" 
			21	 "tube well or borehole" 
			30	 "well - protection unspecified" 
			31	 "protected well" 		
			32	 "unprotected well"		
			40	 "spring - protection unspecified" 
			41	 "protected spring" 	
			42	 "unprotected spring"	
			43	 "surface water (river/dam/lake/pond/stream/canal/irrigation channel)" 
			51	 "rainwater"			
			61	 "tanker truck"			
			62	 "cart with small tank" 
			63	 "cistern"				
			64	 "water in drums/cans"  
			65	 "purchased water"		
			71	 "bottled water"		
		                  72	 "purified water, filtration plant" 
			73	 "satchet water"		
			96	 "other".	

*only for dejure.
do if hv102=1.
recode watersource (11 thru 15, 21, 31, 41, 51, 61 thru 73 = 1) (30, 32, 40, 42, 43, 96 = 0) (99=sysmis) into waterimprove.
end if.

variable labels waterimprove "Improved Water Source".
value labels waterimprove 1 "improved water" 2 "unimproved/surface water".






