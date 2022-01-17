*Correlations and price estimation
use $data/base_airbnb_AEJ.dta, clear

duplicates drop newid, force
bys blockID : gen sum_minodummy_block=_N
bys blockID : egen mean_minodummy_block=mean(minodummy)

keep blockID mean_minodummy_block sum_minodummy_block
duplicates drop 

sum sum_minodummy_block,d
drop if  sum_minodummy_block<5
save $results/mean_minodummy_block.dta, replace


use $data/base_airbnb_AEJ.dta, clear
xtset newid wave

merge m:1 blockID using $results/mean_minodummy_block.dta
keep if _merge==3

quietly xtreg log_price i.citywaveID i.blockID $lesX minodummy, fe i(hoodcityID)

parmest, saving($results/res_reg.dta, replace)



use $results/res_reg.dta, clear
drop dof t p min95 max95
keep if regexm(parm,"block")
gen blockID=substr(parm,1,strpos(parm,".")-1)
destring blockID ,replace force
drop if blockID==.
save $results/res_reg.dta, replace

merge 1:1 blockID using $results/mean_minodummy_block.dta
keep if _merge==3
corr estimate mean_minodummy_block

reg estimate mean_minodummy_block

sum estimate mean_minodummy_block

	






