*Table 7
use $data/base_airbnb_AEJ.dta, clear
keep if Drev100>0

*creation dummy variables (citywave & hoodcity)
xi i.citywaveID i.hoodcityID, noomit

 foreach x in nber_names nber_black_names nber_arabic_african_names nber_mino_names {
egen `x'_total = total(`x'), by(newid) 
}
 
*Calcul Probas*
gen  proba_black=  nber_black_names_total/nber_names_total
gen  proba_arabic_african=  nber_arabic_african_names_total/nber_names_total
gen  proba_mino=  nber_mino_names_total/nber_names_total

*Proba par NEWID
preserve
keep if wave==maxwave

quietly{

areg proba_arabic_african log_price  _IcitywaveI_* _IhoodcityI_*  $lesX ///
 c.lastrat0 c.lastrat7 c.lastrat8 c.lastrat9 c.rev100 arabic_african ///
 nber_names_total, robust cl(blockID) absorb(blockID)
estimates store m1

}

estout  m1  using $results/Table7.tex, cells(b(star fmt(%9.4f)) se(par fmt (%9.4f))) ///
 keep(arabic_african) stats(r2_a N, fmt(%9.3f %9.0g) labels("Adj R2" "N obs."))  ///
    varlabels(arabic_african "Arabic/Muslim Host" ) ///
  title(Ethnic matching between Arabic/Muslim hosts and Arabic/Muslim guests\label{tab.matching}) ///
   style(tex) replace starlevels(* 0.1 ** 0.05 *** 0.01 ) ///  
mlabels(, span prefix(\multicolumn{@span}{c}{) suffix(}))  ///
prehead("\begin{table}\caption{@title}" "\begin{center}""\begin{tabular}{l*{@M}{cc}}""\toprule") ///
posthead(\hline) ///
prefoot(\hline) ///
postfoot("\hline""\end{tabular}" "Notes: OLS regression with listings fixed-effects.""\end{center}" "\end{table}")

restore
