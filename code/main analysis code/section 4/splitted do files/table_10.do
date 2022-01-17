*Table 10
use $data/base_airbnb_AEJ.dta, clear

keep if Drev100>0
  
gen KKrho = rev100/(.136+rev100)
gen lastrat10_KKrho=KKrho*lastrat10
gen lastrat9_KKrho=KKrho*lastrat9
gen lastrat8_KKrho=KKrho*lastrat8
gen lastrat7_KKrho=KKrho*lastrat7
gen minodummy_KKrho=minodummy*KKrho

global struc_step1 c.minodummy#ib10.wave $lesX i.citywaveID lastrat10_KKrho lastrat9_KKrho lastrat8_KKrho lastrat7_KKrho minodummy_KKrho 

sort newid wave
bys newid : gen rev100_t1=rev100[_n+1]
 
gen diff= rev100_t1-rev100
gen taux=diff/rev100

xtreg diff $struc_step1 , fe i(newid) robust cl(newid)
estimates store xtr1
xtreg taux $struc_step1 , fe i(newid) robust cl(newid)
estimates store xtr2

estout xtr1 xtr2 using $results/Table10.tex, cells(b(star fmt(%9.3f)) se(par fmt (%9.3f))) ///
keep(*Krho*) stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs.")) style(tex) ///
replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///
title(Ethnic differentials in the accumulation of reviews over time\label{tab.reviewaccumulation}) ///
varlabels(minodummy_KKrho "Minority \$ \times f(K)\$" ///
lastrat7 "3.5 stars" lastrat8 "4 stars" lastrat9 "4.5 stars" lastrat10 "5 stars" ///
lastrat7_KKrho "3.5 stars \$ \times f(K)\$" ///
lastrat8_KKrho "4 stars \$ \times f(K)\$" ///
lastrat9_KKrho "4.5 stars \$ \times f(K)\$" ///
lastrat10_KKrho "5 stars \$ \times f(K)\$") ///
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\midrule) ///
prefoot(\midrule) ///
postfoot("\bottomrule""\end{tabular}" "Notes: FE regression.""\end{center}" "\end{table}")	
		
