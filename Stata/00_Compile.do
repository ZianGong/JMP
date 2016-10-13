/**** Compile Long dataset *************
Last updated: 11/17/2014
Feiya Shao

Program Outline:
Section A: Pulling variables from raw HRS dataset
	1. Collect raw variables from each wave of HRS
	2. Append waves 8-10 to create auxillary dataset
	3. Merge aux dataset onto stanford dataset using HHID PN wave

****************************************/
#delimit ;

/******************************************************************************
	Wave 7: HRS 2004 
******************************************************************************/
/*expectations module*/

use "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04P_R.dta"; 
keep HHID PN *P017 *P018 *P028 ;
rename JP* P*;

/*health module*/
mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04C_R.dta",
	ukeep(*C001 *C005 *C009 *C010 *C016 *C019 *C020 *C023 *C024 *C030 *C031 *C036 *C037 *C038 *C039 *C040 *C048 *C051 *C052 *C053 *C055 *C062 *C065 *C066 *C229 *C082 *C070 *C139 *C141 *C142 *C104 );
rename JC* C*;

/*cognition module*/
mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04D_R.dta", 
	ukeep(*D110 *D111 *D112 *D113 *D114 *D115 *D116 *D117 *D118);
rename JD* D*;


mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04G_R.dta", 
	ukeep(*G001 *G003 *G004 *G005 *G006 *G007 *G008 *G009 *G010 *G011 *G012 *G014 *G016 *G021 *G023 *G025 *G030 *G040 *G041 *G042 *G044 *G045 *G047 *G048 *G050 *G051 *G052 *G058 *G059 *G060);
rename JG* G*;

/*healthcare module */
mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04N_R.dta", 
	ukeep(*N001 *N006 *N007 *N023 *N033* *N034* *N035* *N036* *N039* *N048* *N049* *N059* *N060* *N062* *N063*);
rename JN* N*;

/*family history */
mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04F_R.dta", 
	ukeep(*F001 *F002 *F009 *F011 *F012 *F019);
rename JF* F*;

/*preloads*/
mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04PR_R.dta",
	ukeep(*X060_R *X065_R  *X060_R *Z123 *Z124 *Z134 );
rename *_R *;
rename JX* X*;
rename JZ* Z*;

/* current job */
mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04J_R.dta",
	ukeep(*J005* *J017 *J018 *J020 *J703 *J705 *J172 *J236 *J556);
rename JJ* J*;

/* leave behind questionaire */

mmerge HHID PN using "V:\LIBRARY\2004hrs\Final\Core\built\stata\H04LB_R.dta",
	ukeep(JLB506N JLB506O JLB506P JLB506Q JLB506R JLB506S);
rename JLB506N LB019F;
rename JLB506O LB019G;
rename JLB506P LB019H;
rename JLB506Q LB019I;
rename JLB506R LB019J;
rename JLB506S LB019K;

gen wave=7;
drop _merge*;
save data/HRSwave7.dta, replace;

/******************************************************************************
	Wave 8: HRS 2006 
******************************************************************************/
/*expectations module*/
use "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06P_R.dta"; 
keep HHID PN *P017 *P018 *P028 KP108 KP109 *P070 *P034 *P110;
rename KP* P*;

/*health module*/
mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06C_R.dta", 
	ukeep(*C001 *C005 *C009 *C010 *C016 *C019 *C020 *C023 *C024 *C030 *C031 *C036 *C037 *C038 *C039 *C040 *C048 *C051 *C052 *C053 *C055 *C062 *C065 *C066 *C229 *C082 *C070 *C139 *C141 *C142 *C104);
rename KC* C*;


/*cognition module*/
mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06D_R.dta", 
	ukeep(*D110 *D111 *D112 *D113 *D114 *D115 *D116 *D117 *D118);
rename KD* D*;


mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06G_R.dta", 
	ukeep(*G001 *G003 *G004 *G005 *G006 *G007 *G008 *G009 *G010 *G011 *G012 *G014 *G016 *G021 *G023 *G025 *G030 *G040 *G041 *G042 *G044 *G045 *G047 *G048 *G050 *G051 *G052 *G058 *G059 *G060);
rename KG* G*;

/*healthcare module */
mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06N_R.dta", 
	ukeep(*N001 *N006 *N007 *N023 *N033* *N034* *N035* *N036* *N039* *N048* *N049* *N059* *N060* *N062* *N063*);
rename KN* N*;

/*preloads*/
mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06PR_R.dta",
	ukeep(KX502_R  KX511_R KX508_R KX506_R KX507_R *X060_R 
		KX065_R  KX060_R KZ123 KZ124 KZ134 );
rename *_R *;
rename KX* X*;
rename KZ* Z*;

/* current job */
mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06J_R.dta",
	ukeep(KJ005* KJ017 KJ018 KJ020 KJ703 KJ705 *J172 *J236 *J556);
rename KJ* J*;

/*family history */
mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06F_R.dta", 
	ukeep(*F001 *F002 *F009 *F011 *F012 *F019);
rename KF* F*;

/* leave behind questionaire */
mmerge HHID PN using "V:\LIBRARY\2006hrs\Final\Core\built\stata\H06LB_R.dta",
	ukeep(*LB019F *LB019G *LB019H *LB019I *LB019J *LB019K );
rename KLB* LB*;


gen wave=8;
drop _merge*;
save data/HRSwave8.dta, replace;

/******************************************************************************
	Wave 9: HRS 2008 
******************************************************************************/
use "V:\LIBRARY\2008hrs\Final\Core\Built\stata\H08P_R.dta";
keep HHID PN LP017 LP018 LP028 LP108 LP109 LP070 *P034 *P110;
rename LP* P*;

mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\Built\stata\H08C_R.dta",	
ukeep(*C001 *C005 *C009 *C010 *C016 *C019 *C020 *C023 *C024 *C030 *C031 *C036 *C037 *C038 *C039 *C040 *C048 *C051 *C052 *C053 *C055 *C062 *C065 *C066 *C229 *C082 *C070 *C139 *C141 *C142 *C104);	
rename LC* C*;

mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\built\stata\H08G_R.dta", 
	ukeep(*G001 *G003 *G004 *G005 *G006 *G007 *G008 *G009 *G010 *G011 *G012 *G014 *G016 *G021 *G023 *G025 *G030 *G040 *G041 *G042 *G044 *G045 *G047 *G048 *G050 *G051 *G052 *G058 *G059 *G060);
rename LG* G*;

/*healthcare module */
mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\built\stata\H08N_R.dta", 
	ukeep(*N001 *N006 *N007 *N023 *N033* *N034* *N035* *N036* *N039* *N048* *N049* *N059* *N060* *N062* *N063*);
rename LN* N*;

/*cognition module*/
mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\built\stata\H08D_R.dta", 
	ukeep(*D110 *D111 *D112 *D113 *D114 *D115 *D116 *D117 *D118);
rename LD* D*;


mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\built\stata\H08PR_R.dta",
	ukeep(LX502_R  LX511_R LX508_R LX506_R LX507_R *X060_R 
	LX065_R  LX060_R LZ123 LZ124 LZ134);
rename *_R *;
rename LX* X*;
rename LZ* Z*;

mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\built\stata\H08J_R.dta",
	ukeep(LJ005* LJ017 LJ018 LJ020 LJ703 LJ705 *J172 *J236 *J556);
rename LJ* J*;

/*family history */
mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\built\stata\H08F_R.dta", 
	ukeep(*F001 *F002 *F009 *F011 *F012 *F019);
rename LF* F*;

/* leave behind questionaire */
mmerge HHID PN using "V:\LIBRARY\2008hrs\Final\Core\built\stata\H08LB_R.dta",
	ukeep(*LB019F *LB019G *LB019H *LB019I *LB019J *LB019K );
rename LLB* LB*;


gen wave=9;
drop _merge*;
save data/HRSwave9.dta, replace;

/******************************************************************************
	Wave 10: HRS 2010 
******************************************************************************/
use "V:\LIBRARY\2010hrs\Final\Core\Built\stata\H10P_R.dta";
keep HHID PN MP017 MP018 MP028 ;
rename MP* P*;

mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\Built\stata\H10C_R.dta",
	ukeep(*C001 *C005 *C009 *C010 *C016 *C019 *C020 *C023 *C024 *C030 *C031 *C036 *C037 *C038 *C039 *C040 *C048 *C051 *C052 *C053 *C055 *C062 *C065 *C066 *C229 *C082 *C070 *C139 *C141 *C142 *C104 *C272 *C273);
rename MC* C*;

mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\built\stata\H10G_R.dta", 
	ukeep(*G001 *G003 *G004 *G005 *G006 *G007 *G008 *G009 *G010 *G011 *G012 *G014 *G016 *G021 *G023 *G025 *G030 *G040 *G041 *G042 *G044 *G045 *G047 *G048 *G050 *G051 *G052 *G058 *G059 *G060);
rename MG* G*;

/*healthcare module */
mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\built\stata\H10N_R.dta", 
	ukeep(*N001 *N006 *N007 *N023 *N033* *N034* *N035* *N036* *N039* *N048* *N049* *N059* *N060* *N062* *N063*);
rename MN* N*;

/*cognition module*/
mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\built\stata\H10D_R.dta", 
	ukeep(*D110 *D111 *D112 *D113 *D114 *D115 *D116 *D117 *D118);
rename MD* D*;


mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\Built\stata\H10PR_R.dta",
	ukeep( MX065_R  MX060_R MZ123 MZ124 MZ134 *X060_R );
rename *_R *;
rename MX* X*;
rename MZ* Z*;

mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\built\stata\H10J_R.dta",
	ukeep(MJ005* MJ017 MJ018 MJ020 MJ703 MJ705 *J172 *J236 *J556);
rename MJ* J*;

/*family history */
mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\built\stata\H10F_R.dta", 
	ukeep(*F001 *F002 *F009 *F011 *F012 *F019);
rename MF* F*;

/* leave behind questionaire */
mmerge HHID PN using "V:\LIBRARY\2010hrs\Final\Core\built\stata\H10LB_R.dta",
	ukeep(*LB019F *LB019G *LB019H *LB019I *LB019J *LB019K );
rename MLB* LB*;


drop _merge*;
gen wave=10;
save data/HRSwave10.dta, replace;


/******************************************************************************
	Wave 11: HRS 2012
******************************************************************************/
#delimit;
use "V:\LIBRARY\2012hrs\Final\Core\Built\stata\H12P_R.dta";
keep HHID PN *P017 *P018 *P028 ;
rename NP* P*;

mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\Built\stata\H12C_R.dta",
	ukeep(*C001 *C005 *C009 *C010 *C016 *C019 *C020 *C023 *C024 *C030 *C031 *C036 *C037 *C038 *C039 *C040 *C048 *C051 *C052 *C053 *C055 *C062 *C065 *C066 *C229 *C082 *C070 *C139 *C141 *C142 *C104 *C272 *C273);
rename NC* C*;


/*cognition module*/
mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\built\stata\H12D_R.dta", 
	ukeep(*D110 *D111 *D112 *D113 *D114 *D115 *D116 *D117 *D118);
rename ND* D*;


mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\built\stata\H12G_R.dta", 
	ukeep(*G001 *G003 *G004 *G005 *G006 *G007 *G008 *G009 *G010 *G011 *G012 *G014 *G016 *G021 *G023 *G025 *G030 *G040 *G041 *G042 *G044 *G045 *G047 *G048 *G050 *G051 *G052 *G058 *G059 *G060);
rename NG* G*;

/*healthcare module */
mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\built\stata\H12N_R.dta", 
	ukeep(*N001 *N006 *N007 *N023 *N033* *N034* *N035* *N036* *N039* *N048* *N049* *N059* *N060* *N062* *N063*);
rename NN* N*;

mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\Built\stata\H12PR_R.dta",
	ukeep( *X065_R  *X060_R *Z123 *Z124 *Z134 *X060_R );
rename *_R *;
rename NX* X*;
rename NZ* Z*;

mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\built\stata\H12J_R.dta",
	ukeep(*J005* *J017 *J018 *J020 *J703 *J705 *J172 *J236 *J556);
rename NJ* J*;

/*family history */
mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\built\stata\H12F_R.dta", 
	ukeep(*F001 *F002 *F009 *F011 *F012 *F019);
rename NF* F*;

/* leave behind questionaire */
mmerge HHID PN using "V:\LIBRARY\2012hrs\Final\Core\built\stata\H12LB_R.dta",
	ukeep(*LB019F *LB019G *LB019H *LB019I *LB019J *LB019K );
rename NLB* LB*;

drop _merge*;
gen wave=11;
save data/HRSwave11.dta, replace;


/******************************************************************************
/* A.2 Append all waves to create dataset */
******************************************************************************/

#delimit;
clear; 
use  data/HRSwave7.dta;
forvalues i=8/11{;
	append using data/HRSwave`i'.dta;
};
mmerge HHID PN using "V:\LIBRARY\Tracker\Trk2014\Built\stata\TRK2014TR_R.dta",
 ukeep(EXDEATHYR BIRTHYR RACE HISPANIC GENDER SCHLYRS KINSAMP KPROXY KNURSHM KMARST);
/*MINSAMP MPROXY */
keep if _merge==3;
drop _merge;
