/* file to grab imputed cognition scores from file */ 

use "V:\LIBRARY\Xwave\CogImp\Built\stata\COGIMP9212A_R.dta", clear

keep HHID PN R7SER7 R8SER7 R9SER7 R10SER7 R11SER7 R7TR20 R8TR20 R9TR20 R10TR20 R11TR20 

forvalues i=7/11{
	gen cog`i' = R`i'SER7 + R`i'TR20
}

reshape long cog, i(HHID PN) j(wave)

save "Q:\U\fyshao\HRS Health Expectations\STATA\data\cogimpt.dta", replace
