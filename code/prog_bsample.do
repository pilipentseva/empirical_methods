
use $results_sample/res_regs_1.dta, clear
gen max_it=400 if "$sample"=="full"
replace max_it=100 if max_it==.
local max = max_it

forvalues i =2/`max' {
append using $results_sample/res_regs_`i'.dta
}
drop max_it

ttest b1_minodummy_KKrho = b2_minodummy_KKrho

centile b1_minodummy_KKrho ,  centile(2.5 5 50 95 97.5)
centile b2_minodummy_KKrho ,  centile(2.5 5 50 95 97.5)

gen diff= b1_minodummy_KKrho-b2_minodummy_KKrho 
centile diff ,  centile(2.5 5 50 95 97.5)

gen ratio= b1_minodummy_KKrho/ b2_minodummy_KKrho
centile ratio ,  centile(2.5 5 50 95 97.5)



// Table 4 - Non linear Model of log-prices as a function of the number of reviews (full sample)
// Table 6 - Non linear Model of log-prices as a function of the number of reviews (subsamples)


replace b_rho=b_rho*100
replace se_rho=se_rho*100

foreach x in b_lastrat10_KKrho b_lastrat9_KKrho ///
b_lastrat8_KKrho  b_lastrat7_KKrho   ///
b1_minodummy_KKrho b_rho se_rho { 
replace `x'=round(`x',.01)
}

replace b1_minodummy_KKrh=b1_minodummy_KKrho*-1
replace b2_minodummy_KKrh=b2_minodummy_KKrho*-1

estpost sum b_lastrat10_KKrho se_lastrat10_KKrho b_lastrat9_KKrho se_lastrat9_KKrho ///
b_lastrat8_KKrho se_lastrat8_KKrho b_lastrat7_KKrho se_lastrat7_KKrho ///
b1_minodummy_KKrho se1_minodummy_KKrho b_rho se_rho
est store m1

estpost sum  b_KKrho se_KKrho ///
b2_minodummy_KKrho se2_minodummy_KKrho b_rho se_rho
est store m2

 esttab  m1 m2 using $results_sample/Table4_$sample.tex , replace noobs cells ("mean") style(tex) ///
 varlabels(b1_minodummy_KKrho "Minority \$ \times f(k)\$" b_lastrat10_KKrho "5 stars \$ \times f(k)\$" ///
 b_lastrat9_KKrho "4.5 stars \$ \times f(k)\$" b2_minodummy_KKrho "Minority \$ \times f(k)\$" ///
b_lastrat8_KKrho "4 stars \$ \times f(k)\$" b_lastrat7_KKrho  "\$\leq\$ 3.5 stars \$ \times f(k)\$" b_KKrho "\$f(k)\$" ///
se_lastrat10_KKrho "Std Err (5 stars \$ \times f(k)\$)" se_lastrat9_KKrho "Std Err (4.5 stars \$ \times f(k)\$)" ///
se_lastrat8_KKrho "Std Err (4 stars \$ \times f(k)\$)" se_lastrat7_KKrho "Std Err (3.5 stars \$ \times f(k)\$)" ///
se1_minodummy_KKrho "Std Err (Minority \$ \times f(k)\$)" se2_minodummy_KKrho "Std Err (Minority \$ \times f(k)\$)"  ///
b_rho "$\rho$" se_rho "Std Err ($\rho$)"   se_KKrho "Std Err (\$f(k)\$)")  ///
title(Structural model ($sample)) 
 

