/*******************************************************************************
	Exploring health shocks in the HRS 
	Feiya Shao
	Last updated: 6/23/2016
	MASTER DO FILE
*******************************************************************************/

clear all
cap close all
set more off
cd "Q:\U\fyshao\HRS Health Expectations\STATA\"

/* SECTION 00: Grab all necessary variables from HRS Core Surveys */

do 00_Compile.do

/****  Sample screen **************
- only keep those not retired in 2006
- note: screen has to be done in wide so that if conditions are not fulfiled,
all waves of data for R is dropped. 
*****************************************/
keep if KINSAMP==1 /* in 2006 sample */

keep if KPROXY==5 /* only Non-proxy core interviews kept */
drop if KNURSHM==1 /*drop those in nursing home */  
drop KNURSHM KPROXY  KINSAMP /*EXDEATHYR*/
/*
**keep if EXDEATHYR >2010 /*still alive in 2010 */
keep if KPROXY==5 | EXDEATHYR<=2010;
replace health_10 = 6 if EXDEATHYR<=2010;
*/
save data/HRSaug_raw.dta, replace

use data/HRSaug_raw.dta, clear
/* append RAND measures for income and wealth (for now) */
mmerge HHID PN wave using data/RAND_HRS_small_long.dta
keep if _merge==3 | _merge==1
drop _merge


/* append RAND measures for cognition */
mmerge HHID PN wave using data/cogimpt.dta
keep if _merge==3 | _merge==1
drop _merge


save data/HRS_RAND_aug_raw_long.dta, replace

/* SECTION 01: Clean variables in long format */
use data/HRS_RAND_aug_raw_long.dta, clear
qui do 01_cleandemographics_v2.do
qui do 01_cleanhealth_v3.do
qui do 01_cleanexpectations_v2.do
qui do 01_cleanlabor_v3.do
qui do 01_cleaninsurance_v2.do
qui do 01_cleanattitude.do 
qui do 01_cleanparent.do
qui do 01_cleanRAND.do
/*
	do 01_cleanwealth.do	
	do 01_cleanconsumption.do
*/
save data/HRS_RAND_clean_long.dta, replace

use data/HRS_RAND_clean_long.dta, clear


/* reshape to wide for wave-consistent demographics */ 
rename * *_
rename wave_ wave
rename HHID_ HHID
rename PN_ PN
rename black_ black 
rename hisp_ hisp
rename married_ married
rename female_ female
rename edu_hs_ edu_hs
rename edu_col_ edu_col
rename EXDEATHYR_ deathyr

reshape wide *_, i(HHID PN) j(wave)
/* drop the messy demos that didn't clean properly */

/* sample selection again - only keep those aged 50 to 67 in 2006. */ 
keep if age_8>=50 & age_8<=67 /* age screen */
tab deathyr,m 
keep if deathyr >2010  /* also only keep those alive in 2010 */
drop deathyr 
/* require answering all the most important questions */
keep if SRH_8<=5 & SRH_10<=5
keep if Pbetter_8<=1 
keep if labpart_8<=1 & labpart_10<=1

/* construct wave-consistent demographics */
do 03_wide_processing.do

save data/HRSaug_wide.dta, replace



use data/HRSaug_wide.dta, clear

/* no longer using stata to make the health proxies 
do 03_constructhealth.do
save data/HRSaug_health.dta, replace
*/

/*Export to matlab */
do 05_export.do

/******** this point onwards, re-run */
/*Import from matlab */
import delimited using "Q:\U\fyshao\HRS Health Expectations\Matlab\matlabout_0719.csv", asfloat clear
rename v1 HHID
rename v2 PN
rename v3 health_lat_8
rename v4 health_lat_10
rename v5 Ehealth
rename v6 Ehealth_notheta


/* matlab messes up the string identifiers and drops digits. add back */
tostring(HHID), replace 
tostring(PN), replace
replace PN = "0"+PN
gen len = strlen(HHID)

replace HHID = "0" + HHID if len==5
replace HHID = "0000" + HHID if len==2

drop len
save data/Matlabout_0719.dta, replace


/* Merge */
use data/HRSaug_wide.dta, clear

*mmerge HHID PN using "Q:\U\fyshao\HRS health expectations\STATA\data\Matlabout_old(Feb 21).dta"
mmerge HHID PN using "data/Matlabout_0719.dta"
keep if _merge==3
drop _merge

save data/HRS_finaluse_wide.dta, replace

use data/HRS_finaluse_wide.dta, clear
/*
/* SECTION 02: Construct health shocks */
do 04_constructshock.do

drop if group_8=="952"
drop if group_8=="953"
drop if group_8=="954"
drop if group_8=="942"
drop if group_8=="943"
drop if group_8=="932"
