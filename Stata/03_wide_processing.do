/* gen optimism */


egen opt_avg = rowmean(opt_index_8 opt_index_9 opt_index_10 opt_index_11)
egen opt_avg2 = rowmean(opt_index2_8 opt_index2_9 opt_index2_10 opt_index2_11)


/* check the parental health history stuff in wide format 
to make sure it makes sense

then reshape back to long to estimate latent health 
then get ready to declare victory yayyy */

/*
/* if parent deceased in wave X, impute for all future waves... */
replace parentdead_11=1 if parentage_11==parentage_10
forvalues i =10(-1)7{
	local j=`i'+1
	replace parentdead_`i'=1 if parentage_`i' == parentage_`j' & parentdead_`i'==.
}

forvalues i=7/11{
	local n =`i'+1
	forvalues j = `n'/11{
		replace parentdead_`j'= 1 if parentdead_`i'==1 & parentdead_`j'==.
		replace parentage_`j' = parentage_`i' if parentdead_`i'==1 
	}
	replace parentalive_`i' = 1-parentdead_`i' if parentalive_`i'==.
}


/* cognitive and vocabulary scores */

forvalues i=7/11{
	egen cogtotsd_`i'=std(cogtot_`i')
	egen vocabsd_`i'=std(vocab_`i')
}
egen cogscore=rowmean(cogtotsd_7 cogtotsd_8 cogtotsd_9 cogtotsd_10 cogtotsd_11)
egen vocabscore=rowmean(vocabsd_7 vocabsd_8 vocabsd_9 vocabsd_10 vocabsd_11)

*egen cesd_avg = rowmean(cesd_7 cesd_8 cesd_9 cesd_10 cesd_11)
drop cogtot_* cogtotsd_*

*/


/* smooth out wealth (these are imputed independently cross wave*/
egen lwealthmean = rowmean(lwealth_7 lwealth_8 lwealth_9 lwealth_10 lwealth_11)
egen lincomemean = rowmean(lincome_7 lincome_8 lincome_9 lincome_10 lincome_11)

/* imputing missing cog scores */ 
replace cog_10 = cog_9 if cog_10==.
replace cog_10 = cog_11 if cog_10==.
