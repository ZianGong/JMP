/* Take HRS RAND file
Make long-shaped file to append to my own dataset 
Variables to grab
totwealth
finwealth 
income



*/

use "V:\LIBRARY\Contrib\RAND\RandHrsO\Stata\rndhrs_o.dta", clear

#delimit;
keep hhidpn hhid pn *iearn *atotw *atotf *drink *drinkd *drinkn *issdi *isret *ipena *smoke*;

/*
mmerge hhidpn using "V:\LIBRARY\Contrib\RAND\RandFamily\stata\rndfamr_c.dta", 
ukeep(*dieill);
*/
save "data/randsmall.dta", replace;


#delimit;
use "data/randsmall.dta", clear;
keep hhidpn hhid pn *7* *8* *9* *10* *11* ;
drop s*;
forvalues i=7/11{;
	rename r`i'* *`i';
	rename h`i'* *`i';
};

#delimit;
reshape long smokev smoken drink drinkd drinkn atotw atotf iearn ipena issdi isret,
 i(hhidpn) j(wave);

rename hhid HHID;
rename pn PN;
sort HHID PN wave;

save "data/RAND_HRS_small_long.dta", replace;
