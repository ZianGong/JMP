/* construct optimism indicator */ 

egen opt = rowmean(LB019G LB019H LB019I)
egen pes = rowmean(LB019F LB019J LB019K)
gen opt_index = log(opt) - log(pes)
summ opt_index
replace opt_index = opt_index /  (r(max) - r(min))

gen opt_index2 = opt-pes
summ opt_index2
replace opt_index2 = opt_index2 /  (r(max) - r(min))

drop LB* opt pes 
