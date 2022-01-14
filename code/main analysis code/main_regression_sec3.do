

* Detailed rating for first and last
gen rating_det = guest_satisfaction_overall/100-1
sort newid wave

// Call functions
do $code/fun_structural_fe.do
do $code/nlstructfe.do

keep if Drev100>0

distinct newid
global distinct = r(ndistinct)


/*
MAX replications
400 for the full sample (table 4)
100 for the subsamples (table 6)
*/
display "$sample"
gen max_it=400 if "$sample"=="full"
replace max_it=100 if max_it==.
local max = max_it

local e_sample=1
while `e_sample'<=`max' {

preserve
bsample $distinct, cluster(newid)
global e_sample `e_sample'
fun_structural_fe

local e_sample =`e_sample'+1

restore
 }


*append bootstrapped samples
do $code/prog_bsample.do



