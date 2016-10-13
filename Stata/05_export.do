/* Prepare stata out for matlab */ 


reshape long 
rename *_ *
sort HHID PN wave

#delimit ; 
keep if wave ==8 | wave==10 ;


keep 
	HHID PN wave
	SRH Pworse ctpt 
	/* X */
	MFFL1 MFFL2 MFFL3 MFFL4 MFFL5 MFFL6 MFFL7 MFFL8 MFFL9
	ADL IADL 
	heart hbp stroke diabetes lung arthritis cancer psych
	smokev smoken drinkm drinkh cog CESD 
	bmi_over bmi_obese 
	/* Z */
	female black hisp married lwealthmean edu_hs edu_col age 
	/* path */
	path
	;

order
	HHID PN wave
	SRH Pworse ctpt 
	/* X */
	MFFL1 MFFL2 MFFL3 MFFL4 MFFL5 MFFL6 MFFL7 MFFL8 MFFL9
	ADL IADL 
	heart hbp stroke diabetes lung arthritis cancer psych
	smokev smoken drinkm drinkh cog CESD 
	bmi_over bmi_obese
	/* Z */
	female black hisp married lwealthmean edu_hs edu_col age 
	/* H* */
	path
	;

#delimit cr 
rename * *_
rename wave_ wave
rename HHID_ HHID
rename PN_ PN

reshape wide *_, i(HHID PN) j(wave)
drop ctpt_10 Pworse_10
drop path_10

/* this line shouldn't do anything, these people would have been picked out already */
drop if missing(SRH_8)| missing(SRH_10) |missing(Pworse_8) 
drop path_8
/*
encode path_8, gen(path2_8)	
tab path2_8,gen(pathdum)
forvalue i=1/11{ /*1 to 11 if use everyone */
	gen Pworse`i' = Pworse_8 *pathdum`i'
}
drop path*
*/
/*
#delimit;
local FYShealth
	MFFL1_8 MFFL2_8 MFFL3_8 MFFL4_8 MFFL5_8 MFFL6_8 MFFL7_8 MFFL8_8 MFFL9_8
	ADL_8 IADL_8 
	heart_8 hbp_8 stroke_8 diabetes_8 lung_8 arthritis_8 cancer_8 psych_8
	smokev_8 smoken_8 drinkm_8 drinkh_8 cog_8 CESD_8
	bmi_over_8 bmi_obese_8;
local demo female black hisp married lwealthmean edu_hs edu_col age_8 ;
	
oprobit SRH_8 `FYShealth' `demo';
*/

dropmiss, obs any force /* drop any obs with missing obersvations */
/* drop to 6,500 */
/* may come back and look at how to input cog score with nn to add in another 1,600 obs */


order HHID PN  Pworse_8 ctpt_8 SRH_8 SRH_10

replace Pworse_8 = 0.01 if Pworse_8<=0.01
replace Pworse_8 = 0.99 if Pworse_8>=0.99 & !missing(Pworse_8)

save data/matlab_input.dta, replace
cd "Q:\U\fyshao\HRS Health Expectations\Matlab\"
export delimited using "matlab_input", nolabel replace
cd "Q:\U\fyshao\HRS Health Expectations\STATA\"

/*
cd "Q:\U\fyshao\JMP\STATA\"
/*
keep HHID PN Pworse_8 ctpt_8 SRH_8 SRH_10 heart_8 cogscore_8 cogscore_10 heart_10 age_8 age_10
order HHID PN Pworse_8 ctpt_8 SRH_8 SRH_10
export delimited using "matlab_input_toy", nolabel replace


