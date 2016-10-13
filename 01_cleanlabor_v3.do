/* 01_cleanlabor.do 
Clear labor participation variables. */

forvalues i=1/7{
	gen J005_O`i' = 1 if J005M1==`i'
	foreach var in J005M2 J005M3 J005M4 J005M5{
		replace J005_O`i'=1 if `var'==`i'
		}
	}
sort HHID PN wave 
gen labpart=0 if Z134[_n+1]==1
replace labpart=0 if J705==1
replace labpart=0 if J005_O4==1 | J005_O5==1 | J005_O6==1
replace labpart=1 if J005_O1==1 | J005_O2==1 | J005_O3==1 /* participating supercedes not participating */
replace labpart=1 if Z134[_n+1]==5 & HHID== HHID[_n+1] & PN==PN[_n+1]


/* hours worked*/
gen hrswork = J172 if J172<98
replace hrswork = hrswork + J556 if J556<98
/* replace hrswork = 0 if labpart==0*/ 
replace hrswork = 80 if hrswork>80 & !missing(hrswork)

**reg dhours dhealth_10
**reg dhours shock 

gen work4pay=(J020==1)

drop J*
